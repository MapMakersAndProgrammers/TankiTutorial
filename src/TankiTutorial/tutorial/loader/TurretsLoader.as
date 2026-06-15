package tutorial.loader
{
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.TankTurret;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.geom.Vector3D;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import tutorial.GameData;
   import tutorial.Turrets;
   import tutorial.commons.Assets;
   
   public class TurretsLoader extends TanksLoader
   {
      
      private var paqowom:Vector.<XML>;
      
      private var wucejydy:String;
      
      private var luwuqap:String;
      
      private var dodycoli:int;
      
      private var zewucadiz:TankTurret;
      
      public function TurretsLoader()
      {
         super();
      }
      
      override public function check(param1:XML) : Boolean
      {
         return param1.turrets.length() > 0;
      }
      
      override public function load(param1:String, param2:XML, param3:Function) : void
      {
         var _loc5_:XML = null;
         this.pomagu = param2.turrets[0];
         this.hon = param3;
         this.paqowom = new Vector.<XML>();
         this.dodycoli = 0;
         this.luwuqap = param1 + pomagu.@baseURL;
         var _loc4_:int = 0;
         for each(_loc5_ in pomagu.elements("turret"))
         {
            this.paqowom[_loc4_] = _loc5_;
            _loc4_++;
         }
         this.loadTurret();
      }
      
      private function loadTurret(param1:BitmapData = null) : void
      {
         var _loc2_:XML = null;
         var _loc3_:URLLoader = null;
         if(param1 != null)
         {
            this.zewucadiz.vypupital = param1;
            this.zewucadiz = null;
            ++this.dodycoli;
         }
         if(this.dodycoli < this.paqowom.length)
         {
            _loc2_ = this.paqowom[this.dodycoli];
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
               this.loadTurret();
            }
         }
         else if(hon != null)
         {
            hon();
         }
      }
      
      private function parse(param1:ByteArray) : XML
      {
         this.zewucadiz = this.parseTurret(param1);
         Turrets.leqib[this.wucejydy] = this.zewucadiz;
         var _loc2_:XML = this.paqowom[this.dodycoli];
         this.zewucadiz.qupi = _loc2_.@turnAcceleration;
         this.zewucadiz.gejebuke = _loc2_.@maxTurnSpeed;
         this.zewucadiz.beryfitu = _loc2_.@damage;
         return _loc2_;
      }
      
      private function loadLightmap(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.target);
         _loc2_.removeEventListener(Event.COMPLETE,this.loadLightmap);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,onProgress);
         var _loc3_:XML = this.parse(_loc2_.data);
         var _loc4_:String = this.luwuqap + _loc3_.@lightmap.toString();
         var _loc5_:Loader = new Loader();
         _loc5_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadDetails);
         _loc5_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
         _loc5_.load(new URLRequest(_loc4_));
      }
      
      private function loadDetails(param1:Event) : void
      {
         var _loc2_:LoaderInfo = LoaderInfo(param1.target);
         this.zewucadiz.sut = Bitmap(_loc2_.content).bitmapData;
         _loc2_.removeEventListener(Event.COMPLETE,this.loadDetails);
         _loc2_.removeEventListener(ProgressEvent.PROGRESS,onProgress);
         var _loc3_:XML = this.paqowom[this.dodycoli];
         var _loc4_:String = this.luwuqap + _loc3_.@details.toString();
         bita.load(_loc4_,this.loadTurret);
      }
      
      private function parseTurret(param1:ByteArray) : TankTurret
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
         var _loc3_:TankTurret = new TankTurret();
         _loc3_.gepocivaj = this.wucejydy;
         var _loc4_:int = int(_loc2_.objects.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_.objects[_loc5_] as Mesh;
            if(_loc6_ != null)
            {
               _loc7_ = _loc6_.name.toLowerCase();
               if(_loc7_.indexOf("turret") == 0)
               {
                  _loc3_.kuca = _loc6_;
                  _loc6_.sorting = Sorting.DYNAMIC_BSP;
                  _loc6_.optimizeForDynamicBSP();
                  _loc6_.calculateVerticesNormalsByAngle(GameData.qusejov,GameData.hevarer);
               }
               else if(_loc7_.indexOf("fmnt") == 0)
               {
                  _loc8_ = _loc6_.matrix.position;
                  _loc3_.luru.x = _loc8_.x;
                  _loc3_.luru.y = _loc8_.y;
                  _loc3_.luru.qyririg = _loc8_.z;
               }
               else if(_loc7_.indexOf("muzzle") == 0)
               {
                  _loc8_ = _loc6_.matrix.position;
                  _loc3_.jun.push(new Vector3(_loc8_.x,_loc8_.y,_loc8_.z));
               }
            }
            _loc5_++;
         }
         return _loc3_;
      }
   }
}

