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
      
      private static const zihuta:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex(),new Vertex()]);
      
      private static const kifulylem:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex(),new Vertex()]);
      
      private static const labisiqyg:Matrix4 = new Matrix4();
      
      private const tupanamer:Vector3 = new Vector3();
      
      private const nydyfi:Vector3 = new Vector3();
      
      private const gisepimin:Vector3 = new Vector3();
      
      private const zimep:Vector3 = new Vector3();
      
      private const naruqe:Vector3 = new Vector3();
      
      private const gizy:Vector3 = new Vector3();
      
      private const vas:Vector3 = new Vector3();
      
      private const rapag:Vector3 = new Vector3();
      
      private const seko:Vector3 = new Vector3();
      
      private var jicywos:Number;
      
      private var kurymyf:Number;
      
      public function BoxRectCollider(param1:Number)
      {
         super();
         this.kurymyf = param1;
      }
      
      public function getContacts(param1:CollisionShape, param2:CollisionShape, param3:Vector.<ShapeContact>) : void
      {
         var _loc4_:CollisionRect = null;
         var _loc5_:CollisionBox = null;
         if(this.haveCollision(param1,param2))
         {
            if(param1 is CollisionRect)
            {
               _loc4_ = CollisionRect(param1);
               _loc5_ = CollisionBox(param2);
            }
            else
            {
               _loc4_ = CollisionRect(param2);
               _loc5_ = CollisionBox(param1);
            }
            this.findContacts(_loc5_,_loc4_,this.seko,param3);
         }
      }
      
      public function haveCollision(param1:CollisionShape, param2:CollisionShape) : Boolean
      {
         var _loc3_:CollisionBox = null;
         var _loc4_:CollisionRect = null;
         this.jicywos = 10000000000;
         if(param1 is CollisionBox)
         {
            _loc3_ = CollisionBox(param1);
            _loc4_ = CollisionRect(param2);
         }
         else
         {
            _loc3_ = CollisionBox(param2);
            _loc4_ = CollisionRect(param1);
         }
         var _loc5_:Matrix4 = _loc3_.wet;
         var _loc6_:Matrix4 = _loc4_.wet;
         this.tupanamer.x = _loc5_.kyvuru - _loc6_.kyvuru;
         this.tupanamer.y = _loc5_.zumidynip - _loc6_.zumidynip;
         this.tupanamer.z = _loc5_.sunafepo - _loc6_.sunafepo;
         this.rapag.x = _loc6_.sivy;
         this.rapag.y = _loc6_.wyvukog;
         this.rapag.z = _loc6_.tari;
         if(!this.testMainAxis(_loc3_,_loc4_,this.rapag,this.tupanamer))
         {
            return false;
         }
         this.gisepimin.x = _loc5_.gusat;
         this.gisepimin.y = _loc5_.sig;
         this.gisepimin.z = _loc5_.vug;
         if(!this.testMainAxis(_loc3_,_loc4_,this.gisepimin,this.tupanamer))
         {
            return false;
         }
         this.zimep.x = _loc5_.cydop;
         this.zimep.y = _loc5_.qanezycap;
         this.zimep.z = _loc5_.luwym;
         if(!this.testMainAxis(_loc3_,_loc4_,this.zimep,this.tupanamer))
         {
            return false;
         }
         this.naruqe.x = _loc5_.sivy;
         this.naruqe.y = _loc5_.wyvukog;
         this.naruqe.z = _loc5_.tari;
         if(!this.testMainAxis(_loc3_,_loc4_,this.naruqe,this.tupanamer))
         {
            return false;
         }
         this.gizy.x = _loc6_.gusat;
         this.gizy.y = _loc6_.sig;
         this.gizy.z = _loc6_.vug;
         this.vas.x = _loc6_.cydop;
         this.vas.y = _loc6_.qanezycap;
         this.vas.z = _loc6_.luwym;
         if(!this.testDerivedAxis(_loc3_,_loc4_,this.gisepimin,this.gizy,this.tupanamer))
         {
            return false;
         }
         if(!this.testDerivedAxis(_loc3_,_loc4_,this.gisepimin,this.vas,this.tupanamer))
         {
            return false;
         }
         if(!this.testDerivedAxis(_loc3_,_loc4_,this.zimep,this.gizy,this.tupanamer))
         {
            return false;
         }
         if(!this.testDerivedAxis(_loc3_,_loc4_,this.zimep,this.vas,this.tupanamer))
         {
            return false;
         }
         if(!this.testDerivedAxis(_loc3_,_loc4_,this.naruqe,this.gizy,this.tupanamer))
         {
            return false;
         }
         if(!this.testDerivedAxis(_loc3_,_loc4_,this.naruqe,this.vas,this.tupanamer))
         {
            return false;
         }
         return true;
      }
      
      private function testMainAxis(param1:CollisionBox, param2:CollisionRect, param3:Vector3, param4:Vector3) : Boolean
      {
         var _loc5_:Number = this.getOverlapOnAxis(param1,param2,param3,param4);
         return this.registerOverlap(_loc5_,param3);
      }
      
      private function testDerivedAxis(param1:CollisionBox, param2:CollisionRect, param3:Vector3, param4:Vector3, param5:Vector3) : Boolean
      {
         var _loc7_:Number = NaN;
         this.nydyfi.x = param3.y * param4.z - param3.z * param4.y;
         this.nydyfi.y = param3.z * param4.x - param3.x * param4.z;
         this.nydyfi.z = param3.x * param4.y - param3.y * param4.x;
         var _loc6_:Number = this.nydyfi.x * this.nydyfi.x + this.nydyfi.y * this.nydyfi.y + this.nydyfi.z * this.nydyfi.z;
         if(_loc6_ < 1e-10)
         {
            return true;
         }
         _loc7_ = 1 / Math.sqrt(_loc6_);
         this.nydyfi.x *= _loc7_;
         this.nydyfi.y *= _loc7_;
         this.nydyfi.z *= _loc7_;
         var _loc8_:Number = this.getOverlapOnAxis(param1,param2,this.nydyfi,param5);
         return this.registerOverlap(_loc8_,this.nydyfi);
      }
      
      private function getOverlapOnAxis(param1:CollisionBox, param2:CollisionRect, param3:Vector3, param4:Vector3) : Number
      {
         var _loc5_:Matrix4 = param1.wet;
         var _loc6_:Number = (_loc5_.gusat * param3.x + _loc5_.sig * param3.y + _loc5_.vug * param3.z) * param1.nezav.x;
         if(_loc6_ < 0)
         {
            _loc6_ = -_loc6_;
         }
         var _loc7_:Number = _loc6_;
         _loc6_ = (_loc5_.cydop * param3.x + _loc5_.qanezycap * param3.y + _loc5_.luwym * param3.z) * param1.nezav.y;
         if(_loc6_ < 0)
         {
            _loc6_ = -_loc6_;
         }
         _loc7_ += _loc6_;
         _loc6_ = (_loc5_.sivy * param3.x + _loc5_.wyvukog * param3.y + _loc5_.tari * param3.z) * param1.nezav.z;
         if(_loc6_ < 0)
         {
            _loc6_ = -_loc6_;
         }
         _loc7_ += _loc6_;
         _loc5_ = param2.wet;
         _loc6_ = (_loc5_.gusat * param3.x + _loc5_.sig * param3.y + _loc5_.vug * param3.z) * param2.nezav.x;
         if(_loc6_ < 0)
         {
            _loc6_ = -_loc6_;
         }
         _loc7_ += _loc6_;
         _loc6_ = (_loc5_.cydop * param3.x + _loc5_.qanezycap * param3.y + _loc5_.luwym * param3.z) * param2.nezav.y;
         if(_loc6_ < 0)
         {
            _loc6_ = -_loc6_;
         }
         _loc7_ += _loc6_;
         _loc6_ = param4.x * param3.x + param4.y * param3.y + param4.z * param3.z;
         if(_loc6_ < 0)
         {
            _loc6_ = -_loc6_;
         }
         return _loc7_ - _loc6_;
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
      
      private function findContacts(param1:CollisionBox, param2:CollisionRect, param3:Vector3, param4:Vector.<ShapeContact>) : void
      {
         var _loc5_:Matrix4 = null;
         var _loc12_:ShapeContact = null;
         var _loc13_:Vector3 = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         _loc5_ = param1.wet;
         var _loc6_:Matrix4 = param2.wet;
         var _loc7_:Vector3 = this.tupanamer;
         _loc7_.x = _loc5_.kyvuru - _loc6_.kyvuru;
         _loc7_.y = _loc5_.zumidynip - _loc6_.zumidynip;
         _loc7_.z = _loc5_.sunafepo - _loc6_.sunafepo;
         if(param3.x * _loc7_.x + param3.y * _loc7_.y + param3.z * _loc7_.z < 0)
         {
            param3.x = -param3.x;
            param3.y = -param3.y;
            param3.z = -param3.z;
         }
         var _loc8_:Matrix4 = labisiqyg;
         ColliderUtils.buildContactBasis(param3,_loc5_,_loc6_,_loc8_);
         ColliderUtils.getBoxFaceVerticesInCCWOrder(param1,param3,FaceSide.puwizi,zihuta);
         ColliderUtils.getRectFaceInCCWOrder(param2,param3,kifulylem);
         ColliderUtils.transformFaceToReferenceSpace(_loc8_,_loc5_,zihuta,4);
         ColliderUtils.transformFaceToReferenceSpace(_loc8_,_loc6_,kifulylem,4);
         var _loc9_:int = int(param4.length);
         PolygonsIntersectionUtils.findContacts(param1,zihuta,4,param2,kifulylem,4,_loc8_,param4);
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
            else if(Math.abs(_loc6_.tari) > 0.999)
            {
               _loc13_.x = _loc14_;
               _loc13_.y = _loc15_;
               _loc13_.z = _loc16_;
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

