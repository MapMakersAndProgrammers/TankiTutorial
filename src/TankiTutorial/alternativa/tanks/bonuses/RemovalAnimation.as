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
      
      private static const vysil:int = 500;
      
      private static const cygybup:int = 22;
      
      private static const cavogu:int = 12;
      
      private static const zuwujedo:Number = 10;
      
      private static const rihuda:Number = 0.5;
      
      private static const myz:Number = 1 - rihuda;
      
      private static const lako:Number = 0.001;
      
      private static const vac:int = 10400;
      
      private const duleruve:Blinker = new Blinker(vysil,cygybup,cavogu,myz,1,zuwujedo);
      
      private var hyfecypi:BattleScene3D;
      
      private var giqo:BonusMesh;
      
      private var racefom:int;
      
      private var vyno:Boolean;
      
      private var jemusyvin:Boolean;
      
      private var mirocy:Boolean;
      
      public function RemovalAnimation(param1:Pool)
      {
         super(param1);
      }
      
      public function init(param1:BattleScene3D, param2:BattleBonus, param3:int) : void
      {
         var _loc4_:int = getTimer();
         this.hyfecypi = param1;
         this.giqo = param2.getBonusMesh();
         this.racefom = _loc4_ + param3 - vac;
         this.mirocy = false;
         this.jemusyvin = true;
         this.vyno = false;
         if(param3 < vac)
         {
            this.duleruve.setInitialInterval(cygybup + (vysil - cygybup) * param3 / vac);
         }
         else
         {
            this.duleruve.setInitialInterval(vysil);
         }
         param1.addRenderer(this,0);
         param2.nuziged.addOnce(this.onBonusPickup);
         param2.lybaluh.addOnce(this.onBonusRemove);
      }
      
      private function onBonusPickup() : void
      {
         this.giqo = null;
         this.destroy();
      }
      
      private function onBonusRemove() : void
      {
         this.vyno = true;
         var _loc1_:int = getTimer() - vac;
         if(this.racefom > _loc1_)
         {
            this.racefom = _loc1_;
         }
      }
      
      public function render(param1:int, param2:int) : void
      {
         if(param1 >= this.racefom)
         {
            if(this.jemusyvin)
            {
               if(!this.mirocy)
               {
                  this.mirocy = true;
                  this.duleruve.init(param1);
               }
               this.blink(param1,param2);
            }
            else
            {
               this.fadeOut(param2);
            }
         }
      }
      
      private function blink(param1:int, param2:int) : void
      {
         var _loc3_:Number = this.duleruve.updateValue(param1,param2);
         this.giqo.setAlpha(_loc3_);
         if(this.vyno && param1 >= this.racefom + vac && _loc3_ == myz)
         {
            this.jemusyvin = false;
         }
      }
      
      private function fadeOut(param1:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = this.giqo.getAlpha();
         _loc2_ -= lako * param1;
         if(_loc2_ > 0)
         {
            this.giqo.setAlpha(_loc2_);
            if(this.giqo.scaleX > 0)
            {
               _loc3_ = this.giqo.scaleX - 0.002 * param1;
               if(_loc3_ < 0)
               {
                  _loc3_ = 0;
               }
               this.giqo.scaleX = _loc3_;
               this.giqo.scaleY = _loc3_;
               this.giqo.scaleZ = _loc3_;
            }
         }
         else
         {
            this.destroy();
         }
      }
      
      private function destroy() : void
      {
         this.hyfecypi.removeRenderer(this,0);
         if(this.giqo != null)
         {
            this.hyfecypi.removeObject(this.giqo);
            this.giqo.recycle();
            this.giqo = null;
         }
         this.hyfecypi = null;
         recycle();
      }
   }
}

