package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   
   public class StaticObject3DPositionProvider extends PooledObject implements Object3DPositionProvider
   {
      
      private static const direction:Vector3 = new Vector3();
      
      private var position:Vector3 = new Vector3();
      
      private var distance:Number;
      
      public function StaticObject3DPositionProvider(param1:Pool)
      {
         super(param1);
      }
      
      public function init(param1:Vector3, param2:Number) : void
      {
         this.position.copy(param1);
         this.distance = param2;
      }
      
      public function setPosition(param1:Vector3) : void
      {
      }
      
      public function initPosition(object:Object3D) : void
      {
         object.x = this.position.x;
         object.y = this.position.y;
         object.z = this.position.z;
      }
      
      public function updateObjectPosition(object:Object3D, camera:GameCamera, deltaTime:int) : void
      {
         direction.x = camera.x - this.position.x;
         direction.y = camera.y - this.position.y;
         direction.z = camera.z - this.position.z;
         direction.normalize();
         object.x = this.position.x + this.distance * direction.x;
         object.y = this.position.y + this.distance * direction.y;
         object.z = this.position.z + this.distance * direction.z;
      }
      
      public function destroy() : void
      {
         recycle();
      }
   }
}

