package alternativa.physics.collision
{
   import alternativa.physics.Body;
   
   public interface BodyCollisionFilter
   {
      
      function considerBodies(body1:Body, body2:Body) : Boolean;
   }
}

