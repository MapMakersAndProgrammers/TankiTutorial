package tutorial.tasks
{
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.geom.ColorTransform;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class HullChangeTask extends Task
   {
      
      private var playerTank:Tank = GameData.playerTank;
      
      private var hullName:String;
      
      private var colorTransform:ColorTransform = new ColorTransform();
      
      private var speed:Number = 300;
      
      private var state:int = 0;
      
      public function HullChangeTask(hullName:String)
      {
         super();
         this.hullName = hullName;
         this.playerTank.kuca.hullMesh.colorTransform = this.colorTransform;
      }
      
      override public function process() : Boolean
      {
         var dimensions:Vector3 = null;
         var halfHeight:Number = NaN;
         var timeData:TimeData = GameData.time;
         var delta:Number = this.speed * timeData.deltaTime;
         switch(this.state)
         {
            case 0:
               this.colorTransform.redOffset += delta;
               this.colorTransform.greenOffset += delta;
               this.colorTransform.blueOffset += delta;
               if(this.colorTransform.redOffset >= 255)
               {
                  this.state = 1;
               }
               break;
            case 1:
               this.playerTank.kuca.hullMesh.colorTransform = null;
               dimensions = this.playerTank.kuca.getHull().getSkinDimensions();
               halfHeight = dimensions.z * 0.5;
               this.playerTank.setHull(this.hullName);
               this.playerTank.hogys.body.state.position.z += dimensions.z * 0.5 - halfHeight;
               this.playerTank.hogys.body.saveState();
               this.playerTank.kuca.hullMesh.colorTransform = this.colorTransform;
               this.state = 2;
               break;
            case 2:
               this.colorTransform.redOffset -= delta;
               this.colorTransform.greenOffset -= delta;
               this.colorTransform.blueOffset -= delta;
               if(this.colorTransform.redOffset <= 0)
               {
                  this.state = 3;
                  this.playerTank.kuca.hullMesh.colorTransform = null;
                  return true;
               }
         }
         return false;
      }
   }
}

