package tutorial.tasks
{
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.controllers.CommonTankController;
   import alternativa.utils.MathUtils;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class EnemyTankTask extends CommonEnemyTask
   {
      
      private static const veco:Number = Math.cos(MathUtils.toRadians(25));
      
      private static const nuzofaqi:Number = MathUtils.toRadians(10);
      
      private static const forward:Vector3 = new Vector3();
      
      private var waypoints:Vector.<Vector3>;
      
      private var waypointIndex:int;
      
      private var dom:Sprite3D;
      
      private var activationPosition:Vector3;
      
      private var range:Number = 800;
      
      private var direction:Vector3 = new Vector3();
      
      public function EnemyTankTask(hull:String, turret:String, color:String, position:Vector3, orientation:Quaternion, waypoints:Vector.<Vector3>, health:Number = 0, damageMultiplier:Number = 1, callback:Function = null, shootDelay:uint = 3000, loop:Boolean = false, activationPosition:Vector3 = null)
      {
         super(hull,turret,color,position,orientation,health,damageMultiplier,callback,shootDelay,loop);
         this.waypoints = waypoints;
         this.activationPosition = activationPosition;
      }
      
      override protected function onInit() : void
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var distanceSqr:Number = NaN;
         if(this.activationPosition != null)
         {
            x = Number(GameData.playerTank.kuca.hullMesh.x);
            y = Number(GameData.playerTank.kuca.hullMesh.y);
            distanceSqr = (x - this.activationPosition.x) * (x - this.activationPosition.x) + (y - this.activationPosition.y) * (y - this.activationPosition.y);
            if(distanceSqr < this.range * this.range)
            {
               super.onInit();
            }
         }
         else
         {
            super.onInit();
         }
      }
      
      override protected function onExecute() : void
      {
         var enemyTank:Tank = null;
         var position:Vector3 = null;
         var waypoint:Vector3 = null;
         var distanceSqr:Number = NaN;
         var matrix:Matrix3 = null;
         var cross:Number = NaN;
         var angle:Number = NaN;
         var angularVelocityZ:Number = NaN;
         var predictedAngle:Number = NaN;
         var action:uint = 0;
         if(this.waypointIndex < this.waypoints.length)
         {
            enemyTank = tank;
            position = enemyTank.body.state.position;
            waypoint = this.waypoints[this.waypointIndex];
            this.direction.x = waypoint.x - position.x;
            this.direction.y = waypoint.y - position.y;
            this.direction.z = 0;
            distanceSqr = this.direction.x * this.direction.x + this.direction.y * this.direction.y;
            this.direction.normalize();
            matrix = enemyTank.body.jefe;
            forward.x = matrix.cydop;
            forward.y = matrix.qanezycap;
            forward.normalize();
            cross = forward.x * this.direction.y - forward.y * this.direction.x;
            angle = Math.asin(cross);
            angularVelocityZ = Number(enemyTank.body.state.fev.z);
            predictedAngle = angle + angularVelocityZ * GameData.time.deltaTime;
            if(Math.cos(predictedAngle) > veco)
            {
               action |= 1 << CommonTankController.cyjeruqa;
            }
            if(distanceSqr < 110000)
            {
               ++this.waypointIndex;
               if(this.waypointIndex == this.waypoints.length)
               {
                  if(loop)
                  {
                     this.waypointIndex = 0;
                  }
                  else
                  {
                     action = 0;
                     if(state < STATE_DEAD)
                     {
                        state = STATE_IDLE;
                     }
                  }
                  return;
               }
            }
            if(MathUtils.sign(predictedAngle) == MathUtils.sign(angle))
            {
               if(Math.abs(predictedAngle) > Math.PI)
               {
                  if(angularVelocityZ > 0)
                  {
                     action |= 1 << CommonTankController.dudazodol;
                  }
                  else if(angularVelocityZ < 0)
                  {
                     action |= 1 << CommonTankController.qij;
                  }
               }
               else if(Math.abs(predictedAngle) > nuzofaqi)
               {
                  if(angle > 0)
                  {
                     action |= 1 << CommonTankController.dudazodol;
                  }
                  else
                  {
                     action |= 1 << CommonTankController.qij;
                  }
               }
            }
         }
         var timeData:TimeData = GameData.time;
         CommonTankController(controller).setAction(action | tryShoot(timeData.time));
      }
      
      override protected function onDecoy() : void
      {
         super.onDecoy();
      }
   }
}

