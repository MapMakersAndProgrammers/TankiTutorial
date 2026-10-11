package tutorial.loader
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import tutorial.commons.Assets;
   import tutorial.loader.proplib.PropLibrary;
   import tutorial.loader.proplib.XMLUtils;
   
   public class PropLibsLoader extends TanksLoader
   {
      
      private var urls:Vector.<String>;
      
      private var priorities:Vector.<int>;
      
      private var baseURL:String;
      
      private var index:int;
      
      private var urlLoader:URLLoader;
      
      public function PropLibsLoader()
      {
         super();
      }
      
      override public function check(sceneXML:XML) : Boolean
      {
         return sceneXML.proplibs.length() > 0;
      }
      
      override public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
         var proplibXML:XML = null;
         this.xml = sceneXML.proplibs[0];
         this.callback = completeListener;
         this.baseURL = sceneURL + xml.@baseURL;
         this.urls = new Vector.<String>();
         this.priorities = new Vector.<int>();
         this.index = 0;
         var i:int = 0;
         for each(proplibXML in xml.elements("proplib"))
         {
            this.urls[i] = this.baseURL + XMLUtils.getAttributeAsString(proplibXML,"url");
            this.priorities[i] = XMLUtils.getAttributeAsInt(proplibXML,"priority");
            i++;
         }
         this.loadLib();
      }
      
      private function loadLib(e:Event = null) : void
      {
         if(e != null)
         {
            this.parse(XML(this.urlLoader.data));
            ++this.index;
         }
         if(this.index < this.urls.length)
         {
            currentURL = this.urls[this.index] + "library.xml";
            if(Assets.hasData(currentURL,XML))
            {
               this.parse(Assets.getData(currentURL,XML));
               ++this.index;
               this.loadLib();
            }
            else
            {
               this.urlLoader = createURLLoader(this.loadLib,onError,onProgress);
               this.urlLoader.load(new URLRequest(this.urls[this.index] + "library.xml"));
            }
         }
         else
         {
            this.urlLoader = null;
            callback();
         }
      }
      
      private function parse(libraryXML:XML) : void
      {
         var library:PropLibrary = new PropLibrary(libraryXML,this.urls[this.index]);
         library.priority = this.priorities[this.index];
         Assets.saveData(library.name,library,PropLibrary);
      }
   }
}

