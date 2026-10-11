package alternativa.math
{
   import flash.geom.Vector3D;
   import flash.utils.getQualifiedClassName;
   
   public class Vector3
   {
      
      public static const zero:Vector3 = new Vector3(0,0,0);
      
      public static const xAxis:Vector3 = new Vector3(1,0,0);
      
      public static const yAxis:Vector3 = new Vector3(0,1,0);
      
      public static const zAxis:Vector3 = new Vector3(0,0,1);
      
      public static const down:Vector3 = new Vector3(0,0,-1);
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function Vector3(x:Number = 0, y:Number = 0, z:Number = 0)
      {
         super();
         this.x = x;
         this.y = y;
         this.z = z;
      }
      
      public static function isFiniteVector(v:Vector3) : Boolean
      {
         return v != null && isFinite(v.x) && isFinite(v.y) && isFinite(v.z);
      }
      
      public static function interpolate(t:Number, a:Vector3, b:Vector3, res:Vector3) : void
      {
         res.x = a.x + t * (b.x - a.x);
         res.y = a.y + t * (b.y - a.y);
         res.z = a.z + t * (b.z - a.z);
      }
      
      public static function distanceBetween(a:Vector3, b:Vector3) : Number
      {
         var dx:Number = a.x - b.x;
         var dy:Number = a.y - b.y;
         var dz:Number = a.z - b.z;
         return Math.sqrt(dx * dx + dy * dy + dz * dz);
      }
      
      public function interpolate(t:Number, a:Vector3, b:Vector3) : void
      {
         this.x = a.x + t * (b.x - a.x);
         this.y = a.y + t * (b.y - a.y);
         this.z = a.z + t * (b.z - a.z);
      }
      
      public function isFiniteVector() : Boolean
      {
         return isFinite(this.x) && isFinite(this.y) && isFinite(this.z);
      }
      
      public function length() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
      }
      
      public function lengthSqr() : Number
      {
         return this.x * this.x + this.y * this.y + this.z * this.z;
      }
      
      public function setLength(len:Number) : Vector3
      {
         var factor:Number = NaN;
         var lenSqr:Number = this.x * this.x + this.y * this.y + this.z * this.z;
         if(lenSqr == 0)
         {
            this.x = len;
         }
         else
         {
            factor = len / Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
            this.x *= factor;
            this.y *= factor;
            this.z *= factor;
         }
         return this;
      }
      
      public function normalize() : Vector3
      {
         var _loc1_:Number = this.x * this.x + this.y * this.y + this.z * this.z;
         if(_loc1_ == 0)
         {
            this.x = 1;
         }
         else
         {
            _loc1_ = Math.sqrt(_loc1_);
            this.x /= _loc1_;
            this.y /= _loc1_;
            this.z /= _loc1_;
         }
         return this;
      }
      
      public function add(v:Vector3) : Vector3
      {
         this.x += v.x;
         this.y += v.y;
         this.z += v.z;
         return this;
      }
      
      public function addScaled(factor:Number, v:Vector3) : Vector3
      {
         this.x += factor * v.x;
         this.y += factor * v.y;
         this.z += factor * v.z;
         return this;
      }
      
      public function subtract(v:Vector3) : Vector3
      {
         this.x -= v.x;
         this.y -= v.y;
         this.z -= v.z;
         return this;
      }
      
      public function sum(a:Vector3, b:Vector3) : Vector3
      {
         this.x = a.x + b.x;
         this.y = a.y + b.y;
         this.z = a.z + b.z;
         return this;
      }
      
      public function diff(a:Vector3, b:Vector3) : Vector3
      {
         this.x = a.x - b.x;
         this.y = a.y - b.y;
         this.z = a.z - b.z;
         return this;
      }
      
      public function diff2d(a:Vector3, b:Vector3) : Vector3
      {
         this.x = a.x - b.x;
         this.y = a.y - b.y;
         this.z = 0;
         return this;
      }
      
      public function scale(factor:Number) : Vector3
      {
         this.x *= factor;
         this.y *= factor;
         this.z *= factor;
         return this;
      }
      
      public function reverse() : Vector3
      {
         this.x = -this.x;
         this.y = -this.y;
         this.z = -this.z;
         return this;
      }
      
      public function dot(v:Vector3) : Number
      {
         return this.x * v.x + this.y * v.y + this.z * v.z;
      }
      
      public function cross(v:Vector3) : Vector3
      {
         var cx:Number = this.y * v.z - this.z * v.y;
         var cy:Number = this.z * v.x - this.x * v.z;
         var cz:Number = this.x * v.y - this.y * v.x;
         this.x = cx;
         this.y = cy;
         this.z = cz;
         return this;
      }
      
      public function cross2(a:Vector3, b:Vector3) : Vector3
      {
         this.x = a.y * b.z - a.z * b.y;
         this.y = a.z * b.x - a.x * b.z;
         this.z = a.x * b.y - a.y * b.x;
         return this;
      }
      
      public function transform3(matrix:Matrix3) : Vector3
      {
         var vx:Number = this.x;
         var vy:Number = this.y;
         var vz:Number = this.z;
         this.x = matrix.ma * vx + matrix.mb * vy + matrix.mc * vz;
         this.y = matrix.me * vx + matrix.mf * vy + matrix.mg * vz;
         this.z = matrix.mi * vx + matrix.mj * vy + matrix.mk * vz;
         return this;
      }
      
      public function transformTransposed3(matrix:Matrix3) : Vector3
      {
         var vx:Number = this.x;
         var vy:Number = this.y;
         var vz:Number = this.z;
         this.x = matrix.ma * vx + matrix.me * vy + matrix.mi * vz;
         this.y = matrix.mb * vx + matrix.mf * vy + matrix.mj * vz;
         this.z = matrix.mc * vx + matrix.mg * vy + matrix.mk * vz;
         return this;
      }
      
      public function transform4(matrix:Matrix4) : Vector3
      {
         var vx:Number = this.x;
         var vy:Number = this.y;
         var vz:Number = this.z;
         this.x = matrix.ma * vx + matrix.mb * vy + matrix.mc * vz + matrix.md;
         this.y = matrix.me * vx + matrix.mf * vy + matrix.mg * vz + matrix.mh;
         this.z = matrix.mi * vx + matrix.mj * vy + matrix.mk * vz + matrix.ml;
         return this;
      }
      
      public function transformInverse4(matrix:Matrix4) : Vector3
      {
         var dx:Number = this.x - matrix.md;
         var dy:Number = this.y - matrix.mh;
         var dz:Number = this.z - matrix.ml;
         this.x = matrix.ma * dx + matrix.me * dy + matrix.mi * dz;
         this.y = matrix.mb * dx + matrix.mf * dy + matrix.mj * dz;
         this.z = matrix.mc * dx + matrix.mg * dy + matrix.mk * dz;
         return this;
      }
      
      public function transformVector4(matrix:Matrix4) : Vector3
      {
         var vx:Number = this.x;
         var vy:Number = this.y;
         var vz:Number = this.z;
         this.x = matrix.ma * vx + matrix.mb * vy + matrix.mc * vz;
         this.y = matrix.me * vx + matrix.mf * vy + matrix.mg * vz;
         this.z = matrix.mi * vx + matrix.mj * vy + matrix.mk * vz;
         return this;
      }
      
      public function reset(param1:Number = 0, param2:Number = 0, param3:Number = 0) : Vector3
      {
         this.x = param1;
         this.y = param2;
         this.z = param3;
         return this;
      }
      
      public function copy(v:Vector3) : Vector3
      {
         this.x = v.x;
         this.y = v.y;
         this.z = v.z;
         return this;
      }
      
      public function clone() : Vector3
      {
         return new Vector3(this.x,this.y,this.z);
      }
      
      public function toVector3D(res:Vector3D) : Vector3D
      {
         res.x = this.x;
         res.y = this.y;
         res.z = this.z;
         return res;
      }
      
      public function copyFromVector3D(v:Vector3D) : Vector3
      {
         this.x = v.x;
         this.y = v.y;
         this.z = v.z;
         return this;
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + " (" + this.x.toFixed(5) + ", " + this.y.toFixed(5) + ", " + this.z.toFixed(5) + ")";
      }
      
      public function distanceToXYSquared(v:Vector3) : Number
      {
         var dx:Number = this.x - v.x;
         var dy:Number = this.y - v.y;
         return dx * dx + dy * dy;
      }
      
      public function distanceToXY(v:Vector3) : Number
      {
         var dx:Number = this.x - v.x;
         var dy:Number = this.y - v.y;
         return Math.sqrt(dx * dx + dy * dy);
      }
      
      public function distanceTo(v:Vector3) : Number
      {
         var dx:Number = this.x - v.x;
         var dy:Number = this.y - v.y;
         var dz:Number = this.z - v.z;
         return Math.sqrt(dx * dx + dy * dy + dz * dz);
      }
      
      public function distanceToSquared(v:Vector3) : Number
      {
         var dx:Number = this.x - v.x;
         var dy:Number = this.y - v.y;
         var dz:Number = this.z - v.z;
         return dx * dx + dy * dy + dz * dz;
      }
      
      public function setLengthAlongDirection(direction:Vector3, len:Number) : void
      {
         var projection:Number = this.x * direction.x + this.y * direction.y + this.z * direction.z;
         var delta:Number = len - projection;
         this.x += delta * direction.x;
         this.y += delta * direction.y;
         this.z += delta * direction.z;
      }
      
      public function projectOnPlane(normal:Vector3) : void
      {
         var projection:Number = this.x * normal.x + this.y * normal.y + this.z * normal.z;
         this.x -= projection * normal.x;
         this.y -= projection * normal.y;
         this.z -= projection * normal.z;
      }
   }
}

