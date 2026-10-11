package alternativa.tanks.bonuses
{
   import alternativa.tanks.animations.AnimationTrack;
   import alternativa.tanks.animations.KeyFrameAnimation;
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class SpawnFlashRenderer extends PooledObject implements Renderer
   {
      
      private static const times:Vector.<Number> = Vector.<Number>([0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5]);
      
      private static const values:Vector.<Number> = Vector.<Number>([0,130.05,255,201.45,140.25,104.55,66.3,40.8,25.5,10.2,0]);
      
      private static const track:AnimationTrack = new AnimationTrack(times,values);
      
      private var colorTransform:AnimatedColorTransform = new AnimatedColorTransform();
      
      private var animation:KeyFrameAnimation = new KeyFrameAnimation(track,colorTransform);
      
      private var bonus:BattleBonus;
      
      private var battleScene:BattleScene3D;
      
      public function SpawnFlashRenderer(pool:Pool)
      {
         super(pool);
      }
      
      public function start(bonus:BattleBonus, battleScene:BattleScene3D) : void
      {
         this.bonus = bonus;
         this.battleScene = battleScene;
         bonus.lybaluh.add(this.destroy);
         bonus.nuziged.add(this.destroy);
         bonus.gave.add(this.destroy);
         bonus.getBonusMesh().colorTransform = this.colorTransform.colorTransform;
         battleScene.addRenderer(this,0);
         this.animation.start();
      }
      
      public function render(time:int, deltaTime:int) : void
      {
         if(this.animation.isComplete())
         {
            this.bonus.enableTrigger();
            this.destroy();
         }
         else
         {
            this.animation.update(deltaTime / 1000);
         }
      }
      
      private function destroy() : void
      {
         this.battleScene.removeRenderer(this,0);
         this.battleScene = null;
         this.bonus.lybaluh.remove(this.destroy);
         this.bonus.nuziged.remove(this.destroy);
         this.bonus.gave.remove(this.destroy);
         this.bonus.getBonusMesh().colorTransform = null;
         this.bonus = null;
         recycle();
      }
   }
}

