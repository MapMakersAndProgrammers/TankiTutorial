package lycikehe
{
   import alternativa.engine3d.core.Object3D;
   import flash.events.Event;
   import flash.media.SoundChannel;
   import gafaduzuw.finajylom;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class dicobokiq extends Wopowur implements rinude
   {
      
      private static const kudyvug:finajylom = new finajylom();
      
      private var zib:raz;
      
      private var visadawa:int;
      
      private var zyqa:int;
      
      private var tyjom:Object3D;
      
      private var sikyzo:SoundChannel;
      
      private var dalipaz:Boolean;
      
      private var letere:Boolean;
      
      private var fat:Boolean;
      
      private var lecopojen:int;
      
      private var koc:Number;
      
      private var qihaq:Number;
      
      public function dicobokiq(param1:fare)
      {
         super(param1);
      }
      
      public function cabor(param1:raz, param2:Object3D, param3:int, param4:int) : void
      {
         this.zib = param1;
         this.tyjom = param2;
         this.visadawa = param3;
         this.zyqa = param4;
         this.fat = false;
         this.letere = false;
         this.dalipaz = false;
         this.lecopojen = 0;
         if(param1 != null)
         {
            this.koc = param1.cokarola;
         }
         this.qihaq = 0;
      }
      
      public function qeguqugir(param1:int, param2:nufaneqog) : void
      {
         if(!this.letere)
         {
            if(this.lecopojen < this.visadawa)
            {
               this.lecopojen += param1;
               return;
            }
            this.letere = true;
            this.sikyzo = this.zib.qeguqugir(0,this.zyqa);
            if(this.sikyzo == null)
            {
               this.dalipaz = false;
               return;
            }
            this.sikyzo.addEventListener(Event.SOUND_COMPLETE,this.ben);
         }
         kudyvug.kan = this.tyjom.x;
         kudyvug.zofydizug = this.tyjom.y;
         kudyvug.qyririg = this.tyjom.z;
         if(this.qihaq > 0)
         {
            this.koc -= this.qihaq * param1;
            if(this.koc <= 0)
            {
               this.qihaq = 0;
               this.koc = 0;
            }
            this.zib.cokarola = this.koc;
         }
         this.zib.hadugomap(param2.zybin,kudyvug,param2.memyjenut);
      }
      
      public function byr() : void
      {
         raz.byr(this.zib);
         if(this.sikyzo != null)
         {
            this.ben(null);
         }
         this.tyjom = null;
         this.zib = null;
         sapavaj();
      }
      
      public function wolyfami() : void
      {
         this.fat = true;
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
         param1.kan = this.tyjom.x;
         param1.zofydizug = this.tyjom.y;
         param1.qyririg = this.tyjom.z;
      }
      
      public function get qyh() : int
      {
         return this.dalipaz && !this.fat ? 1 : 0;
      }
      
      public function zemare(param1:int) : void
      {
         this.qihaq = this.koc / param1;
      }
      
      private function ben(param1:Event) : void
      {
         if(this.sikyzo != null)
         {
            this.sikyzo.removeEventListener(Event.SOUND_COMPLETE,this.ben);
            this.sikyzo = null;
         }
         this.dalipaz = false;
      }
   }
}

