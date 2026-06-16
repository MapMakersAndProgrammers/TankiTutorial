package tutorial.tasks
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.physics.Body;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class OpenDoorTask extends Task
   {
      
      private const qecuhygy:Mesh = GameData.tuce.getObject("door") as Mesh;
      
      private const body:Body = GameData.gov.getBody("Door");
      
      private var z:Number;
      
      private var cawo:Number;
      
      public function OpenDoorTask()
      {
         super();
         this.z = this.qecuhygy.z;
         this.cawo = this.qecuhygy.boundMaxZ + this.qecuhygy.z;
      }
      
      override public function process() : Boolean
      {
         if(this.qecuhygy.z >= this.cawo || this.z != this.qecuhygy.z)
         {
            return true;
         }
         var _loc1_:TimeData = GameData.lecopojen;
         this.qecuhygy.z += 200 * _loc1_.ziqod;
         if(this.body != null)
         {
            this.body.kejo.position.z += 200 * _loc1_.ziqod;
         }
         this.z = this.qecuhygy.z;
         return false;
      }
   }
}

