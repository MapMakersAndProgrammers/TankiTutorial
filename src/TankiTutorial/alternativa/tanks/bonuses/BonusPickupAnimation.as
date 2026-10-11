package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.geom.ColorTransform;
   
   public class BonusPickupAnimation extends PooledObject implements Renderer
   {
      
      private static const DURATION:int = 2000;
      
      private static const boju:int = 300;
      
      private static const vasegosap:int = DURATION - boju;
      
      private static const MAX_COLOR_OFFSET:int = 204;
      
      private static const pocob:Number = Number(MAX_COLOR_OFFSET) / boju;
      
      private static const befuvevac:Number = Number(MAX_COLOR_OFFSET) / (DURATION - boju);
      
      private static const zyhesaju:Number = 300;
      
      private static const ROTATION_SPEED:Number = 2;
      
      private var bonusMesh:BonusMesh;
      
      private var battleScene:BattleScene3D;
      
      private var colorTransform:ColorTransform = new ColorTransform();
      
      private var timeLeft:int;
      
      private var colorOffset:int;
      
      public function BonusPickupAnimation(param1:Pool)
      {
         super(param1);
      }
      
      public function start(param1:BonusMesh, param2:BattleScene3D) : void
      {
         this.bonusMesh = param1;
         this.battleScene = param2;
         this.bonusMesh.colorTransform = this.colorTransform;
         this.timeLeft = DURATION;
         this.colorOffset = 0;
         param2.addRenderer(this,0);
      }
      
      public function render(time:int, deltaTime:int) : void
      {
         if(this.timeLeft > 0)
         {
            this.playAnimation(deltaTime);
         }
         else
         {
            this.destroy();
         }
      }
      
      private function playAnimation(deltaTime:int) : void
      {
         var dt:Number = deltaTime / 1000;
         this.bonusMesh.z += (zyhesaju * this.timeLeft / DURATION + zyhesaju * 0.1) * dt;
         this.bonusMesh.rotationZ += (ROTATION_SPEED * this.timeLeft / DURATION + ROTATION_SPEED * 0.1) * dt;
         if(this.timeLeft > DURATION - boju)
         {
            this.colorOffset += pocob * deltaTime;
            if(this.colorOffset > MAX_COLOR_OFFSET)
            {
               this.colorOffset = MAX_COLOR_OFFSET;
            }
         }
         else
         {
            this.colorOffset -= befuvevac * deltaTime;
            if(this.colorOffset < 0)
            {
               this.colorOffset = 0;
            }
         }
         this.colorTransform.redOffset = this.colorOffset;
         this.colorTransform.blueOffset = this.colorOffset;
         this.colorTransform.greenOffset = this.colorOffset;
         if(this.timeLeft < vasegosap)
         {
            this.bonusMesh.setAlpha(this.timeLeft / vasegosap);
         }
         this.timeLeft -= deltaTime;
      }
      
      private function destroy() : void
      {
         this.bonusMesh.colorTransform = null;
         this.battleScene.removeObject(this.bonusMesh);
         this.bonusMesh.recycle();
         this.bonusMesh = null;
         this.battleScene.removeRenderer(this,0);
         this.battleScene = null;
         recycle();
      }
   }
}

