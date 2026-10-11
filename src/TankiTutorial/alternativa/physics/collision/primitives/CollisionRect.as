package alternativa.physics.collision.primitives
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.types.AABB;
   
   public class CollisionRect extends CollisionShape
   {
      
      private static const nabyjyge:Number = 0.005;
      
      public var nezav:Vector3 = new Vector3();
      
      public function CollisionRect(param1:Vector3, param2:int, param3:PhysicsMaterial)
      {
         super(hosomubeb,param2,param3);
         this.nezav.copy(param1);
      }
      
      override public function calculateAABB() : AABB
      {
         var _loc1_:Matrix4 = null;
         _loc1_ = wet;
         var _loc2_:Number = _loc1_.ma < 0 ? -_loc1_.ma : _loc1_.ma;
         var _loc3_:Number = _loc1_.mb < 0 ? -_loc1_.mb : _loc1_.mb;
         var _loc4_:Number = _loc1_.mc < 0 ? -_loc1_.mc : _loc1_.mc;
         var _loc5_:AABB = this.raruluk;
         _loc5_.jys = this.nezav.x * _loc2_ + this.nezav.y * _loc3_ + nabyjyge * _loc4_;
         _loc5_.cubegyw = -_loc5_.jys;
         _loc2_ = _loc1_.me < 0 ? -_loc1_.me : _loc1_.me;
         _loc3_ = _loc1_.mf < 0 ? -_loc1_.mf : _loc1_.mf;
         _loc4_ = _loc1_.mg < 0 ? -_loc1_.mg : _loc1_.mg;
         _loc5_.juri = this.nezav.x * _loc2_ + this.nezav.y * _loc3_ + nabyjyge * _loc4_;
         _loc5_.nicomosa = -_loc5_.juri;
         _loc2_ = _loc1_.mi < 0 ? -_loc1_.mi : _loc1_.mi;
         _loc3_ = _loc1_.mj < 0 ? -_loc1_.mj : _loc1_.mj;
         _loc4_ = _loc1_.mk < 0 ? -_loc1_.mk : _loc1_.mk;
         _loc5_.zepoci = this.nezav.x * _loc2_ + this.nezav.y * _loc3_ + nabyjyge * _loc4_;
         _loc5_.gesuwi = -_loc5_.zepoci;
         _loc5_.cubegyw += _loc1_.md;
         _loc5_.jys += _loc1_.md;
         _loc5_.nicomosa += _loc1_.mh;
         _loc5_.juri += _loc1_.mh;
         _loc5_.gesuwi += _loc1_.ml;
         _loc5_.zepoci += _loc1_.ml;
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
         var _loc6_:Number = param1.x - _loc5_.md;
         var _loc7_:Number = param1.y - _loc5_.mh;
         var _loc8_:Number = param1.z - _loc5_.ml;
         var _loc9_:Number = _loc5_.ma * _loc6_ + _loc5_.me * _loc7_ + _loc5_.mi * _loc8_;
         var _loc10_:Number = _loc5_.mb * _loc6_ + _loc5_.mf * _loc7_ + _loc5_.mj * _loc8_;
         var _loc11_:Number = _loc5_.mc * _loc6_ + _loc5_.mg * _loc7_ + _loc5_.mk * _loc8_;
         _loc6_ = _loc5_.ma * param2.x + _loc5_.me * param2.y + _loc5_.mi * param2.z;
         _loc7_ = _loc5_.mb * param2.x + _loc5_.mf * param2.y + _loc5_.mj * param2.z;
         _loc8_ = _loc5_.mc * param2.x + _loc5_.mg * param2.y + _loc5_.mk * param2.z;
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
         if(param2.x * _loc5_.mc + param2.y * _loc5_.mg + param2.z * _loc5_.mk > 0)
         {
            param4.x = -_loc5_.mc;
            param4.y = -_loc5_.mg;
            param4.z = -_loc5_.mk;
         }
         else
         {
            param4.x = _loc5_.mc;
            param4.y = _loc5_.mg;
            param4.z = _loc5_.mk;
         }
         return _loc12_;
      }
   }
}

