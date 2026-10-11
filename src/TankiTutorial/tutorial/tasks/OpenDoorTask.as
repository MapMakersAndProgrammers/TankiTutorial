package tutorial.tasks
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.physics.Body;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class OpenDoorTask extends Task
   {
      
      private const door:Mesh = GameData.scene.getObject("door") as Mesh;
      
      private const body:Body = GameData.physicsScene.getBody("Door");
      
      private var z:Number;
      
      private var maxZ:Number;
      
      public function OpenDoorTask()
      {
         super();
         this.z = this.door.z;
         this.maxZ = this.door.boundMaxZ + this.door.z;
      }
      
      override public function process() : Boolean
      {
         if(this.door.z >= this.maxZ || this.z != this.door.z)
         {
            return true;
         }
         var timeData:TimeData = GameData.time;
         this.door.z += 200 * timeData.deltaTime;
         if(this.body != null)
         {
            this.body.state.position.z += 200 * timeData.deltaTime;
         }
         this.z = this.door.z;
         return false;
      }
   }
}

