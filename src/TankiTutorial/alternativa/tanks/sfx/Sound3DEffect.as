package alternativa.tanks.sfx
{
   import flash.events.Event;
   import flash.media.SoundChannel;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   
   public class Sound3DEffect extends PooledObject implements ISound3DEffect
   {
      
      public static var lawidy:int;
      
      private var position:Vector3 = new Vector3();
      
      private var sound:Sound3D;
      
      private var delay:int;
      
      private var startTime:int;
      
      private var channel:SoundChannel;
      
      private var _enabled:Boolean = false;
      
      private var started:Boolean = false;
      
      private var destructionListener:ISoundEffectDestructionListener;
      
      public function Sound3DEffect(pool:Pool)
      {
         super(pool);
      }
      
      public static function create(objectPool:ObjectPool, position:Vector3, sound:Sound3D, delay:int = 0, startTime:int = 0, destructionListener:ISoundEffectDestructionListener = null) : Sound3DEffect
      {
         var effect:Sound3DEffect = null;
         if(sound != null)
         {
            effect = Sound3DEffect(objectPool.getObject(Sound3DEffect));
            effect.init(position,sound,delay,startTime,destructionListener);
            return effect;
         }
         return null;
      }
      
      public function init(position:Vector3, sound:Sound3D, delay:int = 0, startTime:int = 0, destructionListener:ISoundEffectDestructionListener = null) : void
      {
         this.position.copy(position);
         this.sound = sound;
         this.delay = delay;
         this.startTime = startTime;
         this.destructionListener = destructionListener;
         this._enabled = false;
         this.started = false;
      }
      
      public function play(deltaTime:int, camera:GameCamera) : void
      {
         this.delay -= deltaTime;
         if(this.delay > 0)
         {
            return;
         }
         if(!this.started)
         {
            this.started = true;
            this.channel = this.sound.play(this.startTime,1);
            if(this.channel == null)
            {
               return;
            }
            this.channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         }
         this.sound.checkVolume(camera.position,this.position,camera.xAxis);
      }
      
      public function destroy() : void
      {
         Sound3D.destroy(this.sound);
         this.sound = null;
         this.onSoundComplete(null);
         if(this.destructionListener != null)
         {
            this.destructionListener.onSoundEffectDestroyed(this);
            this.destructionListener = null;
         }
         recycle();
      }
      
      public function kill() : void
      {
         this._enabled = false;
      }
      
      public function set enabled(value:Boolean) : void
      {
         if(this._enabled == value)
         {
            return;
         }
         if(!(this._enabled = value))
         {
            this.onSoundComplete(null);
         }
      }
      
      public function readPosition(result:Vector3) : void
      {
         result.x = this.position.x;
         result.y = this.position.y;
         result.z = this.position.z;
      }
      
      public function get numSounds() : int
      {
         return this._enabled ? 1 : 0;
      }
      
      private function onSoundComplete(e:Event) : void
      {
         if(this.channel != null)
         {
            this.channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         }
         this._enabled = false;
         this.channel = null;
      }
   }
}

