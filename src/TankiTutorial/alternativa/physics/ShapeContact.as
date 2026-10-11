package alternativa.physics
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionShape;
   
   public class ShapeContact
   {
      
      private static var poolSize:int;
      
      private static const pool:Vector.<ShapeContact> = new Vector.<ShapeContact>();
      
      public var position:Vector3 = new Vector3();
      
      public var penetration:Number;
      
      public var normal:Vector3 = new Vector3();
      
      public var tangent:Vector3 = new Vector3();
      
      public var binormal:Vector3 = new Vector3();
      
      public var targetNormalVelocity:Number;
      
      public var targetPseudoVelocity:Number;
      
      public var normalInvMass:Number;
      
      public var tangentInvMass:Number;
      
      public var binormalInvMass:Number;
      
      public var normalAngularTerm1:Number;
      
      public var normalAngularTerm2:Number;
      
      public var tangentAngularTerm1:Number;
      
      public var binormalAngularTerm1:Number;
      
      public var tangentAngularTerm2:Number;
      
      public var binormalAngularTerm2:Number;
      
      public var divute:Vector3 = new Vector3();
      
      public var bamod:Vector3 = new Vector3();
      
      public var normalImpulse:Number;
      
      public var tangentImpulse:Number;
      
      public var binormalImpulse:Number;
      
      public var caduk:Boolean;
      
      public var restitution:Number;
      
      public var friction:Number;
      
      public var shape1:CollisionShape;
      
      public var shape2:CollisionShape;
      
      public function ShapeContact()
      {
         super();
      }
      
      public static function create() : ShapeContact
      {
         if(poolSize == 0)
         {
            return new ShapeContact();
         }
         --poolSize;
         var contact:ShapeContact = pool[poolSize];
         pool[poolSize] = null;
         return contact;
      }
      
      public function dispose() : void
      {
         this.shape1 = null;
         this.shape2 = null;
         pool[poolSize] = this;
         ++poolSize;
      }
      
      public function calculatePersistentFrameData() : void
      {
         var bodyPosition:Vector3 = null;
         var body1:Body = this.shape1.body;
         var body2:Body = this.shape2.body;
         this.restitution = this.shape1.material.restitution;
         var restitution2:Number = this.shape2.material.restitution;
         if(restitution2 < this.restitution)
         {
            this.restitution = restitution2;
         }
         this.friction = this.shape1.material.friction;
         var friction2:Number = this.shape2.material.friction;
         if(friction2 < this.friction)
         {
            this.friction = friction2;
         }
         bodyPosition = this.shape1.body.state.position;
         this.divute.x = this.position.x - bodyPosition.x;
         this.divute.y = this.position.y - bodyPosition.y;
         this.divute.z = this.position.z - bodyPosition.z;
         bodyPosition = this.shape2.body.state.position;
         this.bamod.x = this.position.x - bodyPosition.x;
         this.bamod.y = this.position.y - bodyPosition.y;
         this.bamod.z = this.position.z - bodyPosition.z;
         if(Math.abs(this.normal.x) < Math.abs(this.normal.y))
         {
            this.tangent.cross2(this.normal,Vector3.xAxis).normalize();
         }
         else
         {
            this.tangent.cross2(this.normal,Vector3.yAxis).normalize();
         }
         this.binormal.cross2(this.normal,this.tangent);
         this.normalImpulse = 0;
         this.tangentImpulse = 0;
         this.binormalImpulse = 0;
         this.normalInvMass = 0;
         this.tangentInvMass = 0;
         this.binormalInvMass = 0;
         if(body1.movable)
         {
            this.normalAngularTerm1 = this.calculateAngularInertiaTerm(this.normal,this.divute,body1.invInertiaWorld);
            this.tangentAngularTerm1 = this.calculateAngularInertiaTerm(this.tangent,this.divute,body1.invInertiaWorld);
            this.binormalAngularTerm1 = this.calculateAngularInertiaTerm(this.binormal,this.divute,body1.invInertiaWorld);
            this.normalInvMass += body1.invMass + this.normalAngularTerm1;
            this.tangentInvMass += body1.invMass + this.tangentAngularTerm1;
            this.binormalInvMass += body1.invMass + this.binormalAngularTerm1;
         }
         if(body2.movable)
         {
            this.normalAngularTerm2 = this.calculateAngularInertiaTerm(this.normal,this.bamod,body2.invInertiaWorld);
            this.tangentAngularTerm2 = this.calculateAngularInertiaTerm(this.tangent,this.bamod,body2.invInertiaWorld);
            this.binormalAngularTerm2 = this.calculateAngularInertiaTerm(this.binormal,this.bamod,body2.invInertiaWorld);
            this.normalInvMass += body2.invMass + this.normalAngularTerm2;
            this.tangentInvMass += body2.invMass + this.tangentAngularTerm2;
            this.binormalInvMass += body2.invMass + this.binormalAngularTerm2;
         }
         this.targetNormalVelocity = this.getSeparationVelocity();
         if(this.targetNormalVelocity < 0)
         {
            this.targetNormalVelocity = -this.restitution * this.targetNormalVelocity;
         }
      }
      
      private function calculateAngularInertiaTerm(axis:Vector3, r:Vector3, invInertia:Matrix3) : Number
      {
         var cx:Number = r.y * axis.z - r.z * axis.y;
         var cy:Number = r.z * axis.x - r.x * axis.z;
         var cz:Number = r.x * axis.y - r.y * axis.x;
         var ix:Number = invInertia.ma * cx + invInertia.mb * cy + invInertia.mc * cz;
         var iy:Number = invInertia.me * cx + invInertia.mf * cy + invInertia.mg * cz;
         var iz:Number = invInertia.mi * cx + invInertia.mj * cy + invInertia.mk * cz;
         cx = iy * r.z - iz * r.y;
         cy = iz * r.x - ix * r.z;
         cz = ix * r.y - iy * r.x;
         return cx * axis.x + cy * axis.y + cz * axis.z;
      }
      
      public function getSeparationVelocity() : Number
      {
         var angularVelocity:Vector3 = this.shape1.body.state.rotation;
         var cx:Number = angularVelocity.y * this.divute.z - angularVelocity.z * this.divute.y;
         var cy:Number = angularVelocity.z * this.divute.x - angularVelocity.x * this.divute.z;
         var cz:Number = angularVelocity.x * this.divute.y - angularVelocity.y * this.divute.x;
         var v:Vector3 = this.shape1.body.state.velocity;
         var vx:Number = v.x + cx;
         var vy:Number = v.y + cy;
         var vz:Number = v.z + cz;
         angularVelocity = this.shape2.body.state.rotation;
         cx = angularVelocity.y * this.bamod.z - angularVelocity.z * this.bamod.y;
         cy = angularVelocity.z * this.bamod.x - angularVelocity.x * this.bamod.z;
         cz = angularVelocity.x * this.bamod.y - angularVelocity.y * this.bamod.x;
         v = this.shape2.body.state.velocity;
         vx -= v.x + cx;
         vy -= v.y + cy;
         vz -= v.z + cz;
         return vx * this.normal.x + vy * this.normal.y + vz * this.normal.z;
      }
      
      public function calcualteDynamicFrameData(allowedPenetration:Number, penetrationCorrectionFactor:Number, maxPenetrationCorrection:Number, dt:Number) : void
      {
         var depth:Number = NaN;
         var body1:Body = this.shape1.body;
         var body2:Body = this.shape2.body;
         this.normalInvMass = 0;
         this.tangentInvMass = 0;
         this.binormalInvMass = 0;
         if(body1.movable)
         {
            this.normalInvMass += body1.invMass + this.normalAngularTerm1;
            this.tangentInvMass += body1.invMass + this.tangentAngularTerm1;
            this.binormalInvMass += body1.invMass + this.binormalAngularTerm1;
         }
         if(body2.movable)
         {
            this.normalInvMass += body2.invMass + this.normalAngularTerm2;
            this.tangentInvMass += body2.invMass + this.tangentAngularTerm2;
            this.binormalInvMass += body2.invMass + this.binormalAngularTerm2;
         }
         if(this.penetration > allowedPenetration)
         {
            depth = this.penetration - allowedPenetration;
            if(depth > maxPenetrationCorrection)
            {
               depth = maxPenetrationCorrection;
            }
            this.targetPseudoVelocity = penetrationCorrectionFactor * depth / dt;
         }
         else
         {
            this.targetPseudoVelocity = 0;
         }
      }
   }
}

