package alternativa.tanks.sound
{
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.shared.camera.GameCamera;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class DummySoundManager implements ISoundManager
   {
      
      public function DummySoundManager()
      {
         super();
      }
      
      public function set maxDistance(value:Number) : void
      {
      }
      
      public function playSound(sound:Sound, startTime:int = 0, loops:int = 0, soundTransform:SoundTransform = null) : SoundChannel
      {
         return null;
      }
      
      public function stopSound(channel:SoundChannel) : void
      {
      }
      
      public function stopAllSounds() : void
      {
      }
      
      public function addEffect(effect:ISound3DEffect) : Boolean
      {
         return false;
      }
      
      public function removeEffect(effect:ISound3DEffect) : void
      {
      }
      
      public function removeAllEffects() : void
      {
      }
      
      public function updateSoundEffects(deltaTime:int, camera:GameCamera) : void
      {
      }
      
      public function setMute(mute:Boolean) : void
      {
      }
   }
}

