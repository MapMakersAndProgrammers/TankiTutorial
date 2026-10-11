package alternativa.tanks.sfx
{
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import alternativa.math.Vector3;
   import alternativa.tanks.sound.SoundManager;
   
   public class Sound3D
   {
      
      private static var pool:Sound3D;
      
      internal var next:Sound3D;
      
      private var nearRadius:Number;
      
      private var jaji:Number;
      
      private var sound:Sound;
      
      private var _channel:SoundChannel;
      
      private var soundTransform:SoundTransform = new SoundTransform(0);
      
      private var _volume:Number = 1;
      
      private var tacacihob:Number = 1;
      
      private var effectiveVolume:Number = 1;
      
      public function Sound3D(sound:Sound, nearRadius:Number, farRadius:Number, param4:Number, param5:Number)
      {
         super();
         this.init(sound,nearRadius,farRadius,param4,param5);
      }
      
      public static function create(sound:Sound, nearRadius:Number, farRadius:Number, param4:Number, param5:Number) : Sound3D
      {
         var sound3D:Sound3D = null;
         if(sound != null)
         {
            if(pool == null)
            {
               return new Sound3D(sound,nearRadius,farRadius,param4,param5);
            }
            sound3D = pool;
            sound3D.init(sound,nearRadius,farRadius,param4,param5);
            pool = sound3D.next;
            sound3D.next = null;
            return sound3D;
         }
         return null;
      }
      
      public static function destroy(sound3D:Sound3D) : void
      {
         sound3D.clear();
         if(pool == null)
         {
            pool = sound3D;
         }
         else
         {
            sound3D.next = pool;
            pool = sound3D;
         }
      }
      
      public function isPlaying() : Boolean
      {
         return this._channel != null;
      }
      
      public function get channel() : SoundChannel
      {
         return this._channel;
      }
      
      public function get position() : Number
      {
         return this._channel == null ? 0 : this._channel.position;
      }
      
      public function init(sound:Sound, nearRadius:Number, farRadius:Number, param4:Number, param5:Number) : void
      {
         if(sound == null)
         {
            throw new ArgumentError("sound should not be null");
         }
         this.sound = sound;
         this.nearRadius = nearRadius;
         this.tacacihob = param5;
         this.jaji = (Math.sqrt(param4) - 1) / (farRadius - nearRadius);
         this.volume = 1;
         this.updateEffectiveVolume();
      }
      
      public function clear() : void
      {
         this.stop();
         this.sound = null;
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(value:Number) : void
      {
         this._volume = value;
         this.updateEffectiveVolume();
      }
      
      public function calculateSoundProperties(cameraPosition:Vector3, soundPosition:Vector3, cameraXAxis:Vector3, result:SoundTransform) : void
      {
         var _loc9_:Number = NaN;
         var dx:Number = soundPosition.x - cameraPosition.x;
         var dy:Number = soundPosition.y - cameraPosition.y;
         var dz:Number = soundPosition.z - cameraPosition.z;
         var distance:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
         if(distance < this.nearRadius)
         {
            result.volume = 1;
            result.pan = 0;
         }
         else
         {
            _loc9_ = 1 + this.jaji * (distance - this.nearRadius);
            _loc9_ = 1 / (_loc9_ * _loc9_);
            result.volume = _loc9_;
            distance = 1 / distance;
            dx *= distance;
            dy *= distance;
            dz *= distance;
            result.pan = (dx * cameraXAxis.x + dy * cameraXAxis.y + dz * cameraXAxis.z) * (1 - _loc9_);
         }
      }
      
      public function checkVolume(cameraPosition:Vector3, soundPosition:Vector3, cameraXAxis:Vector3) : void
      {
         this.updateEffectiveVolume();
         if(this._channel != null)
         {
            this.calculateSoundProperties(cameraPosition,soundPosition,cameraXAxis,this.soundTransform);
            this.soundTransform.volume *= this.effectiveVolume;
            this._channel.soundTransform = this.soundTransform;
         }
      }
      
      public function play(param1:int, param2:int) : SoundChannel
      {
         var startTime:int = param1;
         var loops:int = param2;
         this.updateEffectiveVolume();
         if(this._channel != null)
         {
            this._channel.stop();
         }
         try
         {
            return this._channel = this.sound.play(startTime,loops);
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function stop() : void
      {
         if(this._channel != null)
         {
            this._channel.stop();
            this._channel = null;
         }
      }
      
      private function updateEffectiveVolume() : void
      {
         this.effectiveVolume = SoundManager.baseVolume * this._volume;
      }
   }
}

