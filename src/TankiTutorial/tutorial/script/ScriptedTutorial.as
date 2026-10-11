package tutorial.script
{
   import alternativa.math.Vector3;
   import tutorial.GameData;
   import tutorial.Tutorial;
   import tutorial.commons.Shared;
   import tutorial.tasks.FrameRateTask;
   
   public class ScriptedTutorial extends Tutorial
   {
      
      private var steps:Vector.<ScriptStep>;
      
      private var xml:XML;
      
      private var current:int;
      
      public function ScriptedTutorial(xml:XML)
      {
         super();
         this.xml = xml;
         name = xml.@name.toString();
      }
      
      override public function getDependencies() : Array
      {
         return this.xml.@dependencies.toString().split(",");
      }
      
      override public function start() : void
      {
         var stepXML:XML = null;
         var step:ScriptStep = null;
         Shared.tracker.trackEvent(Shared.TUTORIAL,name + "_start","");
         super.start();
         this.current = 0;
         this.steps = new Vector.<ScriptStep>();
         for each(stepXML in this.xml.elements("step"))
         {
            step = new ScriptStep(stepXML);
            if(step.name != "")
            {
               step.fullName = name + ":" + step.name;
            }
            this.steps.push(step);
         }
         if(this.steps.length > 0)
         {
            this.startStep(this.current);
         }
         else
         {
            _finished = true;
         }
      }
      
      override public function moveToNextStep() : void
      {
         ++this.current;
         _stepFinished = false;
         if(this.current < this.steps.length)
         {
            this.startStep(this.current);
         }
         else
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL,name + "_finish",GameData.time.fps.toFixed(0));
            _finished = true;
         }
      }
      
      override public function skipStep() : void
      {
         var step:ScriptStep = null;
         var position:Vector3 = null;
         this.moveToNextStep();
         if(this.current < this.steps.length)
         {
            step = this.steps[this.current];
            position = step.position;
            if(position.lengthSqr() > 0)
            {
               GameData.playerTank.setPosition(position);
            }
            else
            {
               this.skipStep();
            }
         }
      }
      
      private function startStep(index:int) : void
      {
         var step:ScriptStep = this.steps[index];
         if(step.fullName != "")
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL,step.fullName,"");
            Shared.tracker.trackEvent(Shared.TUTORIAL_STAT,step.fullName + "_fps" + FrameRateTask.getMode(),GameData.time.fps.toFixed(0));
            Shared.tracker.trackEvent(Shared.TUTORIAL_STAT,"fps" + FrameRateTask.getMode(),GameData.time.fps.toFixed(0));
            Shared.currentStep = step.fullName;
         }
         step.start(this.onFinishStep);
      }
      
      private function onFinishStep() : void
      {
         _stepFinished = true;
      }
   }
}

