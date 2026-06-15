package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class ParachuteDetachAnimation extends PooledObject implements Renderer
   {
      
      private static const hacevul:Number = 0.001;
      
      private static const sevefe:Number = 1 / 4000;
      
      private static const wojopyny:Number = 1 / 3000;
      
      private var hyfecypi:BattleScene3D;
      
      private var kyvedu:Parachute;
      
      private var til:Cords;
      
      private var pobano:Number;
      
      public function ParachuteDetachAnimation(param1:Pool)
      {
         super(param1);
      }
      
      public function start(param1:BattleScene3D, param2:Parachute, param3:Cords, param4:Number) : void
      {
         this.hyfecypi = param1;
         this.kyvedu = param2;
         this.til = param3;
         this.pobano = param4 / 1000;
         param1.addRenderer(this,0);
      }
      
      public function render(param1:int, param2:int) : void
      {
         var _loc3_:Number = NaN;
         this.kyvedu.setAlpha(this.kyvedu.getAlpha() - hacevul * param2);
         if(this.kyvedu.getAlpha() <= 0)
         {
            this.destroy();
         }
         else
         {
            this.til.setAlpha(this.kyvedu.getAlpha());
            this.kyvedu.z -= this.pobano * param2;
            _loc3_ = param2 * sevefe;
            this.kyvedu.scaleX += _loc3_;
            this.kyvedu.scaleY += _loc3_;
            this.kyvedu.scaleZ -= param2 * wojopyny;
            this.til.updateVertices();
         }
      }
      
      private function destroy() : void
      {
         this.hyfecypi.removeRenderer(this,0);
         this.hyfecypi.removeObject(this.kyvedu);
         this.hyfecypi.removeObject(this.til);
         this.kyvedu.recycle();
         this.kyvedu = null;
         this.til.recycle();
         this.til = null;
         this.hyfecypi = null;
         recycle();
      }
   }
}

