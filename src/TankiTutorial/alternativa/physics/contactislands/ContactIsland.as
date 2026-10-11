package alternativa.physics.contactislands
{
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.Body;
   import alternativa.physics.ShapeContact;
   import alternativa.physics.BodyContact;
   import alternativa.math.Vector3;
   
   public class ContactIsland
   {
      
      private static var poolSize:int;
      
      private static const pool:Vector.<ContactIsland> = new Vector.<ContactIsland>();
      
      private static const velocity:Vector3 = new Vector3();
      
      private static const COLLISION_MODE:int = 0;
      
      private static const CONTACT_MODE:int = 1;
      
      public const bodyContacts:Vector.<BodyContact> = new Vector.<BodyContact>();
      
      private var physicsScene:PhysicsScene;
      
      private const shapeContacts:Vector.<ShapeContact> = new Vector.<ShapeContact>();
      
      private const levelContacts:Vector.<ShapeContact> = new Vector.<ShapeContact>();
      
      private var levelBodies:Vector.<Body> = new Vector.<Body>();
      
      private var nextLevelBodies:Vector.<Body> = new Vector.<Body>();
      
      private const levelBodyContacts:Vector.<BodyContact> = new Vector.<BodyContact>();
      
      private const contactLevels:ContactLevels = new ContactLevels();
      
      public function ContactIsland()
      {
         super();
      }
      
      public static function create() : ContactIsland
      {
         if(poolSize == 0)
         {
            return new ContactIsland();
         }
         --poolSize;
         var island:ContactIsland = pool[poolSize];
         pool[poolSize] = null;
         return island;
      }
      
      public function dispose() : void
      {
         this.physicsScene = null;
         this.bodyContacts.length = 0;
         this.shapeContacts.length = 0;
         this.levelContacts.length = 0;
         this.levelBodies.length = 0;
         this.nextLevelBodies.length = 0;
         this.levelBodyContacts.length = 0;
         this.contactLevels.clear();
         pool[poolSize++] = this;
      }
      
      public function init(scene:PhysicsScene) : void
      {
         var bodyContact:BodyContact = null;
         var bodyShapeContacts:Vector.<ShapeContact> = null;
         var numShapeContacts:int = 0;
         var j:int = 0;
         this.physicsScene = scene;
         var len:int = int(this.bodyContacts.length);
         var contacts:Vector.<ShapeContact> = this.shapeContacts;
         var i:int = 0;
         while(i < len)
         {
            bodyContact = this.bodyContacts[i];
            bodyShapeContacts = bodyContact.shapeContacts;
            numShapeContacts = int(bodyShapeContacts.length);
            j = 0;
            while(j < numShapeContacts)
            {
               contacts[contacts.length] = bodyShapeContacts[j];
               j++;
            }
            i++;
         }
      }
      
      public function collisionPhase(iterations:int) : void
      {
         this.resolveCollisions(iterations);
      }
      
      public function contactPhase(iterations:int) : void
      {
         this.resolveContacts(iterations);
      }
      
      private function resolveCollisions(iterations:int) : void
      {
         var j:int = 0;
         var len:int = int(this.shapeContacts.length);
         var i:int = 0;
         while(i < iterations)
         {
            this.shuffleContacts(this.shapeContacts);
            j = 0;
            while(j < len)
            {
               this.resolveContact(this.shapeContacts[j],COLLISION_MODE);
               j++;
            }
            i++;
         }
      }
      
      private function resolveContacts(iterations:int) : void
      {
         var bodies:Vector.<Body> = null;
         var len:int = 0;
         var i:int = 0;
         var contact:ShapeContact = null;
         this.processContacts(iterations);
         this.contactLevels.init(this.bodyContacts);
         this.contactLevels.getStaticLevel(this.levelBodyContacts,this.nextLevelBodies);
         if(this.levelBodyContacts.length > 0)
         {
            this.getShapeContacts(this.levelBodyContacts,this.levelContacts);
            this.resolveContactsForLevel(iterations,this.levelContacts);
            this.calculatePseudoVelocities(iterations,this.levelContacts);
            while(this.contactLevels.hasContacts())
            {
               bodies = this.levelBodies;
               this.levelBodies = this.nextLevelBodies;
               this.nextLevelBodies = bodies;
               this.levelBodyContacts.length = 0;
               this.nextLevelBodies.length = 0;
               this.contactLevels.getNextLevel(this.levelBodies,this.levelBodyContacts,this.nextLevelBodies);
               this.setBodiesMobility(this.levelBodies,false);
               this.levelContacts.length = 0;
               this.getShapeContacts(this.levelBodyContacts,this.levelContacts);
               len = int(this.levelContacts.length);
               i = 0;
               while(i < len)
               {
                  contact = this.levelContacts[i];
                  contact.calcualteDynamicFrameData(this.physicsScene.allowedPenetration,this.physicsScene.penetrationCorrectionFactor,this.physicsScene.maxPenetrationCorrection,this.physicsScene.timeStep);
                  i++;
               }
               this.resolveContactsForLevel(iterations,this.levelContacts);
               this.calculatePseudoVelocities(iterations,this.levelContacts);
               this.setBodiesMobility(this.levelBodies,true);
            }
         }
         else
         {
            this.getShapeContacts(this.bodyContacts,this.levelContacts);
            this.resolveContactsForLevel(iterations,this.levelContacts);
            this.calculatePseudoVelocities(iterations,this.levelContacts);
         }
      }
      
      private function processContacts(iterations:int) : void
      {
         var j:int = 0;
         var len:int = int(this.shapeContacts.length);
         var i:int = 0;
         while(i < iterations)
         {
            this.shuffleContacts(this.shapeContacts);
            j = 0;
            while(j < len)
            {
               this.resolveContact(this.shapeContacts[j],CONTACT_MODE);
               j++;
            }
            i++;
         }
      }
      
      private function getShapeContacts(contacts:Vector.<BodyContact>, result:Vector.<ShapeContact>) : void
      {
         var bodyContact:BodyContact = null;
         var bodyShapeContacts:Vector.<ShapeContact> = null;
         var numShapeContacts:int = 0;
         var j:int = 0;
         var len:int = int(contacts.length);
         var i:int = 0;
         while(i < len)
         {
            bodyContact = contacts[i];
            bodyShapeContacts = bodyContact.shapeContacts;
            numShapeContacts = int(bodyShapeContacts.length);
            j = 0;
            while(j < numShapeContacts)
            {
               result[result.length] = bodyShapeContacts[j];
               j++;
            }
            i++;
         }
      }
      
      private function shuffleContacts(contacts:Vector.<ShapeContact>) : void
      {
         var j:int = 0;
         var contact:ShapeContact = null;
         var len:int = int(contacts.length);
         var i:int = 1;
         while(i < len)
         {
            j = i * Math.random();
            contact = contacts[j];
            contacts[j] = contacts[i];
            contacts[i] = contact;
            i++;
         }
      }
      
      private function resolveContactsForLevel(iterations:int, contacts:Vector.<ShapeContact>) : void
      {
         var len:int = 0;
         var j:int = 0;
         var i:int = 0;
         while(i < iterations)
         {
            this.shuffleContacts(contacts);
            len = int(contacts.length);
            j = 0;
            while(j < len)
            {
               this.resolveContact(contacts[j],CONTACT_MODE);
               j++;
            }
            i++;
         }
      }
      
      private function calculatePseudoVelocities(iterations:int, contacts:Vector.<ShapeContact>) : void
      {
         var len:int = 0;
         var j:int = 0;
         var i:int = 0;
         while(i < iterations)
         {
            this.shuffleContacts(contacts);
            len = int(contacts.length);
            j = 0;
            while(j < len)
            {
               this.resolveContactPseudoVelocity(contacts[j]);
               j++;
            }
            i++;
         }
      }
      
      private function setBodiesMobility(bodies:Vector.<Body>, value:Boolean) : void
      {
         var body:Body = null;
         var len:int = int(bodies.length);
         var i:int = 0;
         while(i < len)
         {
            body = bodies[i];
            body.movable = value;
            i++;
         }
      }
      
      private function resolveContact(contact:ShapeContact, mode:int) : void
      {
         var targetVelocity:Number = NaN;
         var frictionImpulse:Number = NaN;
         var n:Vector3 = contact.normal;
         var body1:Body = contact.shape1.body;
         var body2:Body = contact.shape2.body;
         var relativeVelocity:Vector3 = velocity;
         this.calculateRelativeVelocity(contact,relativeVelocity);
         var vn:Number = relativeVelocity.x * n.x + relativeVelocity.y * n.y + relativeVelocity.z * n.z;
         if(mode == CONTACT_MODE)
         {
            targetVelocity = 0;
            if(vn < 0)
            {
               contact.caduk = false;
            }
            else if(contact.caduk)
            {
               return;
            }
         }
         else
         {
            contact.caduk = true;
            targetVelocity = Number(contact.targetNormalVelocity);
         }
         var tangentVelocity:Number = Number(relativeVelocity.dot(contact.tangent));
         var binormalVelocity:Number = Number(relativeVelocity.dot(contact.binormal));
         var newTangentImpulse:Number = contact.tangentImpulse - tangentVelocity / contact.tangentInvMass;
         var newBinormalImpulse:Number = contact.binormalImpulse - binormalVelocity / contact.binormalInvMass;
         var frictionImpulseSqr:Number = newTangentImpulse * newTangentImpulse + newBinormalImpulse * newBinormalImpulse;
         var maxFrictionImpulse:Number = contact.friction * contact.normalImpulse;
         if(frictionImpulseSqr > maxFrictionImpulse * maxFrictionImpulse)
         {
            frictionImpulse = Math.sqrt(frictionImpulseSqr);
            newTangentImpulse *= maxFrictionImpulse / frictionImpulse;
            newBinormalImpulse *= maxFrictionImpulse / frictionImpulse;
         }
         var deltaTangentImpulse:Number = newTangentImpulse - contact.tangentImpulse;
         var deltaBinormalImpulse:Number = newBinormalImpulse - contact.binormalImpulse;
         contact.tangentImpulse = newTangentImpulse;
         contact.binormalImpulse = newBinormalImpulse;
         if(body1.movable)
         {
            body1.applyWorldImpulseAtLocalPoint(contact.r1,contact.tangent,deltaTangentImpulse);
            body1.applyWorldImpulseAtLocalPoint(contact.r1,contact.binormal,deltaBinormalImpulse);
         }
         if(body2.movable)
         {
            body2.applyWorldImpulseAtLocalPoint(contact.r2,contact.tangent,-deltaTangentImpulse);
            body2.applyWorldImpulseAtLocalPoint(contact.r2,contact.binormal,-deltaBinormalImpulse);
         }
         this.calculateRelativeVelocity(contact,relativeVelocity);
         vn = relativeVelocity.x * n.x + relativeVelocity.y * n.y + relativeVelocity.z * n.z;
         var deltaVelocity:Number = targetVelocity - vn;
         var newNormalImpulse:Number = contact.normalImpulse + deltaVelocity / contact.normalInvMass;
         if(newNormalImpulse < 0)
         {
            newNormalImpulse = 0;
         }
         var deltaNormalImpulse:Number = newNormalImpulse - contact.normalImpulse;
         contact.normalImpulse = newNormalImpulse;
         if(body1.movable)
         {
            body1.applyWorldImpulseAtLocalPoint(contact.r1,contact.normal,deltaNormalImpulse);
         }
         if(body2.movable)
         {
            body2.applyWorldImpulseAtLocalPoint(contact.r2,contact.normal,-deltaNormalImpulse);
         }
      }
      
      private function calculateRelativeVelocity(contact:ShapeContact, result:Vector3) : void
      {
         var v:Vector3 = null;
         var angularVelocity:Vector3 = contact.shape1.body.state.rotation;
         v = contact.r1;
         var cx:Number = angularVelocity.y * v.z - angularVelocity.z * v.y;
         var cy:Number = angularVelocity.z * v.x - angularVelocity.x * v.z;
         var cz:Number = angularVelocity.x * v.y - angularVelocity.y * v.x;
         v = contact.shape1.body.state.velocity;
         result.x = v.x + cx;
         result.y = v.y + cy;
         result.z = v.z + cz;
         angularVelocity = contact.shape2.body.state.rotation;
         v = contact.r2;
         cx = angularVelocity.y * v.z - angularVelocity.z * v.y;
         cy = angularVelocity.z * v.x - angularVelocity.x * v.z;
         cz = angularVelocity.x * v.y - angularVelocity.y * v.x;
         v = contact.shape2.body.state.velocity;
         result.x -= v.x + cx;
         result.y -= v.y + cy;
         result.z -= v.z + cz;
      }
      
      private function resolveContactPseudoVelocity(contact:ShapeContact) : void
      {
         var relativeVelocity:Vector3 = velocity;
         this.calcPseudoSeparationVelocity(contact,relativeVelocity);
         var vn:Number = relativeVelocity.x * contact.normal.x + relativeVelocity.y * contact.normal.y + relativeVelocity.z * contact.normal.z;
         var deltaVelocity:Number = contact.targetPseudoVelocity - vn;
         var impulse:Number = deltaVelocity / contact.normalInvMass;
         if(contact.shape1.body.movable)
         {
            contact.shape1.body.applyWorldPseudoImpulseAtLocalPoint(contact.r1,contact.normal,impulse);
         }
         if(contact.shape2.body.movable)
         {
            contact.shape2.body.applyWorldPseudoImpulseAtLocalPoint(contact.r2,contact.normal,-impulse);
         }
      }
      
      private function calcPseudoSeparationVelocity(contact:ShapeContact, result:Vector3) : void
      {
         var v:Vector3 = null;
         var cz:Number = NaN;
         var angularVelocity:Vector3 = contact.shape1.body.pseudoRotation;
         v = contact.r1;
         var cx:Number = angularVelocity.y * v.z - angularVelocity.z * v.y;
         var cy:Number = angularVelocity.z * v.x - angularVelocity.x * v.z;
         cz = angularVelocity.x * v.y - angularVelocity.y * v.x;
         v = contact.shape1.body.pseudoVelocity;
         result.x = v.x + cx;
         result.y = v.y + cy;
         result.z = v.z + cz;
         angularVelocity = contact.shape2.body.pseudoRotation;
         v = contact.r2;
         cx = angularVelocity.y * v.z - angularVelocity.z * v.y;
         cy = angularVelocity.z * v.x - angularVelocity.x * v.z;
         cz = angularVelocity.x * v.y - angularVelocity.y * v.x;
         v = contact.shape2.body.pseudoVelocity;
         result.x -= v.x + cx;
         result.y -= v.y + cy;
         result.z -= v.z + cz;
      }
   }
}

