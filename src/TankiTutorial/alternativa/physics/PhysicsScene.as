package alternativa.physics
{
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.contactislands.ContactIsland;
   import alternativa.physics.contactislands.IslandsGenerator;
   
   public class PhysicsScene
   {
      
      public var dikaruly:Number = 0.7;
      
      public var finybyle:Number = 10;
      
      public var gyge:Number = 0.01;
      
      public var lenemudap:int = 4;
      
      public var dynen:int = 4;
      
      public var guwacawe:int = 10;
      
      public var zol:Number = 5;
      
      public var davemapo:Number = 0.05;
      
      public const tem:Vector3 = new Vector3(0,0,-9.8);
      
      public var kymaqos:CollisionDetector;
      
      public var cemyda:Vector.<Body> = new Vector.<Body>();
      
      public var lubyp:int;
      
      public var lecopojen:int;
      
      public var favobyfum:Number;
      
      private const hikocos:Vector.<BodyContact> = new Vector.<BodyContact>();
      
      private var dypyh:IslandsGenerator;
      
      public function PhysicsScene()
      {
         super();
         this.dypyh = new IslandsGenerator(this);
      }
      
      public function addBody(param1:Body) : void
      {
         param1.tuce = this;
         param1.wucejydy = this.cemyda.length;
         this.cemyda.push(param1);
      }
      
      public function removeBody(param1:Body) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Body = null;
         var _loc2_:int = this.cemyda.indexOf(param1);
         if(_loc2_ > -1)
         {
            _loc3_ = this.cemyda.length - 1;
            _loc4_ = this.cemyda[_loc3_];
            this.cemyda[_loc2_] = _loc4_;
            _loc4_.wucejydy = _loc2_;
            this.cemyda.length = _loc3_;
            param1.tuce = null;
         }
      }
      
      public function update(param1:int) : void
      {
         ++this.lubyp;
         this.lecopojen += param1;
         this.favobyfum = param1 / 1000;
         this.applyForces();
         this.detectCollisions();
         this.prepareBodyContacts(this.hikocos,this.favobyfum);
         this.dypyh.generate(this.hikocos,this.cemyda.length);
         this.resolveCollisions(this.dypyh.nuwyge);
         this.intergateVelocities(this.favobyfum);
         this.resolveContacts(this.dypyh.nuwyge);
         this.dypyh.clear();
         this.disposeBodyContacts(this.hikocos);
         this.integratePositions(this.favobyfum);
         this.postPhysics();
      }
      
      private function applyForces() : void
      {
         var _loc3_:Body = null;
         var _loc1_:int = int(this.cemyda.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.cemyda[_loc2_];
            _loc3_.calcAccelerations();
            if(_loc3_.midorofic && !_loc3_.vowymov)
            {
               _loc3_.cozo.x += this.tem.x;
               _loc3_.cozo.y += this.tem.y;
               _loc3_.cozo.z += this.tem.z;
            }
            _loc2_++;
         }
      }
      
      private function detectCollisions() : void
      {
         this.calculateBodiesDerivedData();
         this.kymaqos.getBodyContacts(this.hikocos);
      }
      
      private function calculateBodiesDerivedData() : void
      {
         var _loc3_:Body = null;
         var _loc1_:int = int(this.cemyda.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.cemyda[_loc2_];
            if(!_loc3_.vowymov)
            {
               _loc3_.saveState();
               _loc3_.calcDerivedData();
            }
            _loc2_++;
         }
      }
      
      private function prepareBodyContacts(param1:Vector.<BodyContact>, param2:Number) : void
      {
         var _loc5_:BodyContact = null;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            this.prepareShapeContacts(_loc5_.pupicic,param2);
            _loc4_++;
         }
      }
      
      private function prepareShapeContacts(param1:Vector.<ShapeContact>, param2:Number) : void
      {
         var _loc5_:ShapeContact = null;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc5_.calculatePersistentFrameData();
            _loc5_.calcualteDynamicFrameData(this.gyge,this.dikaruly,this.finybyle,param2);
            _loc4_++;
         }
      }
      
      private function resolveCollisions(param1:Vector.<ContactIsland>) : void
      {
         var _loc4_:ContactIsland = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            _loc4_.collisionPhase(this.lenemudap);
            _loc3_++;
         }
      }
      
      private function resolveContacts(param1:Vector.<ContactIsland>) : void
      {
         var _loc4_:ContactIsland = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            _loc4_.contactPhase(this.dynen);
            _loc3_++;
         }
      }
      
      private function intergateVelocities(param1:Number) : void
      {
         var _loc4_:Body = null;
         var _loc2_:int = int(this.cemyda.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.cemyda[_loc3_];
            _loc4_.integrateVelocity(param1);
            _loc3_++;
         }
      }
      
      private function integratePositions(param1:Number) : void
      {
         var _loc4_:Body = null;
         var _loc2_:int = int(this.cemyda.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.cemyda[_loc3_];
            if(_loc4_.midorofic && !_loc4_.vowymov)
            {
               _loc4_.integratePosition(param1);
               _loc4_.integratePseudoVelocity(param1);
            }
            _loc3_++;
         }
      }
      
      private function postPhysics() : void
      {
         var _loc3_:Body = null;
         var _loc4_:BodyState = null;
         var _loc1_:int = int(this.cemyda.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.cemyda[_loc2_];
            _loc3_.clearAccumulators();
            _loc3_.calcDerivedData();
            if(_loc3_.reze && !_loc3_.vowymov)
            {
               _loc4_ = _loc3_.kejo;
               if(_loc4_.zerus.length() < this.zol && _loc4_.fev.length() < this.davemapo)
               {
                  ++_loc3_.qiryk;
                  if(_loc3_.qiryk >= this.guwacawe)
                  {
                     _loc3_.vowymov = true;
                  }
               }
               else
               {
                  _loc3_.qiryk = 0;
                  _loc3_.vowymov = false;
               }
            }
            _loc2_++;
         }
      }
      
      private function disposeBodyContacts(param1:Vector.<BodyContact>) : void
      {
         var _loc4_:BodyContact = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1[_loc3_];
            _loc4_.dispose();
            _loc3_++;
         }
         param1.length = 0;
      }
   }
}

