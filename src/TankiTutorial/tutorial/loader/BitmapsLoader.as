package tutorial.loader
{
   import flash.display.BitmapData;
   import tutorial.commons.Assets;
   
   public class BitmapsLoader extends TanksLoader
   {
      
      private var urls:Vector.<String>;
      
      private var ids:Vector.<String>;
      
      private var index:int;
      
      public function BitmapsLoader()
      {
         super();
      }
      
      override public function check(sceneXML:XML) : Boolean
      {
         return sceneXML.bitmaps.length() > 0;
      }
      
      override public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
         var bitmapXML:XML = null;
         this.xml = sceneXML.bitmaps[0];
         this.callback = completeListener;
         this.urls = new Vector.<String>();
         this.ids = new Vector.<String>();
         this.index = 0;
         var baseURL:String = sceneURL + xml.@baseURL;
         var i:int = 0;
         for each(bitmapXML in xml.elements("bitmap"))
         {
            this.ids[i] = bitmapXML.@id.toString();
            this.urls[i] = baseURL + bitmapXML.@url.toString();
            i++;
         }
         this.loadBitmaps();
      }
      
      private function loadBitmaps(bitmapData:BitmapData = null) : void
      {
         if(bitmapData != null)
         {
            Assets.saveData(this.ids[this.index],bitmapData,BitmapData);
            ++this.index;
         }
         if(this.index < this.urls.length)
         {
            if(Assets.hasData(this.ids[this.index],BitmapData))
            {
               ++this.index;
               this.loadBitmaps();
            }
            else
            {
               currentURL = this.urls[this.index];
               imageLoader.load(this.urls[this.index],this.loadBitmaps);
            }
         }
         else if(callback != null)
         {
            callback();
         }
      }
   }
}

