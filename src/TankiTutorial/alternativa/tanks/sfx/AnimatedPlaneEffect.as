package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: this is for some object3d property
   use namespace alternativa3d;

   public class AnimatedPlaneEffect extends PooledObject implements GraphicEffect
   {
      
      private static const BASE_SIZE:Number = 100;
      
      private var tytofu:Number;
      
      private var scale:Number;
      
      private var baseScale:Number;
      
      private var plane:AnimatedPlane;
      
      private var time:int;
      
      private var duration:int;
      
      public function AnimatedPlaneEffect(param1:Pool)
      {
         super(param1);
         this.plane = new AnimatedPlane(BASE_SIZE);
      }
      
      public function init(size:Number, position:Vector3, rotation:Vector3, fps:Number, animation:TextureAnimation, param6:Number) : void
      {
         this.plane.init(animation,0.001 * fps);
         this.duration = this.plane.getOneLoopTime();
         this.time = 0;
         this.tytofu = 0.001 * param6;
         this.baseScale = size / BASE_SIZE;
         this.scale = this.baseScale;
         this.plane.x = position.x;
         this.plane.y = position.y;
         this.plane.z = position.z;
         this.plane.rotationX = rotation.x;
         this.plane.rotationY = rotation.y;
         this.plane.rotationZ = rotation.z;
      }
      
      public function addedToScene(container:Object3DContainer) : void
      {
         container.addChild(this.plane);
      }
      
      public function play(deltaTime:int, camera:GameCamera) : Boolean
      {
         if(this.time >= this.duration)
         {
            return false;
         }
         this.plane.setTime(this.time);
         this.time += deltaTime;
         this.plane.scaleX = this.scale;
         this.plane.scaleY = this.scale;
         this.scale += this.baseScale * this.tytofu * deltaTime;
         return true;
      }
      
      public function destroy() : void
      {
         this.plane.removeFromParent();
         this.plane.clear();
         recycle();
      }
      
      public function kill() : void
      {
         this.time = this.duration;
      }
   }
}

