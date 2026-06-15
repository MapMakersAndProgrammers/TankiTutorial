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
      
      public function addObject(param1:Object3D) : void
      {
         GameData.guzinizub.addChild(param1);
      }
      
      public function removeObject(param1:Object3D) : void
      {
         GameData.guzinizub.removeChild(param1);
      }
      
      public function addRenderer(param1:Renderer, param2:int) : void
      {
         GameData.jypadif.addRenderer(param1);
      }
      
      public function removeRenderer(param1:Renderer, param2:int) : void
      {
         GameData.jypadif.removeRenderer(param1);
      }
   }
}

