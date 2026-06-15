package tutorial
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.physics.TanksPhysicsScene;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.display.Stage;
   import tutorial.tasks.TaskGroup;
   
   public class Tutorial
   {
      
      public var gepocivaj:String;
      
      protected var stage:Stage = GameData.stage;
      
      protected var namab:TaskGroup = GameData.namab;
      
      protected var jifom:Tank = GameData.jifom;
      
      protected var guzinizub:KDContainer = GameData.guzinizub;
      
      protected var gov:TanksPhysicsScene = GameData.gov;
      
      protected var vegetis:Boolean = false;
      
      protected var tuce:GameScene = GameData.tuce;
      
      protected var tezivasaf:Boolean;
      
      public var feseju:Boolean = false;
      
      public function Tutorial()
      {
         super();
      }
      
      public function get finished() : Boolean
      {
         return this.vegetis;
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
         this.tuce.buildKDTree(this.guzinizub);
         this.gov.build();
         GameData.initMarking();
      }
      
      public function get stepFinished() : Boolean
      {
         return this.tezivasaf;
      }
   }
}

