package tutorial
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.physics.TanksPhysicsScene;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.display.Stage;
   import tutorial.tasks.TaskGroup;
   
   public class Tutorial
   {
      
      public var name:String;
      
      protected var stage:Stage = GameData.stage;
      
      protected var taskGroup:TaskGroup = GameData.taskGroup;
      
      protected var playerTank:Tank = GameData.playerTank;
      
      protected var kdContainer:KDContainer = GameData.kdContainer;
      
      protected var physicsScene:TanksPhysicsScene = GameData.physicsScene;
      
      protected var _finished:Boolean = false;
      
      protected var scene:GameScene = GameData.scene;
      
      protected var _stepFinished:Boolean;
      
      public var loaded:Boolean = false;
      
      public function Tutorial()
      {
         super();
      }
      
      public function get finished() : Boolean
      {
         return this._finished;
      }
      
      public function moveToNextStep() : void
      {
      }
      
      public function getDependencies() : Array
      {
         return [];
      }
      
      public function skipStep() : void
      {
      }
      
      public function start() : void
      {
         this.scene.buildKDTree(this.kdContainer);
         this.physicsScene.build();
         GameData.initMarking();
      }
      
      public function get stepFinished() : Boolean
      {
         return this._stepFinished;
      }
   }
}

