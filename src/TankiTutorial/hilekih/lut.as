package hilekih
{
   import alternativa.engine3d.core.Object3D;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   import lycikehe.hebis;
   import lycikehe.tivacinym;
   
   public class lut extends Wopowur implements hebis
   {
      
      private var gucoqub:simocaqiq;
      
      private var podelidi:tivacinym;
      
      private var zedyhitem:Array = [0.1,0.3,0.5,0.8,0.9,1];
      
      private var logigap:Array = [0.5,0.8,1,0.5,0.3,0.05];
      
      public function lut(param1:fare)
      {
         super(param1);
      }
      
      public function cabor(param1:simocaqiq, param2:tivacinym) : void
      {
         this.gucoqub = param1;
         this.podelidi = param2;
      }
      
      public function nyw(param1:Object3D) : void
      {
         var _loc6_:Vector.<lyhyzi> = null;
         var _loc7_:int = 0;
         var _loc8_:lyhyzi = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         if(this.gucoqub.pohapu == 0)
         {
            this.podelidi.nyw(param1);
         }
         else
         {
            _loc6_ = this.gucoqub.kipodym;
            _loc7_ = 0;
            while(_loc7_ < this.gucoqub.pohapu)
            {
               _loc8_ = _loc6_[_loc7_];
               _loc9_ = _loc8_.hyn / this.gucoqub.mas;
               _loc10_ = this.duhiku(_loc9_);
               _loc5_ += _loc10_;
               _loc2_ += _loc8_.x * _loc10_;
               _loc3_ += _loc8_.y * _loc10_;
               _loc4_ += _loc8_.z * _loc10_;
               _loc7_++;
            }
            _loc2_ /= _loc5_;
            _loc3_ /= _loc5_;
            _loc4_ /= _loc5_;
            param1.x = _loc2_;
            param1.y = _loc3_;
            param1.z = _loc4_;
         }
      }
      
      private function duhiku(param1:Number) : Number
      {
         var _loc3_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < this.zedyhitem.length)
         {
            _loc3_ = Number(this.zedyhitem[_loc2_]);
            if(_loc3_ >= param1)
            {
               return this.logigap[_loc2_];
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function lynetame(param1:Object3D, param2:nufaneqog, param3:int) : void
      {
         this.nyw(param1);
      }
      
      public function byr() : void
      {
         this.gucoqub = null;
         this.podelidi = null;
      }
   }
}

