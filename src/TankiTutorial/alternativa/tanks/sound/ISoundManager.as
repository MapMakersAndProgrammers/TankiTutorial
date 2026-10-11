package alternativa.tanks.sound
{
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.shared.camera.GameCamera;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public interface ISoundManager
   {
      
      function playSound(sound:Sound, startTime:int = 0, loops:int = 0, soundTransform:SoundTransform = null) : SoundChannel;
      
      function stopSound(channel:SoundChannel) : void;
      
      function stopAllSounds() : void;
      
      function addEffect(effect:ISound3DEffect) : Boolean;
      
      function removeEffect(effect:ISound3DEffect) : void;
      
      function removeAllEffects() : void;
      
      function updateSoundEffects(deltaTime:int, camera:GameCamera) : void;
      
      function set maxDistance(value:Number) : void;
      
      function setMute(mute:Boolean) : void;
   }
}

