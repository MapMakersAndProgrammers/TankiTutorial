package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.physics.CollisionGroup;
   import flash.utils.Dictionary;
   
   public class ConicAreaTargetingSystem
   {
      
      private static const COLLISION_GROUP:int = CollisionGroup.WEAPON;
      
      private static const rayPoint:Vector3 = new Vector3();
      
      private var range:Number;
      
      private var halfConeAngle:Number;
      
      private var numRays:int;
      
      private var numSectors:int;
      
      private var collisionDetector:CollisionDetector;
      
      private var targetValidator:ConicAreaTargetValidator;
      
      private const sectorAxis:Vector3 = new Vector3();
      
      private const matrix:Matrix3 = new Matrix3();
      
      private const sectorMatrix:Matrix3 = new Matrix3();
      
      private const rayHit:RayHit = new RayHit();
      
      private const collisionFilter:ConicTargetingCollisionFilter = new ConicTargetingCollisionFilter();
      
      private const rayDirection:Vector3 = new Vector3();
      
      private const rayOrigin:Vector3 = new Vector3();
      
      private var targetDistances:Dictionary;
      
      public function ConicAreaTargetingSystem(range:Number, param2:Number, numRays:int, numSectors:int, collisionDetector:CollisionDetector, targetValidator:ConicAreaTargetValidator)
      {
         super();
         this.range = range;
         this.halfConeAngle = 0.5 * param2;
         this.numRays = numRays;
         this.numSectors = numSectors;
         this.collisionDetector = collisionDetector;
         this.targetValidator = targetValidator;
      }
      
      public function getTargets(body:Body, barrelLength:Number, param3:Number, barrelOrigin:Vector3, direction:Vector3, axis:Vector3, targets:Vector.<Body>, distances:Vector.<Number>) : void
      {
         var key:* = undefined;
         var distance:Number = NaN;
         this.collisionFilter.excludedBody = body;
         this.targetDistances = new Dictionary();
         var rayOriginOffset:Number = param3 * barrelLength;
         var muzzleDistance:Number = barrelLength - rayOriginOffset;
         if(this.collisionDetector.raycast(barrelOrigin,direction,COLLISION_GROUP,barrelLength,this.collisionFilter,this.rayHit) && this.rayHit.shape.body == null)
         {
            return;
         }
         this.sectorAxis.copy(axis);
         this.rayOrigin.copy(barrelOrigin).addScaled(rayOriginOffset,direction);
         var rayLength:Number = this.range + muzzleDistance;
         this.processRay(this.rayOrigin,direction,rayLength);
         this.sectorMatrix.fromAxisAngle(direction,Math.PI / this.numSectors);
         var angleStep:Number = this.halfConeAngle / this.numRays;
         var i:int = 0;
         while(i < this.numSectors)
         {
            this.processSector(this.rayOrigin,direction,this.sectorAxis,rayLength,this.numRays,angleStep);
            this.processSector(this.rayOrigin,direction,this.sectorAxis,rayLength,this.numRays,-angleStep);
            this.sectorAxis.transform3(this.sectorMatrix);
            i++;
         }
         var numTargets:int = 0;
         for(key in this.targetDistances)
         {
            targets[numTargets] = key;
            distance = this.targetDistances[key] - muzzleDistance;
            if(distance < 0)
            {
               distance = 0;
            }
            distances[numTargets] = distance;
            numTargets++;
         }
         targets.length = numTargets;
         distances.length = numTargets;
         this.collisionFilter.excludedBody = null;
         this.collisionFilter.clearInvalidTargets();
         this.targetDistances = null;
      }
      
      private function processSector(origin:Vector3, direction:Vector3, axis:Vector3, length:Number, numSectorRays:int, angleStep:Number) : void
      {
         var angle:Number = 0;
         var i:int = 0;
         while(i < numSectorRays)
         {
            angle += angleStep;
            this.matrix.fromAxisAngle(axis,angle);
            this.matrix.transformVector(direction,this.rayDirection);
            this.processRay(origin,this.rayDirection,length);
            i++;
         }
      }
      
      private function processRay(origin:Vector3, direction:Vector3, length:Number) : void
      {
         var body:Body = null;
         var prevDistance:Number = NaN;
         rayPoint.copy(origin);
         var distance:Number = 0;
         while(length > 0.1)
         {
            if(!this.collisionDetector.raycast(rayPoint,direction,COLLISION_GROUP,length,this.collisionFilter,this.rayHit))
            {
               break;
            }
            body = this.rayHit.shape.body;
            if(body == null)
            {
               break;
            }
            rayPoint.addScaled(this.rayHit.jomuc,direction);
            distance += this.rayHit.jomuc;
            if(this.targetValidator.isValidTarget(body))
            {
               this.collisionFilter.addTarget(body);
               prevDistance = Number(this.targetDistances[body]);
               if(isNaN(prevDistance) || prevDistance > distance)
               {
                  this.targetDistances[body] = distance;
               }
            }
            else
            {
               this.collisionFilter.addInvalidTarget(body);
            }
            length -= this.rayHit.jomuc;
         }
         this.collisionFilter.clearTargets();
      }
   }
}

