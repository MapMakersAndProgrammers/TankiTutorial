package tutorial.loader
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   import tutorial.commons.Assets;
   
   public class SWFLoader extends TanksLoader
   {
      
      private var ryv:Vector.<String>;
      
      private var besitelob:Vector.<String>;
      
      private var dodycoli:int;
      
      private var wija:Loader;
      
      public function SWFLoader()
      {
         super();
      }
      
      override public function check(param1:XML) : Boolean
      {
         return param1.movies.length() > 0;
      }
      
      override public function load(param1:String, param2:XML, param3:Function) : void
      {
         var _loc6_:XML = null;
         this.pomagu = param2.movies[0];
         this.hon = param3;
         this.ryv = new Vector.<String>();
         this.besitelob = new Vector.<String>();
         this.dodycoli = 0;
         var _loc4_:String = param1 + pomagu.@baseURL;
         var _loc5_:int = 0;
         for each(_loc6_ in pomagu.elements("movie"))
         {
            this.besitelob[_loc5_] = _loc6_.@id.toString();
            this.ryv[_loc5_] = _loc4_ + _loc6_.@url.toString();
            _loc5_++;
         }
         this.loadMovies();
      }
      
      private function loadMovies(param1:Event = null) : void
      {
         if(param1 != null)
         {
            Assets.saveData(this.besitelob[this.dodycoli],this.wija.content,MovieClip);
            ++this.dodycoli;
         }
         if(this.dodycoli < this.ryv.length)
         {
            if(Assets.hasData(this.besitelob[this.dodycoli],MovieClip))
            {
               ++this.dodycoli;
               this.loadMovies();
            }
            else
            {
               this.wija = createLoader(this.loadMovies,onError,onProgress);
               this.wija.load(new URLRequest(this.ryv[this.dodycoli]));
            }
         }
         else if(hon != null)
         {
            this.wija = null;
            hon();
         }
      }
      
      override protected function nextItem() : void
      {
         this.loadMovies();
      }
   }
}

