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
      
      private static const kudyvug:Vector3 = new Vector3();
      
      private var zib:Sound3D;
      
      private var visadawa:int;
      
      private var zyqa:int;
      
      private var tyjom:Object3D;
      
      private var channel:SoundChannel;
      
      private var dalipaz:Boolean;
      
      private var letere:Boolean;
      
      private var fat:Boolean;
      
      private var lecopojen:int;
      
      private var koc:Number;
      
      private var qihaq:Number;
      
      public function MobileSound3DEffect(param1:Pool)
      {
         super(param1);
      }
      
      public function init(param1:Sound3D, param2:Object3D, param3:int, param4:int) : void
      {
         this.zib = param1;
         this.tyjom = param2;
         this.visadawa = param3;
         this.zyqa = param4;
         this.fat = false;
         this.letere = false;
         this.dalipaz = false;
         this.lecopojen = 0;
         if(param1 != null)
         {
            this.koc = param1.volume;
         }
         this.qihaq = 0;
      }
      
      public function play(param1:int, param2:GameCamera) : void
      {
         if(!this.letere)
         {
            if(this.lecopojen < this.visadawa)
            {
               this.lecopojen += param1;
               return;
            }
            this.letere = true;
            this.channel = this.zib.play(0,this.zyqa);
            if(this.channel == null)
            {
               this.dalipaz = false;
               return;
            }
            this.channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         }
         kudyvug.x = this.tyjom.x;
         kudyvug.y = this.tyjom.y;
         kudyvug.z = this.tyjom.z;
         if(this.qihaq > 0)
         {
            this.koc -= this.qihaq * param1;
            if(this.koc <= 0)
            {
               this.qihaq = 0;
               this.koc = 0;
            }
            this.zib.volume = this.koc;
         }
         this.zib.checkVolume(param2.position,kudyvug,param2.memyjenut);
      }
      
      public function destroy() : void
      {
         Sound3D.destroy(this.zib);
         if(this.channel != null)
         {
            this.onSoundComplete(null);
         }
         this.tyjom = null;
         this.zib = null;
         recycle();
      }
      
      public function kill() : void
      {
         this.fat = true;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this.dalipaz == param1)
         {
            return;
         }
         if(!(this.dalipaz = param1))
         {
            this.onSoundComplete(null);
         }
      }
      
      public function readPosition(param1:Vector3) : void
      {
         param1.x = this.tyjom.x;
         param1.y = this.tyjom.y;
         param1.z = this.tyjom.z;
      }
      
      public function get numSounds() : int
      {
         return this.dalipaz && !this.fat ? 1 : 0;
      }
      
      public function fade(param1:int) : void
      {
         this.qihaq = this.koc / param1;
      }
      
      private function onSoundComplete(param1:Event) : void
      {
         if(this.channel != null)
         {
            this.channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
            this.channel = null;
         }
         this.dalipaz = false;
      }
   }
}

