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
      
      private static const luculeqa:Number = 0.01;
      
      private const pusuc:Object = {};
      
      private const tet:RayHit = new RayHit();
      
      private const bilaw:MinMax = new MinMax();
      
      private const wawuse:Vector3 = new Vector3();
      
      private const zidihyw:Vector3 = new Vector3();
      
      private const mydip:RayHit = new RayHit();
      
      private const lukej:AABB = new AABB();
      
      private const pupicic:Vector.<ShapeContact> = new Vector.<ShapeContact>();
      
      private var nyseh:CollisionKdTree = new CollisionKdTree();
      
      private var threshold:Number = 0.0001;
      
      private var cubajedid:Vector.<TankBody> = new Vector.<TankBody>();
      
      private var sity:Vector.<Body> = new Vector.<Body>();
      
      private var kobet:Body;
      
      public function TanksCollisionDetector()
      {
         super();
         var _loc1_:Number = 0.000001;
         this.setCollider(CollisionShape.BOX,CollisionShape.BOX,new BoxBoxCollider(_loc1_));
         this.setCollider(CollisionShape.BOX,CollisionShape.RECT,new BoxRectCollider(_loc1_));
         this.setCollider(CollisionShape.BOX,CollisionShape.TRIANGLE,new BoxTriangleCollider(_loc1_));
         this.createStaticBody();
      }
      
      private function setCollider(param1:int, param2:int, param3:Collider) : void
      {
         this.pusuc[param1 | param2] = param3;
      }
      
      private function createStaticBody() : void
      {
         this.kobet = new Body(1,new Matrix3());
         this.kobet.movable = false;
      }
      
      public function buildKdTree(param1:Vector.<CollisionShape>, param2:AABB = null) : void
      {
         var _loc3_:CollisionShape = null;
         for each(_loc3_ in param1)
         {
            _loc3_.body = this.kobet;
         }
         this.nyseh.createTree(param1,param2);
      }
      
      public function addTankBody(param1:TankBody) : void
      {
         this.cubajedid.push(param1);
      }
      
      public function removeTankBody(param1:TankBody) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = this.cubajedid.indexOf(param1);
         if(_loc2_ > -1)
         {
            _loc3_ = this.cubajedid.length - 1;
            this.cubajedid[_loc2_] = this.cubajedid[_loc3_];
            this.cubajedid.length = _loc3_;
         }
      }
      
      public function addKineamticBody(param1:Body) : void
      {
         if(this.sity.indexOf(param1) < 0)
         {
            this.sity.push(param1);
         }
      }
      
      public function removeKinematicBody(param1:Body) : void
      {
         var _loc2_:int = this.sity.indexOf(param1);
         if(_loc2_ > -1)
         {
            this.sity.splice(_loc2_,1);
         }
      }
      
      public function getBodyContacts(param1:Vector.<BodyContact>) : void
      {
         var _loc4_:TankBody = null;
         var _loc5_:int = 0;
         var _loc2_:int = int(this.cubajedid.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.cubajedid[_loc3_];
            _loc4_.vahuzys = false;
            _loc4_.put = false;
            _loc5_ = int(param1.length);
            this.getContactsWithStatic(_loc4_,param1);
            if(_loc5_ != param1.length)
            {
               _loc4_.vahuzys = true;
            }
            _loc5_ = int(param1.length);
            this.getContactsWithOtherBodies(_loc4_,_loc3_ + 1,param1);
            if(_loc5_ != param1.length)
            {
               _loc4_.put = true;
            }
            this.getContactsWithKinematicBodies(_loc4_,param1);
            _loc3_++;
         }
      }
      
      private function getContactsWithStatic(param1:TankBody, param2:Vector.<BodyContact>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:BodyContact = null;
         if(!param1.body.frozen)
         {
            _loc3_ = int(param1.kodasy.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               this.getShapeNodeCollisions(this.nyseh.rootNode,param1.kodasy[_loc4_],this.pupicic);
               _loc4_++;
            }
            if(this.pupicic.length > 0)
            {
               _loc5_ = BodyContact.create();
               _loc5_.body1 = param1.body;
               _loc5_.body2 = this.kobet;
               _loc5_.setShapeContacts(this.pupicic);
               this.pupicic.length = 0;
               param2[param2.length] = _loc5_;
            }
         }
      }
      
      private function getContactsWithOtherBodies(param1:TankBody, param2:int, param3:Vector.<BodyContact>) : void
      {
         var _loc6_:TankBody = null;
         var _loc7_:Body = null;
         var _loc8_:Body = null;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:BodyContact = null;
         var _loc13_:int = 0;
         var _loc14_:ShapeContact = null;
         var _loc4_:int = int(this.cubajedid.length);
         var _loc5_:int = param2;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this.cubajedid[_loc5_];
            _loc7_ = param1.body;
            _loc8_ = _loc6_.body;
            if(!(Boolean(_loc7_.frozen) && Boolean(_loc8_.frozen)) && Boolean(_loc7_.aabb.intersects(_loc8_.aabb,luculeqa)))
            {
               this.getContacts(param1.kyripama,_loc6_.kyripama,this.pupicic);
               _loc9_ = int(this.pupicic.length);
               if(_loc9_ > 0)
               {
                  _loc10_ = _loc7_.collisionFilter == null || Boolean(_loc7_.collisionFilter.considerBodies(_loc7_,_loc8_));
                  _loc11_ = _loc8_.collisionFilter == null || Boolean(_loc8_.collisionFilter.considerBodies(_loc8_,_loc7_));
                  if(_loc10_ && _loc11_)
                  {
                     _loc12_ = BodyContact.create();
                     _loc12_.body1 = _loc7_;
                     _loc12_.body2 = _loc8_;
                     _loc12_.setShapeContacts(this.pupicic);
                     param3[param3.length] = _loc12_;
                  }
                  else
                  {
                     _loc13_ = 0;
                     while(_loc13_ < _loc9_)
                     {
                        _loc14_ = this.pupicic[_loc13_];
                        _loc14_.dispose();
                        _loc13_++;
                     }
                  }
                  this.pupicic.length = 0;
               }
            }
            _loc5_++;
         }
      }
      
      private function getContactsWithKinematicBodies(param1:TankBody, param2:Vector.<BodyContact>) : void
      {
         var _loc5_:Body = null;
         var _loc3_:int = int(this.sity.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.sity[_loc4_];
            this.getBodyBodyContact(param1.body,_loc5_,param2);
            _loc4_++;
         }
      }
      
      private function getBodyBodyContact(param1:Body, param2:Body, param3:Vector.<BodyContact>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Vector.<CollisionShape> = null;
         var _loc6_:int = 0;
         var _loc7_:Vector.<CollisionShape> = null;
         var _loc8_:int = 0;
         var _loc9_:CollisionShape = null;
         var _loc10_:int = 0;
         var _loc11_:BodyContact = null;
         if(param1.aabb.intersects(param2.aabb,luculeqa))
         {
            _loc4_ = int(param1.numCollisionShapes);
            _loc5_ = param1.collisionShapes;
            _loc6_ = int(param2.numCollisionShapes);
            _loc7_ = param2.collisionShapes;
            _loc8_ = 0;
            while(_loc8_ < _loc4_)
            {
               _loc9_ = _loc5_[_loc8_];
               _loc10_ = 0;
               while(_loc10_ < _loc6_)
               {
                  this.getContacts(_loc9_,_loc7_[_loc10_],this.pupicic);
                  _loc10_++;
               }
               _loc8_++;
            }
            if(this.pupicic.length > 0)
            {
               _loc11_ = BodyContact.create();
               _loc11_.body1 = param1;
               _loc11_.body2 = param2;
               _loc11_.setShapeContacts(this.pupicic);
               param3[param3.length] = _loc11_;
               this.pupicic.length = 0;
            }
         }
      }
      
      public function getContacts(param1:CollisionShape, param2:CollisionShape, param3:Vector.<ShapeContact>) : void
      {
         if((param1.collisionGroup & param2.collisionGroup) == 0)
         {
            return;
         }
         if(param1.body == param2.body)
         {
            return;
         }
         if(!param1.aabb.intersects(param2.aabb,luculeqa))
         {
            return;
         }
         var _loc4_:Collider = this.pusuc[param1.type | param2.type];
         _loc4_.getContacts(param1,param2,param3);
      }
      
      public function testCollision(param1:CollisionShape, param2:CollisionShape) : Boolean
      {
         if((param1.collisionGroup & param2.collisionGroup) == 0)
         {
            return false;
         }
         if(param1.body == param2.body)
         {
            return false;
         }
         if(!param1.aabb.intersects(param2.aabb,luculeqa))
         {
            return false;
         }
         var _loc3_:Collider = this.pusuc[param1.type | param2.type];
         return _loc3_.haveCollision(param1,param2);
      }
      
      public function raycast(param1:Vector3, param2:Vector3, param3:int, param4:Number, param5:IRayCollisionFilter, param6:RayHit) : Boolean
      {
         var _loc7_:Boolean = this.raycastStatic(param1,param2,param3,param4,param5,param6);
         var _loc8_:Boolean = this.raycastDynamic(param1,param2,param3,param4,param5,this.mydip);
         if(!(_loc8_ || _loc7_))
         {
            return false;
         }
         if(_loc8_ && _loc7_)
         {
            if(param6.jomuc > this.mydip.jomuc)
            {
               param6.copy(this.mydip);
            }
            this.mydip.clear();
            return true;
         }
         if(_loc7_)
         {
            this.mydip.clear();
            return true;
         }
         param6.copy(this.mydip);
         this.mydip.clear();
         return true;
      }
      
      public function raycastStatic(param1:Vector3, param2:Vector3, param3:int, param4:Number, param5:IRayCollisionFilter, param6:RayHit) : Boolean
      {
         if(!this.getRayBoundBoxIntersection(param1,param2,this.nyseh.rootNode.boundBox,this.bilaw))
         {
            return false;
         }
         if(this.bilaw.rekycave < 0 || this.bilaw.rylegyqa > param4)
         {
            return false;
         }
         if(this.bilaw.rylegyqa <= 0)
         {
            this.bilaw.rylegyqa = 0;
            this.zidihyw.x = param1.x;
            this.zidihyw.y = param1.y;
            this.zidihyw.z = param1.z;
         }
         else
         {
            this.zidihyw.x = param1.x + this.bilaw.rylegyqa * param2.x;
            this.zidihyw.y = param1.y + this.bilaw.rylegyqa * param2.y;
            this.zidihyw.z = param1.z + this.bilaw.rylegyqa * param2.z;
         }
         if(this.bilaw.rekycave > param4)
         {
            this.bilaw.rekycave = param4;
         }
         var _loc7_:Boolean = this.testRayAgainstNode(this.nyseh.rootNode,param1,this.zidihyw,param2,param3,this.bilaw.rylegyqa,this.bilaw.rekycave,param5,param6);
         return _loc7_ ? param6.jomuc <= param4 : false;
      }
      
      public function hasStaticHit(param1:Vector3, param2:Vector3, param3:int, param4:Number, param5:IRayCollisionFilter = null) : Boolean
      {
         var _loc6_:Boolean = this.raycastStatic(param1,param2,param3,param4,param5,this.tet);
         this.tet.clear();
         return _loc6_;
      }
      
      private function getShapeNodeCollisions(param1:CollisionKdNode, param2:CollisionShape, param3:Vector.<ShapeContact>) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Vector.<CollisionShape> = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1.indices != null)
         {
            _loc6_ = this.nyseh.primitives;
            _loc7_ = param1.indices;
            _loc8_ = int(_loc7_.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               this.getContacts(param2,_loc6_[_loc7_[_loc9_]],param3);
               _loc9_++;
            }
         }
         if(param1.axis == -1)
         {
            return;
         }
         switch(param1.axis)
         {
            case 0:
               _loc4_ = Number(param2.aabb.minX);
               _loc5_ = Number(param2.aabb.maxX);
               break;
            case 1:
               _loc4_ = Number(param2.aabb.minY);
               _loc5_ = Number(param2.aabb.maxY);
               break;
            case 2:
               _loc4_ = Number(param2.aabb.minZ);
               _loc5_ = Number(param2.aabb.maxZ);
         }
         if(_loc4_ < param1.coord)
         {
            this.getShapeNodeCollisions(param1.negative,param2,param3);
         }
         if(_loc5_ > param1.coord)
         {
            this.getShapeNodeCollisions(param1.positive,param2,param3);
         }
         if(param1.splitTree != null && _loc4_ < param1.coord && _loc5_ > param1.coord)
         {
            this.getShapeNodeCollisions(param1.splitTree.rootNode,param2,param3);
         }
      }
      
      private function testShapeNodeCollision(param1:CollisionShape, param2:CollisionKdNode) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<CollisionShape> = null;
         var _loc6_:Vector.<int> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param2.indices != null)
         {
            _loc5_ = this.nyseh.primitives;
            _loc6_ = param2.indices;
            _loc7_ = int(_loc6_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               if(this.testCollision(param1,_loc5_[_loc6_[_loc8_]]))
               {
                  return true;
               }
               _loc8_++;
            }
         }
         if(param2.axis == -1)
         {
            return false;
         }
         switch(param2.axis)
         {
            case 0:
               _loc3_ = Number(param1.aabb.minX);
               _loc4_ = Number(param1.aabb.maxX);
               break;
            case 1:
               _loc3_ = Number(param1.aabb.minY);
               _loc4_ = Number(param1.aabb.maxY);
               break;
            case 2:
               _loc3_ = Number(param1.aabb.minZ);
               _loc4_ = Number(param1.aabb.maxZ);
         }
         if(param2.splitTree != null && _loc3_ < param2.coord && _loc4_ > param2.coord)
         {
            if(this.testShapeNodeCollision(param1,param2.splitTree.rootNode))
            {
               return true;
            }
         }
         if(_loc3_ < param2.coord)
         {
            if(this.testShapeNodeCollision(param1,param2.negative))
            {
               return true;
            }
         }
         if(_loc4_ > param2.coord)
         {
            if(this.testShapeNodeCollision(param1,param2.positive))
            {
               return true;
            }
         }
         return false;
      }
      
      private function raycastDynamic(param1:Vector3, param2:Vector3, param3:int, param4:Number, param5:IRayCollisionFilter, param6:RayHit) : Boolean
      {
         var _loc13_:TankBody = null;
         var _loc14_:Body = null;
         var _loc15_:AABB = null;
         var _loc16_:int = 0;
         var _loc17_:CollisionShape = null;
         var _loc18_:Number = NaN;
         var _loc7_:Number = param1.x + param2.x * param4;
         var _loc8_:Number = param1.y + param2.y * param4;
         var _loc9_:Number = param1.z + param2.z * param4;
         if(_loc7_ < param1.x)
         {
            this.lukej.minX = _loc7_;
            this.lukej.maxX = param1.x;
         }
         else
         {
            this.lukej.minX = param1.x;
            this.lukej.maxX = _loc7_;
         }
         if(_loc8_ < param1.y)
         {
            this.lukej.minY = _loc8_;
            this.lukej.maxY = param1.y;
         }
         else
         {
            this.lukej.minY = param1.y;
            this.lukej.maxY = _loc8_;
         }
         if(_loc9_ < param1.z)
         {
            this.lukej.minZ = _loc9_;
            this.lukej.maxZ = param1.z;
         }
         else
         {
            this.lukej.minZ = param1.z;
            this.lukej.maxZ = _loc9_;
         }
         var _loc10_:Number = param4 + 1;
         var _loc11_:int = int(this.cubajedid.length);
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_)
         {
            _loc13_ = this.cubajedid[_loc12_];
            _loc14_ = _loc13_.body;
            _loc15_ = _loc14_.aabb;
            if(!(this.lukej.maxX < _loc15_.minX || this.lukej.minX > _loc15_.maxX || this.lukej.maxY < _loc15_.minY || this.lukej.minY > _loc15_.maxY || this.lukej.maxZ < _loc15_.minZ || this.lukej.minZ > _loc15_.maxZ))
            {
               _loc16_ = 0;
               while(_loc16_ < _loc14_.numCollisionShapes)
               {
                  _loc17_ = _loc14_.collisionShapes[_loc16_];
                  if((_loc17_.collisionGroup & param3) != 0)
                  {
                     _loc15_ = _loc17_.aabb;
                     if(!(this.lukej.maxX < _loc15_.minX || this.lukej.minX > _loc15_.maxX || this.lukej.maxY < _loc15_.minY || this.lukej.minY > _loc15_.maxY || this.lukej.maxZ < _loc15_.minZ || this.lukej.minZ > _loc15_.maxZ))
                     {
                        if(!(param5 != null && !param5.considerBody(_loc14_)))
                        {
                           _loc18_ = Number(_loc17_.raycast(param1,param2,this.threshold,this.wawuse));
                           if(_loc18_ >= 0 && _loc18_ < _loc10_)
                           {
                              _loc10_ = _loc18_;
                              param6.shape = _loc17_;
                              param6.normal.x = this.wawuse.x;
                              param6.normal.y = this.wawuse.y;
                              param6.normal.z = this.wawuse.z;
                           }
                        }
                     }
                  }
                  _loc16_++;
               }
            }
            _loc12_++;
         }
         if(_loc10_ > param4)
         {
            return false;
         }
         param6.position.x = param1.x + param2.x * _loc10_;
         param6.position.y = param1.y + param2.y * _loc10_;
         param6.position.z = param1.z + param2.z * _loc10_;
         param6.jomuc = _loc10_;
         return true;
      }
      
      private function getRayBoundBoxIntersection(param1:Vector3, param2:Vector3, param3:AABB, param4:MinMax) : Boolean
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         param4.rylegyqa = -1;
         param4.rekycave = 1e+308;
         var _loc7_:int = 0;
         for(; _loc7_ < 3; _loc7_++)
         {
            switch(_loc7_)
            {
               case 0:
                  if(!(param2.x < this.threshold && param2.x > -this.threshold))
                  {
                     _loc5_ = (param3.minX - param1.x) / param2.x;
                     _loc6_ = (param3.maxX - param1.x) / param2.x;
                     break;
                  }
                  if(param1.x < param3.minX || param1.x > param3.maxX)
                  {
                     return false;
                  }
                  continue;
               case 1:
                  if(!(param2.y < this.threshold && param2.y > -this.threshold))
                  {
                     _loc5_ = (param3.minY - param1.y) / param2.y;
                     _loc6_ = (param3.maxY - param1.y) / param2.y;
                     break;
                  }
                  if(param1.y < param3.minY || param1.y > param3.maxY)
                  {
                     return false;
                  }
                  continue;
               case 2:
                  if(!(param2.z < this.threshold && param2.z > -this.threshold))
                  {
                     _loc5_ = (param3.minZ - param1.z) / param2.z;
                     _loc6_ = (param3.maxZ - param1.z) / param2.z;
                     break;
                  }
                  if(param1.z < param3.minZ || param1.z > param3.maxZ)
                  {
                     return false;
                  }
                  continue;
            }
            if(_loc5_ < _loc6_)
            {
               if(_loc5_ > param4.rylegyqa)
               {
                  param4.rylegyqa = _loc5_;
               }
               if(_loc6_ < param4.rekycave)
               {
                  param4.rekycave = _loc6_;
               }
            }
            else
            {
               if(_loc6_ > param4.rylegyqa)
               {
                  param4.rylegyqa = _loc6_;
               }
               if(_loc5_ < param4.rekycave)
               {
                  param4.rekycave = _loc5_;
               }
            }
            if(param4.rekycave < param4.rylegyqa)
            {
               return false;
            }
         }
         return true;
      }
      
      private function testRayAgainstNode(param1:CollisionKdNode, param2:Vector3, param3:Vector3, param4:Vector3, param5:int, param6:Number, param7:Number, param8:IRayCollisionFilter, param9:RayHit) : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:CollisionKdNode = null;
         var _loc12_:Boolean = false;
         var _loc13_:CollisionKdNode = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:CollisionShape = null;
         if(param1.indices != null && this.getRayNodeIntersection(param2,param4,param5,this.nyseh.primitives,param1.indices,param8,param9))
         {
            return true;
         }
         if(param1.axis == -1)
         {
            return false;
         }
         switch(param1.axis)
         {
            case 0:
               if(param4.x > -this.threshold && param4.x < this.threshold)
               {
                  _loc10_ = param7 + 1;
               }
               else
               {
                  _loc10_ = (param1.coord - param2.x) / param4.x;
               }
               _loc11_ = param3.x < param1.coord ? param1.negative : param1.positive;
               break;
            case 1:
               if(param4.y > -this.threshold && param4.y < this.threshold)
               {
                  _loc10_ = param7 + 1;
               }
               else
               {
                  _loc10_ = (param1.coord - param2.y) / param4.y;
               }
               _loc11_ = param3.y < param1.coord ? param1.negative : param1.positive;
               break;
            case 2:
               if(param4.z > -this.threshold && param4.z < this.threshold)
               {
                  _loc10_ = param7 + 1;
               }
               else
               {
                  _loc10_ = (param1.coord - param2.z) / param4.z;
               }
               _loc11_ = param3.z < param1.coord ? param1.negative : param1.positive;
         }
         if(_loc10_ < param6 || _loc10_ > param7)
         {
            return this.testRayAgainstNode(_loc11_,param2,param3,param4,param5,param6,param7,param8,param9);
         }
         _loc12_ = this.testRayAgainstNode(_loc11_,param2,param3,param4,param5,param6,_loc10_,param8,param9);
         if(_loc12_)
         {
            return true;
         }
         this.zidihyw.x = param2.x + _loc10_ * param4.x;
         this.zidihyw.y = param2.y + _loc10_ * param4.y;
         this.zidihyw.z = param2.z + _loc10_ * param4.z;
         if(param1.splitTree != null)
         {
            _loc13_ = param1.splitTree.rootNode;
            while(_loc13_ != null && _loc13_.axis != -1)
            {
               switch(_loc13_.axis)
               {
                  case 0:
                     _loc13_ = this.zidihyw.x < _loc13_.coord ? _loc13_.negative : _loc13_.positive;
                     break;
                  case 1:
                     _loc13_ = this.zidihyw.y < _loc13_.coord ? _loc13_.negative : _loc13_.positive;
                     break;
                  case 2:
                     _loc13_ = this.zidihyw.z < _loc13_.coord ? _loc13_.negative : _loc13_.positive;
               }
            }
            if(_loc13_ != null && _loc13_.indices != null)
            {
               _loc14_ = int(_loc13_.indices.length);
               _loc15_ = 0;
               while(_loc15_ < _loc14_)
               {
                  _loc16_ = this.nyseh.primitives[_loc13_.indices[_loc15_]];
                  if((_loc16_.collisionGroup & param5) != 0)
                  {
                     if(!(param8 != null && !param8.considerBody(_loc16_.body)))
                     {
                        param9.jomuc = _loc16_.raycast(param2,param4,this.threshold,param9.normal);
                        if(param9.jomuc >= 0)
                        {
                           param9.position.copy(this.zidihyw);
                           param9.shape = _loc16_;
                           return true;
                        }
                     }
                  }
                  _loc15_++;
               }
            }
         }
         return this.testRayAgainstNode(_loc11_ == param1.negative ? param1.positive : param1.negative,param2,this.zidihyw,param4,param5,_loc10_,param7,param8,param9);
      }
      
      private function getRayNodeIntersection(param1:Vector3, param2:Vector3, param3:int, param4:Vector.<CollisionShape>, param5:Vector.<int>, param6:IRayCollisionFilter, param7:RayHit) : Boolean
      {
         var _loc11_:CollisionShape = null;
         var _loc12_:Number = NaN;
         var _loc8_:int = int(param5.length);
         var _loc9_:Number = 1e+308;
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_)
         {
            _loc11_ = param4[param5[_loc10_]];
            if((_loc11_.collisionGroup & param3) != 0)
            {
               if(!(param6 != null && !param6.considerBody(_loc11_.body)))
               {
                  _loc12_ = Number(_loc11_.raycast(param1,param2,this.threshold,this.wawuse));
                  if(_loc12_ > 0 && _loc12_ < _loc9_)
                  {
                     _loc9_ = _loc12_;
                     param7.shape = _loc11_;
                     param7.normal.x = this.wawuse.x;
                     param7.normal.y = this.wawuse.y;
                     param7.normal.z = this.wawuse.z;
                  }
               }
            }
            _loc10_++;
         }
         if(_loc9_ == 1e+308)
         {
            return false;
         }
         param7.position.x = param1.x + param2.x * _loc9_;
         param7.position.y = param1.y + param2.y * _loc9_;
         param7.position.z = param1.z + param2.z * _loc9_;
         param7.jomuc = _loc9_;
         return true;
      }
      
      public function testStaticCollision(param1:CollisionShape) : Boolean
      {
         return this.testShapeNodeCollision(param1,this.nyseh.rootNode);
      }
   }
}

