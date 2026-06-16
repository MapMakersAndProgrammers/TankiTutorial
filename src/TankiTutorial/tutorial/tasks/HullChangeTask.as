package tutorial.tasks
{
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.geom.ColorTransform;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class HullChangeTask extends Task
   {
      
      private var jifom:Tank = GameData.jifom;
      
      private var qyjosezir:String;
      
      private var fur:ColorTransform = new ColorTransform();
      
      private var qadol:Number = 300;
      
      private var kejo:int = 0;
      
      public function HullChangeTask(param1:String)
      {
         super();
         this.qyjosezir = param1;
         this.jifom.kuca.hullMesh.colorTransform = this.fur;
      }
      
      override public function process() : Boolean
      {
         var _loc3_:Vector3 = null;
         var _loc4_:Number = NaN;
         var _loc1_:TimeData = GameData.lecopojen;
         var _loc2_:Number = this.qadol * _loc1_.ziqod;
         switch(this.kejo)
         {
            case 0:
               this.fur.redOffset += _loc2_;
               this.fur.greenOffset += _loc2_;
               this.fur.blueOffset += _loc2_;
               if(this.fur.redOffset >= 255)
               {
                  this.kejo = 1;
               }
               break;
            case 1:
               this.jifom.kuca.hullMesh.colorTransform = null;
               _loc3_ = this.jifom.kuca.getHull().getSkinDimensions();
               _loc4_ = _loc3_.z * 0.5;
               this.jifom.setHull(this.qyjosezir);
               this.jifom.hogys.body.kejo.position.z += _loc3_.z * 0.5 - _loc4_;
               this.jifom.hogys.body.saveState();
               this.jifom.kuca.hullMesh.colorTransform = this.fur;
               this.kejo = 2;
               break;
            case 2:
               this.fur.redOffset -= _loc2_;
               this.fur.greenOffset -= _loc2_;
               this.fur.blueOffset -= _loc2_;
               if(this.fur.redOffset <= 0)
               {
                  this.kejo = 3;
                  this.jifom.kuca.hullMesh.colorTransform = null;
                  return true;
               }
         }
         return false;
      }
   }
}

