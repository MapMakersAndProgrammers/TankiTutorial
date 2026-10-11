package alternativa.tanks.vehicles.tank.controllers
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.utils.MathUtils;
   
   public class AutoAimTurretController extends TurretController
   {
      
      private static const bodyDirection:Vector3 = new Vector3();
      
      private static const matrix:Matrix4 = new Matrix4();
      
      private static const targetDirection:Vector3 = new Vector3();
      
      private var tank:Tank;
      
      private var target:Tank;
      
      public function AutoAimTurretController(tank:Tank, target:Tank)
      {
         super(0,0,false);
         this.tank = tank;
         this.target = target;
      }
      
      override public function rotate(dt:Number) : void
      {
         if(!this.tank.alive)
         {
            return;
         }
         var position:Vector3 = this.tank.tankBody.body.state.position;
         var targetPosition:Vector3 = this.target.tankBody.body.state.position;
         targetDirection.x = targetPosition.x - position.x;
         targetDirection.y = targetPosition.y - position.y;
         targetDirection.z = targetPosition.z - position.z;
         this.tank.tankBody.body.state.orientation.toMatrix4(matrix);
         matrix.deltaTransformVector(Vector3.yAxis,bodyDirection);
         bodyDirection.normalize();
         targetDirection.normalize();
         var targetAngle:Number = Math.atan2(targetDirection.y,targetDirection.x);
         var bodyAngle:Number = Math.atan2(bodyDirection.y,bodyDirection.x);
         var angle:Number = targetAngle - bodyAngle;
         if(angle < -Math.PI)
         {
            angle += MathUtils.PI2;
         }
         else if(angle > Math.PI)
         {
            angle -= MathUtils.PI2;
         }
         setDirectionImmediate(angle);
      }
   }
}

