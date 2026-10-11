package alternativa.tanks.utils.objectpool
{
   public class PooledObject
   {
      
      private var pool:Pool;
      
      public function PooledObject(pool:Pool)
      {
         super();
         this.pool = pool;
      }
      
      public function recycle() : void
      {
         this.pool.putObject(this);
      }
   }
}

