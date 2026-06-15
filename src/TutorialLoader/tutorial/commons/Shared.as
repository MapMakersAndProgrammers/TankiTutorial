package tutorial.commons
{
   import flash.display.BitmapData;
   
   public class Shared
   {
      
      public static var preloader:LoaderWindow;
      
      public static var currentStep:String;
      
      public static var hideSkipButton:Function;
      
      public static var tracker:TrackerService;
      
      public static var navigateMethod:Function;
      
      public static const stub:BitmapData = new BitmapData(1,1,true,0);
      
      public static const TUTORIAL_LOAD:String = "TutorialLoad";
      
      public static const TUTORIAL:String = "Tutorial";
      
      public static const TUTORIAL_STAT:String = "TutorialStat";
      
      public static const TUTORIAL_ERROR:String = "Tutorial_ERROR";
      
      public static const clientLog:ClientLog = new ClientLog();
      
      public static var gpu:Boolean = true;
      
      public static var constrained:Boolean = false;
      
      public static var regURL:String = "http://tutorial.tankionline.com/lucky.html#tutorial=true";
      
      public static var navigator:String = "Unknown";
      
      public static var navigatorVersion:String = "0.0.0.0";
      
      public static var renderEnabled:Boolean = true;
      
      public static var volume:Number = 1;
      
      public function Shared()
      {
         super();
      }
      
      public static function getMajorNavigatorVersion() : int
      {
         var _loc1_:Array = navigatorVersion.split(".");
         return int(_loc1_[0]);
      }
   }
}

