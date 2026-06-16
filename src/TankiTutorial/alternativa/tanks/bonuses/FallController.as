package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.Object3D;
   import gafaduzuw.finajylom;
   import gafaduzuw.fode;
   
   public class FallController implements judidoju
   {
      
      private static const vegut:Number = 0.1;
      
      private static const paliged:Number = 1;
      
      private static const run:fode = new fode();
      
      private static const qefof:finajylom = new finajylom();
      
      private const mowiluhi:fode = new fode();
      
      private const dugidyvu:finajylom = new finajylom();
      
      private const nusipysav:zipaw = new zipaw();
      
      private const hezataw:zipaw = new zipaw();
      
      private const sitozov:zipaw = new zipaw();
      
      private var karury:BattleBonus;
      
      private var wipegyzy:Number;
      
      private var lecopojen:Number;
      
      private var pobano:Number;
      
      private var wimehyw:Number;
      
      private var kan:Number = 0;
      
      private var zofydizug:Number = 0;
      
      public function FallController(param1:BattleBonus)
      {
         super();
         this.karury = param1;
      }
      
      public function init(param1:finajylom, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this.kan = param1.kan;
         this.zofydizug = param1.zofydizug;
         this.hezataw.fitepil = param1.qyririg + rurosecel.wucaruw - param2 * param5;
         this.hezataw.peze = vegut * Math.sin(paliged * param4);
         this.hezataw.zywojehu = param6 + rurosecel.myr * param5;
         this.pobano = param2;
         this.wipegyzy = param3;
         this.wimehyw = param4;
         this.lecopojen = param5;
         this.nusipysav.disy(this.hezataw);
         this.interpolatePhysicsState(1);
      }
      
      public function start() : void
      {
      }
      
      public function runBeforePhysicsUpdate(param1:Number) : void
      {
         this.nusipysav.disy(this.hezataw);
         this.lecopojen += param1;
         this.hezataw.fitepil -= this.pobano * param1;
         this.hezataw.peze = vegut * Math.sin(paliged * (this.wimehyw + this.lecopojen));
         this.hezataw.zywojehu += rurosecel.myr * param1;
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
         run.vajetyw(this.hezataw.peze,0,this.hezataw.zywojehu);
         run.japoniw(finajylom.lasis,qefof);
         qefof.rudi(rurosecel.wucaruw);
         this.karury.getTrigger().update(this.kan + qefof.kan,this.zofydizug + qefof.zofydizug,this.hezataw.fitepil + qefof.qyririg,this.hezataw.peze,0,this.hezataw.zywojehu);
      }
      
      public function interpolatePhysicsState(param1:Number) : void
      {
         this.sitozov.lir(this.nusipysav,this.hezataw,param1);
         this.mowiluhi.vajetyw(this.sitozov.peze,0,this.sitozov.zywojehu);
         this.mowiluhi.japoniw(finajylom.lasis,this.dugidyvu);
      }
      
      public function render() : void
      {
         this.setObjectTransform(this.karury.getParachute(),rurosecel.zemy,this.dugidyvu);
         this.setObjectTransform(this.karury.qemydyc(),rurosecel.wucaruw,this.dugidyvu);
         this.karury.getCords().updateVertices();
      }
      
      private function setObjectTransform(param1:Object3D, param2:Number, param3:finajylom) : void
      {
         param1.rotationX = this.sitozov.peze;
         param1.rotationZ = this.sitozov.zywojehu;
         param1.x = this.kan + param2 * param3.kan;
         param1.y = this.zofydizug + param2 * param3.zofydizug;
         param1.z = this.sitozov.fitepil + param2 * param3.qyririg;
      }
   }
}

