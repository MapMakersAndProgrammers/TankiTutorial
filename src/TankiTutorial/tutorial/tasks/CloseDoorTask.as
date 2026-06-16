package tutorial.tasks
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.physics.Body;
   import tutorial.GameData;
   
   public class CloseDoorTask extends Task
   {
      
      private const qecuhygy:Mesh = GameData.tuce.getObject("door") as Mesh;
      
      private const body:Body = GameData.gov.getBody("Door");
      
      private var vylujuha:Number;
      
      public function CloseDoorTask()
      {
         super();
         this.vylujuha = this.qecuhygy.z;
      }
      
      override public function process() : Boolean
      {
         if(this.qecuhygy.z <= this.vylujuha)
         {
            this.qecuhygy.z = this.vylujuha;
            return true;
         }
         this.qecuhygy.z -= 5;
         if(this.body != null)
         {
            this.body.kejo.position.z -= 5;
         }
         return false;
      }
   }
}

