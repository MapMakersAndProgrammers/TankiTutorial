package alternativa.tanks.vehicles.tank.controllers
{
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.events.IEventDispatcher;
   import flash.utils.getTimer;
   import tutorial.GameData;
   
   public class RecordTankController extends UserTankController
   {
      
      private var prevControlState:int;
      
      private var recording:Boolean = false;
      
      private var record:String;
      
      private var time:uint;
      
      public function RecordTankController(param1:IEventDispatcher, param2:Tank)
      {
         super(param1,param2);
      }
      
      public function getRecord() : String
      {
         return this.record;
      }
      
      public function startRecording() : void
      {
         this.recording = true;
         this.record = "";
         this.time = getTimer();
      }
      
      public function stopRecording() : void
      {
         this.recording = false;
      }
      
      public function isRecording() : Boolean
      {
         return this.recording;
      }
      
      override public function startAction(action:int) : void
      {
         super.startAction(action);
         if(this.recording && this.prevControlState != controlState)
         {
            this.makeRecord();
         }
         this.prevControlState = controlState;
      }
      
      override public function stopAction(action:int) : void
      {
         super.stopAction(action);
         if(this.recording && this.prevControlState != controlState)
         {
            this.makeRecord();
         }
         this.prevControlState = controlState;
      }
      
      override public function setAction(param1:int) : void
      {
         super.setAction(param1);
         if(this.recording && this.prevControlState != controlState)
         {
            this.makeRecord();
         }
         this.prevControlState = controlState;
      }
      
      override public function update(param1:int, deltaTime:int, param3:Number) : void
      {
         if(!(GameData.camera.controller is SpectatorCameraController))
         {
            super.update(param1,deltaTime,param3);
         }
      }
      
      private function makeRecord() : void
      {
         var now:uint = uint(getTimer());
         var delta:uint = now - this.time;
         this.time = now;
         var entry:String = " " + controlState.toString() + " " + delta.toString();
         this.record += entry;
      }
   }
}

