package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3DContainer;
   import flash.geom.ColorTransform;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: this is needed for some object3d properties
   use namespace alternativa3d;

   public class AnimatedSpriteEffect extends PooledObject implements GraphicEffect
   {
      
      private var sprite:AnimatedSprite3D;
      
      private var frameIndex:Number;
      
      private var luzulo:Number;
      
      private var looped:Boolean;
      
      private var positionProvider:Object3DPositionProvider;
      
      public function AnimatedSpriteEffect(param1:Pool)
      {
         super(param1);
         this.sprite = new AnimatedSprite3D(1,1);
         this.sprite.softAttenuation = 150;
      }
      
      public function init(width:Number, height:Number, animation:TextureAnimation, rotation:Number, fps:Number, param6:Object3DPositionProvider, originX:Number = 0.5, originY:Number = 0.5, colorTransform:ColorTransform = null) : void
      {
         this.initSprite(width,height,rotation,originX,originY,colorTransform,animation);
         param6.initPosition(this.sprite);
         this.luzulo = 0.001 * fps;
         this.positionProvider = param6;
         this.frameIndex = 0;
         this.looped = false;
      }
      
      public function initLooped(width:Number, height:Number, animation:TextureAnimation, rotation:Number, fps:Number, param6:Object3DPositionProvider, originX:Number = 0.5, originY:Number = 0.5, colorTransform:ColorTransform = null) : void
      {
         this.init(width,height,animation,rotation,fps,param6,originX,originY,colorTransform);
         this.looped = true;
      }
      
      public function addedToScene(container:Object3DContainer) : void
      {
         container.addChild(this.sprite);
      }
      
      public function play(deltaTime:int, camera:GameCamera) : Boolean
      {
         if(this.looped || this.frameIndex < this.sprite.getNumFrames())
         {
            this.sprite.setFrameIndex(this.frameIndex);
            this.frameIndex += deltaTime * this.luzulo;
            this.positionProvider.updateObjectPosition(this.sprite,camera,deltaTime);
            return true;
         }
         return false;
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
         this.looped = false;
         this.frameIndex = this.sprite.getNumFrames();
      }
      
      private function initSprite(width:Number, height:Number, rotation:Number, originX:Number, originY:Number, colorTransform:ColorTransform, animation:TextureAnimation) : void
      {
         this.sprite.width = width;
         this.sprite.height = height;
         this.sprite.rotation = rotation;
         this.sprite.originX = originX;
         this.sprite.originY = originY;
         this.sprite.colorTransform = colorTransform;
         this.sprite.setAnimationData(animation);
      }
   }
}

