package alternativa.math
{
   import flash.utils.getQualifiedClassName;
   
   public class Matrix4
   {
      
      public static const identity:Matrix4 = new Matrix4();
      
      public var ma:Number;
      
      public var mb:Number;
      
      public var mc:Number;
      
      public var md:Number;
      
      public var me:Number;
      
      public var mf:Number;
      
      public var mg:Number;
      
      public var mh:Number;
      
      public var mi:Number;
      
      public var mj:Number;
      
      public var mk:Number;
      
      public var ml:Number;
      
      public function Matrix4(ma:Number = 1, mb:Number = 0, mc:Number = 0, md:Number = 0, me:Number = 0, mf:Number = 1, mg:Number = 0, mh:Number = 0, mi:Number = 0, mj:Number = 0, mk:Number = 1, ml:Number = 0)
      {
         super();
         this.ma = ma;
         this.mb = mb;
         this.mc = mc;
         this.md = md;
         this.me = me;
         this.mf = mf;
         this.mg = mg;
         this.mh = mh;
         this.mi = mi;
         this.mj = mj;
         this.mk = mk;
         this.ml = ml;
      }
      
      public function toIdentity() : Matrix4
      {
         this.ma = this.mf = this.mk = 1;
         this.mb = this.mc = this.me = this.mg = this.mi = this.mj = this.md = this.mh = this.ml = 0;
         return this;
      }
      
      public function invert() : Matrix4
      {
         var a:Number = this.ma;
         var b:Number = this.mb;
         var c:Number = this.mc;
         var d:Number = this.md;
         var e:Number = this.me;
         var f:Number = this.mf;
         var g:Number = this.mg;
         var h:Number = this.mh;
         var i:Number = this.mi;
         var j:Number = this.mj;
         var k:Number = this.mk;
         var l:Number = this.ml;
         var det:Number = -c * f * i + b * g * i + c * e * j - a * g * j - b * e * k + a * f * k;
         this.ma = (-g * j + f * k) / det;
         this.mb = (c * j - b * k) / det;
         this.mc = (-c * f + b * g) / det;
         this.md = (d * g * j - c * h * j - d * f * k + b * h * k + c * f * l - b * g * l) / det;
         this.me = (g * i - e * k) / det;
         this.mf = (-c * i + a * k) / det;
         this.mg = (c * e - a * g) / det;
         this.mh = (c * h * i - d * g * i + d * e * k - a * h * k - c * e * l + a * g * l) / det;
         this.mi = (-f * i + e * j) / det;
         this.mj = (b * i - a * j) / det;
         this.mk = (-b * e + a * f) / det;
         this.ml = (d * f * i - b * h * i - d * e * j + a * h * j + b * e * l - a * f * l) / det;
         return this;
      }
      
      public function append(matrix:Matrix4) : Matrix4
      {
         var a:Number = this.ma;
         var b:Number = this.mb;
         var c:Number = this.mc;
         var d:Number = this.md;
         var e:Number = this.me;
         var f:Number = this.mf;
         var g:Number = this.mg;
         var h:Number = this.mh;
         var i:Number = this.mi;
         var j:Number = this.mj;
         var k:Number = this.mk;
         var l:Number = this.ml;
         this.ma = matrix.ma * a + matrix.mb * e + matrix.mc * i;
         this.mb = matrix.ma * b + matrix.mb * f + matrix.mc * j;
         this.mc = matrix.ma * c + matrix.mb * g + matrix.mc * k;
         this.md = matrix.ma * d + matrix.mb * h + matrix.mc * l + matrix.md;
         this.me = matrix.me * a + matrix.mf * e + matrix.mg * i;
         this.mf = matrix.me * b + matrix.mf * f + matrix.mg * j;
         this.mg = matrix.me * c + matrix.mf * g + matrix.mg * k;
         this.mh = matrix.me * d + matrix.mf * h + matrix.mg * l + matrix.mh;
         this.mi = matrix.mi * a + matrix.mj * e + matrix.mk * i;
         this.mj = matrix.mi * b + matrix.mj * f + matrix.mk * j;
         this.mk = matrix.mi * c + matrix.mj * g + matrix.mk * k;
         this.ml = matrix.mi * d + matrix.mj * h + matrix.mk * l + matrix.ml;
         return this;
      }
      
      public function prepend(matrix:Matrix4) : Matrix4
      {
         var a:Number = this.ma;
         var b:Number = this.mb;
         var c:Number = this.mc;
         var d:Number = this.md;
         var e:Number = this.me;
         var f:Number = this.mf;
         var g:Number = this.mg;
         var h:Number = this.mh;
         var i:Number = this.mi;
         var j:Number = this.mj;
         var k:Number = this.mk;
         var l:Number = this.ml;
         this.ma = a * matrix.ma + b * matrix.me + c * matrix.mi;
         this.mb = a * matrix.mb + b * matrix.mf + c * matrix.mj;
         this.mc = a * matrix.mc + b * matrix.mg + c * matrix.mk;
         this.md = a * matrix.md + b * matrix.mh + c * matrix.ml + d;
         this.me = e * matrix.ma + f * matrix.me + g * matrix.mi;
         this.mf = e * matrix.mb + f * matrix.mf + g * matrix.mj;
         this.mg = e * matrix.mc + f * matrix.mg + g * matrix.mk;
         this.mh = e * matrix.md + f * matrix.mh + g * matrix.ml + h;
         this.mi = i * matrix.ma + j * matrix.me + k * matrix.mi;
         this.mj = i * matrix.mb + j * matrix.mf + k * matrix.mj;
         this.mk = i * matrix.mc + j * matrix.mg + k * matrix.mk;
         this.ml = i * matrix.md + j * matrix.mh + k * matrix.ml + l;
         return this;
      }
      
      public function add(matrix:Matrix4) : Matrix4
      {
         this.ma += matrix.ma;
         this.mb += matrix.mb;
         this.mc += matrix.mc;
         this.md += matrix.md;
         this.me += matrix.me;
         this.mf += matrix.mf;
         this.mg += matrix.mg;
         this.mh += matrix.mh;
         this.mi += matrix.mi;
         this.mj += matrix.mj;
         this.mk += matrix.mk;
         this.ml += matrix.ml;
         return this;
      }
      
      public function subtract(matrix:Matrix4) : Matrix4
      {
         this.ma -= matrix.ma;
         this.mb -= matrix.mb;
         this.mc -= matrix.mc;
         this.md -= matrix.md;
         this.me -= matrix.me;
         this.mf -= matrix.mf;
         this.mg -= matrix.mg;
         this.mh -= matrix.mh;
         this.mi -= matrix.mi;
         this.mj -= matrix.mj;
         this.mk -= matrix.mk;
         this.ml -= matrix.ml;
         return this;
      }
      
      public function transformVector(src:Vector3, res:Vector3) : void
      {
         res.x = this.ma * src.x + this.mb * src.y + this.mc * src.z + this.md;
         res.y = this.me * src.x + this.mf * src.y + this.mg * src.z + this.mh;
         res.z = this.mi * src.x + this.mj * src.y + this.mk * src.z + this.ml;
      }
      
      public function transformVectorInverse(src:Vector3, res:Vector3) : void
      {
         var dx:Number = src.x - this.md;
         var dy:Number = src.y - this.mh;
         var dz:Number = src.z - this.ml;
         res.x = this.ma * dx + this.me * dy + this.mi * dz;
         res.y = this.mb * dx + this.mf * dy + this.mj * dz;
         res.z = this.mc * dx + this.mg * dy + this.mk * dz;
      }
      
      public function transformVectors(sources:Vector.<Vector3>, results:Vector.<Vector3>) : void
      {
         var src:Vector3 = null;
         var res:Vector3 = null;
         var len:int = int(sources.length);
         var i:int = 0;
         while(i < len)
         {
            src = sources[i];
            res = results[i];
            res.x = this.ma * src.x + this.mb * src.y + this.mc * src.z + this.md;
            res.y = this.me * src.x + this.mf * src.y + this.mg * src.z + this.mh;
            res.z = this.mi * src.x + this.mj * src.y + this.mk * src.z + this.ml;
            i++;
         }
      }
      
      public function transformVectorsN(sources:Vector.<Vector3>, results:Vector.<Vector3>, len:int) : void
      {
         var src:Vector3 = null;
         var res:Vector3 = null;
         var i:int = 0;
         while(i < len)
         {
            src = sources[i];
            res = results[i];
            res.x = this.ma * src.x + this.mb * src.y + this.mc * src.z + this.md;
            res.y = this.me * src.x + this.mf * src.y + this.mg * src.z + this.mh;
            res.z = this.mi * src.x + this.mj * src.y + this.mk * src.z + this.ml;
            i++;
         }
      }
      
      public function transformVectorsInverse(sources:Vector.<Vector3>, results:Vector.<Vector3>) : void
      {
         var src:Vector3 = null;
         var res:Vector3 = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var len:int = int(sources.length);
         var i:int = 0;
         while(i < len)
         {
            src = sources[i];
            res = results[i];
            dx = src.x - this.md;
            dy = src.y - this.mh;
            dz = src.z - this.ml;
            res.x = this.ma * dx + this.me * dy + this.mi * dz;
            res.y = this.mb * dx + this.mf * dy + this.mj * dz;
            res.z = this.mc * dx + this.mg * dy + this.mk * dz;
            i++;
         }
      }
      
      public function transformVectorsInverseN(sources:Vector.<Vector3>, results:Vector.<Vector3>, len:int) : void
      {
         var src:Vector3 = null;
         var res:Vector3 = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var i:int = 0;
         while(i < len)
         {
            src = sources[i];
            res = results[i];
            dx = src.x - this.md;
            dy = src.y - this.mh;
            dz = src.z - this.ml;
            res.x = this.ma * dx + this.me * dy + this.mi * dz;
            res.y = this.mb * dx + this.mf * dy + this.mj * dz;
            res.z = this.mc * dx + this.mg * dy + this.mk * dz;
            i++;
         }
      }
      
      public function getAxis(index:int, axis:Vector3) : void
      {
         switch(index)
         {
            case 0:
               axis.x = this.ma;
               axis.y = this.me;
               axis.z = this.mi;
               return;
            case 1:
               axis.x = this.mb;
               axis.y = this.mf;
               axis.z = this.mj;
               return;
            case 2:
               axis.x = this.mc;
               axis.y = this.mg;
               axis.z = this.mk;
               return;
            case 3:
               axis.x = this.md;
               axis.y = this.mh;
               axis.z = this.ml;
               return;
            default:
               return;
         }
      }
      
      public function deltaTransformVector(src:Vector3, res:Vector3) : void
      {
         res.x = this.ma * src.x + this.mb * src.y + this.mc * src.z + this.md;
         res.y = this.me * src.x + this.mf * src.y + this.mg * src.z + this.mh;
         res.z = this.mi * src.x + this.mj * src.y + this.mk * src.z + this.ml;
      }
      
      public function deltaTransformVectorInverse(src:Vector3, res:Vector3) : void
      {
         res.x = this.ma * src.x + this.me * src.y + this.mi * src.z;
         res.y = this.mb * src.x + this.mf * src.y + this.mj * src.z;
         res.z = this.mc * src.x + this.mg * src.y + this.mk * src.z;
      }
      
      public function copy(matrix:Matrix4) : Matrix4
      {
         this.ma = matrix.ma;
         this.mb = matrix.mb;
         this.mc = matrix.mc;
         this.md = matrix.md;
         this.me = matrix.me;
         this.mf = matrix.mf;
         this.mg = matrix.mg;
         this.mh = matrix.mh;
         this.mi = matrix.mi;
         this.mj = matrix.mj;
         this.mk = matrix.mk;
         this.ml = matrix.ml;
         return this;
      }
      
      public function setFromMatrix3(matrix:Matrix3, position:Vector3) : Matrix4
      {
         this.ma = matrix.ma;
         this.mb = matrix.mb;
         this.mc = matrix.mc;
         this.md = position.x;
         this.me = matrix.me;
         this.mf = matrix.mf;
         this.mg = matrix.mg;
         this.mh = position.y;
         this.mi = matrix.mi;
         this.mj = matrix.mj;
         this.mk = matrix.mk;
         this.ml = position.z;
         return this;
      }
      
      public function setOrientationFromMatrix3(matrix:Matrix3) : Matrix4
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
      
      public function setRotationMatrix(rotationX:Number, rotationY:Number, rotationZ:Number) : Matrix4
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
      
      public function setMatrix(x:Number, y:Number, z:Number, rotationX:Number, rotationY:Number, rotationZ:Number) : Matrix4
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
         this.md = x;
         this.me = sinZ * cosY;
         this.mf = sinZsinY * sinX + cosZ * cosX;
         this.mg = sinZsinY * cosX - cosZ * sinX;
         this.mh = y;
         this.mi = -sinY;
         this.mj = cosY * sinX;
         this.mk = cosY * cosX;
         this.ml = z;
         return this;
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
      
      public function setPosition(position:Vector3) : void
      {
         this.md = position.x;
         this.mh = position.y;
         this.ml = position.z;
      }
      
      public function clone() : Matrix4
      {
         return new Matrix4(this.ma,this.mb,this.mc,this.md,this.me,this.mf,this.mg,this.mh,this.mi,this.mj,this.mk,this.ml);
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + " (" + this.ma.toFixed(3) + " " + this.mb.toFixed(3) + " " + this.mc.toFixed(3) + " " + this.md.toFixed(3) + "] [" + this.me.toFixed(3) + " " + this.mf.toFixed(3) + " " + this.mg.toFixed(3) + " " + this.mh.toFixed(3) + "] [" + this.mi.toFixed(3) + " " + this.mj.toFixed(3) + " " + this.mk.toFixed(3) + " " + this.ml.toFixed(3) + ")";
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
   }
}

