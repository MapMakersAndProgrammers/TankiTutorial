package alternativa.tanks.bonuses
{
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   
   public class LandingController implements BonusController
   {
      
      private static const eulerAngles:Vector3 = new Vector3();
      
      private static const matrix:Matrix3 = new Matrix3();
      
      private static const ANGULAR_SPEED:Number = 2.5;
      
      private var bonus:BattleBonus;
      
      private var normal:Vector3 = new Vector3();
      
      private var pivot:Vector3 = new Vector3();
      
      private var offset:Vector3 = new Vector3();
      
      private var angle:Number;
      
      private var axis:Vector3 = new Vector3();
      
      private var prevState:LandingState = new LandingState();
      
      private var state:LandingState = new LandingState();
      
      private var interpolatedState:LandingState = new LandingState();
      
      public function LandingController(bonus:BattleBonus)
      {
         super();
         this.bonus = bonus;
      }
      
      public function init(pivot:Vector3, normal:Vector3) : void
      {
         this.pivot.copy(pivot);
         this.normal.copy(normal);
      }
      
      public function start() : void
      {
         var bonusMesh:BonusMesh = this.bonus.getBonusMesh();
         this.offset.reset(bonusMesh.x,bonusMesh.y,bonusMesh.z);
         this.offset.subtract(this.pivot);
         this.axis.copy(Vector3.zAxis);
         this.axis.cross(this.normal);
         this.axis.normalize();
         this.angle = Math.acos(this.normal.z);
         this.state.position.reset(bonusMesh.x,bonusMesh.y,bonusMesh.z);
         this.state.orientation.setFromEulerAnglesXYZ(bonusMesh.rotationX,bonusMesh.rotationY,bonusMesh.rotationZ);
         this.prevState.copy(this.state);
      }
      
      public function runBeforePhysicsUpdate(dt:Number) : void
      {
         this.prevState.copy(this.state);
         var deltaAngle:Number = ANGULAR_SPEED * dt;
         if(deltaAngle > this.angle)
         {
            deltaAngle = this.angle;
            this.angle = 0;
         }
         else
         {
            this.angle -= deltaAngle;
         }
         matrix.fromAxisAngle(this.axis,deltaAngle);
         this.offset.transform3(matrix);
         this.state.position.copy(this.pivot).add(this.offset);
         this.state.orientation.addScaledVector(this.axis,deltaAngle);
         this.updateTrigger();
         if(this.angle == 0)
         {
            this.interpolatePhysicsState(1);
            this.render();
            this.bonus.onLandingComplete();
         }
      }
      
      private function updateTrigger() : void
      {
         this.state.orientation.toMatrix3(matrix);
         this.bonus.getTrigger().setTransform(this.state.position,matrix);
      }
      
      public function interpolatePhysicsState(t:Number) : void
      {
         this.interpolatedState.interpolate(this.prevState,this.state,t);
      }
      
      public function render() : void
      {
         var bonusMesh:BonusMesh = this.bonus.getBonusMesh();
         bonusMesh.x = this.interpolatedState.position.x;
         bonusMesh.y = this.interpolatedState.position.y;
         bonusMesh.z = this.interpolatedState.position.z;
         this.interpolatedState.orientation.getEulerAngles(eulerAngles);
         bonusMesh.rotationX = eulerAngles.x;
         bonusMesh.rotationY = eulerAngles.y;
         bonusMesh.rotationZ = eulerAngles.z;
      }
   }
}

