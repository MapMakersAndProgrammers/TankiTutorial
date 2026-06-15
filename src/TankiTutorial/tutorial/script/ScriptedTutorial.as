package tutorial.script
{
   import alternativa.math.Vector3;
   import tutorial.GameData;
   import tutorial.Tutorial;
   import tutorial.commons.Shared;
   import tutorial.tasks.FrameRateTask;
   
   public class ScriptedTutorial extends Tutorial
   {
      
      private var cofatuzog:Vector.<ScriptStep>;
      
      private var pomagu:XML;
      
      private var zewucadiz:int;
      
      public function ScriptedTutorial(param1:XML)
      {
         super();
         this.pomagu = param1;
         gepocivaj = param1.@name.toString();
      }
      
      override public function getDependencies() : Array
      {
         return this.pomagu.@dependencies.toString().split(",");
      }
      
      override public function start() : void
      {
         var _loc1_:XML = null;
         var _loc2_:ScriptStep = null;
         Shared.tracker.trackEvent(Shared.TUTORIAL,gepocivaj + "_start","");
         super.start();
         this.zewucadiz = 0;
         this.cofatuzog = new Vector.<ScriptStep>();
         for each(_loc1_ in this.pomagu.elements("step"))
         {
            _loc2_ = new ScriptStep(_loc1_);
            if(_loc2_.gepocivaj != "")
            {
               _loc2_.medyq = gepocivaj + ":" + _loc2_.gepocivaj;
            }
            this.cofatuzog.push(_loc2_);
         }
         if(this.cofatuzog.length > 0)
         {
            this.startStep(this.zewucadiz);
         }
         else
         {
            vegetis = true;
         }
      }
      
      override public function moveToNextStep() : void
      {
         ++this.zewucadiz;
         tezivasaf = false;
         if(this.zewucadiz < this.cofatuzog.length)
         {
            this.startStep(this.zewucadiz);
         }
         else
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL,gepocivaj + "_finish",GameData.lecopojen.fps.toFixed(0));
            vegetis = true;
         }
      }
      
      override public function skipStep() : void
      {
         var _loc1_:ScriptStep = null;
         var _loc2_:Vector3 = null;
         this.moveToNextStep();
         if(this.zewucadiz < this.cofatuzog.length)
         {
            _loc1_ = this.cofatuzog[this.zewucadiz];
            _loc2_ = _loc1_.bip;
            if(_loc2_.lengthSqr() > 0)
            {
               GameData.jifom.setPosition(_loc2_);
            }
            else
            {
               this.skipStep();
            }
         }
      }
      
      private function startStep(param1:int) : void
      {
         var _loc2_:ScriptStep = this.cofatuzog[param1];
         if(_loc2_.medyq != "")
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL,_loc2_.medyq,"");
            Shared.tracker.trackEvent(Shared.TUTORIAL_STAT,_loc2_.medyq + "_fps" + FrameRateTask.getMode(),GameData.lecopojen.fps.toFixed(0));
            Shared.tracker.trackEvent(Shared.TUTORIAL_STAT,"fps" + FrameRateTask.getMode(),GameData.lecopojen.fps.toFixed(0));
            Shared.currentStep = _loc2_.medyq;
         }
         _loc2_.start(this.onFinishStep);
      }
      
      private function onFinishStep() : void
      {
         tezivasaf = true;
      }
   }
}

