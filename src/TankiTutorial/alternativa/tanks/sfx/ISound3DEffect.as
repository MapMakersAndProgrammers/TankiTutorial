package alternativa.tanks.sfx
{
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   
   public interface ISound3DEffect
   {
      
      function play(deltaTime:int, camera:GameCamera) : void;
      
      function destroy() : void;
      
      function kill() : void;
      
      function set enabled(value:Boolean) : void;
      
      function readPosition(result:Vector3) : void;
      
      function get numSounds() : int;
   }
}

