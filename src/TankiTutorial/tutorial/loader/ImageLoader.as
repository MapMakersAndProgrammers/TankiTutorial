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
      
      private static const ryparyg:Object = new Object();
      
      private static const mutedog:Point = new Point();
      
      private var hon:Function;
      
      private var vun:Boolean;
      
      private var kiga:Loader;
      
      private var noni:URLLoader;
      
      private var wutacynid:ByteArray = new ByteArray();
      
      private var jify:ByteArray = new ByteArray();
      
      private var qiru:BitmapData;
      
      public function ImageLoader(param1:Boolean = true)
      {
         super();
         this.vun = param1;
      }
      
      public function load(param1:String, param2:Function) : void
      {
         this.hon = param2;
         var _loc3_:BitmapData = ryparyg[param1];
         if(_loc3_ != null)
         {
            Shared.clientLog.addLine("cached :: " + param1);
            param2(_loc3_);
         }
         else if(param1.indexOf(".bin") > 0)
         {
            this.loadCompressed(param1);
         }
         else
         {
            this.loadUncompressed(param1);
         }
      }
      
      private function loadUncompressed(param1:String) : void
      {
         this.kiga = TanksLoader.createLoader(this.saveUncompressed,this.onError,this.vun ? onProgress : null);
         julicoj = param1;
         var _loc2_:LoaderContext = new LoaderContext();
         if("imageDecodingPolicy" in _loc2_)
         {
            _loc2_.imageDecodingPolicy = "onLoad";
         }
         this.kiga.load(new URLRequest(julicoj),_loc2_);
      }
      
      private function onError(param1:ErrorEvent) : void
      {
         var _loc2_:BitmapData = null;
         this.kiga = null;
         this.noni = null;
         this.hon(_loc2_);
      }
      
      private function saveUncompressed(param1:Event) : void
      {
         var _loc2_:Bitmap = this.kiga.content as Bitmap;
         this.kiga = null;
         onFinishLoad();
         ryparyg[julicoj] = _loc2_.bitmapData;
         GameData.colorize(_loc2_.bitmapData);
         this.hon(_loc2_.bitmapData);
      }
      
      private function loadCompressed(param1:String) : void
      {
         this.noni = TanksLoader.createURLLoader(this.onCompressedLoaded,this.onError,this.vun ? onProgress : null);
         this.noni.dataFormat = URLLoaderDataFormat.BINARY;
         julicoj = param1;
         this.noni.load(new URLRequest(param1));
      }
      
      private function onCompressedLoaded(param1:Event) : void
      {
         var _loc2_:* = this.noni.data;
         this.noni = null;
         onFinishLoad();
         this.uncompressImage(_loc2_);
      }
      
      private function uncompressImage(param1:ByteArray) : void
      {
         param1.uncompress();
         this.wutacynid.length = 0;
         this.jify.length = 0;
         var _loc2_:uint = param1.readUnsignedInt();
         param1.readBytes(this.wutacynid,0,_loc2_);
         var _loc3_:uint = param1.readUnsignedInt();
         param1.readBytes(this.jify,0,_loc3_);
         this.kiga = TanksLoader.createLoader(this.onOpaueLoaded,this.onError);
         this.kiga.loadBytes(this.wutacynid);
      }
      
      private function onOpaueLoaded(param1:Event) : void
      {
         var _loc2_:BitmapData = Bitmap(this.kiga.content).bitmapData;
         this.qiru = new BitmapData(_loc2_.width,_loc2_.height,true,0);
         this.qiru.draw(_loc2_);
         _loc2_.dispose();
         this.kiga = TanksLoader.createLoader(this.onAlphaLoaded,this.onError);
         this.kiga.loadBytes(this.jify);
      }
      
      private function onAlphaLoaded(param1:Event) : void
      {
         var _loc2_:BitmapData = Bitmap(this.kiga.content).bitmapData;
         this.qiru.copyChannel(_loc2_,_loc2_.rect,mutedog,BitmapDataChannel.RED,BitmapDataChannel.ALPHA);
         _loc2_.dispose();
         this.kiga = null;
         ryparyg[julicoj] = this.qiru;
         GameData.colorize(this.qiru);
         this.hon(this.qiru);
      }
   }
}

