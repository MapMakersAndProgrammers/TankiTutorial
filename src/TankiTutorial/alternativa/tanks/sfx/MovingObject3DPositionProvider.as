package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   
   public class MovingObject3DPositionProvider extends PooledObject implements Object3DPositionProvider
   {
      
      private var position:Vector3 = new Vector3();
      
      private var velocity:Vector3 = new Vector3();
      
      private var acceleration:Number;
      
      public function MovingObject3DPositionProvider(pool:Pool)
      {
         super(pool);
      }
      
      public function initPosition(object:Object3D) : void
      {
         object.x = this.position.x;
         object.y = this.position.y;
         object.z = this.position.z;
      }
      
      public function init(position:Vector3, velocity:Vector3, acceleration:Number) : void
      {
         this.position.copy(position);
         this.velocity.copy(velocity);
         this.acceleration = acceleration;
      }
      
      public function updateObjectPosition(object:Object3D, camera:GameCamera, deltaTime:int) : void
      {
         var dt:Number = 0.001 * deltaTime;
         object.x += this.velocity.x * dt;
         object.y += this.velocity.y * dt;
         object.z += this.velocity.z * dt;
         var speed:Number = Number(this.velocity.length());
         speed += this.acceleration * dt;
         if(speed <= 0)
         {
            this.velocity.reset();
         }
         else
         {
            this.velocity.normalize();
            this.velocity.scale(speed);
         }
      }
      
      public function destroy() : void
      {
         recycle();
      }
   }
}

