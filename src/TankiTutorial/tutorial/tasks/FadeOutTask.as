package tutorial.tasks
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.utils.getTimer;
   import tutorial.GameData;
   
   public class FadeOutTask extends Task
   {
      
      private var stage:Stage = GameData.stage;
      
      private var startTime:uint;
      
      private var sprite:Sprite;
      
      private var time:uint;
      
      private var callback:Function;
      
      public function FadeOutTask(time:uint, callback:Function = null)
      {
         super();
         this.time = time;
         this.callback = callback;
         this.sprite = new Sprite();
         this.stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize();
      }
      
      private function onResize(e:Event = null) : void
      {
      }
      
      override public function process() : Boolean
      {
         if(this.startTime == 0)
         {
            this.startTime = getTimer();
            GameData.container.addChild(this.sprite);
         }
         var alpha:Number = 1 - (getTimer() - this.startTime) / this.time;
         this.sprite.alpha = alpha;
         if(alpha <= 0)
         {
            GameData.container.removeChild(this.sprite);
            this.stage.removeEventListener(Event.RESIZE,this.onResize);
            this.callback();
            return true;
         }
         return false;
      }
   }
}

