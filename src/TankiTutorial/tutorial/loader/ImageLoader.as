package tutorial.loader
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import tutorial.GameData;
   import tutorial.commons.Shared;
   
   public class ImageLoader extends BaseLoader
   {
      
      private static const cache:Object = new Object();
      
      private static const point:Point = new Point();
      
      private var callback:Function;
      
      private var trackProgress:Boolean;
      
      private var loader:Loader;
      
      private var urlLoader:URLLoader;
      
      private var opaqueBytes:ByteArray = new ByteArray();
      
      private var alphaBytes:ByteArray = new ByteArray();
      
      private var bitmapData:BitmapData;
      
      public function ImageLoader(trackProgress:Boolean = true)
      {
         super();
         this.trackProgress = trackProgress;
      }
      
      public function load(url:String, callback:Function) : void
      {
         this.callback = callback;
         var cached:BitmapData = cache[url];
         if(cached != null)
         {
            Shared.clientLog.addLine("cached :: " + url);
            callback(cached);
         }
         else if(url.indexOf(".bin") > 0)
         {
            this.loadCompressed(url);
         }
         else
         {
            this.loadUncompressed(url);
         }
      }
      
      private function loadUncompressed(url:String) : void
      {
         this.loader = TanksLoader.createLoader(this.saveUncompressed,this.onError,this.trackProgress ? onProgress : null);
         currentURL = url;
         var context:LoaderContext = new LoaderContext();
         if("imageDecodingPolicy" in context)
         {
            context.imageDecodingPolicy = "onLoad";
         }
         this.loader.load(new URLRequest(currentURL),context);
      }
      
      private function onError(errorEvent:ErrorEvent) : void
      {
         var result:BitmapData = null;
         this.loader = null;
         this.urlLoader = null;
         this.callback(result);
      }
      
      private function saveUncompressed(e:Event) : void
      {
         var bitmap:Bitmap = this.loader.content as Bitmap;
         this.loader = null;
         onFinishLoad();
         cache[currentURL] = bitmap.bitmapData;
         GameData.colorize(bitmap.bitmapData);
         this.callback(bitmap.bitmapData);
      }
      
      private function loadCompressed(url:String) : void
      {
         this.urlLoader = TanksLoader.createURLLoader(this.onCompressedLoaded,this.onError,this.trackProgress ? onProgress : null);
         this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         currentURL = url;
         this.urlLoader.load(new URLRequest(url));
      }
      
      private function onCompressedLoaded(e:Event) : void
      {
         var data:* = this.urlLoader.data;
         this.urlLoader = null;
         onFinishLoad();
         this.uncompressImage(data);
      }
      
      private function uncompressImage(data:ByteArray) : void
      {
         data.uncompress();
         this.opaqueBytes.length = 0;
         this.alphaBytes.length = 0;
         var opaqueSize:uint = data.readUnsignedInt();
         data.readBytes(this.opaqueBytes,0,opaqueSize);
         var alphaSize:uint = data.readUnsignedInt();
         data.readBytes(this.alphaBytes,0,alphaSize);
         this.loader = TanksLoader.createLoader(this.onOpaueLoaded,this.onError);
         this.loader.loadBytes(this.opaqueBytes);
      }
      
      private function onOpaueLoaded(e:Event) : void
      {
         var opaque:BitmapData = Bitmap(this.loader.content).bitmapData;
         this.bitmapData = new BitmapData(opaque.width,opaque.height,true,0);
         this.bitmapData.draw(opaque);
         opaque.dispose();
         this.loader = TanksLoader.createLoader(this.onAlphaLoaded,this.onError);
         this.loader.loadBytes(this.alphaBytes);
      }
      
      private function onAlphaLoaded(e:Event) : void
      {
         var alpha:BitmapData = Bitmap(this.loader.content).bitmapData;
         this.bitmapData.copyChannel(alpha,alpha.rect,point,BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
         alpha.dispose();
         this.loader = null;
         cache[currentURL] = this.bitmapData;
         GameData.colorize(this.bitmapData);
         this.callback(this.bitmapData);
      }
   }
}

