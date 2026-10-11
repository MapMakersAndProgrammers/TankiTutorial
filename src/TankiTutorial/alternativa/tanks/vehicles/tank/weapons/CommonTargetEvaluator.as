package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.physics.Body;
   
   public interface CommonTargetEvaluator
   {
      
      function getTargetPriority(body:Body, distance:Number, angle:Number, maxDistance:Number, maxAngle:Number) : Number;
   }
}

