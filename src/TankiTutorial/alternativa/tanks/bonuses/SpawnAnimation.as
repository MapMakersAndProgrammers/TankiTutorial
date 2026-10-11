package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class SpawnAnimation extends PooledObject implements Renderer
   {
      
      private static const ALPHA_SPEED:Number = 0.001;
      
      private var bonus:BattleBonus;
      
      private var battleScene:BattleScene3D;
      
      private var alpha:Number = 0;
      
      public function SpawnAnimation(param1:Pool)
      {
         super(param1);
      }
      
      public function start(param1:BattleBonus, param2:BattleScene3D) : void
      {
         this.bonus = param1;
         this.battleScene = param2;
         this.alpha = 0;
         param1.gave.add(this.destroy);
         param2.addRenderer(this,0);
      }
      
      public function render(time:int, deltaTime:int) : void
      {
         this.alpha += ALPHA_SPEED * deltaTime;
         if(this.alpha > 1)
         {
            this.alpha = 1;
         }
         this.bonus.setAlpha(this.alpha);
         if(this.alpha >= 1)
         {
            this.destroy();
         }
      }
      
      private function destroy() : void
      {
         this.battleScene.removeRenderer(this,0);
         this.battleScene = null;
         this.bonus.gave.remove(this.destroy);
         this.bonus = null;
         recycle();
      }
   }
}

