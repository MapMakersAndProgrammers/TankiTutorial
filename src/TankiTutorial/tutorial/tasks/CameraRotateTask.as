package tutorial.tasks
{
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class CameraRotateTask extends Task
   {
      
      private static const mipid:Number = 0.1;
      
      private var angle:Number;
      
      private var cameraT:Number;
      
      public function CameraRotateTask()
      {
         super();
         this.angle = 0;
         this.cameraT = (GameData.camera.controller as FollowCameraController).getCameraT();
      }
      
      override public function process() : Boolean
      {
         var timeData:TimeData = null;
         var t:Number = NaN;
         var controller:FollowCameraController = GameData.camera.controller as FollowCameraController;
         if(this.angle == 0)
         {
            GameData.playerTank.userTitle.hide();
         }
         if(controller != null)
         {
            GameData.playerTank.lockMovement();
            GameData.playerTank.turretController.lock(1);
            timeData = GameData.time;
            this.angle += timeData.deltaTime * 1.5;
            controller.angle = this.angle;
            if(this.angle > Math.PI)
            {
               t = this.angle - Math.PI;
            }
            else
            {
               t = Math.PI - this.angle;
            }
            t /= Math.PI;
            controller.setCameraT(this.cameraT * (t * (1 - mipid) + mipid));
            controller.heightOffset = -150 * (1 - t);
            if(this.angle > Math.PI * 2)
            {
               controller.angle = 0;
               controller.setCameraT(this.cameraT);
               GameData.playerTank.unlockMovement();
               controller.heightOffset = 0;
               GameData.playerTank.turretController.unlock(1);
               GameData.playerTank.userTitle.show();
               return true;
            }
         }
         return false;
      }
   }
}

