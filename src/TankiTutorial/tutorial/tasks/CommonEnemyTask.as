package tutorial.tasks
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.controllers.AutoAimTurretController;
   import alternativa.tanks.vehicles.tank.controllers.CommonTankController;
   import flash.display.BitmapData;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import tutorial.GameData;
   import tutorial.TimeData;
   import tutorial.commons.Assets;
   
   public class CommonEnemyTask extends Task
   {
      
      private static const CHECK_INTERVAL:uint = 1000;
      
      private static const SHOOT_PROBABILITY:Number = 0.9;
      
      protected static const targetPointer:BitmapData = Assets.getData("target_pointer",BitmapData);
      
      protected static const POINTER_HEIGHT:uint = 400;
      
      protected static const STATE_INIT:int = 0;
      
      protected static const STATE_EXECUTE:int = 1;
      
      protected static const STATE_IDLE:int = 2;
      
      protected static const STATE_DEAD:int = 3;
      
      protected static const STATE_DECOY:int = 4;
      
      protected static const STATE_FINISHED:int = 5;
      
      protected var tank:Tank;
      
      protected var controller:CommonTankController;
      
      protected var racefom:uint;
      
      protected var state:int = 0;
      
      protected var callback:Function;
      
      protected var pointer:Sprite3D;
      
      protected var playerTank:Tank = GameData.playerTank;
      
      protected var kdContainer:KDContainer = GameData.kdContainer;
      
      protected var alpha:Number = 1;
      
      protected var loop:Boolean;
      
      private var shootDelay:uint = 3000;
      
      private var lastCheckTime:uint;
      
      private var initTime:uint;
      
      private var phase:Number;
      
      private var inGame:Boolean;
      
      private var shootAction:int;
      
      public function CommonEnemyTask(hull:String, turret:String, color:String, position:Vector3, orientation:Quaternion, health:Number = 0, damageMultiplier:Number = 1, callback:Function = null, shootDelay:uint = 3000, loop:Boolean = false)
      {
         super();
         this.callback = callback;
         this.shootDelay = shootDelay;
         this.loop = loop;
         this.tank = new Tank();
         this.tank.init(hull,turret,color,health);
         this.tank.setWeaponDamageMultiplier(damageMultiplier);
         this.tank.setPosition(position);
         this.tank.setOrientation(orientation);
         this.tank.turretController = new AutoAimTurretController(this.tank,this.playerTank);
         this.pointer = new Sprite3D(200,400,new TextureMaterial(targetPointer,false,true,MipMapping.PER_PIXEL,2.5));
         this.initTime = getTimer();
         this.inGame = false;
         this.phase = 0;
         this.pointer.useShadowMap = false;
         this.pointer.useLight = false;
         this.pointer.visible = false;
      }
      
      protected function tryShoot(time:uint) : int
      {
         var target:Tank = null;
         if(time - this.racefom < this.shootDelay)
         {
            return 0;
         }
         if(time - this.lastCheckTime >= CHECK_INTERVAL)
         {
            this.lastCheckTime = time;
            target = this.tank.getWeapon().getTarget();
            if(target == this.playerTank && Boolean(this.playerTank.kat) && Math.random() < SHOOT_PROBABILITY)
            {
               this.shootAction = 1 << CommonTankController.syfysu;
            }
            else
            {
               this.shootAction = 0;
            }
         }
         return this.shootAction;
      }
      
      override public function process() : Boolean
      {
         var position:Vector3 = null;
         if(!this.inGame)
         {
            this.inGame = true;
            GameData.tanks.push(this.tank);
            this.kdContainer.addChild(this.pointer);
            this.controller = new CommonTankController(this.tank);
            GameData.taskGroup.addTask(new TankControlTask(this.tank,this.controller));
            this.tank.kuca.setAlpha(0);
         }
         var timeData:TimeData = GameData.time;
         if(this.state < STATE_DEAD)
         {
            if(this.pointer != null)
            {
               position = this.tank.hogys.body.state.position;
               this.pointer.x = position.x;
               this.pointer.y = position.y;
               this.pointer.z = position.z;
               this.phase += timeData.deltaTime * 5;
               this.pointer.z = position.z + POINTER_HEIGHT + Math.sin(this.phase) * 100;
            }
            if(this.tank.currentHealth <= 0 && Boolean(this.tank.kat))
            {
               this.state = STATE_DEAD;
               GameData.dust.removeTank(this.tank);
               this.tank.kill();
               this.controller.setAction(0);
               this.kdContainer.removeChild(this.pointer);
               setTimeout(this.finish,2000);
            }
         }
         switch(this.state)
         {
            case STATE_INIT:
               this.onInit();
               break;
            case STATE_EXECUTE:
               this.onExecute();
               break;
            case STATE_IDLE:
               this.onIdle();
               break;
            case STATE_DEAD:
               this.onDead();
               break;
            case STATE_DECOY:
               this.onDecoy();
               break;
            case STATE_FINISHED:
               return true;
         }
         return false;
      }
      
      protected function onInit() : void
      {
         var timeData:TimeData = GameData.time;
         if(timeData.time - this.initTime > 1000)
         {
            this.racefom = getTimer();
            this.state = STATE_EXECUTE;
            this.tank.kuca.setAlpha(1);
         }
      }
      
      protected function onExecute() : void
      {
      }
      
      protected function onIdle() : void
      {
         var timeData:TimeData = GameData.time;
         this.controller.setAction(this.tryShoot(timeData.time));
      }
      
      protected function onDead() : void
      {
      }
      
      protected function onDecoy() : void
      {
         var timeData:TimeData = GameData.time;
         this.alpha -= 2 * timeData.deltaTime;
         this.tank.kuca.setAlpha(this.alpha);
         if(this.alpha < 0)
         {
            this.tank.removeFromGame();
            this.state = STATE_FINISHED;
         }
      }
      
      private function finish() : void
      {
         if(this.callback != null)
         {
            this.callback();
         }
         this.state = STATE_DECOY;
      }
   }
}

