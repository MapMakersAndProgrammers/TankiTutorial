package alternativa.tanks.vehicles.tank
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.tanks.vehicles.tank.physics.SuspensionParams;
   import alternativa.tanks.vehicles.tank.physics.SuspensionRay;
   import alternativa.tanks.vehicles.tank.physics.Track;
   import alternativa.utils.MathUtils;
   
   public class TrackedChassis
   {
      
      private static const tyqufisen:Number = 400;
      
      private static const dibi:Vector3 = new Vector3();
      
      private static const domypujag:Vector3 = new Vector3();
      
      private static const jidovivo:Vector3 = new Vector3();
      
      private static const mavejok:Vector3 = new Vector3();
      
      private static const jeke:Vector3 = new Vector3();
      
      private static const jyz:Vector3 = new Vector3();
      
      private static const qupe:Vector3 = new Vector3();
      
      private static const kugariz:Vector3 = new Vector3();
      
      private static const vejavus:Vector3 = new Vector3();
      
      private var body:Body;
      
      private var gobo:SuspensionParams;
      
      private var jifav:ValueSmoother;
      
      internal var vapal:Track;
      
      internal var mof:Track;
      
      internal var dajy:Boolean;
      
      internal var rucumopak:int;
      
      internal var wuzyvodew:int;
      
      internal var cewubegy:Boolean;
      
      private var dis:Number = 1306;
      
      private var canako:Number = 1461;
      
      private var hageb:Number = 1439;
      
      private var nasykatag:Number = MathUtils.toRadians(141.9);
      
      private var jikivemuh:Number = MathUtils.toRadians(203.9);
      
      public function TrackedChassis(param1:Body, param2:SuspensionParams, param3:ValueSmoother, param4:Vector3)
      {
         super();
         this.body = param1;
         this.gobo = param2;
         this.jifav = param3;
         this.createTracks(TankConst.nybi,param4);
      }
      
      private function createTracks(param1:int, param2:Vector3) : void
      {
         var _loc3_:Number = param2.y * 0.8;
         var _loc4_:Number = param2.x - 40;
         this.vapal = new Track(this.body,param1,new Vector3(-0.5 * _loc4_,0,-0.5 * param2.qyririg + TankConst.kyr),_loc3_,this.gobo,-1);
         this.mof = new Track(this.body,param1,new Vector3(0.5 * _loc4_,0,-0.5 * param2.qyririg + TankConst.kyr),_loc3_,this.gobo,1);
      }
      
      public function setAcceleration(param1:Number) : void
      {
         this.dis = param1;
      }
      
      public function setReverseAcceleration(param1:Number) : void
      {
         this.canako = param1;
      }
      
      public function setSideAcceleration(param1:Number) : void
      {
         this.hageb = param1;
      }
      
      public function setTurnAcceleration(param1:Number) : void
      {
         this.nasykatag = param1;
      }
      
      public function setReverseTurnAcceleration(param1:Number) : void
      {
         this.jikivemuh = param1;
      }
      
      public function getAcceleration() : Number
      {
         return this.dis;
      }
      
      public function getActualMovementDirection() : int
      {
         return this.dajy ? 0 : this.rucumopak;
      }
      
      public function getActualTurnDirection() : int
      {
         return this.dajy ? 0 : this.wuzyvodew;
      }
      
      public function setTracksCollisionGroup(param1:int) : void
      {
         this.vapal.setCollisionGroup(param1);
         this.mof.setCollisionGroup(param1);
      }
      
      public function applyForces(param1:Number, param2:Number, param3:Number) : void
      {
         this.adjustSuspensionSpringCoeff();
         this.calculateSuspensionContacts(param3);
         this.applyMovementForces(param1,param2,param3);
         this.applySlopeHack();
      }
      
      private function adjustSuspensionSpringCoeff() : void
      {
         var _loc1_:Number = this.body.tuce.tem.length() * this.body.tuwykus;
         this.gobo.jakopunu = _loc1_ / (2 * TankConst.nybi * (this.gobo.tovudov - this.gobo.vocuqih));
      }
      
      private function calculateSuspensionContacts(param1:Number) : void
      {
         this.vapal.calculateSuspensionContacts(param1);
         this.mof.calculateSuspensionContacts(param1);
      }
      
      private function applyMovementForces(param1:Number, param2:Number, param3:Number) : void
      {
         if(this.vapal.jim + this.mof.jim > 0)
         {
            this.doApplyMovementForces(param1,param2,param3);
         }
      }
      
      private function doApplyMovementForces(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc7_:Vector3 = null;
         var _loc8_:Matrix3 = null;
         var _loc9_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:int = 0;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:int = 0;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc4_:int = this.dajy ? 0 : this.rucumopak;
         var _loc5_:int = this.dajy ? 0 : this.wuzyvodew;
         var _loc6_:Vector3 = this.body.kejo.zerus;
         _loc7_ = this.body.kejo.fev;
         _loc8_ = this.body.jefe;
         dibi.x = _loc8_.gusat;
         dibi.y = _loc8_.sig;
         dibi.qyririg = _loc8_.vug;
         domypujag.x = _loc8_.cydop;
         domypujag.y = _loc8_.qanezycap;
         domypujag.qyririg = _loc8_.luwym;
         jidovivo.x = _loc8_.sivy;
         jidovivo.y = _loc8_.wyvukog;
         jidovivo.qyririg = _loc8_.tari;
         _loc9_ = 1;
         var _loc10_:Number = Math.PI / 4;
         var _loc11_:Number = Math.PI / 3;
         if(jidovivo.qyririg < Math.cos(_loc10_))
         {
            if(jidovivo.qyririg < Math.cos(_loc11_))
            {
               _loc9_ = 0;
            }
            else
            {
               _loc9_ = (_loc11_ - Math.acos(jidovivo.qyririg)) / (_loc11_ - _loc10_);
            }
         }
         this.calculateSurfaceVelocities(mavejok,jeke);
         jyz.x = _loc6_.x - mavejok.x;
         jyz.y = _loc6_.y - mavejok.y;
         jyz.qyririg = _loc6_.qyririg - mavejok.qyririg;
         qupe.x = _loc7_.x - jeke.x;
         qupe.y = _loc7_.y - jeke.y;
         qupe.qyririg = _loc7_.qyririg - jeke.qyririg;
         var _loc12_:Number = jyz.x * domypujag.x + jyz.y * domypujag.y + jyz.qyririg * domypujag.qyririg;
         var _loc13_:Number = qupe.x * jidovivo.x + qupe.y * jidovivo.y + qupe.qyririg * jidovivo.qyririg;
         var _loc14_:Number = jyz.x * dibi.x + jyz.y * dibi.y + jyz.qyririg * dibi.qyririg;
         var _loc15_:Number = this.hageb * _loc9_ * param3;
         if(_loc14_ < 0)
         {
            if(_loc15_ > -_loc14_)
            {
               _loc14_ = 0;
            }
            else
            {
               _loc14_ += _loc15_;
            }
         }
         else if(_loc14_ > 0)
         {
            if(_loc15_ > _loc14_)
            {
               _loc14_ = 0;
            }
            else
            {
               _loc14_ -= _loc15_;
            }
         }
         jyz.setLengthAlongDirection(dibi,_loc14_);
         _loc6_.x = mavejok.x + jyz.x;
         _loc6_.y = mavejok.y + jyz.y;
         _loc6_.qyririg = mavejok.qyririg + jyz.qyririg;
         var _loc16_:int = this.vapal.jim;
         var _loc17_:int = this.mof.jim;
         var _loc18_:Number = this.dis;
         var _loc19_:Number = this.nasykatag;
         if(_loc16_ > 0 || _loc17_ > 0)
         {
            _loc20_ = 0;
            if(_loc4_ == 0)
            {
               _loc20_ = -MathUtils.sign(_loc12_) * _loc18_ * param3;
               if(MathUtils.sign(_loc12_) != MathUtils.sign(_loc12_ + _loc20_))
               {
                  _loc20_ = -_loc12_;
               }
            }
            else
            {
               if(MathUtils.sign(_loc12_) * MathUtils.sign(_loc4_) < 0)
               {
                  _loc18_ = this.canako;
               }
               _loc20_ = _loc4_ * _loc18_ * param3;
            }
            _loc21_ = MathUtils.clamp(_loc12_ + _loc20_,-param1,param1);
            _loc22_ = _loc21_ - _loc12_;
            _loc23_ = 1;
            _loc24_ = MathUtils.clamp(1 - Math.abs(_loc12_ / param1),0,1);
            if(_loc24_ < _loc23_ && _loc4_ * MathUtils.sign(_loc12_) > 0)
            {
               _loc22_ *= _loc24_ / _loc23_;
            }
            _loc25_ = _loc22_ / param3;
            if(Math.abs(_loc25_) < tyqufisen && Math.abs(_loc21_) > 0.5 * this.jifav.getTargetValue())
            {
               _loc25_ = MathUtils.numberSign(_loc25_,0.1) * tyqufisen;
            }
            _loc26_ = _loc25_ * this.body.tuwykus;
            _loc27_ = _loc16_ + _loc17_;
            _loc28_ = _loc26_ * (_loc27_ + 0.42 * (10 - _loc16_)) / 10;
            _loc29_ = _loc28_ / _loc27_;
            _loc30_ = Math.PI / 4;
            _loc31_ = Math.PI / 3;
            _loc32_ = 0;
            while(_loc32_ < TankConst.nybi)
            {
               this.applyForceFromRay(this.vapal.mofovoti[_loc32_],domypujag,_loc29_,_loc31_,_loc30_);
               this.applyForceFromRay(this.mof.mofovoti[_loc32_],domypujag,_loc29_,_loc31_,_loc30_);
               _loc32_++;
            }
            _loc33_ = 1;
            if(_loc16_ == 0 || _loc17_ == 0)
            {
               _loc33_ = 0.5;
            }
            _loc34_ = 0;
            if(_loc5_ == 0)
            {
               _loc34_ = -MathUtils.sign(_loc13_) * _loc19_ * _loc9_ * param3;
               if(MathUtils.sign(_loc13_) != MathUtils.sign(_loc13_ + _loc34_))
               {
                  _loc34_ = -_loc13_;
               }
            }
            else
            {
               if(this.isReversedTurn(_loc5_,_loc13_))
               {
                  _loc19_ = this.jikivemuh;
               }
               _loc34_ = _loc5_ * _loc19_ * _loc9_ * param3;
               if(_loc4_ == -1 && this.cewubegy)
               {
                  _loc34_ = -_loc34_;
               }
            }
            _loc35_ = MathUtils.clamp(_loc13_ + _loc34_,-param2 * _loc33_,param2 * _loc33_);
            qupe.setLengthAlongDirection(jidovivo,_loc35_);
            _loc7_.x = jeke.x + qupe.x;
            _loc7_.y = jeke.y + qupe.y;
            _loc7_.qyririg = jeke.qyririg + qupe.qyririg;
         }
      }
      
      private function isReversedTurn(param1:int, param2:Number) : Boolean
      {
         return param1 * param2 < 0;
      }
      
      private function calculateSurfaceVelocities(param1:Vector3, param2:Vector3) : void
      {
         var _loc4_:SuspensionRay = null;
         var _loc5_:int = 0;
         var _loc6_:Vector3 = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc3_:Number = 1 / (this.vapal.jim + this.mof.jim);
         var _loc7_:Number = 0;
         _loc8_ = 0;
         _loc9_ = 0;
         _loc5_ = 0;
         while(_loc5_ < TankConst.nybi)
         {
            _loc4_ = this.vapal.mofovoti[_loc5_];
            if(_loc4_.vivi)
            {
               _loc6_ = _loc4_.wonuhig.position;
               _loc7_ += _loc6_.x;
               _loc8_ += _loc6_.y;
               _loc9_ += _loc6_.qyririg;
            }
            _loc4_ = this.mof.mofovoti[_loc5_];
            if(_loc4_.vivi)
            {
               _loc6_ = _loc4_.wonuhig.position;
               _loc7_ += _loc6_.x;
               _loc8_ += _loc6_.y;
               _loc9_ += _loc6_.qyririg;
            }
            _loc5_++;
         }
         _loc7_ *= _loc3_;
         _loc8_ *= _loc3_;
         _loc9_ *= _loc3_;
         vejavus.x = _loc7_;
         vejavus.y = _loc8_;
         vejavus.qyririg = _loc9_;
         param1.x = 0;
         param1.y = 0;
         param1.qyririg = 0;
         param2.x = 0;
         param2.y = 0;
         param2.qyririg = 0;
         _loc5_ = 0;
         while(_loc5_ < TankConst.nybi)
         {
            this.addVelocitiesFromRay(this.vapal.mofovoti[_loc5_],vejavus,param1,param2);
            this.addVelocitiesFromRay(this.mof.mofovoti[_loc5_],vejavus,param1,param2);
            _loc5_++;
         }
         param1.x *= _loc3_;
         param1.y *= _loc3_;
         param1.qyririg *= _loc3_;
         param2.x *= _loc3_;
         param2.y *= _loc3_;
         param2.qyririg *= _loc3_;
      }
      
      private function addVelocitiesFromRay(param1:SuspensionRay, param2:Vector3, param3:Vector3, param4:Vector3) : void
      {
         var _loc5_:Vector3 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Vector3 = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         if(param1.vivi)
         {
            param3.x += param1.poseze.x;
            param3.y += param1.poseze.y;
            param3.qyririg += param1.poseze.qyririg;
            _loc5_ = param1.wonuhig.position;
            _loc6_ = _loc5_.x - param2.x;
            _loc7_ = _loc5_.y - param2.y;
            _loc8_ = _loc5_.qyririg - param2.qyririg;
            _loc9_ = _loc6_ * _loc6_ + _loc7_ * _loc7_ + _loc8_ * _loc8_;
            if(_loc9_ > 1)
            {
               _loc10_ = 1 / _loc9_;
               _loc11_ = param1.poseze;
               _loc12_ = (_loc7_ * _loc11_.qyririg - _loc8_ * _loc11_.y) * _loc10_;
               _loc13_ = (_loc8_ * _loc11_.x - _loc6_ * _loc11_.qyririg) * _loc10_;
               _loc14_ = (_loc6_ * _loc11_.y - _loc7_ * _loc11_.x) * _loc10_;
               param4.x += _loc12_;
               param4.y += _loc13_;
               param4.qyririg += _loc14_;
            }
         }
      }
      
      private function applyForceFromRay(param1:SuspensionRay, param2:Vector3, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(param1.vivi)
         {
            _loc6_ = param2.x;
            _loc7_ = param2.y;
            _loc8_ = param2.qyririg;
            _loc9_ = _loc6_ * _loc6_ + _loc7_ * _loc7_ + _loc8_ * _loc8_;
            if(_loc9_ > 0.00001)
            {
               _loc10_ = Math.acos(param1.wonuhig.lefugefo.qyririg);
               if(_loc10_ < 0)
               {
                  _loc10_ = -_loc10_;
               }
               if(_loc10_ < param4)
               {
                  _loc11_ = param3 / Math.sqrt(_loc9_);
                  if(_loc10_ > param5)
                  {
                     _loc11_ *= (param4 - _loc10_) / (param4 - param5);
                  }
                  kugariz.x = _loc6_ * _loc11_;
                  kugariz.y = _loc7_ * _loc11_;
                  kugariz.qyririg = _loc8_ * _loc11_;
                  this.body.addWorldForceAtLocalPoint(param1.getOrigin(),kugariz);
               }
            }
         }
      }
      
      private function applySlopeHack() : void
      {
         var _loc1_:Matrix3 = null;
         var _loc2_:Vector3 = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(this.mof.jim >= this.mof.wavi >> 1 || this.vapal.jim >= this.vapal.wavi >> 1)
         {
            _loc1_ = this.body.jefe;
            _loc2_ = this.body.tuce.tem;
            _loc3_ = _loc2_.x * _loc1_.sivy + _loc2_.y * _loc1_.wyvukog + _loc2_.qyririg * _loc1_.tari;
            _loc4_ = _loc2_.length();
            _loc5_ = Math.SQRT1_2 * _loc4_;
            if(_loc3_ < -_loc5_ || _loc3_ > _loc5_)
            {
               _loc6_ = (_loc1_.sivy * _loc3_ - _loc2_.x) * this.body.tuwykus;
               _loc7_ = (_loc1_.wyvukog * _loc3_ - _loc2_.y) * this.body.tuwykus;
               _loc8_ = (_loc1_.tari * _loc3_ - _loc2_.qyririg) * this.body.tuwykus;
               this.body.addForceXYZ(_loc6_,_loc7_,_loc8_);
            }
         }
      }
   }
}

