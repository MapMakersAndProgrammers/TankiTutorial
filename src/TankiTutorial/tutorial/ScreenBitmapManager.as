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
      
      private static const MARGIN:int = 20;
      
      private var bitmap:Bitmap;
      
      private var align:String;
      
      private var stage:Stage;
      
      private var time:uint;
      
      private var speed:Number = 1;
      
      private var bitmapData:BitmapData;
      
      public function ScreenBitmapManager(stage:Stage)
      {
         super();
         this.stage = stage;
         stage.addEventListener(Event.RESIZE,this.updateAlign);
         this.bitmap = new Bitmap();
      }
      
      public function showBitmap(bitmapData:BitmapData, align:String) : void
      {
         this.bitmapData = bitmapData;
         this.align = align;
         if(this.bitmap.bitmapData != null)
         {
            this.stage.addEventListener(Event.ENTER_FRAME,this.hideImage);
            this.time = getTimer();
         }
         else
         {
            this.initImage();
         }
      }
      
      public function hideBimap() : void
      {
         this.stage.addEventListener(Event.ENTER_FRAME,this.hideImage);
         this.time = getTimer();
         this.bitmapData = null;
      }
      
      private function initImage() : void
      {
         if(this.bitmap.parent != null)
         {
            this.stage.removeChild(this.bitmap);
         }
         this.stage.addChild(this.bitmap);
         this.bitmap.alpha = 0;
         this.bitmap.bitmapData = this.bitmapData;
         this.updateAlign();
         this.stage.addEventListener(Event.ENTER_FRAME,this.showImage);
         this.time = getTimer();
      }
      
      private function showImage(e:Event) : void
      {
         var deltaTime:Number = (getTimer() - this.time) * 0.001;
         this.time = getTimer();
         this.bitmap.alpha += deltaTime * this.speed;
         if(this.bitmap.alpha >= 1)
         {
            this.bitmap.alpha = 1;
            this.stage.removeEventListener(Event.ENTER_FRAME,this.showImage);
         }
      }
      
      private function hideImage(e:Event) : void
      {
         var deltaTime:Number = (getTimer() - this.time) * 0.001;
         this.time = getTimer();
         this.bitmap.alpha -= deltaTime * this.speed;
         if(this.bitmap.alpha <= 0)
         {
            this.bitmap.alpha = 0;
            this.stage.removeEventListener(Event.ENTER_FRAME,this.hideImage);
            this.bitmap.bitmapData = null;
            if(this.bitmapData != null)
            {
               this.initImage();
            }
         }
      }
      
      private function updateAlign(e:Event = null) : void
      {
         if(this.bitmapData == null)
         {
            return;
         }
         switch(this.align)
         {
            case StageAlign.BOTTOM:
               this.bitmap.x = (this.stage.stageWidth - this.bitmap.bitmapData.width) * 0.5;
               this.bitmap.y = this.stage.stageHeight - this.bitmap.bitmapData.height - MARGIN;
               break;
            case StageAlign.BOTTOM_LEFT:
               this.bitmap.x = MARGIN;
               this.bitmap.y = this.stage.stageHeight - this.bitmap.bitmapData.height - MARGIN;
               break;
            case StageAlign.BOTTOM_RIGHT:
               this.bitmap.x = this.stage.stageWidth - this.bitmap.bitmapData.width - MARGIN;
               this.bitmap.y = this.stage.stageHeight - this.bitmap.bitmapData.height - MARGIN;
               break;
            case StageAlign.LEFT:
               this.bitmap.x = MARGIN;
               this.bitmap.y = (this.stage.stageHeight - this.bitmap.bitmapData.height) * 0.5;
               break;
            case StageAlign.RIGHT:
               this.bitmap.x = this.stage.stageWidth - this.bitmap.bitmapData.width - MARGIN;
               this.bitmap.y = (this.stage.stageHeight - this.bitmap.bitmapData.height) * 0.5;
               break;
            case StageAlign.TOP:
               this.bitmap.x = (this.stage.stageWidth - this.bitmap.bitmapData.width) * 0.5;
               this.bitmap.y = MARGIN;
               break;
            case StageAlign.TOP_LEFT:
               this.bitmap.x = MARGIN;
               this.bitmap.y = MARGIN;
               break;
            case StageAlign.TOP_RIGHT:
               this.bitmap.x = this.stage.stageWidth - this.bitmap.bitmapData.width - MARGIN;
               this.bitmap.y = MARGIN;
         }
      }
   }
}

