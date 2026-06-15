package alternativa.tanks.utils.objectpool
{
   import flash.utils.Dictionary;
   
   public class ObjectPool
   {
      
      private var racekuwyl:Dictionary = new Dictionary();
      
      public function ObjectPool()
      {
         super();
      }
      
      public function getObject(param1:Class) : Object
      {
         return this.getPoolForClass(param1).getObject();
      }
      
      public function clear() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.racekuwyl)
         {
            Pool(this.racekuwyl[_loc1_]).clear();
            delete this.racekuwyl[_loc1_];
         }
      }
      
      private function getPoolForClass(param1:Class) : Pool
      {
         var _loc2_:Pool = this.racekuwyl[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new Pool(param1);
            this.racekuwyl[param1] = _loc2_;
         }
         return _loc2_;
      }
   }
}

