package alternativa.tanks.sound
{
   import alternativa.math.Vector3;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.shared.camera.GameCamera;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import tutorial.commons.Shared;
   
   public class SoundManager implements ISoundManager
   {
      
      private static const MAX_SOUNDS:int = 10;
      
      private static const MAX_EFFECT_SOUNDS:int = 20;
      
      private static const position:Vector3 = new Vector3();
      
      public static var baseVolume:Number = 0;
      
      public static var wiwoginut:Number = 0;
      
      public static var nad:Number = 0;
      
      private var jahobyva:Number = 0.07;
      
      private var maxDistanceSqr:Number;
      
      private var effects:Vector.<SoundEffectData> = new Vector.<SoundEffectData>();
      
      private var numEffects:int;
      
      private var channels:Dictionary = new Dictionary();
      
      private var numSounds:int;
      
      private var stack:Vector.<int> = new Vector.<int>();
      
      private var muted:Boolean = false;
      
      public function SoundManager()
      {
         super();
      }
      
      public static function createSoundManager(sound:Sound) : ISoundManager
      {
         var channel:SoundChannel = sound.play(0,1,new SoundTransform(0));
         if(channel != null)
         {
            channel.stop();
            return new SoundManager();
         }
         return new DummySoundManager();
      }
      
      public function set maxDistance(value:Number) : void
      {
         this.maxDistanceSqr = value * value;
      }
      
      public function setMute(mute:Boolean) : void
      {
         this.muted = mute;
      }
      
      public function playSound(sound:Sound, startTime:int = 0, loops:int = 0, soundTransform:SoundTransform = null) : SoundChannel
      {
         if(this.cannotPlaySound(sound))
         {
            return null;
         }
         var channel:SoundChannel = sound.play(startTime,loops,soundTransform);
         if(channel != null)
         {
            this.addSoundChannel(channel);
         }
         return channel;
      }
      
      private function cannotPlaySound(sound:Sound) : Boolean
      {
         return this.muted || this.numSounds == MAX_SOUNDS || sound == null;
      }
      
      public function stopSound(channel:SoundChannel) : void
      {
         if(channel != null || this.channels[channel] != null)
         {
            this.removeSoundChannel(channel);
         }
      }
      
      public function stopAllSounds() : void
      {
         var channel:* = undefined;
         for(channel in this.channels)
         {
            this.removeSoundChannel(channel as SoundChannel);
         }
      }
      
      public function addEffect(effect:ISound3DEffect) : Boolean
      {
         if(this.canAddEffect(effect))
         {
            effect.enabled = true;
            this.effects.push(SoundEffectData.create(0,effect));
            ++this.numEffects;
            return true;
         }
         return false;
      }
      
      private function canAddEffect(effect:ISound3DEffect) : Boolean
      {
         return !this.muted && effect != null && this.getEffectIndex(effect) < 0;
      }
      
      public function removeEffect(effect:ISound3DEffect) : void
      {
         var effectData:SoundEffectData = null;
         var i:int = 0;
         while(i < this.numEffects)
         {
            effectData = this.effects[i];
            if(effectData.effect == effect)
            {
               effect.destroy();
               SoundEffectData.destroy(effectData);
               this.effects.splice(i,1);
               --this.numEffects;
               return;
            }
            i++;
         }
      }
      
      public function removeAllEffects() : void
      {
         var effectData:SoundEffectData = null;
         while(this.effects.length > 0)
         {
            effectData = this.effects.pop();
            effectData.effect.destroy();
            SoundEffectData.destroy(effectData);
         }
         this.numEffects = 0;
      }
      
      public function updateSoundEffects(deltaTime:int, camera:GameCamera) : void
      {
         var index:int = 0;
         if(this.numEffects > 0)
         {
            this.sortEffects(camera.position);
            index = this.processEffectsInActiveRange(deltaTime,camera);
            this.deactivateRemainingEffects(index);
         }
         this.switchBaseVolume();
      }
      
      private function switchBaseVolume() : void
      {
         if(wiwoginut > 0)
         {
            wiwoginut += 0.03;
            if(wiwoginut > 1)
            {
               wiwoginut = 1;
            }
         }
         if(nad < Shared.volume)
         {
            nad += 0.1;
            if(nad > Shared.volume)
            {
               nad = Shared.volume;
            }
         }
         else
         {
            nad -= 0.1;
            if(nad < Shared.volume)
            {
               nad = Shared.volume;
            }
         }
         baseVolume = wiwoginut * nad;
      }
      
      private function processEffectsInActiveRange(deltaTime:int, camera:GameCamera) : int
      {
         var effectData:SoundEffectData = null;
         var i:int = 0;
         var numEffectSounds:int = 0;
         var numActiveSounds:int = 0;
         i = 0;
         while(i < this.numEffects)
         {
            effectData = this.effects[i];
            numEffectSounds = int(effectData.effect.numSounds);
            if(numEffectSounds == 0)
            {
               effectData.effect.destroy();
               SoundEffectData.destroy(effectData);
               this.effects.splice(i,1);
               --this.numEffects;
               i--;
            }
            else
            {
               if(effectData.distanceSqr > this.maxDistanceSqr || numActiveSounds + numEffectSounds > MAX_EFFECT_SOUNDS)
               {
                  break;
               }
               effectData.effect.enabled = true;
               effectData.effect.play(deltaTime,camera);
               numActiveSounds += numEffectSounds;
            }
            i++;
         }
         return i;
      }
      
      private function deactivateRemainingEffects(index:int) : void
      {
         var effectData:SoundEffectData = null;
         var i:int = index;
         while(i < this.numEffects)
         {
            effectData = this.effects[i];
            effectData.effect.enabled = false;
            if(effectData.effect.numSounds == 0)
            {
               effectData.effect.destroy();
               SoundEffectData.destroy(effectData);
               this.effects.splice(i,1);
               --this.numEffects;
               i--;
            }
            i++;
         }
      }
      
      private function addSoundChannel(channel:SoundChannel) : void
      {
         channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         this.channels[channel] = true;
         ++this.numSounds;
      }
      
      private function removeSoundChannel(channel:SoundChannel) : void
      {
         channel.stop();
         channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         delete this.channels[channel];
         --this.numSounds;
      }
      
      private function onSoundComplete(e:Event) : void
      {
         this.stopSound(e.target as SoundChannel);
      }
      
      private function getEffectIndex(effect:ISound3DEffect) : int
      {
         var effectData:SoundEffectData = null;
         var i:int = 0;
         while(i < this.numEffects)
         {
            effectData = this.effects[i];
            if(effectData.effect == effect)
            {
               return i;
            }
            i++;
         }
         return -1;
      }
      
      private function sortEffects(cameraPosition:Vector3) : void
      {
         var i:int = 0;
         var j:int = 0;
         var stackSize:int = 0;
         var pivot:Number = NaN;
         var effectData:SoundEffectData = null;
         var a:SoundEffectData = null;
         var b:SoundEffectData = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var pivotData:SoundEffectData = null;
         var left:int = 0;
         var right:int = this.numEffects - 1;
         i = 0;
         while(i < this.numEffects)
         {
            effectData = this.effects[i];
            effectData.effect.readPosition(position);
            dx = cameraPosition.x - position.x;
            dy = cameraPosition.y - position.y;
            dz = cameraPosition.z - position.z;
            effectData.distanceSqr = dx * dx + dy * dy + dz * dz;
            i++;
         }
         if(this.numEffects == 1)
         {
            return;
         }
         this.stack[0] = left;
         this.stack[1] = right;
         stackSize = 2;
         while(stackSize > 0)
         {
            j = right = this.stack[--stackSize];
            i = left = this.stack[--stackSize];
            pivotData = this.effects[right + left >> 1];
            pivot = Number(pivotData.distanceSqr);
            do
            {
               a = this.effects[i];
               while(a.distanceSqr < pivot)
               {
                  i++;
                  a = this.effects[i];
               }
               b = this.effects[j];
               while(b.distanceSqr > pivot)
               {
                  j--;
                  b = this.effects[j];
               }
               if(i <= j)
               {
                  this.effects[i++] = b;
                  this.effects[j--] = a;
               }
            }
            while(i <= j);
            if(left < j)
            {
               this.stack[stackSize++] = left;
               this.stack[stackSize++] = j;
            }
            if(i < right)
            {
               this.stack[stackSize++] = i;
               this.stack[stackSize++] = right;
            }
         }
      }
   }
}

