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
      
      private static const nydyfi:Vector3 = new Vector3();
      
      private static const ryhotibu:Vector3 = new Vector3();
      
      private static const burive:Vector3 = new Vector3();
      
      private static const sen:Vector3 = new Vector3();
      
      private static const mewozeba:Vector3 = new Vector3();
      
      private static const wecekesy:Vector3 = new Vector3();
      
      private static const kuk:Vector3 = new Vector3();
      
      private static const tupanamer:Vector3 = new Vector3();
      
      private static const qotu:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex(),new Vertex()]);
      
      private static const huveluwe:Vector.<Vertex> = Vector.<Vertex>([new Vertex(),new Vertex(),new Vertex(),new Vertex()]);
      
      private static const labisiqyg:Matrix4 = new Matrix4();
      
      private var kurymyf:Number;
      
      private const seko:Vector3 = new Vector3();
      
      private var jicywos:Number;
      
      public function BoxBoxCollider(param1:Number)
      {
         super();
         this.kurymyf = param1;
      }
      
      public function getContacts(param1:CollisionShape, param2:CollisionShape, param3:Vector.<ShapeContact>) : void
      {
         var _loc4_:CollisionBox = null;
         var _loc5_:CollisionBox = null;
         if(this.haveCollision(param1,param2))
         {
            _loc4_ = CollisionBox(param1);
            _loc5_ = CollisionBox(param2);
            this.findContacts(_loc4_,_loc5_,this.seko,param3);
         }
      }
      
      public function haveCollision(param1:CollisionShape, param2:CollisionShape) : Boolean
      {
         var _loc3_:CollisionBox = null;
         var _loc5_:Matrix4 = null;
         var _loc7_:Vector3 = null;
         this.jicywos = 10000000000;
         _loc3_ = CollisionBox(param1);
         var _loc4_:CollisionBox = CollisionBox(param2);
         _loc5_ = _loc3_.wet;
         var _loc6_:Matrix4 = _loc4_.wet;
         _loc7_ = tupanamer;
         _loc7_.x = _loc5_.kyvuru - _loc6_.kyvuru;
         _loc7_.y = _loc5_.zumidynip - _loc6_.zumidynip;
         _loc7_.z = _loc5_.sunafepo - _loc6_.sunafepo;
         ryhotibu.x = _loc5_.gusat;
         ryhotibu.y = _loc5_.sig;
         ryhotibu.z = _loc5_.vug;
         if(!this.testOverlapOnMainAxis(_loc3_,_loc4_,ryhotibu,_loc7_))
         {
            return false;
         }
         burive.x = _loc5_.cydop;
         burive.y = _loc5_.qanezycap;
         burive.z = _loc5_.luwym;
         if(!this.testOverlapOnMainAxis(_loc3_,_loc4_,burive,_loc7_))
         {
            return false;
         }
         sen.x = _loc5_.sivy;
         sen.y = _loc5_.wyvukog;
         sen.z = _loc5_.tari;
         if(!this.testOverlapOnMainAxis(_loc3_,_loc4_,sen,_loc7_))
         {
            return false;
         }
         mewozeba.x = _loc6_.gusat;
         mewozeba.y = _loc6_.sig;
         mewozeba.z = _loc6_.vug;
         if(!this.testOverlapOnMainAxis(_loc3_,_loc4_,mewozeba,_loc7_))
         {
            return false;
         }
         wecekesy.x = _loc6_.cydop;
         wecekesy.y = _loc6_.qanezycap;
         wecekesy.z = _loc6_.luwym;
         if(!this.testOverlapOnMainAxis(_loc3_,_loc4_,wecekesy,_loc7_))
         {
            return false;
         }
         kuk.x = _loc6_.sivy;
         kuk.y = _loc6_.wyvukog;
         kuk.z = _loc6_.tari;
         if(!this.testOverlapOnMainAxis(_loc3_,_loc4_,kuk,_loc7_))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc3_,_loc4_,ryhotibu,mewozeba,_loc7_))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc3_,_loc4_,ryhotibu,wecekesy,_loc7_))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc3_,_loc4_,ryhotibu,kuk,_loc7_))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc3_,_loc4_,burive,mewozeba,_loc7_))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc3_,_loc4_,burive,wecekesy,_loc7_))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc3_,_loc4_,burive,kuk,_loc7_))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc3_,_loc4_,sen,mewozeba,_loc7_))
         {
            return false;
         }
         if(!this.testOverlapOnDerivedAxis(_loc3_,_loc4_,sen,wecekesy,_loc7_))
         {
            return false;
         }
         return this.testOverlapOnDerivedAxis(_loc3_,_loc4_,sen,kuk,_loc7_);
      }
      
      private function testOverlapOnMainAxis(param1:CollisionBox, param2:CollisionBox, param3:Vector3, param4:Vector3) : Boolean
      {
         var _loc5_:Number = this.getOverlapOnAxis(param1,param2,param3,param4);
         return this.registerOverlap(_loc5_,param3);
      }
      
      private function testOverlapOnDerivedAxis(param1:CollisionBox, param2:CollisionBox, param3:Vector3, param4:Vector3, param5:Vector3) : Boolean
      {
         var _loc6_:Vector3 = null;
         var _loc8_:Number = NaN;
         _loc6_ = nydyfi;
         _loc6_.x = param3.y * param4.z - param3.z * param4.y;
         _loc6_.y = param3.z * param4.x - param3.x * param4.z;
         _loc6_.z = param3.x * param4.y - param3.y * param4.x;
         var _loc7_:Number = _loc6_.x * _loc6_.x + _loc6_.y * _loc6_.y + _loc6_.z * _loc6_.z;
         if(_loc7_ < 1e-10)
         {
            return true;
         }
         _loc8_ = 1 / Math.sqrt(_loc7_);
         _loc6_.x *= _loc8_;
         _loc6_.y *= _loc8_;
         _loc6_.z *= _loc8_;
         var _loc9_:Number = this.getOverlapOnAxis(param1,param2,_loc6_,param5);
         return this.registerOverlap(_loc9_,_loc6_);
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
      
      public function getOverlapOnAxis(param1:CollisionBox, param2:CollisionBox, param3:Vector3, param4:Vector3) : Number
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
         _loc6_ = (_loc5_.sivy * param3.x + _loc5_.wyvukog * param3.y + _loc5_.tari * param3.z) * param2.nezav.z;
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
      
      private function findContacts(param1:CollisionBox, param2:CollisionBox, param3:Vector3, param4:Vector.<ShapeContact>) : void
      {
         var _loc5_:Matrix4 = param1.wet;
         var _loc6_:Matrix4 = param2.wet;
         var _loc7_:Vector3 = tupanamer;
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
         ColliderUtils.getBoxFaceVerticesInCCWOrder(param1,param3,FaceSide.puwizi,qotu);
         ColliderUtils.getBoxFaceVerticesInCCWOrder(param2,param3,FaceSide.lylyrakem,huveluwe);
         ColliderUtils.transformFaceToReferenceSpace(_loc8_,param1.wet,qotu,4);
         ColliderUtils.transformFaceToReferenceSpace(_loc8_,param2.wet,huveluwe,4);
         PolygonsIntersectionUtils.findContacts(param1,qotu,4,param2,huveluwe,4,_loc8_,param4);
      }
   }
}

