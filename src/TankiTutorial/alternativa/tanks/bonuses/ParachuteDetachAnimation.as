package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class ParachuteDetachAnimation extends PooledObject implements Renderer
   {
      
      private static const ALPHA_SPEED:Number = 0.001;
      
      private static const SCALE_XY_SPEED:Number = 1 / 4000;
      
      private static const SCALE_Z_SPEED:Number = 1 / 3000;
      
      private var battleScene:BattleScene3D;
      
      private var parachute:Parachute;
      
      private var cords:Cords;
      
      private var fallSpeed:Number;
      
      public function ParachuteDetachAnimation(param1:Pool)
      {
         super(param1);
      }
      
      public function start(param1:BattleScene3D, param2:Parachute, param3:Cords, param4:Number) : void
      {
         this.battleScene = param1;
         this.parachute = param2;
         this.cords = param3;
         this.fallSpeed = param4 / 1000;
         param1.addRenderer(this,0);
      }
      
      public function render(time:int, deltaTime:int) : void
      {
         var scaleDelta:Number = NaN;
         this.parachute.setAlpha(this.parachute.getAlpha() - ALPHA_SPEED * deltaTime);
         if(this.parachute.getAlpha() <= 0)
         {
            this.destroy();
         }
         else
         {
            this.cords.setAlpha(this.parachute.getAlpha());
            this.parachute.z -= this.fallSpeed * deltaTime;
            scaleDelta = deltaTime * SCALE_XY_SPEED;
            this.parachute.scaleX += scaleDelta;
            this.parachute.scaleY += scaleDelta;
            this.parachute.scaleZ -= deltaTime * SCALE_Z_SPEED;
            this.cords.updateVertices();
         }
      }
      
      private function destroy() : void
      {
         this.battleScene.removeRenderer(this,0);
         this.battleScene.removeObject(this.parachute);
         this.battleScene.removeObject(this.cords);
         this.parachute.recycle();
         this.parachute = null;
         this.cords.recycle();
         this.cords = null;
         this.battleScene = null;
         recycle();
      }
   }
}

