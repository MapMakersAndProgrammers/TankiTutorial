package alternativa.tanks.bonuses
{
   import gafaduzuw.finajylom;
   import gafaduzuw.fode;
   
   public class LandingController implements judidoju
   {
      
      private static const fyqynyfy:finajylom = new finajylom();
      
      private static const run:fode = new fode();
      
      private static const pih:Number = 2.5;
      
      private var nasybugo:BattleBonus;
      
      private var lefugefo:finajylom = new finajylom();
      
      private var vale:finajylom = new finajylom();
      
      private var cozude:finajylom = new finajylom();
      
      private var qusejov:Number;
      
      private var zekos:finajylom = new finajylom();
      
      private var nusipysav:varo = new varo();
      
      private var hezataw:varo = new varo();
      
      private var sitozov:varo = new varo();
      
      public function LandingController(param1:BattleBonus)
      {
         super();
         this.nasybugo = param1;
      }
      
      public function init(param1:finajylom, param2:finajylom) : void
      {
         this.vale.disy(param1);
         this.lefugefo.disy(param2);
      }
      
      public function start() : void
      {
         var _loc1_:BonusMesh = this.nasybugo.qemydyc();
         this.cozude.variq(_loc1_.x,_loc1_.y,_loc1_.z);
         this.cozude.simesu(this.vale);
         this.zekos.disy(finajylom.nesicuryn);
         this.zekos.razabol(this.lefugefo);
         this.zekos.behy();
         this.qusejov = Math.acos(this.lefugefo.qyririg);
         this.hezataw.position.variq(_loc1_.x,_loc1_.y,_loc1_.z);
         this.hezataw.bej.daweviqe(_loc1_.rotationX,_loc1_.rotationY,_loc1_.rotationZ);
         this.nusipysav.disy(this.hezataw);
      }
      
      public function runBeforePhysicsUpdate(param1:Number) : void
      {
         this.nusipysav.disy(this.hezataw);
         var _loc2_:Number = pih * param1;
         if(_loc2_ > this.qusejov)
         {
            _loc2_ = this.qusejov;
            this.qusejov = 0;
         }
         else
         {
            this.qusejov -= _loc2_;
         }
         run.dekod(this.zekos,_loc2_);
         this.cozude.jec(run);
         this.hezataw.position.disy(this.vale).kyluwuzi(this.cozude);
         this.hezataw.bej.lavuhuke(this.zekos,_loc2_);
         this.updateTrigger();
         if(this.qusejov == 0)
         {
            this.interpolatePhysicsState(1);
            this.render();
            this.nasybugo.onLandingComplete();
         }
      }
      
      private function updateTrigger() : void
      {
         this.hezataw.bej.jolujeni(run);
         this.nasybugo.getTrigger().qopalon(this.hezataw.position,run);
      }
      
      public function interpolatePhysicsState(param1:Number) : void
      {
         this.sitozov.lir(this.nusipysav,this.hezataw,param1);
      }
      
      public function render() : void
      {
         var _loc1_:BonusMesh = this.nasybugo.qemydyc();
         _loc1_.x = this.sitozov.position.kan;
         _loc1_.y = this.sitozov.position.zofydizug;
         _loc1_.z = this.sitozov.position.qyririg;
         this.sitozov.bej.vah(fyqynyfy);
         _loc1_.rotationX = fyqynyfy.kan;
         _loc1_.rotationY = fyqynyfy.zofydizug;
         _loc1_.rotationZ = fyqynyfy.qyririg;
      }
   }
}

