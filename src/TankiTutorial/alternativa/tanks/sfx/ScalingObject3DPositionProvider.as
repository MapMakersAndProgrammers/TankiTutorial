package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   
   public class ScalingObject3DPositionProvider extends PooledObject implements Object3DPositionProvider
   {
      
      private var position:Vector3 = new Vector3();
      
      private var velocity:Vector3 = new Vector3();
      
      private var ceki:Number;
      
      public function ScalingObject3DPositionProvider(pool:Pool)
      {
         super(pool);
      }
      
      public function initPosition(object:Object3D) : void
      {
         object.x = this.position.x;
         object.y = this.position.y;
         object.z = this.position.z;
         object.scaleX = 1;
         object.scaleY = 1;
         object.scaleZ = 1;
      }
      
      public function init(position:Vector3, velocity:Vector3, param3:Number) : void
      {
         this.position.copy(position);
         this.velocity.copy(velocity);
         this.ceki = param3;
      }
      
      public function updateObjectPosition(object:Object3D, camera:GameCamera, deltaTime:int) : void
      {
         var dt:Number = 0.001 * deltaTime;
         object.x += this.velocity.x * dt;
         object.y += this.velocity.y * dt;
         object.z += this.velocity.z * dt;
         object.scaleX += this.ceki;
         object.scaleY += this.ceki;
         object.scaleZ += this.ceki;
      }
      
      public function destroy() : void
      {
         recycle();
      }
   }
}

