package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.tanks.shared.camera.GameCamera;
   
   public interface GraphicEffect
   {
      
      function addedToScene(container:Object3DContainer) : void;
      
      function play(deltaTime:int, camera:GameCamera) : Boolean;
      
      function destroy() : void;
      
      function kill() : void;
   }
}

