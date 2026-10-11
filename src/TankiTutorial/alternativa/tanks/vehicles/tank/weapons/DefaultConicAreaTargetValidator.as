package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.physics.Body;
   import alternativa.tanks.vehicles.tank.Tank;
   
   public class DefaultConicAreaTargetValidator implements ConicAreaTargetValidator
   {
      
      public function DefaultConicAreaTargetValidator()
      {
         super();
      }
      
      public function isValidTarget(body:Body) : Boolean
      {
         var tank:Tank = body.data as Tank;
         return tank != null && tank.currentHealth > 0;
      }
   }
}

