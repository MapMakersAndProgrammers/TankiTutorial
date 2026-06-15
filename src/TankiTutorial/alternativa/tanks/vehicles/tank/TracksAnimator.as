package alternativa.tanks.vehicles.tank
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.tanks.vehicles.tank.physics.SuspensionRay;
   import alternativa.tanks.vehicles.tank.physics.Track;
   import alternativa.tanks.vehicles.tank.skin.TankSkin;
   import alternativa.utils.MathUtils;
   
   public class TracksAnimator
   {
      
      private static const garyvacy:Number = 100;
      
      private static const miqowat:Vector3 = new Vector3();
      
      private var hag:TrackedChassis;
      
      private var kuca:TankSkin;
      
      private var jifav:ValueSmoother;
      
      public function TracksAnimator(param1:TrackedChassis, param2:TankSkin, param3:ValueSmoother)
      {
         super();
         this.hag = param1;
         this.kuca = param2;
         this.jifav = param3;
      }
      
      public function animate(param1:Number) : void
      {
         this.calculateTracksAnimationSpeed(param1);
         this.kuca.updateTracks(param1 * this.hag.vapal.zigebota,param1 * this.hag.mof.zigebota);
      }
      
      private function calculateTracksAnimationSpeed(param1:Number) : void
      {
         this.calculateTrackAnimationSpeed(this.hag.vapal,param1);
         this.calculateTrackAnimationSpeed(this.hag.mof,param1);
      }
      
      private function calculateTrackAnimationSpeed(param1:Track, param2:Number) : void
      {
         if(this.hasCorrectContacts(param1))
         {
            this.animateTrackWithContacts(param1,param2);
         }
         else
         {
            this.animateTrackWithoutContacts(param1,param2);
         }
      }
      
      private function hasCorrectContacts(param1:Track) : Boolean
      {
         return param1.body.jefe.tari > 0 && param1.jim > 0;
      }
      
      private function animateTrackWithContacts(param1:Track, param2:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc3_:Number = this.getTrackSpeed(param1);
         if(this.requiresSynchronizedAnimation(param1,_loc3_))
         {
            param1.zigebota = _loc3_;
         }
         else
         {
            _loc4_ = this.getDesiredSpeedCoeff(param1) * garyvacy;
            param1.setAnimationSpeed(_loc4_,this.hag.getAcceleration() * param2);
         }
      }
      
      private function getTrackSpeed(param1:Track) : Number
      {
         var _loc2_:Vector3 = param1.hetofefu;
         var _loc3_:SuspensionRay = param1.mofovoti[param1.wavi >> 1];
         this.getBodyPointVelocity(param1.body,_loc3_.getGlobalOrigin(),miqowat);
         var _loc4_:Number = miqowat.x - _loc2_.x;
         var _loc5_:Number = miqowat.y - _loc2_.y;
         var _loc6_:Number = miqowat.qyririg - _loc2_.qyririg;
         var _loc7_:Matrix3 = param1.body.jefe;
         return _loc4_ * _loc7_.cydop + _loc5_ * _loc7_.qanezycap + _loc6_ * _loc7_.luwym;
      }
      
      private function getBodyPointVelocity(param1:Body, param2:Vector3, param3:Vector3) : void
      {
         var _loc5_:Number = NaN;
         var _loc8_:Vector3 = null;
         var _loc4_:Vector3 = param1.kejo.position;
         _loc5_ = param2.x - _loc4_.x;
         var _loc6_:Number = param2.y - _loc4_.y;
         var _loc7_:Number = param2.qyririg - _loc4_.qyririg;
         _loc8_ = param1.kejo.fev;
         param3.x = _loc8_.y * _loc7_ - _loc8_.qyririg * _loc6_;
         param3.y = _loc8_.qyririg * _loc5_ - _loc8_.x * _loc7_;
         param3.qyririg = _loc8_.x * _loc6_ - _loc8_.y * _loc5_;
         var _loc9_:Vector3 = param1.kejo.zerus;
         param3.x += _loc9_.x;
         param3.y += _loc9_.y;
         param3.qyririg += _loc9_.qyririg;
      }
      
      private function requiresSynchronizedAnimation(param1:Track, param2:Number) : Boolean
      {
         var _loc3_:Number = this.getDesiredSpeedCoeff(param1);
         return Math.abs(param2) > 0.8 * garyvacy || _loc3_ == 0 || MathUtils.numberSign(param2,1) * MathUtils.sign(_loc3_) == -1;
      }
      
      private function getDesiredSpeedCoeff(param1:Track) : Number
      {
         var _loc2_:int = this.hag.getActualMovementDirection();
         var _loc3_:int = this.hag.getActualTurnDirection();
         var _loc4_:Number = 0;
         if(_loc2_ == 0)
         {
            _loc4_ = param1.lolojela * _loc3_ * 0.5;
         }
         else if(_loc3_ == 0)
         {
            _loc4_ = _loc2_;
         }
         else
         {
            _loc4_ = _loc2_ * (3 + param1.lolojela * _loc3_) / 4;
         }
         return _loc4_;
      }
      
      private function animateTrackWithoutContacts(param1:Track, param2:Number) : void
      {
         var _loc3_:Number = this.getDesiredSpeedCoeff(param1);
         param1.setAnimationSpeed(_loc3_ * this.jifav.getTargetValue(),this.hag.getAcceleration() * param2);
      }
   }
}

