package tutorial
{
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.tanks.battle.BattleRunner;
   import alternativa.tanks.battle.PhysicsController;
   import alternativa.tanks.battle.PhysicsInterpolator;
   import alternativa.tanks.battle.Trigger;
   
   public class BattleRunnerImpl implements BattleRunner
   {
      
      public function BattleRunnerImpl()
      {
         super();
      }
      
      public function addPhysicsController(controller:PhysicsController) : void
      {
         GameData.physicsScene.addPhysicsController(controller);
      }
      
      public function removePhysicsController(controller:PhysicsController) : void
      {
         GameData.physicsScene.removePhysicsController(controller);
      }
      
      public function addPhysicsInterpolator(interpolator:PhysicsInterpolator) : void
      {
         GameData.physicsScene.addPhysicsInterpolator(interpolator);
      }
      
      public function removePhysicsInterpolator(interpolator:PhysicsInterpolator) : void
      {
         GameData.physicsScene.removePhysicsInterpolator(interpolator);
      }
      
      public function addTrigger(trigger:Trigger) : void
      {
         GameData.physicsScene.nykoto.add(trigger);
      }
      
      public function removeTrigger(trigger:Trigger) : void
      {
         GameData.physicsScene.nykoto.remove(trigger);
      }
      
      public function getCollisionDetector() : CollisionDetector
      {
         return GameData.physicsScene.collisionDetector;
      }
   }
}

