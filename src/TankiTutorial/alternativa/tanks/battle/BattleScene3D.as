package alternativa.tanks.battle
{
   import alternativa.engine3d.core.Object3D;
   
   public interface BattleScene3D
   {
      
      function addObject(param1:Object3D) : void;
      
      function removeObject(param1:Object3D) : void;
      
      function addRenderer(param1:Renderer, param2:int) : void;
      
      function removeRenderer(param1:Renderer, param2:int) : void;
   }
}

