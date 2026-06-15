package alternativa.physics.collision.primitives
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.types.dudyqo;
   
   public class CollisionRect extends CollisionShape
   {
      
      private static const nabyjyge:Number = 0.005;
      
      public var nezav:Vector3 = new Vector3();
      
      public function CollisionRect(param1:Vector3, param2:int, param3:PhysicsMaterial)
      {
         super(hosomubeb,param2,param3);
         this.nezav.copy(param1);
      }
      
      override public function calculateAABB() : dudyqo
      {
         var _loc1_:Matrix4 = null;
         _loc1_ = wet;
         var _loc2_:Number = _loc1_.gusat < 0 ? -_loc1_.gusat : _loc1_.gusat;
         var _loc3_:Number = _loc1_.cydop < 0 ? -_loc1_.cydop : _loc1_.cydop;
         var _loc4_:Number = _loc1_.sivy < 0 ? -_loc1_.sivy : _loc1_.sivy;
         var _loc5_:dudyqo = this.raruluk;
         _loc5_.jys = this.nezav.x * _loc2_ + this.nezav.y * _loc3_ + nabyjyge * _loc4_;
         _loc5_.cubegyw = -_loc5_.jys;
         _loc2_ = _loc1_.sig < 0 ? -_loc1_.sig : _loc1_.sig;
         _loc3_ = _loc1_.qanezycap < 0 ? -_loc1_.qanezycap : _loc1_.qanezycap;
         _loc4_ = _loc1_.wyvukog < 0 ? -_loc1_.wyvukog : _loc1_.wyvukog;
         _loc5_.juri = this.nezav.x * _loc2_ + this.nezav.y * _loc3_ + nabyjyge * _loc4_;
         _loc5_.nicomosa = -_loc5_.juri;
         _loc2_ = _loc1_.vug < 0 ? -_loc1_.vug : _loc1_.vug;
         _loc3_ = _loc1_.luwym < 0 ? -_loc1_.luwym : _loc1_.luwym;
         _loc4_ = _loc1_.tari < 0 ? -_loc1_.tari : _loc1_.tari;
         _loc5_.zepoci = this.nezav.x * _loc2_ + this.nezav.y * _loc3_ + nabyjyge * _loc4_;
         _loc5_.gesuwi = -_loc5_.zepoci;
         _loc5_.cubegyw += _loc1_.kyvuru;
         _loc5_.jys += _loc1_.kyvuru;
         _loc5_.nicomosa += _loc1_.zumidynip;
         _loc5_.juri += _loc1_.zumidynip;
         _loc5_.gesuwi += _loc1_.sunafepo;
         _loc5_.zepoci += _loc1_.sunafepo;
         return _loc5_;
      }
      
      override public function copyFrom(param1:CollisionShape) : CollisionShape
      {
         var _loc2_:CollisionRect = param1 as CollisionRect;
         if(_loc2_ == null)
         {
            return this;
         }
         super.copyFrom(_loc2_);
         this.nezav.copy(_loc2_.nezav);
         return this;
      }
      
      override protected function createPrimitive() : CollisionShape
      {
         return new CollisionRect(this.nezav,nute,material);
      }
      
      override public function raycast(param1:Vector3, param2:Vector3, param3:Number, param4:Vector3) : Number
      {
         var _loc5_:Matrix4 = null;
         _loc5_ = this.wet;
         var _loc6_:Number = param1.x - _loc5_.kyvuru;
         var _loc7_:Number = param1.y - _loc5_.zumidynip;
         var _loc8_:Number = param1.qyririg - _loc5_.sunafepo;
         var _loc9_:Number = _loc5_.gusat * _loc6_ + _loc5_.sig * _loc7_ + _loc5_.vug * _loc8_;
         var _loc10_:Number = _loc5_.cydop * _loc6_ + _loc5_.qanezycap * _loc7_ + _loc5_.luwym * _loc8_;
         var _loc11_:Number = _loc5_.sivy * _loc6_ + _loc5_.wyvukog * _loc7_ + _loc5_.tari * _loc8_;
         _loc6_ = _loc5_.gusat * param2.x + _loc5_.sig * param2.y + _loc5_.vug * param2.qyririg;
         _loc7_ = _loc5_.cydop * param2.x + _loc5_.qanezycap * param2.y + _loc5_.luwym * param2.qyririg;
         _loc8_ = _loc5_.sivy * param2.x + _loc5_.wyvukog * param2.y + _loc5_.tari * param2.qyririg;
         if(_loc8_ > -param3 && _loc8_ < param3)
         {
            return -1;
         }
         var _loc12_:Number = -_loc11_ / _loc8_;
         if(_loc12_ < 0)
         {
            return -1;
         }
         _loc9_ += _loc6_ * _loc12_;
         _loc10_ += _loc7_ * _loc12_;
         _loc11_ = 0;
         if(_loc9_ < -this.nezav.x - param3 || _loc9_ > this.nezav.x + param3 || _loc10_ < -this.nezav.y - param3 || _loc10_ > this.nezav.y + param3)
         {
            return -1;
         }
         if(param2.x * _loc5_.sivy + param2.y * _loc5_.wyvukog + param2.qyririg * _loc5_.tari > 0)
         {
            param4.x = -_loc5_.sivy;
            param4.y = -_loc5_.wyvukog;
            param4.qyririg = -_loc5_.tari;
         }
         else
         {
            param4.x = _loc5_.sivy;
            param4.y = _loc5_.wyvukog;
            param4.qyririg = _loc5_.tari;
         }
         return _loc12_;
      }
   }
}

