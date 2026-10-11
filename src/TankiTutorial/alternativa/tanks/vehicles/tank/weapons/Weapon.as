package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.tanks.vehicles.tank.Tank;
   
   public class Weapon
   {
      
      public var name:String;
      
      public var kuqy:Number = 1;
      
      private const myfo:TurretData = new TurretData();
      
      private var tank:Tank;
      
      protected var zadawe:Boolean;
      
      protected var mamifoma:Number;
      
      public function Weapon(param1:String)
      {
         super();
         this.name = param1;
      }
      
      public function getData() : TurretData
      {
         return this.myfo;
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
         return this.mamifoma;
      }
      
      public function start() : void
      {
         if(this.zadawe)
         {
            return;
         }
         this.zadawe = true;
      }
      
      public function stop() : void
      {
         if(!this.zadawe)
         {
            return;
         }
         this.zadawe = false;
      }
      
      public function getTarget() : Tank
      {
         return null;
      }
      
      public function update(param1:int, param2:int) : void
      {
      }
   }
}

