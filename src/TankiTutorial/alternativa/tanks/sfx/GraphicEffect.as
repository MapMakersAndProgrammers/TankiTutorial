package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.tanks.shared.camera.GameCamera;
   
   public interface GraphicEffect
   {
      
      function addedToScene(param1:Object3DContainer) : void;
      
      function play(param1:int, param2:GameCamera) : Boolean;
      
      function destroy() : void;
      
      function kill() : void;
   }
}

