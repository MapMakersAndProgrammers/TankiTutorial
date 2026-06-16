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
      
      public static var her:Game;
      
      private var stage:Stage = GameData.stage;
      
      private var butefu:GameCamera = GameData.butefu;
      
      private var root:Object3DContainer = GameData.root;
      
      private var namab:TaskGroup = GameData.namab;
      
      private var suvubufi:TimeData = GameData.lecopojen;
      
      private var gov:TanksPhysicsScene = GameData.gov;
      
      private var cyc:Vector.<Tutorial>;
      
      private var qumebake:Tutorial;
      
      private var tudejy:int;
      
      private var nivekyh:int;
      
      private var gujamiq:DependenciesLoader;
      
      private var myzumywi:CameraController;
      
      private var motorafo:CameraController;
      
      private var gido:Dust;
      
      private var hyqirufy:Vector3;
      
      private var vetawifac:Quaternion;
      
      private var qap:uint;
      
      private var newizyqy:uint;
      
      private var podinipo:uint;
      
      private var pylyzom:String;
      
      public function Game()
      {
         super();
         her = this;
         this.setupDust();
         this.stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.stage.addEventListener(Event.RESIZE,this.onResize);
      }
      
      public static function isFinished() : Boolean
      {
         return her.tudejy >= her.cyc.length;
      }
      
      private function setupDust() : void
      {
         this.gido = new Dust(this.butefu);
         var _loc1_:BitmapData = Assets.getData("dust",BitmapData);
         var _loc2_:TextureAnimation = new TextureAnimation(new TextureMaterial(_loc1_),GraphicsUtils.getUVFramesFromTexture(_loc1_,32,32,17),30);
         this.gido.init(_loc2_,9000,7000,200,0.75,0.1);
         this.gido.enabled = false;
         GameData.gido = this.gido;
      }
      
      public function start() : void
      {
         var _loc1_:ConfigLoader = new ConfigLoader();
         _loc1_.load("config.xml",this.onConfigLoaded);
      }
      
      private function onConfigLoaded(param1:ConfigLoader) : void
      {
         var _loc2_:XML = null;
         Assets.config = param1.wytyqinyj;
         Assets.scripts = param1.dijipyhiv;
         this.cyc = new Vector.<Tutorial>();
         for each(_loc2_ in param1.dijipyhiv.script)
         {
            this.cyc.push(new ScriptedTutorial(_loc2_));
         }
         this.gujamiq = new DependenciesLoader();
         this.tudejy = 0;
         this.nivekyh = 0;
         this.loadDependencies();
         this.namab.addTask(new TankRolloverCheckerTask());
      }
      
      private function loadDependencies() : void
      {
         this.qap = getTimer();
         if(this.nivekyh == 0)
         {
            Shared.preloader.reset("LoadHangar");
         }
         else
         {
            Shared.preloader.reset();
         }
         var _loc1_:Tutorial = this.cyc[this.nivekyh];
         this.gujamiq.load(_loc1_.getDependencies(),this.onTutorialReady);
      }
      
      private function onTutorialReady() : void
      {
         var _loc1_:Tutorial = this.cyc[this.nivekyh];
         _loc1_.feseju = true;
         if(this.nivekyh == 0)
         {
            Shared.preloader.complete();
         }
         ++this.nivekyh;
         if(this.qumebake == null)
         {
            this.qumebake = this.cyc[this.tudejy];
            this.qumebake.start();
            this.newizyqy = getTimer();
            Shared.preloader.hideLoaderWindow();
            GameData.ciqoby.startLoad();
         }
         if(this.nivekyh < this.cyc.length)
         {
            this.loadDependencies();
         }
      }
      
      private function onEnterFrame(param1:Event = null) : void
      {
         var _loc3_:Tank = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this.suvubufi.calculate();
         if(Boolean(Shared.renderEnabled) && this.qumebake != null)
         {
            this.updateCurrentTutorial();
         }
         var _loc2_:Vector.<Tank> = GameData.gaz;
         for each(_loc3_ in _loc2_)
         {
            _loc3_.addToGame();
         }
         _loc2_.length = 0;
         this.namab.process();
         _loc4_ = this.suvubufi.lecopojen;
         _loc5_ = this.suvubufi.rud;
         this.updatePhysics(_loc4_);
         this.butefu.startTimer();
         this.butefu.calculateAdditionalData();
         this.butefu.controller.update(_loc4_,_loc5_);
         GameData.bijatil.updateSoundEffects(_loc5_,this.butefu);
         this.gido.update();
         GameData.jypadif.render(_loc4_,_loc5_);
         GameData.hobuna.update(_loc5_,this.butefu);
         this.butefu.render();
         this.butefu.stopTimer();
      }
      
      private function updateCurrentTutorial() : void
      {
         var _loc2_:Tutorial = null;
         var _loc1_:uint = (this.suvubufi.lecopojen - this.newizyqy) / 1000;
         if(this.qumebake.stepFinished)
         {
            if(this.pylyzom != Shared.currentStep)
            {
               this.newizyqy = this.suvubufi.lecopojen;
               this.pylyzom = Shared.currentStep;
               Shared.tracker.trackEvent(Shared.TUTORIAL,Shared.currentStep + "_total_time",_loc1_.toString());
            }
            this.qumebake.moveToNextStep();
         }
         else if(_loc1_ % 5 == 0 && _loc1_ > 0 && _loc1_ != this.podinipo)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL,Shared.currentStep + "_hang_time",_loc1_.toString());
            this.podinipo = _loc1_;
         }
         if(this.qumebake.finished)
         {
            ++this.tudejy;
            this.qumebake = null;
            if(this.tudejy < this.cyc.length)
            {
               _loc2_ = this.cyc[this.tudejy];
               if(_loc2_.feseju)
               {
                  this.qumebake = _loc2_;
                  this.qumebake.start();
                  Shared.preloader.hideLoaderWindow();
               }
               else
               {
                  Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,"preloader_show",_loc2_.gepocivaj);
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
         GameData.qemikoq.enabled = false;
         GameData.butefu.controller = DummyCameraController.degakeh;
         GameData.jifom.turretController.lock(1);
         GameData.jifom.turretController.finish();
         GameData.jifom.kakow.hide();
         GameData.jifom.kat = false;
         GameData.jifom.lysecof.setSilentMode();
         if(Assets.hasData("finish",MovieClip))
         {
            GameData.hulaf.showMovie(Assets.getData("finish",MovieClip),StageAlign.TOP_LEFT);
         }
         else
         {
            GameData.hulaf.showMovie(new FinishClip(),StageAlign.TOP_LEFT);
         }
         if(Shared.hideSkipButton != null)
         {
            Shared.hideSkipButton();
         }
      }
      
      private function updatePhysics(param1:int) : void
      {
         var _loc2_:int = 33;
         while(this.gov.lecopojen < param1)
         {
            this.gov.update(_loc2_);
         }
         var _loc3_:Number = 1 - (this.gov.lecopojen - param1) / _loc2_;
         this.gov.runPhysicsInterpolators(_loc3_);
      }
      
      public function onResize(param1:Event = null) : void
      {
         this.butefu.view.width = this.stage.stageWidth;
         this.butefu.view.height = this.stage.stageHeight;
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
         var _loc5_:Number = Number(this.butefu.view.width);
         var _loc6_:Number = Number(this.butefu.view.height);
         var _loc7_:Number = _loc6_ / _loc3_;
         var _loc8_:Number = _loc5_ / _loc7_;
         if(_loc8_ <= _loc1_)
         {
            this.butefu.fov = _loc4_;
         }
         else
         {
            _loc9_ = _loc8_ - (_loc2_ - _loc1_);
            if(_loc9_ < _loc1_)
            {
               _loc9_ = _loc1_;
            }
            _loc10_ = _loc9_ * _loc7_;
            _loc11_ = Math.sqrt(_loc10_ * _loc10_ + _loc6_ * _loc6_) * 0.5 / Math.tan(_loc4_ * 0.5);
            this.butefu.fov = Math.atan(Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_) * 0.5 / _loc11_) * 2;
         }
      }
      
      private function setupDebugActions() : void
      {
         this.stage.doubleClickEnabled = true;
         this.stage.addEventListener(MouseEvent.DOUBLE_CLICK,this.traceWaypoint);
         this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onDebugActionKey);
      }
      
      private function traceWaypoint(param1:MouseEvent) : void
      {
      }
      
      private function onDebugActionKey(param1:KeyboardEvent) : void
      {
      }
      
      private function startStopRecording() : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:Tank = GameData.jifom;
         var _loc2_:RecordTankController = GameData.qemikoq;
         if(_loc2_.isRecording())
         {
            _loc3_ = _loc2_.getRecord();
            _loc4_ = "<enemy hull=\"" + _loc1_.nariw.gepocivaj + "\" turret=\"" + _loc1_.firaqe.gepocivaj + "\" color=\"red\" position=\"" + this.hyqirufy.x.toFixed(0) + " " + this.hyqirufy.y.toFixed(0) + " " + this.hyqirufy.z.toFixed(0) + "\" orientation=\"" + this.vetawifac.dige.toFixed(4) + " " + this.vetawifac.x.toFixed(4) + " " + this.vetawifac.y.toFixed(4) + " " + this.vetawifac.z.toFixed(6) + "\" data=\"" + _loc3_ + "\">\n</enemy>";
            _loc2_.stopRecording();
            this.setText(_loc4_);
         }
         else
         {
            Shared.clientLog.addLine("start recording");
            this.hyqirufy = _loc1_.body.kejo.position.clone();
            this.vetawifac = _loc1_.body.kejo.bej.clone();
            _loc2_.startRecording();
         }
      }
      
      private function traceSpawnPoint() : void
      {
         var _loc1_:Tank = GameData.jifom;
         if(_loc1_.inGame)
         {
            this.hyqirufy = _loc1_.body.kejo.position.clone();
            this.vetawifac = _loc1_.body.kejo.bej.clone();
            this.setText("<player.spawn hull=\"" + _loc1_.nariw.gepocivaj + "\" turret=\"" + _loc1_.firaqe.gepocivaj + "\" color=\"green\" position=\"" + this.hyqirufy.x.toFixed(4) + " " + this.hyqirufy.y.toFixed(4) + " " + this.hyqirufy.z.toFixed(4) + "\" orientation=\"" + this.vetawifac.dige.toFixed(4) + " " + this.vetawifac.x.toFixed(4) + " " + this.vetawifac.y.toFixed(4) + " " + this.vetawifac.z.toFixed(4) + "\"/>");
         }
      }
      
      private function switchCameraController() : void
      {
         if(this.myzumywi == null)
         {
            this.myzumywi = new SpectatorCameraController(this.stage,this.butefu);
         }
         if(this.butefu.controller != null)
         {
            this.butefu.controller.deactivate();
         }
         if(this.butefu.controller == this.myzumywi)
         {
            this.butefu.controller = this.motorafo;
         }
         else
         {
            this.motorafo = this.butefu.controller;
            this.butefu.controller = this.myzumywi;
         }
         if(this.butefu.controller != null)
         {
            this.butefu.controller.activate();
         }
      }
      
      private function togglePhysicsVisualization() : void
      {
         var _loc1_:KDContainer = GameData.guzinizub;
         if(_loc1_.visible)
         {
            _loc1_.visible = false;
            this.root.addChild(this.gov.physicsVisualization);
         }
         else
         {
            _loc1_.visible = true;
            this.root.removeChild(this.gov.physicsVisualization);
         }
      }
      
      private function setText(param1:String) : void
      {
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,param1);
         Shared.clientLog.addLine(param1);
      }
   }
}

