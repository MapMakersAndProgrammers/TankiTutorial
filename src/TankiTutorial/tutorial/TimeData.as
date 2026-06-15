package tutorial
{
   import flash.utils.getTimer;
   
   public class TimeData
   {
      
      private static const qawyzeby:int = 10;
      
      public var lecopojen:uint;
      
      public var rud:uint;
      
      public var ziqod:Number;
      
      private var sirali:Number;
      
      private var gymut:Number;
      
      private var cyhyfu:Number;
      
      private var suguhoror:Number;
      
      private var ruhisa:int;
      
      private var cawicozy:int;
      
      private var pekup:int;
      
      private var cifytotis:int;
      
      public function TimeData()
      {
         super();
         this.lecopojen = getTimer();
         this.rud = 0;
         this.ziqod = 0;
         this.reset();
      }
      
      public function calculate() : void
      {
         var _loc1_:uint = uint(getTimer());
         this.rud = _loc1_ - this.lecopojen;
         this.ziqod = this.rud * 0.001;
         this.lecopojen = _loc1_;
         this.increaseFrameCounters();
         if(this.shoudCalculateAverageValues(this.lecopojen))
         {
            this.calculateAverageValues(this.lecopojen);
            this.updateMinMaxFPSValues();
            this.cifytotis = this.lecopojen;
         }
      }
      
      public function get averageTimeInMs() : Number
      {
         return this.sirali;
      }
      
      public function get fps() : Number
      {
         return this.gymut;
      }
      
      public function get minFPS() : Number
      {
         return this.cyhyfu;
      }
      
      public function get maxFPS() : Number
      {
         return this.suguhoror;
      }
      
      public function getAverageFPS() : Number
      {
         return 1000 / (this.cifytotis - this.pekup) * this.ruhisa;
      }
      
      public function get totalFrames() : int
      {
         return this.ruhisa;
      }
      
      public function get totalTime() : int
      {
         return this.cifytotis - this.pekup;
      }
      
      public function reset() : void
      {
         this.cawicozy = 0;
         this.sirali = 0;
         this.gymut = 100;
         this.cyhyfu = 100;
         this.suguhoror = 0;
         this.ruhisa = 0;
         this.pekup = getTimer();
         this.cifytotis = this.pekup;
      }
      
      private function increaseFrameCounters() : void
      {
         ++this.ruhisa;
         ++this.cawicozy;
      }
      
      private function shoudCalculateAverageValues(param1:int) : Boolean
      {
         return this.cawicozy >= qawyzeby && param1 > this.cifytotis;
      }
      
      private function calculateAverageValues(param1:int) : void
      {
         this.sirali = (param1 - this.cifytotis) / this.cawicozy;
         this.gymut = 1000 / this.sirali;
         this.cawicozy = 0;
      }
      
      private function updateMinMaxFPSValues() : void
      {
         this.cyhyfu = Math.min(this.cyhyfu,this.gymut);
         this.suguhoror = Math.max(this.suguhoror,this.gymut);
      }
   }
}

