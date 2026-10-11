package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.physics.CollisionGroup;
   
   public class CommonTargetingSystem
   {
      
      private static const COLLISION_GROUP:int = CollisionGroup.WEAPON;
      
      private static const matrix:Matrix3 = new Matrix3();
      
      private static const sudak:Vector3 = new Vector3();
      
      private static const rayDirection:Vector3 = new Vector3();
      
      private static const rayHit:RayHit = new RayHit();
      
      private var maxDistance:Number;
      
      private var angleUp:Number;
      
      private var numRaysUp:int;
      
      private var angleDown:Number;
      
      private var numRaysDown:int;
      
      private var collisionDetector:CollisionDetector;
      
      private var targetEvaluator:CommonTargetEvaluator;
      
      private var maxPriority:Number;
      
      private var targetBody:Body;
      
      private var targetDistance:Number;
      
      private var targetDirection:Vector3 = new Vector3();
      
      private var normal:Vector3 = new Vector3();
      
      private var collisionFilter:CommonRayCollisionFilter = new CommonRayCollisionFilter();
      
      public function CommonTargetingSystem(maxDistance:Number, angleUp:Number, numRaysUp:int, angleDown:Number, numRaysDown:int, collisionDetector:CollisionDetector, targetEvaluator:CommonTargetEvaluator)
      {
         super();
         this.maxDistance = maxDistance;
         this.angleUp = angleUp;
         this.numRaysUp = numRaysUp;
         this.angleDown = angleDown;
         this.numRaysDown = numRaysDown;
         this.collisionDetector = collisionDetector;
         this.targetEvaluator = targetEvaluator;
      }
      
      public function getTarget(origin:Vector3, direction:Vector3, axis:Vector3, body:Body, param5:Number, result:HitInfo) : Boolean
      {
         var hitBody:Body = null;
         this.maxPriority = 0;
         this.targetDistance = this.maxDistance + 1;
         this.targetBody = null;
         this.collisionFilter.excludedBody = body;
         var maxAngle:Number = this.angleUp > this.angleDown ? this.angleUp : this.angleDown;
         if(this.collisionDetector.raycast(origin,direction,COLLISION_GROUP,this.maxDistance,this.collisionFilter,rayHit))
         {
            this.normal.copy(rayHit.normal);
            this.targetDirection.copy(direction);
            this.targetDistance = rayHit.time;
            hitBody = rayHit.shape.body;
            if(hitBody != null)
            {
               this.targetBody = hitBody;
               this.maxPriority = this.targetEvaluator.getTargetPriority(hitBody,this.targetDistance,0,param5,maxAngle);
            }
         }
         if(this.numRaysUp > 0)
         {
            this.checkSector(origin,direction,axis,this.numRaysUp,this.angleUp / this.numRaysUp,param5,maxAngle);
         }
         if(this.numRaysDown > 0)
         {
            this.checkSector(origin,direction,axis,this.numRaysDown,-this.angleDown / this.numRaysDown,param5,maxAngle);
         }
         this.collisionFilter.excludedBody = null;
         if(this.targetDistance <= this.maxDistance)
         {
            result.time = this.targetDistance;
            result.direction.copy(this.targetDirection);
            result.position.copy(origin).addScaled(this.targetDistance,this.targetDirection);
            result.body = this.targetBody;
            this.targetBody = null;
            return true;
         }
         return false;
      }
      
      private function checkSector(origin:Vector3, direction:Vector3, axis:Vector3, numRays:int, angleStep:Number, param6:Number, maxAngle:Number) : void
      {
         var hitBody:Body = null;
         var priority:Number = NaN;
         matrix.fromAxisAngle(axis,angleStep);
         if(angleStep < 0)
         {
            angleStep = -angleStep;
         }
         rayDirection.copy(direction);
         var angle:Number = 0;
         var i:int = 1;
         while(i <= numRays)
         {
            angle += angleStep;
            sudak.copy(rayDirection);
            matrix.transformVector(sudak,rayDirection);
            if(this.collisionDetector.raycast(origin,rayDirection,COLLISION_GROUP,this.maxDistance,this.collisionFilter,rayHit))
            {
               hitBody = rayHit.shape.body;
               if(hitBody != null)
               {
                  priority = this.targetEvaluator.getTargetPriority(hitBody,rayHit.time,angle,param6,maxAngle);
                  if(priority > this.maxPriority)
                  {
                     this.maxPriority = priority;
                     this.targetBody = hitBody;
                     this.targetDirection.copy(rayDirection);
                     this.targetDistance = rayHit.time;
                  }
               }
            }
            i++;
         }
      }
   }
}

