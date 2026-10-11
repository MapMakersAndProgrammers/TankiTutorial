package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.tanks.shared.camera.GameCamera;
   
   public interface Object3DPositionProvider
   {
      
      function initPosition(object:Object3D) : void;
      
      function updateObjectPosition(object:Object3D, camera:GameCamera, deltaTime:int) : void;
      
      function destroy() : void;
   }
}

