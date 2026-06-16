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
      
      private var wahy:AnimatedSprite3D;
      
      private var lamutameq:Number;
      
      private var luzulo:Number;
      
      private var maq:Boolean;
      
      private var toz:Object3DPositionProvider;
      
      public function AnimatedSpriteEffect(param1:Pool)
      {
         super(param1);
         this.wahy = new AnimatedSprite3D(1,1);
         this.wahy.softAttenuation = 150;
      }
      
      public function init(param1:Number, param2:Number, param3:TextureAnimation, param4:Number, param5:Number, param6:Object3DPositionProvider, param7:Number = 0.5, param8:Number = 0.5, param9:ColorTransform = null) : void
      {
         this.initSprite(param1,param2,param4,param7,param8,param9,param3);
         param6.initPosition(this.wahy);
         this.luzulo = 0.001 * param5;
         this.toz = param6;
         this.lamutameq = 0;
         this.maq = false;
      }
      
      public function initLooped(param1:Number, param2:Number, param3:TextureAnimation, param4:Number, param5:Number, param6:Object3DPositionProvider, param7:Number = 0.5, param8:Number = 0.5, param9:ColorTransform = null) : void
      {
         this.init(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         this.maq = true;
      }
      
      public function addedToScene(param1:Object3DContainer) : void
      {
         param1.addChild(this.wahy);
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
         if(this.maq || this.lamutameq < this.wahy.getNumFrames())
         {
            this.wahy.setFrameIndex(this.lamutameq);
            this.lamutameq += param1 * this.luzulo;
            this.toz.updateObjectPosition(this.wahy,param2,param1);
            return true;
         }
         return false;
      }
      
      public function destroy() : void
      {
         this.wahy.removeFromParent();
         this.wahy.clear();
         this.toz.destroy();
         this.toz = null;
         recycle();
      }
      
      public function kill() : void
      {
         this.maq = false;
         this.lamutameq = this.wahy.getNumFrames();
      }
      
      private function initSprite(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:ColorTransform, param7:TextureAnimation) : void
      {
         this.wahy.width = param1;
         this.wahy.height = param2;
         this.wahy.rotation = param3;
         this.wahy.originX = param4;
         this.wahy.originY = param5;
         this.wahy.colorTransform = param6;
         this.wahy.setAnimationData(param7);
      }
   }
}

