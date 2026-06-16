package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   
   public class FallController implements BonusController
   {
      
      private static const vegut:Number = 0.1;
      
      private static const paliged:Number = 1;
      
      private static const run:Matrix3 = new Matrix3();
      
      private static const qefof:Vector3 = new Vector3();
      
      private const mowiluhi:Matrix3 = new Matrix3();
      
      private const dugidyvu:Vector3 = new Vector3();
      
      private const nusipysav:BattleBonusState = new BattleBonusState();
      
      private const hezataw:BattleBonusState = new BattleBonusState();
      
      private const sitozov:BattleBonusState = new BattleBonusState();
      
      private var karury:BattleBonus;
      
      private var wipegyzy:Number;
      
      private var lecopojen:Number;
      
      private var pobano:Number;
      
      private var wimehyw:Number;
      
      private var x:Number = 0;
      
      private var y:Number = 0;
      
      public function FallController(param1:BattleBonus)
      {
         super();
         this.karury = param1;
      }
      
      public function init(param1:Vector3, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this.x = param1.x;
         this.y = param1.y;
         this.hezataw.fitepil = param1.z + BonusConst.wucaruw - param2 * param5;
         this.hezataw.peze = vegut * Math.sin(paliged * param4);
         this.hezataw.zywojehu = param6 + BonusConst.myr * param5;
         this.pobano = param2;
         this.wipegyzy = param3;
         this.wimehyw = param4;
         this.lecopojen = param5;
         this.nusipysav.copy(this.hezataw);
         this.interpolatePhysicsState(1);
      }
      
      public function start() : void
      {
      }
      
      public function runBeforePhysicsUpdate(param1:Number) : void
      {
         this.nusipysav.copy(this.hezataw);
         this.lecopojen += param1;
         this.hezataw.fitepil -= this.pobano * param1;
         this.hezataw.peze = vegut * Math.sin(paliged * (this.wimehyw + this.lecopojen));
         this.hezataw.zywojehu += BonusConst.myr * param1;
         if(this.hezataw.fitepil <= this.wipegyzy)
         {
            this.hezataw.fitepil = this.wipegyzy;
            this.hezataw.peze = 0;
            this.interpolatePhysicsState(1);
            this.render();
            this.karury.onTouchGround();
         }
         this.updateTrigger();
      }
      
      private function updateTrigger() : void
      {
         run.setRotationMatrix(this.hezataw.peze,0,this.hezataw.zywojehu);
         run.transformVector(Vector3.lasis,qefof);
         qefof.scale(BonusConst.wucaruw);
         this.karury.getTrigger().update(this.x + qefof.x,this.y + qefof.y,this.hezataw.fitepil + qefof.z,this.hezataw.peze,0,this.hezataw.zywojehu);
      }
      
      public function interpolatePhysicsState(param1:Number) : void
      {
         this.sitozov.interpolate(this.nusipysav,this.hezataw,param1);
         this.mowiluhi.setRotationMatrix(this.sitozov.peze,0,this.sitozov.zywojehu);
         this.mowiluhi.transformVector(Vector3.lasis,this.dugidyvu);
      }
      
      public function render() : void
      {
         this.setObjectTransform(this.karury.getParachute(),BonusConst.zemy,this.dugidyvu);
         this.setObjectTransform(this.karury.getBonusMesh(),BonusConst.wucaruw,this.dugidyvu);
         this.karury.getCords().updateVertices();
      }
      
      private function setObjectTransform(param1:Object3D, param2:Number, param3:Vector3) : void
      {
         param1.rotationX = this.sitozov.peze;
         param1.rotationZ = this.sitozov.zywojehu;
         param1.x = this.x + param2 * param3.x;
         param1.y = this.y + param2 * param3.y;
         param1.z = this.sitozov.fitepil + param2 * param3.z;
      }
   }
}

