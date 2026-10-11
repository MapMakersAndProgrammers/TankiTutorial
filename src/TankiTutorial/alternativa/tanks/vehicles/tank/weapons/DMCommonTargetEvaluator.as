package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.physics.Body;
   import alternativa.tanks.vehicles.tank.Tank;
   
   public class DMCommonTargetEvaluator implements CommonTargetEvaluator
   {
      
      public function DMCommonTargetEvaluator()
      {
         super();
      }
      
      public function getTargetPriority(body:Body, distance:Number, angle:Number, maxDistance:Number, maxAngle:Number) : Number
      {
         if(body.data != null && Tank(body.data).currentHealth > 0)
         {
            return CommonTargetEvaluatorConst.MAX_PRIORITY - (CommonTargetEvaluatorConst.DISTANCE_WEIGHT * distance / maxDistance + (1 - CommonTargetEvaluatorConst.DISTANCE_WEIGHT) * angle / maxAngle);
         }
         return 0;
      }
   }
}

