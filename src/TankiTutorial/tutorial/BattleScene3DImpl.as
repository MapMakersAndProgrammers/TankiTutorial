package tutorial
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   
   public class BattleScene3DImpl implements BattleScene3D
   {
      
      public function BattleScene3DImpl()
      {
         super();
      }
      
      public function addObject(object:Object3D) : void
      {
         GameData.kdContainer.addChild(object);
      }
      
      public function removeObject(object:Object3D) : void
      {
         GameData.kdContainer.removeChild(object);
      }
      
      public function addRenderer(renderer:Renderer, param2:int) : void
      {
         GameData.renderers.addRenderer(renderer);
      }
      
      public function removeRenderer(renderer:Renderer, param2:int) : void
      {
         GameData.renderers.removeRenderer(renderer);
      }
   }
}

