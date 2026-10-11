package tutorial.commons
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class LoaderWindow extends Sprite
   {
      
      private static const THRESHOLD_STEP:uint = 20480;
      
      private var layer:DisplayObjectContainer;
      
      private var onTop:Boolean = false;
      
      private var size:uint;
      
      private var threshold:Number;
      
      private var state:String;
      
      private var bytesTotal:uint;
      
      private var bytesLoaded:uint;
      
      private var currentProgress:Number;
      
      private var targetProgress:Number;
      
      private var time:uint;
      
      private var totalTime:Number;
      
      private var startLoadTime:uint;
      
      private var lastDelta:uint;
      
      private const bar:ProgressBar = new ProgressBar();
      
      private var windowBmp:Bitmap;
      
      private var progressBrake:Number = 1;
      
      public function LoaderWindow(layer:DisplayObjectContainer)
      {
         super();
         this.layer = layer;
         this.windowBmp = new Bitmap(Shared.stub);
         addChild(this.windowBmp);
         this.bar.x = 14;
         this.bar.y = 242;
         this.bar.setProgress(0);
         addChild(this.bar);
         this.currentProgress = 0;
         this.targetProgress = 0;
         this.totalTime = 0;
      }
      
      public static function createImageFromRGBAndAlpha(rgb:BitmapData, alphaChannel:BitmapData) : Bitmap
      {
         var w:Number = rgb.width;
         var h:Number = rgb.height;
         var bitmapData:BitmapData = new BitmapData(w,h,true,0);
         bitmapData.copyPixels(rgb,new Rectangle(0,0,w,h),new Point());
         bitmapData.copyChannel(alphaChannel,new Rectangle(0,0,w,h),new Point(),1,8);
         return new Bitmap(bitmapData);
      }
      
      public function setSize(bytesTotal:uint) : void
      {
         this.bytesTotal = bytesTotal;
      }
      
      public function reset(state:String = null) : void
      {
         this.state = state;
         Shared.clientLog.addLine("loaded: " + this.size.toString());
         this.size = 0;
         this.threshold = THRESHOLD_STEP;
         if(state != null)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,"Start" + state,"");
         }
      }
      
      public function addBytes(bytes:uint) : void
      {
         if(this.state == null)
         {
            return;
         }
         this.size += bytes;
         while(this.size > this.threshold)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,this.state,int(this.threshold / 1024).toString() + "KB");
            this.threshold += THRESHOLD_STEP;
         }
         this.bytesLoaded += bytes;
         this.targetProgress = this.bytesLoaded / this.bytesTotal;
         if(this.targetProgress > 1)
         {
            this.targetProgress = 1;
         }
         var currentTime:uint = uint(getTimer());
         var seconds:uint = uint((currentTime - this.startLoadTime) / 1000);
         if(seconds % 5 == 0 && seconds != this.lastDelta)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,this.state + "_loading",seconds.toString());
            this.lastDelta = seconds;
         }
      }
      
      public function complete() : void
      {
         if(this.state != null)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,"Finish" + this.state,"************************************");
         }
      }
      
      public function getLoadedBytes() : uint
      {
         return this.size;
      }
      
      public function showLoaderWindow(onTop:Boolean = false) : void
      {
         this.startLoadTime = getTimer();
         this.lastDelta = 0;
         this.onTop = onTop;
         if(!this.layer.contains(this))
         {
            this.layer.addChild(this);
            stage.addEventListener(Event.RESIZE,this.align);
            this.align();
            stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.time = getTimer();
         }
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var speed:Number = NaN;
         var delta:Number = NaN;
         var currentTime:uint = uint(getTimer());
         var deltaTime:Number = (currentTime - this.time) * 0.001;
         this.totalTime += deltaTime;
         this.time = currentTime;
         if(this.totalTime > 0)
         {
            speed = this.targetProgress / this.totalTime;
            if(this.currentProgress > 0.8 && this.currentProgress - this.targetProgress > 0.2)
            {
               speed *= this.progressBrake;
               this.progressBrake *= 0.95;
            }
            delta = speed * deltaTime;
            if(delta < 0.002 && this.currentProgress < 0.1)
            {
               delta = 0.002;
            }
            if(this.currentProgress < 0.5)
            {
               delta *= 1.5;
            }
            this.currentProgress += delta;
            if(this.currentProgress > 1)
            {
               this.currentProgress = 1;
            }
            this.bar.setProgress(this.currentProgress);
         }
      }
      
      public function hideLoaderWindow() : void
      {
         var loadTime:uint = 0;
         if(this.layer.contains(this))
         {
            loadTime = uint((getTimer() - this.startLoadTime) / 1000);
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,this.state + "_loadTime",loadTime.toString());
            stage.removeEventListener(Event.RESIZE,this.align);
            stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.layer.removeChild(this);
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function align(e:Event = null) : void
      {
         this.x = stage.stageWidth - this.windowBmp.width >>> 1;
         if(this.onTop)
         {
            this.y = 10;
         }
         else
         {
            this.y = stage.stageHeight - this.windowBmp.height >>> 1;
         }
      }
   }
}

