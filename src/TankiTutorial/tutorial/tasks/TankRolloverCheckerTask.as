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
      
      private static const hevarer:Number = 0.1;
      
      private var gadiv:int;
      
      public function TankRolloverCheckerTask()
      {
         super();
      }
      
      override public function process() : Boolean
      {
         var _loc1_:TimeData = null;
         if(this.isRolledOver())
         {
            _loc1_ = GameData.lecopojen;
            this.gadiv += _loc1_.rud;
            if(this.gadiv > 4000)
            {
               this.showSuicideHelp();
               return true;
            }
         }
         else
         {
            this.gadiv = 0;
         }
         return false;
      }
      
      private function isRolledOver() : Boolean
      {
         var _loc1_:Tank = GameData.jifom;
         if(_loc1_.hogys == null)
         {
            return false;
         }
         return _loc1_.hogys.body.jefe.tari < hevarer;
      }
      
      private function showSuicideHelp() : void
      {
         if(Game.isFinished())
         {
            return;
         }
         GameData.hulaf.showMovie(Assets.getData("delete_help",MovieClip),StageAlign.TOP);
         GameData.namab.addTask(new HideSuicideHelpTask());
      }
   }
}

