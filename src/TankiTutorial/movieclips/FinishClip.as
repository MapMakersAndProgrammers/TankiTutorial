package movieclips
{
   import tutorial.utils.Text;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Timer;
   import tutorial.commons.Lang;
   import tutorial.commons.LocalizedStrings;
   import tutorial.commons.Shared;
   
   public class FinishClip extends MovieClip
   {
      
      private static const DELAY_IN_SECONDS:uint = 1;
      
      private var finishMCClass:Class = FinishClip_finishMCClass;
      
      private var blur:Shape;
      
      private var clip:MovieClip;
      
      private var tf1:TextField;
      
      private var tf2:TextField;
      
      private var tf3:TextField;
      
      private var redirectLabel:TextField;
      
      private var redirectTimer:Timer;
      
      private var repeat:uint = 5;
      
      public function FinishClip()
      {
         super();
         this.blur = new Shape();
         addChild(this.blur);
         this.clip = new this.finishMCClass() as MovieClip;
         addChild(this.clip);
         this.tf1 = Text.getTextField(Lang.getText(LocalizedStrings.CONGRATULATIONS),42,1000,"center");
         this.tf2 = Text.getTextField(Lang.getText(LocalizedStrings.LAST_PHRASE_1),22,1000,"center");
         this.tf3 = Text.getTextField(Lang.getText(LocalizedStrings.LAST_PHRASE_2),22,1000,"center");
         addChild(this.tf1);
         addChild(this.tf2);
         addChild(this.tf3);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.redirectLabel = Text.getTextField(this.getTimeLeftText(),22,1000,"center");
         addChild(this.redirectLabel);
         this.redirectTimer = new Timer(DELAY_IN_SECONDS * 1000,this.repeat);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize();
         this.redirectTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this.redirectTimer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
         this.redirectTimer.start();
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         --this.repeat;
         this.redirectLabel.text = this.getTimeLeftText();
      }
      
      private function getTimeLeftText() : String
      {
         var _loc1_:RegExp = /0/i;
         var _loc2_:String = Lang.getText(LocalizedStrings.REDIRECT_TO_THE_GAME);
         return _loc2_.replace(_loc1_,(DELAY_IN_SECONDS * this.repeat).toString());
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         Shared.tracker.trackEvent(Shared.TUTORIAL,"registration","");
         if(Shared.navigateMethod != null)
         {
            Shared.navigateMethod();
         }
      }
      
      private function onResize(param1:Event = null) : void
      {
         this.blur.graphics.clear();
         this.blur.graphics.beginFill(0,0.7);
         this.blur.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         var _loc2_:Point = localToGlobal(new Point());
         this.blur.x = -_loc2_.x;
         this.blur.y = -_loc2_.y;
         this.clip.x = (stage.stageWidth - this.clip.width) * 0.5 - _loc2_.x;
         this.clip.y = (stage.stageHeight - this.clip.height) * 0.5 - 50 - _loc2_.y;
         this.tf1.x = this.clip.x + (this.clip.width - this.tf1.width) / 2;
         this.tf1.y = this.clip.y - 80 + 40 + 40;
         this.tf2.x = this.clip.x + (this.clip.width - this.tf2.width) / 2;
         this.tf2.y = this.clip.y - 20 + 30 + 40;
         this.tf3.x = this.clip.x + (this.clip.width - this.tf3.width) / 2;
         this.tf3.y = this.clip.y + this.clip.height + 35;
         this.redirectLabel.x = this.clip.x + (this.clip.width - this.redirectLabel.width) / 2;
         this.redirectLabel.y = this.clip.y + this.clip.height - 20;
      }
   }
}

