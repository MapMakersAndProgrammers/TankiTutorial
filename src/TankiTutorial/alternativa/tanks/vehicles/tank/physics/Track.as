package alternativa.tanks.vehicles.tank.physics
{
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   
   public class Track
   {
      
      public var body:Body;
      
      public var rays:Vector.<SuspensionRay>;
      
      public var numRays:int;
      
      public var numContacts:int;
      
      public var suspensionParams:SuspensionParams;
      
      public var animationSpeed:Number = 0;
      
      public var side:int;
      
      public const averageContactVelocity:Vector3 = new Vector3();
      
      public function Track(body:Body, numRays:int, center:Vector3, trackLength:Number, suspensionParams:SuspensionParams, side:int)
      {
         super();
         this.body = body;
         this.side = side;
         this.setTrackParams(numRays,center,trackLength,suspensionParams);
      }
      
      public function setTrackParams(numRays:int, center:Vector3, trackLength:Number, suspensionParams:SuspensionParams) : void
      {
         var rayOrigin:Vector3 = null;
         this.numRays = numRays;
         this.suspensionParams = suspensionParams;
         this.rays = new Vector.<SuspensionRay>(numRays);
         var raySpacing:Number = trackLength / (numRays - 1);
         var i:int = 0;
         while(i < numRays)
         {
            rayOrigin = new Vector3(center.x,center.y + 0.5 * trackLength - i * raySpacing,center.z);
            this.rays[i] = new SuspensionRay(this.body,rayOrigin,Vector3.down,suspensionParams);
            i++;
         }
      }
      
      public function setCollisionGroup(collisionGroup:int) : void
      {
         var i:int = 0;
         while(i < this.numRays)
         {
            SuspensionRay(this.rays[i]).collisionGroup = collisionGroup;
            i++;
         }
      }
      
      public function calculateSuspensionContacts(dt:Number) : void
      {
         var velocity:Vector3 = null;
         var ray:SuspensionRay = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         this.numContacts = 0;
         this.averageContactVelocity.x = 0;
         this.averageContactVelocity.y = 0;
         this.averageContactVelocity.z = 0;
         velocity = this.body.state.velocity;
         var i:int = 0;
         while(i < this.numRays)
         {
            ray = this.rays[i];
            ray.update(dt);
            if(ray.colliding)
            {
               ++this.numContacts;
               this.body.addWorldForceScaled(ray.getGlobalOrigin(),ray.getGlobalDirection(),-ray.springForce);
               this.averageContactVelocity.x += ray.contactVelocity.x;
               this.averageContactVelocity.y += ray.contactVelocity.y;
               this.averageContactVelocity.z += ray.contactVelocity.z;
               dx = velocity.x - ray.contactVelocity.x;
               dy = velocity.y - ray.contactVelocity.y;
               dz = velocity.z - ray.contactVelocity.z;
               ray.speed = Math.sqrt(dx * dx + dy * dy + dz * dz);
            }
            else
            {
               ray.speed = 0;
            }
            i++;
         }
         if(this.numContacts > 1)
         {
            this.averageContactVelocity.x /= this.numContacts;
            this.averageContactVelocity.y /= this.numContacts;
            this.averageContactVelocity.z /= this.numContacts;
         }
      }
      
      public function setAnimationSpeed(targetSpeed:Number, maxDelta:Number) : void
      {
         var speed:Number = NaN;
         if(this.animationSpeed < targetSpeed)
         {
            speed = this.animationSpeed + maxDelta;
            this.animationSpeed = speed > targetSpeed ? targetSpeed : speed;
         }
         else if(this.animationSpeed > targetSpeed)
         {
            speed = this.animationSpeed - maxDelta;
            this.animationSpeed = speed < targetSpeed ? targetSpeed : speed;
         }
      }
   }
}

