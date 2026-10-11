package tutorial
{
   import flash.utils.getTimer;
   
   public class TimeData
   {
      
      private static const AVERAGE_FRAMES:int = 10;
      
      public var time:uint;
      
      public var deltaTimeMs:uint;
      
      public var deltaTime:Number;
      
      private var _averageTimeInMs:Number;
      
      private var _fps:Number;
      
      private var _minFPS:Number;
      
      private var _maxFPS:Number;
      
      private var _totalFrames:int;
      
      private var frameCounter:int;
      
      private var startTime:int;
      
      private var lastAverageTime:int;
      
      public function TimeData()
      {
         super();
         this.time = getTimer();
         this.deltaTimeMs = 0;
         this.deltaTime = 0;
         this.reset();
      }
      
      public function calculate() : void
      {
         var currentTime:uint = uint(getTimer());
         this.deltaTimeMs = currentTime - this.time;
         this.deltaTime = this.deltaTimeMs * 0.001;
         this.time = currentTime;
         this.increaseFrameCounters();
         if(this.shoudCalculateAverageValues(this.time))
         {
            this.calculateAverageValues(this.time);
            this.updateMinMaxFPSValues();
            this.lastAverageTime = this.time;
         }
      }
      
      public function get averageTimeInMs() : Number
      {
         return this._averageTimeInMs;
      }
      
      public function get fps() : Number
      {
         return this._fps;
      }
      
      public function get minFPS() : Number
      {
         return this._minFPS;
      }
      
      public function get maxFPS() : Number
      {
         return this._maxFPS;
      }
      
      public function getAverageFPS() : Number
      {
         return 1000 / (this.lastAverageTime - this.startTime) * this._totalFrames;
      }
      
      public function get totalFrames() : int
      {
         return this._totalFrames;
      }
      
      public function get totalTime() : int
      {
         return this.lastAverageTime - this.startTime;
      }
      
      public function reset() : void
      {
         this.frameCounter = 0;
         this._averageTimeInMs = 0;
         this._fps = 100;
         this._minFPS = 100;
         this._maxFPS = 0;
         this._totalFrames = 0;
         this.startTime = getTimer();
         this.lastAverageTime = this.startTime;
      }
      
      private function increaseFrameCounters() : void
      {
         ++this._totalFrames;
         ++this.frameCounter;
      }
      
      private function shoudCalculateAverageValues(currentTime:int) : Boolean
      {
         return this.frameCounter >= AVERAGE_FRAMES && currentTime > this.lastAverageTime;
      }
      
      private function calculateAverageValues(currentTime:int) : void
      {
         this._averageTimeInMs = (currentTime - this.lastAverageTime) / this.frameCounter;
         this._fps = 1000 / this._averageTimeInMs;
         this.frameCounter = 0;
      }
      
      private function updateMinMaxFPSValues() : void
      {
         this._minFPS = Math.min(this._minFPS,this._fps);
         this._maxFPS = Math.max(this._maxFPS,this._fps);
      }
   }
}

