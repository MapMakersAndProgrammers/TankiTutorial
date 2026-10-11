package tutorial.tasks
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import tutorial.GameData;
   import tutorial.StartClip;
   
   public class StartTutorialTask extends Task
   {
      
      private var clip:MovieClip;
      
      private var callback:Function;
      
      private var finished:Boolean;
      
      public function StartTutorialTask(callback:Function)
      {
         super();
         this.callback = callback;
      }
      
      override public function process() : Boolean
      {
         if(this.clip == null)
         {
            this.clip = new StartClip();
            this.clip.addEventListener(Event.COMPLETE,this.finish);
            GameData.screenMovieClipManager.showMovie(this.clip,"TL",true);
         }
         return this.finished;
      }
      
      private function finish(e:Event) : void
      {
         this.finished = true;
         var graphics:Graphics = Sprite(GameData.container).graphics;
         graphics.clear();
         GameData.screenMovieClipManager.hideMovie(true);
         if(this.callback != null)
         {
            this.callback();
         }
      }
   }
}

