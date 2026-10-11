package alternativa.tanks.bonuses
{
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.geom.ColorTransform;
   
   public class BonusPickupAnimation extends PooledObject implements Renderer
   {
      
      private static const zehyki:int = 2000;
      
      private static const boju:int = 300;
      
      private static const vasegosap:int = zehyki - boju;
      
      private static const nimahobu:int = 204;
      
      private static const pocob:Number = Number(nimahobu) / boju;
      
      private static const befuvevac:Number = Number(nimahobu) / (zehyki - boju);
      
      private static const zyhesaju:Number = 300;
      
      private static const bosykyj:Number = 2;
      
      private var giqo:BonusMesh;
      
      private var battleScene:BattleScene3D;
      
      private var colorTransform:ColorTransform = new ColorTransform();
      
      private var hany:int;
      
      private var pegyj:int;
      
      public function BonusPickupAnimation(param1:Pool)
      {
         super(param1);
      }
      
      public function start(param1:BonusMesh, param2:BattleScene3D) : void
      {
         this.giqo = param1;
         this.battleScene = param2;
         this.giqo.colorTransform = this.colorTransform;
         this.hany = zehyki;
         this.pegyj = 0;
         param2.addRenderer(this,0);
      }
      
      public function render(param1:int, param2:int) : void
      {
         if(this.hany > 0)
         {
            this.playAnimation(param2);
         }
         else
         {
            this.destroy();
         }
      }
      
      private function playAnimation(param1:int) : void
      {
         var _loc2_:Number = param1 / 1000;
         this.giqo.z += (zyhesaju * this.hany / zehyki + zyhesaju * 0.1) * _loc2_;
         this.giqo.rotationZ += (bosykyj * this.hany / zehyki + bosykyj * 0.1) * _loc2_;
         if(this.hany > zehyki - boju)
         {
            this.pegyj += pocob * param1;
            if(this.pegyj > nimahobu)
            {
               this.pegyj = nimahobu;
            }
         }
         else
         {
            this.pegyj -= befuvevac * param1;
            if(this.pegyj < 0)
            {
               this.pegyj = 0;
            }
         }
         this.colorTransform.redOffset = this.pegyj;
         this.colorTransform.blueOffset = this.pegyj;
         this.colorTransform.greenOffset = this.pegyj;
         if(this.hany < vasegosap)
         {
            this.giqo.setAlpha(this.hany / vasegosap);
         }
         this.hany -= param1;
      }
      
      private function destroy() : void
      {
         this.giqo.colorTransform = null;
         this.battleScene.removeObject(this.giqo);
         this.giqo.recycle();
         this.giqo = null;
         this.battleScene.removeRenderer(this,0);
         this.battleScene = null;
         recycle();
      }
   }
}

