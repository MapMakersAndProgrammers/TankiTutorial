package alternativa.tanks.bonuses
{
   public class ObjectCache
   {
      
      private var numObjects:int;
      
      private var objects:Vector.<Object> = new Vector.<Object>();
      
      public function ObjectCache()
      {
         super();
      }
      
      public function put(object:Object) : void
      {
         this.objects[this.numObjects++] = object;
      }
      
      public function get() : Object
      {
         if(this.isEmpty())
         {
            throw new Error();
         }
         --this.numObjects;
         var object:Object = this.objects[this.numObjects];
         this.objects[this.numObjects] = null;
         return object;
      }
      
      public function isEmpty() : Boolean
      {
         return this.numObjects == 0;
      }
      
      public function clear() : void
      {
         this.objects.length = 0;
         this.numObjects = 0;
      }
   }
}

