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
      
      private static const mal:Vector.<Number> = Vector.<Number>([0,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5]);
      
      private static const maduze:Vector.<Number> = Vector.<Number>([0,130.05,255,201.45,140.25,104.55,66.3,40.8,25.5,10.2,0]);
      
      private static const cyn:AnimationTrack = new AnimationTrack(mal,maduze);
      
      private var fur:AnimatedColorTransform = new AnimatedColorTransform();
      
      private var zeg:KeyFrameAnimation = new KeyFrameAnimation(cyn,this.fur);
      
      private var nasybugo:BattleBonus;
      
      private var hyfecypi:BattleScene3D;
      
      public function SpawnFlashRenderer(param1:Pool)
      {
         super(param1);
      }
      
      public function start(param1:BattleBonus, param2:BattleScene3D) : void
      {
         this.nasybugo = param1;
         this.hyfecypi = param2;
         param1.lybaluh.add(this.destroy);
         param1.nuziged.add(this.destroy);
         param1.gave.add(this.destroy);
         param1.getBonusMesh().colorTransform = this.fur.fur;
         param2.addRenderer(this,0);
         this.zeg.start();
      }
      
      public function render(param1:int, param2:int) : void
      {
         if(this.zeg.isComplete())
         {
            this.nasybugo.enableTrigger();
            this.destroy();
         }
         else
         {
            this.zeg.update(param2 / 1000);
         }
      }
      
      private function destroy() : void
      {
         this.hyfecypi.removeRenderer(this,0);
         this.hyfecypi = null;
         this.nasybugo.lybaluh.remove(this.destroy);
         this.nasybugo.nuziged.remove(this.destroy);
         this.nasybugo.gave.remove(this.destroy);
         this.nasybugo.getBonusMesh().colorTransform = null;
         this.nasybugo = null;
         recycle();
      }
   }
}

