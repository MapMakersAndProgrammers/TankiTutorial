package alternativa.tanks.vehicles.tank.physics
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.collision.types.RayHit;
   
   public class SuspensionRay
   {
      
      public var nute:int;
      
      public var vivi:Boolean = false;
      
      public var wonuhig:RayHit = new RayHit();
      
      public var vys:Number = 0;
      
      public const poseze:Vector3 = new Vector3();
      
      public var wiciqy:Number = 0;
      
      private var body:Body;
      
      private var vyhomopog:Vector3 = new Vector3();
      
      private var ruda:Vector3 = new Vector3();
      
      private var gobo:SuspensionParams;
      
      private var ralowano:Vector3 = new Vector3();
      
      private var dozykamu:Vector3 = new Vector3();
      
      private var zife:Number = 0;
      
      private var woz:RayCollisionFilter;
      
      public function SuspensionRay(param1:Body, param2:Vector3, param3:Vector3, param4:SuspensionParams)
      {
         super();
         this.body = param1;
         this.vyhomopog.copy(param2);
         this.ruda.copy(param3);
         this.gobo = param4;
         this.woz = new RayCollisionFilter(param1);
      }
      
      public function update(param1:Number) : void
      {
         this.raycast();
         if(this.vivi)
         {
            this.calculateSpringForce(param1);
            this.calculateContactVelocity();
         }
      }
      
      private function raycast() : void
      {
         var _loc1_:Matrix3 = this.body.jefe;
         this.dozykamu.x = _loc1_.gusat * this.ruda.x + _loc1_.cydop * this.ruda.y + _loc1_.sivy * this.ruda.qyririg;
         this.dozykamu.y = _loc1_.sig * this.ruda.x + _loc1_.qanezycap * this.ruda.y + _loc1_.wyvukog * this.ruda.qyririg;
         this.dozykamu.qyririg = _loc1_.vug * this.ruda.x + _loc1_.luwym * this.ruda.y + _loc1_.tari * this.ruda.qyririg;
         var _loc2_:Vector3 = this.body.kejo.position;
         this.ralowano.x = _loc1_.gusat * this.vyhomopog.x + _loc1_.cydop * this.vyhomopog.y + _loc1_.sivy * this.vyhomopog.qyririg;
         this.ralowano.y = _loc1_.sig * this.vyhomopog.x + _loc1_.qanezycap * this.vyhomopog.y + _loc1_.wyvukog * this.vyhomopog.qyririg;
         this.ralowano.qyririg = _loc1_.vug * this.vyhomopog.x + _loc1_.luwym * this.vyhomopog.y + _loc1_.tari * this.vyhomopog.qyririg;
         this.ralowano.x += _loc2_.x;
         this.ralowano.y += _loc2_.y;
         this.ralowano.qyririg += _loc2_.qyririg;
         if(this.vivi)
         {
            this.zife = this.gobo.tovudov - this.wonuhig.jomuc;
         }
         this.vivi = this.body.tuce.kymaqos.raycast(this.ralowano,this.dozykamu,this.nute,this.gobo.tovudov,this.woz,this.wonuhig);
      }
      
      public function calculateSpringForce(param1:Number) : void
      {
         var _loc2_:Number = this.gobo.tovudov - this.wonuhig.jomuc;
         this.vys = this.gobo.jakopunu * _loc2_;
         var _loc3_:Number = (_loc2_ - this.zife) / param1;
         this.vys += _loc3_ * this.gobo.miqelina;
         if(this.vys < 0)
         {
            this.vys = 0;
         }
      }
      
      private function calculateContactVelocity() : void
      {
         var _loc2_:Vector3 = null;
         var _loc3_:Vector3 = null;
         var _loc4_:Vector3 = null;
         var _loc5_:Vector3 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc1_:Body = this.wonuhig.vetudozi.body;
         if(_loc1_.katuf != null)
         {
            _loc2_ = _loc1_.kejo.position;
            _loc3_ = _loc1_.kejo.zerus;
            _loc4_ = _loc1_.kejo.fev;
            _loc5_ = this.wonuhig.position;
            _loc6_ = _loc5_.x - _loc2_.x;
            _loc7_ = _loc5_.y - _loc2_.y;
            _loc8_ = _loc5_.qyririg - _loc2_.qyririg;
            this.poseze.x = _loc4_.y * _loc8_ - _loc4_.qyririg * _loc7_;
            this.poseze.y = _loc4_.qyririg * _loc6_ - _loc4_.x * _loc8_;
            this.poseze.qyririg = _loc4_.x * _loc7_ - _loc4_.y * _loc6_;
            this.poseze.x += _loc3_.x;
            this.poseze.y += _loc3_.y;
            this.poseze.qyririg += _loc3_.qyririg;
         }
         else
         {
            this.poseze.x = 0;
            this.poseze.y = 0;
            this.poseze.qyririg = 0;
         }
      }
      
      public function getGlobalOrigin() : Vector3
      {
         return this.ralowano;
      }
      
      public function getGlobalDirection() : Vector3
      {
         return this.dozykamu;
      }
      
      public function getOrigin() : Vector3
      {
         return this.vyhomopog;
      }
      
      public function getActualLength() : Number
      {
         if(this.vivi)
         {
            return this.wonuhig.jomuc;
         }
         return this.gobo.tovudov;
      }
   }
}

