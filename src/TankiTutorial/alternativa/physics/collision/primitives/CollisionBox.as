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
         _loc3_ = _loc1_.gusat < 0 ? -_loc1_.gusat : Number(_loc1_.gusat);
         _loc4_ = _loc1_.cydop < 0 ? -_loc1_.cydop : Number(_loc1_.cydop);
         _loc5_ = _loc1_.sivy < 0 ? -_loc1_.sivy : Number(_loc1_.sivy);
         _loc2_.jys = this.nezav.x * _loc3_ + this.nezav.y * _loc4_ + this.nezav.z * _loc5_;
         _loc2_.cubegyw = -_loc2_.jys;
         _loc3_ = _loc1_.sig < 0 ? -_loc1_.sig : Number(_loc1_.sig);
         _loc4_ = _loc1_.qanezycap < 0 ? -_loc1_.qanezycap : Number(_loc1_.qanezycap);
         _loc5_ = _loc1_.wyvukog < 0 ? -_loc1_.wyvukog : Number(_loc1_.wyvukog);
         _loc2_.juri = this.nezav.x * _loc3_ + this.nezav.y * _loc4_ + this.nezav.z * _loc5_;
         _loc2_.nicomosa = -_loc2_.juri;
         _loc3_ = _loc1_.vug < 0 ? -_loc1_.vug : Number(_loc1_.vug);
         _loc4_ = _loc1_.luwym < 0 ? -_loc1_.luwym : Number(_loc1_.luwym);
         _loc5_ = _loc1_.tari < 0 ? -_loc1_.tari : Number(_loc1_.tari);
         _loc2_.zepoci = this.nezav.x * _loc3_ + this.nezav.y * _loc4_ + this.nezav.z * _loc5_;
         _loc2_.gesuwi = -_loc2_.zepoci;
         _loc2_.cubegyw += _loc1_.kyvuru;
         _loc2_.jys += _loc1_.kyvuru;
         _loc2_.nicomosa += _loc1_.zumidynip;
         _loc2_.juri += _loc1_.zumidynip;
         _loc2_.gesuwi += _loc1_.sunafepo;
         _loc2_.zepoci += _loc1_.sunafepo;
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
         var _loc10_:Number = param1.x - _loc5_.kyvuru;
         var _loc11_:Number = param1.y - _loc5_.zumidynip;
         var _loc12_:Number = param1.z - _loc5_.sunafepo;
         var _loc13_:Number = _loc5_.gusat * _loc10_ + _loc5_.sig * _loc11_ + _loc5_.vug * _loc12_;
         var _loc14_:Number = _loc5_.cydop * _loc10_ + _loc5_.qanezycap * _loc11_ + _loc5_.luwym * _loc12_;
         var _loc15_:Number = _loc5_.sivy * _loc10_ + _loc5_.wyvukog * _loc11_ + _loc5_.tari * _loc12_;
         _loc10_ = _loc5_.gusat * param2.x + _loc5_.sig * param2.y + _loc5_.vug * param2.z;
         _loc11_ = _loc5_.cydop * param2.x + _loc5_.qanezycap * param2.y + _loc5_.luwym * param2.z;
         _loc12_ = _loc5_.sivy * param2.x + _loc5_.wyvukog * param2.y + _loc5_.tari * param2.z;
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
         param4.x = _loc5_.gusat * _loc10_ + _loc5_.cydop * _loc11_ + _loc5_.sivy * _loc12_;
         param4.y = _loc5_.sig * _loc10_ + _loc5_.qanezycap * _loc11_ + _loc5_.wyvukog * _loc12_;
         param4.z = _loc5_.vug * _loc10_ + _loc5_.luwym * _loc11_ + _loc5_.tari * _loc12_;
         return _loc6_;
      }
   }
}

