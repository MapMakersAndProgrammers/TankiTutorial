package tutorial
{
   import flash.external.ExternalInterface;
   import flash.system.Capabilities;
   
   public class BrowserBlackList
   {
      
      private static const STAND_ALONE:String = "StandAlone";
      
      public static const blackList:Array = [{
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
         var entry:Object = null;
         if(!isMouseControlAvailable())
         {
            return true;
         }
         if(Capabilities.playerType == STAND_ALONE)
         {
            return false;
         }
         var browserName:String = getBrowserName();
         var os:String = Capabilities.os;
         var i:int = 0;
         while(i < BrowserBlackList.blackList.length)
         {
            entry = BrowserBlackList.blackList[i];
            if(browserName.indexOf(entry.browser) > -1 && os.indexOf(entry.os) > -1)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      private static function isMouseControlAvailable() : Boolean
      {
         var version:Array = getFlashVersion();
         return int(version[0]) == 11 && int(version[1]) >= 3 || int(version[0]) > 11;
      }
      
      private static function getBrowserName() : String
      {
         var userAgent:String = null;
         var browserName:String = null;
         try
         {
            userAgent = ExternalInterface.call("window.navigator.userAgent.toString");
            browserName = "[Unknown Browser]";
            if(userAgent.indexOf("Safari") != -1)
            {
               browserName = "Safari";
            }
            if(userAgent.indexOf("Firefox") != -1)
            {
               browserName = "Firefox";
            }
            if(userAgent.indexOf("Chrome") != -1)
            {
               browserName = "Chrome";
            }
            if(userAgent.indexOf("MSIE") != -1)
            {
               browserName = "IE";
            }
            if(userAgent.indexOf("Opera") != -1)
            {
               browserName = "Opera";
            }
            if(userAgent.indexOf("YaBrowser") != -1)
            {
               browserName = "Yandex";
            }
         }
         catch(e:Error)
         {
            return "[No ExternalInterface]";
         }
         return browserName;
      }
      
      private static function getFlashVersion() : Array
      {
         return Capabilities.version.substr(Capabilities.version.indexOf(" ") + 1).split(",");
      }
   }
}

