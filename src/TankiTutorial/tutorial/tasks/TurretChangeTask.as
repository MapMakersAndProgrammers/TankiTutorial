package tutorial.tasks
{
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.geom.ColorTransform;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class TurretChangeTask extends Task
   {
      
      private var playerTank:Tank = GameData.playerTank;
      
      private var turretName:String;
      
      private var colorTransform:ColorTransform = new ColorTransform();
      
      private var speed:Number = 300;
      
      private var state:int = 0;
      
      public function TurretChangeTask(turretName:String)
      {
         super();
         this.turretName = turretName;
         this.playerTank.skin.turretMesh.colorTransform = this.colorTransform;
      }
      
      override public function process() : Boolean
      {
         var timeData:TimeData = GameData.time;
         switch(this.state)
         {
            case 0:
               this.colorTransform.redOffset += this.speed * timeData.deltaTime;
               this.colorTransform.greenOffset += this.speed * timeData.deltaTime;
               this.colorTransform.blueOffset += this.speed * timeData.deltaTime;
               if(this.colorTransform.redOffset >= 255)
               {
                  this.state = 1;
               }
               break;
            case 1:
               this.playerTank.skin.turretMesh.colorTransform = null;
               this.playerTank.setTurret(this.turretName);
               this.playerTank.skin.turretMesh.colorTransform = this.colorTransform;
               this.state = 2;
               break;
            case 2:
               this.colorTransform.redOffset -= this.speed * timeData.deltaTime;
               this.colorTransform.greenOffset -= this.speed * timeData.deltaTime;
               this.colorTransform.blueOffset -= this.speed * timeData.deltaTime;
               if(this.colorTransform.redOffset <= 0)
               {
                  this.state = 3;
                  this.playerTank.skin.turretMesh.colorTransform = null;
                  return true;
               }
         }
         return false;
      }
   }
}

