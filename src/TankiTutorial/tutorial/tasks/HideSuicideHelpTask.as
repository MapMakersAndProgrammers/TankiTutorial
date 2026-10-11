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
      
      private function onKeyDown(keyboardEvent:KeyboardEvent) : void
      {
         if(keyboardEvent.keyCode == Keyboard.DELETE)
         {
            this.finished = true;
            GameData.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            GameData.screenMovieClipManager.hideMovie();
            GameData.screenMovieClipManager.showMovie(Assets.getData("help",MovieClip),StageAlign.BOTTOM_RIGHT);
         }
      }
      
      override public function process() : Boolean
      {
         return this.finished;
      }
   }
}

