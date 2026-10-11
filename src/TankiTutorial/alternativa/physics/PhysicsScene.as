package alternativa.physics
{
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.contactislands.ContactIsland;
   import alternativa.physics.contactislands.IslandsGenerator;
   
   public class PhysicsScene
   {
      
      public var penetrationCorrectionFactor:Number = 0.7;
      
      public var maxPenetrationCorrection:Number = 10;
      
      public var allowedPenetration:Number = 0.01;
      
      public var collisionIterations:int = 4;
      
      public var contactIterations:int = 4;
      
      public var freezeSteps:int = 10;
      
      public var linearFreezeThreshold:Number = 5;
      
      public var rotationFreezeThreshold:Number = 0.05;
      
      public const gravity:Vector3 = new Vector3(0,0,-9.8);
      
      public var collisionDetector:CollisionDetector;
      
      public var bodies:Vector.<Body> = new Vector.<Body>();
      
      public var frame:int;
      
      public var time:int;
      
      public var timeStep:Number;
      
      private const bodyContacts:Vector.<BodyContact> = new Vector.<BodyContact>();
      
      private var islandsGenerator:IslandsGenerator;
      
      public function PhysicsScene()
      {
         super();
         this.islandsGenerator = new IslandsGenerator(this);
      }
      
      public function addBody(body:Body) : void
      {
         body.scene = this;
         body.id = this.bodies.length;
         this.bodies.push(body);
      }
      
      public function removeBody(body:Body) : void
      {
         var lastIndex:int = 0;
         var lastBody:Body = null;
         var index:int = this.bodies.indexOf(body);
         if(index > -1)
         {
            lastIndex = this.bodies.length - 1;
            lastBody = this.bodies[lastIndex];
            this.bodies[index] = lastBody;
            lastBody.id = index;
            this.bodies.length = lastIndex;
            body.scene = null;
         }
      }
      
      public function update(delta:int) : void
      {
         ++this.frame;
         this.time += delta;
         this.timeStep = delta / 1000;
         this.applyForces();
         this.detectCollisions();
         this.prepareBodyContacts(this.bodyContacts,this.timeStep);
         this.islandsGenerator.generate(this.bodyContacts,this.bodies.length);
         this.resolveCollisions(this.islandsGenerator.islands);
         this.intergateVelocities(this.timeStep);
         this.resolveContacts(this.islandsGenerator.islands);
         this.islandsGenerator.clear();
         this.disposeBodyContacts(this.bodyContacts);
         this.integratePositions(this.timeStep);
         this.postPhysics();
      }
      
      private function applyForces() : void
      {
         var body:Body = null;
         var len:int = int(this.bodies.length);
         var i:int = 0;
         while(i < len)
         {
            body = this.bodies[i];
            body.calcAccelerations();
            if(body.movable && !body.frozen)
            {
               body.acceleration.x += this.gravity.x;
               body.acceleration.y += this.gravity.y;
               body.acceleration.z += this.gravity.z;
            }
            i++;
         }
      }
      
      private function detectCollisions() : void
      {
         this.calculateBodiesDerivedData();
         this.collisionDetector.getBodyContacts(this.bodyContacts);
      }
      
      private function calculateBodiesDerivedData() : void
      {
         var body:Body = null;
         var len:int = int(this.bodies.length);
         var i:int = 0;
         while(i < len)
         {
            body = this.bodies[i];
            if(!body.frozen)
            {
               body.saveState();
               body.calcDerivedData();
            }
            i++;
         }
      }
      
      private function prepareBodyContacts(contacts:Vector.<BodyContact>, dt:Number) : void
      {
         var bodyContact:BodyContact = null;
         var len:int = int(contacts.length);
         var i:int = 0;
         while(i < len)
         {
            bodyContact = contacts[i];
            this.prepareShapeContacts(bodyContact.shapeContacts,dt);
            i++;
         }
      }
      
      private function prepareShapeContacts(contacts:Vector.<ShapeContact>, dt:Number) : void
      {
         var shapeContact:ShapeContact = null;
         var len:int = int(contacts.length);
         var i:int = 0;
         while(i < len)
         {
            shapeContact = contacts[i];
            shapeContact.calculatePersistentFrameData();
            shapeContact.calcualteDynamicFrameData(this.allowedPenetration,this.penetrationCorrectionFactor,this.maxPenetrationCorrection,dt);
            i++;
         }
      }
      
      private function resolveCollisions(islands:Vector.<ContactIsland>) : void
      {
         var island:ContactIsland = null;
         var len:int = int(islands.length);
         var i:int = 0;
         while(i < len)
         {
            island = islands[i];
            island.collisionPhase(this.collisionIterations);
            i++;
         }
      }
      
      private function resolveContacts(islands:Vector.<ContactIsland>) : void
      {
         var island:ContactIsland = null;
         var len:int = int(islands.length);
         var i:int = 0;
         while(i < len)
         {
            island = islands[i];
            island.contactPhase(this.contactIterations);
            i++;
         }
      }
      
      private function intergateVelocities(dt:Number) : void
      {
         var body:Body = null;
         var len:int = int(this.bodies.length);
         var i:int = 0;
         while(i < len)
         {
            body = this.bodies[i];
            body.integrateVelocity(dt);
            i++;
         }
      }
      
      private function integratePositions(dt:Number) : void
      {
         var body:Body = null;
         var len:int = int(this.bodies.length);
         var i:int = 0;
         while(i < len)
         {
            body = this.bodies[i];
            if(body.movable && !body.frozen)
            {
               body.integratePosition(dt);
               body.integratePseudoVelocity(dt);
            }
            i++;
         }
      }
      
      private function postPhysics() : void
      {
         var body:Body = null;
         var state:BodyState = null;
         var len:int = int(this.bodies.length);
         var i:int = 0;
         while(i < len)
         {
            body = this.bodies[i];
            body.clearAccumulators();
            body.calcDerivedData();
            if(body.freezable && !body.frozen)
            {
               state = body.state;
               if(state.velocity.length() < this.linearFreezeThreshold && state.rotation.length() < this.rotationFreezeThreshold)
               {
                  ++body.freezeCounter;
                  if(body.freezeCounter >= this.freezeSteps)
                  {
                     body.frozen = true;
                  }
               }
               else
               {
                  body.freezeCounter = 0;
                  body.frozen = false;
               }
            }
            i++;
         }
      }
      
      private function disposeBodyContacts(contacts:Vector.<BodyContact>) : void
      {
         var bodyContact:BodyContact = null;
         var len:int = int(contacts.length);
         var i:int = 0;
         while(i < len)
         {
            bodyContact = contacts[i];
            bodyContact.dispose();
            i++;
         }
         contacts.length = 0;
      }
   }
}

