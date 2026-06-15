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
      
      private var ryv:Vector.<String>;
      
      private var guz:Vector.<int>;
      
      private var luwuqap:String;
      
      private var dodycoli:int;
      
      private var wija:URLLoader;
      
      public function PropLibsLoader()
      {
         super();
      }
      
      override public function check(param1:XML) : Boolean
      {
         return param1.proplibs.length() > 0;
      }
      
      override public function load(param1:String, param2:XML, param3:Function) : void
      {
         var _loc5_:XML = null;
         this.pomagu = param2.proplibs[0];
         this.hon = param3;
         this.luwuqap = param1 + pomagu.@baseURL;
         this.ryv = new Vector.<String>();
         this.guz = new Vector.<int>();
         this.dodycoli = 0;
         var _loc4_:int = 0;
         for each(_loc5_ in pomagu.elements("proplib"))
         {
            this.ryv[_loc4_] = this.luwuqap + XMLUtils.getAttributeAsString(_loc5_,"url");
            this.guz[_loc4_] = XMLUtils.getAttributeAsInt(_loc5_,"priority");
            _loc4_++;
         }
         this.loadLib();
      }
      
      private function loadLib(param1:Event = null) : void
      {
         if(param1 != null)
         {
            this.parse(XML(this.wija.data));
            ++this.dodycoli;
         }
         if(this.dodycoli < this.ryv.length)
         {
            julicoj = this.ryv[this.dodycoli] + "library.xml";
            if(Assets.hasData(julicoj,XML))
            {
               this.parse(Assets.getData(julicoj,XML));
               ++this.dodycoli;
               this.loadLib();
            }
            else
            {
               this.wija = createURLLoader(this.loadLib,onError,onProgress);
               this.wija.load(new URLRequest(this.ryv[this.dodycoli] + "library.xml"));
            }
         }
         else
         {
            this.wija = null;
            hon();
         }
      }
      
      private function parse(param1:XML) : void
      {
         var _loc2_:PropLibrary = new PropLibrary(param1,this.ryv[this.dodycoli]);
         _loc2_.gohigewam = this.guz[this.dodycoli];
         Assets.saveData(_loc2_.gepocivaj,_loc2_,PropLibrary);
      }
   }
}

