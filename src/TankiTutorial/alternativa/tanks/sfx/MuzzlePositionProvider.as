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
      
      private static const bul:Matrix4 = new Matrix4();
      
      private static const dogeny:Vector3 = new Vector3();
      
      private var firaqe:Object3D;
      
      private var fodunuhul:Vector3 = new Vector3();
      
      public function MuzzlePositionProvider(param1:Pool)
      {
         super(param1);
      }
      
      public function init(param1:Object3D, param2:Vector3, param3:Number) : void
      {
         this.firaqe = param1;
         this.fodunuhul.copy(param2);
         this.fodunuhul.y += param3;
      }
      
      public function initPosition(param1:Object3D) : void
      {
         param1.x = 0;
         param1.y = 0;
         param1.z = 0;
      }
      
      public function updateObjectPosition(param1:Object3D, param2:GameCamera, param3:int) : void
      {
         bul.setMatrix(this.firaqe.x,this.firaqe.y,this.firaqe.z,this.firaqe.rotationX,this.firaqe.rotationY,this.firaqe.rotationZ);
         bul.transformVector(this.fodunuhul,dogeny);
         param1.x = dogeny.x;
         param1.y = dogeny.y;
         param1.z = dogeny.z;
      }
      
      public function destroy() : void
      {
         this.firaqe = null;
         recycle();
      }
   }
}

