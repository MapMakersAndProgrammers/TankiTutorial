package alternativa.tanks.vehicles.tank.physics
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.collision.types.RayHit;
   
   public class SuspensionRay
   {
      
      public var collisionGroup:int;
      
      public var colliding:Boolean = false;
      
      public var rayHit:RayHit = new RayHit();
      
      public var springForce:Number = 0;
      
      public const contactVelocity:Vector3 = new Vector3();
      
      public var speed:Number = 0;
      
      private var body:Body;
      
      private var origin:Vector3 = new Vector3();
      
      private var direction:Vector3 = new Vector3();
      
      private var suspensionParams:SuspensionParams;
      
      private var globalOrigin:Vector3 = new Vector3();
      
      private var globalDirection:Vector3 = new Vector3();
      
      private var prevCompression:Number = 0;
      
      private var collisionFilter:RayCollisionFilter;
      
      public function SuspensionRay(body:Body, origin:Vector3, direction:Vector3, suspensionParams:SuspensionParams)
      {
         super();
         this.body = body;
         this.origin.copy(origin);
         this.direction.copy(direction);
         this.suspensionParams = suspensionParams;
         this.collisionFilter = new RayCollisionFilter(body);
      }
      
      public function update(dt:Number) : void
      {
         this.raycast();
         if(this.colliding)
         {
            this.calculateSpringForce(dt);
            this.calculateContactVelocity();
         }
      }
      
      private function raycast() : void
      {
         var matrix:Matrix3 = this.body.orientationMatrix;
         this.globalDirection.x = matrix.ma * this.direction.x + matrix.mb * this.direction.y + matrix.mc * this.direction.z;
         this.globalDirection.y = matrix.me * this.direction.x + matrix.mf * this.direction.y + matrix.mg * this.direction.z;
         this.globalDirection.z = matrix.mi * this.direction.x + matrix.mj * this.direction.y + matrix.mk * this.direction.z;
         var position:Vector3 = this.body.state.position;
         this.globalOrigin.x = matrix.ma * this.origin.x + matrix.mb * this.origin.y + matrix.mc * this.origin.z;
         this.globalOrigin.y = matrix.me * this.origin.x + matrix.mf * this.origin.y + matrix.mg * this.origin.z;
         this.globalOrigin.z = matrix.mi * this.origin.x + matrix.mj * this.origin.y + matrix.mk * this.origin.z;
         this.globalOrigin.x += position.x;
         this.globalOrigin.y += position.y;
         this.globalOrigin.z += position.z;
         if(this.colliding)
         {
            this.prevCompression = this.suspensionParams.rayLength - this.rayHit.jomuc;
         }
         this.colliding = this.body.scene.collisionDetector.raycast(this.globalOrigin,this.globalDirection,this.collisionGroup,this.suspensionParams.rayLength,this.collisionFilter,this.rayHit);
      }
      
      public function calculateSpringForce(dt:Number) : void
      {
         var compression:Number = this.suspensionParams.rayLength - this.rayHit.jomuc;
         this.springForce = this.suspensionParams.springCoeff * compression;
         var compressionSpeed:Number = (compression - this.prevCompression) / dt;
         this.springForce += compressionSpeed * this.suspensionParams.dampingCoeff;
         if(this.springForce < 0)
         {
            this.springForce = 0;
         }
      }
      
      private function calculateContactVelocity() : void
      {
         var position:Vector3 = null;
         var velocity:Vector3 = null;
         var rotation:Vector3 = null;
         var hitPosition:Vector3 = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var hitBody:Body = this.rayHit.shape.body;
         if(hitBody.data != null)
         {
            position = hitBody.state.position;
            velocity = hitBody.state.velocity;
            rotation = hitBody.state.rotation;
            hitPosition = this.rayHit.position;
            dx = hitPosition.x - position.x;
            dy = hitPosition.y - position.y;
            dz = hitPosition.z - position.z;
            this.contactVelocity.x = rotation.y * dz - rotation.z * dy;
            this.contactVelocity.y = rotation.z * dx - rotation.x * dz;
            this.contactVelocity.z = rotation.x * dy - rotation.y * dx;
            this.contactVelocity.x += velocity.x;
            this.contactVelocity.y += velocity.y;
            this.contactVelocity.z += velocity.z;
         }
         else
         {
            this.contactVelocity.x = 0;
            this.contactVelocity.y = 0;
            this.contactVelocity.z = 0;
         }
      }
      
      public function getGlobalOrigin() : Vector3
      {
         return this.globalOrigin;
      }
      
      public function getGlobalDirection() : Vector3
      {
         return this.globalDirection;
      }
      
      public function getOrigin() : Vector3
      {
         return this.origin;
      }
      
      public function getActualLength() : Number
      {
         if(this.colliding)
         {
            return this.rayHit.jomuc;
         }
         return this.suspensionParams.rayLength;
      }
   }
}

