package alternativa.tanks.vehicles.tank.controllers
{
   import alternativa.tanks.utils.BitMask;
   import alternativa.tanks.vehicles.tank.SimpleValueSmoother;
   import alternativa.tanks.vehicles.tank.ValueSmoother;
   import alternativa.utils.MathUtils;
   
   public class TurretController
   {
      
      public static const LEFT:int = 0;
      
      public static const RIGHT:int = 1;
      
      public static const CENTER:int = 2;
      
      private var maxTurnSpeedSmoother:ValueSmoother = new SimpleValueSmoother(0.3,10,0,0);
      
      private var maxTurnSpeed:Number = 0;
      
      private var turnAcceleration:Number = 0;
      
      private var turnSpeed:Number = 0;
      
      private var prevDirection:Number = 0;
      
      private var direction:Number = 0;
      
      private var prevTurnDirection:int;
      
      private var turnDirection:int;
      
      private var centering:Boolean;
      
      private var lockMask:BitMask = new BitMask();
      
      private var rakyraqeh:Boolean;
      
      private var tobizir:Number = 0;
      
      protected var tankDirection:Number = 0;
      
      protected var finished:Boolean = false;
      
      public function TurretController(maxTurnSpeed:Number, turnAcceleration:Number, param3:Boolean)
      {
         super();
         this.rakyraqeh = param3;
         this.setMaxTurnSpeed(maxTurnSpeed,true);
         this.turnAcceleration = turnAcceleration;
      }
      
      public function lock(mask:int) : void
      {
         this.lockMask.change(mask,true);
         if(!this.lockMask.isEmpty())
         {
            this.turnSpeed = 0;
         }
      }
      
      public function unlock(mask:int) : void
      {
         var unlocked:Boolean = this.lockMask.isEmpty();
         this.lockMask.change(mask,false);
         if(this.lockMask.isEmpty() && !unlocked)
         {
            this.centering = false;
            this.doUnlock();
         }
      }
      
      public function applyControlState(controlState:int) : void
      {
         var left:int = MathUtils.getBitValue(controlState,LEFT);
         var right:int = MathUtils.getBitValue(controlState,RIGHT);
         this.turnDirection = left - right;
         this.centering = left + right == 0 && (this.centering || MathUtils.getBitValue(controlState,CENTER) == 1);
      }
      
      public function setDirectionImmediate(angle:Number) : void
      {
         this.direction = angle;
         this.prevDirection = angle;
         this.tobizir = 0;
      }
      
      public function setDirectionWithSmoothig(angle:Number) : void
      {
         this.tobizir = angle - this.direction;
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
         return this.direction;
      }
      
      public function getCameraDirection() : Number
      {
         return 0;
      }
      
      public function rotate(dt:Number) : void
      {
         var dir:int = 0;
         var wasNegative:Boolean = false;
         this.prevDirection = this.direction;
         this.maxTurnSpeed = this.maxTurnSpeedSmoother.update(dt);
         if(this.lockMask.isEmpty())
         {
            if(this.centering)
            {
               if(this.direction == 0)
               {
                  this.finishTurretCentering();
                  return;
               }
               dir = this.direction < 0 ? 1 : -1;
            }
            else
            {
               dir = this.turnDirection;
            }
            if(this.prevTurnDirection != dir)
            {
               this.turnSpeed = 0;
               this.prevTurnDirection = dir;
            }
            if(dir == 0)
            {
               this.turnSpeed = 0;
               return;
            }
            this.turnSpeed += dir * this.turnAcceleration * dt;
            this.turnSpeed = MathUtils.clamp(this.turnSpeed,-this.maxTurnSpeed,this.maxTurnSpeed);
            wasNegative = this.direction < 0;
            this.direction += this.turnSpeed * dt;
            if(this.centering && wasNegative != this.direction < 0)
            {
               this.direction = 0;
               this.finishTurretCentering();
            }
            if(this.direction < -Math.PI)
            {
               this.direction += MathUtils.PI2;
            }
            else if(this.direction > Math.PI)
            {
               this.direction -= MathUtils.PI2;
            }
         }
      }
      
      private function finishTurretCentering() : void
      {
         this.centering = false;
         this.turnSpeed = 0;
         this.onTurretCenteringComplete();
      }
      
      protected function onTurretCenteringComplete() : void
      {
      }
      
      public function getInterpolatedDirection(t:Number) : Number
      {
         var result:Number = NaN;
         var delta:Number = this.direction - this.prevDirection;
         if(delta < -Math.PI)
         {
            result = this.prevDirection + t * (MathUtils.PI2 + delta);
            if(result > Math.PI)
            {
               result -= MathUtils.PI2;
            }
         }
         else if(delta > Math.PI)
         {
            result = this.prevDirection - t * (MathUtils.PI2 - delta);
            if(result < -Math.PI)
            {
               result += MathUtils.PI2;
            }
         }
         else
         {
            result = this.prevDirection + t * delta;
         }
         return result;
      }
      
      public function isRotating() : Boolean
      {
         return this.turnSpeed != 0;
      }
      
      public function reset() : void
      {
         this.turnSpeed = 0;
         this.prevDirection = 0;
         this.direction = 0;
         this.maxTurnSpeedSmoother.reset(this.maxTurnSpeedSmoother.getTargetValue());
         this.centering = false;
         if(this.rakyraqeh)
         {
            this.turnDirection = 0;
         }
      }
      
      public function destroy() : void
      {
      }
      
      public function setMaxTurnSpeed(value:Number, immediately:Boolean) : void
      {
         if(immediately)
         {
            this.maxTurnSpeed = value;
            this.maxTurnSpeedSmoother.reset(value);
         }
         else
         {
            this.maxTurnSpeedSmoother.setTargetValue(value);
         }
      }
      
      public function getMaxTurnSpeed() : Number
      {
         return this.maxTurnSpeedSmoother.getTargetValue();
      }
      
      public function setTurnAcceleration(value:Number) : void
      {
         this.turnAcceleration = value;
      }
      
      public function getTurnAcceleration() : Number
      {
         return this.turnAcceleration;
      }
      
      protected function doUnlock() : void
      {
      }
      
      public function isNotLocked() : Boolean
      {
         return this.lockMask.isEmpty();
      }
      
      public function setTankDirection(value:Number) : void
      {
         this.tankDirection = value;
      }
      
      public function finish() : void
      {
         this.finished = true;
      }
   }
}

