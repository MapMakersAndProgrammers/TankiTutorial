package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   
   public class FallController implements BonusController
   {
      
      private static const SWING_AMPLITUDE:Number = 0.1;
      
      private static const SWING_FREQUENCY:Number = 1;
      
      private static const matrix:Matrix3 = new Matrix3();
      
      private static const offset:Vector3 = new Vector3();
      
      private const mowiluhi:Matrix3 = new Matrix3();
      
      private const direction:Vector3 = new Vector3();
      
      private const prevState:BattleBonusState = new BattleBonusState();
      
      private const state:BattleBonusState = new BattleBonusState();
      
      private const interpolatedState:BattleBonusState = new BattleBonusState();
      
      private var bonus:BattleBonus;
      
      private var minZ:Number;
      
      private var time:Number;
      
      private var fallSpeed:Number;
      
      private var timeOffset:Number;
      
      private var x:Number = 0;
      
      private var y:Number = 0;
      
      public function FallController(bonus:BattleBonus)
      {
         super();
         this.bonus = bonus;
      }
      
      public function init(position:Vector3, param2:Number, param3:Number, param4:Number, param5:Number, startingAngleZ:Number) : void
      {
         this.x = position.x;
         this.y = position.y;
         this.state.z = position.z + BonusConst.wucaruw - param2 * param5;
         this.state.rotationX = SWING_AMPLITUDE * Math.sin(SWING_FREQUENCY * param4);
         this.state.rotationZ = startingAngleZ + BonusConst.ROTATION_SPEED * param5;
         this.fallSpeed = param2;
         this.minZ = param3;
         this.timeOffset = param4;
         this.time = param5;
         this.prevState.copy(this.state);
         this.interpolatePhysicsState(1);
      }
      
      public function start() : void
      {
      }
      
      public function runBeforePhysicsUpdate(dt:Number) : void
      {
         this.prevState.copy(this.state);
         this.time += dt;
         this.state.z -= this.fallSpeed * dt;
         this.state.rotationX = SWING_AMPLITUDE * Math.sin(SWING_FREQUENCY * (this.timeOffset + this.time));
         this.state.rotationZ += BonusConst.ROTATION_SPEED * dt;
         if(this.state.z <= this.minZ)
         {
            this.state.z = this.minZ;
            this.state.rotationX = 0;
            this.interpolatePhysicsState(1);
            this.render();
            this.bonus.onTouchGround();
         }
         this.updateTrigger();
      }
      
      private function updateTrigger() : void
      {
         matrix.setRotationMatrix(this.state.rotationX,0,this.state.rotationZ);
         matrix.transformVector(Vector3.down,offset);
         offset.scale(BonusConst.wucaruw);
         this.bonus.getTrigger().update(this.x + offset.x,this.y + offset.y,this.state.z + offset.z,this.state.rotationX,0,this.state.rotationZ);
      }
      
      public function interpolatePhysicsState(t:Number) : void
      {
         this.interpolatedState.interpolate(this.prevState,this.state,t);
         this.mowiluhi.setRotationMatrix(this.interpolatedState.rotationX,0,this.interpolatedState.rotationZ);
         this.mowiluhi.transformVector(Vector3.down,this.direction);
      }
      
      public function render() : void
      {
         this.setObjectTransform(this.bonus.getParachute(),BonusConst.zemy,this.direction);
         this.setObjectTransform(this.bonus.getBonusMesh(),BonusConst.wucaruw,this.direction);
         this.bonus.getCords().updateVertices();
      }
      
      private function setObjectTransform(object:Object3D, distance:Number, dir:Vector3) : void
      {
         object.rotationX = this.interpolatedState.rotationX;
         object.rotationZ = this.interpolatedState.rotationZ;
         object.x = this.x + distance * dir.x;
         object.y = this.y + distance * dir.y;
         object.z = this.interpolatedState.z + distance * dir.z;
      }
   }
}

