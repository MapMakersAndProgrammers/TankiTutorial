package alternativa.physics.collision.colliders
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.primitives.CollisionRect;
   import alternativa.physics.collision.primitives.CollisionTriangle;
   import alternativa.physics.collision.primitives.CollisionBox;
   
   public class ColliderUtils
   {
      
      private static const vuw:Vector3 = new Vector3();
      
      private static const koq:Vector3 = new Vector3();
      
      public function ColliderUtils()
      {
         super();
      }
      
      public static function buildContactBasis(param1:Vector3, param2:Matrix4, param3:Matrix4, param4:Matrix4) : void
      {
         var _loc5_:Vector3 = vuw;
         var _loc6_:Vector3 = koq;
         if(Math.abs(param1.x) < Math.abs(param1.y))
         {
            _loc5_.x = 0;
            _loc5_.y = param1.z;
            _loc5_.z = -param1.y;
         }
         else
         {
            _loc5_.x = -param1.z;
            _loc5_.y = 0;
            _loc5_.z = param1.x;
         }
         _loc5_.normalize();
         _loc6_.x = param1.y * _loc5_.z - param1.z * _loc5_.y;
         _loc6_.y = param1.z * _loc5_.x - param1.x * _loc5_.z;
         _loc6_.z = param1.x * _loc5_.y - param1.y * _loc5_.x;
         param4.gusat = _loc5_.x;
         param4.sig = _loc5_.y;
         param4.vug = _loc5_.z;
         param4.cydop = _loc6_.x;
         param4.qanezycap = _loc6_.y;
         param4.luwym = _loc6_.z;
         param4.sivy = param1.x;
         param4.wyvukog = param1.y;
         param4.tari = param1.z;
      }
      
      public static function transformFaceToReferenceSpace(param1:Matrix4, param2:Matrix4, param3:Vector.<Vertex>, param4:int) : void
      {
         var _loc6_:Vertex = null;
         var _loc5_:int = 0;
         while(_loc5_ < param4)
         {
            _loc6_ = param3[_loc5_];
            param2.transformVector(_loc6_.vam,_loc6_.bap);
            param1.transformVectorInverse(_loc6_.bap,_loc6_.cujeqo);
            _loc5_++;
         }
      }
      
      public static function getBoxFaceVerticesInCCWOrder(param1:CollisionBox, param2:Vector3, param3:FaceSide, param4:Vector.<Vertex>) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Vector3 = null;
         var _loc16_:Vector3 = null;
         var _loc17_:Vertex = null;
         var _loc5_:Matrix4 = param1.wet;
         var _loc6_:int = 0;
         _loc11_ = _loc5_.gusat;
         _loc12_ = _loc5_.sig;
         _loc13_ = _loc5_.vug;
         _loc7_ = _loc11_ * param2.x + _loc12_ * param2.y + _loc13_ * param2.z;
         _loc8_ = Math.abs(_loc7_);
         _loc11_ = _loc5_.cydop;
         _loc12_ = _loc5_.qanezycap;
         _loc13_ = _loc5_.luwym;
         _loc10_ = _loc11_ * param2.x + _loc12_ * param2.y + _loc13_ * param2.z;
         _loc9_ = Math.abs(_loc10_);
         if(_loc9_ > _loc8_)
         {
            _loc8_ = _loc9_;
            _loc7_ = _loc10_;
            _loc6_ = 1;
         }
         _loc11_ = _loc5_.sivy;
         _loc12_ = _loc5_.wyvukog;
         _loc13_ = _loc5_.tari;
         _loc10_ = _loc11_ * param2.x + _loc12_ * param2.y + _loc13_ * param2.z;
         _loc9_ = Math.abs(_loc10_);
         if(_loc9_ > _loc8_)
         {
            _loc7_ = _loc10_;
            _loc6_ = 2;
         }
         _loc14_ = _loc7_ > 0 ? 1 : -1;
         if(param3 == FaceSide.puwizi)
         {
            _loc14_ = -_loc14_;
         }
         _loc16_ = param1.nezav;
         switch(_loc6_)
         {
            case 0:
               _loc15_ = Vertex(param4[0]).vam;
               _loc15_.x = _loc14_ * _loc16_.x;
               _loc15_.y = _loc16_.y;
               _loc15_.z = _loc16_.z;
               _loc15_ = Vertex(param4[1]).vam;
               _loc15_.x = _loc14_ * _loc16_.x;
               _loc15_.y = -_loc16_.y;
               _loc15_.z = _loc16_.z;
               _loc15_ = Vertex(param4[2]).vam;
               _loc15_.x = _loc14_ * _loc16_.x;
               _loc15_.y = -_loc16_.y;
               _loc15_.z = -_loc16_.z;
               _loc15_ = Vertex(param4[3]).vam;
               _loc15_.x = _loc14_ * _loc16_.x;
               _loc15_.y = _loc16_.y;
               _loc15_.z = -_loc16_.z;
               break;
            case 1:
               _loc15_ = Vertex(param4[0]).vam;
               _loc15_.x = _loc16_.x;
               _loc15_.y = _loc14_ * _loc16_.y;
               _loc15_.z = _loc16_.z;
               _loc15_ = Vertex(param4[1]).vam;
               _loc15_.x = _loc16_.x;
               _loc15_.y = _loc14_ * _loc16_.y;
               _loc15_.z = -_loc16_.z;
               _loc15_ = Vertex(param4[2]).vam;
               _loc15_.x = -_loc16_.x;
               _loc15_.y = _loc14_ * _loc16_.y;
               _loc15_.z = -_loc16_.z;
               _loc15_ = Vertex(param4[3]).vam;
               _loc15_.x = -_loc16_.x;
               _loc15_.y = _loc14_ * _loc16_.y;
               _loc15_.z = _loc16_.z;
               break;
            case 2:
               _loc15_ = Vertex(param4[0]).vam;
               _loc15_.x = _loc16_.x;
               _loc15_.y = _loc16_.y;
               _loc15_.z = _loc14_ * _loc16_.z;
               _loc15_ = Vertex(param4[1]).vam;
               _loc15_.x = -_loc16_.x;
               _loc15_.y = _loc16_.y;
               _loc15_.z = _loc14_ * _loc16_.z;
               _loc15_ = Vertex(param4[2]).vam;
               _loc15_.x = -_loc16_.x;
               _loc15_.y = -_loc16_.y;
               _loc15_.z = _loc14_ * _loc16_.z;
               _loc15_ = Vertex(param4[3]).vam;
               _loc15_.x = _loc16_.x;
               _loc15_.y = -_loc16_.y;
               _loc15_.z = _loc14_ * _loc16_.z;
               break;
            default:
               throw new Error();
         }
         if(_loc7_ < 0)
         {
            _loc17_ = param4[0];
            param4[0] = param4[3];
            param4[3] = _loc17_;
            _loc17_ = param4[1];
            param4[1] = param4[2];
            param4[2] = _loc17_;
         }
      }
      
      public static function getRectFaceInCCWOrder(param1:CollisionRect, param2:Vector3, param3:Vector.<Vertex>) : void
      {
         var _loc5_:Vertex = null;
         var _loc4_:Vector3 = param1.nezav;
         _loc5_ = param3[0];
         _loc5_.vam.x = _loc4_.x;
         _loc5_.vam.y = _loc4_.y;
         _loc5_.vam.z = 0;
         _loc5_ = param3[1];
         _loc5_.vam.x = -_loc4_.x;
         _loc5_.vam.y = _loc4_.y;
         _loc5_.vam.z = 0;
         _loc5_ = param3[2];
         _loc5_.vam.x = -_loc4_.x;
         _loc5_.vam.y = -_loc4_.y;
         _loc5_.vam.z = 0;
         _loc5_ = param3[3];
         _loc5_.vam.x = _loc4_.x;
         _loc5_.vam.y = -_loc4_.y;
         _loc5_.vam.z = 0;
         var _loc6_:Matrix4 = param1.wet;
         var _loc7_:Number = param2.x * _loc6_.sivy + param2.y * _loc6_.wyvukog + param2.z * _loc6_.tari;
         if(_loc7_ < 0)
         {
            _loc5_ = param3[0];
            param3[0] = param3[3];
            param3[3] = _loc5_;
            _loc5_ = param3[1];
            param3[1] = param3[2];
            param3[2] = _loc5_;
         }
      }
      
      public static function getTriangleFaceInCCWOrder(param1:CollisionTriangle, param2:Vector3, param3:Vector.<Vertex>) : void
      {
         var _loc4_:Vertex = null;
         _loc4_ = param3[0];
         _loc4_.vam.x = param1.lyzud.x;
         _loc4_.vam.y = param1.lyzud.y;
         _loc4_.vam.z = 0;
         _loc4_ = param3[1];
         _loc4_.vam.x = param1.pedake.x;
         _loc4_.vam.y = param1.pedake.y;
         _loc4_.vam.z = 0;
         _loc4_ = param3[2];
         _loc4_.vam.x = param1.bykecy.x;
         _loc4_.vam.y = param1.bykecy.y;
         _loc4_.vam.z = 0;
         var _loc5_:Matrix4 = param1.wet;
         var _loc6_:Number = param2.x * _loc5_.sivy + param2.y * _loc5_.wyvukog + param2.z * _loc5_.tari;
         if(_loc6_ < 0)
         {
            _loc4_ = param3[0];
            param3[0] = param3[2];
            param3[2] = _loc4_;
         }
      }
   }
}

