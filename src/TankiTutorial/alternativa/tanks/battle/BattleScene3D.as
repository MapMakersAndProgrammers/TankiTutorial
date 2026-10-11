package alternativa.tanks.battle
{
   import alternativa.engine3d.core.Object3D;
   
   public interface BattleScene3D
   {
      
      function addObject(object:Object3D) : void;
      
      function removeObject(object:Object3D) : void;
      
      function addRenderer(renderer:Renderer, param2:int) : void;
      
      function removeRenderer(renderer:Renderer, param2:int) : void;
   }
}

