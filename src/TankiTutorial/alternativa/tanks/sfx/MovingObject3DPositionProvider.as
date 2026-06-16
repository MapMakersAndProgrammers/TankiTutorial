package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import gafaduzuw.finajylom;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class MovingObject3DPositionProvider extends Wopowur implements hebis
   {
      
      private var kiji:finajylom = new finajylom();
      
      private var zerus:finajylom = new finajylom();
      
      private var cozo:Number;
      
      public function MovingObject3DPositionProvider(param1:fare)
      {
         super(param1);
      }
      
      public function initPosition(param1:Object3D) : void
      {
         param1.x = this.kiji.kan;
         param1.y = this.kiji.zofydizug;
         param1.z = this.kiji.qyririg;
      }
      
      public function init(param1:finajylom, param2:finajylom, param3:Number) : void
      {
         this.kiji.disy(param1);
         this.zerus.disy(param2);
         this.cozo = param3;
      }
      
      public function updateObjectPosition(param1:Object3D, param2:nufaneqog, param3:int) : void
      {
         var _loc4_:Number = 0.001 * param3;
         param1.x += this.zerus.kan * _loc4_;
         param1.y += this.zerus.zofydizug * _loc4_;
         param1.z += this.zerus.qyririg * _loc4_;
         var _loc5_:Number = Number(this.zerus.nyhuguty());
         _loc5_ += this.cozo * _loc4_;
         if(_loc5_ <= 0)
         {
            this.zerus.variq();
         }
         else
         {
            this.zerus.behy();
            this.zerus.rudi(_loc5_);
         }
      }
      
      public function destroy() : void
      {
         recycle();
      }
   }
}

