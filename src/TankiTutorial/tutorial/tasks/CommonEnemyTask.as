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
      
      private static const nitimalu:uint = 1000;
      
      private static const necykaquda:Number = 0.9;
      
      protected static const socu:BitmapData = Assets.getData("target_pointer",BitmapData);
      
      protected static const caba:uint = 400;
      
      protected static const nipol:int = 0;
      
      protected static const kyzijawo:int = 1;
      
      protected static const cenebah:int = 2;
      
      protected static const hukozi:int = 3;
      
      protected static const jym:int = 4;
      
      protected static const zawyzowa:int = 5;
      
      protected var citacir:Tank;
      
      protected var controller:CommonTankController;
      
      protected var racefom:uint;
      
      protected var kejo:int = 0;
      
      protected var hon:Function;
      
      protected var pifyg:Sprite3D;
      
      protected var jifom:Tank = GameData.jifom;
      
      protected var guzinizub:KDContainer = GameData.guzinizub;
      
      protected var zule:Number = 1;
      
      protected var hefine:Boolean;
      
      private var nyqiwopy:uint = 3000;
      
      private var sequqiz:uint;
      
      private var zulonyhul:uint;
      
      private var dodycoli:Number;
      
      private var inGame:Boolean;
      
      private var babek:int;
      
      public function CommonEnemyTask(param1:String, param2:String, param3:String, param4:Vector3, param5:Quaternion, param6:Number = 0, param7:Number = 1, param8:Function = null, param9:uint = 3000, param10:Boolean = false)
      {
         super();
         this.hon = param8;
         this.nyqiwopy = param9;
         this.hefine = param10;
         this.citacir = new Tank();
         this.citacir.init(param1,param2,param3,param6);
         this.citacir.setWeaponDamageMultiplier(param7);
         this.citacir.setPosition(param4);
         this.citacir.setOrientation(param5);
         this.citacir.turretController = new AutoAimTurretController(this.citacir,this.jifom);
         this.pifyg = new Sprite3D(200,400,new TextureMaterial(socu,false,true,MipMapping.PER_PIXEL,2.5));
         this.zulonyhul = getTimer();
         this.inGame = false;
         this.dodycoli = 0;
         this.pifyg.useShadowMap = false;
         this.pifyg.useLight = false;
         this.pifyg.visible = false;
      }
      
      protected function tryShoot(param1:uint) : int
      {
         var _loc2_:Tank = null;
         if(param1 - this.racefom < this.nyqiwopy)
         {
            return 0;
         }
         if(param1 - this.sequqiz >= nitimalu)
         {
            this.sequqiz = param1;
            _loc2_ = this.citacir.getWeapon().getTarget();
            if(_loc2_ == this.jifom && Boolean(this.jifom.kat) && Math.random() < necykaquda)
            {
               this.babek = 1 << CommonTankController.syfysu;
            }
            else
            {
               this.babek = 0;
            }
         }
         return this.babek;
      }
      
      override public function process() : Boolean
      {
         var _loc2_:Vector3 = null;
         if(!this.inGame)
         {
            this.inGame = true;
            GameData.gaz.push(this.citacir);
            this.guzinizub.addChild(this.pifyg);
            this.controller = new CommonTankController(this.citacir);
            GameData.namab.addTask(new TankControlTask(this.citacir,this.controller));
            this.citacir.kuca.setAlpha(0);
         }
         var _loc1_:TimeData = GameData.lecopojen;
         if(this.kejo < hukozi)
         {
            if(this.pifyg != null)
            {
               _loc2_ = this.citacir.hogys.body.kejo.position;
               this.pifyg.x = _loc2_.x;
               this.pifyg.y = _loc2_.y;
               this.pifyg.z = _loc2_.qyririg;
               this.dodycoli += _loc1_.ziqod * 5;
               this.pifyg.z = _loc2_.qyririg + caba + Math.sin(this.dodycoli) * 100;
            }
            if(this.citacir.currentHealth <= 0 && Boolean(this.citacir.kat))
            {
               this.kejo = hukozi;
               GameData.gido.removeTank(this.citacir);
               this.citacir.kill();
               this.controller.setAction(0);
               this.guzinizub.removeChild(this.pifyg);
               setTimeout(this.finish,2000);
            }
         }
         switch(this.kejo)
         {
            case nipol:
               this.onInit();
               break;
            case kyzijawo:
               this.onExecute();
               break;
            case cenebah:
               this.onIdle();
               break;
            case hukozi:
               this.onDead();
               break;
            case jym:
               this.onDecoy();
               break;
            case zawyzowa:
               return true;
         }
         return false;
      }
      
      protected function onInit() : void
      {
         var _loc1_:TimeData = GameData.lecopojen;
         if(_loc1_.lecopojen - this.zulonyhul > 1000)
         {
            this.racefom = getTimer();
            this.kejo = kyzijawo;
            this.citacir.kuca.setAlpha(1);
         }
      }
      
      protected function onExecute() : void
      {
      }
      
      protected function onIdle() : void
      {
         var _loc1_:TimeData = GameData.lecopojen;
         this.controller.setAction(this.tryShoot(_loc1_.lecopojen));
      }
      
      protected function onDead() : void
      {
      }
      
      protected function onDecoy() : void
      {
         var _loc1_:TimeData = GameData.lecopojen;
         this.zule -= 2 * _loc1_.ziqod;
         this.citacir.kuca.setAlpha(this.zule);
         if(this.zule < 0)
         {
            this.citacir.removeFromGame();
            this.kejo = zawyzowa;
         }
      }
      
      private function finish() : void
      {
         if(this.hon != null)
         {
            this.hon();
         }
         this.kejo = jym;
      }
   }
}

