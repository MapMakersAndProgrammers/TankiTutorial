package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleService;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class GroundSpawnRenderer extends PooledObject implements Renderer
   {
      
      private static const SCALE_SPEED:Number = 0.005;
      
      private var bonus:BattleBonus;
      
      private var battleService:BattleService;
      
      private var scale:Number;
      
      public function GroundSpawnRenderer(param1:Pool)
      {
         super(param1);
      }
      
      public function start(param1:BattleBonus, param2:BattleService) : void
      {
         this.bonus = param1;
         this.battleService = param2;
         this.scale = 0;
         param1.lybaluh.add(this.destroy);
         param1.nuziged.add(this.destroy);
         param1.gave.add(this.destroy);
         param2.getBattleScene3D().addRenderer(this,0);
      }
      
      public function render(time:int, deltaTime:int) : void
      {
         this.scale += SCALE_SPEED * deltaTime;
         if(this.scale > 1)
         {
            this.scale = 1;
         }
         var bonusMesh:BonusMesh = this.bonus.getBonusMesh();
         bonusMesh.scaleX = this.scale;
         bonusMesh.scaleY = this.scale;
         bonusMesh.scaleZ = this.scale;
         bonusMesh.setAlpha(this.scale);
         if(this.scale == 1)
         {
            this.startFlashAnimation();
            this.destroy();
         }
      }
      
      private function startFlashAnimation() : void
      {
         var spawnFlashRenderer:SpawnFlashRenderer = SpawnFlashRenderer(this.battleService.getObjectPool().getObject(SpawnFlashRenderer));
         spawnFlashRenderer.start(this.bonus,this.battleService.getBattleScene3D());
      }
      
      private function destroy() : void
      {
         this.battleService.getBattleScene3D().removeRenderer(this,0);
         this.battleService = null;
         this.bonus.lybaluh.remove(this.destroy);
         this.bonus.nuziged.remove(this.destroy);
         this.bonus.gave.remove(this.destroy);
         this.bonus = null;
         recycle();
      }
   }
}

