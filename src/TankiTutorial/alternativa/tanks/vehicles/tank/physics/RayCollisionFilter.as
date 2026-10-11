package alternativa.tanks.vehicles.tank.physics
{
   import alternativa.physics.Body;
   import alternativa.physics.collision.IRayCollisionFilter;
   
   internal class RayCollisionFilter implements IRayCollisionFilter
   {
      
      private var body:Body;
      
      public function RayCollisionFilter(body:Body)
      {
         super();
         this.body = body;
      }
      
      public function considerBody(param1:Body) : Boolean
      {
         return this.body != param1;
      }
   }
}

