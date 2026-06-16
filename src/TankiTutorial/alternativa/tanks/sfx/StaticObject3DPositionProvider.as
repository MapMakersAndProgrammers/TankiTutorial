package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   
   public class StaticObject3DPositionProvider extends PooledObject implements Object3DPositionProvider
   {
      
      private static const pipoj:Vector3 = new Vector3();
      
      private var position:Vector3 = new Vector3();
      
      private var lume:Number;
      
      public function StaticObject3DPositionProvider(param1:Pool)
      {
         super(param1);
      }
      
      public function init(param1:Vector3, param2:Number) : void
      {
         this.position.copy(param1);
         this.lume = param2;
      }
      
      public function setPosition(param1:Vector3) : void
      {
      }
      
      public function initPosition(param1:Object3D) : void
      {
         param1.x = this.position.x;
         param1.y = this.position.y;
         param1.z = this.position.z;
      }
      
      public function updateObjectPosition(param1:Object3D, param2:GameCamera, param3:int) : void
      {
         pipoj.x = param2.x - this.position.x;
         pipoj.y = param2.y - this.position.y;
         pipoj.z = param2.z - this.position.z;
         pipoj.normalize();
         param1.x = this.position.x + this.lume * pipoj.x;
         param1.y = this.position.y + this.lume * pipoj.y;
         param1.z = this.position.z + this.lume * pipoj.z;
      }
      
      public function destroy() : void
      {
         recycle();
      }
   }
}

