package alternativa.tanks.sfx
{
   import flash.events.Event;
   import flash.media.SoundChannel;
   import gafaduzuw.finajylom;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   import kefy.lalyna;
   
   public class Sound3DEffect extends Wopowur implements rinude
   {
      
      public static var lawidy:int;
      
      private var position:finajylom = new finajylom();
      
      private var zib:Sound3D;
      
      private var visadawa:int;
      
      private var racefom:int;
      
      private var channel:SoundChannel;
      
      private var dalipaz:Boolean = false;
      
      private var sefoqar:Boolean = false;
      
      private var bepin:zulyvajy;
      
      public function Sound3DEffect(param1:fare)
      {
         super(param1);
      }
      
      public static function create(param1:lalyna, param2:finajylom, param3:Sound3D, param4:int = 0, param5:int = 0, param6:zulyvajy = null) : Sound3DEffect
      {
         var _loc7_:Sound3DEffect = null;
         if(param3 != null)
         {
            _loc7_ = Sound3DEffect(param1.loq(Sound3DEffect));
            _loc7_.init(param2,param3,param4,param5,param6);
            return _loc7_;
         }
         return null;
      }
      
      public function init(param1:finajylom, param2:Sound3D, param3:int = 0, param4:int = 0, param5:zulyvajy = null) : void
      {
         this.position.disy(param1);
         this.zib = param2;
         this.visadawa = param3;
         this.racefom = param4;
         this.bepin = param5;
         this.dalipaz = false;
         this.sefoqar = false;
      }
      
      public function play(param1:int, param2:nufaneqog) : void
      {
         this.visadawa -= param1;
         if(this.visadawa > 0)
         {
            return;
         }
         if(!this.sefoqar)
         {
            this.sefoqar = true;
            this.channel = this.zib.play(this.racefom,1);
            if(this.channel == null)
            {
               return;
            }
            this.channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         }
         this.zib.checkVolume(param2.position,this.position,param2.memyjenut);
      }
      
      public function destroy() : void
      {
         Sound3D.destroy(this.zib);
         this.zib = null;
         this.onSoundComplete(null);
         if(this.bepin != null)
         {
            this.bepin.cywoqyw(this);
            this.bepin = null;
         }
         recycle();
      }
      
      public function kill() : void
      {
         this.dalipaz = false;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this.dalipaz == param1)
         {
            return;
         }
         if(!(this.dalipaz = param1))
         {
            this.onSoundComplete(null);
         }
      }
      
      public function readPosition(param1:finajylom) : void
      {
         param1.kan = this.position.kan;
         param1.zofydizug = this.position.zofydizug;
         param1.qyririg = this.position.qyririg;
      }
      
      public function get numSounds() : int
      {
         return this.dalipaz ? 1 : 0;
      }
      
      private function onSoundComplete(param1:Event) : void
      {
         if(this.channel != null)
         {
            this.channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         }
         this.dalipaz = false;
         this.channel = null;
      }
   }
}

