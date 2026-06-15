package alternativa.math
{
   import flash.geom.Vector3D;
   import flash.utils.getQualifiedClassName;
   
   public class Matrix3
   {
      
      public static const hylivoqug:Matrix3 = new Matrix3(0,0,0,0,0,0,0,0,0);
      
      public static const nyra:Matrix3 = new Matrix3();
      
      public var gusat:Number;
      
      public var cydop:Number;
      
      public var sivy:Number;
      
      public var sig:Number;
      
      public var qanezycap:Number;
      
      public var wyvukog:Number;
      
      public var vug:Number;
      
      public var luwym:Number;
      
      public var tari:Number;
      
      public function Matrix3(param1:Number = 1, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:Number = 1, param6:Number = 0, param7:Number = 0, param8:Number = 0, param9:Number = 1)
      {
         super();
         this.gusat = param1;
         this.cydop = param2;
         this.sivy = param3;
         this.sig = param4;
         this.qanezycap = param5;
         this.wyvukog = param6;
         this.vug = param7;
         this.luwym = param8;
         this.tari = param9;
      }
      
      public function toIdentity() : Matrix3
      {
         this.gusat = this.qanezycap = this.tari = 1;
         this.cydop = this.sivy = this.sig = this.wyvukog = this.vug = this.luwym = 0;
         return this;
      }
      
      public function invert() : Matrix3
      {
         var _loc1_:Number = this.gusat;
         var _loc2_:Number = this.cydop;
         var _loc3_:Number = this.sivy;
         var _loc4_:Number = this.sig;
         var _loc5_:Number = this.qanezycap;
         var _loc6_:Number = this.wyvukog;
         var _loc7_:Number = this.vug;
         var _loc8_:Number = this.luwym;
         var _loc9_:Number = this.tari;
         var _loc10_:Number = 1 / (-_loc3_ * _loc5_ * _loc7_ + _loc2_ * _loc6_ * _loc7_ + _loc3_ * _loc4_ * _loc8_ - _loc1_ * _loc6_ * _loc8_ - _loc2_ * _loc4_ * _loc9_ + _loc1_ * _loc5_ * _loc9_);
         this.gusat = (_loc5_ * _loc9_ - _loc6_ * _loc8_) * _loc10_;
         this.cydop = (_loc3_ * _loc8_ - _loc2_ * _loc9_) * _loc10_;
         this.sivy = (_loc2_ * _loc6_ - _loc3_ * _loc5_) * _loc10_;
         this.sig = (_loc6_ * _loc7_ - _loc4_ * _loc9_) * _loc10_;
         this.qanezycap = (_loc1_ * _loc9_ - _loc3_ * _loc7_) * _loc10_;
         this.wyvukog = (_loc3_ * _loc4_ - _loc1_ * _loc6_) * _loc10_;
         this.vug = (_loc4_ * _loc8_ - _loc5_ * _loc7_) * _loc10_;
         this.luwym = (_loc2_ * _loc7_ - _loc1_ * _loc8_) * _loc10_;
         this.tari = (_loc1_ * _loc5_ - _loc2_ * _loc4_) * _loc10_;
         return this;
      }
      
      public function append(param1:Matrix3) : Matrix3
      {
         var _loc2_:Number = this.gusat;
         var _loc3_:Number = this.cydop;
         var _loc4_:Number = this.sivy;
         var _loc5_:Number = this.sig;
         var _loc6_:Number = this.qanezycap;
         var _loc7_:Number = this.wyvukog;
         var _loc8_:Number = this.vug;
         var _loc9_:Number = this.luwym;
         var _loc10_:Number = this.tari;
         this.gusat = param1.gusat * _loc2_ + param1.cydop * _loc5_ + param1.sivy * _loc8_;
         this.cydop = param1.gusat * _loc3_ + param1.cydop * _loc6_ + param1.sivy * _loc9_;
         this.sivy = param1.gusat * _loc4_ + param1.cydop * _loc7_ + param1.sivy * _loc10_;
         this.sig = param1.sig * _loc2_ + param1.qanezycap * _loc5_ + param1.wyvukog * _loc8_;
         this.qanezycap = param1.sig * _loc3_ + param1.qanezycap * _loc6_ + param1.wyvukog * _loc9_;
         this.wyvukog = param1.sig * _loc4_ + param1.qanezycap * _loc7_ + param1.wyvukog * _loc10_;
         this.vug = param1.vug * _loc2_ + param1.luwym * _loc5_ + param1.tari * _loc8_;
         this.luwym = param1.vug * _loc3_ + param1.luwym * _loc6_ + param1.tari * _loc9_;
         this.tari = param1.vug * _loc4_ + param1.luwym * _loc7_ + param1.tari * _loc10_;
         return this;
      }
      
      public function prepend(param1:Matrix3) : Matrix3
      {
         var _loc2_:Number = this.gusat;
         var _loc3_:Number = this.cydop;
         var _loc4_:Number = this.sivy;
         var _loc5_:Number = this.sig;
         var _loc6_:Number = this.qanezycap;
         var _loc7_:Number = this.wyvukog;
         var _loc8_:Number = this.vug;
         var _loc9_:Number = this.luwym;
         var _loc10_:Number = this.tari;
         this.gusat = _loc2_ * param1.gusat + _loc3_ * param1.sig + _loc4_ * param1.vug;
         this.cydop = _loc2_ * param1.cydop + _loc3_ * param1.qanezycap + _loc4_ * param1.luwym;
         this.sivy = _loc2_ * param1.sivy + _loc3_ * param1.wyvukog + _loc4_ * param1.tari;
         this.sig = _loc5_ * param1.gusat + _loc6_ * param1.sig + _loc7_ * param1.vug;
         this.qanezycap = _loc5_ * param1.cydop + _loc6_ * param1.qanezycap + _loc7_ * param1.luwym;
         this.wyvukog = _loc5_ * param1.sivy + _loc6_ * param1.wyvukog + _loc7_ * param1.tari;
         this.vug = _loc8_ * param1.gusat + _loc9_ * param1.sig + _loc10_ * param1.vug;
         this.luwym = _loc8_ * param1.cydop + _loc9_ * param1.qanezycap + _loc10_ * param1.luwym;
         this.tari = _loc8_ * param1.sivy + _loc9_ * param1.wyvukog + _loc10_ * param1.tari;
         return this;
      }
      
      public function prependTransposed(param1:Matrix3) : Matrix3
      {
         var _loc2_:Number = this.gusat;
         var _loc3_:Number = this.cydop;
         var _loc4_:Number = this.sivy;
         var _loc5_:Number = this.sig;
         var _loc6_:Number = this.qanezycap;
         var _loc7_:Number = this.wyvukog;
         var _loc8_:Number = this.vug;
         var _loc9_:Number = this.luwym;
         var _loc10_:Number = this.tari;
         this.gusat = _loc2_ * param1.gusat + _loc3_ * param1.cydop + _loc4_ * param1.sivy;
         this.cydop = _loc2_ * param1.sig + _loc3_ * param1.qanezycap + _loc4_ * param1.wyvukog;
         this.sivy = _loc2_ * param1.vug + _loc3_ * param1.luwym + _loc4_ * param1.tari;
         this.sig = _loc5_ * param1.gusat + _loc6_ * param1.cydop + _loc7_ * param1.sivy;
         this.qanezycap = _loc5_ * param1.sig + _loc6_ * param1.qanezycap + _loc7_ * param1.wyvukog;
         this.wyvukog = _loc5_ * param1.vug + _loc6_ * param1.luwym + _loc7_ * param1.tari;
         this.vug = _loc8_ * param1.gusat + _loc9_ * param1.cydop + _loc10_ * param1.sivy;
         this.luwym = _loc8_ * param1.sig + _loc9_ * param1.qanezycap + _loc10_ * param1.wyvukog;
         this.tari = _loc8_ * param1.vug + _loc9_ * param1.luwym + _loc10_ * param1.tari;
         return this;
      }
      
      public function add(param1:Matrix3) : Matrix3
      {
         this.gusat += param1.gusat;
         this.cydop += param1.cydop;
         this.sivy += param1.sivy;
         this.sig += param1.sig;
         this.qanezycap += param1.qanezycap;
         this.wyvukog += param1.wyvukog;
         this.vug += param1.vug;
         this.luwym += param1.luwym;
         this.tari += param1.tari;
         return this;
      }
      
      public function subtract(param1:Matrix3) : Matrix3
      {
         this.gusat -= param1.gusat;
         this.cydop -= param1.cydop;
         this.sivy -= param1.sivy;
         this.sig -= param1.sig;
         this.qanezycap -= param1.qanezycap;
         this.wyvukog -= param1.wyvukog;
         this.vug -= param1.vug;
         this.luwym -= param1.luwym;
         this.tari -= param1.tari;
         return this;
      }
      
      public function transpose() : Matrix3
      {
         var _loc1_:Number = this.cydop;
         this.cydop = this.sig;
         this.sig = _loc1_;
         _loc1_ = this.sivy;
         this.sivy = this.vug;
         this.vug = _loc1_;
         _loc1_ = this.wyvukog;
         this.wyvukog = this.luwym;
         this.luwym = _loc1_;
         return this;
      }
      
      public function transformVector(param1:Vector3, param2:Vector3) : void
      {
         param2.x = this.gusat * param1.x + this.cydop * param1.y + this.sivy * param1.qyririg;
         param2.y = this.sig * param1.x + this.qanezycap * param1.y + this.wyvukog * param1.qyririg;
         param2.qyririg = this.vug * param1.x + this.luwym * param1.y + this.tari * param1.qyririg;
      }
      
      public function transformVectorInverse(param1:Vector3, param2:Vector3) : void
      {
         param2.x = this.gusat * param1.x + this.sig * param1.y + this.vug * param1.qyririg;
         param2.y = this.cydop * param1.x + this.qanezycap * param1.y + this.luwym * param1.qyririg;
         param2.qyririg = this.sivy * param1.x + this.wyvukog * param1.y + this.tari * param1.qyririg;
      }
      
      public function transformVector3To3D(param1:Vector3, param2:Vector3D) : void
      {
         param2.x = this.gusat * param1.x + this.cydop * param1.y + this.sivy * param1.qyririg;
         param2.y = this.sig * param1.x + this.qanezycap * param1.y + this.wyvukog * param1.qyririg;
         param2.z = this.vug * param1.x + this.luwym * param1.y + this.tari * param1.qyririg;
      }
      
      public function createSkewSymmetric(param1:Vector3) : Matrix3
      {
         this.gusat = this.qanezycap = this.tari = 0;
         this.cydop = -param1.qyririg;
         this.sivy = param1.y;
         this.sig = param1.qyririg;
         this.wyvukog = -param1.x;
         this.vug = -param1.y;
         this.luwym = param1.x;
         return this;
      }
      
      public function copy(param1:Matrix3) : Matrix3
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
      
      public function setRotationMatrix(param1:Number, param2:Number, param3:Number) : Matrix3
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
      
      public function clone() : Matrix3
      {
         return new Matrix3(this.gusat,this.cydop,this.sivy,this.sig,this.qanezycap,this.wyvukog,this.vug,this.luwym,this.tari);
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + " (" + this.gusat + ", " + this.cydop + ", " + this.sivy + "), (" + this.sig + ", " + this.qanezycap + ", " + this.wyvukog + "), (" + this.vug + ", " + this.luwym + ", " + this.tari + ")";
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
      
      public function getAxis(param1:int, param2:Vector3) : void
      {
         switch(param1)
         {
            case 0:
               param2.reset(this.gusat,this.sig,this.vug);
               break;
            case 1:
               param2.reset(this.cydop,this.qanezycap,this.luwym);
               break;
            case 2:
               param2.reset(this.sivy,this.wyvukog,this.tari);
         }
      }
   }
}

