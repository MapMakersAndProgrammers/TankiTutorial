package alternativa.tanks.battle
{
   import alternativa.physics.collision.CollisionDetector;
   
   public interface BattleRunner
   {
      
      function addPhysicsController(controller:PhysicsController) : void;
      
      function removePhysicsController(controller:PhysicsController) : void;
      
      function addPhysicsInterpolator(interpolator:PhysicsInterpolator) : void;
      
      function removePhysicsInterpolator(interpolator:PhysicsInterpolator) : void;
      
      function addTrigger(trigger:Trigger) : void;
      
      function removeTrigger(trigger:Trigger) : void;
      
      function getCollisionDetector() : CollisionDetector;
   }
}

