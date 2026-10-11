package alternativa.physics
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.types.AABB;
   import alternativa.tanks.battle.PhysicsController;
   import alternativa.tanks.battle.PhysicsInterpolator;
   import alternativa.tanks.battle.triggers.Triggers;
   import alternativa.tanks.shared.physics.TankBody;
   import alternativa.tanks.shared.physics.TanksCollisionDetector;
   import tutorial.GameData;
   
   public class TanksPhysicsScene extends PhysicsScene
   {
      
      private var physicsControllers:Vector.<PhysicsController> = new Vector.<PhysicsController>();
      
      private var controllersToAdd:Vector.<PhysicsController> = new Vector.<PhysicsController>();
      
      private var controllersToRemove:Vector.<PhysicsController> = new Vector.<PhysicsController>();
      
      private var physicsInterpolators:Vector.<PhysicsInterpolator> = new Vector.<PhysicsInterpolator>();
      
      public var tanksCollisionDetector:TanksCollisionDetector;
      
      private var primitivesChanged:Boolean = false;
      
      private var collisionPrimitives:Vector.<CollisionShape>;
      
      private var namedBodies:Object = {};
      
      private var _physicsVisualization:Mesh;
      
      private var controllersRunning:Boolean;
      
      public const triggers:Triggers = new Triggers();
      
      public function TanksPhysicsScene()
      {
         super();
         this.tanksCollisionDetector = new TanksCollisionDetector();
         collisionDetector = this.tanksCollisionDetector;
         this.collisionPrimitives = new Vector.<CollisionShape>();
      }
      
      public function addTankBody(tankBody:TankBody) : void
      {
         this.addBody(tankBody.body);
         this.tanksCollisionDetector.addTankBody(tankBody);
      }
      
      public function removeTankBody(tankBody:TankBody) : void
      {
         this.removeBody(tankBody.body);
         this.tanksCollisionDetector.removeTankBody(tankBody);
      }
      
      public function addKinematicBody(body:Body) : void
      {
         this.addBody(body);
         this.tanksCollisionDetector.addKineamticBody(body);
      }
      
      public function removeDynamicBody(body:Body) : void
      {
         this.removeBody(body);
         this.tanksCollisionDetector.removeKinematicBody(body);
      }
      
      override public function addBody(body:Body) : void
      {
         super.addBody(body);
         if(body.name != null)
         {
            this.namedBodies[body.name] = body;
         }
      }
      
      override public function removeBody(body:Body) : void
      {
         super.removeBody(body);
         if(body.name != null)
         {
            delete this.namedBodies[body.name];
         }
      }
      
      public function getBody(name:String) : Body
      {
         return this.namedBodies[name];
      }
      
      public function addCollisionPrimitive(primitive:CollisionShape) : void
      {
         this.collisionPrimitives.push(primitive);
         this.primitivesChanged = true;
      }
      
      public function build() : void
      {
         var boundBox:AABB = null;
         var size:Number = NaN;
         if(this.primitivesChanged)
         {
            boundBox = new AABB();
            size = 200000;
            boundBox.setSize(-size,-size,-size,size,size,size);
            this.tanksCollisionDetector.buildKdTree(this.collisionPrimitives,boundBox);
            this.primitivesChanged = false;
         }
      }
      
      public function addPhysicsController(controller:PhysicsController) : void
      {
         if(this.controllersRunning)
         {
            this.controllersToAdd.push(controller);
         }
         else if(this.physicsControllers.indexOf(controller) < 0)
         {
            this.physicsControllers.push(controller);
         }
      }
      
      public function removePhysicsController(controller:PhysicsController) : void
      {
         var index:int = 0;
         if(this.controllersRunning)
         {
            this.controllersToRemove.push(controller);
         }
         else
         {
            index = this.physicsControllers.indexOf(controller);
            if(index >= 0)
            {
               this.physicsControllers.splice(index,1);
            }
         }
      }
      
      public function runPhysicsInterpolators(t:Number) : void
      {
         var interpolator:PhysicsInterpolator = null;
         var len:int = int(this.physicsInterpolators.length);
         var i:int = 0;
         while(i < len)
         {
            interpolator = this.physicsInterpolators[i];
            interpolator.interpolatePhysicsState(t);
            i++;
         }
      }
      
      public function addPhysicsInterpolator(interpolator:PhysicsInterpolator) : void
      {
         if(this.physicsInterpolators.indexOf(interpolator) < 0)
         {
            this.physicsInterpolators.push(interpolator);
         }
      }
      
      public function removePhysicsInterpolator(interpolator:PhysicsInterpolator) : void
      {
         var index:int = 0;
         var len:int = int(this.physicsInterpolators.length);
         if(len > 0)
         {
            index = this.physicsInterpolators.indexOf(interpolator);
            if(index >= 0)
            {
               this.physicsInterpolators[index] = this.physicsInterpolators[--len];
               this.physicsInterpolators.length = len;
            }
         }
      }
      
      override public function update(delta:int) : void
      {
         this.runPhysicsControllers(delta * 0.001);
         super.update(delta);
         if(this.isPlayerTankAlive())
         {
            this.triggers.check(GameData.playerTank.hogys.body);
         }
      }
      
      private function isPlayerTankAlive() : Boolean
      {
         return Boolean(GameData.playerTank) && Boolean(GameData.playerTank.hogys) && Boolean(GameData.playerTank.kat);
      }
      
      private function runPhysicsControllers(dt:Number) : void
      {
         var controller:PhysicsController = null;
         this.controllersRunning = true;
         for each(controller in this.physicsControllers)
         {
            controller.runBeforePhysicsUpdate(dt);
         }
         this.controllersRunning = false;
         this.addNewControllers();
         this.deleteRemovedControllers();
      }
      
      private function addNewControllers() : void
      {
         var controller:PhysicsController = null;
         for each(controller in this.controllersToAdd)
         {
            this.addPhysicsController(controller);
         }
         this.controllersToAdd.length = 0;
      }
      
      private function deleteRemovedControllers() : void
      {
         var controller:PhysicsController = null;
         for each(controller in this.controllersToRemove)
         {
            this.removePhysicsController(controller);
         }
         this.controllersToRemove.length = 0;
      }
      
      public function get physicsVisualization() : Object3D
      {
         return this._physicsVisualization;
      }
   }
}

