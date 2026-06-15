package alternativa.math
{
   import flash.geom.Vector3D;
   import flash.utils.getQualifiedClassName;
   
   public class Vector3
   {
      
      public static const hylivoqug:Vector3 = new Vector3(0,0,0);
      
      public static const giv:Vector3 = new Vector3(1,0,0);
      
      public static const pypymu:Vector3 = new Vector3(0,1,0);
      
      public static const nesicuryn:Vector3 = new Vector3(0,0,1);
      
      public static const lasis:Vector3 = new Vector3(0,0,-1);
      
      public var x:Number;
      
      public var y:Number;
      
      public var qyririg:Number;
      
      public function Vector3(param1:Number = 0, param2:Number = 0, param3:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.qyririg = param3;
      }
      
      public static function isFiniteVector(param1:Vector3) : Boolean
      {
         return param1 != null && isFinite(param1.x) && isFinite(param1.y) && isFinite(param1.qyririg);
      }
      
      public static function interpolate(param1:Number, param2:Vector3, param3:Vector3, param4:Vector3) : void
      {
         param4.x = param2.x + param1 * (param3.x - param2.x);
         param4.y = param2.y + param1 * (param3.y - param2.y);
         param4.qyririg = param2.qyririg + param1 * (param3.qyririg - param2.qyririg);
      }
      
      public static function distanceBetween(param1:Vector3, param2:Vector3) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         var _loc5_:Number = param1.qyririg - param2.qyririg;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_);
      }
      
      public function interpolate(param1:Number, param2:Vector3, param3:Vector3) : void
      {
         this.x = param2.x + param1 * (param3.x - param2.x);
         this.y = param2.y + param1 * (param3.y - param2.y);
         this.qyririg = param2.qyririg + param1 * (param3.qyririg - param2.qyririg);
      }
      
      public function isFiniteVector() : Boolean
      {
         return isFinite(this.x) && isFinite(this.y) && isFinite(this.qyririg);
      }
      
      public function length() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y + this.qyririg * this.qyririg);
      }
      
      public function lengthSqr() : Number
      {
         return this.x * this.x + this.y * this.y + this.qyririg * this.qyririg;
      }
      
      public function setLength(param1:Number) : Vector3
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = this.x * this.x + this.y * this.y + this.qyririg * this.qyririg;
         if(_loc2_ == 0)
         {
            this.x = param1;
         }
         else
         {
            _loc3_ = param1 / Math.sqrt(this.x * this.x + this.y * this.y + this.qyririg * this.qyririg);
            this.x *= _loc3_;
            this.y *= _loc3_;
            this.qyririg *= _loc3_;
         }
         return this;
      }
      
      public function normalize() : Vector3
      {
         var _loc1_:Number = this.x * this.x + this.y * this.y + this.qyririg * this.qyririg;
         if(_loc1_ == 0)
         {
            this.x = 1;
         }
         else
         {
            _loc1_ = Math.sqrt(_loc1_);
            this.x /= _loc1_;
            this.y /= _loc1_;
            this.qyririg /= _loc1_;
         }
         return this;
      }
      
      public function add(param1:Vector3) : Vector3
      {
         this.x += param1.x;
         this.y += param1.y;
         this.qyririg += param1.qyririg;
         return this;
      }
      
      public function addScaled(param1:Number, param2:Vector3) : Vector3
      {
         this.x += param1 * param2.x;
         this.y += param1 * param2.y;
         this.qyririg += param1 * param2.qyririg;
         return this;
      }
      
      public function subtract(param1:Vector3) : Vector3
      {
         this.x -= param1.x;
         this.y -= param1.y;
         this.qyririg -= param1.qyririg;
         return this;
      }
      
      public function sum(param1:Vector3, param2:Vector3) : Vector3
      {
         this.x = param1.x + param2.x;
         this.y = param1.y + param2.y;
         this.qyririg = param1.qyririg + param2.qyririg;
         return this;
      }
      
      public function diff(param1:Vector3, param2:Vector3) : Vector3
      {
         this.x = param1.x - param2.x;
         this.y = param1.y - param2.y;
         this.qyririg = param1.qyririg - param2.qyririg;
         return this;
      }
      
      public function diff2d(param1:Vector3, param2:Vector3) : Vector3
      {
         this.x = param1.x - param2.x;
         this.y = param1.y - param2.y;
         this.qyririg = 0;
         return this;
      }
      
      public function scale(param1:Number) : Vector3
      {
         this.x *= param1;
         this.y *= param1;
         this.qyririg *= param1;
         return this;
      }
      
      public function reverse() : Vector3
      {
         this.x = -this.x;
         this.y = -this.y;
         this.qyririg = -this.qyririg;
         return this;
      }
      
      public function dot(param1:Vector3) : Number
      {
         return this.x * param1.x + this.y * param1.y + this.qyririg * param1.qyririg;
      }
      
      public function cross(param1:Vector3) : Vector3
      {
         var _loc2_:Number = this.y * param1.qyririg - this.qyririg * param1.y;
         var _loc3_:Number = this.qyririg * param1.x - this.x * param1.qyririg;
         var _loc4_:Number = this.x * param1.y - this.y * param1.x;
         this.x = _loc2_;
         this.y = _loc3_;
         this.qyririg = _loc4_;
         return this;
      }
      
      public function cross2(param1:Vector3, param2:Vector3) : Vector3
      {
         this.x = param1.y * param2.qyririg - param1.qyririg * param2.y;
         this.y = param1.qyririg * param2.x - param1.x * param2.qyririg;
         this.qyririg = param1.x * param2.y - param1.y * param2.x;
         return this;
      }
      
      public function transform3(param1:Matrix3) : Vector3
      {
         var _loc2_:Number = this.x;
         var _loc3_:Number = this.y;
         var _loc4_:Number = this.qyririg;
         this.x = param1.gusat * _loc2_ + param1.cydop * _loc3_ + param1.sivy * _loc4_;
         this.y = param1.sig * _loc2_ + param1.qanezycap * _loc3_ + param1.wyvukog * _loc4_;
         this.qyririg = param1.vug * _loc2_ + param1.luwym * _loc3_ + param1.tari * _loc4_;
         return this;
      }
      
      public function transformTransposed3(param1:Matrix3) : Vector3
      {
         var _loc2_:Number = this.x;
         var _loc3_:Number = this.y;
         var _loc4_:Number = this.qyririg;
         this.x = param1.gusat * _loc2_ + param1.sig * _loc3_ + param1.vug * _loc4_;
         this.y = param1.cydop * _loc2_ + param1.qanezycap * _loc3_ + param1.luwym * _loc4_;
         this.qyririg = param1.sivy * _loc2_ + param1.wyvukog * _loc3_ + param1.tari * _loc4_;
         return this;
      }
      
      public function transform4(param1:Matrix4) : Vector3
      {
         var _loc2_:Number = this.x;
         var _loc3_:Number = this.y;
         var _loc4_:Number = this.qyririg;
         this.x = param1.gusat * _loc2_ + param1.cydop * _loc3_ + param1.sivy * _loc4_ + param1.kyvuru;
         this.y = param1.sig * _loc2_ + param1.qanezycap * _loc3_ + param1.wyvukog * _loc4_ + param1.zumidynip;
         this.qyririg = param1.vug * _loc2_ + param1.luwym * _loc3_ + param1.tari * _loc4_ + param1.sunafepo;
         return this;
      }
      
      public function transformInverse4(param1:Matrix4) : Vector3
      {
         var _loc2_:Number = this.x - param1.kyvuru;
         var _loc3_:Number = this.y - param1.zumidynip;
         var _loc4_:Number = this.qyririg - param1.sunafepo;
         this.x = param1.gusat * _loc2_ + param1.sig * _loc3_ + param1.vug * _loc4_;
         this.y = param1.cydop * _loc2_ + param1.qanezycap * _loc3_ + param1.luwym * _loc4_;
         this.qyririg = param1.sivy * _loc2_ + param1.wyvukog * _loc3_ + param1.tari * _loc4_;
         return this;
      }
      
      public function transformVector4(param1:Matrix4) : Vector3
      {
         var _loc2_:Number = this.x;
         var _loc3_:Number = this.y;
         var _loc4_:Number = this.qyririg;
         this.x = param1.gusat * _loc2_ + param1.cydop * _loc3_ + param1.sivy * _loc4_;
         this.y = param1.sig * _loc2_ + param1.qanezycap * _loc3_ + param1.wyvukog * _loc4_;
         this.qyririg = param1.vug * _loc2_ + param1.luwym * _loc3_ + param1.tari * _loc4_;
         return this;
      }
      
      public function reset(param1:Number = 0, param2:Number = 0, param3:Number = 0) : Vector3
      {
         this.x = param1;
         this.y = param2;
         this.qyririg = param3;
         return this;
      }
      
      public function copy(param1:Vector3) : Vector3
      {
         this.x = param1.x;
         this.y = param1.y;
         this.qyririg = param1.qyririg;
         return this;
      }
      
      public function clone() : Vector3
      {
         return new Vector3(this.x,this.y,this.qyririg);
      }
      
      public function toVector3D(param1:Vector3D) : Vector3D
      {
         param1.x = this.x;
         param1.y = this.y;
         param1.z = this.qyririg;
         return param1;
      }
      
      public function copyFromVector3D(param1:Vector3D) : Vector3
      {
         this.x = param1.x;
         this.y = param1.y;
         this.qyririg = param1.z;
         return this;
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + " (" + this.x.toFixed(5) + ", " + this.y.toFixed(5) + ", " + this.qyririg.toFixed(5) + ")";
      }
      
      public function distanceToXYSquared(param1:Vector3) : Number
      {
         var _loc2_:Number = this.x - param1.x;
         var _loc3_:Number = this.y - param1.y;
         return _loc2_ * _loc2_ + _loc3_ * _loc3_;
      }
      
      public function distanceToXY(param1:Vector3) : Number
      {
         var _loc2_:Number = this.x - param1.x;
         var _loc3_:Number = this.y - param1.y;
         return Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
      }
      
      public function distanceTo(param1:Vector3) : Number
      {
         var _loc2_:Number = this.x - param1.x;
         var _loc3_:Number = this.y - param1.y;
         var _loc4_:Number = this.qyririg - param1.qyririg;
         return Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
      
      public function distanceToSquared(param1:Vector3) : Number
      {
         var _loc2_:Number = this.x - param1.x;
         var _loc3_:Number = this.y - param1.y;
         var _loc4_:Number = this.qyririg - param1.qyririg;
         return _loc2_ * _loc2_ + _loc3_ * _loc3_ + _loc4_ * _loc4_;
      }
      
      public function setLengthAlongDirection(param1:Vector3, param2:Number) : void
      {
         var _loc3_:Number = this.x * param1.x + this.y * param1.y + this.qyririg * param1.qyririg;
         var _loc4_:Number = param2 - _loc3_;
         this.x += _loc4_ * param1.x;
         this.y += _loc4_ * param1.y;
         this.qyririg += _loc4_ * param1.qyririg;
      }
      
      public function projectOnPlane(param1:Vector3) : void
      {
         var _loc2_:Number = this.x * param1.x + this.y * param1.y + this.qyririg * param1.qyririg;
         this.x -= _loc2_ * param1.x;
         this.y -= _loc2_ * param1.y;
         this.qyririg -= _loc2_ * param1.qyririg;
      }
   }
}

