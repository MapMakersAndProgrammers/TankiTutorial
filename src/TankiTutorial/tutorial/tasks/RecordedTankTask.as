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
      
      private var jireky:Vector.<uint>;
      
      private var pas:int;
      
      private var tatobuku:Boolean;
      
      public function RecordedTankTask(param1:String, param2:String, param3:String, param4:Vector3, param5:Quaternion, param6:Vector.<uint>, param7:Number = 0, param8:Number = 1, param9:Function = null, param10:uint = 3000)
      {
         super(param1,param2,param3,param4,param5,param7,param8,param9,param10);
         this.jireky = param6;
         this.tatobuku = false;
      }
      
      override protected function onExecute() : void
      {
         if(!this.tatobuku)
         {
            this.nextAction();
            this.tatobuku = true;
         }
      }
      
      private function nextAction() : void
      {
         var _loc1_:uint = 0;
         if(this.pas < this.jireky.length)
         {
            _loc1_ = this.jireky[int(this.pas + 1)];
            setTimeout(this.executeAction,_loc1_);
         }
         else if(kejo < hukozi)
         {
            kejo = cenebah;
         }
      }
      
      private function executeAction() : void
      {
         var _loc1_:TimeData = GameData.lecopojen;
         CommonTankController(controller).setAction(this.jireky[this.pas] | tryShoot(_loc1_.lecopojen));
         this.pas += 2;
         this.nextAction();
      }
   }
}

