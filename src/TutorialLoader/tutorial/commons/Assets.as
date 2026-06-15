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
      
      public static function saveData(param1:String, param2:*, param3:Class) : void
      {
         var _loc4_:Object = registries[param3];
         if(_loc4_ == null)
         {
            _loc4_ = registries[param3] = {};
         }
         if(_loc4_[param1] != null)
         {
            throw new ArgumentError("Assets.as: already registred " + param1);
         }
         _loc4_[param1] = param2;
      }
      
      public static function getData(param1:String, param2:Class) : *
      {
         var _loc3_:Object = registries[param2];
         if(_loc3_ == null)
         {
            if(param2 != Sound)
            {
               throw new ArgumentError("Assets.as: no such registry " + getQualifiedClassName(param2));
            }
            return null;
         }
         if(param2 != Sound)
         {
            if(_loc3_[param1] == null)
            {
               throw new ArgumentError("Assets.as: not registred " + param1);
            }
         }
         return _loc3_[param1];
      }
      
      public static function hasData(param1:String, param2:Class) : Boolean
      {
         var _loc3_:Object = registries[param2];
         if(_loc3_ == null)
         {
            return false;
         }
         return _loc3_[param1] != null;
      }
   }
}

