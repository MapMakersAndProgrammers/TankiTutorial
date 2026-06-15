package alternativa.tanks.sound
{
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.shared.camera.GameCamera;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public interface ISoundManager
   {
      
      function playSound(param1:Sound, param2:int = 0, param3:int = 0, param4:SoundTransform = null) : SoundChannel;
      
      function stopSound(param1:SoundChannel) : void;
      
      function stopAllSounds() : void;
      
      function addEffect(param1:ISound3DEffect) : Boolean;
      
      function removeEffect(param1:ISound3DEffect) : void;
      
      function removeAllEffects() : void;
      
      function updateSoundEffects(param1:int, param2:GameCamera) : void;
      
      function set maxDistance(param1:Number) : void;
      
      function setMute(param1:Boolean) : void;
   }
}

