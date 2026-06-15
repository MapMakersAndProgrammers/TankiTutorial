package alternativa.tanks.utils.objectpool
{
   public class PooledObject
   {
      
      private var hybuhy:Pool;
      
      public function PooledObject(param1:Pool)
      {
         super();
         this.hybuhy = param1;
      }
      
      public function recycle() : void
      {
         this.hybuhy.putObject(this);
      }
   }
}

