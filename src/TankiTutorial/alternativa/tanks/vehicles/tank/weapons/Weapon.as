package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.tanks.vehicles.tank.Tank;
   
   public class Weapon
   {
      
      public var name:String;
      
      public var damageMultiplier:Number = 1;
      
      private const data:TurretData = new TurretData();
      
      private var tank:Tank;
      
      protected var active:Boolean;
      
      protected var _status:Number;
      
      public function Weapon(param1:String)
      {
         super();
         this.name = param1;
      }
      
      public function getData() : TurretData
      {
         return this.data;
      }
      
      public function getTank() : Tank
      {
         return this.tank;
      }
      
      public function setTank(param1:Tank) : void
      {
         this.tank = param1;
      }
      
      public function get status() : Number
      {
         return this._status;
      }
      
      public function start() : void
      {
         if(this.active)
         {
            return;
         }
         this.active = true;
      }
      
      public function stop() : void
      {
         if(!this.active)
         {
            return;
         }
         this.active = false;
      }
      
      public function getTarget() : Tank
      {
         return null;
      }
      
      public function update(time:int, deltaTime:int) : void
      {
      }
   }
}

