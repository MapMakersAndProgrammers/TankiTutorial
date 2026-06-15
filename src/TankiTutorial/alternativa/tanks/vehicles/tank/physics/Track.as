package alternativa.tanks.vehicles.tank.physics
{
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   
   public class Track
   {
      
      public var body:Body;
      
      public var mofovoti:Vector.<SuspensionRay>;
      
      public var wavi:int;
      
      public var jim:int;
      
      public var gobo:SuspensionParams;
      
      public var zigebota:Number = 0;
      
      public var lolojela:int;
      
      public const hetofefu:Vector3 = new Vector3();
      
      public function Track(param1:Body, param2:int, param3:Vector3, param4:Number, param5:SuspensionParams, param6:int)
      {
         super();
         this.body = param1;
         this.lolojela = param6;
         this.setTrackParams(param2,param3,param4,param5);
      }
      
      public function setTrackParams(param1:int, param2:Vector3, param3:Number, param4:SuspensionParams) : void
      {
         var _loc7_:Vector3 = null;
         this.wavi = param1;
         this.gobo = param4;
         this.mofovoti = new Vector.<SuspensionRay>(param1);
         var _loc5_:Number = param3 / (param1 - 1);
         var _loc6_:int = 0;
         while(_loc6_ < param1)
         {
            _loc7_ = new Vector3(param2.x,param2.y + 0.5 * param3 - _loc6_ * _loc5_,param2.qyririg);
            this.mofovoti[_loc6_] = new SuspensionRay(this.body,_loc7_,Vector3.lasis,param4);
            _loc6_++;
         }
      }
      
      public function setCollisionGroup(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.wavi)
         {
            SuspensionRay(this.mofovoti[_loc2_]).nute = param1;
            _loc2_++;
         }
      }
      
      public function calculateSuspensionContacts(param1:Number) : void
      {
         var _loc2_:Vector3 = null;
         var _loc4_:SuspensionRay = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         this.jim = 0;
         this.hetofefu.x = 0;
         this.hetofefu.y = 0;
         this.hetofefu.qyririg = 0;
         _loc2_ = this.body.kejo.zerus;
         var _loc3_:int = 0;
         while(_loc3_ < this.wavi)
         {
            _loc4_ = this.mofovoti[_loc3_];
            _loc4_.update(param1);
            if(_loc4_.vivi)
            {
               ++this.jim;
               this.body.addWorldForceScaled(_loc4_.getGlobalOrigin(),_loc4_.getGlobalDirection(),-_loc4_.vys);
               this.hetofefu.x += _loc4_.poseze.x;
               this.hetofefu.y += _loc4_.poseze.y;
               this.hetofefu.qyririg += _loc4_.poseze.qyririg;
               _loc5_ = _loc2_.x - _loc4_.poseze.x;
               _loc6_ = _loc2_.y - _loc4_.poseze.y;
               _loc7_ = _loc2_.qyririg - _loc4_.poseze.qyririg;
               _loc4_.wiciqy = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_ + _loc7_ * _loc7_);
            }
            else
            {
               _loc4_.wiciqy = 0;
            }
            _loc3_++;
         }
         if(this.jim > 1)
         {
            this.hetofefu.x /= this.jim;
            this.hetofefu.y /= this.jim;
            this.hetofefu.qyririg /= this.jim;
         }
      }
      
      public function setAnimationSpeed(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         if(this.zigebota < param1)
         {
            _loc3_ = this.zigebota + param2;
            this.zigebota = _loc3_ > param1 ? param1 : _loc3_;
         }
         else if(this.zigebota > param1)
         {
            _loc3_ = this.zigebota - param2;
            this.zigebota = _loc3_ < param1 ? param1 : _loc3_;
         }
      }
   }
}

