package alternativa.tanks.vehicles.tank.controllers
{
   import alternativa.tanks.utils.BitMask;
   import alternativa.tanks.vehicles.tank.SimpleValueSmoother;
   import alternativa.tanks.vehicles.tank.ValueSmoother;
   import alternativa.utils.MathUtils;
   
   public class TurretController
   {
      
      public static const wogop:int = 0;
      
      public static const dad:int = 1;
      
      public static const heravytu:int = 2;
      
      private var vibewyge:ValueSmoother = new SimpleValueSmoother(0.3,10,0,0);
      
      private var gejebuke:Number = 0;
      
      private var qupi:Number = 0;
      
      private var pyfika:Number = 0;
      
      private var dypy:Number = 0;
      
      private var masudaca:Number = 0;
      
      private var jiburaco:int;
      
      private var wuzyvodew:int;
      
      private var hatynev:Boolean;
      
      private var goka:BitMask = new BitMask();
      
      private var rakyraqeh:Boolean;
      
      private var tobizir:Number = 0;
      
      protected var jygef:Number = 0;
      
      protected var finished:Boolean = false;
      
      public function TurretController(param1:Number, param2:Number, param3:Boolean)
      {
         super();
         this.rakyraqeh = param3;
         this.setMaxTurnSpeed(param1,true);
         this.qupi = param2;
      }
      
      public function lock(param1:int) : void
      {
         this.goka.change(param1,true);
         if(!this.goka.isEmpty())
         {
            this.pyfika = 0;
         }
      }
      
      public function unlock(param1:int) : void
      {
         var _loc2_:Boolean = this.goka.isEmpty();
         this.goka.change(param1,false);
         if(this.goka.isEmpty() && !_loc2_)
         {
            this.hatynev = false;
            this.doUnlock();
         }
      }
      
      public function applyControlState(param1:int) : void
      {
         var _loc2_:int = MathUtils.getBitValue(param1,wogop);
         var _loc3_:int = MathUtils.getBitValue(param1,dad);
         this.wuzyvodew = _loc2_ - _loc3_;
         this.hatynev = _loc2_ + _loc3_ == 0 && (this.hatynev || MathUtils.getBitValue(param1,heravytu) == 1);
      }
      
      public function setDirectionImmediate(param1:Number) : void
      {
         this.masudaca = param1;
         this.dypy = param1;
         this.tobizir = 0;
      }
      
      public function setDirectionWithSmoothig(param1:Number) : void
      {
         this.tobizir = param1 - this.masudaca;
         if(this.tobizir > Math.PI)
         {
            this.tobizir = 2 * Math.PI - this.tobizir;
         }
         else if(this.tobizir < -Math.PI)
         {
            this.tobizir += 2 * Math.PI;
         }
      }
      
      public function getDirection() : Number
      {
         return this.masudaca;
      }
      
      public function getCameraDirection() : Number
      {
         return 0;
      }
      
      public function rotate(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         this.dypy = this.masudaca;
         this.gejebuke = this.vibewyge.update(param1);
         if(this.goka.isEmpty())
         {
            if(this.hatynev)
            {
               if(this.masudaca == 0)
               {
                  this.finishTurretCentering();
                  return;
               }
               _loc2_ = this.masudaca < 0 ? 1 : -1;
            }
            else
            {
               _loc2_ = this.wuzyvodew;
            }
            if(this.jiburaco != _loc2_)
            {
               this.pyfika = 0;
               this.jiburaco = _loc2_;
            }
            if(_loc2_ == 0)
            {
               this.pyfika = 0;
               return;
            }
            this.pyfika += _loc2_ * this.qupi * param1;
            this.pyfika = MathUtils.clamp(this.pyfika,-this.gejebuke,this.gejebuke);
            _loc3_ = this.masudaca < 0;
            this.masudaca += this.pyfika * param1;
            if(this.hatynev && _loc3_ != this.masudaca < 0)
            {
               this.masudaca = 0;
               this.finishTurretCentering();
            }
            if(this.masudaca < -Math.PI)
            {
               this.masudaca += MathUtils.qubabyby;
            }
            else if(this.masudaca > Math.PI)
            {
               this.masudaca -= MathUtils.qubabyby;
            }
         }
      }
      
      private function finishTurretCentering() : void
      {
         this.hatynev = false;
         this.pyfika = 0;
         this.onTurretCenteringComplete();
      }
      
      protected function onTurretCenteringComplete() : void
      {
      }
      
      public function getInterpolatedDirection(param1:Number) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = this.masudaca - this.dypy;
         if(_loc3_ < -Math.PI)
         {
            _loc2_ = this.dypy + param1 * (MathUtils.qubabyby + _loc3_);
            if(_loc2_ > Math.PI)
            {
               _loc2_ -= MathUtils.qubabyby;
            }
         }
         else if(_loc3_ > Math.PI)
         {
            _loc2_ = this.dypy - param1 * (MathUtils.qubabyby - _loc3_);
            if(_loc2_ < -Math.PI)
            {
               _loc2_ += MathUtils.qubabyby;
            }
         }
         else
         {
            _loc2_ = this.dypy + param1 * _loc3_;
         }
         return _loc2_;
      }
      
      public function isRotating() : Boolean
      {
         return this.pyfika != 0;
      }
      
      public function reset() : void
      {
         this.pyfika = 0;
         this.dypy = 0;
         this.masudaca = 0;
         this.vibewyge.reset(this.vibewyge.getTargetValue());
         this.hatynev = false;
         if(this.rakyraqeh)
         {
            this.wuzyvodew = 0;
         }
      }
      
      public function destroy() : void
      {
      }
      
      public function setMaxTurnSpeed(param1:Number, param2:Boolean) : void
      {
         if(param2)
         {
            this.gejebuke = param1;
            this.vibewyge.reset(param1);
         }
         else
         {
            this.vibewyge.setTargetValue(param1);
         }
      }
      
      public function getMaxTurnSpeed() : Number
      {
         return this.vibewyge.getTargetValue();
      }
      
      public function setTurnAcceleration(param1:Number) : void
      {
         this.qupi = param1;
      }
      
      public function getTurnAcceleration() : Number
      {
         return this.qupi;
      }
      
      protected function doUnlock() : void
      {
      }
      
      public function isNotLocked() : Boolean
      {
         return this.goka.isEmpty();
      }
      
      public function setTankDirection(param1:Number) : void
      {
         this.jygef = param1;
      }
      
      public function finish() : void
      {
         this.finished = true;
      }
   }
}

