package alternativa.tanks.utils.objectpool
{
   public class Pool
   {
      
      private var dosomez:int;
      
      private var dyrog:Class;
      
      private var leqib:Vector.<Object> = new Vector.<Object>();
      
      public function Pool(param1:Class)
      {
         super();
         this.dyrog = param1;
      }
      
      final public function getNumObjects() : int
      {
         return this.dosomez;
      }
      
      final public function getObject() : Object
      {
         if(this.dosomez == 0)
         {
            return new this.dyrog(this);
         }
         var _loc1_:Object = this.leqib[--this.dosomez];
         this.leqib[this.dosomez] = null;
         return _loc1_;
      }
      
      final public function putObject(param1:Object) : void
      {
         if(this.dyrog != param1.constructor)
         {
            throw new ArgumentError();
         }
         this.leqib[this.dosomez++] = param1;
      }
      
      final public function clear() : void
      {
         this.leqib.length = 0;
         this.dosomez = 0;
      }
   }
}

