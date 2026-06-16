package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import gafaduzuw.finajylom;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class StaticObject3DPositionProvider extends Wopowur implements hebis
   {
      
      private static const pipoj:finajylom = new finajylom();
      
      private var position:finajylom = new finajylom();
      
      private var lume:Number;
      
      public function StaticObject3DPositionProvider(param1:fare)
      {
         super(param1);
      }
      
      public function init(param1:finajylom, param2:Number) : void
      {
         this.position.disy(param1);
         this.lume = param2;
      }
      
      public function setPosition(param1:finajylom) : void
      {
      }
      
      public function initPosition(param1:Object3D) : void
      {
         param1.x = this.position.kan;
         param1.y = this.position.zofydizug;
         param1.z = this.position.qyririg;
      }
      
      public function updateObjectPosition(param1:Object3D, param2:nufaneqog, param3:int) : void
      {
         pipoj.kan = param2.x - this.position.kan;
         pipoj.zofydizug = param2.y - this.position.zofydizug;
         pipoj.qyririg = param2.z - this.position.qyririg;
         pipoj.behy();
         param1.x = this.position.kan + this.lume * pipoj.kan;
         param1.y = this.position.zofydizug + this.lume * pipoj.zofydizug;
         param1.z = this.position.qyririg + this.lume * pipoj.qyririg;
      }
      
      public function destroy() : void
      {
         recycle();
      }
   }
}

