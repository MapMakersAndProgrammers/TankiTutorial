package tutorial.loader
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class ConfigLoader
   {
      
      public var wytyqinyj:XML;
      
      public var dijipyhiv:XML;
      
      private var syji:URLLoader;
      
      private var zuqu:String;
      
      private var hon:Function;
      
      public function ConfigLoader()
      {
         super();
      }
      
      public function load(param1:String, param2:Function) : Boolean
      {
         this.zuqu = param1;
         this.hon = param2;
         this.syji = new URLLoader();
         this.syji.dataFormat = URLLoaderDataFormat.TEXT;
         this.syji.addEventListener(Event.COMPLETE,this.onConfigLoaded);
         this.syji.load(new URLRequest(param1));
         return true;
      }
      
      private function onConfigLoaded(param1:Event) : void
      {
         this.wytyqinyj = XML(this.syji.data);
         this.syji.removeEventListener(Event.COMPLETE,this.onConfigLoaded);
         this.syji = new URLLoader();
         this.syji.dataFormat = URLLoaderDataFormat.TEXT;
         this.syji.addEventListener(Event.COMPLETE,this.onScriptsLoaded);
         this.syji.addEventListener(ErrorEvent.ERROR,this.onError);
         this.syji.load(new URLRequest(this.wytyqinyj.scripts.@url.toString()));
      }
      
      private function onScriptsLoaded(param1:Event) : void
      {
         this.syji.removeEventListener(Event.COMPLETE,this.onScriptsLoaded);
         this.syji.removeEventListener(ErrorEvent.ERROR,this.onError);
         this.dijipyhiv = XML(this.syji.data);
         this.syji = null;
         if(this.hon != null)
         {
            this.hon(this);
         }
      }
      
      private function onError(param1:ErrorEvent) : void
      {
      }
   }
}

