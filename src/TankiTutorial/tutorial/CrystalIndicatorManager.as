package tutorial
{
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class CrystalIndicatorManager
   {
      
      private static const MARGIN:int = 20;
      
      public var indicator:CrystalIndicator;
      
      private var stage:Stage;
      
      private var align:String;
      
      private var time:uint;
      
      private var speed:Number = 0.6180339882723972;
      
      private var animating:Boolean = false;
      
      public function CrystalIndicatorManager(stage:Stage)
      {
         super();
         this.stage = stage;
         this.align = StageAlign.TOP_RIGHT;
         this.indicator = new CrystalIndicator();
         this.indicator.alpha = 0;
         this.updateAlign();
         stage.addEventListener(Event.RESIZE,this.updateAlign);
      }
      
      public function showIndicator() : void
      {
         if(this.indicator.parent == null)
         {
            this.stage.addChild(this.indicator);
         }
         if(this.animating)
         {
            this.stage.removeEventListener(Event.ENTER_FRAME,this.showMotion);
            this.stage.removeEventListener(Event.ENTER_FRAME,this.hideImage);
         }
         this.animating = true;
         this.stage.addEventListener(Event.ENTER_FRAME,this.showMotion);
         this.time = getTimer();
      }
      
      public function hideIndicator() : void
      {
         if(this.indicator.parent != null)
         {
            if(this.animating)
            {
               this.stage.removeEventListener(Event.ENTER_FRAME,this.showMotion);
               this.stage.removeEventListener(Event.ENTER_FRAME,this.hideImage);
            }
            this.animating = true;
            this.stage.addEventListener(Event.ENTER_FRAME,this.hideImage);
            this.time = getTimer();
         }
      }
      
      private function showMotion(e:Event = null) : void
      {
         var deltaTime:Number = (getTimer() - this.time) * 0.001;
         this.time = getTimer();
         this.indicator.alpha += deltaTime * this.speed;
         if(this.indicator.alpha >= 1)
         {
            this.indicator.alpha = 1;
            this.stage.removeEventListener(Event.ENTER_FRAME,this.showMotion);
            this.animating = false;
         }
      }
      
      private function hideImage(e:Event) : void
      {
         var deltaTime:Number = (getTimer() - this.time) * 0.001;
         this.time = getTimer();
         this.indicator.alpha -= deltaTime * this.speed;
         if(this.indicator.alpha <= 0)
         {
            this.indicator.alpha = 0;
            this.animating = false;
            this.stage.removeEventListener(Event.ENTER_FRAME,this.hideImage);
            if(this.indicator.parent != null)
            {
               this.stage.removeChild(this.indicator);
            }
         }
      }
      
      private function updateAlign(e:Event = null) : void
      {
         if(this.indicator == null)
         {
            return;
         }
         switch(this.align)
         {
            case StageAlign.BOTTOM:
               this.indicator.x = (this.stage.stageWidth - this.indicator.width) * 0.5;
               this.indicator.y = this.stage.stageHeight - this.indicator.height - MARGIN;
               break;
            case StageAlign.BOTTOM_LEFT:
               this.indicator.x = MARGIN;
               this.indicator.y = this.stage.stageHeight - this.indicator.height - MARGIN;
               break;
            case StageAlign.BOTTOM_RIGHT:
               this.indicator.x = this.stage.stageWidth - this.indicator.width - MARGIN;
               this.indicator.y = this.stage.stageHeight - this.indicator.height - MARGIN;
               break;
            case StageAlign.LEFT:
               this.indicator.x = MARGIN;
               this.indicator.y = (this.stage.stageHeight - this.indicator.height) * 0.5;
               break;
            case StageAlign.RIGHT:
               this.indicator.x = this.stage.stageWidth - this.indicator.width - MARGIN;
               this.indicator.y = (this.stage.stageHeight - this.indicator.height) * 0.5;
               break;
            case StageAlign.TOP:
               this.indicator.x = (this.stage.stageWidth - this.indicator.width) * 0.5;
               this.indicator.y = MARGIN;
               break;
            case StageAlign.TOP_LEFT:
               this.indicator.x = MARGIN;
               this.indicator.y = MARGIN;
               break;
            case StageAlign.TOP_RIGHT:
               this.indicator.x = this.stage.stageWidth - this.indicator.width - MARGIN;
               this.indicator.y = MARGIN;
         }
      }
   }
}

