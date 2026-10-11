package alternativa.tanks.vehicles.tank
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.tanks.vehicles.tank.physics.SuspensionRay;
   import alternativa.tanks.vehicles.tank.physics.Track;
   import alternativa.tanks.vehicles.tank.skin.TankSkin;
   import alternativa.utils.MathUtils;
   
   public class TracksAnimator
   {
      
      private static const garyvacy:Number = 100;
      
      private static const pointVelocity:Vector3 = new Vector3();
      
      private var chassis:TrackedChassis;
      
      private var skin:TankSkin;
      
      private var maxSpeedSmoother:ValueSmoother;
      
      public function TracksAnimator(chassis:TrackedChassis, skin:TankSkin, maxSpeedSmoother:ValueSmoother)
      {
         super();
         this.chassis = chassis;
         this.skin = skin;
         this.maxSpeedSmoother = maxSpeedSmoother;
      }
      
      public function animate(dt:Number) : void
      {
         this.calculateTracksAnimationSpeed(dt);
         this.skin.updateTracks(dt * this.chassis.leftTrack.animationSpeed,dt * this.chassis.rightTrack.animationSpeed);
      }
      
      private function calculateTracksAnimationSpeed(dt:Number) : void
      {
         this.calculateTrackAnimationSpeed(this.chassis.leftTrack,dt);
         this.calculateTrackAnimationSpeed(this.chassis.rightTrack,dt);
      }
      
      private function calculateTrackAnimationSpeed(track:Track, dt:Number) : void
      {
         if(this.hasCorrectContacts(track))
         {
            this.animateTrackWithContacts(track,dt);
         }
         else
         {
            this.animateTrackWithoutContacts(track,dt);
         }
      }
      
      private function hasCorrectContacts(track:Track) : Boolean
      {
         return track.body.orientationMatrix.mk > 0 && track.numContacts > 0;
      }
      
      private function animateTrackWithContacts(track:Track, dt:Number) : void
      {
         var targetSpeed:Number = NaN;
         var trackSpeed:Number = this.getTrackSpeed(track);
         if(this.requiresSynchronizedAnimation(track,trackSpeed))
         {
            track.animationSpeed = trackSpeed;
         }
         else
         {
            targetSpeed = this.getDesiredSpeedCoeff(track) * garyvacy;
            track.setAnimationSpeed(targetSpeed,this.chassis.getAcceleration() * dt);
         }
      }
      
      private function getTrackSpeed(track:Track) : Number
      {
         var contactVelocity:Vector3 = track.averageContactVelocity;
         var ray:SuspensionRay = track.rays[track.numRays >> 1];
         this.getBodyPointVelocity(track.body,ray.getGlobalOrigin(),pointVelocity);
         var dx:Number = pointVelocity.x - contactVelocity.x;
         var dy:Number = pointVelocity.y - contactVelocity.y;
         var dz:Number = pointVelocity.z - contactVelocity.z;
         var matrix:Matrix3 = track.body.orientationMatrix;
         return dx * matrix.mb + dy * matrix.mf + dz * matrix.mj;
      }
      
      private function getBodyPointVelocity(body:Body, point:Vector3, result:Vector3) : void
      {
         var dx:Number = NaN;
         var rotation:Vector3 = null;
         var position:Vector3 = body.state.position;
         dx = point.x - position.x;
         var dy:Number = point.y - position.y;
         var dz:Number = point.z - position.z;
         rotation = body.state.rotation;
         result.x = rotation.y * dz - rotation.z * dy;
         result.y = rotation.z * dx - rotation.x * dz;
         result.z = rotation.x * dy - rotation.y * dx;
         var velocity:Vector3 = body.state.velocity;
         result.x += velocity.x;
         result.y += velocity.y;
         result.z += velocity.z;
      }
      
      private function requiresSynchronizedAnimation(track:Track, speed:Number) : Boolean
      {
         var coeff:Number = this.getDesiredSpeedCoeff(track);
         return Math.abs(speed) > 0.8 * garyvacy || coeff == 0 || MathUtils.numberSign(speed,1) * MathUtils.sign(coeff) == -1;
      }
      
      private function getDesiredSpeedCoeff(track:Track) : Number
      {
         var movementDirection:int = this.chassis.getActualMovementDirection();
         var turnDirection:int = this.chassis.getActualTurnDirection();
         var coeff:Number = 0;
         if(movementDirection == 0)
         {
            coeff = track.side * turnDirection * 0.5;
         }
         else if(turnDirection == 0)
         {
            coeff = movementDirection;
         }
         else
         {
            coeff = movementDirection * (3 + track.side * turnDirection) / 4;
         }
         return coeff;
      }
      
      private function animateTrackWithoutContacts(track:Track, dt:Number) : void
      {
         var coeff:Number = this.getDesiredSpeedCoeff(track);
         track.setAnimationSpeed(coeff * this.maxSpeedSmoother.getTargetValue(),this.chassis.getAcceleration() * dt);
      }
   }
}

