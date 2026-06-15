package tutorial.loader.proplib
{
   import flash.utils.ByteArray;
   
   public class XMLUtils
   {
      
      private static var meke:ByteArray = new ByteArray();
      
      public function XMLUtils()
      {
         super();
      }
      
      public static function copyXMLString(param1:String) : String
      {
         meke.position = 0;
         meke.writeUTF(param1);
         meke.position = 0;
         return meke.readUTF();
      }
      
      public static function getAttributeAsString(param1:XML, param2:String, param3:String = null) : String
      {
         var _loc5_:XML = null;
         var _loc4_:XMLList = param1.attribute(param2);
         if(_loc4_.length() > 0)
         {
            _loc5_ = _loc4_[0];
            return _loc5_.toString();
         }
         return param3;
      }
      
      public static function getAttributeAsNumber(param1:XML, param2:String, param3:Number = NaN) : Number
      {
         var _loc4_:XMLList = param1.attribute(param2);
         if(_loc4_.length() > 0)
         {
            return Number(_loc4_[0]);
         }
         return param3;
      }
      
      public static function getAttributeAsInt(param1:XML, param2:String, param3:int = 0) : Number
      {
         var _loc4_:XMLList = param1.attribute(param2);
         if(_loc4_.length() > 0)
         {
            return int(_loc4_[0]);
         }
         return param3;
      }
   }
}

