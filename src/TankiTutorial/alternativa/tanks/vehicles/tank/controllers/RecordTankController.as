package alternativa.tanks.vehicles.tank.controllers
{
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.events.IEventDispatcher;
   import flash.utils.getTimer;
   import tutorial.GameData;
   
   public class RecordTankController extends UserTankController
   {
      
      private var fof:int;
      
      private var ruwi:Boolean = false;
      
      private var fod:String;
      
      private var lecopojen:uint;
      
      public function RecordTankController(param1:IEventDispatcher, param2:Tank)
      {
         super(param1,param2);
      }
      
      public function getRecord() : String
      {
         return this.fod;
      }
      
      public function startRecording() : void
      {
         this.ruwi = true;
         this.fod = "";
         this.lecopojen = getTimer();
      }
      
      public function stopRecording() : void
      {
         this.ruwi = false;
      }
      
      public function isRecording() : Boolean
      {
         return this.ruwi;
      }
      
      override public function startAction(param1:int) : void
      {
         super.startAction(param1);
         if(this.ruwi && this.fof != ses)
         {
            this.makeRecord();
         }
         this.fof = ses;
      }
      
      override public function stopAction(param1:int) : void
      {
         super.stopAction(param1);
         if(this.ruwi && this.fof != ses)
         {
            this.makeRecord();
         }
         this.fof = ses;
      }
      
      override public function setAction(param1:int) : void
      {
         super.setAction(param1);
         if(this.ruwi && this.fof != ses)
         {
            this.makeRecord();
         }
         this.fof = ses;
      }
      
      override public function update(param1:int, param2:int, param3:Number) : void
      {
         if(!(GameData.butefu.controller is SpectatorCameraController))
         {
            super.update(param1,param2,param3);
         }
      }
      
      private function makeRecord() : void
      {
         var _loc1_:uint = uint(getTimer());
         var _loc2_:uint = _loc1_ - this.lecopojen;
         this.lecopojen = _loc1_;
         var _loc3_:String = " " + ses.toString() + " " + _loc2_.toString();
         this.fod += _loc3_;
      }
   }
}

