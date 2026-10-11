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
      
      private var turrets:Vector.<XML>;
      
      private var id:String;
      
      private var baseURL:String;
      
      private var index:int;
      
      private var current:TankTurret;
      
      public function TurretsLoader()
      {
         super();
      }
      
      override public function check(sceneXML:XML) : Boolean
      {
         return sceneXML.turrets.length() > 0;
      }
      
      override public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
         var turretXML:XML = null;
         this.xml = sceneXML.turrets[0];
         this.callback = completeListener;
         this.turrets = new Vector.<XML>();
         this.index = 0;
         this.baseURL = sceneURL + xml.@baseURL;
         var i:int = 0;
         for each(turretXML in xml.elements("turret"))
         {
            this.turrets[i] = turretXML;
            i++;
         }
         this.loadTurret();
      }
      
      private function loadTurret(details:BitmapData = null) : void
      {
         var turretXML:XML = null;
         var urlLoader:URLLoader = null;
         if(details != null)
         {
            this.current.vypupital = details;
            this.current = null;
            ++this.index;
         }
         if(this.index < this.turrets.length)
         {
            turretXML = this.turrets[this.index];
            this.id = turretXML.@id.toString();
            currentURL = this.baseURL + turretXML.@url.toString();
            if(!Assets.hasData(currentURL,ByteArray))
            {
               urlLoader = new URLLoader();
               urlLoader.addEventListener(Event.COMPLETE,this.loadLightmap);
               urlLoader.addEventListener(ProgressEvent.PROGRESS,onProgress);
               urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
               urlLoader.load(new URLRequest(currentURL));
            }
            else
            {
               this.parse(Assets.getData(currentURL,ByteArray));
               this.current.sut = Assets.getData(this.baseURL + turretXML.@lightmap.toString(),BitmapData);
               this.current.vypupital = Assets.getData(this.baseURL + turretXML.@details.toString(),BitmapData);
               this.current = null;
               ++this.index;
               this.loadTurret();
            }
         }
         else if(callback != null)
         {
            callback();
         }
      }
      
      private function parse(data:ByteArray) : XML
      {
         this.current = this.parseTurret(data);
         Turrets.objects[this.id] = this.current;
         var turretXML:XML = this.turrets[this.index];
         this.current.qupi = turretXML.@turnAcceleration;
         this.current.gejebuke = turretXML.@maxTurnSpeed;
         this.current.beryfitu = turretXML.@damage;
         return turretXML;
      }
      
      private function loadLightmap(e:Event) : void
      {
         var urlLoader:URLLoader = URLLoader(e.target);
         urlLoader.removeEventListener(Event.COMPLETE,this.loadLightmap);
         urlLoader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
         var turretXML:XML = this.parse(urlLoader.data);
         var lightmapURL:String = this.baseURL + turretXML.@lightmap.toString();
         var loader:Loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadDetails);
         loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
         loader.load(new URLRequest(lightmapURL));
      }
      
      private function loadDetails(e:Event) : void
      {
         var loaderInfo:LoaderInfo = LoaderInfo(e.target);
         this.current.sut = Bitmap(loaderInfo.content).bitmapData;
         loaderInfo.removeEventListener(Event.COMPLETE,this.loadDetails);
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
         var turretXML:XML = this.turrets[this.index];
         var detailsURL:String = this.baseURL + turretXML.@details.toString();
         imageLoader.load(detailsURL,this.loadTurret);
      }
      
      private function parseTurret(data:ByteArray) : TankTurret
      {
         var mesh:Mesh = null;
         var objectName:String = null;
         var position:Vector3D = null;
         var parser:Parser3DS = new Parser3DS();
         if(currentURL.indexOf(".3dz") > 0)
         {
            data.uncompress();
         }
         parser.parse(data);
         var turret:TankTurret = new TankTurret();
         turret.name = this.id;
         var len:int = int(parser.objects.length);
         var i:int = 0;
         while(i < len)
         {
            mesh = parser.objects[i] as Mesh;
            if(mesh != null)
            {
               objectName = mesh.name.toLowerCase();
               if(objectName.indexOf("turret") == 0)
               {
                  turret.kuca = mesh;
                  mesh.sorting = Sorting.DYNAMIC_BSP;
                  mesh.optimizeForDynamicBSP();
                  mesh.calculateVerticesNormalsByAngle(GameData.angle,GameData.threshold);
               }
               else if(objectName.indexOf("fmnt") == 0)
               {
                  position = mesh.matrix.position;
                  turret.luru.x = position.x;
                  turret.luru.y = position.y;
                  turret.luru.z = position.z;
               }
               else if(objectName.indexOf("muzzle") == 0)
               {
                  position = mesh.matrix.position;
                  turret.jun.push(new Vector3(position.x,position.y,position.z));
               }
            }
            i++;
         }
         return turret;
      }
   }
}

