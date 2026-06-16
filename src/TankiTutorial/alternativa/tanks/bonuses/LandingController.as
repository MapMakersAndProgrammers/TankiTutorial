package alternativa.tanks.bonuses
{
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   
   public class LandingController implements BonusController
   {
      
      private static const fyqynyfy:Vector3 = new Vector3();
      
      private static const run:Matrix3 = new Matrix3();
      
      private static const pih:Number = 2.5;
      
      private var nasybugo:BattleBonus;
      
      private var lefugefo:Vector3 = new Vector3();
      
      private var vale:Vector3 = new Vector3();
      
      private var cozude:Vector3 = new Vector3();
      
      private var qusejov:Number;
      
      private var zekos:Vector3 = new Vector3();
      
      private var nusipysav:LandingState = new LandingState();
      
      private var hezataw:LandingState = new LandingState();
      
      private var sitozov:LandingState = new LandingState();
      
      public function LandingController(param1:BattleBonus)
      {
         super();
         this.nasybugo = param1;
      }
      
      public function init(param1:Vector3, param2:Vector3) : void
      {
         this.vale.copy(param1);
         this.lefugefo.copy(param2);
      }
      
      public function start() : void
      {
         var _loc1_:BonusMesh = this.nasybugo.getBonusMesh();
         this.cozude.reset(_loc1_.x,_loc1_.y,_loc1_.z);
         this.cozude.subtract(this.vale);
         this.zekos.copy(Vector3.nesicuryn);
         this.zekos.cross(this.lefugefo);
         this.zekos.normalize();
         this.qusejov = Math.acos(this.lefugefo.z);
         this.hezataw.position.reset(_loc1_.x,_loc1_.y,_loc1_.z);
         this.hezataw.bej.setFromEulerAnglesXYZ(_loc1_.rotationX,_loc1_.rotationY,_loc1_.rotationZ);
         this.nusipysav.copy(this.hezataw);
      }
      
      public function runBeforePhysicsUpdate(param1:Number) : void
      {
         this.nusipysav.copy(this.hezataw);
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
         run.fromAxisAngle(this.zekos,_loc2_);
         this.cozude.transform3(run);
         this.hezataw.position.copy(this.vale).add(this.cozude);
         this.hezataw.bej.addScaledVector(this.zekos,_loc2_);
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
         this.hezataw.bej.toMatrix3(run);
         this.nasybugo.getTrigger().setTransform(this.hezataw.position,run);
      }
      
      public function interpolatePhysicsState(param1:Number) : void
      {
         this.sitozov.interpolate(this.nusipysav,this.hezataw,param1);
      }
      
      public function render() : void
      {
         var _loc1_:BonusMesh = this.nasybugo.getBonusMesh();
         _loc1_.x = this.sitozov.position.x;
         _loc1_.y = this.sitozov.position.y;
         _loc1_.z = this.sitozov.position.z;
         this.sitozov.bej.getEulerAngles(fyqynyfy);
         _loc1_.rotationX = fyqynyfy.x;
         _loc1_.rotationY = fyqynyfy.y;
         _loc1_.rotationZ = fyqynyfy.z;
      }
   }
}

