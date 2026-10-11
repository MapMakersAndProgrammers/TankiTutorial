package tutorial
{
   import embed.Embed;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import tutorial.commons.Lang;
   import tutorial.commons.LocalizedStrings;
   import tutorial.utils.Button;
   import tutorial.utils.Form;
   
   public class StartClip extends MovieClip
   {
      
      private var button:Button;
      
      private var jorodyk:Number;
      
      private var teziveqo:Number = 0.7;
      
      private var startTime:uint;
      
      public function StartClip()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.button = new Button(new Form(200,Embed.LEFT,Embed.FILL),new Form(200,Embed.LEFT_OVER,Embed.FILL_OVER),new Form(200,Embed.LEFT_PRESSED,Embed.FILL_PRESSED),Lang.getText(LocalizedStrings.START));
      }
      
      private function onAddedToStage(e:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.button.addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.jorodyk = 1;
         this.onResize();
         addChild(this.button);
         stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(GameData.container.contains(GameData.backgroundSprite))
         {
            GameData.container.removeChild(GameData.backgroundSprite);
         }
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var currentTime:uint = uint(getTimer());
         var elapsed:uint = (currentTime - this.startTime) * 0.001;
         this.jorodyk -= elapsed * 0.001;
         if(this.jorodyk <= this.teziveqo)
         {
            this.jorodyk = this.teziveqo;
            stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         this.onResize();
      }
      
      private function onRemoved(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      private function onClick(mouseEvent:MouseEvent) : void
      {
         stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onResize(e:Event = null) : void
      {
         var point:Point = new Point();
         point = localToGlobal(point);
         this.drawBackground();
         this.button.x = int((stage.stageWidth - this.button.width) * 0.5) - point.x;
         this.button.y = int((stage.stageHeight - this.button.height) * 0.3) - point.y;
      }
      
      private function drawBackground() : void
      {
         var point:Point = new Point();
         point = localToGlobal(point);
      }
   }
}

