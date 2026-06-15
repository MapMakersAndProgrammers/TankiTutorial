package tutorial
{
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class CrystalIndicatorManager
   {
      
      private static const kiqidevov:int = 20;
      
      public var duqup:CrystalIndicator;
      
      private var stage:Stage;
      
      private var cinilu:String;
      
      private var lecopojen:uint;
      
      private var wiciqy:Number = 0.6180339882723972;
      
      private var pov:Boolean = false;
      
      public function CrystalIndicatorManager(param1:Stage)
      {
         super();
         this.stage = param1;
         this.cinilu = StageAlign.TOP_RIGHT;
         this.duqup = new CrystalIndicator();
         this.duqup.alpha = 0;
         this.updateAlign();
         param1.addEventListener(Event.RESIZE,this.updateAlign);
      }
      
      public function showIndicator() : void
      {
         if(this.duqup.parent == null)
         {
            this.stage.addChild(this.duqup);
         }
         if(this.pov)
         {
            this.stage.removeEventListener(Event.ENTER_FRAME,this.showMotion);
            this.stage.removeEventListener(Event.ENTER_FRAME,this.hideImage);
         }
         this.pov = true;
         this.stage.addEventListener(Event.ENTER_FRAME,this.showMotion);
         this.lecopojen = getTimer();
      }
      
      public function hideIndicator() : void
      {
         if(this.duqup.parent != null)
         {
            if(this.pov)
            {
               this.stage.removeEventListener(Event.ENTER_FRAME,this.showMotion);
               this.stage.removeEventListener(Event.ENTER_FRAME,this.hideImage);
            }
            this.pov = true;
            this.stage.addEventListener(Event.ENTER_FRAME,this.hideImage);
            this.lecopojen = getTimer();
         }
      }
      
      private function showMotion(param1:Event = null) : void
      {
         var _loc2_:Number = (getTimer() - this.lecopojen) * 0.001;
         this.lecopojen = getTimer();
         this.duqup.alpha += _loc2_ * this.wiciqy;
         if(this.duqup.alpha >= 1)
         {
            this.duqup.alpha = 1;
            this.stage.removeEventListener(Event.ENTER_FRAME,this.showMotion);
            this.pov = false;
         }
      }
      
      private function hideImage(param1:Event) : void
      {
         var _loc2_:Number = (getTimer() - this.lecopojen) * 0.001;
         this.lecopojen = getTimer();
         this.duqup.alpha -= _loc2_ * this.wiciqy;
         if(this.duqup.alpha <= 0)
         {
            this.duqup.alpha = 0;
            this.pov = false;
            this.stage.removeEventListener(Event.ENTER_FRAME,this.hideImage);
            if(this.duqup.parent != null)
            {
               this.stage.removeChild(this.duqup);
            }
         }
      }
      
      private function updateAlign(param1:Event = null) : void
      {
         if(this.duqup == null)
         {
            return;
         }
         switch(this.cinilu)
         {
            case StageAlign.BOTTOM:
               this.duqup.x = (this.stage.stageWidth - this.duqup.width) * 0.5;
               this.duqup.y = this.stage.stageHeight - this.duqup.height - kiqidevov;
               break;
            case StageAlign.BOTTOM_LEFT:
               this.duqup.x = kiqidevov;
               this.duqup.y = this.stage.stageHeight - this.duqup.height - kiqidevov;
               break;
            case StageAlign.BOTTOM_RIGHT:
               this.duqup.x = this.stage.stageWidth - this.duqup.width - kiqidevov;
               this.duqup.y = this.stage.stageHeight - this.duqup.height - kiqidevov;
               break;
            case StageAlign.LEFT:
               this.duqup.x = kiqidevov;
               this.duqup.y = (this.stage.stageHeight - this.duqup.height) * 0.5;
               break;
            case StageAlign.RIGHT:
               this.duqup.x = this.stage.stageWidth - this.duqup.width - kiqidevov;
               this.duqup.y = (this.stage.stageHeight - this.duqup.height) * 0.5;
               break;
            case StageAlign.TOP:
               this.duqup.x = (this.stage.stageWidth - this.duqup.width) * 0.5;
               this.duqup.y = kiqidevov;
               break;
            case StageAlign.TOP_LEFT:
               this.duqup.x = kiqidevov;
               this.duqup.y = kiqidevov;
               break;
            case StageAlign.TOP_RIGHT:
               this.duqup.x = this.stage.stageWidth - this.duqup.width - kiqidevov;
               this.duqup.y = kiqidevov;
         }
      }
   }
}

