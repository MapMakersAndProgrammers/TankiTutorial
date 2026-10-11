package
{
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   
   public class CameraControllerBase
   {
      
      protected var camera:GameCamera;
      
      public function CameraControllerBase(camera:GameCamera)
      {
         super();
         if(camera == null)
         {
            throw new ArgumentError("Parameter camera cannot be null");
         }
         this.camera = camera;
      }
      
      public function setCamera(camera:GameCamera) : void
      {
         this.camera = camera;
      }
      
      protected function setPosition(position:Vector3) : void
      {
         this.camera.x = position.x;
         this.camera.y = position.y;
         this.camera.z = position.z;
      }
      
      protected function setOrientation(rotation:Vector3) : void
      {
         this.camera.rotationX = rotation.x;
         this.camera.rotationY = rotation.y;
         this.camera.rotationZ = rotation.z;
      }
      
      protected function setOrientationXYZ(rotationX:Number, rotationY:Number, rotationZ:Number) : void
      {
         this.camera.rotationX = rotationX;
         this.camera.rotationY = rotationY;
         this.camera.rotationZ = rotationZ;
      }
      
      protected function moveBy(dx:Number, dy:Number, dz:Number) : void
      {
         this.camera.x += dx;
         this.camera.y += dy;
         this.camera.z += dz;
      }
      
      protected function rotateBy(param1:Number, param2:Number, param3:Number) : void
      {
         this.camera.rotationX += param1;
         this.camera.rotationY += param2;
         this.camera.rotationZ += param3;
      }
   }
}

