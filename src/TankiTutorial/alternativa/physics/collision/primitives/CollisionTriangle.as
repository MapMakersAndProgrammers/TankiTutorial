package alternativa.physics.collision.primitives
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.types.dudyqo;
   
   public class CollisionTriangle extends CollisionShape
   {
      
      public var lyzud:Vector3 = new Vector3();
      
      public var pedake:Vector3 = new Vector3();
      
      public var bykecy:Vector3 = new Vector3();
      
      public var dodupypic:Vector3 = new Vector3();
      
      public var cilozuj:Vector3 = new Vector3();
      
      public var dij:Vector3 = new Vector3();
      
      public function CollisionTriangle(param1:Vector3, param2:Vector3, param3:Vector3, param4:int, param5:PhysicsMaterial)
      {
         super(miluvo,param4,param5);
         this.initVertices(param1,param2,param3);
      }
      
      override public function calculateAABB() : dudyqo
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:dudyqo = this.raruluk;
         var _loc2_:Matrix4 = this.wet;
         var _loc3_:Number = 0.005;
         var _loc6_:Number = _loc3_ * _loc2_.sivy;
         var _loc7_:Number = _loc3_ * _loc2_.wyvukog;
         var _loc8_:Number = _loc3_ * _loc2_.tari;
         _loc4_ = this.lyzud.x * _loc2_.gusat + this.lyzud.y * _loc2_.cydop;
         _loc1_.cubegyw = _loc1_.jys = _loc4_ + _loc6_;
         _loc5_ = _loc4_ - _loc6_;
         if(_loc5_ > _loc1_.jys)
         {
            _loc1_.jys = _loc5_;
         }
         else if(_loc5_ < _loc1_.cubegyw)
         {
            _loc1_.cubegyw = _loc5_;
         }
         _loc4_ = this.lyzud.x * _loc2_.sig + this.lyzud.y * _loc2_.qanezycap;
         _loc1_.nicomosa = _loc1_.juri = _loc4_ + _loc7_;
         _loc5_ = _loc4_ - _loc7_;
         if(_loc5_ > _loc1_.juri)
         {
            _loc1_.juri = _loc5_;
         }
         else if(_loc5_ < _loc1_.nicomosa)
         {
            _loc1_.nicomosa = _loc5_;
         }
         _loc4_ = this.lyzud.x * _loc2_.vug + this.lyzud.y * _loc2_.luwym;
         _loc1_.gesuwi = _loc1_.zepoci = _loc4_ + _loc8_;
         _loc5_ = _loc4_ - _loc8_;
         if(_loc5_ > _loc1_.zepoci)
         {
            _loc1_.zepoci = _loc5_;
         }
         else if(_loc5_ < _loc1_.gesuwi)
         {
            _loc1_.gesuwi = _loc5_;
         }
         _loc4_ = this.pedake.x * _loc2_.gusat + this.pedake.y * _loc2_.cydop;
         _loc5_ = _loc4_ + _loc6_;
         if(_loc5_ > _loc1_.jys)
         {
            _loc1_.jys = _loc5_;
         }
         else if(_loc5_ < _loc1_.cubegyw)
         {
            _loc1_.cubegyw = _loc5_;
         }
         _loc5_ = _loc4_ - _loc6_;
         if(_loc5_ > _loc1_.jys)
         {
            _loc1_.jys = _loc5_;
         }
         else if(_loc5_ < _loc1_.cubegyw)
         {
            _loc1_.cubegyw = _loc5_;
         }
         _loc4_ = this.pedake.x * _loc2_.sig + this.pedake.y * _loc2_.qanezycap;
         _loc5_ = _loc4_ + _loc7_;
         if(_loc5_ > _loc1_.juri)
         {
            _loc1_.juri = _loc5_;
         }
         else if(_loc5_ < _loc1_.nicomosa)
         {
            _loc1_.nicomosa = _loc5_;
         }
         _loc5_ = _loc4_ - _loc7_;
         if(_loc5_ > _loc1_.juri)
         {
            _loc1_.juri = _loc5_;
         }
         else if(_loc5_ < _loc1_.nicomosa)
         {
            _loc1_.nicomosa = _loc5_;
         }
         _loc4_ = this.pedake.x * _loc2_.vug + this.pedake.y * _loc2_.luwym;
         _loc5_ = _loc4_ + _loc8_;
         if(_loc5_ > _loc1_.zepoci)
         {
            _loc1_.zepoci = _loc5_;
         }
         else if(_loc5_ < _loc1_.gesuwi)
         {
            _loc1_.gesuwi = _loc5_;
         }
         _loc5_ = _loc4_ - _loc8_;
         if(_loc5_ > _loc1_.zepoci)
         {
            _loc1_.zepoci = _loc5_;
         }
         else if(_loc5_ < _loc1_.gesuwi)
         {
            _loc1_.gesuwi = _loc5_;
         }
         _loc4_ = this.bykecy.x * _loc2_.gusat + this.bykecy.y * _loc2_.cydop;
         _loc5_ = _loc4_ + _loc6_;
         if(_loc5_ > _loc1_.jys)
         {
            _loc1_.jys = _loc5_;
         }
         else if(_loc5_ < _loc1_.cubegyw)
         {
            _loc1_.cubegyw = _loc5_;
         }
         _loc5_ = _loc4_ - _loc6_;
         if(_loc5_ > _loc1_.jys)
         {
            _loc1_.jys = _loc5_;
         }
         else if(_loc5_ < _loc1_.cubegyw)
         {
            _loc1_.cubegyw = _loc5_;
         }
         _loc4_ = this.bykecy.x * _loc2_.sig + this.bykecy.y * _loc2_.qanezycap;
         _loc5_ = _loc4_ + _loc7_;
         if(_loc5_ > _loc1_.juri)
         {
            _loc1_.juri = _loc5_;
         }
         else if(_loc5_ < _loc1_.nicomosa)
         {
            _loc1_.nicomosa = _loc5_;
         }
         _loc5_ = _loc4_ - _loc7_;
         if(_loc5_ > _loc1_.juri)
         {
            _loc1_.juri = _loc5_;
         }
         else if(_loc5_ < _loc1_.nicomosa)
         {
            _loc1_.nicomosa = _loc5_;
         }
         _loc4_ = this.bykecy.x * _loc2_.vug + this.bykecy.y * _loc2_.luwym;
         _loc5_ = _loc4_ + _loc8_;
         if(_loc5_ > _loc1_.zepoci)
         {
            _loc1_.zepoci = _loc5_;
         }
         else if(_loc5_ < _loc1_.gesuwi)
         {
            _loc1_.gesuwi = _loc5_;
         }
         _loc5_ = _loc4_ - _loc8_;
         if(_loc5_ > _loc1_.zepoci)
         {
            _loc1_.zepoci = _loc5_;
         }
         else if(_loc5_ < _loc1_.gesuwi)
         {
            _loc1_.gesuwi = _loc5_;
         }
         _loc1_.cubegyw += _loc2_.kyvuru;
         _loc1_.jys += _loc2_.kyvuru;
         _loc1_.nicomosa += _loc2_.zumidynip;
         _loc1_.juri += _loc2_.zumidynip;
         _loc1_.gesuwi += _loc2_.sunafepo;
         _loc1_.zepoci += _loc2_.sunafepo;
         return _loc1_;
      }
      
      override public function raycast(param1:Vector3, param2:Vector3, param3:Number, param4:Vector3) : Number
      {
         var _loc5_:Matrix4 = null;
         _loc5_ = this.wet;
         var _loc6_:Number = param2.x * _loc5_.sivy + param2.y * _loc5_.wyvukog + param2.qyririg * _loc5_.tari;
         if(_loc6_ < param3 && _loc6_ > -param3)
         {
            return -1;
         }
         var _loc7_:Number = param1.x - _loc5_.kyvuru;
         var _loc8_:Number = param1.y - _loc5_.zumidynip;
         var _loc9_:Number = param1.qyririg - _loc5_.sunafepo;
         var _loc10_:Number = _loc7_ * _loc5_.sivy + _loc8_ * _loc5_.wyvukog + _loc9_ * _loc5_.tari;
         var _loc11_:Number = -_loc10_ / _loc6_;
         if(_loc11_ < 0)
         {
            return -1;
         }
         var _loc12_:Number = _loc7_ * _loc5_.gusat + _loc8_ * _loc5_.sig + _loc9_ * _loc5_.vug;
         var _loc13_:Number = _loc7_ * _loc5_.cydop + _loc8_ * _loc5_.qanezycap + _loc9_ * _loc5_.luwym;
         _loc7_ = _loc12_ + _loc11_ * (param2.x * _loc5_.gusat + param2.y * _loc5_.sig + param2.qyririg * _loc5_.vug);
         _loc8_ = _loc13_ + _loc11_ * (param2.x * _loc5_.cydop + param2.y * _loc5_.qanezycap + param2.qyririg * _loc5_.luwym);
         if(this.dodupypic.x * (_loc8_ - this.lyzud.y) - this.dodupypic.y * (_loc7_ - this.lyzud.x) < 0 || this.cilozuj.x * (_loc8_ - this.pedake.y) - this.cilozuj.y * (_loc7_ - this.pedake.x) < 0 || this.dij.x * (_loc8_ - this.bykecy.y) - this.dij.y * (_loc7_ - this.bykecy.x) < 0)
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
         return _loc11_;
      }
      
      override public function copyFrom(param1:CollisionShape) : CollisionShape
      {
         super.copyFrom(param1);
         var _loc2_:CollisionTriangle = param1 as CollisionTriangle;
         if(_loc2_ != null)
         {
            this.lyzud.copy(_loc2_.lyzud);
            this.pedake.copy(_loc2_.pedake);
            this.bykecy.copy(_loc2_.bykecy);
            this.dodupypic.copy(_loc2_.dodupypic);
            this.cilozuj.copy(_loc2_.cilozuj);
            this.dij.copy(_loc2_.dij);
         }
         return this;
      }
      
      override protected function createPrimitive() : CollisionShape
      {
         return new CollisionTriangle(this.lyzud,this.pedake,this.bykecy,nute,material);
      }
      
      private function initVertices(param1:Vector3, param2:Vector3, param3:Vector3) : void
      {
         this.lyzud.copy(param1);
         this.pedake.copy(param2);
         this.bykecy.copy(param3);
         this.dodupypic.diff(param2,param1);
         this.dodupypic.normalize();
         this.cilozuj.diff(param3,param2);
         this.cilozuj.normalize();
         this.dij.diff(param1,param3);
         this.dij.normalize();
      }
   }
}

