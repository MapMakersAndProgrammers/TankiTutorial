package tutorial.tasks
{
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.controllers.CommonTankController;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class TankControlTask extends Task
   {
      
      private var controller:CommonTankController;
      
      private var citacir:Tank;
      
      public function TankControlTask(param1:Tank, param2:CommonTankController)
      {
         super();
         this.citacir = param1;
         this.controller = param2;
      }
      
      override public function process() : Boolean
      {
         var _loc1_:TimeData = GameData.lecopojen;
         if(this.citacir.inGame)
         {
            this.controller.update(_loc1_.lecopojen,_loc1_.rud,_loc1_.ziqod);
            return false;
         }
         return GameData.gaz.indexOf(this.citacir) < 0;
      }
   }
}

