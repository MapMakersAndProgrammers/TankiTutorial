package lycikehe
{
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import gafaduzuw.finajylom;
   import jem.tove;
   
   public class raz
   {
      
      private static var hybuhy:raz;
      
      internal var qesyqeno:raz;
      
      private var suwyc:Number;
      
      private var jaji:Number;
      
      private var zib:Sound;
      
      private var judymu:SoundChannel;
      
      private var wet:SoundTransform = new SoundTransform(0);
      
      private var bato:Number = 1;
      
      private var tacacihob:Number = 1;
      
      private var tuc:Number = 1;
      
      public function raz(param1:Sound, param2:Number, param3:Number, param4:Number, param5:Number)
      {
         super();
         this.cabor(param1,param2,param3,param4,param5);
      }
      
      public static function leqame(param1:Sound, param2:Number, param3:Number, param4:Number, param5:Number) : raz
      {
         var _loc6_:raz = null;
         if(param1 != null)
         {
            if(hybuhy == null)
            {
               return new raz(param1,param2,param3,param4,param5);
            }
            _loc6_ = hybuhy;
            _loc6_.cabor(param1,param2,param3,param4,param5);
            hybuhy = _loc6_.qesyqeno;
            _loc6_.qesyqeno = null;
            return _loc6_;
         }
         return null;
      }
      
      public static function byr(param1:raz) : void
      {
         param1.napyr();
         if(hybuhy == null)
         {
            hybuhy = param1;
         }
         else
         {
            param1.qesyqeno = hybuhy;
            hybuhy = param1;
         }
      }
      
      public function diryrozu() : Boolean
      {
         return this.judymu != null;
      }
      
      public function get sikyzo() : SoundChannel
      {
         return this.judymu;
      }
      
      public function get zybin() : Number
      {
         return this.judymu == null ? 0 : this.judymu.position;
      }
      
      public function cabor(param1:Sound, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("sound should not be null");
         }
         this.zib = param1;
         this.suwyc = param2;
         this.tacacihob = param5;
         this.jaji = (Math.sqrt(param4) - 1) / (param3 - param2);
         this.cokarola = 1;
         this.siluwar();
      }
      
      public function napyr() : void
      {
         this.jyfibaho();
         this.zib = null;
      }
      
      public function get cokarola() : Number
      {
         return this.bato;
      }
      
      public function set cokarola(param1:Number) : void
      {
         this.bato = param1;
         this.siluwar();
      }
      
      public function mosokovyn(param1:finajylom, param2:finajylom, param3:finajylom, param4:SoundTransform) : void
      {
         var _loc9_:Number = NaN;
         var _loc5_:Number = param2.kan - param1.kan;
         var _loc6_:Number = param2.zofydizug - param1.zofydizug;
         var _loc7_:Number = param2.qyririg - param1.qyririg;
         var _loc8_:Number = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_ + _loc7_ * _loc7_);
         if(_loc8_ < this.suwyc)
         {
            param4.volume = 1;
            param4.pan = 0;
         }
         else
         {
            _loc9_ = 1 + this.jaji * (_loc8_ - this.suwyc);
            _loc9_ = 1 / (_loc9_ * _loc9_);
            param4.volume = _loc9_;
            _loc8_ = 1 / _loc8_;
            _loc5_ *= _loc8_;
            _loc6_ *= _loc8_;
            _loc7_ *= _loc8_;
            param4.pan = (_loc5_ * param3.kan + _loc6_ * param3.zofydizug + _loc7_ * param3.qyririg) * (1 - _loc9_);
         }
      }
      
      public function hadugomap(param1:finajylom, param2:finajylom, param3:finajylom) : void
      {
         this.siluwar();
         if(this.judymu != null)
         {
            this.mosokovyn(param1,param2,param3,this.wet);
            this.wet.volume *= this.tuc;
            this.judymu.soundTransform = this.wet;
         }
      }
      
      public function qeguqugir(param1:int, param2:int) : SoundChannel
      {
         var kyqudeh:int = param1;
         var doqe:int = param2;
         this.siluwar();
         if(this.judymu != null)
         {
            this.judymu.stop();
         }
         try
         {
            return this.judymu = this.zib.play(kyqudeh,doqe);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function jyfibaho() : void
      {
         if(this.judymu != null)
         {
            this.judymu.stop();
            this.judymu = null;
         }
      }
      
      private function siluwar() : void
      {
         this.tuc = tove.tacacihob * this.bato;
      }
   }
}

