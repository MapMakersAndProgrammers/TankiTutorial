package alternativa.physics.collision.types
{
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionShape;
   
   public class RayHit
   {
      
      public var shape:CollisionShape;
      
      public var position:Vector3 = new Vector3();
      
      public var normal:Vector3 = new Vector3();
      
      public var time:Number = 0;
      
      public function RayHit()
      {
         super();
      }
      
      public function copy(src:RayHit) : void
      {
         this.shape = src.shape;
         this.position.copy(src.position);
         this.normal.copy(src.normal);
         this.time = src.time;
      }
      
      public function clear() : void
      {
         this.shape = null;
      }
   }
}

