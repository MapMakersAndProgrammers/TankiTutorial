package alternativa.tanks.vehicles.tank
{
   public interface ValueSmoother
   {
      
      function reset(value:Number) : void;
      
      function update(dt:Number) : Number;
      
      function setTargetValue(value:Number) : void;
      
      function getTargetValue() : Number;
   }
}

