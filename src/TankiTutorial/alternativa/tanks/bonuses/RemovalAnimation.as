package alternativa.tanks.bonuses
{
   import flash.utils.getTimer;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.sfx.Blinker;
   
   public class RemovalAnimation extends PooledObject implements Renderer
   {
      
      private static const INITIAL_INTERVAL:int = 500;
      
      private static const MIN_INTERVAL:int = 22;
      
      private static const INTERVAL_DECREMENT:int = 12;
      
      private static const zuwujedo:Number = 10;
      
      private static const rihuda:Number = 0.5;
      
      private static const MIN_ALPHA:Number = 1 - rihuda;
      
      private static const ALPHA_SPEED:Number = 0.001;
      
      private static const BLINK_DURATION:int = 10400;
      
      private const blinker:Blinker = new Blinker(INITIAL_INTERVAL,MIN_INTERVAL,INTERVAL_DECREMENT,MIN_ALPHA,1,zuwujedo);
      
      private var battleScene:BattleScene3D;
      
      private var bonusMesh:BonusMesh;
      
      private var blinkStartTime:int;
      
      private var removed:Boolean;
      
      private var blinking:Boolean;
      
      private var blinkStarted:Boolean;
      
      public function RemovalAnimation(pool:Pool)
      {
         super(pool);
      }
      
      public function init(battleScene:BattleScene3D, bonus:BattleBonus, lifeTime:int) : void
      {
         var time:int = getTimer();
         this.battleScene = battleScene;
         this.bonusMesh = bonus.getBonusMesh();
         this.blinkStartTime = time + lifeTime - BLINK_DURATION;
         this.blinkStarted = false;
         this.blinking = true;
         this.removed = false;
         if(lifeTime < BLINK_DURATION)
         {
            this.blinker.setInitialInterval(MIN_INTERVAL + (INITIAL_INTERVAL - MIN_INTERVAL) * lifeTime / BLINK_DURATION);
         }
         else
         {
            this.blinker.setInitialInterval(INITIAL_INTERVAL);
         }
         battleScene.addRenderer(this,0);
         bonus.nuziged.addOnce(this.onBonusPickup);
         bonus.lybaluh.addOnce(this.onBonusRemove);
      }
      
      private function onBonusPickup() : void
      {
         this.bonusMesh = null;
         this.destroy();
      }
      
      private function onBonusRemove() : void
      {
         this.removed = true;
         var _loc1_:int = getTimer() - BLINK_DURATION;
         if(this.blinkStartTime > _loc1_)
         {
            this.blinkStartTime = _loc1_;
         }
      }
      
      public function render(time:int, deltaTime:int) : void
      {
         if(time >= this.blinkStartTime)
         {
            if(this.blinking)
            {
               if(!this.blinkStarted)
               {
                  this.blinkStarted = true;
                  this.blinker.init(time);
               }
               this.blink(time,deltaTime);
            }
            else
            {
               this.fadeOut(deltaTime);
            }
         }
      }
      
      private function blink(time:int, deltaTime:int) : void
      {
         var alpha:Number = this.blinker.updateValue(time,deltaTime);
         this.bonusMesh.setAlpha(alpha);
         if(this.removed && time >= this.blinkStartTime + BLINK_DURATION && alpha == MIN_ALPHA)
         {
            this.blinking = false;
         }
      }
      
      private function fadeOut(deltaTime:int) : void
      {
         var scale:Number = NaN;
         var alpha:Number = this.bonusMesh.getAlpha();
         alpha -= ALPHA_SPEED * deltaTime;
         if(alpha > 0)
         {
            this.bonusMesh.setAlpha(alpha);
            if(this.bonusMesh.scaleX > 0)
            {
               scale = this.bonusMesh.scaleX - 0.002 * deltaTime;
               if(scale < 0)
               {
                  scale = 0;
               }
               this.bonusMesh.scaleX = scale;
               this.bonusMesh.scaleY = scale;
               this.bonusMesh.scaleZ = scale;
            }
         }
         else
         {
            this.destroy();
         }
      }
      
      private function destroy() : void
      {
         this.battleScene.removeRenderer(this,0);
         if(this.bonusMesh != null)
         {
            this.battleScene.removeObject(this.bonusMesh);
            this.bonusMesh.recycle();
            this.bonusMesh = null;
         }
         this.battleScene = null;
         recycle();
      }
   }
}

