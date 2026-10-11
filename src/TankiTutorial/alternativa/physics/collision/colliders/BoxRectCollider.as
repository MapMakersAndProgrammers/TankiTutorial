package alternativa.physics.collision.colliders
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.ShapeContact;
   import alternativa.physics.collision.Collider;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.primitives.CollisionRect;
   import alternativa.physics.collision.primitives.CollisionBox;
   
   public class BoxRectCollider implements Collider
   {
      
      private static const boxVertices:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex(),new Vertex()]);
      
      private static const rectVertices:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex(),new Vertex()]);
      
      private static const contactBasis:Matrix4 = new Matrix4();
      
      private const vectorToBox:Vector3 = new Vector3();
      
      private const derivedAxis:Vector3 = new Vector3();
      
      private const axis10:Vector3 = new Vector3();
      
      private const axis11:Vector3 = new Vector3();
      
      private const axis12:Vector3 = new Vector3();
      
      private const axis20:Vector3 = new Vector3();
      
      private const axis21:Vector3 = new Vector3();
      
      private const axis22:Vector3 = new Vector3();
      
      private const bestAxis:Vector3 = new Vector3();
      
      private var minOverlap:Number;
      
      private var epsilon:Number;
      
      public function BoxRectCollider(epsilon:Number)
      {
         super();
         this.epsilon = epsilon;
      }
      
      public function getContacts(shape1:CollisionShape, shape2:CollisionShape, contacts:Vector.<ShapeContact>) : void
      {
         var rect:CollisionRect = null;
         var box:CollisionBox = null;
         if(this.haveCollision(shape1,shape2))
         {
            if(shape1 is CollisionRect)
            {
               rect = CollisionRect(shape1);
               box = CollisionBox(shape2);
            }
            else
            {
               rect = CollisionRect(shape2);
               box = CollisionBox(shape1);
            }
            this.findContacts(box,rect,this.bestAxis,contacts);
         }
      }
      
      public function haveCollision(shape1:CollisionShape, shape2:CollisionShape) : Boolean
      {
         var box:CollisionBox = null;
         var rect:CollisionRect = null;
         this.minOverlap = 10000000000;
         if(shape1 is CollisionBox)
         {
            box = CollisionBox(shape1);
            rect = CollisionRect(shape2);
         }
         else
         {
            box = CollisionBox(shape2);
            rect = CollisionRect(shape1);
         }
         var boxTransform:Matrix4 = box.transform;
         var rectTransform:Matrix4 = rect.transform;
         this.vectorToBox.x = boxTransform.md - rectTransform.md;
         this.vectorToBox.y = boxTransform.mh - rectTransform.mh;
         this.vectorToBox.z = boxTransform.ml - rectTransform.ml;
         this.axis22.x = rectTransform.mc;
         this.axis22.y = rectTransform.mg;
         this.axis22.z = rectTransform.mk;
         if(!this.testMainAxis(box,rect,this.axis22,this.vectorToBox))
         {
            return false;
         }
         this.axis10.x = boxTransform.ma;
         this.axis10.y = boxTransform.me;
         this.axis10.z = boxTransform.mi;
         if(!this.testMainAxis(box,rect,this.axis10,this.vectorToBox))
         {
            return false;
         }
         this.axis11.x = boxTransform.mb;
         this.axis11.y = boxTransform.mf;
         this.axis11.z = boxTransform.mj;
         if(!this.testMainAxis(box,rect,this.axis11,this.vectorToBox))
         {
            return false;
         }
         this.axis12.x = boxTransform.mc;
         this.axis12.y = boxTransform.mg;
         this.axis12.z = boxTransform.mk;
         if(!this.testMainAxis(box,rect,this.axis12,this.vectorToBox))
         {
            return false;
         }
         this.axis20.x = rectTransform.ma;
         this.axis20.y = rectTransform.me;
         this.axis20.z = rectTransform.mi;
         this.axis21.x = rectTransform.mb;
         this.axis21.y = rectTransform.mf;
         this.axis21.z = rectTransform.mj;
         if(!this.testDerivedAxis(box,rect,this.axis10,this.axis20,this.vectorToBox))
         {
            return false;
         }
         if(!this.testDerivedAxis(box,rect,this.axis10,this.axis21,this.vectorToBox))
         {
            return false;
         }
         if(!this.testDerivedAxis(box,rect,this.axis11,this.axis20,this.vectorToBox))
         {
            return false;
         }
         if(!this.testDerivedAxis(box,rect,this.axis11,this.axis21,this.vectorToBox))
         {
            return false;
         }
         if(!this.testDerivedAxis(box,rect,this.axis12,this.axis20,this.vectorToBox))
         {
            return false;
         }
         if(!this.testDerivedAxis(box,rect,this.axis12,this.axis21,this.vectorToBox))
         {
            return false;
         }
         return true;
      }
      
      private function testMainAxis(box:CollisionBox, rect:CollisionRect, axis:Vector3, toBox:Vector3) : Boolean
      {
         var overlap:Number = this.getOverlapOnAxis(box,rect,axis,toBox);
         return this.registerOverlap(overlap,axis);
      }
      
      private function testDerivedAxis(box:CollisionBox, rect:CollisionRect, axis1:Vector3, axis2:Vector3, toBox:Vector3) : Boolean
      {
         var invLen:Number = NaN;
         this.derivedAxis.x = axis1.y * axis2.z - axis1.z * axis2.y;
         this.derivedAxis.y = axis1.z * axis2.x - axis1.x * axis2.z;
         this.derivedAxis.z = axis1.x * axis2.y - axis1.y * axis2.x;
         var lenSqr:Number = this.derivedAxis.x * this.derivedAxis.x + this.derivedAxis.y * this.derivedAxis.y + this.derivedAxis.z * this.derivedAxis.z;
         if(lenSqr < 1e-10)
         {
            return true;
         }
         invLen = 1 / Math.sqrt(lenSqr);
         this.derivedAxis.x *= invLen;
         this.derivedAxis.y *= invLen;
         this.derivedAxis.z *= invLen;
         var overlap:Number = this.getOverlapOnAxis(box,rect,this.derivedAxis,toBox);
         return this.registerOverlap(overlap,this.derivedAxis);
      }
      
      private function getOverlapOnAxis(box:CollisionBox, rect:CollisionRect, axis:Vector3, toBox:Vector3) : Number
      {
         var matrix:Matrix4 = box.transform;
         var projection:Number = (matrix.ma * axis.x + matrix.me * axis.y + matrix.mi * axis.z) * box.halfSize.x;
         if(projection < 0)
         {
            projection = -projection;
         }
         var sum:Number = projection;
         projection = (matrix.mb * axis.x + matrix.mf * axis.y + matrix.mj * axis.z) * box.halfSize.y;
         if(projection < 0)
         {
            projection = -projection;
         }
         sum += projection;
         projection = (matrix.mc * axis.x + matrix.mg * axis.y + matrix.mk * axis.z) * box.halfSize.z;
         if(projection < 0)
         {
            projection = -projection;
         }
         sum += projection;
         matrix = rect.transform;
         projection = (matrix.ma * axis.x + matrix.me * axis.y + matrix.mi * axis.z) * rect.halfSize.x;
         if(projection < 0)
         {
            projection = -projection;
         }
         sum += projection;
         projection = (matrix.mb * axis.x + matrix.mf * axis.y + matrix.mj * axis.z) * rect.halfSize.y;
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
      
      private function findContacts(box:CollisionBox, rect:CollisionRect, collisionNormal:Vector3, contacts:Vector.<ShapeContact>) : void
      {
         var boxTransform:Matrix4 = null;
         var contact:ShapeContact = null;
         var contactNormal:Vector3 = null;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var nz:Number = NaN;
         boxTransform = box.transform;
         var rectTransform:Matrix4 = rect.transform;
         var toBox:Vector3 = this.vectorToBox;
         toBox.x = boxTransform.md - rectTransform.md;
         toBox.y = boxTransform.mh - rectTransform.mh;
         toBox.z = boxTransform.ml - rectTransform.ml;
         if(collisionNormal.x * toBox.x + collisionNormal.y * toBox.y + collisionNormal.z * toBox.z < 0)
         {
            collisionNormal.x = -collisionNormal.x;
            collisionNormal.y = -collisionNormal.y;
            collisionNormal.z = -collisionNormal.z;
         }
         var basis:Matrix4 = contactBasis;
         ColliderUtils.buildContactBasis(collisionNormal,boxTransform,rectTransform,basis);
         ColliderUtils.getBoxFaceVerticesInCCWOrder(box,collisionNormal,FaceSide.back,boxVertices);
         ColliderUtils.getRectFaceInCCWOrder(rect,collisionNormal,rectVertices);
         ColliderUtils.transformFaceToReferenceSpace(basis,boxTransform,boxVertices,4);
         ColliderUtils.transformFaceToReferenceSpace(basis,rectTransform,rectVertices,4);
         var startIndex:int = int(contacts.length);
         PolygonsIntersectionUtils.findContacts(box,boxVertices,4,rect,rectVertices,4,basis,contacts);
         var numContacts:int = int(contacts.length);
         var i:int = startIndex;
         while(i < numContacts)
         {
            contact = contacts[i];
            contactNormal = contact.normal;
            nx = rectTransform.mc;
            ny = rectTransform.mg;
            nz = rectTransform.mk;
            if(contactNormal.x * nx + contactNormal.y * ny + contactNormal.z * nz < 0)
            {
               contact.dispose();
               numContacts--;
               contacts[i] = contacts[numContacts];
               contacts[numContacts] = null;
               i--;
            }
            else if(Math.abs(rectTransform.mk) > 0.999)
            {
               contactNormal.x = nx;
               contactNormal.y = ny;
               contactNormal.z = nz;
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

