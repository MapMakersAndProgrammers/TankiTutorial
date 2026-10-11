package alternativa.math
{
   import flash.geom.Vector3D;
   import flash.utils.getQualifiedClassName;
   
   public class Quaternion
   {
      
      private static var quaternion:Quaternion = new Quaternion();
      
      public var w:Number;
      
      public var x:Number;
      
      public var y:Number;
      
      public var z:Number;
      
      public function Quaternion(w:Number = 1, x:Number = 0, y:Number = 0, z:Number = 0)
      {
         super();
         this.w = w;
         this.x = x;
         this.y = y;
         this.z = z;
      }
      
      public static function multiply(a:Quaternion, b:Quaternion, res:Quaternion) : void
      {
         res.w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z;
         res.x = a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y;
         res.y = a.w * b.y + a.y * b.w + a.z * b.x - a.x * b.z;
         res.z = a.w * b.z + a.z * b.w + a.x * b.y - a.y * b.x;
      }
      
      public static function createFromAxisAngle(axis:Vector3, angle:Number) : Quaternion
      {
         var res:Quaternion = new Quaternion();
         res.setFromAxisAngle(axis,angle);
         return res;
      }
      
      public static function createFromAxisAngleComponents(axisX:Number, axisY:Number, axisZ:Number, angle:Number) : Quaternion
      {
         var res:Quaternion = new Quaternion();
         res.setFromAxisAngleComponents(axisX,axisY,axisZ,angle);
         return res;
      }
      
      public function reset(w:Number = 1, x:Number = 0, y:Number = 0, z:Number = 0) : Quaternion
      {
         this.w = w;
         this.x = x;
         this.y = y;
         this.z = z;
         return this;
      }
      
      public function normalize() : Quaternion
      {
         var len:Number = this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z;
         if(len == 0)
         {
            this.w = 1;
         }
         else
         {
            len = 1 / Math.sqrt(len);
            this.w *= len;
            this.x *= len;
            this.y *= len;
            this.z *= len;
         }
         return this;
      }
      
      public function prepend(q:Quaternion) : Quaternion
      {
         var newW:Number = this.w * q.w - this.x * q.x - this.y * q.y - this.z * q.z;
         var newX:Number = this.w * q.x + this.x * q.w + this.y * q.z - this.z * q.y;
         var newY:Number = this.w * q.y + this.y * q.w + this.z * q.x - this.x * q.z;
         var newZ:Number = this.w * q.z + this.z * q.w + this.x * q.y - this.y * q.x;
         this.w = newW;
         this.x = newX;
         this.y = newY;
         this.z = newZ;
         return this;
      }
      
      public function append(q:Quaternion) : Quaternion
      {
         var newW:Number = q.w * this.w - q.x * this.x - q.y * this.y - q.z * this.z;
         var newX:Number = q.w * this.x + q.x * this.w + q.y * this.z - q.z * this.y;
         var newY:Number = q.w * this.y + q.y * this.w + q.z * this.x - q.x * this.z;
         var newZ:Number = q.w * this.z + q.z * this.w + q.x * this.y - q.y * this.x;
         this.w = newW;
         this.x = newX;
         this.y = newY;
         this.z = newZ;
         return this;
      }
      
      public function rotateByVector(v:Vector3) : Quaternion
      {
         var newW:Number = -v.x * this.x - v.y * this.y - v.z * this.z;
         var newX:Number = v.x * this.w + v.y * this.z - v.z * this.y;
         var newY:Number = v.y * this.w + v.z * this.x - v.x * this.z;
         var newZ:Number = v.z * this.w + v.x * this.y - v.y * this.x;
         this.w = newW;
         this.x = newX;
         this.y = newY;
         this.z = newZ;
         return this;
      }
      
      public function addScaledVector(v:Vector3, scale:Number) : Quaternion
      {
         var vx:Number = v.x * scale;
         var vy:Number = v.y * scale;
         var vz:Number = v.z * scale;
         var dw:Number = -this.x * vx - this.y * vy - this.z * vz;
         var dx:Number = vx * this.w + vy * this.z - vz * this.y;
         var dy:Number = vy * this.w + vz * this.x - vx * this.z;
         var dz:Number = vz * this.w + vx * this.y - vy * this.x;
         this.w += 0.5 * dw;
         this.x += 0.5 * dx;
         this.y += 0.5 * dy;
         this.z += 0.5 * dz;
         var len:Number = this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z;
         if(len == 0)
         {
            this.w = 1;
         }
         else
         {
            len = 1 / Math.sqrt(len);
            this.w *= len;
            this.x *= len;
            this.y *= len;
            this.z *= len;
         }
         return this;
      }
      
      public function toMatrix3(matrix:Matrix3) : Quaternion
      {
         var zz:Number = NaN;
         var xy:Number = NaN;
         var yz:Number = NaN;
         var zx:Number = NaN;
         var wx:Number = NaN;
         var wy:Number = NaN;
         var xx:Number = 2 * this.x * this.x;
         var yy:Number = 2 * this.y * this.y;
         zz = 2 * this.z * this.z;
         xy = 2 * this.x * this.y;
         yz = 2 * this.y * this.z;
         zx = 2 * this.z * this.x;
         wx = 2 * this.w * this.x;
         wy = 2 * this.w * this.y;
         var wz:Number = 2 * this.w * this.z;
         matrix.ma = 1 - yy - zz;
         matrix.mb = xy - wz;
         matrix.mc = zx + wy;
         matrix.me = xy + wz;
         matrix.mf = 1 - xx - zz;
         matrix.mg = yz - wx;
         matrix.mi = zx - wy;
         matrix.mj = yz + wx;
         matrix.mk = 1 - xx - yy;
         return this;
      }
      
      public function toMatrix4(matrix:Matrix4) : Quaternion
      {
         var yz:Number = NaN;
         var zx:Number = NaN;
         var wx:Number = NaN;
         var xx:Number = 2 * this.x * this.x;
         var yy:Number = 2 * this.y * this.y;
         var zz:Number = 2 * this.z * this.z;
         var xy:Number = 2 * this.x * this.y;
         yz = 2 * this.y * this.z;
         zx = 2 * this.z * this.x;
         wx = 2 * this.w * this.x;
         var wy:Number = 2 * this.w * this.y;
         var wz:Number = 2 * this.w * this.z;
         matrix.ma = 1 - yy - zz;
         matrix.mb = xy - wz;
         matrix.mc = zx + wy;
         matrix.me = xy + wz;
         matrix.mf = 1 - xx - zz;
         matrix.mg = yz - wx;
         matrix.mi = zx - wy;
         matrix.mj = yz + wx;
         matrix.mk = 1 - xx - yy;
         return this;
      }
      
      public function length() : Number
      {
         return Math.sqrt(this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z);
      }
      
      public function lengthSqr() : Number
      {
         return this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z;
      }
      
      public function setFromAxisAngle(axis:Vector3, angle:Number) : Quaternion
      {
         this.w = Math.cos(0.5 * angle);
         var factor:Number = Math.sin(0.5 * angle) / Math.sqrt(axis.x * axis.x + axis.y * axis.y + axis.z * axis.z);
         this.x = axis.x * factor;
         this.y = axis.y * factor;
         this.z = axis.z * factor;
         return this;
      }
      
      public function setFromAxisAngleComponents(axisX:Number, axisY:Number, axisZ:Number, angle:Number) : Quaternion
      {
         this.w = Math.cos(0.5 * angle);
         var factor:Number = Math.sin(0.5 * angle) / Math.sqrt(axisX * axisX + axisY * axisY + axisZ * axisZ);
         this.x = axisX * factor;
         this.y = axisY * factor;
         this.z = axisZ * factor;
         return this;
      }
      
      public function toAxisVector(axis:Vector3 = null) : Vector3
      {
         var angle:Number = NaN;
         var factor:Number = NaN;
         if(this.w < -1 || this.w > 1)
         {
            this.normalize();
         }
         if(axis == null)
         {
            axis = new Vector3();
         }
         if(this.w > -1 && this.w < 1)
         {
            if(this.w == 0)
            {
               axis.x = this.x;
               axis.y = this.y;
               axis.z = this.z;
            }
            else
            {
               angle = 2 * Math.acos(this.w);
               factor = 1 / Math.sqrt(1 - this.w * this.w);
               axis.x = this.x * factor * angle;
               axis.y = this.y * factor * angle;
               axis.z = this.z * factor * angle;
            }
         }
         else
         {
            axis.x = 0;
            axis.y = 0;
            axis.z = 0;
         }
         return axis;
      }
      
      public function getEulerAngles(angles:Vector3) : Vector3
      {
         var xx:Number = 2 * this.x * this.x;
         var yy:Number = 2 * this.y * this.y;
         var zz:Number = 2 * this.z * this.z;
         var xy:Number = 2 * this.x * this.y;
         var yz:Number = 2 * this.y * this.z;
         var zx:Number = 2 * this.z * this.x;
         var wx:Number = 2 * this.w * this.x;
         var wy:Number = 2 * this.w * this.y;
         var wz:Number = 2 * this.w * this.z;
         var a:Number = 1 - yy - zz;
         var b:Number = xy - wz;
         var e:Number = xy + wz;
         var f:Number = 1 - xx - zz;
         var i:Number = zx - wy;
         var j:Number = yz + wx;
         var k:Number = 1 - xx - yy;
         if(-1 < i && i < 1)
         {
            if(angles == null)
            {
               angles = new Vector3(Math.atan2(j,k),-Math.asin(i),Math.atan2(e,a));
            }
            else
            {
               angles.x = Math.atan2(j,k);
               angles.y = -Math.asin(i);
               angles.z = Math.atan2(e,a);
            }
         }
         else if(angles == null)
         {
            angles = new Vector3(0,0.5 * (i <= -1 ? Math.PI : -Math.PI),Math.atan2(-b,f));
         }
         else
         {
            angles.x = 0;
            angles.y = i <= -1 ? Math.PI : -Math.PI;
            angles.y *= 0.5;
            angles.z = Math.atan2(-b,f);
         }
         return angles;
      }
      
      public function setFromEulerAnglesXYZ(rotationX:Number, rotationY:Number, rotationZ:Number) : void
      {
         this.setFromAxisAngleComponents(1,0,0,rotationX);
         quaternion.setFromAxisAngleComponents(0,1,0,rotationY);
         this.append(quaternion);
         this.normalize();
         quaternion.setFromAxisAngleComponents(0,0,1,rotationZ);
         this.append(quaternion);
         this.normalize();
      }
      
      public function conjugate() : void
      {
         this.x = -this.x;
         this.y = -this.y;
         this.z = -this.z;
      }
      
      public function nlerp(a:Quaternion, b:Quaternion, t:Number) : Quaternion
      {
         var _loc4_:Number = 1 - t;
         this.w = a.w * _loc4_ + b.w * t;
         this.x = a.x * _loc4_ + b.x * t;
         this.y = a.y * _loc4_ + b.y * t;
         this.z = a.z * _loc4_ + b.z * t;
         _loc4_ = this.w * this.w + this.x * this.x + this.y * this.y + this.z * this.z;
         if(_loc4_ == 0)
         {
            this.w = 1;
         }
         else
         {
            _loc4_ = 1 / Math.sqrt(_loc4_);
            this.w *= _loc4_;
            this.x *= _loc4_;
            this.y *= _loc4_;
            this.z *= _loc4_;
         }
         return this;
      }
      
      public function subtract(q:Quaternion) : Quaternion
      {
         this.w -= q.w;
         this.x -= q.x;
         this.y -= q.y;
         this.z -= q.z;
         return this;
      }
      
      public function diff(a:Quaternion, b:Quaternion) : Quaternion
      {
         this.w = b.w - a.w;
         this.x = b.x - a.x;
         this.y = b.y - a.y;
         this.z = b.z - a.z;
         return this;
      }
      
      public function copy(q:Quaternion) : Quaternion
      {
         this.w = q.w;
         this.x = q.x;
         this.y = q.y;
         this.z = q.z;
         return this;
      }
      
      public function toVector3D(res:Vector3D) : Vector3D
      {
         res.x = this.x;
         res.y = this.y;
         res.z = this.z;
         res.w = this.w;
         return res;
      }
      
      public function clone() : Quaternion
      {
         return new Quaternion(this.w,this.x,this.y,this.z);
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + "(" + this.w + ", " + this.x + ", " + this.y + ", " + this.z + ")";
      }
      
      public function slerp(a:Quaternion, b:Quaternion, t:Number) : Quaternion
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var angle:Number = NaN;
         var sinAngle:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var sign:Number = 1;
         var dot:Number = a.w * b.w + a.x * b.x + a.y * b.y + a.z * b.z;
         if(dot < 0)
         {
            dot = -dot;
            sign = -1;
         }
         if(1 - dot < 0.001)
         {
            _loc6_ = 1 - t;
            _loc7_ = t * sign;
            this.w = a.w * _loc6_ + b.w * _loc7_;
            this.x = a.x * _loc6_ + b.x * _loc7_;
            this.y = a.y * _loc6_ + b.y * _loc7_;
            this.z = a.z * _loc6_ + b.z * _loc7_;
            this.normalize();
         }
         else
         {
            angle = Math.acos(dot);
            sinAngle = Math.sin(angle);
            _loc10_ = Math.sin((1 - t) * angle) / sinAngle;
            _loc11_ = Math.sin(t * angle) / sinAngle * sign;
            this.w = a.w * _loc10_ + b.w * _loc11_;
            this.x = a.x * _loc10_ + b.x * _loc11_;
            this.y = a.y * _loc10_ + b.y * _loc11_;
            this.z = a.z * _loc10_ + b.z * _loc11_;
         }
         return this;
      }
      
      public function isFiniteQuaternion() : Boolean
      {
         return isFinite(this.w) && isFinite(this.x) && isFinite(this.y) && isFinite(this.z);
      }
   }
}

