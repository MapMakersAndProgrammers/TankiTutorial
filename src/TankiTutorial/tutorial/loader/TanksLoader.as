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
      
      protected var imageLoader:ImageLoader = new ImageLoader();
      
      protected var xml:XML;
      
      protected var callback:Function;
      
      public function TanksLoader()
      {
         super();
      }
      
      public static function createLoader(completeListener:Function, errorListener:Function, progressListener:Function = null) : Loader
      {
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeListener);
         if(progressListener != null)
         {
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressListener);
         }
         loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR,errorListener);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorListener);
         loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorListener);
         return loader;
      }
      
      public static function createURLLoader(completeListener:Function, errorListener:Function, progressListener:Function = null) : URLLoader
      {
         var urlLoader:URLLoader = new URLLoader();
         urlLoader.addEventListener(Event.COMPLETE,completeListener);
         if(progressListener != null)
         {
            urlLoader.addEventListener(ProgressEvent.PROGRESS,progressListener);
         }
         urlLoader.addEventListener(ErrorEvent.ERROR,errorListener);
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,errorListener);
         urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorListener);
         return urlLoader;
      }
      
      public function check(sceneXML:XML) : Boolean
      {
         return false;
      }
      
      public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
      }
      
      protected function onError(errorEvent:ErrorEvent) : void
      {
         Shared.tracker.trackEvent("Tutorial_ERROR","LoadError",errorEvent.text + " " + currentURL);
         this.nextItem();
      }
      
      protected function nextItem() : void
      {
      }
   }
}

