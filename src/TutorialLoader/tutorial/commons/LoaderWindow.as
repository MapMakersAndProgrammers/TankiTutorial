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
      
      public function LoaderWindow(param1:DisplayObjectContainer)
      {
         super();
         this.layer = param1;
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
      
      public static function createImageFromRGBAndAlpha(param1:BitmapData, param2:BitmapData) : Bitmap
      {
         var _loc3_:Number = param1.width;
         var _loc4_:Number = param1.height;
         var _loc5_:BitmapData = new BitmapData(_loc3_,_loc4_,true,0);
         _loc5_.copyPixels(param1,new Rectangle(0,0,_loc3_,_loc4_),new Point());
         _loc5_.copyChannel(param2,new Rectangle(0,0,_loc3_,_loc4_),new Point(),1,8);
         return new Bitmap(_loc5_);
      }
      
      public function setSize(param1:uint) : void
      {
         this.bytesTotal = param1;
      }
      
      public function reset(param1:String = null) : void
      {
         this.state = param1;
         Shared.clientLog.addLine("loaded: " + this.size.toString());
         this.size = 0;
         this.threshold = THRESHOLD_STEP;
         if(param1 != null)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,"Start" + param1,"");
         }
      }
      
      public function addBytes(param1:uint) : void
      {
         if(this.state == null)
         {
            return;
         }
         this.size += param1;
         while(this.size > this.threshold)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,this.state,int(this.threshold / 1024).toString() + "KB");
            this.threshold += THRESHOLD_STEP;
         }
         this.bytesLoaded += param1;
         this.targetProgress = this.bytesLoaded / this.bytesTotal;
         if(this.targetProgress > 1)
         {
            this.targetProgress = 1;
         }
         var _loc2_:uint = uint(getTimer());
         var _loc3_:uint = uint((_loc2_ - this.startLoadTime) / 1000);
         if(_loc3_ % 5 == 0 && _loc3_ != this.lastDelta)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,this.state + "_loading",_loc3_.toString());
            this.lastDelta = _loc3_;
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
      
      public function showLoaderWindow(param1:Boolean = false) : void
      {
         this.startLoadTime = getTimer();
         this.lastDelta = 0;
         this.onTop = param1;
         if(!this.layer.contains(this))
         {
            this.layer.addChild(this);
            stage.addEventListener(Event.RESIZE,this.align);
            this.align();
            stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.time = getTimer();
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:uint = uint(getTimer());
         var _loc3_:Number = (_loc2_ - this.time) * 0.001;
         this.totalTime += _loc3_;
         this.time = _loc2_;
         if(this.totalTime > 0)
         {
            _loc4_ = this.targetProgress / this.totalTime;
            if(this.currentProgress > 0.8 && this.currentProgress - this.targetProgress > 0.2)
            {
               _loc4_ *= this.progressBrake;
               this.progressBrake *= 0.95;
            }
            _loc5_ = _loc4_ * _loc3_;
            if(_loc5_ < 0.002 && this.currentProgress < 0.1)
            {
               _loc5_ = 0.002;
            }
            if(this.currentProgress < 0.5)
            {
               _loc5_ *= 1.5;
            }
            this.currentProgress += _loc5_;
            if(this.currentProgress > 1)
            {
               this.currentProgress = 1;
            }
            this.bar.setProgress(this.currentProgress);
         }
      }
      
      public function hideLoaderWindow() : void
      {
         var _loc1_:uint = 0;
         if(this.layer.contains(this))
         {
            _loc1_ = uint((getTimer() - this.startLoadTime) / 1000);
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,this.state + "_loadTime",_loc1_.toString());
            stage.removeEventListener(Event.RESIZE,this.align);
            stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            this.layer.removeChild(this);
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
      
      private function align(param1:Event = null) : void
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

