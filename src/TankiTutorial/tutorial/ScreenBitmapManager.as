package tutorial
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class ScreenBitmapManager
   {
      
      private static const kiqidevov:int = 20;
      
      private var vuwo:Bitmap;
      
      private var cinilu:String;
      
      private var stage:Stage;
      
      private var lecopojen:uint;
      
      private var wiciqy:Number = 1;
      
      private var bitmapData:BitmapData;
      
      public function ScreenBitmapManager(param1:Stage)
      {
         super();
         this.stage = param1;
         param1.addEventListener(Event.RESIZE,this.updateAlign);
         this.vuwo = new Bitmap();
      }
      
      public function showBitmap(param1:BitmapData, param2:String) : void
      {
         this.bitmapData = param1;
         this.cinilu = param2;
         if(this.vuwo.bitmapData != null)
         {
            this.stage.addEventListener(Event.ENTER_FRAME,this.hideImage);
            this.lecopojen = getTimer();
         }
         else
         {
            this.initImage();
         }
      }
      
      public function hideBimap() : void
      {
         this.stage.addEventListener(Event.ENTER_FRAME,this.hideImage);
         this.lecopojen = getTimer();
         this.bitmapData = null;
      }
      
      private function initImage() : void
      {
         if(this.vuwo.parent != null)
         {
            this.stage.removeChild(this.vuwo);
         }
         this.stage.addChild(this.vuwo);
         this.vuwo.alpha = 0;
         this.vuwo.bitmapData = this.bitmapData;
         this.updateAlign();
         this.stage.addEventListener(Event.ENTER_FRAME,this.showImage);
         this.lecopojen = getTimer();
      }
      
      private function showImage(param1:Event) : void
      {
         var _loc2_:Number = (getTimer() - this.lecopojen) * 0.001;
         this.lecopojen = getTimer();
         this.vuwo.alpha += _loc2_ * this.wiciqy;
         if(this.vuwo.alpha >= 1)
         {
            this.vuwo.alpha = 1;
            this.stage.removeEventListener(Event.ENTER_FRAME,this.showImage);
         }
      }
      
      private function hideImage(param1:Event) : void
      {
         var _loc2_:Number = (getTimer() - this.lecopojen) * 0.001;
         this.lecopojen = getTimer();
         this.vuwo.alpha -= _loc2_ * this.wiciqy;
         if(this.vuwo.alpha <= 0)
         {
            this.vuwo.alpha = 0;
            this.stage.removeEventListener(Event.ENTER_FRAME,this.hideImage);
            this.vuwo.bitmapData = null;
            if(this.bitmapData != null)
            {
               this.initImage();
            }
         }
      }
      
      private function updateAlign(param1:Event = null) : void
      {
         if(this.bitmapData == null)
         {
            return;
         }
         switch(this.cinilu)
         {
            case StageAlign.BOTTOM:
               this.vuwo.x = (this.stage.stageWidth - this.vuwo.bitmapData.width) * 0.5;
               this.vuwo.y = this.stage.stageHeight - this.vuwo.bitmapData.height - kiqidevov;
               break;
            case StageAlign.BOTTOM_LEFT:
               this.vuwo.x = kiqidevov;
               this.vuwo.y = this.stage.stageHeight - this.vuwo.bitmapData.height - kiqidevov;
               break;
            case StageAlign.BOTTOM_RIGHT:
               this.vuwo.x = this.stage.stageWidth - this.vuwo.bitmapData.width - kiqidevov;
               this.vuwo.y = this.stage.stageHeight - this.vuwo.bitmapData.height - kiqidevov;
               break;
            case StageAlign.LEFT:
               this.vuwo.x = kiqidevov;
               this.vuwo.y = (this.stage.stageHeight - this.vuwo.bitmapData.height) * 0.5;
               break;
            case StageAlign.RIGHT:
               this.vuwo.x = this.stage.stageWidth - this.vuwo.bitmapData.width - kiqidevov;
               this.vuwo.y = (this.stage.stageHeight - this.vuwo.bitmapData.height) * 0.5;
               break;
            case StageAlign.TOP:
               this.vuwo.x = (this.stage.stageWidth - this.vuwo.bitmapData.width) * 0.5;
               this.vuwo.y = kiqidevov;
               break;
            case StageAlign.TOP_LEFT:
               this.vuwo.x = kiqidevov;
               this.vuwo.y = kiqidevov;
               break;
            case StageAlign.TOP_RIGHT:
               this.vuwo.x = this.stage.stageWidth - this.vuwo.bitmapData.width - kiqidevov;
               this.vuwo.y = kiqidevov;
         }
      }
   }
}

