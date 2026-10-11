package alternativa.physics
{
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.BodyCollisionFilter;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.types.AABB;
   
   public class Body
   {
      
      public static var linearDamping:Number = 0.997;
      
      public static var rotationDamping:Number = 0.997;
      
      private static const MAX_SPEED_Z:Number = 1500;
      
      private static const relativePoint:Vector3 = new Vector3();
      
      private static const worldForce:Vector3 = new Vector3();
      
      public var id:int;
      
      public var name:String;
      
      public var data:Object;
      
      public var scene:PhysicsScene;
      
      public var movable:Boolean = true;
      
      public var freezable:Boolean = false;
      
      public var freezeCounter:int;
      
      public var frozen:Boolean = false;
      
      public var aabb:AABB = new AABB();
      
      public var collisionFilter:BodyCollisionFilter;
      
      public var acceleration:Vector3 = new Vector3();
      
      public var angularAcceleration:Vector3 = new Vector3();
      
      public var prevState:BodyState = new BodyState();
      
      public var mass:Number = 1;
      
      public var invMass:Number = 1;
      
      public var invInertia:Matrix3 = new Matrix3();
      
      public var invInertiaWorld:Matrix3 = new Matrix3();
      
      public var orientationMatrix:Matrix3 = new Matrix3();
      
      public var prevVelocity:Vector3 = new Vector3();
      
      public var state:BodyState = new BodyState();
      
      private var maxSpeedZGain:Number = 600;
      
      private var minAccelerationZ:Number = -1100;
      
      public var collisionShapes:Vector.<CollisionShape>;
      
      public var numCollisionShapes:int;
      
      public var forceAccumulator:Vector3 = new Vector3();
      
      public var torqueAccumulator:Vector3 = new Vector3();
      
      public var pseudoVelocity:Vector3 = new Vector3();
      
      public var pseudoRotation:Vector3 = new Vector3();
      
      public function Body(mass:Number, invInertia:Matrix3)
      {
         super();
         this.mass = mass;
         this.invMass = 1 / mass;
         this.invInertia.copy(invInertia);
      }
      
      public function addCollisionShape(shape:CollisionShape, localTransform:Matrix4 = null) : void
      {
         if(shape == null)
         {
            throw new ArgumentError("Parameter is null");
         }
         if(this.collisionShapes == null)
         {
            this.collisionShapes = new Vector.<CollisionShape>();
            this.numCollisionShapes = 0;
         }
         this.collisionShapes.push(shape);
         this.numCollisionShapes = this.collisionShapes.length;
         shape.setBody(this,localTransform);
      }
      
      public function removeCollisionShape(shape:CollisionShape) : void
      {
         var index:int = 0;
         if(this.collisionShapes != null)
         {
            if(this.numCollisionShapes > 0)
            {
               index = this.collisionShapes.indexOf(shape);
               if(index >= 0)
               {
                  shape.setBody(null);
                  this.collisionShapes[index] = this.collisionShapes[--this.numCollisionShapes];
                  if(this.numCollisionShapes == 0)
                  {
                     this.collisionShapes = null;
                  }
                  else
                  {
                     this.collisionShapes.length = this.numCollisionShapes;
                  }
               }
            }
         }
      }
      
      public function interpolate(t:Number, pos:Vector3, quaternion:Quaternion) : void
      {
         var _loc4_:Number = NaN;
         _loc4_ = 1 - t;
         pos.x = this.prevState.position.x * _loc4_ + this.state.position.x * t;
         pos.y = this.prevState.position.y * _loc4_ + this.state.position.y * t;
         pos.z = this.prevState.position.z * _loc4_ + this.state.position.z * t;
         quaternion.w = this.prevState.orientation.w * _loc4_ + this.state.orientation.w * t;
         quaternion.x = this.prevState.orientation.x * _loc4_ + this.state.orientation.x * t;
         quaternion.y = this.prevState.orientation.y * _loc4_ + this.state.orientation.y * t;
         quaternion.z = this.prevState.orientation.z * _loc4_ + this.state.orientation.z * t;
      }
      
      public function setPosition(position:Vector3) : void
      {
         this.state.position.copy(position);
      }
      
      public function setPositionXYZ(x:Number, y:Number, z:Number) : void
      {
         this.state.position.reset(x,y,z);
      }
      
      public function setVelocity(v:Vector3) : void
      {
         this.state.velocity.copy(v);
      }
      
      public function setVelocityXYZ(x:Number, y:Number, z:Number) : void
      {
         this.state.velocity.reset(x,y,z);
      }
      
      public function setRotation(v:Vector3) : void
      {
         this.state.rotation.copy(v);
      }
      
      public function setRotationXYZ(x:Number, y:Number, z:Number) : void
      {
         this.state.rotation.reset(x,y,z);
      }
      
      public function setOrientation(q:Quaternion) : void
      {
         this.state.orientation.copy(q);
      }
      
      public function applyWorldImpulseAtLocalPoint(localPoint:Vector3, direction:Vector3, impulse:Number) : void
      {
         var factor:Number = NaN;
         var tx:Number = NaN;
         var tz:Number = NaN;
         factor = impulse * this.invMass;
         this.state.velocity.x += factor * direction.x;
         this.state.velocity.y += factor * direction.y;
         this.state.velocity.z += factor * direction.z;
         tx = (localPoint.y * direction.z - localPoint.z * direction.y) * impulse;
         var ty:Number = (localPoint.z * direction.x - localPoint.x * direction.z) * impulse;
         tz = (localPoint.x * direction.y - localPoint.y * direction.x) * impulse;
         this.state.rotation.x += this.invInertiaWorld.ma * tx + this.invInertiaWorld.mb * ty + this.invInertiaWorld.mc * tz;
         this.state.rotation.y += this.invInertiaWorld.me * tx + this.invInertiaWorld.mf * ty + this.invInertiaWorld.mg * tz;
         this.state.rotation.z += this.invInertiaWorld.mi * tx + this.invInertiaWorld.mj * ty + this.invInertiaWorld.mk * tz;
      }
      
      public function applyWorldPseudoImpulseAtLocalPoint(localPoint:Vector3, direction:Vector3, impulse:Number) : void
      {
         var factor:Number = NaN;
         var ty:Number = NaN;
         var tz:Number = NaN;
         factor = impulse * this.invMass;
         this.pseudoVelocity.x += factor * direction.x;
         this.pseudoVelocity.y += factor * direction.y;
         this.pseudoVelocity.z += factor * direction.z;
         var tx:Number = (localPoint.y * direction.z - localPoint.z * direction.y) * impulse;
         ty = (localPoint.z * direction.x - localPoint.x * direction.z) * impulse;
         tz = (localPoint.x * direction.y - localPoint.y * direction.x) * impulse;
         this.pseudoRotation.x += this.invInertiaWorld.ma * tx + this.invInertiaWorld.mb * ty + this.invInertiaWorld.mc * tz;
         this.pseudoRotation.y += this.invInertiaWorld.me * tx + this.invInertiaWorld.mf * ty + this.invInertiaWorld.mg * tz;
         this.pseudoRotation.z += this.invInertiaWorld.mi * tx + this.invInertiaWorld.mj * ty + this.invInertiaWorld.mk * tz;
      }
      
      public function applyImpulse(direction:Vector3, impulse:Number) : void
      {
         var factor:Number = impulse * this.invMass;
         this.state.velocity.x += factor * direction.x;
         this.state.velocity.y += factor * direction.y;
         this.state.velocity.z += factor * direction.z;
      }
      
      public function addForce(force:Vector3) : void
      {
         this.forceAccumulator.add(force);
      }
      
      public function addForceXYZ(fx:Number, fy:Number, fz:Number) : void
      {
         this.forceAccumulator.x += fx;
         this.forceAccumulator.y += fy;
         this.forceAccumulator.z += fz;
      }
      
      public function addWorldForceXYZ(px:Number, py:Number, pz:Number, fx:Number, fy:Number, fz:Number) : void
      {
         var rx:Number = NaN;
         this.forceAccumulator.x += fx;
         this.forceAccumulator.y += fy;
         this.forceAccumulator.z += fz;
         var position:Vector3 = this.state.position;
         rx = px - position.x;
         var ry:Number = py - position.y;
         var rz:Number = pz - position.z;
         this.torqueAccumulator.x += ry * fz - rz * fy;
         this.torqueAccumulator.y += rz * fx - rx * fz;
         this.torqueAccumulator.z += rx * fy - ry * fx;
      }
      
      public function addWorldForce(point:Vector3, force:Vector3) : void
      {
         this.forceAccumulator.add(force);
         this.torqueAccumulator.add(relativePoint.diff(point,this.state.position).cross(force));
      }
      
      public function addWorldForceScaled(point:Vector3, force:Vector3, scale:Number) : void
      {
         var fx:Number = NaN;
         var fy:Number = NaN;
         fx = scale * force.x;
         fy = scale * force.y;
         var fz:Number = scale * force.z;
         this.forceAccumulator.x += fx;
         this.forceAccumulator.y += fy;
         this.forceAccumulator.z += fz;
         var position:Vector3 = this.state.position;
         var rx:Number = point.x - position.x;
         var ry:Number = point.y - position.y;
         var rz:Number = point.z - position.z;
         this.torqueAccumulator.x += ry * fz - rz * fy;
         this.torqueAccumulator.y += rz * fx - rx * fz;
         this.torqueAccumulator.z += rx * fy - ry * fx;
      }
      
      public function addLocalForce(localPoint:Vector3, localForce:Vector3) : void
      {
         this.orientationMatrix.transformVector(localPoint,relativePoint);
         this.orientationMatrix.transformVector(localForce,worldForce);
         this.forceAccumulator.add(worldForce);
         this.torqueAccumulator.add(relativePoint.cross(worldForce));
      }
      
      public function addWorldForceAtLocalPoint(localPoint:Vector3, force:Vector3) : void
      {
         this.orientationMatrix.transformVector(localPoint,relativePoint);
         this.forceAccumulator.add(force);
         this.torqueAccumulator.add(relativePoint.cross(force));
      }
      
      public function addTorque(torque:Vector3) : void
      {
         this.torqueAccumulator.add(torque);
      }
      
      public function clearAccumulators() : void
      {
         this.forceAccumulator.x = this.forceAccumulator.y = this.forceAccumulator.z = 0;
         this.torqueAccumulator.x = this.torqueAccumulator.y = this.torqueAccumulator.z = 0;
      }
      
      public function calcAccelerations() : void
      {
         this.acceleration.x = this.forceAccumulator.x * this.invMass;
         this.acceleration.y = this.forceAccumulator.y * this.invMass;
         this.acceleration.z = this.forceAccumulator.z * this.invMass;
         this.angularAcceleration.x = this.invInertiaWorld.ma * this.torqueAccumulator.x + this.invInertiaWorld.mb * this.torqueAccumulator.y + this.invInertiaWorld.mc * this.torqueAccumulator.z;
         this.angularAcceleration.y = this.invInertiaWorld.me * this.torqueAccumulator.x + this.invInertiaWorld.mf * this.torqueAccumulator.y + this.invInertiaWorld.mg * this.torqueAccumulator.z;
         this.angularAcceleration.z = this.invInertiaWorld.mi * this.torqueAccumulator.x + this.invInertiaWorld.mj * this.torqueAccumulator.y + this.invInertiaWorld.mk * this.torqueAccumulator.z;
      }
      
      public function calcDerivedData() : void
      {
         var i:int = 0;
         var shape:CollisionShape = null;
         this.state.orientation.toMatrix3(this.orientationMatrix);
         this.invInertiaWorld.copy(this.invInertia).append(this.orientationMatrix).prependTransposed(this.orientationMatrix);
         if(this.collisionShapes != null)
         {
            this.aabb.infinity();
            i = 0;
            while(i < this.numCollisionShapes)
            {
               shape = this.collisionShapes[i];
               shape.transform.setFromMatrix3(this.orientationMatrix,this.state.position);
               if(shape.localTransform != null)
               {
                  shape.transform.prepend(shape.localTransform);
               }
               shape.calculateAABB();
               this.aabb.addBoundBox(shape.aabb);
               i++;
            }
         }
      }
      
      public function saveState() : void
      {
         this.prevState.copy(this.state);
      }
      
      public function restoreState() : void
      {
         this.state.copy(this.prevState);
      }
      
      public function integrateVelocity(dt:Number) : void
      {
         this.prevVelocity.copy(this.state.velocity);
         if(this.acceleration.z < this.minAccelerationZ)
         {
            this.acceleration.z = this.minAccelerationZ;
         }
         this.state.velocity.x += this.acceleration.x * dt;
         this.state.velocity.y += this.acceleration.y * dt;
         this.state.velocity.z += this.acceleration.z * dt;
         var speedZ:Number = Math.abs(this.state.velocity.z);
         if(speedZ > MAX_SPEED_Z)
         {
            this.state.velocity.z *= MAX_SPEED_Z / speedZ;
         }
         this.state.rotation.x += this.angularAcceleration.x * dt;
         this.state.rotation.y += this.angularAcceleration.y * dt;
         this.state.rotation.z += this.angularAcceleration.z * dt;
         this.state.velocity.x *= linearDamping;
         this.state.velocity.y *= linearDamping;
         this.state.velocity.z *= linearDamping;
         this.state.rotation.x *= rotationDamping;
         this.state.rotation.y *= rotationDamping;
         this.state.rotation.z *= rotationDamping;
         if(this.state.rotation.length() > 10)
         {
            this.state.rotation.setLength(10);
         }
         if(this.state.velocity.z - this.prevVelocity.z > this.maxSpeedZGain)
         {
            this.state.velocity.z = this.prevVelocity.z + this.maxSpeedZGain;
         }
      }
      
      public function integratePosition(dt:Number) : void
      {
         this.state.position.x += this.state.velocity.x * dt;
         this.state.position.y += this.state.velocity.y * dt;
         this.state.position.z += this.state.velocity.z * dt;
         this.state.orientation.addScaledVector(this.state.rotation,dt);
      }
      
      public function integratePseudoVelocity(dt:Number) : void
      {
         this.state.position.x += this.pseudoVelocity.x * dt;
         this.state.position.y += this.pseudoVelocity.y * dt;
         this.state.position.z += this.pseudoVelocity.z * dt;
         this.state.orientation.addScaledVector(this.pseudoRotation,dt);
         this.pseudoVelocity.reset();
         this.pseudoRotation.reset();
      }
      
      public function clearCollisionShapes() : void
      {
         var shape:CollisionShape = null;
         for each(shape in this.collisionShapes)
         {
            shape.body = null;
         }
         if(this.collisionShapes != null)
         {
            this.collisionShapes.length = 0;
            this.numCollisionShapes = 0;
         }
      }
   }
}

