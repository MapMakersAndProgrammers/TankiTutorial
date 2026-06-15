package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleService;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class GroundSpawnRenderer extends PooledObject implements Renderer
   {
      
      private static const walokocej:Number = 0.005;
      
      private var nasybugo:BattleBonus;
      
      private var mij:BattleService;
      
      private var lyvoz:Number;
      
      public function GroundSpawnRenderer(param1:Pool)
      {
         super(param1);
      }
      
      public function start(param1:BattleBonus, param2:BattleService) : void
      {
         this.nasybugo = param1;
         this.mij = param2;
         this.lyvoz = 0;
         param1.lybaluh.add(this.destroy);
         param1.nuziged.add(this.destroy);
         param1.gave.add(this.destroy);
         param2.getBattleScene3D().addRenderer(this,0);
      }
      
      public function render(param1:int, param2:int) : void
      {
         this.lyvoz += walokocej * param2;
         if(this.lyvoz > 1)
         {
            this.lyvoz = 1;
         }
         var _loc3_:BonusMesh = this.nasybugo.getBonusMesh();
         _loc3_.scaleX = this.lyvoz;
         _loc3_.scaleY = this.lyvoz;
         _loc3_.scaleZ = this.lyvoz;
         _loc3_.setAlpha(this.lyvoz);
         if(this.lyvoz == 1)
         {
            this.startFlashAnimation();
            this.destroy();
         }
      }
      
      private function startFlashAnimation() : void
      {
         var _loc1_:SpawnFlashRenderer = SpawnFlashRenderer(this.mij.getObjectPool().getObject(SpawnFlashRenderer));
         _loc1_.start(this.nasybugo,this.mij.getBattleScene3D());
      }
      
      private function destroy() : void
      {
         this.mij.getBattleScene3D().removeRenderer(this,0);
         this.mij = null;
         this.nasybugo.lybaluh.remove(this.destroy);
         this.nasybugo.nuziged.remove(this.destroy);
         this.nasybugo.gave.remove(this.destroy);
         this.nasybugo = null;
         recycle();
      }
   }
}

