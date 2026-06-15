package alternativa.math
{
   import flash.utils.getQualifiedClassName;
   
   public class Matrix4
   {
      
      public static const nyra:Matrix4 = new Matrix4();
      
      public var gusat:Number;
      
      public var cydop:Number;
      
      public var sivy:Number;
      
      public var kyvuru:Number;
      
      public var sig:Number;
      
      public var qanezycap:Number;
      
      public var wyvukog:Number;
      
      public var zumidynip:Number;
      
      public var vug:Number;
      
      public var luwym:Number;
      
      public var tari:Number;
      
      public var sunafepo:Number;
      
      public function Matrix4(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 0, param6:Number = 1, param7:Number = 0, param8:Number = 0, param9:Number = 0, param10:Number = 0, param11:Number = 1, param12:Number = 0)
      {
         super();
         this.gusat = param1;
         this.cydop = param2;
         this.sivy = param3;
         this.kyvuru = param4;
         this.sig = param5;
         this.qanezycap = param6;
         this.wyvukog = param7;
         this.zumidynip = param8;
         this.vug = param9;
         this.luwym = param10;
         this.tari = param11;
         this.sunafepo = param12;
      }
      
      public function toIdentity() : Matrix4
      {
         this.gusat = this.qanezycap = this.tari = 1;
         this.cydop = this.sivy = this.sig = this.wyvukog = this.vug = this.luwym = this.kyvuru = this.zumidynip = this.sunafepo = 0;
         return this;
      }
      
      public function invert() : Matrix4
      {
         var _loc1_:Number = this.gusat;
         var _loc2_:Number = this.cydop;
         var _loc3_:Number = this.sivy;
         var _loc4_:Number = this.kyvuru;
         var _loc5_:Number = this.sig;
         var _loc6_:Number = this.qanezycap;
         var _loc7_:Number = this.wyvukog;
         var _loc8_:Number = this.zumidynip;
         var _loc9_:Number = this.vug;
         var _loc10_:Number = this.luwym;
         var _loc11_:Number = this.tari;
         var _loc12_:Number = this.sunafepo;
         var _loc13_:Number = -_loc3_ * _loc6_ * _loc9_ + _loc2_ * _loc7_ * _loc9_ + _loc3_ * _loc5_ * _loc10_ - _loc1_ * _loc7_ * _loc10_ - _loc2_ * _loc5_ * _loc11_ + _loc1_ * _loc6_ * _loc11_;
         this.gusat = (-_loc7_ * _loc10_ + _loc6_ * _loc11_) / _loc13_;
         this.cydop = (_loc3_ * _loc10_ - _loc2_ * _loc11_) / _loc13_;
         this.sivy = (-_loc3_ * _loc6_ + _loc2_ * _loc7_) / _loc13_;
         this.kyvuru = (_loc4_ * _loc7_ * _loc10_ - _loc3_ * _loc8_ * _loc10_ - _loc4_ * _loc6_ * _loc11_ + _loc2_ * _loc8_ * _loc11_ + _loc3_ * _loc6_ * _loc12_ - _loc2_ * _loc7_ * _loc12_) / _loc13_;
         this.sig = (_loc7_ * _loc9_ - _loc5_ * _loc11_) / _loc13_;
         this.qanezycap = (-_loc3_ * _loc9_ + _loc1_ * _loc11_) / _loc13_;
         this.wyvukog = (_loc3_ * _loc5_ - _loc1_ * _loc7_) / _loc13_;
         this.zumidynip = (_loc3_ * _loc8_ * _loc9_ - _loc4_ * _loc7_ * _loc9_ + _loc4_ * _loc5_ * _loc11_ - _loc1_ * _loc8_ * _loc11_ - _loc3_ * _loc5_ * _loc12_ + _loc1_ * _loc7_ * _loc12_) / _loc13_;
         this.vug = (-_loc6_ * _loc9_ + _loc5_ * _loc10_) / _loc13_;
         this.luwym = (_loc2_ * _loc9_ - _loc1_ * _loc10_) / _loc13_;
         this.tari = (-_loc2_ * _loc5_ + _loc1_ * _loc6_) / _loc13_;
         this.sunafepo = (_loc4_ * _loc6_ * _loc9_ - _loc2_ * _loc8_ * _loc9_ - _loc4_ * _loc5_ * _loc10_ + _loc1_ * _loc8_ * _loc10_ + _loc2_ * _loc5_ * _loc12_ - _loc1_ * _loc6_ * _loc12_) / _loc13_;
         return this;
      }
      
      public function append(param1:Matrix4) : Matrix4
      {
         var _loc2_:Number = this.gusat;
         var _loc3_:Number = this.cydop;
         var _loc4_:Number = this.sivy;
         var _loc5_:Number = this.kyvuru;
         var _loc6_:Number = this.sig;
         var _loc7_:Number = this.qanezycap;
         var _loc8_:Number = this.wyvukog;
         var _loc9_:Number = this.zumidynip;
         var _loc10_:Number = this.vug;
         var _loc11_:Number = this.luwym;
         var _loc12_:Number = this.tari;
         var _loc13_:Number = this.sunafepo;
         this.gusat = param1.gusat * _loc2_ + param1.cydop * _loc6_ + param1.sivy * _loc10_;
         this.cydop = param1.gusat * _loc3_ + param1.cydop * _loc7_ + param1.sivy * _loc11_;
         this.sivy = param1.gusat * _loc4_ + param1.cydop * _loc8_ + param1.sivy * _loc12_;
         this.kyvuru = param1.gusat * _loc5_ + param1.cydop * _loc9_ + param1.sivy * _loc13_ + param1.kyvuru;
         this.sig = param1.sig * _loc2_ + param1.qanezycap * _loc6_ + param1.wyvukog * _loc10_;
         this.qanezycap = param1.sig * _loc3_ + param1.qanezycap * _loc7_ + param1.wyvukog * _loc11_;
         this.wyvukog = param1.sig * _loc4_ + param1.qanezycap * _loc8_ + param1.wyvukog * _loc12_;
         this.zumidynip = param1.sig * _loc5_ + param1.qanezycap * _loc9_ + param1.wyvukog * _loc13_ + param1.zumidynip;
         this.vug = param1.vug * _loc2_ + param1.luwym * _loc6_ + param1.tari * _loc10_;
         this.luwym = param1.vug * _loc3_ + param1.luwym * _loc7_ + param1.tari * _loc11_;
         this.tari = param1.vug * _loc4_ + param1.luwym * _loc8_ + param1.tari * _loc12_;
         this.sunafepo = param1.vug * _loc5_ + param1.luwym * _loc9_ + param1.tari * _loc13_ + param1.sunafepo;
         return this;
      }
      
      public function prepend(param1:Matrix4) : Matrix4
      {
         var _loc2_:Number = this.gusat;
         var _loc3_:Number = this.cydop;
         var _loc4_:Number = this.sivy;
         var _loc5_:Number = this.kyvuru;
         var _loc6_:Number = this.sig;
         var _loc7_:Number = this.qanezycap;
         var _loc8_:Number = this.wyvukog;
         var _loc9_:Number = this.zumidynip;
         var _loc10_:Number = this.vug;
         var _loc11_:Number = this.luwym;
         var _loc12_:Number = this.tari;
         var _loc13_:Number = this.sunafepo;
         this.gusat = _loc2_ * param1.gusat + _loc3_ * param1.sig + _loc4_ * param1.vug;
         this.cydop = _loc2_ * param1.cydop + _loc3_ * param1.qanezycap + _loc4_ * param1.luwym;
         this.sivy = _loc2_ * param1.sivy + _loc3_ * param1.wyvukog + _loc4_ * param1.tari;
         this.kyvuru = _loc2_ * param1.kyvuru + _loc3_ * param1.zumidynip + _loc4_ * param1.sunafepo + _loc5_;
         this.sig = _loc6_ * param1.gusat + _loc7_ * param1.sig + _loc8_ * param1.vug;
         this.qanezycap = _loc6_ * param1.cydop + _loc7_ * param1.qanezycap + _loc8_ * param1.luwym;
         this.wyvukog = _loc6_ * param1.sivy + _loc7_ * param1.wyvukog + _loc8_ * param1.tari;
         this.zumidynip = _loc6_ * param1.kyvuru + _loc7_ * param1.zumidynip + _loc8_ * param1.sunafepo + _loc9_;
         this.vug = _loc10_ * param1.gusat + _loc11_ * param1.sig + _loc12_ * param1.vug;
         this.luwym = _loc10_ * param1.cydop + _loc11_ * param1.qanezycap + _loc12_ * param1.luwym;
         this.tari = _loc10_ * param1.sivy + _loc11_ * param1.wyvukog + _loc12_ * param1.tari;
         this.sunafepo = _loc10_ * param1.kyvuru + _loc11_ * param1.zumidynip + _loc12_ * param1.sunafepo + _loc13_;
         return this;
      }
      
      public function add(param1:Matrix4) : Matrix4
      {
         this.gusat += param1.gusat;
         this.cydop += param1.cydop;
         this.sivy += param1.sivy;
         this.kyvuru += param1.kyvuru;
         this.sig += param1.sig;
         this.qanezycap += param1.qanezycap;
         this.wyvukog += param1.wyvukog;
         this.zumidynip += param1.zumidynip;
         this.vug += param1.vug;
         this.luwym += param1.luwym;
         this.tari += param1.tari;
         this.sunafepo += param1.sunafepo;
         return this;
      }
      
      public function subtract(param1:Matrix4) : Matrix4
      {
         this.gusat -= param1.gusat;
         this.cydop -= param1.cydop;
         this.sivy -= param1.sivy;
         this.kyvuru -= param1.kyvuru;
         this.sig -= param1.sig;
         this.qanezycap -= param1.qanezycap;
         this.wyvukog -= param1.wyvukog;
         this.zumidynip -= param1.zumidynip;
         this.vug -= param1.vug;
         this.luwym -= param1.luwym;
         this.tari -= param1.tari;
         this.sunafepo -= param1.sunafepo;
         return this;
      }
      
      public function transformVector(param1:Vector3, param2:Vector3) : void
      {
         param2.x = this.gusat * param1.x + this.cydop * param1.y + this.sivy * param1.qyririg + this.kyvuru;
         param2.y = this.sig * param1.x + this.qanezycap * param1.y + this.wyvukog * param1.qyririg + this.zumidynip;
         param2.qyririg = this.vug * param1.x + this.luwym * param1.y + this.tari * param1.qyririg + this.sunafepo;
      }
      
      public function transformVectorInverse(param1:Vector3, param2:Vector3) : void
      {
         var _loc3_:Number = param1.x - this.kyvuru;
         var _loc4_:Number = param1.y - this.zumidynip;
         var _loc5_:Number = param1.qyririg - this.sunafepo;
         param2.x = this.gusat * _loc3_ + this.sig * _loc4_ + this.vug * _loc5_;
         param2.y = this.cydop * _loc3_ + this.qanezycap * _loc4_ + this.luwym * _loc5_;
         param2.qyririg = this.sivy * _loc3_ + this.wyvukog * _loc4_ + this.tari * _loc5_;
      }
      
      public function transformVectors(param1:Vector.<Vector3>, param2:Vector.<Vector3>) : void
      {
         var _loc4_:Vector3 = null;
         var _loc5_:Vector3 = null;
         var _loc3_:int = int(param1.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            _loc4_ = param1[_loc6_];
            _loc5_ = param2[_loc6_];
            _loc5_.x = this.gusat * _loc4_.x + this.cydop * _loc4_.y + this.sivy * _loc4_.qyririg + this.kyvuru;
            _loc5_.y = this.sig * _loc4_.x + this.qanezycap * _loc4_.y + this.wyvukog * _loc4_.qyririg + this.zumidynip;
            _loc5_.qyririg = this.vug * _loc4_.x + this.luwym * _loc4_.y + this.tari * _loc4_.qyririg + this.sunafepo;
            _loc6_++;
         }
      }
      
      public function transformVectorsN(param1:Vector.<Vector3>, param2:Vector.<Vector3>, param3:int) : void
      {
         var _loc4_:Vector3 = null;
         var _loc5_:Vector3 = null;
         var _loc6_:int = 0;
         while(_loc6_ < param3)
         {
            _loc4_ = param1[_loc6_];
            _loc5_ = param2[_loc6_];
            _loc5_.x = this.gusat * _loc4_.x + this.cydop * _loc4_.y + this.sivy * _loc4_.qyririg + this.kyvuru;
            _loc5_.y = this.sig * _loc4_.x + this.qanezycap * _loc4_.y + this.wyvukog * _loc4_.qyririg + this.zumidynip;
            _loc5_.qyririg = this.vug * _loc4_.x + this.luwym * _loc4_.y + this.tari * _loc4_.qyririg + this.sunafepo;
            _loc6_++;
         }
      }
      
      public function transformVectorsInverse(param1:Vector.<Vector3>, param2:Vector.<Vector3>) : void
      {
         var _loc4_:Vector3 = null;
         var _loc5_:Vector3 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc3_:int = int(param1.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_)
         {
            _loc4_ = param1[_loc6_];
            _loc5_ = param2[_loc6_];
            _loc7_ = _loc4_.x - this.kyvuru;
            _loc8_ = _loc4_.y - this.zumidynip;
            _loc9_ = _loc4_.qyririg - this.sunafepo;
            _loc5_.x = this.gusat * _loc7_ + this.sig * _loc8_ + this.vug * _loc9_;
            _loc5_.y = this.cydop * _loc7_ + this.qanezycap * _loc8_ + this.luwym * _loc9_;
            _loc5_.qyririg = this.sivy * _loc7_ + this.wyvukog * _loc8_ + this.tari * _loc9_;
            _loc6_++;
         }
      }
      
      public function transformVectorsInverseN(param1:Vector.<Vector3>, param2:Vector.<Vector3>, param3:int) : void
      {
         var _loc4_:Vector3 = null;
         var _loc5_:Vector3 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc6_:int = 0;
         while(_loc6_ < param3)
         {
            _loc4_ = param1[_loc6_];
            _loc5_ = param2[_loc6_];
            _loc7_ = _loc4_.x - this.kyvuru;
            _loc8_ = _loc4_.y - this.zumidynip;
            _loc9_ = _loc4_.qyririg - this.sunafepo;
            _loc5_.x = this.gusat * _loc7_ + this.sig * _loc8_ + this.vug * _loc9_;
            _loc5_.y = this.cydop * _loc7_ + this.qanezycap * _loc8_ + this.luwym * _loc9_;
            _loc5_.qyririg = this.sivy * _loc7_ + this.wyvukog * _loc8_ + this.tari * _loc9_;
            _loc6_++;
         }
      }
      
      public function getAxis(param1:int, param2:Vector3) : void
      {
         switch(param1)
         {
            case 0:
               param2.x = this.gusat;
               param2.y = this.sig;
               param2.qyririg = this.vug;
               return;
            case 1:
               param2.x = this.cydop;
               param2.y = this.qanezycap;
               param2.qyririg = this.luwym;
               return;
            case 2:
               param2.x = this.sivy;
               param2.y = this.wyvukog;
               param2.qyririg = this.tari;
               return;
            case 3:
               param2.x = this.kyvuru;
               param2.y = this.zumidynip;
               param2.qyririg = this.sunafepo;
               return;
            default:
               return;
         }
      }
      
      public function deltaTransformVector(param1:Vector3, param2:Vector3) : void
      {
         param2.x = this.gusat * param1.x + this.cydop * param1.y + this.sivy * param1.qyririg + this.kyvuru;
         param2.y = this.sig * param1.x + this.qanezycap * param1.y + this.wyvukog * param1.qyririg + this.zumidynip;
         param2.qyririg = this.vug * param1.x + this.luwym * param1.y + this.tari * param1.qyririg + this.sunafepo;
      }
      
      public function deltaTransformVectorInverse(param1:Vector3, param2:Vector3) : void
      {
         param2.x = this.gusat * param1.x + this.sig * param1.y + this.vug * param1.qyririg;
         param2.y = this.cydop * param1.x + this.qanezycap * param1.y + this.luwym * param1.qyririg;
         param2.qyririg = this.sivy * param1.x + this.wyvukog * param1.y + this.tari * param1.qyririg;
      }
      
      public function copy(param1:Matrix4) : Matrix4
      {
         this.gusat = param1.gusat;
         this.cydop = param1.cydop;
         this.sivy = param1.sivy;
         this.kyvuru = param1.kyvuru;
         this.sig = param1.sig;
         this.qanezycap = param1.qanezycap;
         this.wyvukog = param1.wyvukog;
         this.zumidynip = param1.zumidynip;
         this.vug = param1.vug;
         this.luwym = param1.luwym;
         this.tari = param1.tari;
         this.sunafepo = param1.sunafepo;
         return this;
      }
      
      public function setFromMatrix3(param1:Matrix3, param2:Vector3) : Matrix4
      {
         this.gusat = param1.gusat;
         this.cydop = param1.cydop;
         this.sivy = param1.sivy;
         this.kyvuru = param2.x;
         this.sig = param1.sig;
         this.qanezycap = param1.qanezycap;
         this.wyvukog = param1.wyvukog;
         this.zumidynip = param2.y;
         this.vug = param1.vug;
         this.luwym = param1.luwym;
         this.tari = param1.tari;
         this.sunafepo = param2.qyririg;
         return this;
      }
      
      public function setOrientationFromMatrix3(param1:Matrix3) : Matrix4
      {
         this.gusat = param1.gusat;
         this.cydop = param1.cydop;
         this.sivy = param1.sivy;
         this.sig = param1.sig;
         this.qanezycap = param1.qanezycap;
         this.wyvukog = param1.wyvukog;
         this.vug = param1.vug;
         this.luwym = param1.luwym;
         this.tari = param1.tari;
         return this;
      }
      
      public function setRotationMatrix(param1:Number, param2:Number, param3:Number) : Matrix4
      {
         var _loc4_:Number = Math.cos(param1);
         var _loc5_:Number = Math.sin(param1);
         var _loc6_:Number = Math.cos(param2);
         var _loc7_:Number = Math.sin(param2);
         var _loc8_:Number = Math.cos(param3);
         var _loc9_:Number = Math.sin(param3);
         var _loc10_:Number = _loc8_ * _loc7_;
         var _loc11_:Number = _loc9_ * _loc7_;
         this.gusat = _loc8_ * _loc6_;
         this.cydop = _loc10_ * _loc5_ - _loc9_ * _loc4_;
         this.sivy = _loc10_ * _loc4_ + _loc9_ * _loc5_;
         this.sig = _loc9_ * _loc6_;
         this.qanezycap = _loc11_ * _loc5_ + _loc8_ * _loc4_;
         this.wyvukog = _loc11_ * _loc4_ - _loc8_ * _loc5_;
         this.vug = -_loc7_;
         this.luwym = _loc6_ * _loc5_;
         this.tari = _loc6_ * _loc4_;
         return this;
      }
      
      public function setMatrix(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Matrix4
      {
         var _loc7_:Number = Math.cos(param4);
         var _loc8_:Number = Math.sin(param4);
         var _loc9_:Number = Math.cos(param5);
         var _loc10_:Number = Math.sin(param5);
         var _loc11_:Number = Math.cos(param6);
         var _loc12_:Number = Math.sin(param6);
         var _loc13_:Number = _loc11_ * _loc10_;
         var _loc14_:Number = _loc12_ * _loc10_;
         this.gusat = _loc11_ * _loc9_;
         this.cydop = _loc13_ * _loc8_ - _loc12_ * _loc7_;
         this.sivy = _loc13_ * _loc7_ + _loc12_ * _loc8_;
         this.kyvuru = param1;
         this.sig = _loc12_ * _loc9_;
         this.qanezycap = _loc14_ * _loc8_ + _loc11_ * _loc7_;
         this.wyvukog = _loc14_ * _loc7_ - _loc11_ * _loc8_;
         this.zumidynip = param2;
         this.vug = -_loc10_;
         this.luwym = _loc9_ * _loc8_;
         this.tari = _loc9_ * _loc7_;
         this.sunafepo = param3;
         return this;
      }
      
      public function getEulerAngles(param1:Vector3) : void
      {
         if(-1 < this.vug && this.vug < 1)
         {
            param1.x = Math.atan2(this.luwym,this.tari);
            param1.y = -Math.asin(this.vug);
            param1.qyririg = Math.atan2(this.sig,this.gusat);
         }
         else
         {
            param1.x = 0;
            param1.y = this.vug <= -1 ? Math.PI : -Math.PI;
            param1.y *= 0.5;
            param1.qyririg = Math.atan2(-this.cydop,this.qanezycap);
         }
      }
      
      public function setPosition(param1:Vector3) : void
      {
         this.kyvuru = param1.x;
         this.zumidynip = param1.y;
         this.sunafepo = param1.qyririg;
      }
      
      public function clone() : Matrix4
      {
         return new Matrix4(this.gusat,this.cydop,this.sivy,this.kyvuru,this.sig,this.qanezycap,this.wyvukog,this.zumidynip,this.vug,this.luwym,this.tari,this.sunafepo);
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + " (" + this.gusat.toFixed(3) + " " + this.cydop.toFixed(3) + " " + this.sivy.toFixed(3) + " " + this.kyvuru.toFixed(3) + "] [" + this.sig.toFixed(3) + " " + this.qanezycap.toFixed(3) + " " + this.wyvukog.toFixed(3) + " " + this.zumidynip.toFixed(3) + "] [" + this.vug.toFixed(3) + " " + this.luwym.toFixed(3) + " " + this.tari.toFixed(3) + " " + this.sunafepo.toFixed(3) + ")";
      }
      
      public function fromAxisAngle(param1:Vector3, param2:Number) : void
      {
         var _loc3_:Number = Math.cos(param2);
         var _loc4_:Number = Math.sin(param2);
         var _loc5_:Number = 1 - _loc3_;
         var _loc6_:Number = param1.x;
         var _loc7_:Number = param1.y;
         var _loc8_:Number = param1.qyririg;
         this.gusat = _loc5_ * _loc6_ * _loc6_ + _loc3_;
         this.cydop = _loc5_ * _loc6_ * _loc7_ - _loc8_ * _loc4_;
         this.sivy = _loc5_ * _loc6_ * _loc8_ + _loc7_ * _loc4_;
         this.sig = _loc5_ * _loc6_ * _loc7_ + _loc8_ * _loc4_;
         this.qanezycap = _loc5_ * _loc7_ * _loc7_ + _loc3_;
         this.wyvukog = _loc5_ * _loc7_ * _loc8_ - _loc6_ * _loc4_;
         this.vug = _loc5_ * _loc6_ * _loc8_ - _loc7_ * _loc4_;
         this.luwym = _loc5_ * _loc7_ * _loc8_ + _loc6_ * _loc4_;
         this.tari = _loc5_ * _loc8_ * _loc8_ + _loc3_;
      }
   }
}

