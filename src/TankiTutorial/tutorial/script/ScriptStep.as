package tutorial.script
{
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.object.Wall;
   import alternativa.tanks.shared.usertitle.TitleConfigFlags;
   import alternativa.tanks.shared.usertitle.UserTitle;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.controllers.LocalTurretController;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Matrix3D;
   import flash.utils.setTimeout;
   import movieclips.ControlsClip;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   import tutorial.commons.Shared;
   import tutorial.tasks.CameraRotateTask;
   import tutorial.tasks.ChangeCameraAngleTask;
   import tutorial.tasks.CloseDoorTask;
   import tutorial.tasks.CrystalIndicatorTask;
   import tutorial.tasks.DropCrystalTask;
   import tutorial.tasks.DropMedicineTask;
   import tutorial.tasks.EnemyTankTask;
   import tutorial.tasks.FadeOutTask;
   import tutorial.tasks.FrameRateTask;
   import tutorial.tasks.HullChangeTask;
   import tutorial.tasks.OpenDoorTask;
   import tutorial.tasks.PlayerRespawnTask;
   import tutorial.tasks.RecordedTankTask;
   import tutorial.tasks.StartTutorialTask;
   import tutorial.tasks.TankControlTask;
   import tutorial.tasks.Task;
   import tutorial.tasks.TaskGroup;
   import tutorial.tasks.TurretChangeTask;
   import tutorial.tasks.WaypointTask;
   import tutorial.tasks.WaywallTask;
   
   public class ScriptStep
   {
      
      public static const ryk:String = "waypoint";
      
      public static const qawi:String = "waywall";
      
      public static const niliribu:String = "wayarea";
      
      public static const cefod:String = "open-door";
      
      public static const tuzydi:String = "show-crystal-indicator";
      
      public static const kal:String = "hide-crystal-indicator";
      
      public static const qumajozy:String = "close-door";
      
      public static const qiby:String = "enemy";
      
      public static const hemutunaj:String = "change";
      
      public static const wejaqat:String = "medicine";
      
      public static const qogihyzug:String = "crystal";
      
      public static const dymikary:String = "camera.angle";
      
      public static const vyqysen:String = "camera.controller";
      
      public static const rawaly:String = "camera.matrix";
      
      public static const nymynykov:String = "fadeout";
      
      public static const copumir:String = "fadein";
      
      public static const culytiq:String = "title";
      
      public static const sil:String = "player.controller";
      
      public static const quka:String = "player.spawn";
      
      public static const fytuqo:String = "bitmap.show";
      
      public static const gityquryh:String = "bitmap.hide";
      
      public static const tyroji:String = "player.canSuicide";
      
      public static const fojehem:String = "wait";
      
      public static const sose:String = "movie.show";
      
      public static const zevubuzyd:String = "movie.hide";
      
      public static const byficy:String = "start";
      
      public static const fafycavav:String = "adaptiveFPS";
      
      public static const myrajyzin:String = "arrow-glow.show";
      
      public static const pofigik:String = "arrow-glow.hide";
      
      public static const wafusemob:String = "space-glow.show";
      
      public static const dekijyf:String = "space-glow.hide";
      
      private static const namab:TaskGroup = GameData.namab;
      
      private var hon:Function;
      
      private var tomynec:Vector.<Task>;
      
      private var rarenyq:int;
      
      private var jifom:Tank;
      
      private var murow:ObjectPool;
      
      private var fazony:Vector.<Function>;
      
      private var vyjure:Vector.<Object>;
      
      public var gepocivaj:String;
      
      public var medyq:String;
      
      public var bip:Vector3;
      
      private var nudyde:uint;
      
      public function ScriptStep(param1:XML)
      {
         var _loc2_:XML = null;
         var _loc3_:Vector3 = null;
         var _loc4_:Wall = null;
         var _loc5_:TankFunctionParams = null;
         var _loc6_:BitmapShowParams = null;
         var _loc7_:Vector3 = null;
         var _loc8_:EnemyTankTask = null;
         this.tomynec = new Vector.<Task>();
         this.jifom = GameData.jifom;
         this.murow = GameData.murow;
         this.fazony = new Vector.<Function>();
         this.vyjure = new Vector.<Object>();
         this.bip = new Vector3();
         super();
         this.gepocivaj = param1.@name.toString();
         this.medyq = "";
         for each(_loc2_ in param1.elements())
         {
            switch(_loc2_.name().toString())
            {
               case ryk:
                  _loc3_ = this.parseWaypoint(_loc2_);
                  this.bip.copy(_loc3_);
                  this.tomynec.push(new WaypointTask(_loc3_,this.jifom,this.onStepDone));
                  ++this.rarenyq;
                  break;
               case qawi:
                  _loc4_ = this.parseWayWall(_loc2_);
                  this.bip.copy(_loc4_.kiw);
                  this.tomynec.push(new WaywallTask(_loc4_,this.jifom,this.onStepDone));
                  ++this.rarenyq;
                  break;
               case cefod:
                  this.tomynec.push(new OpenDoorTask());
                  break;
               case tuzydi:
                  this.tomynec.push(new CrystalIndicatorTask(CrystalIndicatorTask.qufifyqi));
                  break;
               case kal:
                  this.tomynec.push(new CrystalIndicatorTask(CrystalIndicatorTask.zijuzohyl));
                  break;
               case qumajozy:
                  this.tomynec.push(new CloseDoorTask());
                  break;
               case dymikary:
                  this.tomynec.push(new ChangeCameraAngleTask(_loc2_.@t,_loc2_.@speed));
                  break;
               case vyqysen:
                  this.fazony.push(this.cameraController);
                  this.vyjure.push(null);
                  break;
               case wejaqat:
                  this.tomynec.push(new DropMedicineTask(this.parseWaypoint(_loc2_)));
                  break;
               case qogihyzug:
                  this.tomynec.push(new DropCrystalTask(this.parseWaypoint(_loc2_)));
                  break;
               case qiby:
                  if(_loc2_.waypoint.length() > 0)
                  {
                     if(_loc2_.activator.length() > 0)
                     {
                        _loc7_ = this.parseWaypoint(_loc2_.activator[0]);
                     }
                     _loc8_ = new EnemyTankTask(_loc2_.@hull,_loc2_.@turret,_loc2_.@color,this.parsePosition(_loc2_.@position),this.parseOrientation(_loc2_.@orientation),this.parseWaypoints(_loc2_.waypoint),_loc2_.@health,_loc2_.@damageMultiplier.toString() != "" ? Number(_loc2_.@damageMultiplier) : 1,this.onEnemyKilled,_loc2_.@startShootDelay > 0 ? uint(_loc2_.@startShootDelay) : 3000,_loc2_.@cycled.toString() == "true",_loc7_);
                     this.tomynec.push(_loc8_);
                  }
                  else
                  {
                     this.tomynec.push(new RecordedTankTask(_loc2_.@hull,_loc2_.@turret,_loc2_.@color,this.parsePosition(_loc2_.@position),this.parseOrientation(_loc2_.@orientation),this.parseEnemyData(_loc2_.@data),_loc2_.@health,_loc2_.@damageMultiplier.toString() != "" ? Number(_loc2_.@damageMultiplier) : 1,this.onEnemyKilled,_loc2_.@startShootDelay > 0 ? uint(_loc2_.@startShootDelay) : 3000));
                  }
                  if(_loc2_.@required == "true")
                  {
                     ++this.rarenyq;
                  }
                  break;
               case hemutunaj:
                  if(_loc2_.@hull.toString() != "")
                  {
                     this.tomynec.push(new HullChangeTask(_loc2_.@hull));
                  }
                  if(_loc2_.@turret.toString() != "")
                  {
                     this.tomynec.push(new TurretChangeTask(_loc2_.@turret));
                  }
                  this.tomynec.push(new CameraRotateTask());
                  break;
               case nymynykov:
                  this.tomynec.push(new FadeOutTask(_loc2_.@time,this.onStepDone));
                  ++this.rarenyq;
                  break;
               case culytiq:
                  this.fazony.push(this.setTitle);
                  this.vyjure.push(null);
                  break;
               case sil:
                  this.fazony.push(this.playerController);
                  this.vyjure.push(null);
                  break;
               case fafycavav:
                  this.tomynec.push(new FrameRateTask());
                  break;
               case quka:
                  this.fazony.push(this.playerSpawn);
                  _loc5_ = this.murow.getObject(TankFunctionParams) as TankFunctionParams;
                  _loc5_.position = this.parsePosition(_loc2_.@position.toString());
                  _loc5_.orientation = this.parseOrientation(_loc2_.@orientation.toString());
                  _loc5_.hull = _loc2_.@hull.toString();
                  _loc5_.turret = _loc2_.@turret.toString();
                  _loc5_.color = _loc2_.@color.toString();
                  _loc5_.health = _loc2_.@health;
                  _loc5_.damageMultiplier = _loc2_.@damageMultiplier.toString() != "" ? Number(_loc2_.@damageMultiplier) : 1;
                  this.vyjure.push(_loc5_);
                  break;
               case rawaly:
                  this.fazony.push(this.cameraMatrix);
                  this.vyjure.push(this.getMatrix(_loc2_.@matrix));
                  break;
               case fytuqo:
                  this.fazony.push(this.bitmapShow);
                  _loc6_ = this.murow.getObject(BitmapShowParams) as BitmapShowParams;
                  _loc6_.align = _loc2_.@align.toString();
                  _loc6_.bitmapID = _loc2_.@id.toString();
                  this.vyjure.push(_loc6_);
                  break;
               case gityquryh:
                  this.fazony.push(this.bitmapHide);
                  this.vyjure.push(null);
                  break;
               case fojehem:
                  this.fazony.push(this.wait);
                  ++this.rarenyq;
                  this.vyjure.push(_loc2_.@time);
                  break;
               case tyroji:
                  this.tomynec.push(new PlayerRespawnTask());
                  break;
               case sose:
                  this.fazony.push(this.movieShow);
                  _loc6_ = this.murow.getObject(BitmapShowParams) as BitmapShowParams;
                  _loc6_.align = _loc2_.@align.toString();
                  _loc6_.bitmapID = _loc2_.@id.toString();
                  this.vyjure.push(_loc6_);
                  break;
               case zevubuzyd:
                  this.fazony.push(this.movieHide);
                  this.vyjure.push(null);
                  break;
               case byficy:
                  this.tomynec.push(new StartTutorialTask(this.onStepDone));
                  ++this.rarenyq;
                  break;
               case myrajyzin:
                  this.fazony.push(this.arrowGlowShow);
                  this.vyjure.push(null);
                  break;
               case pofigik:
                  this.fazony.push(this.arrowGlowHide);
                  this.vyjure.push(null);
                  break;
               case wafusemob:
                  this.fazony.push(this.spaceGlowShow);
                  this.vyjure.push(null);
                  break;
               case dekijyf:
                  this.fazony.push(this.spaceGlowHide);
                  this.vyjure.push(null);
            }
         }
      }
      
      private function onEnemyKilled() : void
      {
         var _loc1_:String = null;
         ++this.nudyde;
         if(this.medyq != "")
         {
            _loc1_ = this.medyq + "[enemy" + this.nudyde.toString() + " dead]";
            Shared.tracker.trackEvent(Shared.TUTORIAL,_loc1_,"");
            Shared.currentStep = _loc1_;
         }
         this.onStepDone();
      }
      
      private function parseWaypoints(param1:XMLList) : Vector.<Vector3>
      {
         var _loc3_:XML = null;
         var _loc2_:Vector.<Vector3> = new Vector.<Vector3>();
         for each(_loc3_ in param1)
         {
            _loc2_.push(this.parseWaypoint(_loc3_));
         }
         return _loc2_;
      }
      
      private function parseWaypoint(param1:XML) : Vector3
      {
         return new Vector3(param1.@x,param1.@y,param1.@z);
      }
      
      private function parseWayWall(param1:XML) : Wall
      {
         return new Wall(param1.@x1,param1.@y1,param1.@x2,param1.@y2,param1.@indicatorX,param1.@indicatorY,param1.@indicatorZ);
      }
      
      private function movieShow(param1:BitmapShowParams) : void
      {
         GameData.hulaf.showMovie(Assets.getData(param1.bitmapID,MovieClip),param1.align);
      }
      
      private function arrowGlowShow() : void
      {
         var _loc1_:ControlsClip = GameData.hulaf.pere as ControlsClip;
         if(Boolean(_loc1_))
         {
            _loc1_.showArrowGlow();
         }
      }
      
      private function arrowGlowHide() : void
      {
         var _loc1_:ControlsClip = GameData.hulaf.pere as ControlsClip;
         if(Boolean(_loc1_))
         {
            _loc1_.hideArrowGlow();
         }
      }
      
      private function spaceGlowShow() : void
      {
         var _loc1_:ControlsClip = GameData.hulaf.pere as ControlsClip;
         if(Boolean(_loc1_))
         {
            _loc1_.showSpaceGlow();
         }
      }
      
      private function spaceGlowHide() : void
      {
         var _loc1_:ControlsClip = GameData.hulaf.pere as ControlsClip;
         if(Boolean(_loc1_))
         {
            _loc1_.hideSpaceGlow();
         }
      }
      
      private function movieHide() : void
      {
         GameData.hulaf.hideMovie();
      }
      
      private function wait(param1:uint) : void
      {
         setTimeout(this.onStepDone,param1);
      }
      
      private function bitmapShow(param1:BitmapShowParams) : void
      {
         var _loc2_:BitmapData = Assets.getData(param1.bitmapID,BitmapData);
         GameData.dazupuzif.showBitmap(_loc2_,param1.align);
      }
      
      private function bitmapHide() : void
      {
         GameData.dazupuzif.hideBimap();
      }
      
      private function cameraController() : void
      {
         var _loc1_:FollowCameraController = new FollowCameraController(GameData.stage,GameData.butefu);
         _loc1_.setCollisionParameters(GameData.guzinizub);
         _loc1_.setTarget(this.jifom);
         _loc1_.activate();
         GameData.butefu.controller = _loc1_;
      }
      
      private function cameraMatrix(param1:Matrix3D) : void
      {
         GameData.butefu.matrix = param1;
      }
      
      private function playerSpawn(param1:TankFunctionParams) : void
      {
         if(this.jifom.inGame)
         {
            this.jifom.removeFromGame();
         }
         this.jifom.init(param1.hull,param1.turret,param1.color,param1.health);
         this.jifom.setPosition(param1.position);
         this.jifom.setOrientation(param1.orientation);
         this.jifom.addToGame();
         this.jifom.setWeaponDamageMultiplier(param1.damageMultiplier);
         this.jifom.setCheckpoint();
         this.jifom.lysecof.setSilentMode();
         param1.recycle();
      }
      
      private function playerController() : void
      {
         namab.addTask(new TankControlTask(this.jifom,GameData.qemikoq));
         this.jifom.turretController = new LocalTurretController(0,0,GameData.stage);
         this.jifom.lysecof.setIdleMode();
      }
      
      private function setTitle() : void
      {
         var _loc1_:UserTitle = this.jifom.kakow == null ? new UserTitle(0,GameData.root) : this.jifom.kakow;
         var _loc2_:uint = uint(TitleConfigFlags.qoj | TitleConfigFlags.deli);
         _loc1_.setConfiguration(_loc2_);
         _loc1_.addToContainer();
         _loc1_.show();
         this.jifom.kakow = _loc1_;
      }
      
      private function onStepDone() : void
      {
         --this.rarenyq;
         if(this.rarenyq == 0)
         {
            this.hon();
         }
      }
      
      public function start(param1:Function) : void
      {
         var _loc2_:Task = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         this.hon = param1;
         for each(_loc2_ in this.tomynec)
         {
            GameData.namab.addTask(_loc2_);
         }
         _loc3_ = int(this.fazony.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.vyjure[_loc4_];
            if(_loc5_ != null)
            {
               this.fazony[_loc4_](_loc5_);
            }
            else
            {
               this.fazony[_loc4_]();
            }
            _loc4_++;
         }
         if(this.rarenyq == 0)
         {
            param1();
         }
      }
      
      private function parsePosition(param1:String) : Vector3
      {
         var _loc2_:Array = param1.split(" ");
         return new Vector3(parseFloat(_loc2_[0]),parseFloat(_loc2_[1]),parseFloat(_loc2_[2]));
      }
      
      private function parseOrientation(param1:String) : Quaternion
      {
         var _loc2_:Array = param1.split(" ");
         return new Quaternion(parseFloat(_loc2_[0]),parseFloat(_loc2_[1]),parseFloat(_loc2_[2]),parseFloat(_loc2_[3]));
      }
      
      private function parseEnemyData(param1:String) : Vector.<uint>
      {
         var _loc5_:String = null;
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         var _loc3_:Array = param1.split(" ");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_ != "")
            {
               _loc2_.push(parseInt(_loc5_));
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function getMatrix(param1:String) : Matrix3D
      {
         var _loc5_:String = null;
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         var _loc3_:Array = param1.split(",");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_ != "")
            {
               _loc2_.push(parseFloat(_loc5_));
            }
            _loc4_++;
         }
         return new Matrix3D(_loc2_);
      }
   }
}

import alternativa.math.Quaternion;
import alternativa.math.Vector3;
import alternativa.tanks.utils.objectpool.Pool;
import alternativa.tanks.utils.objectpool.PooledObject;

class TankFunctionParams extends PooledObject
{
   
   public var position:Vector3;
   
   public var orientation:Quaternion;
   
   public var hull:String;
   
   public var turret:String;
   
   public var color:String;
   
   public var health:Number;
   
   public var damageMultiplier:Number;
   
   public function TankFunctionParams(param1:Pool)
   {
      super(param1);
   }
}

class BitmapShowParams extends PooledObject
{
   
   public var bitmapID:String;
   
   public var align:String;
   
   public function BitmapShowParams(param1:Pool)
   {
      super(param1);
   }
}
