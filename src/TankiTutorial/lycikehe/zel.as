package lycikehe
{
   import flash.events.Event;
   import flash.media.SoundChannel;
   import gafaduzuw.finajylom;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   import kefy.lalyna;
   
   public class zel extends Wopowur implements rinude
   {
      
      public static var lawidy:int;
      
      private var zybin:finajylom = new finajylom();
      
      private var zib:raz;
      
      private var visadawa:int;
      
      private var racefom:int;
      
      private var sikyzo:SoundChannel;
      
      private var dalipaz:Boolean = false;
      
      private var sefoqar:Boolean = false;
      
      private var bepin:zulyvajy;
      
      public function zel(param1:fare)
      {
         super(param1);
      }
      
      public static function leqame(param1:lalyna, param2:finajylom, param3:raz, param4:int = 0, param5:int = 0, param6:zulyvajy = null) : zel
      {
         var _loc7_:zel = null;
         if(param3 != null)
         {
            _loc7_ = zel(param1.loq(zel));
            _loc7_.cabor(param2,param3,param4,param5,param6);
            return _loc7_;
         }
         return null;
      }
      
      public function cabor(param1:finajylom, param2:raz, param3:int = 0, param4:int = 0, param5:zulyvajy = null) : void
      {
         this.zybin.disy(param1);
         this.zib = param2;
         this.visadawa = param3;
         this.racefom = param4;
         this.bepin = param5;
         this.dalipaz = false;
         this.sefoqar = false;
      }
      
      public function qeguqugir(param1:int, param2:nufaneqog) : void
      {
         this.visadawa -= param1;
         if(this.visadawa > 0)
         {
            return;
         }
         if(!this.sefoqar)
         {
            this.sefoqar = true;
            this.sikyzo = this.zib.qeguqugir(this.racefom,1);
            if(this.sikyzo == null)
            {
               return;
            }
            this.sikyzo.addEventListener(Event.SOUND_COMPLETE,this.ben);
         }
         this.zib.hadugomap(param2.zybin,this.zybin,param2.memyjenut);
      }
      
      public function byr() : void
      {
         raz.byr(this.zib);
         this.zib = null;
         this.ben(null);
         if(this.bepin != null)
         {
            this.bepin.cywoqyw(this);
            this.bepin = null;
         }
         sapavaj();
      }
      
      public function wolyfami() : void
      {
         this.dalipaz = false;
      }
      
      public function set mavafujuh(param1:Boolean) : void
      {
         if(this.dalipaz == param1)
         {
            return;
         }
         if(!(this.dalipaz = param1))
         {
            this.ben(null);
         }
      }
      
      public function zimas(param1:finajylom) : void
      {
         param1.kan = this.zybin.kan;
         param1.zofydizug = this.zybin.zofydizug;
         param1.qyririg = this.zybin.qyririg;
      }
      
      public function get qyh() : int
      {
         return this.dalipaz ? 1 : 0;
      }
      
      private function ben(param1:Event) : void
      {
         if(this.sikyzo != null)
         {
            this.sikyzo.removeEventListener(Event.SOUND_COMPLETE,this.ben);
         }
         this.dalipaz = false;
         this.sikyzo = null;
      }
   }
}

