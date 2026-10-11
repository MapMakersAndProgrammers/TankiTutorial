package tutorial.commons
{
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   
   public class Lang
   {
      
      private static var lang:String;
      
      public static const RU:String = "RU";
      
      public static const EN:String = "EN";
      
      public static const DE:String = "DE";
      
      public static const CN:String = "CN";
      
      public static const PT_BR:String = "PT_BR";
      
      public static const PL:String = "PL";
      
      public static const ES:String = "ES";
      
      public function Lang()
      {
         super();
      }
      
      public static function init() : void
      {
         if(lang != null)
         {
            return;
         }
         if(ExternalInterface.available)
         {
            lang = ExternalInterface.call("getLang").toUpperCase();
         }
         else
         {
            lang = Capabilities.language.toUpperCase();
         }
      }
      
      public static function get language() : String
      {
         return lang;
      }
      
      public static function getText(texts:Vector.<String>) : String
      {
         var index:int = 0;
         switch(lang)
         {
            case EN:
               index = 0;
               break;
            case DE:
               index = 1;
               break;
            case RU:
               index = 2;
               break;
            case CN:
               index = 3;
               break;
            case PT_BR:
               index = 4;
               break;
            case PL:
               index = 5;
               break;
            case ES:
               index = 6;
               break;
            default:
               index = 0;
         }
         return texts[index];
      }
      
      public static function get embedFonts() : Boolean
      {
         return lang != CN;
      }
   }
}

