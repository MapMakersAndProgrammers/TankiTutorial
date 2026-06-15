package tutorial.tasks
{
   import alternativa.Alternativa3D;
   import flash.display.Stage;
   import flash.display.StageQuality;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class FrameRateTask extends Task
   {
      
      private static const hes:Number = 60;
      
      private static const vypofamo:Number = 40;
      
      private static const dak:int = 10;
      
      private static const benysaqoq:int = 5;
      
      private var stage:Stage = GameData.stage;
      
      private var peqiru:int;
      
      private var kycakone:int;
      
      private var foha:Number;
      
      private var zyzif:String;
      
      public function FrameRateTask()
      {
         super();
         this.setMaxFrameRate();
         this.saveStageParams();
         this.setInitialStageParams();
      }
      
      public static function getMode() : String
      {
         if(Alternativa3D.mawoqu == "7.11.0")
         {
            return GameData.butefu.view.constrained ? "GPU_constrained" : "GPU";
         }
         return "CPU";
      }
      
      private function saveStageParams() : void
      {
         this.foha = this.stage.frameRate;
         this.zyzif = this.stage.quality;
      }
      
      private function setInitialStageParams() : void
      {
         this.stage.frameRate = this.peqiru;
         if(Alternativa3D.mawoqu == "7.11.0")
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
         this.stage.frameRate = this.foha;
         this.stage.quality = this.zyzif;
      }
      
      private function setMaxFrameRate() : void
      {
         if(Alternativa3D.mawoqu == "7.11.0")
         {
            this.peqiru = hes;
         }
         else
         {
            this.peqiru = vypofamo;
         }
      }
      
      override public function process() : Boolean
      {
         ++this.kycakone;
         if(this.kycakone == benysaqoq)
         {
            this.kycakone = 0;
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
         var _loc1_:TimeData = GameData.lecopojen;
         return _loc1_.fps < this.stage.frameRate - 4;
      }
      
      private function decreaseStageFrameRate() : void
      {
         var _loc1_:TimeData = GameData.lecopojen;
         this.stage.frameRate = _loc1_.fps < dak ? dak : _loc1_.fps;
      }
      
      private function increaseStageFrameRate() : void
      {
         var _loc1_:Number = this.stage.frameRate + 1;
         this.stage.frameRate = _loc1_ > this.peqiru ? this.peqiru : _loc1_;
      }
   }
}

