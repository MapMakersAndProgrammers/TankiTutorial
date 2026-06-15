package tutorial.loader
{
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.tanks.vehicles.tank.TankHull;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.geom.Vector3D;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import tutorial.GameData;
   import tutorial.Hulls;
   import tutorial.commons.Assets;
   
   public class HullsLoader extends TanksLoader
   {
      
      private var vobav:Vector.<XML>;
      
      private var wucejydy:String;
      
      private var luwuqap:String;
      
      private var dodycoli:int;
      
      private var zewucadiz:TankHull;
      
      public function HullsLoader()
      {
         super();
      }
      
      override public function check(param1:XML) : Boolean
      {
         return param1.hulls.length() > 0;
      }
      
      override public function load(param1:String, param2:XML, param3:Function) : void
      {
         var _loc5_:XML = null;
         this.pomagu = param2.hulls[0];
         this.hon = param3;
         this.vobav = new Vector.<XML>();
         this.dodycoli = 0;
         this.luwuqap = param1 + pomagu.@baseURL;
         var _loc4_:int = 0;
         for each(_loc5_ in pomagu.elements("hull"))
         {
            this.vobav[_loc4_] = _loc5_;
            _loc4_++;
         }
         this.loadHulls();
      }
      
      private function loadHulls(param1:BitmapData = null) : void
      {
         var _loc2_:XML = null;
         var _loc3_:URLLoader = null;
         if(param1 != null)
         {
            this.zewucadiz.vypupital = param1;
            this.zewucadiz = null;
            ++this.dodycoli;
         }
         if(this.dodycoli < this.vobav.length)
         {
            _loc2_ = this.vobav[this.dodycoli];
            this.wucejydy = _loc2_.@id.toString();
            julicoj = this.luwuqap + _loc2_.@url.toString();
            if(!Assets.hasData(julicoj,ByteArray))
            {
               _loc3_ = new URLLoader();
               _loc3_.addEventListener(Event.COMPLETE,this.loadLightmap);
               _loc3_.addEventListener(ProgressEvent.PROGRESS,onProgress);
               _loc3_.dataFormat = URLLoaderDataFormat.BINARY;
               _loc3_.load(new URLRequest(julicoj));
            }
            else
            {
               this.parse(Assets.getData(julicoj,ByteArray));
               this.zewucadiz.sut = Assets.getData(this.luwuqap + _loc2_.@lightmap.toString(),BitmapData);
               this.zewucadiz.vypupital = Assets.getData(this.luwuqap + _loc2_.@details.toString(),BitmapData);
               this.zewucadiz = null;
               ++this.dodycoli;
               this.loadHulls();
            }
         }
         else if(hon != null)
         {
            hon();
         }
      }
      
      private function loadLightmap(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,this.loadLightmap);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,onProgress);
         var _loc3_:XML = this.parse(_loc2_.data);
         var _loc4_:String = this.luwuqap + _loc3_.@lightmap.toString();
         bita.load(_loc4_,this.loadDetails);
      }
      
      private function parse(param1:ByteArray) : XML
      {
         this.zewucadiz = this.parseHull(param1);
         Hulls.leqib[this.wucejydy] = this.zewucadiz;
         var _loc2_:XML = this.vobav[this.dodycoli];
         Hulls.applyProfile(_loc2_,this.zewucadiz);
         return _loc2_;
      }
      
      private function loadDetails(param1:BitmapData) : void
      {
         this.zewucadiz.sut = param1;
         var _loc2_:XML = this.vobav[this.dodycoli];
         var _loc3_:String = this.luwuqap + _loc2_.@details.toString();
         bita.load(_loc3_,this.loadHulls);
      }
      
      private function parseHull(param1:ByteArray) : TankHull
      {
         var _loc6_:Mesh = null;
         var _loc7_:String = null;
         var _loc8_:Vector3D = null;
         var _loc2_:Parser3DS = new Parser3DS();
         if(julicoj.indexOf(".3dz") > 0)
         {
            param1.uncompress();
         }
         _loc2_.parse(param1);
         var _loc3_:TankHull = new TankHull();
         var _loc4_:int = int(_loc2_.objects.length);
         _loc3_.gepocivaj = this.wucejydy;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_.objects[_loc5_] as Mesh;
            _loc7_ = _loc6_.name.toLowerCase();
            if(_loc7_.indexOf("hull") == 0)
            {
               _loc3_.kuca = _loc6_;
               _loc6_.sorting = Sorting.DYNAMIC_BSP;
               _loc6_.optimizeForDynamicBSP();
               _loc6_.calculateVerticesNormalsByAngle(GameData.qusejov,GameData.hevarer);
            }
            else if(_loc7_.indexOf("mount") == 0)
            {
               _loc8_ = Mesh(_loc6_).matrix.position;
               _loc3_.sih.reset(_loc8_.x,_loc8_.y,_loc8_.z);
            }
            _loc5_++;
         }
         return _loc3_;
      }
   }
}

