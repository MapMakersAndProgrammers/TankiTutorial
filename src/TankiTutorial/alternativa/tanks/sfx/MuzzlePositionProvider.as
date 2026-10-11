package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix4;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   
   public class MuzzlePositionProvider extends PooledObject implements Object3DPositionProvider
   {
      
      private static const matrix:Matrix4 = new Matrix4();
      
      private static const position:Vector3 = new Vector3();
      
      private var turret:Object3D;
      
      private var localMuzzlePosition:Vector3 = new Vector3();
      
      public function MuzzlePositionProvider(param1:Pool)
      {
         super(param1);
      }
      
      public function init(param1:Object3D, param2:Vector3, param3:Number) : void
      {
         this.turret = param1;
         this.localMuzzlePosition.copy(param2);
         this.localMuzzlePosition.y += param3;
      }
      
      public function initPosition(object:Object3D) : void
      {
         object.x = 0;
         object.y = 0;
         object.z = 0;
      }
      
      public function updateObjectPosition(object:Object3D, camera:GameCamera, deltaTime:int) : void
      {
         matrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         matrix.transformVector(this.localMuzzlePosition,position);
         object.x = position.x;
         object.y = position.y;
         object.z = position.z;
      }
      
      public function destroy() : void
      {
         this.turret = null;
         recycle();
      }
   }
}

