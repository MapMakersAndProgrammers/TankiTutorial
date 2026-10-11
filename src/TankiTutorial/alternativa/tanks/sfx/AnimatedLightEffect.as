package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: this is needed for some object3d properties
   use namespace alternativa3d;

   public final class AnimatedLightEffect extends PooledObject implements GraphicEffect
   {
      
      public static const DEFAULT_MAX_DISTANCE:Number = 99999;
      
      public var light:OmniLight;
      
      private var positionProvider:Object3DPositionProvider;
      
      private var animation:LightAnimation;
      
      private var time:int;
      
      private var duration:int;
      
      private var looped:Boolean;
      
      private var alive:Boolean;
      
      private var maxDistance:Number;
      
      private var fadeDistance:Number;
      
      private var position:Vector3 = new Vector3();
      
      public function AnimatedLightEffect(pool:Pool)
      {
         super(pool);
         this.light = new OmniLight(0,0,0);
      }
      
      public function init(positionProvider:Object3DPositionProvider, animation:LightAnimation, maxDistance:Number = 99999, looped:Boolean = false) : void
      {
         this.initFromTime(positionProvider,animation.getLiveTime(),animation,maxDistance,looped);
      }
      
      public function initFromTime(positionProvider:Object3DPositionProvider, duration:int, animation:LightAnimation, maxDistance:Number = 99999, looped:Boolean = false) : void
      {
         this.positionProvider = positionProvider;
         this.duration = duration;
         this.time = 0;
         this.animation = animation;
         this.looped = looped;
         this.alive = true;
         this.maxDistance = maxDistance;
         this.fadeDistance = maxDistance / 4 * 3;
         positionProvider.initPosition(this.light);
      }
      
      public function initFromAnimation(positionProvider:Object3DPositionProvider, textureAnimation:TextureAnimation, animation:LightAnimation, maxDistance:Number = 99999, looped:Boolean = false) : void
      {
         this.initFromTime(positionProvider,textureAnimation.frames.length / textureAnimation.fps * 1000,animation,maxDistance,looped);
      }
      
      public function addedToScene(container:Object3DContainer) : void
      {
         container.addChild(this.light);
      }
      
      public function play(deltaTime:int, camera:GameCamera) : Boolean
      {
         var distance:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.alive)
         {
            this.animation.updateByTime(this.light,this.time,this.duration);
            this.positionProvider.updateObjectPosition(this.light,camera,deltaTime);
            this.time += deltaTime;
            if(this.time > this.duration)
            {
               if(this.looped)
               {
                  this.time %= this.duration;
               }
               else
               {
                  this.alive = false;
               }
            }
            this.position.x = this.light.x;
            this.position.y = this.light.y;
            this.position.z = this.light.z;
            distance = Number(this.position.distanceTo(camera.position));
            if(distance > this.fadeDistance)
            {
               _loc4_ = 1 - (distance - this.fadeDistance) / (this.maxDistance - this.fadeDistance);
               this.light.intensity *= _loc4_;
               this.light.visible = distance < this.maxDistance;
            }
            return this.alive;
         }
         return false;
      }
      
      public function destroy() : void
      {
         this.light.removeFromParent();
         this.animation = null;
         this.positionProvider = null;
      }
      
      public function kill() : void
      {
         this.alive = false;
      }
   }
}

