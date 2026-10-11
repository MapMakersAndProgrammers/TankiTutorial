package alternativa.physics.collision
{
   import alternativa.physics.Body;
   
   public interface IRayCollisionFilter
   {
      
      function considerBody(body:Body) : Boolean;
   }
}

