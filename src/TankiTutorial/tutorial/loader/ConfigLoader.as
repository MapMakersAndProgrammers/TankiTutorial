package tutorial.loader
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class ConfigLoader
   {
      
      public var config:XML;
      
      public var scripts:XML;
      
      private var urlLoader:URLLoader;
      
      private var url:String;
      
      private var callback:Function;
      
      public function ConfigLoader()
      {
         super();
      }
      
      public function load(url:String, callback:Function) : Boolean
      {
         this.url = url;
         this.callback = callback;
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.urlLoader.addEventListener(Event.COMPLETE,this.onConfigLoaded);
         this.urlLoader.load(new URLRequest(url));
         return true;
      }
      
      private function onConfigLoaded(e:Event) : void
      {
         this.config = XML(this.urlLoader.data);
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onConfigLoaded);
         this.urlLoader = new URLLoader();
         this.urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
         this.urlLoader.addEventListener(Event.COMPLETE,this.onScriptsLoaded);
         this.urlLoader.addEventListener(ErrorEvent.ERROR,this.onError);
         this.urlLoader.load(new URLRequest(this.config.scripts.@url.toString()));
      }
      
      private function onScriptsLoaded(e:Event) : void
      {
         this.urlLoader.removeEventListener(Event.COMPLETE,this.onScriptsLoaded);
         this.urlLoader.removeEventListener(ErrorEvent.ERROR,this.onError);
         this.scripts = XML(this.urlLoader.data);
         this.urlLoader = null;
         if(this.callback != null)
         {
            this.callback(this);
         }
      }
      
      private function onError(errorEvent:ErrorEvent) : void
      {
      }
   }
}

