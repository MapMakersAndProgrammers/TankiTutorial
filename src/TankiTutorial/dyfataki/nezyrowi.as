package dyfataki
{
   import flash.utils.getTimer;
   import kefy.Wopowur;
   import kefy.fare;
   import lowavide.litavepot;
   import lowavide.luvaqalyr;
   import lycikehe.vipifoki;
   
   public class nezyrowi extends Wopowur implements litavepot
   {
      
      private static const vysil:int = 500;
      
      private static const cygybup:int = 22;
      
      private static const cavogu:int = 12;
      
      private static const zuwujedo:Number = 10;
      
      private static const rihuda:Number = 0.5;
      
      private static const myz:Number = 1 - rihuda;
      
      private static const lako:Number = 0.001;
      
      private static const vac:int = 10400;
      
      private const duleruve:vipifoki = new vipifoki(vysil,cygybup,cavogu,myz,1,zuwujedo);
      
      private var hyfecypi:luvaqalyr;
      
      private var giqo:cogaj;
      
      private var racefom:int;
      
      private var vyno:Boolean;
      
      private var jemusyvin:Boolean;
      
      private var mirocy:Boolean;
      
      public function nezyrowi(param1:fare)
      {
         super(param1);
      }
      
      public function cabor(param1:luvaqalyr, param2:ryzaj, param3:int) : void
      {
         var _loc4_:int = getTimer();
         this.hyfecypi = param1;
         this.giqo = param2.qemydyc();
         this.racefom = _loc4_ + param3 - vac;
         this.mirocy = false;
         this.jemusyvin = true;
         this.vyno = false;
         if(param3 < vac)
         {
            this.duleruve.nuq(cygybup + (vysil - cygybup) * param3 / vac);
         }
         else
         {
            this.duleruve.nuq(vysil);
         }
         param1.dopus(this,0);
         param2.nuziged.gucipusid(this.dalyh);
         param2.lybaluh.gucipusid(this.symo);
      }
      
      private function dalyh() : void
      {
         this.giqo = null;
         this.byr();
      }
      
      private function symo() : void
      {
         this.vyno = true;
         var _loc1_:int = getTimer() - vac;
         if(this.racefom > _loc1_)
         {
            this.racefom = _loc1_;
         }
      }
      
      public function gecumyb(param1:int, param2:int) : void
      {
         if(param1 >= this.racefom)
         {
            if(this.jemusyvin)
            {
               if(!this.mirocy)
               {
                  this.mirocy = true;
                  this.duleruve.cabor(param1);
               }
               this.melukyt(param1,param2);
            }
            else
            {
               this.fivequqa(param2);
            }
         }
      }
      
      private function melukyt(param1:int, param2:int) : void
      {
         var _loc3_:Number = this.duleruve.sukogehen(param1,param2);
         this.giqo.newofelan(_loc3_);
         if(this.vyno && param1 >= this.racefom + vac && _loc3_ == myz)
         {
            this.jemusyvin = false;
         }
      }
      
      private function fivequqa(param1:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = this.giqo.gihane();
         _loc2_ -= lako * param1;
         if(_loc2_ > 0)
         {
            this.giqo.newofelan(_loc2_);
            if(this.giqo.scaleX > 0)
            {
               _loc3_ = this.giqo.scaleX - 0.002 * param1;
               if(_loc3_ < 0)
               {
                  _loc3_ = 0;
               }
               this.giqo.scaleX = _loc3_;
               this.giqo.scaleY = _loc3_;
               this.giqo.scaleZ = _loc3_;
            }
         }
         else
         {
            this.byr();
         }
      }
      
      private function byr() : void
      {
         this.hyfecypi.gebi(this,0);
         if(this.giqo != null)
         {
            this.hyfecypi.behukywu(this.giqo);
            this.giqo.sapavaj();
            this.giqo = null;
         }
         this.hyfecypi = null;
         sapavaj();
      }
   }
}

