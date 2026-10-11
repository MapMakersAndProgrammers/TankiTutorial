package tutorial.tasks
{
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import tutorial.Game;
   import tutorial.GameData;
   import tutorial.TimeData;
   import tutorial.commons.Assets;
   
   public class TankRolloverCheckerTask extends Task
   {
      
      private static const threshold:Number = 0.1;
      
      private var rolledOverTime:int;
      
      public function TankRolloverCheckerTask()
      {
         super();
      }
      
      override public function process() : Boolean
      {
         var timeData:TimeData = null;
         if(this.isRolledOver())
         {
            timeData = GameData.time;
            this.rolledOverTime += timeData.deltaTimeMs;
            if(this.rolledOverTime > 4000)
            {
               this.showSuicideHelp();
               return true;
            }
         }
         else
         {
            this.rolledOverTime = 0;
         }
         return false;
      }
      
      private function isRolledOver() : Boolean
      {
         var tank:Tank = GameData.playerTank;
         if(tank.hogys == null)
         {
            return false;
         }
         return tank.hogys.body.jefe.tari < threshold;
      }
      
      private function showSuicideHelp() : void
      {
         if(Game.isFinished())
         {
            return;
         }
         GameData.screenMovieClipManager.showMovie(Assets.getData("delete_help",MovieClip),StageAlign.TOP);
         GameData.taskGroup.addTask(new HideSuicideHelpTask());
      }
   }
}

