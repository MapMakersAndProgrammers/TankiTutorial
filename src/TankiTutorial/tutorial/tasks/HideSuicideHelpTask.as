package tutorial.tasks
{
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class HideSuicideHelpTask extends Task
   {
      
      private var finished:Boolean;
      
      public function HideSuicideHelpTask()
      {
         super();
         GameData.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.DELETE)
         {
            this.finished = true;
            GameData.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            GameData.hulaf.hideMovie();
            GameData.hulaf.showMovie(Assets.getData("help",MovieClip),StageAlign.BOTTOM_RIGHT);
         }
      }
      
      override public function process() : Boolean
      {
         return this.finished;
      }
   }
}

