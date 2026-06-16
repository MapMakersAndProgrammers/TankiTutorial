package alternativa.object
{
   import alternativa.math.Vector3;
   
   public class Wall
   {
      
      private var woninynyn:Number;
      
      private var cuqa:Number;
      
      private var pewetifa:Number;
      
      private var pipohe:Number;
      
      public var kiw:Vector3 = new Vector3();
      
      private var gar:Number;
      
      private var nityt:Number;
      
      private var fysu:Number;
      
      private var ciguz:Number;
      
      public function Wall(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number)
      {
         super();
         this.woninynyn = param1;
         this.cuqa = param3;
         this.pewetifa = param2;
         this.pipohe = param4;
         this.calculateABC();
         this.kiw.x = param5;
         this.kiw.y = param6;
         this.kiw.z = param7;
      }
      
      public function isPointInEnvironmentOfWall(param1:Vector3, param2:Number) : Boolean
      {
         var _loc3_:Number = param1.x;
         var _loc4_:Number = param1.y;
         var _loc5_:Number = param1.z;
         var _loc6_:Number = Math.abs(this.gar * _loc3_ + this.nityt * _loc4_ + this.fysu) / this.ciguz;
         if(_loc6_ <= param2)
         {
            return true;
         }
         return false;
      }
      
      private function calculateABC() : void
      {
         this.gar = this.pipohe - this.pewetifa;
         this.nityt = this.woninynyn - this.cuqa;
         this.fysu = this.pewetifa * this.cuqa - this.woninynyn * this.pipohe;
         this.ciguz = Math.sqrt(this.gar * this.gar + this.nityt * this.nityt);
      }
      
      public function get x1() : Number
      {
         return this.woninynyn;
      }
      
      public function set x1(param1:Number) : void
      {
         this.woninynyn = param1;
         this.calculateABC();
      }
      
      public function get x2() : Number
      {
         return this.cuqa;
      }
      
      public function set x2(param1:Number) : void
      {
         this.cuqa = param1;
         this.calculateABC();
      }
      
      public function get y1() : Number
      {
         return this.pewetifa;
      }
      
      public function set y1(param1:Number) : void
      {
         this.pewetifa = param1;
         this.calculateABC();
      }
      
      public function get y2() : Number
      {
         return this.pipohe;
      }
      
      public function set y2(param1:Number) : void
      {
         this.pipohe = param1;
         this.calculateABC();
      }
   }
}

