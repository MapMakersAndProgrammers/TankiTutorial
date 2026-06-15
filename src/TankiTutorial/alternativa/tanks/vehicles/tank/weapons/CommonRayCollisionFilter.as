package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.physics.Body;
   import alternativa.physics.collision.IRayCollisionFilter;
   
   public class CommonRayCollisionFilter implements IRayCollisionFilter
   {
      
      public var bowe:Body;
      
      public function CommonRayCollisionFilter()
      {
         super();
      }
      
      public function considerBody(param1:Body) : Boolean
      {
         return this.bowe != param1;
      }
   }
}

