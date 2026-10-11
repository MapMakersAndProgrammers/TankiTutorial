package alternativa.math
{
   import flash.geom.Vector3D;
   import flash.utils.getQualifiedClassName;
   
   public class Matrix3
   {
      
      public static const zero:Matrix3 = new Matrix3(0,0,0,0,0,0,0,0,0);
      
      public static const identity:Matrix3 = new Matrix3();
      
      public var ma:Number;
      
      public var mb:Number;
      
      public var mc:Number;
      
      public var me:Number;
      
      public var mf:Number;
      
      public var mg:Number;
      
      public var mi:Number;
      
      public var mj:Number;
      
      public var mk:Number;
      
      public function Matrix3(ma:Number = 1, mb:Number = 0, mc:Number = 0, me:Number = 0, mf:Number = 1, mg:Number = 0, mi:Number = 0, mj:Number = 0, mk:Number = 1)
      {
         super();
         this.ma = ma;
         this.mb = mb;
         this.mc = mc;
         this.me = me;
         this.mf = mf;
         this.mg = mg;
         this.mi = mi;
         this.mj = mj;
         this.mk = mk;
      }
      
      public function toIdentity() : Matrix3
      {
         this.ma = this.mf = this.mk = 1;
         this.mb = this.mc = this.me = this.mg = this.mi = this.mj = 0;
         return this;
      }
      
      public function invert() : Matrix3
      {
         var a:Number = this.ma;
         var b:Number = this.mb;
         var c:Number = this.mc;
         var e:Number = this.me;
         var f:Number = this.mf;
         var g:Number = this.mg;
         var i:Number = this.mi;
         var j:Number = this.mj;
         var k:Number = this.mk;
         var det:Number = 1 / (-c * f * i + b * g * i + c * e * j - a * g * j - b * e * k + a * f * k);
         this.ma = (f * k - g * j) * det;
         this.mb = (c * j - b * k) * det;
         this.mc = (b * g - c * f) * det;
         this.me = (g * i - e * k) * det;
         this.mf = (a * k - c * i) * det;
         this.mg = (c * e - a * g) * det;
         this.mi = (e * j - f * i) * det;
         this.mj = (b * i - a * j) * det;
         this.mk = (a * f - b * e) * det;
         return this;
      }
      
      public function append(matrix:Matrix3) : Matrix3
      {
         var a:Number = this.ma;
         var b:Number = this.mb;
         var c:Number = this.mc;
         var e:Number = this.me;
         var f:Number = this.mf;
         var g:Number = this.mg;
         var i:Number = this.mi;
         var j:Number = this.mj;
         var k:Number = this.mk;
         this.ma = matrix.ma * a + matrix.mb * e + matrix.mc * i;
         this.mb = matrix.ma * b + matrix.mb * f + matrix.mc * j;
         this.mc = matrix.ma * c + matrix.mb * g + matrix.mc * k;
         this.me = matrix.me * a + matrix.mf * e + matrix.mg * i;
         this.mf = matrix.me * b + matrix.mf * f + matrix.mg * j;
         this.mg = matrix.me * c + matrix.mf * g + matrix.mg * k;
         this.mi = matrix.mi * a + matrix.mj * e + matrix.mk * i;
         this.mj = matrix.mi * b + matrix.mj * f + matrix.mk * j;
         this.mk = matrix.mi * c + matrix.mj * g + matrix.mk * k;
         return this;
      }
      
      public function prepend(matrix:Matrix3) : Matrix3
      {
         var a:Number = this.ma;
         var b:Number = this.mb;
         var c:Number = this.mc;
         var e:Number = this.me;
         var f:Number = this.mf;
         var g:Number = this.mg;
         var i:Number = this.mi;
         var j:Number = this.mj;
         var k:Number = this.mk;
         this.ma = a * matrix.ma + b * matrix.me + c * matrix.mi;
         this.mb = a * matrix.mb + b * matrix.mf + c * matrix.mj;
         this.mc = a * matrix.mc + b * matrix.mg + c * matrix.mk;
         this.me = e * matrix.ma + f * matrix.me + g * matrix.mi;
         this.mf = e * matrix.mb + f * matrix.mf + g * matrix.mj;
         this.mg = e * matrix.mc + f * matrix.mg + g * matrix.mk;
         this.mi = i * matrix.ma + j * matrix.me + k * matrix.mi;
         this.mj = i * matrix.mb + j * matrix.mf + k * matrix.mj;
         this.mk = i * matrix.mc + j * matrix.mg + k * matrix.mk;
         return this;
      }
      
      public function prependTransposed(matrix:Matrix3) : Matrix3
      {
         var a:Number = this.ma;
         var b:Number = this.mb;
         var c:Number = this.mc;
         var e:Number = this.me;
         var f:Number = this.mf;
         var g:Number = this.mg;
         var i:Number = this.mi;
         var j:Number = this.mj;
         var k:Number = this.mk;
         this.ma = a * matrix.ma + b * matrix.mb + c * matrix.mc;
         this.mb = a * matrix.me + b * matrix.mf + c * matrix.mg;
         this.mc = a * matrix.mi + b * matrix.mj + c * matrix.mk;
         this.me = e * matrix.ma + f * matrix.mb + g * matrix.mc;
         this.mf = e * matrix.me + f * matrix.mf + g * matrix.mg;
         this.mg = e * matrix.mi + f * matrix.mj + g * matrix.mk;
         this.mi = i * matrix.ma + j * matrix.mb + k * matrix.mc;
         this.mj = i * matrix.me + j * matrix.mf + k * matrix.mg;
         this.mk = i * matrix.mi + j * matrix.mj + k * matrix.mk;
         return this;
      }
      
      public function add(matrix:Matrix3) : Matrix3
      {
         this.ma += matrix.ma;
         this.mb += matrix.mb;
         this.mc += matrix.mc;
         this.me += matrix.me;
         this.mf += matrix.mf;
         this.mg += matrix.mg;
         this.mi += matrix.mi;
         this.mj += matrix.mj;
         this.mk += matrix.mk;
         return this;
      }
      
      public function subtract(matrix:Matrix3) : Matrix3
      {
         this.ma -= matrix.ma;
         this.mb -= matrix.mb;
         this.mc -= matrix.mc;
         this.me -= matrix.me;
         this.mf -= matrix.mf;
         this.mg -= matrix.mg;
         this.mi -= matrix.mi;
         this.mj -= matrix.mj;
         this.mk -= matrix.mk;
         return this;
      }
      
      public function transpose() : Matrix3
      {
         var tmp:Number = this.mb;
         this.mb = this.me;
         this.me = tmp;
         tmp = this.mc;
         this.mc = this.mi;
         this.mi = tmp;
         tmp = this.mg;
         this.mg = this.mj;
         this.mj = tmp;
         return this;
      }
      
      public function transformVector(src:Vector3, res:Vector3) : void
      {
         res.x = this.ma * src.x + this.mb * src.y + this.mc * src.z;
         res.y = this.me * src.x + this.mf * src.y + this.mg * src.z;
         res.z = this.mi * src.x + this.mj * src.y + this.mk * src.z;
      }
      
      public function transformVectorInverse(src:Vector3, res:Vector3) : void
      {
         res.x = this.ma * src.x + this.me * src.y + this.mi * src.z;
         res.y = this.mb * src.x + this.mf * src.y + this.mj * src.z;
         res.z = this.mc * src.x + this.mg * src.y + this.mk * src.z;
      }
      
      public function transformVector3To3D(src:Vector3, res:Vector3D) : void
      {
         res.x = this.ma * src.x + this.mb * src.y + this.mc * src.z;
         res.y = this.me * src.x + this.mf * src.y + this.mg * src.z;
         res.z = this.mi * src.x + this.mj * src.y + this.mk * src.z;
      }
      
      public function createSkewSymmetric(v:Vector3) : Matrix3
      {
         this.ma = this.mf = this.mk = 0;
         this.mb = -v.z;
         this.mc = v.y;
         this.me = v.z;
         this.mg = -v.x;
         this.mi = -v.y;
         this.mj = v.x;
         return this;
      }
      
      public function copy(matrix:Matrix3) : Matrix3
      {
         this.ma = matrix.ma;
         this.mb = matrix.mb;
         this.mc = matrix.mc;
         this.me = matrix.me;
         this.mf = matrix.mf;
         this.mg = matrix.mg;
         this.mi = matrix.mi;
         this.mj = matrix.mj;
         this.mk = matrix.mk;
         return this;
      }
      
      public function setRotationMatrix(rotationX:Number, rotationY:Number, rotationZ:Number) : Matrix3
      {
         var cosX:Number = Math.cos(rotationX);
         var sinX:Number = Math.sin(rotationX);
         var cosY:Number = Math.cos(rotationY);
         var sinY:Number = Math.sin(rotationY);
         var cosZ:Number = Math.cos(rotationZ);
         var sinZ:Number = Math.sin(rotationZ);
         var cosZsinY:Number = cosZ * sinY;
         var sinZsinY:Number = sinZ * sinY;
         this.ma = cosZ * cosY;
         this.mb = cosZsinY * sinX - sinZ * cosX;
         this.mc = cosZsinY * cosX + sinZ * sinX;
         this.me = sinZ * cosY;
         this.mf = sinZsinY * sinX + cosZ * cosX;
         this.mg = sinZsinY * cosX - cosZ * sinX;
         this.mi = -sinY;
         this.mj = cosY * sinX;
         this.mk = cosY * cosX;
         return this;
      }
      
      public function fromAxisAngle(axis:Vector3, angle:Number) : void
      {
         var c:Number = Math.cos(angle);
         var s:Number = Math.sin(angle);
         var t:Number = 1 - c;
         var x:Number = axis.x;
         var y:Number = axis.y;
         var z:Number = axis.z;
         this.ma = t * x * x + c;
         this.mb = t * x * y - z * s;
         this.mc = t * x * z + y * s;
         this.me = t * x * y + z * s;
         this.mf = t * y * y + c;
         this.mg = t * y * z - x * s;
         this.mi = t * x * z - y * s;
         this.mj = t * y * z + x * s;
         this.mk = t * z * z + c;
      }
      
      public function clone() : Matrix3
      {
         return new Matrix3(this.ma,this.mb,this.mc,this.me,this.mf,this.mg,this.mi,this.mj,this.mk);
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + " (" + this.ma + ", " + this.mb + ", " + this.mc + "), (" + this.me + ", " + this.mf + ", " + this.mg + "), (" + this.mi + ", " + this.mj + ", " + this.mk + ")";
      }
      
      public function getEulerAngles(angles:Vector3) : void
      {
         if(-1 < this.mi && this.mi < 1)
         {
            angles.x = Math.atan2(this.mj,this.mk);
            angles.y = -Math.asin(this.mi);
            angles.z = Math.atan2(this.me,this.ma);
         }
         else
         {
            angles.x = 0;
            angles.y = this.mi <= -1 ? Math.PI : -Math.PI;
            angles.y *= 0.5;
            angles.z = Math.atan2(-this.mb,this.mf);
         }
      }
      
      public function getAxis(index:int, axis:Vector3) : void
      {
         switch(index)
         {
            case 0:
               axis.reset(this.ma,this.me,this.mi);
               break;
            case 1:
               axis.reset(this.mb,this.mf,this.mj);
               break;
            case 2:
               axis.reset(this.mc,this.mg,this.mk);
         }
      }
   }
}

