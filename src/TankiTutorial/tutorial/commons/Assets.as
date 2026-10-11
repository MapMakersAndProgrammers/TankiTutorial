package tutorial.commons
{
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class Assets
   {
      
      public static var config:XML;
      
      public static var scripts:XML;
      
      public static var initialDataIsSaved:Boolean = false;
      
      private static const registries:Dictionary = new Dictionary();
      
      public function Assets()
      {
         super();
      }
      
      public static function saveData(name:String, data:*, type:Class) : void
      {
         var registry:Object = registries[type];
         if(registry == null)
         {
            registry = registries[type] = {};
         }
         if(registry[name] != null)
         {
            throw new ArgumentError("Assets.as: already registred " + name);
         }
         registry[name] = data;
      }
      
      public static function getData(name:String, type:Class) : *
      {
         var registry:Object = registries[type];
         if(registry == null)
         {
            if(type != Sound)
            {
               throw new ArgumentError("Assets.as: no such registry " + getQualifiedClassName(type));
            }
            return null;
         }
         if(type != Sound)
         {
            if(registry[name] == null)
            {
               throw new ArgumentError("Assets.as: not registred " + name);
            }
         }
         return registry[name];
      }
      
      public static function hasData(name:String, type:Class) : Boolean
      {
         var registry:Object = registries[type];
         if(registry == null)
         {
            return false;
         }
         return registry[name] != null;
      }
   }
}

