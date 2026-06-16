package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import gafaduzuw.finajylom;
   import gafaduzuw.kyhewil;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   import kihi.qedozeze;
   import pekiv.sumik;
   import zicy.nocyquk;
   
   public class CollisionObject3DPositionProvider extends Wopowur implements hebis
   {
      
      private static const bul:kyhewil = new kyhewil();
      
      private static const fybumu:finajylom = new finajylom();
      
      private static const ruda:finajylom = new finajylom();
      
      private static const rygapyv:finajylom = new finajylom();
      
      private static const rinego:finajylom = new finajylom();
      
      private static const tefydiw:qedozeze = new qedozeze();
      
      private static const rucuha:Number = 20;
      
      private static const kab:Number = 0.2;
      
      private var gog:Number;
      
      private var kymaqos:nocyquk;
      
      private var toqumyc:finajylom = new finajylom();
      
      private var firaqe:Object3D;
      
      private var cyrare:Number;
      
      private var dypudecoz:Number = 0;
      
      public function CollisionObject3DPositionProvider(param1:fare)
      {
         super(param1);
      }
      
      private function calculateParameters() : void
      {
         bul.lowefuwi(this.firaqe.x,this.firaqe.y,this.firaqe.z,this.firaqe.rotationX,this.firaqe.rotationY,this.firaqe.rotationZ);
         rygapyv.kan = bul.gusat;
         rygapyv.zofydizug = bul.sig;
         rygapyv.qyririg = bul.vug;
         ruda.kan = bul.cydop;
         ruda.zofydizug = bul.qanezycap;
         ruda.qyririg = bul.luwym;
         bul.japoniw(this.toqumyc,rinego);
         var _loc1_:Number = Number(this.toqumyc.zofydizug);
         fybumu.kan = rinego.kan - _loc1_ * ruda.kan;
         fybumu.zofydizug = rinego.zofydizug - _loc1_ * ruda.zofydizug;
         fybumu.qyririg = rinego.qyririg - _loc1_ * ruda.qyririg;
      }
      
      public function init(param1:Object3D, param2:finajylom, param3:nocyquk, param4:Number, param5:Number = 0.5) : void
      {
         this.firaqe = param1;
         this.toqumyc = param2;
         this.kymaqos = param3;
         this.gog = param4;
         this.cyrare = param5;
         this.dypudecoz = 0;
      }
      
      public function initPosition(param1:Object3D) : void
      {
         this.calculateParameters();
         var _loc2_:Number = this.gog * this.cyrare;
         if(this.kymaqos.jityw(fybumu,ruda,sumik.neli,this.gog,null,tefydiw))
         {
            _loc2_ = finajylom.dycycowah(fybumu,tefydiw.position) * this.cyrare;
         }
         var _loc3_:Number = _loc2_ - this.dypudecoz;
         if(Math.abs(_loc3_) <= rucuha)
         {
            this.dypudecoz = _loc2_;
         }
         else
         {
            this.dypudecoz += _loc3_ * kab;
         }
         param1.x = fybumu.kan + ruda.kan * this.dypudecoz;
         param1.y = fybumu.zofydizug + ruda.zofydizug * this.dypudecoz;
         param1.z = fybumu.qyririg + ruda.qyririg * this.dypudecoz;
      }
      
      public function updateObjectPosition(param1:Object3D, param2:nufaneqog, param3:int) : void
      {
         this.initPosition(param1);
      }
      
      public function destroy() : void
      {
         this.firaqe = null;
         this.kymaqos = null;
         recycle();
      }
   }
}

