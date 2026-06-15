package tutorial
{
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   
   public class BrowserBlackList
   {
      
      private static const narit:String = "StandAlone";
      
      public static const huvygetu:Array = [{
         "browser":"Chrome",
         "os":"Windows"
      },{
         "browser":"Chrome",
         "os":"Mac"
      },{
         "browser":"Safari",
         "os":"Windows"
      },{
         "browser":"Safari",
         "os":"Mac"
      },{
         "browser":"Yandex",
         "os":"Windows"
      },{
         "browser":"Yandex",
         "os":"Mac"
      }];
      
      public function BrowserBlackList()
      {
         super();
      }
      
      public static function checkIfMouseDisabled() : Boolean
      {
         var _loc4_:Object = null;
         if(!isMouseControlAvailable())
         {
            return true;
         }
         if(Capabilities.playerType == narit)
         {
            return false;
         }
         var _loc1_:String = getBrowserName();
         var _loc2_:String = Capabilities.os;
         var _loc3_:int = 0;
         while(_loc3_ < BrowserBlackList.huvygetu.length)
         {
            _loc4_ = BrowserBlackList.huvygetu[_loc3_];
            if(_loc1_.indexOf(_loc4_.browser) > -1 && _loc2_.indexOf(_loc4_.os) > -1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private static function isMouseControlAvailable() : Boolean
      {
         var _loc1_:Array = getFlashVersion();
         return int(_loc1_[0]) == 11 && int(_loc1_[1]) >= 3 || int(_loc1_[0]) > 11;
      }
      
      private static function getBrowserName() : String
      {
         var toRadians:String = null;
         var doqe:String = null;
         try
         {
            toRadians = ExternalInterface.call("window.navigator.userAgent.toString");
            doqe = "[Unknown Browser]";
            if(toRadians.indexOf("Safari") != -1)
            {
               doqe = "Safari";
            }
            if(toRadians.indexOf("Firefox") != -1)
            {
               doqe = "Firefox";
            }
            if(toRadians.indexOf("Chrome") != -1)
            {
               doqe = "Chrome";
            }
            if(toRadians.indexOf("MSIE") != -1)
            {
               doqe = "IE";
            }
            if(toRadians.indexOf("Opera") != -1)
            {
               doqe = "Opera";
            }
            if(toRadians.indexOf("YaBrowser") != -1)
            {
               doqe = "Yandex";
            }
         }
         catch(e:Error)
         {
            return "[No ExternalInterface]";
         }
         return doqe;
      }
      
      private static function getFlashVersion() : Array
      {
         return Capabilities.version.substr(Capabilities.version.indexOf(" ") + 1).split(",");
      }
   }
}

