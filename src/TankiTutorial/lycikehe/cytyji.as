package lycikehe
{
   import alternativa.engine3d.core.Object3D;
   import gafaduzuw.finajylom;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class cytyji extends Wopowur implements hebis
   {
      
      private static const pipoj:finajylom = new finajylom();
      
      private var zybin:finajylom = new finajylom();
      
      private var lume:Number;
      
      public function cytyji(param1:fare)
      {
         super(param1);
      }
      
      public function cabor(param1:finajylom, param2:Number) : void
      {
         this.zybin.disy(param1);
         this.lume = param2;
      }
      
      public function faverewov(param1:finajylom) : void
      {
      }
      
      public function nyw(param1:Object3D) : void
      {
         param1.x = this.zybin.kan;
         param1.y = this.zybin.zofydizug;
         param1.z = this.zybin.qyririg;
      }
      
      public function lynetame(param1:Object3D, param2:nufaneqog, param3:int) : void
      {
         pipoj.kan = param2.x - this.zybin.kan;
         pipoj.zofydizug = param2.y - this.zybin.zofydizug;
         pipoj.qyririg = param2.z - this.zybin.qyririg;
         pipoj.behy();
         param1.x = this.zybin.kan + this.lume * pipoj.kan;
         param1.y = this.zybin.zofydizug + this.lume * pipoj.zofydizug;
         param1.z = this.zybin.qyririg + this.lume * pipoj.qyririg;
      }
      
      public function byr() : void
      {
         sapavaj();
      }
   }
}

