package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.physics.Body;
   
   public interface ConicAreaTargetValidator
   {
      
      function isValidTarget(body:Body) : Boolean;
   }
}

