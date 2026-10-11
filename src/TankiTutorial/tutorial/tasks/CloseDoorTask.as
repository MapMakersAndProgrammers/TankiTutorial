package tutorial.tasks
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.physics.Body;
   import tutorial.GameData;
   
   public class CloseDoorTask extends Task
   {
      
      private const door:Mesh = GameData.scene.getObject("door") as Mesh;
      
      private const body:Body = GameData.physicsScene.getBody("Door");
      
      private var initialZ:Number;
      
      public function CloseDoorTask()
      {
         super();
         this.initialZ = this.door.z;
      }
      
      override public function process() : Boolean
      {
         if(this.door.z <= this.initialZ)
         {
            this.door.z = this.initialZ;
            return true;
         }
         this.door.z -= 5;
         if(this.body != null)
         {
            this.body.state.position.z -= 5;
         }
         return false;
      }
   }
}

