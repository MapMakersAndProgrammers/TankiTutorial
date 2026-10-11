package tutorial
{
   import alternativa.Alternativa3D;
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.ShadowMap;
   import alternativa.engine3d.core.View;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.math.Vector3;
   import alternativa.physics.TanksPhysicsScene;
   import alternativa.tanks.RenderGroup;
   import alternativa.tanks.battle.BattleRunner;
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.BattleService;
   import alternativa.tanks.battle.Dust;
   import alternativa.tanks.shared.camera.CameraController;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.shared.physics.TanksCollisionDetector;
   import alternativa.tanks.sound.ISoundManager;
   import alternativa.tanks.sound.SoundManager;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.controllers.RecordTankController;
   import alternativa.tanks.vehicles.tank.controllers.TurretControlKeyMap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import tutorial.commons.Lang;
   import tutorial.commons.LoaderWindow;
   import tutorial.commons.Shared;
   import tutorial.commons.TrackerService;
   import tutorial.loader.TexturesLoader;
   import tutorial.tasks.TaskGroup;
   
   public class GameData
   {
      
      public static var root:Object3DContainer;
      
      public static var camera:GameCamera;
      
      public static var kdContainer:KDContainer;
      
      public static var playerTank:Tank;
      
      public static var stage:Stage;
      
      public static var soundManager:ISoundManager;
      
      public static var taskGroup:TaskGroup;
      
      public static var physicsScene:TanksPhysicsScene;
      
      public static var collisionDetector:TanksCollisionDetector;
      
      public static var screenBitmapManager:ScreenBitmapManager;
      
      public static var screenMovieClipManager:ScreenMovieClipManager;
      
      public static var crystalIndicatorManager:CrystalIndicatorManager;
      
      public static var recordTankController:RecordTankController;
      
      public static var container:DisplayObjectContainer;
      
      public static var dust:Dust;
      
      private static var colorTransform:ColorTransform;
      
      public static var battleService:BattleService;
      
      public static var battleRunner:BattleRunner;
      
      public static var battleScene:BattleScene3D;
      
      public static var markingManager:MarkingManager;
      
      private static var spectatorController:CameraController;
      
      private static var previousController:CameraController;
      
      public static var jygukik:String = "RU";
      
      public static const time:TimeData = new TimeData();
      
      public static const scene:GameScene = new GameScene();
      
      public static const objectPool:ObjectPool = new ObjectPool();
      
      public static const renderers:RenderGroup = new RenderGroup();
      
      public static const effects:EffectsManager = new EffectsManager();
      
      public static const texturesLoader:TexturesLoader = new TexturesLoader();
      
      public static const tanks:Vector.<Tank> = new Vector.<Tank>();
      
      public static const backgroundSprite:BackgroundSprite = new BackgroundSprite();
      
      public static const angle:Number = 70 * Math.PI / 180;
      
      public static const threshold:Number = 0.1;
      
      public static const direction:Vector3D = new Vector3D(-0.6,-0.5,-1);
      
      public static const version:int = Alternativa3D.version.split(".")[1];
      
      public static var bonusRegions:Vector.<Vector3> = new Vector.<Vector3>();
      
      public static const bisoga:Boolean = true;
      
      public static var mouseEnabled:Boolean = false;
      
      public static var kumiteva:Boolean = false;
      
      public static var qazul:Boolean = false;
      
      public function GameData()
      {
         super();
      }
      
      public static function createGameData(stage:Stage, container:DisplayObjectContainer) : void
      {
         var lightDirection:Vector3D = null;
         GameData.stage = stage;
         GameData.container = container;
         if(Shared.tracker == null)
         {
            Shared.tracker = new TrackerService(true);
            Shared.preloader = new LoaderWindow(stage);
         }
         root = new Object3DContainer();
         camera = new GameCamera();
         camera.matrix = new Matrix3D(Vector.<Number>([-0.8589262962341309,-0.5120992064476013,0,0,-0.056438345462083817,0.09466209262609482,-0.9939083456993103,0,0.5089796781539917,-0.8536940217018127,-0.11020979285240173,0,1734.8155517578125,-4618.1220703125,121.45249938964844,1]));
         camera.nearClipping = 100;
         camera.farClipping = 40000;
         camera.view = new View(stage.stageWidth,stage.stageHeight,Shared.constrained);
         camera.view.hideLogo();
         camera.view.antiAliasEnabled = false;
         camera.addToDebug(Debug.EDGES,Object3D);
         camera.addToDebug(Debug.LIGHTS,Object3D);
         camera.timerUpdatePeriod = 30;
         camera.softTransparency = false;
         root.addChild(camera);
         stage.addChildAt(camera.view,0);
         kdContainer = new KDContainer();
         kdContainer.ignoreChildrenInCollider = true;
         root.addChild(kdContainer);
         soundManager = new SoundManager();
         taskGroup = new TaskGroup();
         physicsScene = new TanksPhysicsScene();
         physicsScene.gyge = 5;
         var gravity:Vector3 = physicsScene.tem;
         gravity.reset(0,0,-1000);
         physicsScene.time = getTimer();
         collisionDetector = physicsScene.secakesem;
         TurretControlKeyMap.initDefaultKeyMap(Lang.language);
         playerTank = new Tank();
         recordTankController = new RecordTankController(stage,playerTank);
         screenBitmapManager = new ScreenBitmapManager(stage);
         screenMovieClipManager = new ScreenMovieClipManager(stage,container);
         crystalIndicatorManager = new CrystalIndicatorManager(stage);
         var _loc4_:int = 150;
         var _loc5_:int = 150;
         var _loc6_:int = 127;
         var _loc7_:int = 40;
         var _loc8_:int = 50;
         var _loc9_:int = 70;
         var _loc10_:int = 13090219;
         var _loc11_:int = 5530735;
         _loc4_ = _loc10_ >> 16 & 0xFF;
         _loc5_ = _loc10_ >> 8 & 0xFF;
         _loc6_ = _loc10_ & 0xFF;
         _loc7_ = _loc11_ >> 16 & 0xFF;
         _loc8_ = _loc11_ >> 8 & 0xFF;
         _loc9_ = _loc11_ & 0xFF;
         var lightColor:int = color(_loc4_ - _loc7_,_loc5_ - _loc8_,_loc6_ - _loc9_);
         var ambientColor:int = color(_loc7_,_loc8_,_loc9_);
         if(Boolean(Shared.gpu) && version >= 11 && !Shared.constrained && (Shared.navigator != "Chrome" || int(Shared.navigatorVersion.split(".")[0]) > 23))
         {
            camera.fogNear = 0;
            camera.fogFar = 10000;
            camera.fogAlpha = 0;
            camera.directionalLight = new DirectionalLight(lightColor);
            camera.directionalLight.lookAt(direction.x,direction.y,direction.z);
            camera.ambientColor = ambientColor;
            camera.shadowMap = new ShadowMap(2048,5000,8000,0.5,4000);
            camera.deferredLighting = false;
            camera.softTransparency = false;
            camera.ssao = false;
            camera.ssaoRadius = 400;
            camera.ssaoRange = 1200;
            camera.ssaoColor = 2636880;
            camera.ssaoAlpha = 1.4;
         }
         else
         {
            lightDirection = direction.clone();
            lightDirection.normalize();
            colorTransform = calculateColorTransform(ambientColor,lightColor,Math.abs(lightDirection.z));
         }
         battleService = new BattleServiceImpl();
         battleRunner = new BattleRunnerImpl();
         battleScene = new BattleScene3DImpl();
         mouseEnabled = !BrowserBlackList.checkIfMouseDisabled();
      }
      
      public static function initMarking() : void
      {
         if(markingManager == null)
         {
            markingManager = new MarkingManager(stage,camera,kdContainer,playerTank,false);
         }
      }
      
      public static function colorize(bitmapData:BitmapData) : void
      {
         if(colorTransform != null && bitmapData != null)
         {
            bitmapData.colorTransform(bitmapData.rect,colorTransform);
         }
      }
      
      private static function onKey(keyboardEvent:KeyboardEvent) : void
      {
         switch(keyboardEvent.keyCode)
         {
            case Keyboard.NUMPAD_4:
               direction.x -= 0.1;
               break;
            case Keyboard.NUMPAD_6:
               direction.x += 0.1;
               break;
            case Keyboard.NUMPAD_2:
               direction.y -= 0.1;
               break;
            case Keyboard.NUMPAD_8:
               direction.y += 0.1;
               break;
            case Keyboard.TAB:
               camera.debug = !camera.debug;
               break;
            case Keyboard.F2:
               if(spectatorController == null)
               {
                  spectatorController = new SpectatorCameraController(stage,camera);
               }
               if(camera.controller != null)
               {
                  camera.controller.deactivate();
               }
               if(camera.controller == spectatorController)
               {
                  camera.controller = previousController;
               }
               else
               {
                  previousController = camera.controller;
                  camera.controller = spectatorController;
               }
               if(camera.controller != null)
               {
                  camera.controller.activate();
               }
         }
      }
      
      private static function color(r:uint, g:uint, b:uint) : int
      {
         if(r > 255)
         {
            r = 255;
         }
         if(g > 255)
         {
            g = 255;
         }
         if(b > 255)
         {
            b = 255;
         }
         return r << 16 | g << 8 | b;
      }
      
      private static function calculateColorTransform(ambientColor:uint, lightColor:uint, factor:Number = 1) : ColorTransform
      {
         var _loc4_:Number = (ambientColor >> 16 & 0xFF) / 255;
         var _loc5_:Number = (ambientColor >> 8 & 0xFF) / 255;
         var _loc6_:Number = (ambientColor & 0xFF) / 255;
         var _loc7_:Number = (lightColor >> 16 & 0xFF) / 255;
         var _loc8_:Number = (lightColor >> 8 & 0xFF) / 255;
         var _loc9_:Number = (lightColor & 0xFF) / 255;
         var result:ColorTransform = new ColorTransform();
         result.redMultiplier = (_loc4_ + _loc7_ * factor) * 2;
         result.greenMultiplier = (_loc5_ + _loc8_ * factor) * 2;
         result.blueMultiplier = (_loc6_ + _loc9_ * factor) * 2;
         return result;
      }
   }
}

