package tutorial.loader.proplib
{
   import flash.utils.ByteArray;
   
   public class XMLUtils
   {
      
      private static var bytes:ByteArray = new ByteArray();
      
      public function XMLUtils()
      {
         super();
      }
      
      public static function copyXMLString(str:String) : String
      {
         bytes.position = 0;
         bytes.writeUTF(str);
         bytes.position = 0;
         return bytes.readUTF();
      }
      
      public static function getAttributeAsString(xml:XML, name:String, defaultValue:String = null) : String
      {
         var attribute:XML = null;
         var attributes:XMLList = xml.attribute(name);
         if(attributes.length() > 0)
         {
            attribute = attributes[0];
            return attribute.toString();
         }
         return defaultValue;
      }
      
      public static function getAttributeAsNumber(xml:XML, name:String, defaultValue:Number = NaN) : Number
      {
         var attributes:XMLList = xml.attribute(name);
         if(attributes.length() > 0)
         {
            return Number(attributes[0]);
         }
         return defaultValue;
      }
      
      public static function getAttributeAsInt(xml:XML, name:String, defaultValue:int = 0) : Number
      {
         var attributes:XMLList = xml.attribute(name);
         if(attributes.length() > 0)
         {
            return int(attributes[0]);
         }
         return defaultValue;
      }
   }
}

