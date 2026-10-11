package alternativa.tanks.sfx
{
   import alternativa.math.Vector3;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   
   public class EngineSounds
   {
      
      public static const SILENT_MODE:int = 0;
      
      public static const IDLE_MODE:int = 1;
      
      public static const ACCELERATION_MODE:int = 2;
      
      public static const MOVING_MODE:int = 3;
      
      public static const TURNING_MODE:int = 4;
      
      private static const FADE_SPEED:Number = 0.001;
      
      private var mode:int = 0;
      
      private var currentSound:Sound3D;
      
      private var idleSound:Sound3D;
      
      private var startSound:Sound3D;
      
      private var movingSound:Sound3D;
      
      private var channel:SoundChannel;
      
      private var fading:Boolean;
      
      private var minVolume:Number = 1;
      
      private var nextSound:Sound3D;
      
      public function EngineSounds(idleSound:Sound, startSound:Sound, movingSound:Sound)
      {
         super();
         var nearRadius:Number = SoundOptions.nearRadius;
         var farRadius:Number = SoundOptions.farRadius;
         var _loc6_:Number = SoundOptions.fyvilyv;
         var volume:Number = 1;
         this.idleSound = Sound3D.create(idleSound,nearRadius,farRadius,_loc6_,2);
         this.startSound = Sound3D.create(startSound,nearRadius,farRadius,_loc6_,volume);
         this.movingSound = Sound3D.create(movingSound,nearRadius,farRadius,_loc6_,volume);
         this.currentSound = this.idleSound;
      }
      
      public function update(deltaTime:int, cameraPosition:Vector3, position:Vector3, cameraXAxis:Vector3) : void
      {
         if(this.mode != SILENT_MODE)
         {
            if(this.fading)
            {
               this.currentSound.volume -= FADE_SPEED * deltaTime;
               if(this.currentSound.volume < this.minVolume)
               {
                  this.fading = false;
                  this.stop();
                  this.currentSound = this.idleSound;
                  this.currentSound.volume = this.mode == IDLE_MODE ? 2 : 3;
                  this.currentSound.play(0,10000);
               }
            }
            if(this.nextSound != null)
            {
               this.channel = null;
               this.currentSound.stop();
               this.currentSound = this.nextSound;
               this.currentSound.volume = 1;
               this.currentSound.play(0,10000);
               this.nextSound = null;
            }
            this.currentSound.checkVolume(cameraPosition,position,cameraXAxis);
         }
      }
      
      public function setSilentMode() : void
      {
         if(this.mode != SILENT_MODE)
         {
            this.mode = SILENT_MODE;
            this.stop();
         }
      }
      
      public function setIdleMode() : void
      {
         if(this.mode != IDLE_MODE)
         {
            if(this.mode == SILENT_MODE)
            {
               this.currentSound = this.idleSound;
               this.currentSound.volume = 1;
               this.currentSound.play(0,1000);
            }
            else
            {
               this.fading = true;
               this.minVolume = 0.2;
            }
            this.mode = IDLE_MODE;
         }
      }
      
      public function setAccelerationMode() : void
      {
         if(this.mode == ACCELERATION_MODE || this.mode == MOVING_MODE)
         {
            return;
         }
         this.fading = false;
         this.mode = ACCELERATION_MODE;
         this.currentSound.stop();
         this.currentSound = this.startSound;
         this.currentSound.volume = 1;
         this.channel = this.currentSound.play(0,0);
         if(this.channel != null)
         {
            this.channel.addEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         }
      }
      
      public function setTurningMode() : void
      {
         if(this.mode != TURNING_MODE)
         {
            if(this.mode == IDLE_MODE)
            {
               if(!this.fading)
               {
                  this.currentSound.volume = 3;
               }
            }
            else
            {
               this.fading = true;
            }
            this.minVolume = 0.6;
            this.mode = TURNING_MODE;
         }
      }
      
      public function stop() : void
      {
         if(this.channel != null)
         {
            this.channel.removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
            this.channel = null;
         }
         this.currentSound.stop();
      }
      
      public function destroy() : void
      {
         this.stop();
         Sound3D.destroy(this.idleSound);
         this.idleSound = null;
         Sound3D.destroy(this.startSound);
         this.startSound = null;
         Sound3D.destroy(this.movingSound);
         this.movingSound = null;
      }
      
      private function soundComplete(e:Event) : void
      {
         if(this.channel == null || this.mode != ACCELERATION_MODE)
         {
            return;
         }
         this.channel.removeEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         this.mode = MOVING_MODE;
         this.movingSound.volume = this.startSound.volume;
         this.nextSound = this.movingSound;
      }
   }
}

