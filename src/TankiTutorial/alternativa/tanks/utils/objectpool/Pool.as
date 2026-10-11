package alternativa.tanks.utils.objectpool
{
   public class Pool
   {
      
      private var numObjects:int;
      
      private var objectClass:Class;
      
      private var objects:Vector.<Object> = new Vector.<Object>();
      
      public function Pool(objectClass:Class)
      {
         super();
         this.objectClass = objectClass;
      }
      
      final public function getNumObjects() : int
      {
         return this.numObjects;
      }
      
      final public function getObject() : Object
      {
         if(this.numObjects == 0)
         {
            return new this.objectClass(this);
         }
         var object:Object = this.objects[--this.numObjects];
         this.objects[this.numObjects] = null;
         return object;
      }
      
      final public function putObject(object:Object) : void
      {
         if(this.objectClass != object.constructor)
         {
            throw new ArgumentError();
         }
         this.objects[this.numObjects++] = object;
      }
      
      final public function clear() : void
      {
         this.objects.length = 0;
         this.numObjects = 0;
      }
   }
}

