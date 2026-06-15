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
      
      private var racefom:uint;
      
      private var sprite:Sprite;
      
      private var lecopojen:uint;
      
      private var hon:Function;
      
      public function FadeOutTask(param1:uint, param2:Function = null)
      {
         super();
         this.lecopojen = param1;
         this.hon = param2;
         this.sprite = new Sprite();
         this.stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize();
      }
      
      private function onResize(param1:Event = null) : void
      {
      }
      
      override public function process() : Boolean
      {
         if(this.racefom == 0)
         {
            this.racefom = getTimer();
            GameData.danewazam.addChild(this.sprite);
         }
         var _loc1_:Number = 1 - (getTimer() - this.racefom) / this.lecopojen;
         this.sprite.alpha = _loc1_;
         if(_loc1_ <= 0)
         {
            GameData.danewazam.removeChild(this.sprite);
            this.stage.removeEventListener(Event.RESIZE,this.onResize);
            this.hon();
            return true;
         }
         return false;
      }
   }
}

