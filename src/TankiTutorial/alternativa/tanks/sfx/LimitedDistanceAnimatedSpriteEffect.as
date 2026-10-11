package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3DContainer;
   import flash.geom.ColorTransform;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: this is required to access some object3d function
   use namespace alternativa3d;

   public class LimitedDistanceAnimatedSpriteEffect extends PooledObject implements GraphicEffect
   {
      
      private static const position:Vector3 = new Vector3();
      
      private var sprite:AnimatedSprite3D;
      
      private var frameIndex:Number;
      
      private var framesPerMs:Number;
      
      private var numLoops:int;
      
      private var positionProvider:Object3DPositionProvider;
      
      private var nearDistance:Number;
      
      private var farDistance:Number;
      
      private var alphaMultiplier:Number;
      
      public function LimitedDistanceAnimatedSpriteEffect(pool:Pool)
      {
         super(pool);
         this.sprite = new AnimatedSprite3D(1,1);
         this.sprite.useShadowMap = true;
         this.sprite.useLight = false;
      }
      
      public function init(width:Number, height:Number, animation:TextureAnimation, rotation:Number, positionProvider:Object3DPositionProvider, originX:Number = 0.5, originY:Number = 0.5, colorTransform:ColorTransform = null, softAttenuation:Number = 130, blendMode:String = "normal", nearDistance:Number = 1000000, farDistance:Number = 1000000, alphaMultiplier:Number = 1) : void
      {
         this.alphaMultiplier = alphaMultiplier;
         this.initSprite(width,height,rotation,originX,originY,colorTransform,animation,softAttenuation,blendMode);
         this.nearDistance = nearDistance;
         this.farDistance = farDistance;
         positionProvider.initPosition(this.sprite);
         this.framesPerMs = 0.001 * animation.fps;
         this.positionProvider = positionProvider;
         this.frameIndex = 0;
         this.numLoops = 1;
      }
      
      public function addedToScene(container:Object3DContainer) : void
      {
         container.addChild(this.sprite);
      }
      
      public function play(deltaTime:int, camera:GameCamera) : Boolean
      {
         this.sprite.setFrameIndex(this.frameIndex);
         this.frameIndex += deltaTime * this.framesPerMs;
         this.positionProvider.updateObjectPosition(this.sprite,camera,deltaTime);
         if(this.numLoops > 0 && this.frameIndex >= this.sprite.getNumFrames())
         {
            --this.numLoops;
            if(this.numLoops == 0)
            {
               return false;
            }
            this.frameIndex -= this.sprite.getNumFrames();
         }
         position.x = this.sprite.x;
         position.y = this.sprite.y;
         position.z = this.sprite.z;
         var distance:Number = Number(position.distanceTo(camera.position));
         if(distance > this.farDistance)
         {
            this.sprite.visible = false;
         }
         else
         {
            this.sprite.visible = true;
            if(distance > this.nearDistance)
            {
               this.sprite.alpha = this.alphaMultiplier * (this.farDistance - distance) / (this.farDistance - this.nearDistance);
            }
            else
            {
               this.sprite.alpha = this.alphaMultiplier;
            }
         }
         return true;
      }
      
      public function destroy() : void
      {
         this.sprite.removeFromParent();
         this.sprite.clear();
         this.positionProvider.destroy();
         this.positionProvider = null;
         recycle();
      }
      
      public function kill() : void
      {
         this.numLoops = 1;
         this.frameIndex = this.sprite.getNumFrames();
      }
      
      private function initSprite(width:Number, height:Number, rotation:Number, originX:Number, originY:Number, colorTransform:ColorTransform, animation:TextureAnimation, softAttenuation:Number, blendMode:String) : void
      {
         this.sprite.width = width;
         this.sprite.height = height;
         this.sprite.rotation = rotation;
         this.sprite.originX = originX;
         this.sprite.originY = originY;
         this.sprite.blendMode = blendMode;
         this.sprite.colorTransform = colorTransform;
         this.sprite.softAttenuation = softAttenuation;
         this.sprite.setAnimationData(animation);
      }
   }
}

