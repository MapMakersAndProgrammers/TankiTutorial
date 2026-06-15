package tutorial.tasks
{
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class ChangeCameraAngleTask extends Task
   {
      
      private static const nav:Number = 0.05;
      
      private var controller:FollowCameraController = GameData.butefu.controller as FollowCameraController;
      
      private var cejufi:Number;
      
      private var wiciqy:Number;
      
      public function ChangeCameraAngleTask(param1:Number, param2:Number)
      {
         super();
         this.cejufi = param1;
         this.wiciqy = param2;
      }
      
      override public function process() : Boolean
      {
         var _loc1_:FollowCameraController = this.controller;
         var _loc2_:Number = _loc1_.getCameraT() - this.cejufi;
         if(_loc2_ < nav && _loc2_ > -nav)
         {
            _loc1_.setCameraT(this.cejufi);
            return true;
         }
         var _loc3_:TimeData = GameData.lecopojen;
         _loc1_.setCameraT(_loc1_.getCameraT() - _loc2_ * this.wiciqy * _loc3_.ziqod);
         return false;
      }
   }
}

