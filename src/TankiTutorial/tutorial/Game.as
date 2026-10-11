package tutorial
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.physics.TanksPhysicsScene;
   import alternativa.tanks.battle.Dust;
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.shared.camera.CameraController;
   import alternativa.tanks.shared.camera.DummyCameraController;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.GraphicsUtils;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.controllers.RecordTankController;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import movieclips.FinishClip;
   import tutorial.commons.Assets;
   import tutorial.commons.Shared;
   import tutorial.loader.ConfigLoader;
   import tutorial.script.ScriptedTutorial;
   import tutorial.tasks.TankRolloverCheckerTask;
   import tutorial.tasks.TaskGroup;
   
   public class Game
   {
      
      public static var instance:Game;
      
      private var stage:Stage = GameData.stage;
      
      private var camera:GameCamera = GameData.camera;
      
      private var root:Object3DContainer = GameData.root;
      
      private var taskGroup:TaskGroup = GameData.taskGroup;
      
      private var timeData:TimeData = GameData.time;
      
      private var physicsScene:TanksPhysicsScene = GameData.physicsScene;
      
      private var tutorials:Vector.<Tutorial>;
      
      private var currentTutorial:Tutorial;
      
      private var tutorialIndex:int;
      
      private var loadIndex:int;
      
      private var dependenciesLoader:DependenciesLoader;
      
      private var spectatorController:CameraController;
      
      private var previousController:CameraController;
      
      private var dust:Dust;
      
      private var position:Vector3;
      
      private var orientation:Quaternion;
      
      private var loadStartTime:uint;
      
      private var stepStartTime:uint;
      
      private var lastHangTime:uint;
      
      private var lastStep:String;
      
      public function Game()
      {
         super();
         instance = this;
         this.setupDust();
         this.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.stage.addEventListener(Event.RESIZE,this.onResize);
      }
      
      public static function isFinished() : Boolean
      {
         return instance.tutorialIndex >= instance.tutorials.length;
      }
      
      private function setupDust() : void
      {
         this.dust = new Dust(this.camera);
         var bitmapData:BitmapData = Assets.getData("dust",BitmapData);
         var animation:TextureAnimation = new TextureAnimation(new TextureMaterial(bitmapData),GraphicsUtils.getUVFramesFromTexture(bitmapData,32,32,17),30);
         this.dust.init(animation,9000,7000,200,0.75,0.1);
         this.dust.enabled = false;
         GameData.dust = this.dust;
      }
      
      public function start() : void
      {
         var configLoader:ConfigLoader = new ConfigLoader();
         configLoader.load("config.xml",this.onConfigLoaded);
      }
      
      private function onConfigLoaded(configLoader:ConfigLoader) : void
      {
         var scriptXML:XML = null;
         Assets.config = configLoader.config;
         Assets.scripts = configLoader.scripts;
         this.tutorials = new Vector.<Tutorial>();
         for each(scriptXML in configLoader.scripts.script)
         {
            this.tutorials.push(new ScriptedTutorial(scriptXML));
         }
         this.dependenciesLoader = new DependenciesLoader();
         this.tutorialIndex = 0;
         this.loadIndex = 0;
         this.loadDependencies();
         this.taskGroup.addTask(new TankRolloverCheckerTask());
      }
      
      private function loadDependencies() : void
      {
         this.loadStartTime = getTimer();
         if(this.loadIndex == 0)
         {
            Shared.preloader.reset("LoadHangar");
         }
         else
         {
            Shared.preloader.reset();
         }
         var t:Tutorial = this.tutorials[this.loadIndex];
         this.dependenciesLoader.load(t.getDependencies(),this.onTutorialReady);
      }
      
      private function onTutorialReady() : void
      {
         var t:Tutorial = this.tutorials[this.loadIndex];
         t.loaded = true;
         if(this.loadIndex == 0)
         {
            Shared.preloader.complete();
         }
         ++this.loadIndex;
         if(this.currentTutorial == null)
         {
            this.currentTutorial = this.tutorials[this.tutorialIndex];
            this.currentTutorial.start();
            this.stepStartTime = getTimer();
            Shared.preloader.hideLoaderWindow();
            GameData.texturesLoader.startLoad();
         }
         if(this.loadIndex < this.tutorials.length)
         {
            this.loadDependencies();
         }
      }
      
      private function onEnterFrame(e:Event = null) : void
      {
         var tank:Tank = null;
         var time:uint = 0;
         var deltaTime:uint = 0;
         this.timeData.calculate();
         if(Boolean(Shared.renderEnabled) && this.currentTutorial != null)
         {
            this.updateCurrentTutorial();
         }
         var tanks:Vector.<Tank> = GameData.tanks;
         for each(tank in tanks)
         {
            tank.addToGame();
         }
         tanks.length = 0;
         this.taskGroup.process();
         time = this.timeData.time;
         deltaTime = this.timeData.deltaTimeMs;
         this.updatePhysics(time);
         this.camera.startTimer();
         this.camera.calculateAdditionalData();
         this.camera.controller.update(time,deltaTime);
         GameData.soundManager.updateSoundEffects(deltaTime,this.camera);
         this.dust.update();
         GameData.renderers.render(time,deltaTime);
         GameData.effects.update(deltaTime,this.camera);
         this.camera.render();
         this.camera.stopTimer();
      }
      
      private function updateCurrentTutorial() : void
      {
         var t:Tutorial = null;
         var seconds:uint = (this.timeData.time - this.stepStartTime) / 1000;
         if(this.currentTutorial.stepFinished)
         {
            if(this.lastStep != Shared.currentStep)
            {
               this.stepStartTime = this.timeData.time;
               this.lastStep = Shared.currentStep;
               Shared.tracker.trackEvent(Shared.TUTORIAL,Shared.currentStep + "_total_time",seconds.toString());
            }
            this.currentTutorial.moveToNextStep();
         }
         else if(seconds % 5 == 0 && seconds > 0 && seconds != this.lastHangTime)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL,Shared.currentStep + "_hang_time",seconds.toString());
            this.lastHangTime = seconds;
         }
         if(this.currentTutorial.finished)
         {
            ++this.tutorialIndex;
            this.currentTutorial = null;
            if(this.tutorialIndex < this.tutorials.length)
            {
               t = this.tutorials[this.tutorialIndex];
               if(t.loaded)
               {
                  this.currentTutorial = t;
                  this.currentTutorial.start();
                  Shared.preloader.hideLoaderWindow();
               }
               else
               {
                  Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,"preloader_show",t.name);
                  Shared.preloader.showLoaderWindow();
               }
            }
            else
            {
               this.finishGame();
            }
         }
      }
      
      private function finishGame() : void
      {
         Shared.tracker.trackEvent(Shared.TUTORIAL,Shared.TUTORIAL + ":finish","");
         GameData.recordTankController.enabled = false;
         GameData.camera.controller = DummyCameraController.degakeh;
         GameData.playerTank.turretController.lock(1);
         GameData.playerTank.turretController.finish();
         GameData.playerTank.kakow.hide();
         GameData.playerTank.kat = false;
         GameData.playerTank.lysecof.setSilentMode();
         if(Assets.hasData("finish",MovieClip))
         {
            GameData.screenMovieClipManager.showMovie(Assets.getData("finish",MovieClip),StageAlign.TOP_LEFT);
         }
         else
         {
            GameData.screenMovieClipManager.showMovie(new FinishClip(),StageAlign.TOP_LEFT);
         }
         if(Shared.hideSkipButton != null)
         {
            Shared.hideSkipButton();
         }
      }
      
      private function updatePhysics(time:int) : void
      {
         var step:int = 33;
         while(this.physicsScene.time < time)
         {
            this.physicsScene.update(step);
         }
         var t:Number = 1 - (this.physicsScene.time - time) / step;
         this.physicsScene.runPhysicsInterpolators(t);
      }
      
      public function onResize(e:Event = null) : void
      {
         this.camera.view.width = this.stage.stageWidth;
         this.camera.view.height = this.stage.stageHeight;
         this.correctCameraFOV();
      }
      
      private function correctCameraFOV() : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc1_:Number = 12;
         var _loc2_:Number = 16;
         var _loc3_:Number = 9;
         var _loc4_:Number = Math.PI / 2;
         var width:Number = Number(this.camera.view.width);
         var height:Number = Number(this.camera.view.height);
         var _loc7_:Number = height / _loc3_;
         var _loc8_:Number = width / _loc7_;
         if(_loc8_ <= _loc1_)
         {
            this.camera.fov = _loc4_;
         }
         else
         {
            _loc9_ = _loc8_ - (_loc2_ - _loc1_);
            if(_loc9_ < _loc1_)
            {
               _loc9_ = _loc1_;
            }
            _loc10_ = _loc9_ * _loc7_;
            _loc11_ = Math.sqrt(_loc10_ * _loc10_ + height * height) * 0.5 / Math.tan(_loc4_ * 0.5);
            this.camera.fov = Math.atan(Math.sqrt(width * width + height * height) * 0.5 / _loc11_) * 2;
         }
      }
      
      private function setupDebugActions() : void
      {
         this.stage.doubleClickEnabled = true;
         this.stage.addEventListener(MouseEvent.DOUBLE_CLICK,this.traceWaypoint);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onDebugActionKey);
      }
      
      private function traceWaypoint(mouseEvent:MouseEvent) : void
      {
      }
      
      private function onDebugActionKey(keyboardEvent:KeyboardEvent) : void
      {
      }
      
      private function startStopRecording() : void
      {
         var record:String = null;
         var text:String = null;
         var tank:Tank = GameData.playerTank;
         var controller:RecordTankController = GameData.recordTankController;
         if(controller.isRecording())
         {
            record = controller.getRecord();
            text = "<enemy hull=\"" + tank.nariw.name + "\" turret=\"" + tank.firaqe.name + "\" color=\"red\" position=\"" + this.position.x.toFixed(0) + " " + this.position.y.toFixed(0) + " " + this.position.z.toFixed(0) + "\" orientation=\"" + this.orientation.w.toFixed(4) + " " + this.orientation.x.toFixed(4) + " " + this.orientation.y.toFixed(4) + " " + this.orientation.z.toFixed(6) + "\" data=\"" + record + "\">\n</enemy>";
            controller.stopRecording();
            this.setText(text);
         }
         else
         {
            Shared.clientLog.addLine("start recording");
            this.position = tank.body.state.position.clone();
            this.orientation = tank.body.state.orientation.clone();
            controller.startRecording();
         }
      }
      
      private function traceSpawnPoint() : void
      {
         var tank:Tank = GameData.playerTank;
         if(tank.inGame)
         {
            this.position = tank.body.state.position.clone();
            this.orientation = tank.body.state.orientation.clone();
            this.setText("<player.spawn hull=\"" + tank.nariw.name + "\" turret=\"" + tank.firaqe.name + "\" color=\"green\" position=\"" + this.position.x.toFixed(4) + " " + this.position.y.toFixed(4) + " " + this.position.z.toFixed(4) + "\" orientation=\"" + this.orientation.w.toFixed(4) + " " + this.orientation.x.toFixed(4) + " " + this.orientation.y.toFixed(4) + " " + this.orientation.z.toFixed(4) + "\"/>");
         }
      }
      
      private function switchCameraController() : void
      {
         if(this.spectatorController == null)
         {
            this.spectatorController = new SpectatorCameraController(this.stage,this.camera);
         }
         if(this.camera.controller != null)
         {
            this.camera.controller.deactivate();
         }
         if(this.camera.controller == this.spectatorController)
         {
            this.camera.controller = this.previousController;
         }
         else
         {
            this.previousController = this.camera.controller;
            this.camera.controller = this.spectatorController;
         }
         if(this.camera.controller != null)
         {
            this.camera.controller.activate();
         }
      }
      
      private function togglePhysicsVisualization() : void
      {
         var kdContainer:KDContainer = GameData.kdContainer;
         if(kdContainer.visible)
         {
            kdContainer.visible = false;
            this.root.addChild(this.physicsScene.physicsVisualization);
         }
         else
         {
            kdContainer.visible = true;
            this.root.removeChild(this.physicsScene.physicsVisualization);
         }
      }
      
      private function setText(text:String) : void
      {
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,text);
         Shared.clientLog.addLine(text);
      }
   }
}

