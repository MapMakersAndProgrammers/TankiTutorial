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
      
      private var hon:Function;
      
      private var finished:Boolean;
      
      public function StartTutorialTask(param1:Function)
      {
         super();
         this.hon = param1;
      }
      
      override public function process() : Boolean
      {
         if(this.clip == null)
         {
            this.clip = new StartClip();
            this.clip.addEventListener(Event.COMPLETE,this.finish);
            GameData.hulaf.showMovie(this.clip,"TL",true);
         }
         return this.finished;
      }
      
      private function finish(param1:Event) : void
      {
         this.finished = true;
         var _loc2_:Graphics = Sprite(GameData.danewazam).graphics;
         _loc2_.clear();
         GameData.hulaf.hideMovie(true);
         if(this.hon != null)
         {
            this.hon();
         }
      }
   }
}

