package alternativa.tanks.bonuses
{
   public class ObjectCache
   {
      
      private var jiso:int;
      
      private var leqib:Vector.<Object> = new Vector.<Object>();
      
      public function ObjectCache()
      {
         super();
      }
      
      public function put(param1:Object) : void
      {
         this.leqib[this.jiso++] = param1;
      }
      
      public function get() : Object
      {
         if(this.isEmpty())
         {
            throw new Error();
         }
         --this.jiso;
         var _loc1_:Object = this.leqib[this.jiso];
         this.leqib[this.jiso] = null;
         return _loc1_;
      }
      
      public function isEmpty() : Boolean
      {
         return this.jiso == 0;
      }
      
      public function clear() : void
      {
         this.leqib.length = 0;
         this.jiso = 0;
      }
   }
}

