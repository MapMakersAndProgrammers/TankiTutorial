package alternativa.tanks.vehicles.tank.controllers
{
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.weapons.Weapon;
   
   public class CommonTankController
   {
      
      public static const cyjeruqa:int = 2;
      
      public static const pycyje:int = 3;
      
      public static const dudazodol:int = 4;
      
      public static const qij:int = 5;
      
      public static const syfysu:int = 6;
      
      public var cogutirym:int = 0;
      
      public var ses:int;
      
      public var dalipaz:Boolean = true;
      
      public var citacir:Tank;
      
      public function CommonTankController(param1:Tank)
      {
         super();
         this.citacir = param1;
      }
      
      public function get enabled() : Boolean
      {
         return this.dalipaz;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         this.dalipaz = param1;
         this.setAction(0);
      }
      
      public function lock(param1:int) : void
      {
         this.ses &= ~param1;
         this.cogutirym |= param1;
      }
      
      public function unlock(param1:int) : void
      {
         this.cogutirym &= ~param1;
      }
      
      public function startMoveForward() : void
      {
         this.ses |= 1 << cyjeruqa & ~this.cogutirym;
      }
      
      public function stopMoveForward() : void
      {
         this.ses &= ~(1 << cyjeruqa);
      }
      
      public function startMoveBackward() : void
      {
         this.ses |= 1 << pycyje & ~this.cogutirym;
      }
      
      public function stopMoveBackward() : void
      {
         this.ses &= ~(1 << pycyje);
      }
      
      public function startTurnLeft() : void
      {
         this.ses |= 1 << dudazodol & ~this.cogutirym;
      }
      
      public function stopTurnLeft() : void
      {
         this.ses &= ~(1 << dudazodol);
      }
      
      public function startTurnRight() : void
      {
         this.ses |= 1 << qij & ~this.cogutirym;
      }
      
      public function stopTurnRight() : void
      {
         this.ses &= ~(1 << qij);
      }
      
      public function startAction(param1:int) : void
      {
         this.ses |= 1 << param1 & ~this.cogutirym;
      }
      
      public function stopAction(param1:int) : void
      {
         this.ses &= ~(1 << param1);
      }
      
      public function setAction(param1:int) : void
      {
         this.ses = param1;
      }
      
      public function update(param1:int, param2:int, param3:Number) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:Weapon = this.citacir.getWeapon();
         if(this.citacir.kat)
         {
            _loc5_ = this.getInput(cyjeruqa,pycyje);
            _loc6_ = this.getInput(dudazodol,qij);
            if(_loc5_ < 0)
            {
            }
            this.citacir.setMovementParams(_loc5_,_loc6_,false);
            if(_loc4_ != null)
            {
               if((this.ses & 1 << syfysu) == 0)
               {
                  _loc4_.stop();
               }
               else
               {
                  _loc4_.start();
               }
            }
         }
         else
         {
            this.citacir.setMovementParams(0,0,false);
            if(_loc4_ != null)
            {
               _loc4_.stop();
            }
         }
      }
      
      private function getInput(param1:int, param2:int) : int
      {
         return ((this.ses & 1 << param1) >> param1) - ((this.ses & 1 << param2) >> param2);
      }
   }
}

