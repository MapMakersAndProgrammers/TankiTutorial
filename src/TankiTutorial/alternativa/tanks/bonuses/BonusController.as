package alternativa.tanks.bonuses
{
   public interface BonusController
   {
      
      function start() : void;
      
      function runBeforePhysicsUpdate(dt:Number) : void;
      
      function interpolatePhysicsState(t:Number) : void;
      
      function render() : void;
   }
}

