package alternativa.physics.contactislands
{
   import alternativa.physics.BodyContact;
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.QuickUnionFind;
   import alternativa.utils.clearDictionary;
   import flash.utils.Dictionary;
   
   public class IslandsGenerator
   {
      
      public const nuwyge:Vector.<ContactIsland> = new Vector.<ContactIsland>();
      
      private const zabuvaroq:Dictionary = new Dictionary();
      
      private const byrokeby:QuickUnionFind = new QuickUnionFind();
      
      private var gov:PhysicsScene;
      
      public function IslandsGenerator(param1:PhysicsScene)
      {
         super();
         this.gov = param1;
      }
      
      public function generate(param1:Vector.<BodyContact>, param2:int) : void
      {
         this.createUnions(param1,param2);
         this.createIslands(param1);
      }
      
      private function createUnions(param1:Vector.<BodyContact>, param2:int) : void
      {
         var _loc5_:BodyContact = null;
         this.byrokeby.init(param2);
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_.rukowicyp.midorofic && _loc5_.zata.midorofic)
            {
               this.byrokeby.union(_loc5_.rukowicyp.wucejydy,_loc5_.zata.wucejydy);
            }
            _loc4_++;
         }
      }
      
      private function createIslands(param1:Vector.<BodyContact>) : void
      {
         var _loc6_:BodyContact = null;
         var _loc7_:int = 0;
         var _loc8_:ContactIsland = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc6_ = param1[_loc3_];
            if(_loc6_.rukowicyp.midorofic)
            {
               _loc7_ = int(this.byrokeby.root(_loc6_.rukowicyp.wucejydy));
            }
            else
            {
               _loc7_ = int(this.byrokeby.root(_loc6_.zata.wucejydy));
            }
            _loc8_ = this.zabuvaroq[_loc7_];
            if(_loc8_ == null)
            {
               _loc8_ = ContactIsland.create();
               this.nuwyge[this.nuwyge.length] = _loc8_;
               this.zabuvaroq[_loc7_] = _loc8_;
            }
            _loc8_.hikocos[_loc8_.hikocos.length] = _loc6_;
            _loc3_++;
         }
         var _loc4_:int = int(this.nuwyge.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc8_ = this.nuwyge[_loc5_];
            _loc8_.init(this.gov);
            _loc5_++;
         }
         clearDictionary(this.zabuvaroq);
      }
      
      public function clear() : void
      {
         var _loc3_:ContactIsland = null;
         var _loc1_:int = int(this.nuwyge.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.nuwyge[_loc2_];
            _loc3_.dispose();
            _loc2_++;
         }
         this.nuwyge.length = 0;
      }
   }
}

