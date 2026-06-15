package tutorial.tasks
{
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.geom.ColorTransform;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class TurretChangeTask extends Task
   {
      
      private var jifom:Tank = GameData.jifom;
      
      private var sacoteg:String;
      
      private var fur:ColorTransform = new ColorTransform();
      
      private var qadol:Number = 300;
      
      private var kejo:int = 0;
      
      public function TurretChangeTask(param1:String)
      {
         super();
         this.sacoteg = param1;
         this.jifom.kuca.turretMesh.colorTransform = this.fur;
      }
      
      override public function process() : Boolean
      {
         var _loc1_:TimeData = GameData.lecopojen;
         switch(this.kejo)
         {
            case 0:
               this.fur.redOffset += this.qadol * _loc1_.ziqod;
               this.fur.greenOffset += this.qadol * _loc1_.ziqod;
               this.fur.blueOffset += this.qadol * _loc1_.ziqod;
               if(this.fur.redOffset >= 255)
               {
                  this.kejo = 1;
               }
               break;
            case 1:
               this.jifom.kuca.turretMesh.colorTransform = null;
               this.jifom.setTurret(this.sacoteg);
               this.jifom.kuca.turretMesh.colorTransform = this.fur;
               this.kejo = 2;
               break;
            case 2:
               this.fur.redOffset -= this.qadol * _loc1_.ziqod;
               this.fur.greenOffset -= this.qadol * _loc1_.ziqod;
               this.fur.blueOffset -= this.qadol * _loc1_.ziqod;
               if(this.fur.redOffset <= 0)
               {
                  this.kejo = 3;
                  this.jifom.kuca.turretMesh.colorTransform = null;
                  return true;
               }
         }
         return false;
      }
   }
}

