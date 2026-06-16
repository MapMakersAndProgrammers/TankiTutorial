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
      
      public var kurymyf:Number;
      
      private var jicywos:Number;
      
      private const pemufo:Vector3 = new Vector3();
      
      private const zekos:Vector3 = new Vector3();
      
      private const gisepimin:Vector3 = new Vector3();
      
      private const zimep:Vector3 = new Vector3();
      
      private const naruqe:Vector3 = new Vector3();
      
      private const gizy:Vector3 = new Vector3();
      
      private const vas:Vector3 = new Vector3();
      
      private const rapag:Vector3 = new Vector3();
      
      private const seko:Vector3 = new Vector3();
      
      private const labisiqyg:Matrix4 = new Matrix4();
      
      private const zihuta:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex(),new Vertex()]);
      
      private const wawi:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex()]);
      
      public function BoxTriangleCollider(param1:Number)
      {
         super();
         this.kurymyf = param1;
      }
      
      public function getContacts(param1:CollisionShape, param2:CollisionShape, param3:Vector.<ShapeContact>) : void
      {
         var _loc4_:CollisionTriangle = null;
         var _loc5_:CollisionBox = null;
         if(!this.haveCollision(param1,param2))
         {
            return;
         }
         if(param1 is CollisionBox)
         {
            _loc5_ = CollisionBox(param1);
            _loc4_ = CollisionTriangle(param2);
         }
         else
         {
            _loc5_ = CollisionBox(param2);
            _loc4_ = CollisionTriangle(param1);
         }
         this.findContacts(_loc5_,_loc4_,this.seko,param3);
      }
      
      public function haveCollision(param1:CollisionShape, param2:CollisionShape) : Boolean
      {
         var _loc3_:CollisionTriangle = null;
         var _loc4_:CollisionBox = null;
         var _loc5_:Matrix4 = null;
         var _loc6_:Matrix4 = null;
         var _loc7_:Vector3 = null;
         if(param1 is CollisionBox)
         {
            _loc4_ = CollisionBox(param1);
            _loc3_ = CollisionTriangle(param2);
         }
         else
         {
            _loc4_ = CollisionBox(param2);
            _loc3_ = CollisionTriangle(param1);
         }
         _loc5_ = _loc4_.wet;
         _loc6_ = _loc3_.wet;
         this.pemufo.x = _loc5_.kyvuru - _loc6_.kyvuru;
         this.pemufo.y = _loc5_.zumidynip - _loc6_.zumidynip;
         this.pemufo.z = _loc5_.sunafepo - _loc6_.sunafepo;
         this.jicywos = 10000000000;
         this.zekos.x = _loc6_.sivy;
         this.zekos.y = _loc6_.wyvukog;
         this.zekos.z = _loc6_.tari;
         if(!this.testOverlapOnMainAxis(_loc4_,_loc3_,this.zekos,this.pemufo))
         {
            return false;
         }
         this.gisepimin.x = _loc5_.gusat;
         this.gisepimin.y = _loc5_.sig;
         this.gisepimin.z = _loc5_.vug;
         if(!this.testOverlapOnMainAxis(_loc4_,_loc3_,this.gisepimin,this.pemufo))
         {
            return false;
         }
         this.zimep.x = _loc5_.cydop;
         this.zimep.y = _loc5_.qanezycap;
         this.zimep.z = _loc5_.luwym;
         if(!this.testOverlapOnMainAxis(_loc4_,_loc3_,this.zimep,this.pemufo))
         {
            return false;
         }
         this.naruqe.x = _loc5_.sivy;
         this.naruqe.y = _loc5_.wyvukog;
         this.naruqe.z = _loc5_.tari;
         if(!this.testOverlapOnMainAxis(_loc4_,_loc3_,this.naruqe,this.pemufo))
         {
            return false;
         }
         _loc7_ = _loc3_.dodupypic;
         this.gizy.x = _loc6_.gusat * _loc7_.x + _loc6_.cydop * _loc7_.y + _loc6_.sivy * _loc7_.z;
         this.gizy.y = _loc6_.sig * _loc7_.x + _loc6_.qanezycap * _loc7_.y + _loc6_.wyvukog * _loc7_.z;
         this.gizy.z = _loc6_.vug * _loc7_.x + _loc6_.luwym * _loc7_.y + _loc6_.tari * _loc7_.z;
         if(!this.testOverlapOnDerivedAxis(_loc4_,_loc3_,this.gisepimin,this.gizy,this.pemufo))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc4_,_loc3_,this.zimep,this.gizy,this.pemufo))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc4_,_loc3_,this.naruqe,this.gizy,this.pemufo))
         {
            return false;
         }
         _loc7_ = _loc3_.cilozuj;
         this.vas.x = _loc6_.gusat * _loc7_.x + _loc6_.cydop * _loc7_.y + _loc6_.sivy * _loc7_.z;
         this.vas.y = _loc6_.sig * _loc7_.x + _loc6_.qanezycap * _loc7_.y + _loc6_.wyvukog * _loc7_.z;
         this.vas.z = _loc6_.vug * _loc7_.x + _loc6_.luwym * _loc7_.y + _loc6_.tari * _loc7_.z;
         if(!this.testOverlapOnDerivedAxis(_loc4_,_loc3_,this.gisepimin,this.vas,this.pemufo))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc4_,_loc3_,this.zimep,this.vas,this.pemufo))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc4_,_loc3_,this.naruqe,this.vas,this.pemufo))
         {
            return false;
         }
         _loc7_ = _loc3_.dij;
         this.rapag.x = _loc6_.gusat * _loc7_.x + _loc6_.cydop * _loc7_.y + _loc6_.sivy * _loc7_.z;
         this.rapag.y = _loc6_.sig * _loc7_.x + _loc6_.qanezycap * _loc7_.y + _loc6_.wyvukog * _loc7_.z;
         this.rapag.z = _loc6_.vug * _loc7_.x + _loc6_.luwym * _loc7_.y + _loc6_.tari * _loc7_.z;
         if(!this.testOverlapOnDerivedAxis(_loc4_,_loc3_,this.gisepimin,this.rapag,this.pemufo))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc4_,_loc3_,this.zimep,this.rapag,this.pemufo))
         {
            return false;
         }
         return this.testOverlapOnDerivedAxis(_loc4_,_loc3_,this.naruqe,this.rapag,this.pemufo);
      }
      
      private function testOverlapOnMainAxis(param1:CollisionBox, param2:CollisionTriangle, param3:Vector3, param4:Vector3) : Boolean
      {
         var _loc5_:Number = this.getOverlapOnAxis(param1,param2,param3,param4);
         return this.registerOverlap(_loc5_,param3);
      }
      
      private function registerOverlap(param1:Number, param2:Vector3) : Boolean
      {
         if(param1 < this.kurymyf)
         {
            return false;
         }
         if(param1 + this.kurymyf < this.jicywos)
         {
            this.jicywos = param1;
            this.seko.x = param2.x;
            this.seko.y = param2.y;
            this.seko.z = param2.z;
         }
         return true;
      }
      
      private function testOverlapOnDerivedAxis(param1:CollisionBox, param2:CollisionTriangle, param3:Vector3, param4:Vector3, param5:Vector3) : Boolean
      {
         var _loc7_:Number = NaN;
         this.zekos.x = param3.y * param4.z - param3.z * param4.y;
         this.zekos.y = param3.z * param4.x - param3.x * param4.z;
         this.zekos.z = param3.x * param4.y - param3.y * param4.x;
         var _loc6_:Number = this.zekos.x * this.zekos.x + this.zekos.y * this.zekos.y + this.zekos.z * this.zekos.z;
         if(_loc6_ < 1e-10)
         {
            return true;
         }
         _loc7_ = 1 / Math.sqrt(_loc6_);
         this.zekos.x *= _loc7_;
         this.zekos.y *= _loc7_;
         this.zekos.z *= _loc7_;
         var _loc8_:Number = this.getOverlapOnAxis(param1,param2,this.zekos,param5);
         return this.registerOverlap(_loc8_,this.zekos);
      }
      
      private function getOverlapOnAxis(param1:CollisionBox, param2:CollisionTriangle, param3:Vector3, param4:Vector3) : Number
      {
         var _loc8_:Number = NaN;
         var _loc5_:Matrix4 = param1.wet;
         var _loc6_:Vector3 = param1.nezav;
         var _loc7_:Number = 0;
         _loc8_ = (_loc5_.gusat * param3.x + _loc5_.sig * param3.y + _loc5_.vug * param3.z) * _loc6_.x;
         if(_loc8_ < 0)
         {
            _loc7_ -= _loc8_;
         }
         else
         {
            _loc7_ += _loc8_;
         }
         _loc8_ = (_loc5_.cydop * param3.x + _loc5_.qanezycap * param3.y + _loc5_.luwym * param3.z) * _loc6_.y;
         if(_loc8_ < 0)
         {
            _loc7_ -= _loc8_;
         }
         else
         {
            _loc7_ += _loc8_;
         }
         _loc8_ = (_loc5_.sivy * param3.x + _loc5_.wyvukog * param3.y + _loc5_.tari * param3.z) * _loc6_.z;
         if(_loc8_ < 0)
         {
            _loc7_ -= _loc8_;
         }
         else
         {
            _loc7_ += _loc8_;
         }
         var _loc9_:Number = param4.x * param3.x + param4.y * param3.y + param4.z * param3.z;
         var _loc10_:Matrix4 = param2.wet;
         var _loc11_:Number = _loc10_.gusat * param3.x + _loc10_.sig * param3.y + _loc10_.vug * param3.z;
         var _loc12_:Number = _loc10_.cydop * param3.x + _loc10_.qanezycap * param3.y + _loc10_.luwym * param3.z;
         var _loc13_:Number = _loc10_.sivy * param3.x + _loc10_.wyvukog * param3.y + _loc10_.tari * param3.z;
         var _loc14_:Number = 0;
         var _loc15_:Vector3 = param2.lyzud;
         var _loc16_:Vector3 = param2.pedake;
         var _loc17_:Vector3 = param2.bykecy;
         if(_loc9_ < 0)
         {
            _loc9_ = -_loc9_;
            _loc8_ = _loc15_.x * _loc11_ + _loc15_.y * _loc12_ + _loc15_.z * _loc13_;
            if(_loc8_ < _loc14_)
            {
               _loc14_ = _loc8_;
            }
            _loc8_ = _loc16_.x * _loc11_ + _loc16_.y * _loc12_ + _loc16_.z * _loc13_;
            if(_loc8_ < _loc14_)
            {
               _loc14_ = _loc8_;
            }
            _loc8_ = _loc17_.x * _loc11_ + _loc17_.y * _loc12_ + _loc17_.z * _loc13_;
            if(_loc8_ < _loc14_)
            {
               _loc14_ = _loc8_;
            }
            _loc14_ = -_loc14_;
         }
         else
         {
            _loc8_ = _loc15_.x * _loc11_ + _loc15_.y * _loc12_ + _loc15_.z * _loc13_;
            if(_loc8_ > _loc14_)
            {
               _loc14_ = _loc8_;
            }
            _loc8_ = _loc16_.x * _loc11_ + _loc16_.y * _loc12_ + _loc16_.z * _loc13_;
            if(_loc8_ > _loc14_)
            {
               _loc14_ = _loc8_;
            }
            _loc8_ = _loc17_.x * _loc11_ + _loc17_.y * _loc12_ + _loc17_.z * _loc13_;
            if(_loc8_ > _loc14_)
            {
               _loc14_ = _loc8_;
            }
         }
         return _loc7_ + _loc14_ - _loc9_;
      }
      
      private function findContacts(param1:CollisionBox, param2:CollisionTriangle, param3:Vector3, param4:Vector.<ShapeContact>) : void
      {
         var _loc6_:Matrix4 = null;
         var _loc7_:Vector3 = null;
         var _loc12_:ShapeContact = null;
         var _loc13_:Vector3 = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc5_:Matrix4 = param1.wet;
         _loc6_ = param2.wet;
         _loc7_ = this.pemufo;
         _loc7_.x = _loc5_.kyvuru - _loc6_.kyvuru;
         _loc7_.y = _loc5_.zumidynip - _loc6_.zumidynip;
         _loc7_.z = _loc5_.sunafepo - _loc6_.sunafepo;
         if(param3.x * _loc7_.x + param3.y * _loc7_.y + param3.z * _loc7_.z < 0)
         {
            param3.x = -param3.x;
            param3.y = -param3.y;
            param3.z = -param3.z;
         }
         var _loc8_:Matrix4 = this.labisiqyg;
         ColliderUtils.buildContactBasis(param3,_loc5_,_loc6_,_loc8_);
         ColliderUtils.getBoxFaceVerticesInCCWOrder(param1,param3,FaceSide.puwizi,this.zihuta);
         ColliderUtils.getTriangleFaceInCCWOrder(param2,param3,this.wawi);
         ColliderUtils.transformFaceToReferenceSpace(_loc8_,_loc5_,this.zihuta,4);
         ColliderUtils.transformFaceToReferenceSpace(_loc8_,_loc6_,this.wawi,3);
         var _loc9_:int = int(param4.length);
         PolygonsIntersectionUtils.findContacts(param1,this.zihuta,4,param2,this.wawi,3,_loc8_,param4);
         var _loc10_:int = int(param4.length);
         var _loc11_:int = _loc9_;
         while(_loc11_ < _loc10_)
         {
            _loc12_ = param4[_loc11_];
            _loc13_ = _loc12_.lefugefo;
            _loc14_ = _loc6_.sivy;
            _loc15_ = _loc6_.wyvukog;
            _loc16_ = _loc6_.tari;
            if(_loc13_.x * _loc14_ + _loc13_.y * _loc15_ + _loc13_.z * _loc16_ < 0)
            {
               _loc12_.dispose();
               _loc10_--;
               param4[_loc11_] = param4[_loc10_];
               param4[_loc10_] = null;
               _loc11_--;
            }
            _loc11_++;
         }
         if(_loc10_ < param4.length)
         {
            param4.length = _loc10_;
         }
      }
   }
}

