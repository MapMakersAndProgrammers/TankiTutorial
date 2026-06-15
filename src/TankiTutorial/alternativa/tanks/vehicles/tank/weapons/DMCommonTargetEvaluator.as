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
      
      public function getTargetPriority(param1:Body, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         if(param1.katuf != null && Tank(param1.katuf).currentHealth > 0)
         {
            return CommonTargetEvaluatorConst.hosonam - (CommonTargetEvaluatorConst.dihipa * param2 / param4 + (1 - CommonTargetEvaluatorConst.dihipa) * param3 / param5);
         }
         return 0;
      }
   }
}

