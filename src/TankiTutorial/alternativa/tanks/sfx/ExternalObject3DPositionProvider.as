package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class ExternalObject3DPositionProvider extends PooledObject implements Object3DPositionProvider
   {
      
      private var position:Vector3 = new Vector3();
      
      public function ExternalObject3DPositionProvider(param1:Pool)
      {
         super(param1);
      }
      
      public function setPosition(param1:Vector3) : void
      {
         this.position.copy(param1);
      }
      
      public function initPosition(object:Object3D) : void
      {
         object.x = this.position.x;
         object.y = this.position.y;
         object.z = this.position.z;
      }
      
      public function updateObjectPosition(object:Object3D, camera:GameCamera, deltaTime:int) : void
      {
         this.initPosition(object);
      }
      
      public function destroy() : void
      {
      }
   }
}

