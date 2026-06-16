package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import gafaduzuw.finajylom;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class ScalingObject3DPositionProvider extends Wopowur implements hebis
   {
      
      private var kiji:finajylom = new finajylom();
      
      private var zerus:finajylom = new finajylom();
      
      private var ceki:Number;
      
      public function ScalingObject3DPositionProvider(param1:fare)
      {
         super(param1);
      }
      
      public function initPosition(param1:Object3D) : void
      {
         param1.x = this.kiji.kan;
         param1.y = this.kiji.zofydizug;
         param1.z = this.kiji.qyririg;
         param1.scaleX = 1;
         param1.scaleY = 1;
         param1.scaleZ = 1;
      }
      
      public function init(param1:finajylom, param2:finajylom, param3:Number) : void
      {
         this.kiji.disy(param1);
         this.zerus.disy(param2);
         this.ceki = param3;
      }
      
      public function updateObjectPosition(param1:Object3D, param2:nufaneqog, param3:int) : void
      {
         var _loc4_:Number = 0.001 * param3;
         param1.x += this.zerus.kan * _loc4_;
         param1.y += this.zerus.zofydizug * _loc4_;
         param1.z += this.zerus.qyririg * _loc4_;
         param1.scaleX += this.ceki;
         param1.scaleY += this.ceki;
         param1.scaleZ += this.ceki;
      }
      
      public function destroy() : void
      {
         recycle();
      }
   }
}

