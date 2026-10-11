package alternativa.object
{
   import alternativa.math.Vector3;
   
   public class Wall
   {
      
      private var _x1:Number;
      
      private var _x2:Number;
      
      private var _y1:Number;
      
      private var _y2:Number;
      
      public var indicator:Vector3 = new Vector3();
      
      private var a:Number;
      
      private var b:Number;
      
      private var c:Number;
      
      private var ciguz:Number;
      
      public function Wall(x1:Number, y1:Number, x2:Number, y2:Number, indicatorX:Number, indicatorY:Number, indicatorZ:Number)
      {
         super();
         this._x1 = x1;
         this._x2 = x2;
         this._y1 = y1;
         this._y2 = y2;
         this.calculateABC();
         this.indicator.x = indicatorX;
         this.indicator.y = indicatorY;
         this.indicator.z = indicatorZ;
      }
      
      public function isPointInEnvironmentOfWall(point:Vector3, range:Number) : Boolean
      {
         var x:Number = point.x;
         var y:Number = point.y;
         var z:Number = point.z;
         var distance:Number = Math.abs(this.a * x + this.b * y + this.c) / this.ciguz;
         if(distance <= range)
         {
            return true;
         }
         return false;
      }
      
      private function calculateABC() : void
      {
         this.a = this._y2 - this._y1;
         this.b = this._x1 - this._x2;
         this.c = this._y1 * this._x2 - this._x1 * this._y2;
         this.ciguz = Math.sqrt(this.a * this.a + this.b * this.b);
      }
      
      public function get x1() : Number
      {
         return this._x1;
      }
      
      public function set x1(value:Number) : void
      {
         this._x1 = value;
         this.calculateABC();
      }
      
      public function get x2() : Number
      {
         return this._x2;
      }
      
      public function set x2(value:Number) : void
      {
         this._x2 = value;
         this.calculateABC();
      }
      
      public function get y1() : Number
      {
         return this._y1;
      }
      
      public function set y1(value:Number) : void
      {
         this._y1 = value;
         this.calculateABC();
      }
      
      public function get y2() : Number
      {
         return this._y2;
      }
      
      public function set y2(value:Number) : void
      {
         this._y2 = value;
         this.calculateABC();
      }
   }
}

