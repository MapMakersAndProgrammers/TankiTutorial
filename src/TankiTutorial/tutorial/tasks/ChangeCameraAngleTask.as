package tutorial.tasks
{
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class ChangeCameraAngleTask extends Task
   {
      
      private static const nav:Number = 0.05;
      
      private var controller:FollowCameraController = GameData.camera.controller as FollowCameraController;
      
      private var targetCameraT:Number;
      
      private var speed:Number;
      
      public function ChangeCameraAngleTask(targetCameraT:Number, speed:Number)
      {
         super();
         this.targetCameraT = targetCameraT;
         this.speed = speed;
      }
      
      override public function process() : Boolean
      {
         var cameraController:FollowCameraController = this.controller;
         var delta:Number = cameraController.getCameraT() - this.targetCameraT;
         if(delta < nav && delta > -nav)
         {
            cameraController.setCameraT(this.targetCameraT);
            return true;
         }
         var timeData:TimeData = GameData.time;
         cameraController.setCameraT(cameraController.getCameraT() - delta * this.speed * timeData.deltaTime);
         return false;
      }
   }
}

