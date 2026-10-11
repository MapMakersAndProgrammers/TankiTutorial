package tutorial.tasks
{
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.controllers.CommonTankController;
   import flash.utils.setTimeout;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class RecordedTankTask extends CommonEnemyTask
   {
      
      private var record:Vector.<uint>;
      
      private var actionIndex:int;
      
      private var started:Boolean;
      
      public function RecordedTankTask(hull:String, turret:String, color:String, position:Vector3, orientation:Quaternion, record:Vector.<uint>, health:Number = 0, damageMultiplier:Number = 1, callback:Function = null, shootDelay:uint = 3000)
      {
         super(hull,turret,color,position,orientation,health,damageMultiplier,callback,shootDelay);
         this.record = record;
         this.started = false;
      }
      
      override protected function onExecute() : void
      {
         if(!this.started)
         {
            this.nextAction();
            this.started = true;
         }
      }
      
      private function nextAction() : void
      {
         var delay:uint = 0;
         if(this.actionIndex < this.record.length)
         {
            delay = this.record[int(this.actionIndex + 1)];
            setTimeout(this.executeAction,delay);
         }
         else if(state < STATE_DEAD)
         {
            state = STATE_IDLE;
         }
      }
      
      private function executeAction() : void
      {
         var timeData:TimeData = GameData.time;
         CommonTankController(controller).setAction(this.record[this.actionIndex] | tryShoot(timeData.time));
         this.actionIndex += 2;
         this.nextAction();
      }
   }
}

