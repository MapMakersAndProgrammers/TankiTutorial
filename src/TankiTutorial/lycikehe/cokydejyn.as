package lycikehe
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import gafaduzuw.finajylom;
   import gafaduzuw.kyhewil;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class cokydejyn extends Wopowur implements bowu
   {
      
      public static const qezizyj:Number = 60;
      
      private static const kykihyf:Number = 210;
      
      private static const nywysi:finajylom = new finajylom();
      
      private static const rinego:finajylom = new finajylom();
      
      private static const bul:kyhewil = new kyhewil();
      
      private static const wuzyrodu:finajylom = new finajylom();
      
      private var cysam:Medima;
      
      private var myhal:int;
      
      private var firaqe:Object3D;
      
      private var toqumyc:finajylom = new finajylom();
      
      public function cokydejyn(param1:fare)
      {
         super(param1);
         this.cysam = new Medima(qezizyj,kykihyf,0.5,0);
         this.cysam.guf(0,0,0,1,1,1,1,0);
         this.cysam.useShadowMap = false;
         this.cysam.useLight = false;
         this.cysam.shadowMapAlphaThreshold = 2;
         this.cysam.depthMapAlphaThreshold = 2;
      }
      
      public function cabor(param1:finajylom, param2:Object3D, param3:TextureMaterial, param4:int) : void
      {
         this.toqumyc.disy(param1);
         this.firaqe = param2;
         this.myhal = param4;
         this.cysam.setMaterialToAllFaces(param3);
         var _loc5_:BitmapData = param3.texture;
         param3.resolution = this.cysam.calculateResolution(_loc5_.width,_loc5_.height);
      }
      
      public function qeguqugir(param1:int, param2:nufaneqog) : Boolean
      {
         if(this.myhal < 0)
         {
            return false;
         }
         this.myhal -= param1;
         bul.lowefuwi(this.firaqe.x,this.firaqe.y,this.firaqe.z,this.firaqe.rotationX,this.firaqe.rotationY,this.firaqe.rotationZ);
         bul.japoniw(this.toqumyc,rinego);
         bul.dife(1,nywysi);
         wuzyrodu.kan = param2.x;
         wuzyrodu.zofydizug = param2.y;
         wuzyrodu.qyririg = param2.z;
         pybalutu.teg(this.cysam,rinego,nywysi,wuzyrodu);
         return true;
      }
      
      public function byr() : void
      {
         this.cysam.removeFromParent();
         this.firaqe = null;
         sapavaj();
      }
      
      public function wolyfami() : void
      {
         this.myhal = -1;
      }
      
      public function jipokikez(param1:Object3DContainer) : void
      {
         param1.addChild(this.cysam);
      }
   }
}

