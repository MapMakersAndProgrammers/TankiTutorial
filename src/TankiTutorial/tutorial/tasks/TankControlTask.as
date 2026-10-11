package tutorial.tasks
{
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.controllers.CommonTankController;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class TankControlTask extends Task
   {
      
      private var controller:CommonTankController;
      
      private var tank:Tank;
      
      public function TankControlTask(tank:Tank, controller:CommonTankController)
      {
         super();
         this.tank = tank;
         this.controller = controller;
      }
      
      override public function process() : Boolean
      {
         var timeData:TimeData = GameData.time;
         if(this.tank.inGame)
         {
            this.controller.update(timeData.time,timeData.deltaTimeMs,timeData.deltaTime);
            return false;
         }
         return GameData.tanks.indexOf(this.tank) < 0;
      }
   }
}

