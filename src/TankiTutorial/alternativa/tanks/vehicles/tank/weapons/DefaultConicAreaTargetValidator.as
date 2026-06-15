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
      
      public function isValidTarget(param1:Body) : Boolean
      {
         var _loc2_:Tank = param1.katuf as Tank;
         return _loc2_ != null && _loc2_.currentHealth > 0;
      }
   }
}

