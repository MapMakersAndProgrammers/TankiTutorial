package alternativa.physics.collision.colliders
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.ShapeContact;
   import alternativa.physics.collision.Collider;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.primitives.CollisionBox;
   
   public class BoxBoxCollider implements Collider
   {
      
      private static const derivedAxis:Vector3 = new Vector3();
      
      private static const axis10:Vector3 = new Vector3();
      
      private static const axis11:Vector3 = new Vector3();
      
      private static const axis12:Vector3 = new Vector3();
      
      private static const axis20:Vector3 = new Vector3();
      
      private static const axis21:Vector3 = new Vector3();
      
      private static const axis22:Vector3 = new Vector3();
      
      private static const vectorToBox:Vector3 = new Vector3();
      
      private static const box1Vertices:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex(),new Vertex()]);
      
      private static const box2Vertices:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex(),new Vertex()]);
      
      private static const contactBasis:Matrix4 = new Matrix4();
      
      private var epsilon:Number;
      
      private const bestAxis:Vector3 = new Vector3();
      
      private var minOverlap:Number;
      
      public function BoxBoxCollider(epsilon:Number)
      {
         super();
         this.epsilon = epsilon;
      }
      
      public function getContacts(shape1:CollisionShape, shape2:CollisionShape, contacts:Vector.<ShapeContact>) : void
      {
         var box1:CollisionBox = null;
         var box2:CollisionBox = null;
         if(this.haveCollision(shape1,shape2))
         {
            box1 = CollisionBox(shape1);
            box2 = CollisionBox(shape2);
            this.findContacts(box1,box2,this.bestAxis,contacts);
         }
      }
      
      public function haveCollision(shape1:CollisionShape, shape2:CollisionShape) : Boolean
      {
         var box1:CollisionBox = null;
         var transform1:Matrix4 = null;
         var toBox:Vector3 = null;
         this.minOverlap = 10000000000;
         box1 = CollisionBox(shape1);
         var box2:CollisionBox = CollisionBox(shape2);
         transform1 = box1.transform;
         var transform2:Matrix4 = box2.transform;
         toBox = vectorToBox;
         toBox.x = transform1.md - transform2.md;
         toBox.y = transform1.mh - transform2.mh;
         toBox.z = transform1.ml - transform2.ml;
         axis10.x = transform1.ma;
         axis10.y = transform1.me;
         axis10.z = transform1.mi;
         if(!this.testOverlapOnMainAxis(box1,box2,axis10,toBox))
         {
            return false;
         }
         axis11.x = transform1.mb;
         axis11.y = transform1.mf;
         axis11.z = transform1.mj;
         if(!this.testOverlapOnMainAxis(box1,box2,axis11,toBox))
         {
            return false;
         }
         axis12.x = transform1.mc;
         axis12.y = transform1.mg;
         axis12.z = transform1.mk;
         if(!this.testOverlapOnMainAxis(box1,box2,axis12,toBox))
         {
            return false;
         }
         axis20.x = transform2.ma;
         axis20.y = transform2.me;
         axis20.z = transform2.mi;
         if(!this.testOverlapOnMainAxis(box1,box2,axis20,toBox))
         {
            return false;
         }
         axis21.x = transform2.mb;
         axis21.y = transform2.mf;
         axis21.z = transform2.mj;
         if(!this.testOverlapOnMainAxis(box1,box2,axis21,toBox))
         {
            return false;
         }
         axis22.x = transform2.mc;
         axis22.y = transform2.mg;
         axis22.z = transform2.mk;
         if(!this.testOverlapOnMainAxis(box1,box2,axis22,toBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box1,box2,axis10,axis20,toBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box1,box2,axis10,axis21,toBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box1,box2,axis10,axis22,toBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box1,box2,axis11,axis20,toBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box1,box2,axis11,axis21,toBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box1,box2,axis11,axis22,toBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box1,box2,axis12,axis20,toBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box1,box2,axis12,axis21,toBox))
         {
            return false;
         }
         return this.testOverlapOnDerivedAxis(box1,box2,axis12,axis22,toBox);
      }
      
      private function testOverlapOnMainAxis(box1:CollisionBox, box2:CollisionBox, axis:Vector3, toBox:Vector3) : Boolean
      {
         var overlap:Number = this.getOverlapOnAxis(box1,box2,axis,toBox);
         return this.registerOverlap(overlap,axis);
      }
      
      private function testOverlapOnDerivedAxis(box1:CollisionBox, box2:CollisionBox, axis1:Vector3, axis2:Vector3, toBox:Vector3) : Boolean
      {
         var axis:Vector3 = null;
         var invLen:Number = NaN;
         axis = derivedAxis;
         axis.x = axis1.y * axis2.z - axis1.z * axis2.y;
         axis.y = axis1.z * axis2.x - axis1.x * axis2.z;
         axis.z = axis1.x * axis2.y - axis1.y * axis2.x;
         var lenSqr:Number = axis.x * axis.x + axis.y * axis.y + axis.z * axis.z;
         if(lenSqr < 1e-10)
         {
            return true;
         }
         invLen = 1 / Math.sqrt(lenSqr);
         axis.x *= invLen;
         axis.y *= invLen;
         axis.z *= invLen;
         var overlap:Number = this.getOverlapOnAxis(box1,box2,axis,toBox);
         return this.registerOverlap(overlap,axis);
      }
      
      private function registerOverlap(overlap:Number, axis:Vector3) : Boolean
      {
         if(overlap < this.epsilon)
         {
            return false;
         }
         if(overlap + this.epsilon < this.minOverlap)
         {
            this.minOverlap = overlap;
            this.bestAxis.x = axis.x;
            this.bestAxis.y = axis.y;
            this.bestAxis.z = axis.z;
         }
         return true;
      }
      
      public function getOverlapOnAxis(box1:CollisionBox, box2:CollisionBox, axis:Vector3, toBox:Vector3) : Number
      {
         var matrix:Matrix4 = box1.transform;
         var projection:Number = (matrix.ma * axis.x + matrix.me * axis.y + matrix.mi * axis.z) * box1.halfSize.x;
         if(projection < 0)
         {
            projection = -projection;
         }
         var sum:Number = projection;
         projection = (matrix.mb * axis.x + matrix.mf * axis.y + matrix.mj * axis.z) * box1.halfSize.y;
         if(projection < 0)
         {
            projection = -projection;
         }
         sum += projection;
         projection = (matrix.mc * axis.x + matrix.mg * axis.y + matrix.mk * axis.z) * box1.halfSize.z;
         if(projection < 0)
         {
            projection = -projection;
         }
         sum += projection;
         matrix = box2.transform;
         projection = (matrix.ma * axis.x + matrix.me * axis.y + matrix.mi * axis.z) * box2.halfSize.x;
         if(projection < 0)
         {
            projection = -projection;
         }
         sum += projection;
         projection = (matrix.mb * axis.x + matrix.mf * axis.y + matrix.mj * axis.z) * box2.halfSize.y;
         if(projection < 0)
         {
            projection = -projection;
         }
         sum += projection;
         projection = (matrix.mc * axis.x + matrix.mg * axis.y + matrix.mk * axis.z) * box2.halfSize.z;
         if(projection < 0)
         {
            projection = -projection;
         }
         sum += projection;
         projection = toBox.x * axis.x + toBox.y * axis.y + toBox.z * axis.z;
         if(projection < 0)
         {
            projection = -projection;
         }
         return sum - projection;
      }
      
      private function findContacts(box1:CollisionBox, box2:CollisionBox, collisionNormal:Vector3, contacts:Vector.<ShapeContact>) : void
      {
         var transform1:Matrix4 = box1.transform;
         var transform2:Matrix4 = box2.transform;
         var toBox:Vector3 = vectorToBox;
         toBox.x = transform1.md - transform2.md;
         toBox.y = transform1.mh - transform2.mh;
         toBox.z = transform1.ml - transform2.ml;
         if(collisionNormal.x * toBox.x + collisionNormal.y * toBox.y + collisionNormal.z * toBox.z < 0)
         {
            collisionNormal.x = -collisionNormal.x;
            collisionNormal.y = -collisionNormal.y;
            collisionNormal.z = -collisionNormal.z;
         }
         var basis:Matrix4 = contactBasis;
         ColliderUtils.buildContactBasis(collisionNormal,transform1,transform2,basis);
         ColliderUtils.getBoxFaceVerticesInCCWOrder(box1,collisionNormal,FaceSide.back,box1Vertices);
         ColliderUtils.getBoxFaceVerticesInCCWOrder(box2,collisionNormal,FaceSide.front,box2Vertices);
         ColliderUtils.transformFaceToReferenceSpace(basis,box1.transform,box1Vertices,4);
         ColliderUtils.transformFaceToReferenceSpace(basis,box2.transform,box2Vertices,4);
         PolygonsIntersectionUtils.findContacts(box1,box1Vertices,4,box2,box2Vertices,4,basis,contacts);
      }
   }
}

