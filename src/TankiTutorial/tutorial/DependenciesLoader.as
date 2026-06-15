package tutorial
{
   import tutorial.commons.Assets;
   import tutorial.loader.SceneLoader;
   
   public class DependenciesLoader
   {
      
      private static const feseju:Object = {};
      
      private var potakubu:Array;
      
      private var dodycoli:int;
      
      private var hon:Function;
      
      private var rilabito:String;
      
      public function DependenciesLoader()
      {
         super();
      }
      
      public function load(param1:Array, param2:Function) : void
      {
         var _loc5_:String = null;
         var _loc6_:XML = null;
         var _loc7_:String = null;
         this.potakubu = param1;
         this.hon = param2;
         var _loc3_:XML = Assets.config;
         this.dodycoli = 0;
         var _loc4_:Object = {};
         for each(_loc5_ in param1)
         {
            if(!feseju[_loc5_])
            {
               _loc4_[_loc5_] = true;
            }
         }
         for each(_loc6_ in _loc3_.scene)
         {
            _loc7_ = _loc6_.@name.toString();
            if(Boolean(_loc4_[_loc7_]))
            {
               delete _loc4_[_loc7_];
            }
         }
         this.loadDependency();
      }
      
      private function loadDependency(param1:SceneLoader = null) : void
      {
         var _loc2_:SceneLoader = null;
         if(param1 != null)
         {
            ++this.dodycoli;
            feseju[this.rilabito] = true;
         }
         if(this.dodycoli < this.potakubu.length)
         {
            this.rilabito = this.potakubu[this.dodycoli];
            if(Boolean(feseju[this.rilabito]))
            {
               ++this.dodycoli;
               this.loadDependency();
            }
            else
            {
               _loc2_ = new SceneLoader();
               _loc2_.load(this.rilabito,this.loadDependency);
            }
         }
         else
         {
            this.hon();
         }
      }
   }
}

