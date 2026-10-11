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
      
      public static const WAYPOINT:String = "waypoint";
      
      public static const WAYWALL:String = "waywall";
      
      public static const WAYAREA:String = "wayarea";
      
      public static const OPEN_DOOR:String = "open-door";
      
      public static const SHOW_CRYSTAL_INDICATOR:String = "show-crystal-indicator";
      
      public static const HIDE_CRYSTAL_INDICATOR:String = "hide-crystal-indicator";
      
      public static const CLOSE_DOOR:String = "close-door";
      
      public static const ENEMY:String = "enemy";
      
      public static const CHANGE:String = "change";
      
      public static const MEDICINE:String = "medicine";
      
      public static const CRYSTAL:String = "crystal";
      
      public static const CAMERA_ANGLE:String = "camera.angle";
      
      public static const CAMERA_CONTROLLER:String = "camera.controller";
      
      public static const CAMERA_MATRIX:String = "camera.matrix";
      
      public static const FADEOUT:String = "fadeout";
      
      public static const FADEIN:String = "fadein";
      
      public static const TITLE:String = "title";
      
      public static const PLAYER_CONTROLLER:String = "player.controller";
      
      public static const PLAYER_SPAWN:String = "player.spawn";
      
      public static const BITMAP_SHOW:String = "bitmap.show";
      
      public static const BITMAP_HIDE:String = "bitmap.hide";
      
      public static const PLAYER_CAN_SUICIDE:String = "player.canSuicide";
      
      public static const WAIT:String = "wait";
      
      public static const MOVIE_SHOW:String = "movie.show";
      
      public static const MOVIE_HIDE:String = "movie.hide";
      
      public static const START:String = "start";
      
      public static const ADAPTIVE_FPS:String = "adaptiveFPS";
      
      public static const ARROW_GLOW_SHOW:String = "arrow-glow.show";
      
      public static const ARROW_GLOW_HIDE:String = "arrow-glow.hide";
      
      public static const SPACE_GLOW_SHOW:String = "space-glow.show";
      
      public static const SPACE_GLOW_HIDE:String = "space-glow.hide";
      
      private static const taskGroup:TaskGroup = GameData.taskGroup;
      
      private var callback:Function;
      
      private var tasks:Vector.<Task>;
      
      private var numRequired:int;
      
      private var playerTank:Tank;
      
      private var objectPool:ObjectPool;
      
      private var functions:Vector.<Function>;
      
      private var functionParams:Vector.<Object>;
      
      public var name:String;
      
      public var fullName:String;
      
      public var position:Vector3;
      
      private var numKilled:uint;
      
      public function ScriptStep(xml:XML)
      {
         var actionXML:XML = null;
         var waypoint:Vector3 = null;
         var wall:Wall = null;
         var tankParams:TankFunctionParams = null;
         var bitmapParams:BitmapShowParams = null;
         var activator:Vector3 = null;
         var enemyTask:EnemyTankTask = null;
         this.tasks = new Vector.<Task>();
         this.playerTank = GameData.playerTank;
         this.objectPool = GameData.objectPool;
         this.functions = new Vector.<Function>();
         this.functionParams = new Vector.<Object>();
         this.position = new Vector3();
         super();
         this.name = xml.@name.toString();
         this.fullName = "";
         for each(actionXML in xml.elements())
         {
            switch(actionXML.name().toString())
            {
               case WAYPOINT:
                  waypoint = this.parseWaypoint(actionXML);
                  this.position.copy(waypoint);
                  this.tasks.push(new WaypointTask(waypoint,this.playerTank,this.onStepDone));
                  ++this.numRequired;
                  break;
               case WAYWALL:
                  wall = this.parseWayWall(actionXML);
                  this.position.copy(wall.kiw);
                  this.tasks.push(new WaywallTask(wall,this.playerTank,this.onStepDone));
                  ++this.numRequired;
                  break;
               case OPEN_DOOR:
                  this.tasks.push(new OpenDoorTask());
                  break;
               case SHOW_CRYSTAL_INDICATOR:
                  this.tasks.push(new CrystalIndicatorTask(CrystalIndicatorTask.SHOW));
                  break;
               case HIDE_CRYSTAL_INDICATOR:
                  this.tasks.push(new CrystalIndicatorTask(CrystalIndicatorTask.HIDE));
                  break;
               case CLOSE_DOOR:
                  this.tasks.push(new CloseDoorTask());
                  break;
               case CAMERA_ANGLE:
                  this.tasks.push(new ChangeCameraAngleTask(actionXML.@t,actionXML.@speed));
                  break;
               case CAMERA_CONTROLLER:
                  this.functions.push(this.cameraController);
                  this.functionParams.push(null);
                  break;
               case MEDICINE:
                  this.tasks.push(new DropMedicineTask(this.parseWaypoint(actionXML)));
                  break;
               case CRYSTAL:
                  this.tasks.push(new DropCrystalTask(this.parseWaypoint(actionXML)));
                  break;
               case ENEMY:
                  if(actionXML.waypoint.length() > 0)
                  {
                     if(actionXML.activator.length() > 0)
                     {
                        activator = this.parseWaypoint(actionXML.activator[0]);
                     }
                     enemyTask = new EnemyTankTask(actionXML.@hull,actionXML.@turret,actionXML.@color,this.parsePosition(actionXML.@position),this.parseOrientation(actionXML.@orientation),this.parseWaypoints(actionXML.waypoint),actionXML.@health,actionXML.@damageMultiplier.toString() != "" ? Number(actionXML.@damageMultiplier) : 1,this.onEnemyKilled,actionXML.@startShootDelay > 0 ? uint(actionXML.@startShootDelay) : 3000,actionXML.@cycled.toString() == "true",activator);
                     this.tasks.push(enemyTask);
                  }
                  else
                  {
                     this.tasks.push(new RecordedTankTask(actionXML.@hull,actionXML.@turret,actionXML.@color,this.parsePosition(actionXML.@position),this.parseOrientation(actionXML.@orientation),this.parseEnemyData(actionXML.@data),actionXML.@health,actionXML.@damageMultiplier.toString() != "" ? Number(actionXML.@damageMultiplier) : 1,this.onEnemyKilled,actionXML.@startShootDelay > 0 ? uint(actionXML.@startShootDelay) : 3000));
                  }
                  if(actionXML.@required == "true")
                  {
                     ++this.numRequired;
                  }
                  break;
               case CHANGE:
                  if(actionXML.@hull.toString() != "")
                  {
                     this.tasks.push(new HullChangeTask(actionXML.@hull));
                  }
                  if(actionXML.@turret.toString() != "")
                  {
                     this.tasks.push(new TurretChangeTask(actionXML.@turret));
                  }
                  this.tasks.push(new CameraRotateTask());
                  break;
               case FADEOUT:
                  this.tasks.push(new FadeOutTask(actionXML.@time,this.onStepDone));
                  ++this.numRequired;
                  break;
               case TITLE:
                  this.functions.push(this.setTitle);
                  this.functionParams.push(null);
                  break;
               case PLAYER_CONTROLLER:
                  this.functions.push(this.playerController);
                  this.functionParams.push(null);
                  break;
               case ADAPTIVE_FPS:
                  this.tasks.push(new FrameRateTask());
                  break;
               case PLAYER_SPAWN:
                  this.functions.push(this.playerSpawn);
                  tankParams = this.objectPool.getObject(TankFunctionParams) as TankFunctionParams;
                  tankParams.position = this.parsePosition(actionXML.@position.toString());
                  tankParams.orientation = this.parseOrientation(actionXML.@orientation.toString());
                  tankParams.hull = actionXML.@hull.toString();
                  tankParams.turret = actionXML.@turret.toString();
                  tankParams.color = actionXML.@color.toString();
                  tankParams.health = actionXML.@health;
                  tankParams.damageMultiplier = actionXML.@damageMultiplier.toString() != "" ? Number(actionXML.@damageMultiplier) : 1;
                  this.functionParams.push(tankParams);
                  break;
               case CAMERA_MATRIX:
                  this.functions.push(this.cameraMatrix);
                  this.functionParams.push(this.getMatrix(actionXML.@matrix));
                  break;
               case BITMAP_SHOW:
                  this.functions.push(this.bitmapShow);
                  bitmapParams = this.objectPool.getObject(BitmapShowParams) as BitmapShowParams;
                  bitmapParams.align = actionXML.@align.toString();
                  bitmapParams.bitmapID = actionXML.@id.toString();
                  this.functionParams.push(bitmapParams);
                  break;
               case BITMAP_HIDE:
                  this.functions.push(this.bitmapHide);
                  this.functionParams.push(null);
                  break;
               case WAIT:
                  this.functions.push(this.wait);
                  ++this.numRequired;
                  this.functionParams.push(actionXML.@time);
                  break;
               case PLAYER_CAN_SUICIDE:
                  this.tasks.push(new PlayerRespawnTask());
                  break;
               case MOVIE_SHOW:
                  this.functions.push(this.movieShow);
                  bitmapParams = this.objectPool.getObject(BitmapShowParams) as BitmapShowParams;
                  bitmapParams.align = actionXML.@align.toString();
                  bitmapParams.bitmapID = actionXML.@id.toString();
                  this.functionParams.push(bitmapParams);
                  break;
               case MOVIE_HIDE:
                  this.functions.push(this.movieHide);
                  this.functionParams.push(null);
                  break;
               case START:
                  this.tasks.push(new StartTutorialTask(this.onStepDone));
                  ++this.numRequired;
                  break;
               case ARROW_GLOW_SHOW:
                  this.functions.push(this.arrowGlowShow);
                  this.functionParams.push(null);
                  break;
               case ARROW_GLOW_HIDE:
                  this.functions.push(this.arrowGlowHide);
                  this.functionParams.push(null);
                  break;
               case SPACE_GLOW_SHOW:
                  this.functions.push(this.spaceGlowShow);
                  this.functionParams.push(null);
                  break;
               case SPACE_GLOW_HIDE:
                  this.functions.push(this.spaceGlowHide);
                  this.functionParams.push(null);
            }
         }
      }
      
      private function onEnemyKilled() : void
      {
         var eventName:String = null;
         ++this.numKilled;
         if(this.fullName != "")
         {
            eventName = this.fullName + "[enemy" + this.numKilled.toString() + " dead]";
            Shared.tracker.trackEvent(Shared.TUTORIAL,eventName,"");
            Shared.currentStep = eventName;
         }
         this.onStepDone();
      }
      
      private function parseWaypoints(list:XMLList) : Vector.<Vector3>
      {
         var waypointXML:XML = null;
         var waypoints:Vector.<Vector3> = new Vector.<Vector3>();
         for each(waypointXML in list)
         {
            waypoints.push(this.parseWaypoint(waypointXML));
         }
         return waypoints;
      }
      
      private function parseWaypoint(xml:XML) : Vector3
      {
         return new Vector3(xml.@x,xml.@y,xml.@z);
      }
      
      private function parseWayWall(xml:XML) : Wall
      {
         return new Wall(xml.@x1,xml.@y1,xml.@x2,xml.@y2,xml.@indicatorX,xml.@indicatorY,xml.@indicatorZ);
      }
      
      private function movieShow(params:BitmapShowParams) : void
      {
         GameData.screenMovieClipManager.showMovie(Assets.getData(params.bitmapID,MovieClip),params.align);
      }
      
      private function arrowGlowShow() : void
      {
         var controlsClip:ControlsClip = GameData.screenMovieClipManager.currentMovie as ControlsClip;
         if(Boolean(controlsClip))
         {
            controlsClip.showArrowGlow();
         }
      }
      
      private function arrowGlowHide() : void
      {
         var controlsClip:ControlsClip = GameData.screenMovieClipManager.currentMovie as ControlsClip;
         if(Boolean(controlsClip))
         {
            controlsClip.hideArrowGlow();
         }
      }
      
      private function spaceGlowShow() : void
      {
         var controlsClip:ControlsClip = GameData.screenMovieClipManager.currentMovie as ControlsClip;
         if(Boolean(controlsClip))
         {
            controlsClip.showSpaceGlow();
         }
      }
      
      private function spaceGlowHide() : void
      {
         var controlsClip:ControlsClip = GameData.screenMovieClipManager.currentMovie as ControlsClip;
         if(Boolean(controlsClip))
         {
            controlsClip.hideSpaceGlow();
         }
      }
      
      private function movieHide() : void
      {
         GameData.screenMovieClipManager.hideMovie();
      }
      
      private function wait(time:uint) : void
      {
         setTimeout(this.onStepDone,time);
      }
      
      private function bitmapShow(params:BitmapShowParams) : void
      {
         var bitmapData:BitmapData = Assets.getData(params.bitmapID,BitmapData);
         GameData.screenBitmapManager.showBitmap(bitmapData,params.align);
      }
      
      private function bitmapHide() : void
      {
         GameData.screenBitmapManager.hideBimap();
      }
      
      private function cameraController() : void
      {
         var controller:FollowCameraController = new FollowCameraController(GameData.stage,GameData.camera);
         controller.setCollisionParameters(GameData.kdContainer);
         controller.setTarget(this.playerTank);
         controller.activate();
         GameData.camera.controller = controller;
      }
      
      private function cameraMatrix(matrix:Matrix3D) : void
      {
         GameData.camera.matrix = matrix;
      }
      
      private function playerSpawn(params:TankFunctionParams) : void
      {
         if(this.playerTank.inGame)
         {
            this.playerTank.removeFromGame();
         }
         this.playerTank.init(params.hull,params.turret,params.color,params.health);
         this.playerTank.setPosition(params.position);
         this.playerTank.setOrientation(params.orientation);
         this.playerTank.addToGame();
         this.playerTank.setWeaponDamageMultiplier(params.damageMultiplier);
         this.playerTank.setCheckpoint();
         this.playerTank.lysecof.setSilentMode();
         params.recycle();
      }
      
      private function playerController() : void
      {
         taskGroup.addTask(new TankControlTask(this.playerTank,GameData.recordTankController));
         this.playerTank.turretController = new LocalTurretController(0,0,GameData.stage);
         this.playerTank.lysecof.setIdleMode();
      }
      
      private function setTitle() : void
      {
         var title:UserTitle = this.playerTank.kakow == null ? new UserTitle(0,GameData.root) : this.playerTank.kakow;
         var flags:uint = uint(TitleConfigFlags.HEALTH | TitleConfigFlags.WEAPON);
         title.setConfiguration(flags);
         title.addToContainer();
         title.show();
         this.playerTank.kakow = title;
      }
      
      private function onStepDone() : void
      {
         --this.numRequired;
         if(this.numRequired == 0)
         {
            this.callback();
         }
      }
      
      public function start(callback:Function) : void
      {
         var task:Task = null;
         var len:int = 0;
         var i:int = 0;
         var params:Object = null;
         this.callback = callback;
         for each(task in this.tasks)
         {
            GameData.taskGroup.addTask(task);
         }
         len = int(this.functions.length);
         i = 0;
         while(i < len)
         {
            params = this.functionParams[i];
            if(params != null)
            {
               this.functions[i](params);
            }
            else
            {
               this.functions[i]();
            }
            i++;
         }
         if(this.numRequired == 0)
         {
            callback();
         }
      }
      
      private function parsePosition(str:String) : Vector3
      {
         var parts:Array = str.split(" ");
         return new Vector3(parseFloat(parts[0]),parseFloat(parts[1]),parseFloat(parts[2]));
      }
      
      private function parseOrientation(str:String) : Quaternion
      {
         var parts:Array = str.split(" ");
         return new Quaternion(parseFloat(parts[0]),parseFloat(parts[1]),parseFloat(parts[2]),parseFloat(parts[3]));
      }
      
      private function parseEnemyData(str:String) : Vector.<uint>
      {
         var part:String = null;
         var data:Vector.<uint> = new Vector.<uint>();
         var parts:Array = str.split(" ");
         var i:int = 0;
         while(i < parts.length)
         {
            part = parts[i];
            if(part != "")
            {
               data.push(parseInt(part));
            }
            i++;
         }
         return data;
      }
      
      private function getMatrix(str:String) : Matrix3D
      {
         var part:String = null;
         var values:Vector.<Number> = new Vector.<Number>();
         var parts:Array = str.split(",");
         var i:int = 0;
         while(i < parts.length)
         {
            part = parts[i];
            if(part != "")
            {
               values.push(parseFloat(part));
            }
            i++;
         }
         return new Matrix3D(values);
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
   
   public function TankFunctionParams(pool:Pool)
   {
      super(pool);
   }
}

class BitmapShowParams extends PooledObject
{
   
   public var bitmapID:String;
   
   public var align:String;
   
   public function BitmapShowParams(pool:Pool)
   {
      super(pool);
   }
}
