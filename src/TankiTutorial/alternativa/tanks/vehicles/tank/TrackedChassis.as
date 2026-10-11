package alternativa.tanks.vehicles.tank
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.tanks.vehicles.tank.physics.SuspensionParams;
   import alternativa.tanks.vehicles.tank.physics.SuspensionRay;
   import alternativa.tanks.vehicles.tank.physics.Track;
   import alternativa.utils.MathUtils;
   
   public class TrackedChassis
   {
      
      private static const tyqufisen:Number = 400;
      
      private static const xAxis:Vector3 = new Vector3();
      
      private static const yAxis:Vector3 = new Vector3();
      
      private static const zAxis:Vector3 = new Vector3();
      
      private static const surfaceVelocity:Vector3 = new Vector3();
      
      private static const surfaceAngularVelocity:Vector3 = new Vector3();
      
      private static const relativeVelocity:Vector3 = new Vector3();
      
      private static const relativeAngularVelocity:Vector3 = new Vector3();
      
      private static const force:Vector3 = new Vector3();
      
      private static const contactsCenter:Vector3 = new Vector3();
      
      private var body:Body;
      
      private var suspensionParams:SuspensionParams;
      
      private var maxSpeedSmoother:ValueSmoother;
      
      internal var leftTrack:Track;
      
      internal var rightTrack:Track;
      
      internal var movementLocked:Boolean;
      
      internal var movementDirection:int;
      
      internal var turnDirection:int;
      
      internal var cewubegy:Boolean;
      
      private var acceleration:Number = 1306;
      
      private var reverseAcceleration:Number = 1461;
      
      private var sideAcceleration:Number = 1439;
      
      private var turnAcceleration:Number = MathUtils.toRadians(141.9);
      
      private var reverseTurnAcceleration:Number = MathUtils.toRadians(203.9);
      
      public function TrackedChassis(body:Body, suspensionParams:SuspensionParams, maxSpeedSmoother:ValueSmoother, size:Vector3)
      {
         super();
         this.body = body;
         this.suspensionParams = suspensionParams;
         this.maxSpeedSmoother = maxSpeedSmoother;
         this.createTracks(TankConst.NUM_RAYS_PER_TRACK,size);
      }
      
      private function createTracks(numRays:int, size:Vector3) : void
      {
         var trackLength:Number = size.y * 0.8;
         var trackSpacing:Number = size.x - 40;
         this.leftTrack = new Track(this.body,numRays,new Vector3(-0.5 * trackSpacing,0,-0.5 * size.z + TankConst.kyr),trackLength,this.suspensionParams,-1);
         this.rightTrack = new Track(this.body,numRays,new Vector3(0.5 * trackSpacing,0,-0.5 * size.z + TankConst.kyr),trackLength,this.suspensionParams,1);
      }
      
      public function setAcceleration(value:Number) : void
      {
         this.acceleration = value;
      }
      
      public function setReverseAcceleration(value:Number) : void
      {
         this.reverseAcceleration = value;
      }
      
      public function setSideAcceleration(value:Number) : void
      {
         this.sideAcceleration = value;
      }
      
      public function setTurnAcceleration(value:Number) : void
      {
         this.turnAcceleration = value;
      }
      
      public function setReverseTurnAcceleration(value:Number) : void
      {
         this.reverseTurnAcceleration = value;
      }
      
      public function getAcceleration() : Number
      {
         return this.acceleration;
      }
      
      public function getActualMovementDirection() : int
      {
         return this.movementLocked ? 0 : this.movementDirection;
      }
      
      public function getActualTurnDirection() : int
      {
         return this.movementLocked ? 0 : this.turnDirection;
      }
      
      public function setTracksCollisionGroup(collisionGroup:int) : void
      {
         this.leftTrack.setCollisionGroup(collisionGroup);
         this.rightTrack.setCollisionGroup(collisionGroup);
      }
      
      public function applyForces(maxSpeed:Number, maxTurnSpeed:Number, dt:Number) : void
      {
         this.adjustSuspensionSpringCoeff();
         this.calculateSuspensionContacts(dt);
         this.applyMovementForces(maxSpeed,maxTurnSpeed,dt);
         this.applySlopeHack();
      }
      
      private function adjustSuspensionSpringCoeff() : void
      {
         var weight:Number = this.body.scene.gravity.length() * this.body.mass;
         this.suspensionParams.springCoeff = weight / (2 * TankConst.NUM_RAYS_PER_TRACK * (this.suspensionParams.rayLength - this.suspensionParams.nominalRayLength));
      }
      
      private function calculateSuspensionContacts(dt:Number) : void
      {
         this.leftTrack.calculateSuspensionContacts(dt);
         this.rightTrack.calculateSuspensionContacts(dt);
      }
      
      private function applyMovementForces(maxSpeed:Number, maxTurnSpeed:Number, dt:Number) : void
      {
         if(this.leftTrack.numContacts + this.rightTrack.numContacts > 0)
         {
            this.doApplyMovementForces(maxSpeed,maxTurnSpeed,dt);
         }
      }
      
      private function doApplyMovementForces(maxSpeed:Number, maxTurnSpeed:Number, dt:Number) : void
      {
         var rotation:Vector3 = null;
         var matrix:Matrix3 = null;
         var slopeCoeff:Number = NaN;
         var speedDelta:Number = NaN;
         var newSpeed:Number = NaN;
         var actualSpeedDelta:Number = NaN;
         var _loc23_:Number = NaN;
         var remainingSpeedRatio:Number = NaN;
         var requiredAcceleration:Number = NaN;
         var totalForce:Number = NaN;
         var numContacts:int = 0;
         var _loc28_:Number = NaN;
         var forcePerRay:Number = NaN;
         var minRaySlopeAngle:Number = NaN;
         var maxRaySlopeAngle:Number = NaN;
         var i:int = 0;
         var turnSpeedCoeff:Number = NaN;
         var turnSpeedDelta:Number = NaN;
         var newTurnSpeed:Number = NaN;
         var actualMovementDirection:int = this.movementLocked ? 0 : this.movementDirection;
         var actualTurnDirection:int = this.movementLocked ? 0 : this.turnDirection;
         var velocity:Vector3 = this.body.state.velocity;
         rotation = this.body.state.rotation;
         matrix = this.body.orientationMatrix;
         xAxis.x = matrix.ma;
         xAxis.y = matrix.me;
         xAxis.z = matrix.mi;
         yAxis.x = matrix.mb;
         yAxis.y = matrix.mf;
         yAxis.z = matrix.mj;
         zAxis.x = matrix.mc;
         zAxis.y = matrix.mg;
         zAxis.z = matrix.mk;
         slopeCoeff = 1;
         var minSlopeAngle:Number = Math.PI / 4;
         var maxSlopeAngle:Number = Math.PI / 3;
         if(zAxis.z < Math.cos(minSlopeAngle))
         {
            if(zAxis.z < Math.cos(maxSlopeAngle))
            {
               slopeCoeff = 0;
            }
            else
            {
               slopeCoeff = (maxSlopeAngle - Math.acos(zAxis.z)) / (maxSlopeAngle - minSlopeAngle);
            }
         }
         this.calculateSurfaceVelocities(surfaceVelocity,surfaceAngularVelocity);
         relativeVelocity.x = velocity.x - surfaceVelocity.x;
         relativeVelocity.y = velocity.y - surfaceVelocity.y;
         relativeVelocity.z = velocity.z - surfaceVelocity.z;
         relativeAngularVelocity.x = rotation.x - surfaceAngularVelocity.x;
         relativeAngularVelocity.y = rotation.y - surfaceAngularVelocity.y;
         relativeAngularVelocity.z = rotation.z - surfaceAngularVelocity.z;
         var forwardSpeed:Number = relativeVelocity.x * yAxis.x + relativeVelocity.y * yAxis.y + relativeVelocity.z * yAxis.z;
         var turnSpeed:Number = relativeAngularVelocity.x * zAxis.x + relativeAngularVelocity.y * zAxis.y + relativeAngularVelocity.z * zAxis.z;
         var sideSpeed:Number = relativeVelocity.x * xAxis.x + relativeVelocity.y * xAxis.y + relativeVelocity.z * xAxis.z;
         var sideSpeedDelta:Number = this.sideAcceleration * slopeCoeff * dt;
         if(sideSpeed < 0)
         {
            if(sideSpeedDelta > -sideSpeed)
            {
               sideSpeed = 0;
            }
            else
            {
               sideSpeed += sideSpeedDelta;
            }
         }
         else if(sideSpeed > 0)
         {
            if(sideSpeedDelta > sideSpeed)
            {
               sideSpeed = 0;
            }
            else
            {
               sideSpeed -= sideSpeedDelta;
            }
         }
         relativeVelocity.setLengthAlongDirection(xAxis,sideSpeed);
         velocity.x = surfaceVelocity.x + relativeVelocity.x;
         velocity.y = surfaceVelocity.y + relativeVelocity.y;
         velocity.z = surfaceVelocity.z + relativeVelocity.z;
         var numLeftContacts:int = this.leftTrack.numContacts;
         var numRightContacts:int = this.rightTrack.numContacts;
         var linearAcceleration:Number = this.acceleration;
         var angularAcceleration:Number = this.turnAcceleration;
         if(numLeftContacts > 0 || numRightContacts > 0)
         {
            speedDelta = 0;
            if(actualMovementDirection == 0)
            {
               speedDelta = -MathUtils.sign(forwardSpeed) * linearAcceleration * dt;
               if(MathUtils.sign(forwardSpeed) != MathUtils.sign(forwardSpeed + speedDelta))
               {
                  speedDelta = -forwardSpeed;
               }
            }
            else
            {
               if(MathUtils.sign(forwardSpeed) * MathUtils.sign(actualMovementDirection) < 0)
               {
                  linearAcceleration = this.reverseAcceleration;
               }
               speedDelta = actualMovementDirection * linearAcceleration * dt;
            }
            newSpeed = MathUtils.clamp(forwardSpeed + speedDelta,-maxSpeed,maxSpeed);
            actualSpeedDelta = newSpeed - forwardSpeed;
            _loc23_ = 1;
            remainingSpeedRatio = MathUtils.clamp(1 - Math.abs(forwardSpeed / maxSpeed),0,1);
            if(remainingSpeedRatio < _loc23_ && actualMovementDirection * MathUtils.sign(forwardSpeed) > 0)
            {
               actualSpeedDelta *= remainingSpeedRatio / _loc23_;
            }
            requiredAcceleration = actualSpeedDelta / dt;
            if(Math.abs(requiredAcceleration) < tyqufisen && Math.abs(newSpeed) > 0.5 * this.maxSpeedSmoother.getTargetValue())
            {
               requiredAcceleration = MathUtils.numberSign(requiredAcceleration,0.1) * tyqufisen;
            }
            totalForce = requiredAcceleration * this.body.mass;
            numContacts = numLeftContacts + numRightContacts;
            _loc28_ = totalForce * (numContacts + 0.42 * (10 - numLeftContacts)) / 10;
            forcePerRay = _loc28_ / numContacts;
            minRaySlopeAngle = Math.PI / 4;
            maxRaySlopeAngle = Math.PI / 3;
            i = 0;
            while(i < TankConst.NUM_RAYS_PER_TRACK)
            {
               this.applyForceFromRay(this.leftTrack.rays[i],yAxis,forcePerRay,maxRaySlopeAngle,minRaySlopeAngle);
               this.applyForceFromRay(this.rightTrack.rays[i],yAxis,forcePerRay,maxRaySlopeAngle,minRaySlopeAngle);
               i++;
            }
            turnSpeedCoeff = 1;
            if(numLeftContacts == 0 || numRightContacts == 0)
            {
               turnSpeedCoeff = 0.5;
            }
            turnSpeedDelta = 0;
            if(actualTurnDirection == 0)
            {
               turnSpeedDelta = -MathUtils.sign(turnSpeed) * angularAcceleration * slopeCoeff * dt;
               if(MathUtils.sign(turnSpeed) != MathUtils.sign(turnSpeed + turnSpeedDelta))
               {
                  turnSpeedDelta = -turnSpeed;
               }
            }
            else
            {
               if(this.isReversedTurn(actualTurnDirection,turnSpeed))
               {
                  angularAcceleration = this.reverseTurnAcceleration;
               }
               turnSpeedDelta = actualTurnDirection * angularAcceleration * slopeCoeff * dt;
               if(actualMovementDirection == -1 && this.cewubegy)
               {
                  turnSpeedDelta = -turnSpeedDelta;
               }
            }
            newTurnSpeed = MathUtils.clamp(turnSpeed + turnSpeedDelta,-maxTurnSpeed * turnSpeedCoeff,maxTurnSpeed * turnSpeedCoeff);
            relativeAngularVelocity.setLengthAlongDirection(zAxis,newTurnSpeed);
            rotation.x = surfaceAngularVelocity.x + relativeAngularVelocity.x;
            rotation.y = surfaceAngularVelocity.y + relativeAngularVelocity.y;
            rotation.z = surfaceAngularVelocity.z + relativeAngularVelocity.z;
         }
      }
      
      private function isReversedTurn(direction:int, turnSpeed:Number) : Boolean
      {
         return direction * turnSpeed < 0;
      }
      
      private function calculateSurfaceVelocities(velocity:Vector3, angularVelocity:Vector3) : void
      {
         var ray:SuspensionRay = null;
         var i:int = 0;
         var position:Vector3 = null;
         var y:Number = NaN;
         var z:Number = NaN;
         var invNumContacts:Number = 1 / (this.leftTrack.numContacts + this.rightTrack.numContacts);
         var x:Number = 0;
         y = 0;
         z = 0;
         i = 0;
         while(i < TankConst.NUM_RAYS_PER_TRACK)
         {
            ray = this.leftTrack.rays[i];
            if(ray.colliding)
            {
               position = ray.rayHit.position;
               x += position.x;
               y += position.y;
               z += position.z;
            }
            ray = this.rightTrack.rays[i];
            if(ray.colliding)
            {
               position = ray.rayHit.position;
               x += position.x;
               y += position.y;
               z += position.z;
            }
            i++;
         }
         x *= invNumContacts;
         y *= invNumContacts;
         z *= invNumContacts;
         contactsCenter.x = x;
         contactsCenter.y = y;
         contactsCenter.z = z;
         velocity.x = 0;
         velocity.y = 0;
         velocity.z = 0;
         angularVelocity.x = 0;
         angularVelocity.y = 0;
         angularVelocity.z = 0;
         i = 0;
         while(i < TankConst.NUM_RAYS_PER_TRACK)
         {
            this.addVelocitiesFromRay(this.leftTrack.rays[i],contactsCenter,velocity,angularVelocity);
            this.addVelocitiesFromRay(this.rightTrack.rays[i],contactsCenter,velocity,angularVelocity);
            i++;
         }
         velocity.x *= invNumContacts;
         velocity.y *= invNumContacts;
         velocity.z *= invNumContacts;
         angularVelocity.x *= invNumContacts;
         angularVelocity.y *= invNumContacts;
         angularVelocity.z *= invNumContacts;
      }
      
      private function addVelocitiesFromRay(ray:SuspensionRay, center:Vector3, velocity:Vector3, angularVelocity:Vector3) : void
      {
         var position:Vector3 = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var distanceSqr:Number = NaN;
         var invDistanceSqr:Number = NaN;
         var contactVelocity:Vector3 = null;
         var wx:Number = NaN;
         var wy:Number = NaN;
         var wz:Number = NaN;
         if(ray.colliding)
         {
            velocity.x += ray.contactVelocity.x;
            velocity.y += ray.contactVelocity.y;
            velocity.z += ray.contactVelocity.z;
            position = ray.rayHit.position;
            dx = position.x - center.x;
            dy = position.y - center.y;
            dz = position.z - center.z;
            distanceSqr = dx * dx + dy * dy + dz * dz;
            if(distanceSqr > 1)
            {
               invDistanceSqr = 1 / distanceSqr;
               contactVelocity = ray.contactVelocity;
               wx = (dy * contactVelocity.z - dz * contactVelocity.y) * invDistanceSqr;
               wy = (dz * contactVelocity.x - dx * contactVelocity.z) * invDistanceSqr;
               wz = (dx * contactVelocity.y - dy * contactVelocity.x) * invDistanceSqr;
               angularVelocity.x += wx;
               angularVelocity.y += wy;
               angularVelocity.z += wz;
            }
         }
      }
      
      private function applyForceFromRay(ray:SuspensionRay, direction:Vector3, forceMagnitude:Number, maxAngle:Number, minAngle:Number) : void
      {
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var lengthSqr:Number = NaN;
         var slopeAngle:Number = NaN;
         var forceScale:Number = NaN;
         if(ray.colliding)
         {
            dx = direction.x;
            dy = direction.y;
            dz = direction.z;
            lengthSqr = dx * dx + dy * dy + dz * dz;
            if(lengthSqr > 0.00001)
            {
               slopeAngle = Math.acos(ray.rayHit.normal.z);
               if(slopeAngle < 0)
               {
                  slopeAngle = -slopeAngle;
               }
               if(slopeAngle < maxAngle)
               {
                  forceScale = forceMagnitude / Math.sqrt(lengthSqr);
                  if(slopeAngle > minAngle)
                  {
                     forceScale *= (maxAngle - slopeAngle) / (maxAngle - minAngle);
                  }
                  force.x = dx * forceScale;
                  force.y = dy * forceScale;
                  force.z = dz * forceScale;
                  this.body.addWorldForceAtLocalPoint(ray.getOrigin(),force);
               }
            }
         }
      }
      
      private function applySlopeHack() : void
      {
         var matrix:Matrix3 = null;
         var gravity:Vector3 = null;
         var dot:Number = NaN;
         var gravityMagnitude:Number = NaN;
         var threshold:Number = NaN;
         var fx:Number = NaN;
         var fy:Number = NaN;
         var fz:Number = NaN;
         if(this.rightTrack.numContacts >= this.rightTrack.numRays >> 1 || this.leftTrack.numContacts >= this.leftTrack.numRays >> 1)
         {
            matrix = this.body.orientationMatrix;
            gravity = this.body.scene.gravity;
            dot = gravity.x * matrix.mc + gravity.y * matrix.mg + gravity.z * matrix.mk;
            gravityMagnitude = gravity.length();
            threshold = Math.SQRT1_2 * gravityMagnitude;
            if(dot < -threshold || dot > threshold)
            {
               fx = (matrix.mc * dot - gravity.x) * this.body.mass;
               fy = (matrix.mg * dot - gravity.y) * this.body.mass;
               fz = (matrix.mk * dot - gravity.z) * this.body.mass;
               this.body.addForceXYZ(fx,fy,fz);
            }
         }
      }
   }
}

