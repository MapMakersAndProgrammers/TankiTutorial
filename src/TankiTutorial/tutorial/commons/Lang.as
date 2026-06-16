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
      
      public static function getText(param1:Vector.<String>) : String
      {
         var _loc2_:int = 0;
         switch(lang)
         {
            case EN:
               _loc2_ = 0;
               break;
            case DE:
               _loc2_ = 1;
               break;
            case RU:
               _loc2_ = 2;
               break;
            case CN:
               _loc2_ = 3;
               break;
            case PT_BR:
               _loc2_ = 4;
               break;
            case PL:
               _loc2_ = 5;
               break;
            case ES:
               _loc2_ = 6;
               break;
            default:
               _loc2_ = 0;
         }
         return param1[_loc2_];
      }
      
      public static function get embedFonts() : Boolean
      {
         return lang != CN;
      }
   }
}

