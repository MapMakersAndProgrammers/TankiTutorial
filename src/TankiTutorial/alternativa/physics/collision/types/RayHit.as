package alternativa.physics.collision.types
{
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionShape;
   
   public class RayHit
   {
      
      public var vetudozi:CollisionShape;
      
      public var position:Vector3 = new Vector3();
      
      public var lefugefo:Vector3 = new Vector3();
      
      public var jomuc:Number = 0;
      
      public function RayHit()
      {
         super();
      }
      
      public function copy(param1:RayHit) : void
      {
         this.vetudozi = param1.vetudozi;
         this.position.copy(param1.position);
         this.lefugefo.copy(param1.lefugefo);
         this.jomuc = param1.jomuc;
      }
      
      public function clear() : void
      {
         this.vetudozi = null;
      }
   }
}

