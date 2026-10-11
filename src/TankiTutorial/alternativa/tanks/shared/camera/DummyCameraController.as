package alternativa.tanks.shared.camera
{
   public class DummyCameraController implements CameraController
   {
      
      public static const instance:DummyCameraController = new DummyCameraController();
      
      public function DummyCameraController()
      {
         super();
      }
      
      public function setCamera(camera:GameCamera) : void
      {
      }
      
      public function deactivate() : void
      {
      }
      
      public function activate() : void
      {
      }
      
      public function update(time:int, deltaTime:int) : void
      {
      }
   }
}

