package alternativa.physics
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.types.dudyqo;
   import alternativa.tanks.battle.PhysicsController;
   import alternativa.tanks.battle.PhysicsInterpolator;
   import alternativa.tanks.battle.triggers.Triggers;
   import alternativa.tanks.shared.physics.TankBody;
   import alternativa.tanks.shared.physics.mebiw;
   import tutorial.GameData;
   
   public class TanksPhysicsScene extends PhysicsScene
   {
      
      private var qywy:Vector.<PhysicsController> = new Vector.<PhysicsController>();
      
      private var mete:Vector.<PhysicsController> = new Vector.<PhysicsController>();
      
      private var lepebeso:Vector.<PhysicsController> = new Vector.<PhysicsController>();
      
      private var dytoc:Vector.<PhysicsInterpolator> = new Vector.<PhysicsInterpolator>();
      
      public var secakesem:mebiw;
      
      private var juzote:Boolean = false;
      
      private var kodasy:Vector.<CollisionShape>;
      
      private var kagehi:Object = {};
      
      private var guziwod:Mesh;
      
      private var cotyripyc:Boolean;
      
      public const nykoto:Triggers = new Triggers();
      
      public function TanksPhysicsScene()
      {
         super();
         this.secakesem = new mebiw();
         kymaqos = this.secakesem;
         this.kodasy = new Vector.<CollisionShape>();
      }
      
      public function addTankBody(param1:TankBody) : void
      {
         this.addBody(param1.body);
         this.secakesem.addTankBody(param1);
      }
      
      public function removeTankBody(param1:TankBody) : void
      {
         this.removeBody(param1.body);
         this.secakesem.removeTankBody(param1);
      }
      
      public function addKinematicBody(param1:Body) : void
      {
         this.addBody(param1);
         this.secakesem.cul(param1);
      }
      
      public function removeDynamicBody(param1:Body) : void
      {
         this.removeBody(param1);
         this.secakesem.niryruv(param1);
      }
      
      override public function addBody(param1:Body) : void
      {
         super.addBody(param1);
         if(param1.gepocivaj != null)
         {
            this.kagehi[param1.gepocivaj] = param1;
         }
      }
      
      override public function removeBody(param1:Body) : void
      {
         super.removeBody(param1);
         if(param1.gepocivaj != null)
         {
            delete this.kagehi[param1.gepocivaj];
         }
      }
      
      public function getBody(param1:String) : Body
      {
         return this.kagehi[param1];
      }
      
      public function addCollisionPrimitive(param1:CollisionShape) : void
      {
         this.kodasy.push(param1);
         this.juzote = true;
      }
      
      public function build() : void
      {
         var _loc1_:dudyqo = null;
         var _loc2_:Number = NaN;
         if(this.juzote)
         {
            _loc1_ = new dudyqo();
            _loc2_ = 200000;
            _loc1_.wigikot(-_loc2_,-_loc2_,-_loc2_,_loc2_,_loc2_,_loc2_);
            this.secakesem.nonolit(this.kodasy,_loc1_);
            this.juzote = false;
         }
      }
      
      public function addPhysicsController(param1:PhysicsController) : void
      {
         if(this.cotyripyc)
         {
            this.mete.push(param1);
         }
         else if(this.qywy.indexOf(param1) < 0)
         {
            this.qywy.push(param1);
         }
      }
      
      public function removePhysicsController(param1:PhysicsController) : void
      {
         var _loc2_:int = 0;
         if(this.cotyripyc)
         {
            this.lepebeso.push(param1);
         }
         else
         {
            _loc2_ = this.qywy.indexOf(param1);
            if(_loc2_ >= 0)
            {
               this.qywy.splice(_loc2_,1);
            }
         }
      }
      
      public function runPhysicsInterpolators(param1:Number) : void
      {
         var _loc4_:PhysicsInterpolator = null;
         var _loc2_:int = int(this.dytoc.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.dytoc[_loc3_];
            _loc4_.interpolatePhysicsState(param1);
            _loc3_++;
         }
      }
      
      public function addPhysicsInterpolator(param1:PhysicsInterpolator) : void
      {
         if(this.dytoc.indexOf(param1) < 0)
         {
            this.dytoc.push(param1);
         }
      }
      
      public function removePhysicsInterpolator(param1:PhysicsInterpolator) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = int(this.dytoc.length);
         if(_loc2_ > 0)
         {
            _loc3_ = this.dytoc.indexOf(param1);
            if(_loc3_ >= 0)
            {
               this.dytoc[_loc3_] = this.dytoc[--_loc2_];
               this.dytoc.length = _loc2_;
            }
         }
      }
      
      override public function update(param1:int) : void
      {
         this.runPhysicsControllers(param1 * 0.001);
         super.update(param1);
         if(this.isPlayerTankAlive())
         {
            this.nykoto.check(GameData.jifom.hogys.body);
         }
      }
      
      private function isPlayerTankAlive() : Boolean
      {
         return Boolean(GameData.jifom) && Boolean(GameData.jifom.hogys) && Boolean(GameData.jifom.kat);
      }
      
      private function runPhysicsControllers(param1:Number) : void
      {
         var _loc2_:PhysicsController = null;
         this.cotyripyc = true;
         for each(_loc2_ in this.qywy)
         {
            _loc2_.runBeforePhysicsUpdate(param1);
         }
         this.cotyripyc = false;
         this.addNewControllers();
         this.deleteRemovedControllers();
      }
      
      private function addNewControllers() : void
      {
         var _loc1_:PhysicsController = null;
         for each(_loc1_ in this.mete)
         {
            this.addPhysicsController(_loc1_);
         }
         this.mete.length = 0;
      }
      
      private function deleteRemovedControllers() : void
      {
         var _loc1_:PhysicsController = null;
         for each(_loc1_ in this.lepebeso)
         {
            this.removePhysicsController(_loc1_);
         }
         this.lepebeso.length = 0;
      }
      
      public function get physicsVisualization() : Object3D
      {
         return this.guziwod;
      }
   }
}

