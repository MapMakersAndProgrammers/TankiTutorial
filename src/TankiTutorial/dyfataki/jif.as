package dyfataki
{
   import gafaduzuw.finajylom;
   import gafaduzuw.fode;
   
   public class jif implements judidoju
   {
      
      private static const fyqynyfy:finajylom = new finajylom();
      
      private static const run:fode = new fode();
      
      private static const pih:Number = 2.5;
      
      private var nasybugo:ryzaj;
      
      private var lefugefo:finajylom = new finajylom();
      
      private var vale:finajylom = new finajylom();
      
      private var cozude:finajylom = new finajylom();
      
      private var qusejov:Number;
      
      private var zekos:finajylom = new finajylom();
      
      private var nusipysav:varo = new varo();
      
      private var hezataw:varo = new varo();
      
      private var sitozov:varo = new varo();
      
      public function jif(param1:ryzaj)
      {
         super();
         this.nasybugo = param1;
      }
      
      public function cabor(param1:finajylom, param2:finajylom) : void
      {
         this.vale.disy(param1);
         this.lefugefo.disy(param2);
      }
      
      public function juh() : void
      {
         var _loc1_:cogaj = this.nasybugo.qemydyc();
         this.cozude.variq(_loc1_.x,_loc1_.y,_loc1_.z);
         this.cozude.simesu(this.vale);
         this.zekos.disy(finajylom.nesicuryn);
         this.zekos.razabol(this.lefugefo);
         this.zekos.behy();
         this.qusejov = Math.acos(this.lefugefo.qyririg);
         this.hezataw.zybin.variq(_loc1_.x,_loc1_.y,_loc1_.z);
         this.hezataw.bej.daweviqe(_loc1_.rotationX,_loc1_.rotationY,_loc1_.rotationZ);
         this.nusipysav.disy(this.hezataw);
      }
      
      public function hebygima(param1:Number) : void
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
         this.hezataw.zybin.disy(this.vale).kyluwuzi(this.cozude);
         this.hezataw.bej.lavuhuke(this.zekos,_loc2_);
         this.tugakeri();
         if(this.qusejov == 0)
         {
            this.hynar(1);
            this.gecumyb();
            this.nasybugo.tewyveku();
         }
      }
      
      private function tugakeri() : void
      {
         this.hezataw.bej.jolujeni(run);
         this.nasybugo.lesebymeb().qopalon(this.hezataw.zybin,run);
      }
      
      public function hynar(param1:Number) : void
      {
         this.sitozov.lir(this.nusipysav,this.hezataw,param1);
      }
      
      public function gecumyb() : void
      {
         var _loc1_:cogaj = this.nasybugo.qemydyc();
         _loc1_.x = this.sitozov.zybin.kan;
         _loc1_.y = this.sitozov.zybin.zofydizug;
         _loc1_.z = this.sitozov.zybin.qyririg;
         this.sitozov.bej.vah(fyqynyfy);
         _loc1_.rotationX = fyqynyfy.kan;
         _loc1_.rotationY = fyqynyfy.zofydizug;
         _loc1_.rotationZ = fyqynyfy.qyririg;
      }
   }
}

