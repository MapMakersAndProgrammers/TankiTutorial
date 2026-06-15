package alternativa.tanks.sfx
{
   import alternativa.math.Vector3;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   
   public class EngineSounds
   {
      
      public static const pubevih:int = 0;
      
      public static const qanigak:int = 1;
      
      public static const docic:int = 2;
      
      public static const quqec:int = 3;
      
      public static const daqizinan:int = 4;
      
      private static const fudofeqal:Number = 0.001;
      
      private var junyji:int = 0;
      
      private var nusu:Sound3D;
      
      private var lifeka:Sound3D;
      
      private var logada:Sound3D;
      
      private var luwecy:Sound3D;
      
      private var channel:SoundChannel;
      
      private var rawo:Boolean;
      
      private var jetagecon:Number = 1;
      
      private var fuvuwyv:Sound3D;
      
      public function EngineSounds(param1:Sound, param2:Sound, param3:Sound)
      {
         super();
         var _loc4_:Number = SoundOptions.suwyc;
         var _loc5_:Number = SoundOptions.bapewa;
         var _loc6_:Number = SoundOptions.fyvilyv;
         var _loc7_:Number = 1;
         this.lifeka = Sound3D.create(param1,_loc4_,_loc5_,_loc6_,2);
         this.logada = Sound3D.create(param2,_loc4_,_loc5_,_loc6_,_loc7_);
         this.luwecy = Sound3D.create(param3,_loc4_,_loc5_,_loc6_,_loc7_);
         this.nusu = this.lifeka;
      }
      
      public function update(param1:int, param2:Vector3, param3:Vector3, param4:Vector3) : void
      {
         if(this.junyji != pubevih)
         {
            if(this.rawo)
            {
               this.nusu.volume -= fudofeqal * param1;
               if(this.nusu.volume < this.jetagecon)
               {
                  this.rawo = false;
                  this.stop();
                  this.nusu = this.lifeka;
                  this.nusu.volume = this.junyji == qanigak ? 2 : 3;
                  this.nusu.play(0,10000);
               }
            }
            if(this.fuvuwyv != null)
            {
               this.channel = null;
               this.nusu.stop();
               this.nusu = this.fuvuwyv;
               this.nusu.volume = 1;
               this.nusu.play(0,10000);
               this.fuvuwyv = null;
            }
            this.nusu.checkVolume(param2,param3,param4);
         }
      }
      
      public function setSilentMode() : void
      {
         if(this.junyji != pubevih)
         {
            this.junyji = pubevih;
            this.stop();
         }
      }
      
      public function setIdleMode() : void
      {
         if(this.junyji != qanigak)
         {
            if(this.junyji == pubevih)
            {
               this.nusu = this.lifeka;
               this.nusu.volume = 1;
               this.nusu.play(0,1000);
            }
            else
            {
               this.rawo = true;
               this.jetagecon = 0.2;
            }
            this.junyji = qanigak;
         }
      }
      
      public function setAccelerationMode() : void
      {
         if(this.junyji == docic || this.junyji == quqec)
         {
            return;
         }
         this.rawo = false;
         this.junyji = docic;
         this.nusu.stop();
         this.nusu = this.logada;
         this.nusu.volume = 1;
         this.channel = this.nusu.play(0,0);
         if(this.channel != null)
         {
            this.channel.addEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         }
      }
      
      public function setTurningMode() : void
      {
         if(this.junyji != daqizinan)
         {
            if(this.junyji == qanigak)
            {
               if(!this.rawo)
               {
                  this.nusu.volume = 3;
               }
            }
            else
            {
               this.rawo = true;
            }
            this.jetagecon = 0.6;
            this.junyji = daqizinan;
         }
      }
      
      public function stop() : void
      {
         if(this.channel != null)
         {
            this.channel.removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
            this.channel = null;
         }
         this.nusu.stop();
      }
      
      public function destroy() : void
      {
         this.stop();
         Sound3D.destroy(this.lifeka);
         this.lifeka = null;
         Sound3D.destroy(this.logada);
         this.logada = null;
         Sound3D.destroy(this.luwecy);
         this.luwecy = null;
      }
      
      private function soundComplete(param1:Event) : void
      {
         if(this.channel == null || this.junyji != docic)
         {
            return;
         }
         this.channel.removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         this.junyji = quqec;
         this.luwecy.volume = this.logada.volume;
         this.fuvuwyv = this.luwecy;
      }
   }
}

