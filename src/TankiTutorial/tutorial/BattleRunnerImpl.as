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
      
      public function addPhysicsController(param1:PhysicsController) : void
      {
         GameData.gov.addPhysicsController(param1);
      }
      
      public function removePhysicsController(param1:PhysicsController) : void
      {
         GameData.gov.removePhysicsController(param1);
      }
      
      public function addPhysicsInterpolator(param1:PhysicsInterpolator) : void
      {
         GameData.gov.addPhysicsInterpolator(param1);
      }
      
      public function removePhysicsInterpolator(param1:PhysicsInterpolator) : void
      {
         GameData.gov.removePhysicsInterpolator(param1);
      }
      
      public function addTrigger(param1:Trigger) : void
      {
         GameData.gov.nykoto.add(param1);
      }
      
      public function removeTrigger(param1:Trigger) : void
      {
         GameData.gov.nykoto.remove(param1);
      }
      
      public function getCollisionDetector() : CollisionDetector
      {
         return GameData.gov.kymaqos;
      }
   }
}

