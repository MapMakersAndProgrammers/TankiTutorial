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
      
      private static const bakowy:Vector3 = new Vector3();
      
      private var wahy:AnimatedSprite3D;
      
      private var lamutameq:Number;
      
      private var luzulo:Number;
      
      private var goqo:int;
      
      private var toz:Object3DPositionProvider;
      
      private var qiqimary:Number;
      
      private var naliwy:Number;
      
      private var fidemujil:Number;
      
      public function LimitedDistanceAnimatedSpriteEffect(param1:Pool)
      {
         super(param1);
         this.wahy = new AnimatedSprite3D(1,1);
         this.wahy.useShadowMap = true;
         this.wahy.useLight = false;
      }
      
      public function init(param1:Number, param2:Number, param3:TextureAnimation, param4:Number, param5:Object3DPositionProvider, param6:Number = 0.5, param7:Number = 0.5, param8:ColorTransform = null, param9:Number = 130, param10:String = "normal", param11:Number = 1000000, param12:Number = 1000000, param13:Number = 1) : void
      {
         this.fidemujil = param13;
         this.initSprite(param1,param2,param4,param6,param7,param8,param3,param9,param10);
         this.qiqimary = param11;
         this.naliwy = param12;
         param5.initPosition(this.wahy);
         this.luzulo = 0.001 * param3.fps;
         this.toz = param5;
         this.lamutameq = 0;
         this.goqo = 1;
      }
      
      public function addedToScene(param1:Object3DContainer) : void
      {
         param1.addChild(this.wahy);
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
         this.wahy.setFrameIndex(this.lamutameq);
         this.lamutameq += param1 * this.luzulo;
         this.toz.updateObjectPosition(this.wahy,param2,param1);
         if(this.goqo > 0 && this.lamutameq >= this.wahy.getNumFrames())
         {
            --this.goqo;
            if(this.goqo == 0)
            {
               return false;
            }
            this.lamutameq -= this.wahy.getNumFrames();
         }
         bakowy.x = this.wahy.x;
         bakowy.y = this.wahy.y;
         bakowy.z = this.wahy.z;
         var _loc3_:Number = Number(bakowy.distanceTo(param2.position));
         if(_loc3_ > this.naliwy)
         {
            this.wahy.visible = false;
         }
         else
         {
            this.wahy.visible = true;
            if(_loc3_ > this.qiqimary)
            {
               this.wahy.alpha = this.fidemujil * (this.naliwy - _loc3_) / (this.naliwy - this.qiqimary);
            }
            else
            {
               this.wahy.alpha = this.fidemujil;
            }
         }
         return true;
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
         this.goqo = 1;
         this.lamutameq = this.wahy.getNumFrames();
      }
      
      private function initSprite(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:ColorTransform, param7:TextureAnimation, param8:Number, param9:String) : void
      {
         this.wahy.width = param1;
         this.wahy.height = param2;
         this.wahy.rotation = param3;
         this.wahy.originX = param4;
         this.wahy.originY = param5;
         this.wahy.blendMode = param9;
         this.wahy.colorTransform = param6;
         this.wahy.softAttenuation = param8;
         this.wahy.setAnimationData(param7);
      }
   }
}

