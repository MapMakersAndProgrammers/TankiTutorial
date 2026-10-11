package alternativa.tanks.vehicles.tank.controllers
{
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.weapons.Weapon;
   
   public class CommonTankController
   {
      
      public static const FORWARD:int = 2;
      
      public static const BACKWARD:int = 3;
      
      public static const LEFT:int = 4;
      
      public static const RIGHT:int = 5;
      
      public static const FIRE:int = 6;
      
      public var lockMask:int = 0;
      
      public var controlState:int;
      
      public var _enabled:Boolean = true;
      
      public var tank:Tank;
      
      public function CommonTankController(param1:Tank)
      {
         super();
         this.tank = param1;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set enabled(value:Boolean) : void
      {
         this._enabled = value;
         this.setAction(0);
      }
      
      public function lock(mask:int) : void
      {
         this.controlState &= ~mask;
         this.lockMask |= mask;
      }
      
      public function unlock(mask:int) : void
      {
         this.lockMask &= ~mask;
      }
      
      public function startMoveForward() : void
      {
         this.controlState |= 1 << FORWARD & ~this.lockMask;
      }
      
      public function stopMoveForward() : void
      {
         this.controlState &= ~(1 << FORWARD);
      }
      
      public function startMoveBackward() : void
      {
         this.controlState |= 1 << BACKWARD & ~this.lockMask;
      }
      
      public function stopMoveBackward() : void
      {
         this.controlState &= ~(1 << BACKWARD);
      }
      
      public function startTurnLeft() : void
      {
         this.controlState |= 1 << LEFT & ~this.lockMask;
      }
      
      public function stopTurnLeft() : void
      {
         this.controlState &= ~(1 << LEFT);
      }
      
      public function startTurnRight() : void
      {
         this.controlState |= 1 << RIGHT & ~this.lockMask;
      }
      
      public function stopTurnRight() : void
      {
         this.controlState &= ~(1 << RIGHT);
      }
      
      public function startAction(action:int) : void
      {
         this.controlState |= 1 << action & ~this.lockMask;
      }
      
      public function stopAction(action:int) : void
      {
         this.controlState &= ~(1 << action);
      }
      
      public function setAction(param1:int) : void
      {
         this.controlState = param1;
      }
      
      public function update(time:int, deltaTime:int, param3:Number) : void
      {
         var movementDirection:int = 0;
         var turnDirection:int = 0;
         var weapon:Weapon = this.tank.getWeapon();
         if(this.tank.alive)
         {
            movementDirection = this.getInput(FORWARD,BACKWARD);
            turnDirection = this.getInput(LEFT,RIGHT);
            if(movementDirection < 0)
            {
            }
            this.tank.setMovementParams(movementDirection,turnDirection,false);
            if(weapon != null)
            {
               if((this.controlState & 1 << FIRE) == 0)
               {
                  weapon.stop();
               }
               else
               {
                  weapon.start();
               }
            }
         }
         else
         {
            this.tank.setMovementParams(0,0,false);
            if(weapon != null)
            {
               weapon.stop();
            }
         }
      }
      
      private function getInput(positiveAction:int, negativeAction:int) : int
      {
         return ((this.controlState & 1 << positiveAction) >> positiveAction) - ((this.controlState & 1 << negativeAction) >> negativeAction);
      }
   }
}

