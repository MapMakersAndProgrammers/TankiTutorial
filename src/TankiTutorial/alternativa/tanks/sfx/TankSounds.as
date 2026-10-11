package alternativa.tanks.sfx
{
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import tutorial.commons.Assets;
   
   public class TankSounds implements ISound3DEffect
   {
      
      private static const position:Vector3 = new Vector3();
      
      private var tank:Tank;
      
      private var engineSounds:EngineSounds;
      
      private var turretSound:Sound3D;
      
      private var engineMode:int = 1;
      
      private var _enabled:Boolean = false;
      
      private var _turretSoundEnabled:Boolean;
      
      private var engineSoundsLoaded:Boolean = false;
      
      private var turretSoundLoaded:Boolean = false;
      
      public function TankSounds()
      {
         super();
      }
      
      private function initEngineSound() : void
      {
         var idleSound:Sound = null;
         var startSound:Sound = null;
         var movingSound:Sound = null;
         if(!this.engineSoundsLoaded)
         {
            idleSound = Assets.getData("engine_idle",Sound);
            startSound = Assets.getData("engine_start",Sound);
            movingSound = Assets.getData("engine_moving",Sound);
            if(idleSound != null && startSound != null && movingSound != null)
            {
               this.engineSounds = new EngineSounds(idleSound,startSound,movingSound);
               this.engineSoundsLoaded = true;
            }
         }
      }
      
      private function initTurretSound() : void
      {
         var sound:Sound = null;
         if(!this.turretSoundLoaded)
         {
            sound = Assets.getData("engine_turret",Sound);
            if(sound != null)
            {
               this.turretSound = Sound3D.create(sound,500,2000,5,0.5);
               this.turretSoundLoaded = true;
            }
         }
      }
      
      public function setIdleMode() : void
      {
         this.initEngineSound();
         if(this.engineSoundsLoaded)
         {
            this.engineMode = EngineSounds.IDLE_MODE;
            if(this._enabled)
            {
               this.engineSounds.setIdleMode();
            }
         }
      }
      
      public function setSilentMode() : void
      {
         this.initEngineSound();
         if(this.engineSoundsLoaded)
         {
            this.engineMode = EngineSounds.SILENT_MODE;
            if(this._enabled)
            {
               this.engineSounds.setSilentMode();
            }
         }
      }
      
      public function setAccelerationMode() : void
      {
         this.initEngineSound();
         if(this.engineSoundsLoaded)
         {
            this.engineMode = EngineSounds.ACCELERATION_MODE;
            if(this._enabled)
            {
               this.engineSounds.setAccelerationMode();
            }
         }
      }
      
      public function setTurningMode() : void
      {
         this.initEngineSound();
         if(this.engineSoundsLoaded)
         {
            this.engineMode = EngineSounds.TURNING_MODE;
            if(this._enabled)
            {
               this.engineSounds.setTurningMode();
            }
         }
      }
      
      public function setTank(param1:Tank) : void
      {
         this.tank = param1;
      }
      
      public function playTurretSound(param1:Boolean) : void
      {
         var channel:SoundChannel = null;
         this.initTurretSound();
         if(this.turretSoundLoaded)
         {
            if(this._enabled)
            {
               if(param1 && this._turretSoundEnabled)
               {
                  if(!this.turretSound.isPlaying())
                  {
                     channel = this.turretSound.play(100,0);
                     if(channel != null)
                     {
                        channel.addEventListener(Event.SOUND_COMPLETE,this.onTurretSoundComplete);
                     }
                  }
               }
               else if(this.turretSound.isPlaying())
               {
                  this.turretSound.stop();
               }
            }
         }
      }
      
      private function onTurretSoundComplete(e:Event) : void
      {
         if(this._turretSoundEnabled)
         {
            this.turretSound.play(3000,9999);
         }
      }
      
      public function set turretSoundEnabled(value:Boolean) : void
      {
         if(this._turretSoundEnabled != value)
         {
            this._turretSoundEnabled = value;
            if(!this._turretSoundEnabled)
            {
               if(this.turretSoundLoaded)
               {
                  this.turretSound.stop();
               }
            }
         }
      }
      
      public function play(deltaTime:int, camera:GameCamera) : void
      {
         if(this.tank != null && this._enabled)
         {
            position.copy(this.tank.tankBody.body.state.position);
            if(this.engineSoundsLoaded)
            {
               this.engineSounds.update(deltaTime,camera.position,position,camera.xAxis);
            }
            if(this.turretSoundLoaded)
            {
               this.turretSound.checkVolume(camera.position,position,camera.xAxis);
            }
         }
      }
      
      public function destroy() : void
      {
         if(this.engineSoundsLoaded)
         {
            this.engineSounds.stop();
         }
         if(this.turretSoundLoaded)
         {
            this.turretSound.stop();
         }
      }
      
      public function kill() : void
      {
      }
      
      public function get numSounds() : int
      {
         return 2;
      }
      
      public function readPosition(result:Vector3) : void
      {
         result.copy(this.tank.tankBody.body.state.position);
      }
      
      public function set enabled(value:Boolean) : void
      {
         if(this._enabled != value)
         {
            this._enabled = value;
            this.updateSounds();
         }
      }
      
      private function updateSounds() : void
      {
         if(this._enabled)
         {
            if(this.engineSoundsLoaded)
            {
               switch(this.engineMode)
               {
                  case EngineSounds.IDLE_MODE:
                     this.engineSounds.setIdleMode();
                     break;
                  case EngineSounds.ACCELERATION_MODE:
                     this.engineSounds.setAccelerationMode();
                     break;
                  case EngineSounds.TURNING_MODE:
                     this.engineSounds.setTurningMode();
               }
            }
         }
         else
         {
            if(this.turretSoundLoaded)
            {
               this.turretSound.stop();
            }
            if(this.engineSoundsLoaded)
            {
               this.engineSounds.setSilentMode();
            }
         }
      }
   }
}

