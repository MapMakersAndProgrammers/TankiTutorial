package tutorial.tasks
{
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class CameraRotateTask extends Task
   {
      
      private static const mipid:Number = 0.1;
      
      private var dodycoli:Number;
      
      private var cipa:Number;
      
      public function CameraRotateTask()
      {
         super();
         this.dodycoli = 0;
         this.cipa = (GameData.butefu.controller as FollowCameraController).getCameraT();
      }
      
      override public function process() : Boolean
      {
         var _loc2_:TimeData = null;
         var _loc3_:Number = NaN;
         var _loc1_:FollowCameraController = GameData.butefu.controller as FollowCameraController;
         if(this.dodycoli == 0)
         {
            GameData.jifom.kakow.hide();
         }
         if(_loc1_ != null)
         {
            GameData.jifom.lockMovement();
            GameData.jifom.turretController.lock(1);
            _loc2_ = GameData.lecopojen;
            this.dodycoli += _loc2_.ziqod * 1.5;
            _loc1_.qusejov = this.dodycoli;
            if(this.dodycoli > Math.PI)
            {
               _loc3_ = this.dodycoli - Math.PI;
            }
            else
            {
               _loc3_ = Math.PI - this.dodycoli;
            }
            _loc3_ /= Math.PI;
            _loc1_.setCameraT(this.cipa * (_loc3_ * (1 - mipid) + mipid));
            _loc1_.bifejizi = -150 * (1 - _loc3_);
            if(this.dodycoli > Math.PI * 2)
            {
               _loc1_.qusejov = 0;
               _loc1_.setCameraT(this.cipa);
               GameData.jifom.unlockMovement();
               _loc1_.bifejizi = 0;
               GameData.jifom.turretController.unlock(1);
               GameData.jifom.kakow.show();
               return true;
            }
         }
         return false;
      }
   }
}

