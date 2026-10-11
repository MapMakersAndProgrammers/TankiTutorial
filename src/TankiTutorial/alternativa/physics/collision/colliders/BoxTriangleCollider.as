package alternativa.physics.collision.colliders
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.ShapeContact;
   import alternativa.physics.collision.Collider;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.primitives.CollisionTriangle;
   import alternativa.physics.collision.primitives.CollisionBox;
   
   public class BoxTriangleCollider implements Collider
   {
      
      public var epsilon:Number;
      
      private var minOverlap:Number;
      
      private const vectorToBox:Vector3 = new Vector3();
      
      private const axis:Vector3 = new Vector3();
      
      private const axis10:Vector3 = new Vector3();
      
      private const axis11:Vector3 = new Vector3();
      
      private const axis12:Vector3 = new Vector3();
      
      private const axis20:Vector3 = new Vector3();
      
      private const axis21:Vector3 = new Vector3();
      
      private const axis22:Vector3 = new Vector3();
      
      private const bestAxis:Vector3 = new Vector3();
      
      private const contactBasis:Matrix4 = new Matrix4();
      
      private const boxVertices:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex(),new Vertex()]);
      
      private const triangleVertices:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex()]);
      
      public function BoxTriangleCollider(epsilon:Number)
      {
         super();
         this.epsilon = epsilon;
      }
      
      public function getContacts(shape1:CollisionShape, shape2:CollisionShape, contacts:Vector.<ShapeContact>) : void
      {
         var triangle:CollisionTriangle = null;
         var box:CollisionBox = null;
         if(!this.haveCollision(shape1,shape2))
         {
            return;
         }
         if(shape1 is CollisionBox)
         {
            box = CollisionBox(shape1);
            triangle = CollisionTriangle(shape2);
         }
         else
         {
            box = CollisionBox(shape2);
            triangle = CollisionTriangle(shape1);
         }
         this.findContacts(box,triangle,this.bestAxis,contacts);
      }
      
      public function haveCollision(shape1:CollisionShape, shape2:CollisionShape) : Boolean
      {
         var triangle:CollisionTriangle = null;
         var box:CollisionBox = null;
         var boxTransform:Matrix4 = null;
         var triangleTransform:Matrix4 = null;
         var edge:Vector3 = null;
         if(shape1 is CollisionBox)
         {
            box = CollisionBox(shape1);
            triangle = CollisionTriangle(shape2);
         }
         else
         {
            box = CollisionBox(shape2);
            triangle = CollisionTriangle(shape1);
         }
         boxTransform = box.transform;
         triangleTransform = triangle.transform;
         this.vectorToBox.x = boxTransform.md - triangleTransform.md;
         this.vectorToBox.y = boxTransform.mh - triangleTransform.mh;
         this.vectorToBox.z = boxTransform.ml - triangleTransform.ml;
         this.minOverlap = 10000000000;
         this.axis.x = triangleTransform.mc;
         this.axis.y = triangleTransform.mg;
         this.axis.z = triangleTransform.mk;
         if(!this.testOverlapOnMainAxis(box,triangle,this.axis,this.vectorToBox))
         {
            return false;
         }
         this.axis10.x = boxTransform.ma;
         this.axis10.y = boxTransform.me;
         this.axis10.z = boxTransform.mi;
         if(!this.testOverlapOnMainAxis(box,triangle,this.axis10,this.vectorToBox))
         {
            return false;
         }
         this.axis11.x = boxTransform.mb;
         this.axis11.y = boxTransform.mf;
         this.axis11.z = boxTransform.mj;
         if(!this.testOverlapOnMainAxis(box,triangle,this.axis11,this.vectorToBox))
         {
            return false;
         }
         this.axis12.x = boxTransform.mc;
         this.axis12.y = boxTransform.mg;
         this.axis12.z = boxTransform.mk;
         if(!this.testOverlapOnMainAxis(box,triangle,this.axis12,this.vectorToBox))
         {
            return false;
         }
         edge = triangle.e0;
         this.axis20.x = triangleTransform.ma * edge.x + triangleTransform.mb * edge.y + triangleTransform.mc * edge.z;
         this.axis20.y = triangleTransform.me * edge.x + triangleTransform.mf * edge.y + triangleTransform.mg * edge.z;
         this.axis20.z = triangleTransform.mi * edge.x + triangleTransform.mj * edge.y + triangleTransform.mk * edge.z;
         if(!this.testOverlapOnDerivedAxis(box,triangle,this.axis10,this.axis20,this.vectorToBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box,triangle,this.axis11,this.axis20,this.vectorToBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box,triangle,this.axis12,this.axis20,this.vectorToBox))
         {
            return false;
         }
         edge = triangle.e1;
         this.axis21.x = triangleTransform.ma * edge.x + triangleTransform.mb * edge.y + triangleTransform.mc * edge.z;
         this.axis21.y = triangleTransform.me * edge.x + triangleTransform.mf * edge.y + triangleTransform.mg * edge.z;
         this.axis21.z = triangleTransform.mi * edge.x + triangleTransform.mj * edge.y + triangleTransform.mk * edge.z;
         if(!this.testOverlapOnDerivedAxis(box,triangle,this.axis10,this.axis21,this.vectorToBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box,triangle,this.axis11,this.axis21,this.vectorToBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box,triangle,this.axis12,this.axis21,this.vectorToBox))
         {
            return false;
         }
         edge = triangle.e2;
         this.axis22.x = triangleTransform.ma * edge.x + triangleTransform.mb * edge.y + triangleTransform.mc * edge.z;
         this.axis22.y = triangleTransform.me * edge.x + triangleTransform.mf * edge.y + triangleTransform.mg * edge.z;
         this.axis22.z = triangleTransform.mi * edge.x + triangleTransform.mj * edge.y + triangleTransform.mk * edge.z;
         if(!this.testOverlapOnDerivedAxis(box,triangle,this.axis10,this.axis22,this.vectorToBox))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(box,triangle,this.axis11,this.axis22,this.vectorToBox))
         {
            return false;
         }
         return this.testOverlapOnDerivedAxis(box,triangle,this.axis12,this.axis22,this.vectorToBox);
      }
      
      private function testOverlapOnMainAxis(box:CollisionBox, triangle:CollisionTriangle, separatingAxis:Vector3, toBox:Vector3) : Boolean
      {
         var overlap:Number = this.getOverlapOnAxis(box,triangle,separatingAxis,toBox);
         return this.registerOverlap(overlap,separatingAxis);
      }
      
      private function registerOverlap(overlap:Number, separatingAxis:Vector3) : Boolean
      {
         if(overlap < this.epsilon)
         {
            return false;
         }
         if(overlap + this.epsilon < this.minOverlap)
         {
            this.minOverlap = overlap;
            this.bestAxis.x = separatingAxis.x;
            this.bestAxis.y = separatingAxis.y;
            this.bestAxis.z = separatingAxis.z;
         }
         return true;
      }
      
      private function testOverlapOnDerivedAxis(box:CollisionBox, triangle:CollisionTriangle, axis1:Vector3, axis2:Vector3, toBox:Vector3) : Boolean
      {
         var invLen:Number = NaN;
         this.axis.x = axis1.y * axis2.z - axis1.z * axis2.y;
         this.axis.y = axis1.z * axis2.x - axis1.x * axis2.z;
         this.axis.z = axis1.x * axis2.y - axis1.y * axis2.x;
         var lenSqr:Number = this.axis.x * this.axis.x + this.axis.y * this.axis.y + this.axis.z * this.axis.z;
         if(lenSqr < 1e-10)
         {
            return true;
         }
         invLen = 1 / Math.sqrt(lenSqr);
         this.axis.x *= invLen;
         this.axis.y *= invLen;
         this.axis.z *= invLen;
         var overlap:Number = this.getOverlapOnAxis(box,triangle,this.axis,toBox);
         return this.registerOverlap(overlap,this.axis);
      }
      
      private function getOverlapOnAxis(box:CollisionBox, triangle:CollisionTriangle, separatingAxis:Vector3, toBox:Vector3) : Number
      {
         var projection:Number = NaN;
         var boxTransform:Matrix4 = box.transform;
         var hs:Vector3 = box.halfSize;
         var boxProjection:Number = 0;
         projection = (boxTransform.ma * separatingAxis.x + boxTransform.me * separatingAxis.y + boxTransform.mi * separatingAxis.z) * hs.x;
         if(projection < 0)
         {
            boxProjection -= projection;
         }
         else
         {
            boxProjection += projection;
         }
         projection = (boxTransform.mb * separatingAxis.x + boxTransform.mf * separatingAxis.y + boxTransform.mj * separatingAxis.z) * hs.y;
         if(projection < 0)
         {
            boxProjection -= projection;
         }
         else
         {
            boxProjection += projection;
         }
         projection = (boxTransform.mc * separatingAxis.x + boxTransform.mg * separatingAxis.y + boxTransform.mk * separatingAxis.z) * hs.z;
         if(projection < 0)
         {
            boxProjection -= projection;
         }
         else
         {
            boxProjection += projection;
         }
         var distance:Number = toBox.x * separatingAxis.x + toBox.y * separatingAxis.y + toBox.z * separatingAxis.z;
         var triangleTransform:Matrix4 = triangle.transform;
         var ax:Number = triangleTransform.ma * separatingAxis.x + triangleTransform.me * separatingAxis.y + triangleTransform.mi * separatingAxis.z;
         var ay:Number = triangleTransform.mb * separatingAxis.x + triangleTransform.mf * separatingAxis.y + triangleTransform.mj * separatingAxis.z;
         var az:Number = triangleTransform.mc * separatingAxis.x + triangleTransform.mg * separatingAxis.y + triangleTransform.mk * separatingAxis.z;
         var triangleProjection:Number = 0;
         var p0:Vector3 = triangle.v0;
         var p1:Vector3 = triangle.v1;
         var p2:Vector3 = triangle.v2;
         if(distance < 0)
         {
            distance = -distance;
            projection = p0.x * ax + p0.y * ay + p0.z * az;
            if(projection < triangleProjection)
            {
               triangleProjection = projection;
            }
            projection = p1.x * ax + p1.y * ay + p1.z * az;
            if(projection < triangleProjection)
            {
               triangleProjection = projection;
            }
            projection = p2.x * ax + p2.y * ay + p2.z * az;
            if(projection < triangleProjection)
            {
               triangleProjection = projection;
            }
            triangleProjection = -triangleProjection;
         }
         else
         {
            projection = p0.x * ax + p0.y * ay + p0.z * az;
            if(projection > triangleProjection)
            {
               triangleProjection = projection;
            }
            projection = p1.x * ax + p1.y * ay + p1.z * az;
            if(projection > triangleProjection)
            {
               triangleProjection = projection;
            }
            projection = p2.x * ax + p2.y * ay + p2.z * az;
            if(projection > triangleProjection)
            {
               triangleProjection = projection;
            }
         }
         return boxProjection + triangleProjection - distance;
      }
      
      private function findContacts(box:CollisionBox, triangle:CollisionTriangle, collisionNormal:Vector3, contacts:Vector.<ShapeContact>) : void
      {
         var triangleTransform:Matrix4 = null;
         var toBox:Vector3 = null;
         var contact:ShapeContact = null;
         var contactNormal:Vector3 = null;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var nz:Number = NaN;
         var boxTransform:Matrix4 = box.transform;
         triangleTransform = triangle.transform;
         toBox = this.vectorToBox;
         toBox.x = boxTransform.md - triangleTransform.md;
         toBox.y = boxTransform.mh - triangleTransform.mh;
         toBox.z = boxTransform.ml - triangleTransform.ml;
         if(collisionNormal.x * toBox.x + collisionNormal.y * toBox.y + collisionNormal.z * toBox.z < 0)
         {
            collisionNormal.x = -collisionNormal.x;
            collisionNormal.y = -collisionNormal.y;
            collisionNormal.z = -collisionNormal.z;
         }
         var basis:Matrix4 = this.contactBasis;
         ColliderUtils.buildContactBasis(collisionNormal,boxTransform,triangleTransform,basis);
         ColliderUtils.getBoxFaceVerticesInCCWOrder(box,collisionNormal,FaceSide.back,this.boxVertices);
         ColliderUtils.getTriangleFaceInCCWOrder(triangle,collisionNormal,this.triangleVertices);
         ColliderUtils.transformFaceToReferenceSpace(basis,boxTransform,this.boxVertices,4);
         ColliderUtils.transformFaceToReferenceSpace(basis,triangleTransform,this.triangleVertices,3);
         var startIndex:int = int(contacts.length);
         PolygonsIntersectionUtils.findContacts(box,this.boxVertices,4,triangle,this.triangleVertices,3,basis,contacts);
         var numContacts:int = int(contacts.length);
         var i:int = startIndex;
         while(i < numContacts)
         {
            contact = contacts[i];
            contactNormal = contact.normal;
            nx = triangleTransform.mc;
            ny = triangleTransform.mg;
            nz = triangleTransform.mk;
            if(contactNormal.x * nx + contactNormal.y * ny + contactNormal.z * nz < 0)
            {
               contact.dispose();
               numContacts--;
               contacts[i] = contacts[numContacts];
               contacts[numContacts] = null;
               i--;
            }
            i++;
         }
         if(numContacts < contacts.length)
         {
            contacts.length = numContacts;
         }
      }
   }
}

