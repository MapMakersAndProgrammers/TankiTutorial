package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import gafaduzuw.finajylom;
   import gafaduzuw.kyhewil;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class MuzzlePositionProvider extends Wopowur implements hebis
   {
      
      private static const bul:kyhewil = new kyhewil();
      
      private static const dogeny:finajylom = new finajylom();
      
      private var firaqe:Object3D;
      
      private var fodunuhul:finajylom = new finajylom();
      
      public function MuzzlePositionProvider(param1:fare)
      {
         super(param1);
      }
      
      public function init(param1:Object3D, param2:finajylom, param3:Number) : void
      {
         this.firaqe = param1;
         this.fodunuhul.disy(param2);
         this.fodunuhul.zofydizug += param3;
      }
      
      public function initPosition(param1:Object3D) : void
      {
         param1.x = 0;
         param1.y = 0;
         param1.z = 0;
      }
      
      public function updateObjectPosition(param1:Object3D, param2:nufaneqog, param3:int) : void
      {
         bul.lowefuwi(this.firaqe.x,this.firaqe.y,this.firaqe.z,this.firaqe.rotationX,this.firaqe.rotationY,this.firaqe.rotationZ);
         bul.japoniw(this.fodunuhul,dogeny);
         param1.x = dogeny.kan;
         param1.y = dogeny.zofydizug;
         param1.z = dogeny.qyririg;
      }
      
      public function destroy() : void
      {
         this.firaqe = null;
         recycle();
      }
   }
}

