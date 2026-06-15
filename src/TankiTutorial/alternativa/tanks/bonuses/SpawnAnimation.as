package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class SpawnAnimation extends PooledObject implements Renderer
   {
      
      private static const hacevul:Number = 0.001;
      
      private var nasybugo:BattleBonus;
      
      private var hyfecypi:BattleScene3D;
      
      private var wedebuga:Number = 0;
      
      public function SpawnAnimation(param1:Pool)
      {
         super(param1);
      }
      
      public function start(param1:BattleBonus, param2:BattleScene3D) : void
      {
         this.nasybugo = param1;
         this.hyfecypi = param2;
         this.wedebuga = 0;
         param1.gave.add(this.destroy);
         param2.addRenderer(this,0);
      }
      
      public function render(param1:int, param2:int) : void
      {
         this.wedebuga += hacevul * param2;
         if(this.wedebuga > 1)
         {
            this.wedebuga = 1;
         }
         this.nasybugo.setAlpha(this.wedebuga);
         if(this.wedebuga >= 1)
         {
            this.destroy();
         }
      }
      
      private function destroy() : void
      {
         this.hyfecypi.removeRenderer(this,0);
         this.hyfecypi = null;
         this.nasybugo.gave.remove(this.destroy);
         this.nasybugo = null;
         recycle();
      }
   }
}

