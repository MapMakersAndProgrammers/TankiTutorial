package alternativa.tanks.battle
{
   import alternativa.physics.collision.CollisionDetector;
   
   public interface BattleRunner
   {
      
      function addPhysicsController(param1:PhysicsController) : void;
      
      function removePhysicsController(param1:PhysicsController) : void;
      
      function addPhysicsInterpolator(param1:PhysicsInterpolator) : void;
      
      function removePhysicsInterpolator(param1:PhysicsInterpolator) : void;
      
      function addTrigger(param1:Trigger) : void;
      
      function removeTrigger(param1:Trigger) : void;
      
      function getCollisionDetector() : CollisionDetector;
   }
}

