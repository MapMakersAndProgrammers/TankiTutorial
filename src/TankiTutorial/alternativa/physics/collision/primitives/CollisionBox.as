package alternativa.physics.collision.primitives
{
   import alternativa.physics.PhysicsMaterial;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix4;
   import alternativa.physics.collision.types.AABB;
   import alternativa.physics.collision.CollisionShape;
   
   public class CollisionBox extends CollisionShape
   {
      
      public var nezav:Vector3 = new Vector3();
      
      public function CollisionBox(param1:Vector3, param2:int, param3:PhysicsMaterial)
      {
         super(jupod,param2,param3);
         this.nezav.copy(param1);
      }
      
      override public function calculateAABB() : AABB
      {
         var _loc1_:Matrix4 = null;
         var _loc2_:AABB = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc1_ = wet;
         _loc2_ = this.raruluk;
         _loc3_ = _loc1_.ma < 0 ? -_loc1_.ma : Number(_loc1_.ma);
         _loc4_ = _loc1_.mb < 0 ? -_loc1_.mb : Number(_loc1_.mb);
         _loc5_ = _loc1_.mc < 0 ? -_loc1_.mc : Number(_loc1_.mc);
         _loc2_.jys = this.nezav.x * _loc3_ + this.nezav.y * _loc4_ + this.nezav.z * _loc5_;
         _loc2_.cubegyw = -_loc2_.jys;
         _loc3_ = _loc1_.me < 0 ? -_loc1_.me : Number(_loc1_.me);
         _loc4_ = _loc1_.mf < 0 ? -_loc1_.mf : Number(_loc1_.mf);
         _loc5_ = _loc1_.mg < 0 ? -_loc1_.mg : Number(_loc1_.mg);
         _loc2_.juri = this.nezav.x * _loc3_ + this.nezav.y * _loc4_ + this.nezav.z * _loc5_;
         _loc2_.nicomosa = -_loc2_.juri;
         _loc3_ = _loc1_.mi < 0 ? -_loc1_.mi : Number(_loc1_.mi);
         _loc4_ = _loc1_.mj < 0 ? -_loc1_.mj : Number(_loc1_.mj);
         _loc5_ = _loc1_.mk < 0 ? -_loc1_.mk : Number(_loc1_.mk);
         _loc2_.zepoci = this.nezav.x * _loc3_ + this.nezav.y * _loc4_ + this.nezav.z * _loc5_;
         _loc2_.gesuwi = -_loc2_.zepoci;
         _loc2_.cubegyw += _loc1_.md;
         _loc2_.jys += _loc1_.md;
         _loc2_.nicomosa += _loc1_.mh;
         _loc2_.juri += _loc1_.mh;
         _loc2_.gesuwi += _loc1_.ml;
         _loc2_.zepoci += _loc1_.ml;
         return _loc2_;
      }
      
      override public function copyFrom(param1:CollisionShape) : CollisionShape
      {
         var _loc2_:CollisionBox = param1 as CollisionBox;
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
         return new CollisionBox(this.nezav,nute,material);
      }
      
      override public function raycast(param1:Vector3, param2:Vector3, param3:Number, param4:Vector3) : Number
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc5_:Matrix4 = this.wet;
         var _loc6_:Number = -1;
         var _loc7_:Number = 1e+308;
         var _loc10_:Number = param1.x - _loc5_.md;
         var _loc11_:Number = param1.y - _loc5_.mh;
         var _loc12_:Number = param1.z - _loc5_.ml;
         var _loc13_:Number = _loc5_.ma * _loc10_ + _loc5_.me * _loc11_ + _loc5_.mi * _loc12_;
         var _loc14_:Number = _loc5_.mb * _loc10_ + _loc5_.mf * _loc11_ + _loc5_.mj * _loc12_;
         var _loc15_:Number = _loc5_.mc * _loc10_ + _loc5_.mg * _loc11_ + _loc5_.mk * _loc12_;
         _loc10_ = _loc5_.ma * param2.x + _loc5_.me * param2.y + _loc5_.mi * param2.z;
         _loc11_ = _loc5_.mb * param2.x + _loc5_.mf * param2.y + _loc5_.mj * param2.z;
         _loc12_ = _loc5_.mc * param2.x + _loc5_.mg * param2.y + _loc5_.mk * param2.z;
         if(_loc10_ < param3 && _loc10_ > -param3)
         {
            if(_loc13_ < -this.nezav.x || _loc13_ > this.nezav.x)
            {
               return -1;
            }
         }
         else
         {
            _loc8_ = (-this.nezav.x - _loc13_) / _loc10_;
            _loc9_ = (this.nezav.x - _loc13_) / _loc10_;
            if(_loc8_ < _loc9_)
            {
               if(_loc8_ > _loc6_)
               {
                  _loc6_ = _loc8_;
                  param4.x = -1;
                  param4.y = param4.z = 0;
               }
               if(_loc9_ < _loc7_)
               {
                  _loc7_ = _loc9_;
               }
            }
            else
            {
               if(_loc9_ > _loc6_)
               {
                  _loc6_ = _loc9_;
                  param4.x = 1;
                  param4.y = param4.z = 0;
               }
               if(_loc8_ < _loc7_)
               {
                  _loc7_ = _loc8_;
               }
            }
            if(_loc7_ < _loc6_)
            {
               return -1;
            }
         }
         if(_loc11_ < param3 && _loc11_ > -param3)
         {
            if(_loc14_ < -this.nezav.y || _loc14_ > this.nezav.y)
            {
               return -1;
            }
         }
         else
         {
            _loc8_ = (-this.nezav.y - _loc14_) / _loc11_;
            _loc9_ = (this.nezav.y - _loc14_) / _loc11_;
            if(_loc8_ < _loc9_)
            {
               if(_loc8_ > _loc6_)
               {
                  _loc6_ = _loc8_;
                  param4.y = -1;
                  param4.x = param4.z = 0;
               }
               if(_loc9_ < _loc7_)
               {
                  _loc7_ = _loc9_;
               }
            }
            else
            {
               if(_loc9_ > _loc6_)
               {
                  _loc6_ = _loc9_;
                  param4.y = 1;
                  param4.x = param4.z = 0;
               }
               if(_loc8_ < _loc7_)
               {
                  _loc7_ = _loc8_;
               }
            }
            if(_loc7_ < _loc6_)
            {
               return -1;
            }
         }
         if(_loc12_ < param3 && _loc12_ > -param3)
         {
            if(_loc15_ < -this.nezav.z || _loc15_ > this.nezav.z)
            {
               return -1;
            }
         }
         else
         {
            _loc8_ = (-this.nezav.z - _loc15_) / _loc12_;
            _loc9_ = (this.nezav.z - _loc15_) / _loc12_;
            if(_loc8_ < _loc9_)
            {
               if(_loc8_ > _loc6_)
               {
                  _loc6_ = _loc8_;
                  param4.z = -1;
                  param4.x = param4.y = 0;
               }
               if(_loc9_ < _loc7_)
               {
                  _loc7_ = _loc9_;
               }
            }
            else
            {
               if(_loc9_ > _loc6_)
               {
                  _loc6_ = _loc9_;
                  param4.z = 1;
                  param4.x = param4.y = 0;
               }
               if(_loc8_ < _loc7_)
               {
                  _loc7_ = _loc8_;
               }
            }
            if(_loc7_ < _loc6_)
            {
               return -1;
            }
         }
         _loc10_ = Number(param4.x);
         _loc11_ = Number(param4.y);
         _loc12_ = Number(param4.z);
         param4.x = _loc5_.ma * _loc10_ + _loc5_.mb * _loc11_ + _loc5_.mc * _loc12_;
         param4.y = _loc5_.me * _loc10_ + _loc5_.mf * _loc11_ + _loc5_.mg * _loc12_;
         param4.z = _loc5_.mi * _loc10_ + _loc5_.mj * _loc11_ + _loc5_.mk * _loc12_;
         return _loc6_;
      }
   }
}

