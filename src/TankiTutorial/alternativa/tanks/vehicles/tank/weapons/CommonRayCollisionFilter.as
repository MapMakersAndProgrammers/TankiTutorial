package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.physics.Body;
   import alternativa.physics.collision.IRayCollisionFilter;
   
   public class CommonRayCollisionFilter implements IRayCollisionFilter
   {
      
      public var excludedBody:Body;
      
      public function CommonRayCollisionFilter()
      {
         super();
      }
      
      public function considerBody(body:Body) : Boolean
      {
         return this.excludedBody != body;
      }
   }
}

