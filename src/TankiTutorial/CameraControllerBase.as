package
{
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   
   public class CameraControllerBase
   {
      
      protected var butefu:GameCamera;
      
      public function CameraControllerBase(param1:GameCamera)
      {
         super();
         if(param1 == null)
         {
            throw new ArgumentError("Parameter camera cannot be null");
         }
         this.butefu = param1;
      }
      
      public function setCamera(param1:GameCamera) : void
      {
         this.butefu = param1;
      }
      
      protected function setPosition(param1:Vector3) : void
      {
         this.butefu.x = param1.x;
         this.butefu.y = param1.y;
         this.butefu.z = param1.z;
      }
      
      protected function setOrientation(param1:Vector3) : void
      {
         this.butefu.rotationX = param1.x;
         this.butefu.rotationY = param1.y;
         this.butefu.rotationZ = param1.z;
      }
      
      protected function setOrientationXYZ(param1:Number, param2:Number, param3:Number) : void
      {
         this.butefu.rotationX = param1;
         this.butefu.rotationY = param2;
         this.butefu.rotationZ = param3;
      }
      
      protected function moveBy(param1:Number, param2:Number, param3:Number) : void
      {
         this.butefu.x += param1;
         this.butefu.y += param2;
         this.butefu.z += param3;
      }
      
      protected function rotateBy(param1:Number, param2:Number, param3:Number) : void
      {
         this.butefu.rotationX += param1;
         this.butefu.rotationY += param2;
         this.butefu.rotationZ += param3;
      }
   }
}

