package tutorial.loader
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   import tutorial.commons.Assets;
   
   public class SWFLoader extends TanksLoader
   {
      
      private var urls:Vector.<String>;
      
      private var ids:Vector.<String>;
      
      private var index:int;
      
      private var loader:Loader;
      
      public function SWFLoader()
      {
         super();
      }
      
      override public function check(sceneXML:XML) : Boolean
      {
         return sceneXML.movies.length() > 0;
      }
      
      override public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
         var movieXML:XML = null;
         this.xml = sceneXML.movies[0];
         this.callback = completeListener;
         this.urls = new Vector.<String>();
         this.ids = new Vector.<String>();
         this.index = 0;
         var baseURL:String = sceneURL + xml.@baseURL;
         var i:int = 0;
         for each(movieXML in xml.elements("movie"))
         {
            this.ids[i] = movieXML.@id.toString();
            this.urls[i] = baseURL + movieXML.@url.toString();
            i++;
         }
         this.loadMovies();
      }
      
      private function loadMovies(e:Event = null) : void
      {
         if(e != null)
         {
            Assets.saveData(this.ids[this.index],this.loader.content,MovieClip);
            ++this.index;
         }
         if(this.index < this.urls.length)
         {
            if(Assets.hasData(this.ids[this.index],MovieClip))
            {
               ++this.index;
               this.loadMovies();
            }
            else
            {
               this.loader = createLoader(this.loadMovies,onError,onProgress);
               this.loader.load(new URLRequest(this.urls[this.index]));
            }
         }
         else if(callback != null)
         {
            this.loader = null;
            callback();
         }
      }
      
      override protected function nextItem() : void
      {
         this.loadMovies();
      }
   }
}

