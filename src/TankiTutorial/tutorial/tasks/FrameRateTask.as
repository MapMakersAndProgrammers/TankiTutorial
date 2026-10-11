package tutorial.tasks
{
   import alternativa.Alternativa3D;
   import flash.display.Stage;
   import flash.display.StageQuality;
   import tutorial.GameData;
   import tutorial.TimeData;
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;

   public class FrameRateTask extends Task
   {
      
      private static const GPU_MAX_FRAME_RATE:Number = 60;
      
      private static const CPU_MAX_FRAME_RATE:Number = 40;
      
      private static const MIN_FRAME_RATE:int = 10;
      
      private static const CHECK_PERIOD:int = 5;
      
      private var stage:Stage = GameData.stage;
      
      private var maxFrameRate:int;
      
      private var frameCounter:int;
      
      private var savedFrameRate:Number;
      
      private var savedQuality:String;
      
      public function FrameRateTask()
      {
         super();
         this.setMaxFrameRate();
         this.saveStageParams();
         this.setInitialStageParams();
      }
      
      public static function getMode() : String
      {
         if(Alternativa3D.version == "7.11.0")
         {
            return GameData.camera.view.constrained ? "GPU_constrained" : "GPU";
         }
         return "CPU";
      }
      
      private function saveStageParams() : void
      {
         this.savedFrameRate = this.stage.frameRate;
         this.savedQuality = this.stage.quality;
      }
      
      private function setInitialStageParams() : void
      {
         this.stage.frameRate = this.maxFrameRate;
         if(Alternativa3D.version == "7.11.0")
         {
            this.stage.quality = StageQuality.MEDIUM;
         }
         else
         {
            this.stage.quality = StageQuality.LOW;
         }
      }
      
      public function restoreStageParams() : void
      {
         this.stage.frameRate = this.savedFrameRate;
         this.stage.quality = this.savedQuality;
      }
      
      private function setMaxFrameRate() : void
      {
         if(Alternativa3D.version == "7.11.0")
         {
            this.maxFrameRate = GPU_MAX_FRAME_RATE;
         }
         else
         {
            this.maxFrameRate = CPU_MAX_FRAME_RATE;
         }
      }
      
      override public function process() : Boolean
      {
         ++this.frameCounter;
         if(this.frameCounter == CHECK_PERIOD)
         {
            this.frameCounter = 0;
            if(this.currentFpsIsTooLow())
            {
               this.decreaseStageFrameRate();
            }
            else
            {
               this.increaseStageFrameRate();
            }
         }
         return false;
      }
      
      private function currentFpsIsTooLow() : Boolean
      {
         var timeData:TimeData = GameData.time;
         return timeData.fps < this.stage.frameRate - 4;
      }
      
      private function decreaseStageFrameRate() : void
      {
         var timeData:TimeData = GameData.time;
         this.stage.frameRate = timeData.fps < MIN_FRAME_RATE ? MIN_FRAME_RATE : timeData.fps;
      }
      
      private function increaseStageFrameRate() : void
      {
         var frameRate:Number = this.stage.frameRate + 1;
         this.stage.frameRate = frameRate > this.maxFrameRate ? this.maxFrameRate : frameRate;
      }
   }
}

