package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import flash.events.Event;
   import flash.media.SoundChannel;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   
   public class MobileSound3DEffect extends PooledObject implements ISound3DEffect
   {
      
      private static const position:Vector3 = new Vector3();
      
      private var sound:Sound3D;
      
      private var delay:int;
      
      private var loops:int;
      
      private var object:Object3D;
      
      private var channel:SoundChannel;
      
      private var _enabled:Boolean;
      
      private var started:Boolean;
      
      private var killed:Boolean;
      
      private var time:int;
      
      private var volume:Number;
      
      private var fadeSpeed:Number;
      
      public function MobileSound3DEffect(pool:Pool)
      {
         super(pool);
      }
      
      public function init(sound:Sound3D, object:Object3D, delay:int, loops:int) : void
      {
         this.sound = sound;
         this.object = object;
         this.delay = delay;
         this.loops = loops;
         this.killed = false;
         this.started = false;
         this._enabled = false;
         this.time = 0;
         if(sound != null)
         {
            this.volume = sound.volume;
         }
         this.fadeSpeed = 0;
      }
      
      public function play(deltaTime:int, camera:GameCamera) : void
      {
         if(!this.started)
         {
            if(this.time < this.delay)
            {
               this.time += deltaTime;
               return;
            }
            this.started = true;
            this.channel = this.sound.play(0,this.loops);
            if(this.channel == null)
            {
               this._enabled = false;
               return;
            }
            this.channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         }
         position.x = this.object.x;
         position.y = this.object.y;
         position.z = this.object.z;
         if(this.fadeSpeed > 0)
         {
            this.volume -= this.fadeSpeed * deltaTime;
            if(this.volume <= 0)
            {
               this.fadeSpeed = 0;
               this.volume = 0;
            }
            this.sound.volume = this.volume;
         }
         this.sound.checkVolume(camera.position,position,camera.xAxis);
      }
      
      public function destroy() : void
      {
         Sound3D.destroy(this.sound);
         if(this.channel != null)
         {
            this.onSoundComplete(null);
         }
         this.object = null;
         this.sound = null;
         recycle();
      }
      
      public function kill() : void
      {
         this.killed = true;
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
         result.x = this.object.x;
         result.y = this.object.y;
         result.z = this.object.z;
      }
      
      public function get numSounds() : int
      {
         return this._enabled && !this.killed ? 1 : 0;
      }
      
      public function fade(fadeTime:int) : void
      {
         this.fadeSpeed = this.volume / fadeTime;
      }
      
      private function onSoundComplete(e:Event) : void
      {
         if(this.channel != null)
         {
            this.channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
            this.channel = null;
         }
         this._enabled = false;
      }
   }
}

