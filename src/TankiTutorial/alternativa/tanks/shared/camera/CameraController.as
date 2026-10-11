package alternativa.tanks.shared.camera
{
   public interface CameraController
   {
      
      function setCamera(camera:GameCamera) : void;
      
      function deactivate() : void;
      
      function activate() : void;
      
      function update(time:int, deltaTime:int) : void;
   }
}

