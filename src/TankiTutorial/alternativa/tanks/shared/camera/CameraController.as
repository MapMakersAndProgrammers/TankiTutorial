package alternativa.tanks.shared.camera
{
   public interface CameraController
   {
      
      function setCamera(param1:GameCamera) : void;
      
      function deactivate() : void;
      
      function activate() : void;
      
      function update(param1:int, param2:int) : void;
   }
}

