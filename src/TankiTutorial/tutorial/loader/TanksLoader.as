package tutorial.loader
{
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import tutorial.commons.Shared;
   
   public class TanksLoader extends BaseLoader
   {
      
      protected var bita:ImageLoader = new ImageLoader();
      
      protected var pomagu:XML;
      
      protected var hon:Function;
      
      public function TanksLoader()
      {
         super();
      }
      
      public static function createLoader(param1:Function, param2:Function, param3:Function = null) : Loader
      {
         var _loc4_:Loader = new Loader();
         _loc4_.contentLoaderInfo.addEventListener(Event.COMPLETE,param1);
         if(param3 != null)
         {
            _loc4_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,param3);
         }
         _loc4_.contentLoaderInfo.addEventListener(ErrorEvent.ERROR,param2);
         _loc4_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,param2);
         _loc4_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,param2);
         return _loc4_;
      }
      
      public static function createURLLoader(param1:Function, param2:Function, param3:Function = null) : URLLoader
      {
         var _loc4_:URLLoader = new URLLoader();
         _loc4_.addEventListener(Event.COMPLETE,param1);
         if(param3 != null)
         {
            _loc4_.addEventListener(ProgressEvent.PROGRESS,param3);
         }
         _loc4_.addEventListener(ErrorEvent.ERROR,param2);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,param2);
         _loc4_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,param2);
         return _loc4_;
      }
      
      public function check(param1:XML) : Boolean
      {
         return false;
      }
      
      public function load(param1:String, param2:XML, param3:Function) : void
      {
      }
      
      protected function onError(param1:ErrorEvent) : void
      {
         Shared.tracker.trackEvent("Tutorial_ERROR","LoadError",param1.text + " " + julicoj);
         this.nextItem();
      }
      
      protected function nextItem() : void
      {
      }
   }
}

