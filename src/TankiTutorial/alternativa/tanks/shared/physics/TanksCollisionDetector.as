package alternativa.tanks.shared.physics
{
   import alternativa.physics.Body;
   import alternativa.physics.ShapeContact;
   import alternativa.physics.BodyContact;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   import alternativa.physics.collision.types.AABB;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.physics.collision.colliders.BoxBoxCollider;
   import alternativa.physics.collision.colliders.BoxRectCollider;
   import alternativa.physics.collision.colliders.BoxTriangleCollider;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.Collider;
   import alternativa.physics.collision.CollisionKdNode;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.CollisionKdTree;
   import alternativa.physics.collision.IRayCollisionFilter;
   
   public class TanksCollisionDetector implements CollisionDetector
   {
      
      private static const EPSILON:Number = 0.01;
      
      private const colliders:Object = {};
      
      private const rayHit:RayHit = new RayHit();
      
      private const minMax:MinMax = new MinMax();
      
      private const normal:Vector3 = new Vector3();
      
      private const point:Vector3 = new Vector3();
      
      private const dynamicRayHit:RayHit = new RayHit();
      
      private const rayAABB:AABB = new AABB();
      
      private const shapeContacts:Vector.<ShapeContact> = new Vector.<ShapeContact>();
      
      private var kdTree:CollisionKdTree = new CollisionKdTree();
      
      private var threshold:Number = 0.0001;
      
      private var tankBodies:Vector.<TankBody> = new Vector.<TankBody>();
      
      private var kinematicBodies:Vector.<Body> = new Vector.<Body>();
      
      private var staticBody:Body;
      
      public function TanksCollisionDetector()
      {
         super();
         var epsilon:Number = 0.000001;
         this.setCollider(CollisionShape.BOX,CollisionShape.BOX,new BoxBoxCollider(epsilon));
         this.setCollider(CollisionShape.BOX,CollisionShape.RECT,new BoxRectCollider(epsilon));
         this.setCollider(CollisionShape.BOX,CollisionShape.TRIANGLE,new BoxTriangleCollider(epsilon));
         this.createStaticBody();
      }
      
      private function setCollider(type1:int, type2:int, collider:Collider) : void
      {
         this.colliders[type1 | type2] = collider;
      }
      
      private function createStaticBody() : void
      {
         this.staticBody = new Body(1,new Matrix3());
         this.staticBody.movable = false;
      }
      
      public function buildKdTree(shapes:Vector.<CollisionShape>, bounds:AABB = null) : void
      {
         var shape:CollisionShape = null;
         for each(shape in shapes)
         {
            shape.body = this.staticBody;
         }
         this.kdTree.createTree(shapes,bounds);
      }
      
      public function addTankBody(tankBody:TankBody) : void
      {
         this.tankBodies.push(tankBody);
      }
      
      public function removeTankBody(tankBody:TankBody) : void
      {
         var lastIndex:int = 0;
         var index:int = this.tankBodies.indexOf(tankBody);
         if(index > -1)
         {
            lastIndex = this.tankBodies.length - 1;
            this.tankBodies[index] = this.tankBodies[lastIndex];
            this.tankBodies.length = lastIndex;
         }
      }
      
      public function addKineamticBody(body:Body) : void
      {
         if(this.kinematicBodies.indexOf(body) < 0)
         {
            this.kinematicBodies.push(body);
         }
      }
      
      public function removeKinematicBody(body:Body) : void
      {
         var index:int = this.kinematicBodies.indexOf(body);
         if(index > -1)
         {
            this.kinematicBodies.splice(index,1);
         }
      }
      
      public function getBodyContacts(contacts:Vector.<BodyContact>) : void
      {
         var tankBody:TankBody = null;
         var numContacts:int = 0;
         var len:int = int(this.tankBodies.length);
         var i:int = 0;
         while(i < len)
         {
            tankBody = this.tankBodies[i];
            tankBody.vahuzys = false;
            tankBody.put = false;
            numContacts = int(contacts.length);
            this.getContactsWithStatic(tankBody,contacts);
            if(numContacts != contacts.length)
            {
               tankBody.vahuzys = true;
            }
            numContacts = int(contacts.length);
            this.getContactsWithOtherBodies(tankBody,i + 1,contacts);
            if(numContacts != contacts.length)
            {
               tankBody.put = true;
            }
            this.getContactsWithKinematicBodies(tankBody,contacts);
            i++;
         }
      }
      
      private function getContactsWithStatic(tankBody:TankBody, contacts:Vector.<BodyContact>) : void
      {
         var len:int = 0;
         var i:int = 0;
         var bodyContact:BodyContact = null;
         if(!tankBody.body.frozen)
         {
            len = int(tankBody.staticCollisionBoxes.length);
            i = 0;
            while(i < len)
            {
               this.getShapeNodeCollisions(this.kdTree.rootNode,tankBody.staticCollisionBoxes[i],this.shapeContacts);
               i++;
            }
            if(this.shapeContacts.length > 0)
            {
               bodyContact = BodyContact.create();
               bodyContact.body1 = tankBody.body;
               bodyContact.body2 = this.staticBody;
               bodyContact.setShapeContacts(this.shapeContacts);
               this.shapeContacts.length = 0;
               contacts[contacts.length] = bodyContact;
            }
         }
      }
      
      private function getContactsWithOtherBodies(tankBody:TankBody, startIndex:int, contacts:Vector.<BodyContact>) : void
      {
         var otherTankBody:TankBody = null;
         var body1:Body = null;
         var body2:Body = null;
         var numShapeContacts:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var bodyContact:BodyContact = null;
         var j:int = 0;
         var shapeContact:ShapeContact = null;
         var len:int = int(this.tankBodies.length);
         var i:int = startIndex;
         while(i < len)
         {
            otherTankBody = this.tankBodies[i];
            body1 = tankBody.body;
            body2 = otherTankBody.body;
            if(!(Boolean(body1.frozen) && Boolean(body2.frozen)) && Boolean(body1.aabb.intersects(body2.aabb,EPSILON)))
            {
               this.getContacts(tankBody.tankCollisionBox,otherTankBody.tankCollisionBox,this.shapeContacts);
               numShapeContacts = int(this.shapeContacts.length);
               if(numShapeContacts > 0)
               {
                  _loc10_ = body1.collisionFilter == null || Boolean(body1.collisionFilter.considerBodies(body1,body2));
                  _loc11_ = body2.collisionFilter == null || Boolean(body2.collisionFilter.considerBodies(body2,body1));
                  if(_loc10_ && _loc11_)
                  {
                     bodyContact = BodyContact.create();
                     bodyContact.body1 = body1;
                     bodyContact.body2 = body2;
                     bodyContact.setShapeContacts(this.shapeContacts);
                     contacts[contacts.length] = bodyContact;
                  }
                  else
                  {
                     j = 0;
                     while(j < numShapeContacts)
                     {
                        shapeContact = this.shapeContacts[j];
                        shapeContact.dispose();
                        j++;
                     }
                  }
                  this.shapeContacts.length = 0;
               }
            }
            i++;
         }
      }
      
      private function getContactsWithKinematicBodies(tankBody:TankBody, contacts:Vector.<BodyContact>) : void
      {
         var body:Body = null;
         var len:int = int(this.kinematicBodies.length);
         var i:int = 0;
         while(i < len)
         {
            body = this.kinematicBodies[i];
            this.getBodyBodyContact(tankBody.body,body,contacts);
            i++;
         }
      }
      
      private function getBodyBodyContact(body1:Body, body2:Body, contacts:Vector.<BodyContact>) : void
      {
         var numShapes1:int = 0;
         var shapes1:Vector.<CollisionShape> = null;
         var numShapes2:int = 0;
         var shapes2:Vector.<CollisionShape> = null;
         var i:int = 0;
         var shape1:CollisionShape = null;
         var j:int = 0;
         var bodyContact:BodyContact = null;
         if(body1.aabb.intersects(body2.aabb,EPSILON))
         {
            numShapes1 = int(body1.numCollisionShapes);
            shapes1 = body1.collisionShapes;
            numShapes2 = int(body2.numCollisionShapes);
            shapes2 = body2.collisionShapes;
            i = 0;
            while(i < numShapes1)
            {
               shape1 = shapes1[i];
               j = 0;
               while(j < numShapes2)
               {
                  this.getContacts(shape1,shapes2[j],this.shapeContacts);
                  j++;
               }
               i++;
            }
            if(this.shapeContacts.length > 0)
            {
               bodyContact = BodyContact.create();
               bodyContact.body1 = body1;
               bodyContact.body2 = body2;
               bodyContact.setShapeContacts(this.shapeContacts);
               contacts[contacts.length] = bodyContact;
               this.shapeContacts.length = 0;
            }
         }
      }
      
      public function getContacts(shape1:CollisionShape, shape2:CollisionShape, contacts:Vector.<ShapeContact>) : void
      {
         if((shape1.collisionGroup & shape2.collisionGroup) == 0)
         {
            return;
         }
         if(shape1.body == shape2.body)
         {
            return;
         }
         if(!shape1.aabb.intersects(shape2.aabb,EPSILON))
         {
            return;
         }
         var collider:Collider = this.colliders[shape1.type | shape2.type];
         collider.getContacts(shape1,shape2,contacts);
      }
      
      public function testCollision(shape1:CollisionShape, shape2:CollisionShape) : Boolean
      {
         if((shape1.collisionGroup & shape2.collisionGroup) == 0)
         {
            return false;
         }
         if(shape1.body == shape2.body)
         {
            return false;
         }
         if(!shape1.aabb.intersects(shape2.aabb,EPSILON))
         {
            return false;
         }
         var collider:Collider = this.colliders[shape1.type | shape2.type];
         return collider.haveCollision(shape1,shape2);
      }
      
      public function raycast(origin:Vector3, direction:Vector3, collisionGroup:int, maxTime:Number, filter:IRayCollisionFilter, result:RayHit) : Boolean
      {
         var staticHit:Boolean = this.raycastStatic(origin,direction,collisionGroup,maxTime,filter,result);
         var dynamicHit:Boolean = this.raycastDynamic(origin,direction,collisionGroup,maxTime,filter,this.dynamicRayHit);
         if(!(dynamicHit || staticHit))
         {
            return false;
         }
         if(dynamicHit && staticHit)
         {
            if(result.time > this.dynamicRayHit.time)
            {
               result.copy(this.dynamicRayHit);
            }
            this.dynamicRayHit.clear();
            return true;
         }
         if(staticHit)
         {
            this.dynamicRayHit.clear();
            return true;
         }
         result.copy(this.dynamicRayHit);
         this.dynamicRayHit.clear();
         return true;
      }
      
      public function raycastStatic(origin:Vector3, direction:Vector3, collisionGroup:int, maxTime:Number, filter:IRayCollisionFilter, result:RayHit) : Boolean
      {
         if(!this.getRayBoundBoxIntersection(origin,direction,this.kdTree.rootNode.boundBox,this.minMax))
         {
            return false;
         }
         if(this.minMax.max < 0 || this.minMax.min > maxTime)
         {
            return false;
         }
         if(this.minMax.min <= 0)
         {
            this.minMax.min = 0;
            this.point.x = origin.x;
            this.point.y = origin.y;
            this.point.z = origin.z;
         }
         else
         {
            this.point.x = origin.x + this.minMax.min * direction.x;
            this.point.y = origin.y + this.minMax.min * direction.y;
            this.point.z = origin.z + this.minMax.min * direction.z;
         }
         if(this.minMax.max > maxTime)
         {
            this.minMax.max = maxTime;
         }
         var hit:Boolean = this.testRayAgainstNode(this.kdTree.rootNode,origin,this.point,direction,collisionGroup,this.minMax.min,this.minMax.max,filter,result);
         return hit ? result.time <= maxTime : false;
      }
      
      public function hasStaticHit(origin:Vector3, direction:Vector3, collisionGroup:int, maxTime:Number, filter:IRayCollisionFilter = null) : Boolean
      {
         var hit:Boolean = this.raycastStatic(origin,direction,collisionGroup,maxTime,filter,this.rayHit);
         this.rayHit.clear();
         return hit;
      }
      
      private function getShapeNodeCollisions(node:CollisionKdNode, shape:CollisionShape, contacts:Vector.<ShapeContact>) : void
      {
         var min:Number = NaN;
         var max:Number = NaN;
         var primitives:Vector.<CollisionShape> = null;
         var indices:Vector.<int> = null;
         var len:int = 0;
         var i:int = 0;
         if(node.indices != null)
         {
            primitives = this.kdTree.primitives;
            indices = node.indices;
            len = int(indices.length);
            i = 0;
            while(i < len)
            {
               this.getContacts(shape,primitives[indices[i]],contacts);
               i++;
            }
         }
         if(node.axis == -1)
         {
            return;
         }
         switch(node.axis)
         {
            case 0:
               min = Number(shape.aabb.minX);
               max = Number(shape.aabb.maxX);
               break;
            case 1:
               min = Number(shape.aabb.minY);
               max = Number(shape.aabb.maxY);
               break;
            case 2:
               min = Number(shape.aabb.minZ);
               max = Number(shape.aabb.maxZ);
         }
         if(min < node.coord)
         {
            this.getShapeNodeCollisions(node.negative,shape,contacts);
         }
         if(max > node.coord)
         {
            this.getShapeNodeCollisions(node.positive,shape,contacts);
         }
         if(node.splitTree != null && min < node.coord && max > node.coord)
         {
            this.getShapeNodeCollisions(node.splitTree.rootNode,shape,contacts);
         }
      }
      
      private function testShapeNodeCollision(shape:CollisionShape, node:CollisionKdNode) : Boolean
      {
         var min:Number = NaN;
         var max:Number = NaN;
         var primitives:Vector.<CollisionShape> = null;
         var indices:Vector.<int> = null;
         var len:int = 0;
         var i:int = 0;
         if(node.indices != null)
         {
            primitives = this.kdTree.primitives;
            indices = node.indices;
            len = int(indices.length);
            i = 0;
            while(i < len)
            {
               if(this.testCollision(shape,primitives[indices[i]]))
               {
                  return true;
               }
               i++;
            }
         }
         if(node.axis == -1)
         {
            return false;
         }
         switch(node.axis)
         {
            case 0:
               min = Number(shape.aabb.minX);
               max = Number(shape.aabb.maxX);
               break;
            case 1:
               min = Number(shape.aabb.minY);
               max = Number(shape.aabb.maxY);
               break;
            case 2:
               min = Number(shape.aabb.minZ);
               max = Number(shape.aabb.maxZ);
         }
         if(node.splitTree != null && min < node.coord && max > node.coord)
         {
            if(this.testShapeNodeCollision(shape,node.splitTree.rootNode))
            {
               return true;
            }
         }
         if(min < node.coord)
         {
            if(this.testShapeNodeCollision(shape,node.negative))
            {
               return true;
            }
         }
         if(max > node.coord)
         {
            if(this.testShapeNodeCollision(shape,node.positive))
            {
               return true;
            }
         }
         return false;
      }
      
      private function raycastDynamic(origin:Vector3, direction:Vector3, collisionGroup:int, maxTime:Number, filter:IRayCollisionFilter, result:RayHit) : Boolean
      {
         var tankBody:TankBody = null;
         var body:Body = null;
         var aabb:AABB = null;
         var j:int = 0;
         var shape:CollisionShape = null;
         var t:Number = NaN;
         var endX:Number = origin.x + direction.x * maxTime;
         var endY:Number = origin.y + direction.y * maxTime;
         var endZ:Number = origin.z + direction.z * maxTime;
         if(endX < origin.x)
         {
            this.rayAABB.minX = endX;
            this.rayAABB.maxX = origin.x;
         }
         else
         {
            this.rayAABB.minX = origin.x;
            this.rayAABB.maxX = endX;
         }
         if(endY < origin.y)
         {
            this.rayAABB.minY = endY;
            this.rayAABB.maxY = origin.y;
         }
         else
         {
            this.rayAABB.minY = origin.y;
            this.rayAABB.maxY = endY;
         }
         if(endZ < origin.z)
         {
            this.rayAABB.minZ = endZ;
            this.rayAABB.maxZ = origin.z;
         }
         else
         {
            this.rayAABB.minZ = origin.z;
            this.rayAABB.maxZ = endZ;
         }
         var minTime:Number = maxTime + 1;
         var len:int = int(this.tankBodies.length);
         var i:int = 0;
         while(i < len)
         {
            tankBody = this.tankBodies[i];
            body = tankBody.body;
            aabb = body.aabb;
            if(!(this.rayAABB.maxX < aabb.minX || this.rayAABB.minX > aabb.maxX || this.rayAABB.maxY < aabb.minY || this.rayAABB.minY > aabb.maxY || this.rayAABB.maxZ < aabb.minZ || this.rayAABB.minZ > aabb.maxZ))
            {
               j = 0;
               while(j < body.numCollisionShapes)
               {
                  shape = body.collisionShapes[j];
                  if((shape.collisionGroup & collisionGroup) != 0)
                  {
                     aabb = shape.aabb;
                     if(!(this.rayAABB.maxX < aabb.minX || this.rayAABB.minX > aabb.maxX || this.rayAABB.maxY < aabb.minY || this.rayAABB.minY > aabb.maxY || this.rayAABB.maxZ < aabb.minZ || this.rayAABB.minZ > aabb.maxZ))
                     {
                        if(!(filter != null && !filter.considerBody(body)))
                        {
                           t = Number(shape.raycast(origin,direction,this.threshold,this.normal));
                           if(t >= 0 && t < minTime)
                           {
                              minTime = t;
                              result.shape = shape;
                              result.normal.x = this.normal.x;
                              result.normal.y = this.normal.y;
                              result.normal.z = this.normal.z;
                           }
                        }
                     }
                  }
                  j++;
               }
            }
            i++;
         }
         if(minTime > maxTime)
         {
            return false;
         }
         result.position.x = origin.x + direction.x * minTime;
         result.position.y = origin.y + direction.y * minTime;
         result.position.z = origin.z + direction.z * minTime;
         result.time = minTime;
         return true;
      }
      
      private function getRayBoundBoxIntersection(origin:Vector3, direction:Vector3, boundBox:AABB, result:MinMax) : Boolean
      {
         var t1:Number = NaN;
         var t2:Number = NaN;
         result.min = -1;
         result.max = 1e+308;
         var i:int = 0;
         for(; i < 3; i++)
         {
            switch(i)
            {
               case 0:
                  if(!(direction.x < this.threshold && direction.x > -this.threshold))
                  {
                     t1 = (boundBox.minX - origin.x) / direction.x;
                     t2 = (boundBox.maxX - origin.x) / direction.x;
                     break;
                  }
                  if(origin.x < boundBox.minX || origin.x > boundBox.maxX)
                  {
                     return false;
                  }
                  continue;
               case 1:
                  if(!(direction.y < this.threshold && direction.y > -this.threshold))
                  {
                     t1 = (boundBox.minY - origin.y) / direction.y;
                     t2 = (boundBox.maxY - origin.y) / direction.y;
                     break;
                  }
                  if(origin.y < boundBox.minY || origin.y > boundBox.maxY)
                  {
                     return false;
                  }
                  continue;
               case 2:
                  if(!(direction.z < this.threshold && direction.z > -this.threshold))
                  {
                     t1 = (boundBox.minZ - origin.z) / direction.z;
                     t2 = (boundBox.maxZ - origin.z) / direction.z;
                     break;
                  }
                  if(origin.z < boundBox.minZ || origin.z > boundBox.maxZ)
                  {
                     return false;
                  }
                  continue;
            }
            if(t1 < t2)
            {
               if(t1 > result.min)
               {
                  result.min = t1;
               }
               if(t2 < result.max)
               {
                  result.max = t2;
               }
            }
            else
            {
               if(t2 > result.min)
               {
                  result.min = t2;
               }
               if(t1 < result.max)
               {
                  result.max = t1;
               }
            }
            if(result.max < result.min)
            {
               return false;
            }
         }
         return true;
      }
      
      private function testRayAgainstNode(node:CollisionKdNode, origin:Vector3, entryPoint:Vector3, direction:Vector3, collisionGroup:int, minTime:Number, maxTime:Number, filter:IRayCollisionFilter, result:RayHit) : Boolean
      {
         var splitTime:Number = NaN;
         var nearNode:CollisionKdNode = null;
         var hit:Boolean = false;
         var splitTreeNode:CollisionKdNode = null;
         var len:int = 0;
         var i:int = 0;
         var shape:CollisionShape = null;
         if(node.indices != null && this.getRayNodeIntersection(origin,direction,collisionGroup,this.kdTree.primitives,node.indices,filter,result))
         {
            return true;
         }
         if(node.axis == -1)
         {
            return false;
         }
         switch(node.axis)
         {
            case 0:
               if(direction.x > -this.threshold && direction.x < this.threshold)
               {
                  splitTime = maxTime + 1;
               }
               else
               {
                  splitTime = (node.coord - origin.x) / direction.x;
               }
               nearNode = entryPoint.x < node.coord ? node.negative : node.positive;
               break;
            case 1:
               if(direction.y > -this.threshold && direction.y < this.threshold)
               {
                  splitTime = maxTime + 1;
               }
               else
               {
                  splitTime = (node.coord - origin.y) / direction.y;
               }
               nearNode = entryPoint.y < node.coord ? node.negative : node.positive;
               break;
            case 2:
               if(direction.z > -this.threshold && direction.z < this.threshold)
               {
                  splitTime = maxTime + 1;
               }
               else
               {
                  splitTime = (node.coord - origin.z) / direction.z;
               }
               nearNode = entryPoint.z < node.coord ? node.negative : node.positive;
         }
         if(splitTime < minTime || splitTime > maxTime)
         {
            return this.testRayAgainstNode(nearNode,origin,entryPoint,direction,collisionGroup,minTime,maxTime,filter,result);
         }
         hit = this.testRayAgainstNode(nearNode,origin,entryPoint,direction,collisionGroup,minTime,splitTime,filter,result);
         if(hit)
         {
            return true;
         }
         this.point.x = origin.x + splitTime * direction.x;
         this.point.y = origin.y + splitTime * direction.y;
         this.point.z = origin.z + splitTime * direction.z;
         if(node.splitTree != null)
         {
            splitTreeNode = node.splitTree.rootNode;
            while(splitTreeNode != null && splitTreeNode.axis != -1)
            {
               switch(splitTreeNode.axis)
               {
                  case 0:
                     splitTreeNode = this.point.x < splitTreeNode.coord ? splitTreeNode.negative : splitTreeNode.positive;
                     break;
                  case 1:
                     splitTreeNode = this.point.y < splitTreeNode.coord ? splitTreeNode.negative : splitTreeNode.positive;
                     break;
                  case 2:
                     splitTreeNode = this.point.z < splitTreeNode.coord ? splitTreeNode.negative : splitTreeNode.positive;
               }
            }
            if(splitTreeNode != null && splitTreeNode.indices != null)
            {
               len = int(splitTreeNode.indices.length);
               i = 0;
               while(i < len)
               {
                  shape = this.kdTree.primitives[splitTreeNode.indices[i]];
                  if((shape.collisionGroup & collisionGroup) != 0)
                  {
                     if(!(filter != null && !filter.considerBody(shape.body)))
                     {
                        result.time = shape.raycast(origin,direction,this.threshold,result.normal);
                        if(result.time >= 0)
                        {
                           result.position.copy(this.point);
                           result.shape = shape;
                           return true;
                        }
                     }
                  }
                  i++;
               }
            }
         }
         return this.testRayAgainstNode(nearNode == node.negative ? node.positive : node.negative,origin,this.point,direction,collisionGroup,splitTime,maxTime,filter,result);
      }
      
      private function getRayNodeIntersection(origin:Vector3, direction:Vector3, collisionGroup:int, primitives:Vector.<CollisionShape>, indices:Vector.<int>, filter:IRayCollisionFilter, result:RayHit) : Boolean
      {
         var shape:CollisionShape = null;
         var t:Number = NaN;
         var len:int = int(indices.length);
         var minTime:Number = 1e+308;
         var i:int = 0;
         while(i < len)
         {
            shape = primitives[indices[i]];
            if((shape.collisionGroup & collisionGroup) != 0)
            {
               if(!(filter != null && !filter.considerBody(shape.body)))
               {
                  t = Number(shape.raycast(origin,direction,this.threshold,this.normal));
                  if(t > 0 && t < minTime)
                  {
                     minTime = t;
                     result.shape = shape;
                     result.normal.x = this.normal.x;
                     result.normal.y = this.normal.y;
                     result.normal.z = this.normal.z;
                  }
               }
            }
            i++;
         }
         if(minTime == 1e+308)
         {
            return false;
         }
         result.position.x = origin.x + direction.x * minTime;
         result.position.y = origin.y + direction.y * minTime;
         result.position.z = origin.z + direction.z * minTime;
         result.time = minTime;
         return true;
      }
      
      public function testStaticCollision(shape:CollisionShape) : Boolean
      {
         return this.testShapeNodeCollision(shape,this.kdTree.rootNode);
      }
   }
}

