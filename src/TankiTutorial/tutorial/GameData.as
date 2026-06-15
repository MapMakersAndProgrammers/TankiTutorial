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
   import alternativa.tanks.shared.physics.mebiw;
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
      
      public static var butefu:GameCamera;
      
      public static var guzinizub:KDContainer;
      
      public static var jifom:Tank;
      
      public static var stage:Stage;
      
      public static var bijatil:ISoundManager;
      
      public static var namab:TaskGroup;
      
      public static var gov:TanksPhysicsScene;
      
      public static var kymaqos:mebiw;
      
      public static var dazupuzif:ScreenBitmapManager;
      
      public static var hulaf:ScreenMovieClipManager;
      
      public static var maji:CrystalIndicatorManager;
      
      public static var qemikoq:RecordTankController;
      
      public static var danewazam:DisplayObjectContainer;
      
      public static var gido:Dust;
      
      private static var fur:ColorTransform;
      
      public static var mij:BattleService;
      
      public static var zepymy:BattleRunner;
      
      public static var hyfecypi:BattleScene3D;
      
      public static var jyqoqogy:MarkingManager;
      
      private static var myzumywi:CameraController;
      
      private static var motorafo:CameraController;
      
      public static var jygukik:String = "RU";
      
      public static const lecopojen:TimeData = new TimeData();
      
      public static const tuce:GameScene = new GameScene();
      
      public static const murow:ObjectPool = new ObjectPool();
      
      public static const jypadif:RenderGroup = new RenderGroup();
      
      public static const hobuna:EffectsManager = new EffectsManager();
      
      public static const ciqoby:TexturesLoader = new TexturesLoader();
      
      public static const gaz:Vector.<Tank> = new Vector.<Tank>();
      
      public static const varezula:BackgroundSprite = new BackgroundSprite();
      
      public static const qusejov:Number = 70 * Math.PI / 180;
      
      public static const hevarer:Number = 0.1;
      
      public static const ruda:Vector3D = new Vector3D(-0.6,-0.5,-1);
      
      public static const mawoqu:int = Alternativa3D.mawoqu.split(".")[1];
      
      public static var wuhibota:Vector.<Vector3> = new Vector.<Vector3>();
      
      public static const bisoga:Boolean = true;
      
      public static var vucofena:Boolean = false;
      
      public static var kumiteva:Boolean = false;
      
      public static var qazul:Boolean = false;
      
      public function GameData()
      {
         super();
      }
      
      public static function createGameData(param1:Stage, param2:DisplayObjectContainer) : void
      {
         var _loc14_:Vector3D = null;
         GameData.stage = param1;
         GameData.danewazam = param2;
         if(Shared.tracker == null)
         {
            Shared.tracker = new TrackerService(true);
            Shared.preloader = new LoaderWindow(param1);
         }
         root = new Object3DContainer();
         butefu = new GameCamera();
         butefu.matrix = new Matrix3D(Vector.<Number>([-0.8589262962341309,-0.5120992064476013,0,0,-0.056438345462083817,0.09466209262609482,-0.9939083456993103,0,0.5089796781539917,-0.8536940217018127,-0.11020979285240173,0,1734.8155517578125,-4618.1220703125,121.45249938964844,1]));
         butefu.nearClipping = 100;
         butefu.farClipping = 40000;
         butefu.view = new View(param1.stageWidth,param1.stageHeight,Shared.constrained);
         butefu.view.hideLogo();
         butefu.view.antiAliasEnabled = false;
         butefu.addToDebug(Debug.EDGES,Object3D);
         butefu.addToDebug(Debug.LIGHTS,Object3D);
         butefu.timerUpdatePeriod = 30;
         butefu.softTransparency = false;
         root.addChild(butefu);
         param1.addChildAt(butefu.view,0);
         guzinizub = new KDContainer();
         guzinizub.ignoreChildrenInCollider = true;
         root.addChild(guzinizub);
         bijatil = new SoundManager();
         namab = new TaskGroup();
         gov = new TanksPhysicsScene();
         gov.gyge = 5;
         var _loc3_:Vector3 = gov.tem;
         _loc3_.reset(0,0,-1000);
         gov.lecopojen = getTimer();
         kymaqos = gov.secakesem;
         TurretControlKeyMap.initDefaultKeyMap(Lang.language);
         jifom = new Tank();
         qemikoq = new RecordTankController(param1,jifom);
         dazupuzif = new ScreenBitmapManager(param1);
         hulaf = new ScreenMovieClipManager(param1,param2);
         maji = new CrystalIndicatorManager(param1);
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
         var _loc12_:int = color(_loc4_ - _loc7_,_loc5_ - _loc8_,_loc6_ - _loc9_);
         var _loc13_:int = color(_loc7_,_loc8_,_loc9_);
         if(Boolean(Shared.gpu) && mawoqu >= 11 && !Shared.constrained && (Shared.navigator != "Chrome" || int(Shared.navigatorVersion.split(".")[0]) > 23))
         {
            butefu.fogNear = 0;
            butefu.fogFar = 10000;
            butefu.fogAlpha = 0;
            butefu.directionalLight = new DirectionalLight(_loc12_);
            butefu.directionalLight.lookAt(ruda.x,ruda.y,ruda.z);
            butefu.ambientColor = _loc13_;
            butefu.shadowMap = new ShadowMap(2048,5000,8000,0.5,4000);
            butefu.deferredLighting = false;
            butefu.softTransparency = false;
            butefu.ssao = false;
            butefu.ssaoRadius = 400;
            butefu.ssaoRange = 1200;
            butefu.ssaoColor = 2636880;
            butefu.ssaoAlpha = 1.4;
         }
         else
         {
            _loc14_ = ruda.clone();
            _loc14_.normalize();
            fur = calculateColorTransform(_loc13_,_loc12_,Math.abs(_loc14_.z));
         }
         mij = new BattleServiceImpl();
         zepymy = new BattleRunnerImpl();
         hyfecypi = new BattleScene3DImpl();
         vucofena = !BrowserBlackList.checkIfMouseDisabled();
      }
      
      public static function initMarking() : void
      {
         if(jyqoqogy == null)
         {
            jyqoqogy = new MarkingManager(stage,butefu,guzinizub,jifom,false);
         }
      }
      
      public static function colorize(param1:BitmapData) : void
      {
         if(fur != null && param1 != null)
         {
            param1.colorTransform(param1.rect,fur);
         }
      }
      
      private static function onKey(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case Keyboard.NUMPAD_4:
               ruda.x -= 0.1;
               break;
            case Keyboard.NUMPAD_6:
               ruda.x += 0.1;
               break;
            case Keyboard.NUMPAD_2:
               ruda.y -= 0.1;
               break;
            case Keyboard.NUMPAD_8:
               ruda.y += 0.1;
               break;
            case Keyboard.TAB:
               butefu.debug = !butefu.debug;
               break;
            case Keyboard.F2:
               if(myzumywi == null)
               {
                  myzumywi = new SpectatorCameraController(stage,butefu);
               }
               if(butefu.controller != null)
               {
                  butefu.controller.deactivate();
               }
               if(butefu.controller == myzumywi)
               {
                  butefu.controller = motorafo;
               }
               else
               {
                  motorafo = butefu.controller;
                  butefu.controller = myzumywi;
               }
               if(butefu.controller != null)
               {
                  butefu.controller.activate();
               }
         }
      }
      
      private static function color(param1:uint, param2:uint, param3:uint) : int
      {
         if(param1 > 255)
         {
            param1 = 255;
         }
         if(param2 > 255)
         {
            param2 = 255;
         }
         if(param3 > 255)
         {
            param3 = 255;
         }
         return param1 << 16 | param2 << 8 | param3;
      }
      
      private static function calculateColorTransform(param1:uint, param2:uint, param3:Number = 1) : ColorTransform
      {
         var _loc4_:Number = (param1 >> 16 & 0xFF) / 255;
         var _loc5_:Number = (param1 >> 8 & 0xFF) / 255;
         var _loc6_:Number = (param1 & 0xFF) / 255;
         var _loc7_:Number = (param2 >> 16 & 0xFF) / 255;
         var _loc8_:Number = (param2 >> 8 & 0xFF) / 255;
         var _loc9_:Number = (param2 & 0xFF) / 255;
         var _loc10_:ColorTransform = new ColorTransform();
         _loc10_.redMultiplier = (_loc4_ + _loc7_ * param3) * 2;
         _loc10_.greenMultiplier = (_loc5_ + _loc8_ * param3) * 2;
         _loc10_.blueMultiplier = (_loc6_ + _loc9_ * param3) * 2;
         return _loc10_;
      }
   }
}

