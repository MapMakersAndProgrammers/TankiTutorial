package alternativa.tanks.utils.objectpool
{
   import flash.utils.Dictionary;
   
   public class ObjectPool
   {
      
      private var pools:Dictionary = new Dictionary();
      
      public function ObjectPool()
      {
         super();
      }
      
      public function getObject(objectClass:Class) : Object
      {
         return this.getPoolForClass(objectClass).getObject();
      }
      
      public function clear() : void
      {
         var objectClass:* = undefined;
         for(objectClass in this.pools)
         {
            Pool(this.pools[objectClass]).clear();
            delete this.pools[objectClass];
         }
      }
      
      private function getPoolForClass(objectClass:Class) : Pool
      {
         var pool:Pool = this.pools[objectClass];
         if(pool == null)
         {
            pool = new Pool(objectClass);
            this.pools[objectClass] = pool;
         }
         return pool;
      }
   }
}

