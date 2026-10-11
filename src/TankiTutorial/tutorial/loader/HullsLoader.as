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
      
      private var hulls:Vector.<XML>;
      
      private var id:String;
      
      private var baseURL:String;
      
      private var index:int;
      
      private var current:TankHull;
      
      public function HullsLoader()
      {
         super();
      }
      
      override public function check(sceneXML:XML) : Boolean
      {
         return sceneXML.hulls.length() > 0;
      }
      
      override public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
         var hullXML:XML = null;
         this.xml = sceneXML.hulls[0];
         this.callback = completeListener;
         this.hulls = new Vector.<XML>();
         this.index = 0;
         this.baseURL = sceneURL + xml.@baseURL;
         var i:int = 0;
         for each(hullXML in xml.elements("hull"))
         {
            this.hulls[i] = hullXML;
            i++;
         }
         this.loadHulls();
      }
      
      private function loadHulls(details:BitmapData = null) : void
      {
         var hullXML:XML = null;
         var urlLoader:URLLoader = null;
         if(details != null)
         {
            this.current.vypupital = details;
            this.current = null;
            ++this.index;
         }
         if(this.index < this.hulls.length)
         {
            hullXML = this.hulls[this.index];
            this.id = hullXML.@id.toString();
            currentURL = this.baseURL + hullXML.@url.toString();
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
               this.current.sut = Assets.getData(this.baseURL + hullXML.@lightmap.toString(),BitmapData);
               this.current.vypupital = Assets.getData(this.baseURL + hullXML.@details.toString(),BitmapData);
               this.current = null;
               ++this.index;
               this.loadHulls();
            }
         }
         else if(callback != null)
         {
            callback();
         }
      }
      
      private function loadLightmap(e:Event) : void
      {
         var urlLoader:URLLoader = URLLoader(e.target);
         urlLoader.removeEventListener(Event.COMPLETE,this.loadLightmap);
         urlLoader.removeEventListener(ProgressEvent.PROGRESS,onProgress);
         var hullXML:XML = this.parse(urlLoader.data);
         var lightmapURL:String = this.baseURL + hullXML.@lightmap.toString();
         imageLoader.load(lightmapURL,this.loadDetails);
      }
      
      private function parse(data:ByteArray) : XML
      {
         this.current = this.parseHull(data);
         Hulls.objects[this.id] = this.current;
         var hullXML:XML = this.hulls[this.index];
         Hulls.applyProfile(hullXML,this.current);
         return hullXML;
      }
      
      private function loadDetails(lightmap:BitmapData) : void
      {
         this.current.sut = lightmap;
         var hullXML:XML = this.hulls[this.index];
         var detailsURL:String = this.baseURL + hullXML.@details.toString();
         imageLoader.load(detailsURL,this.loadHulls);
      }
      
      private function parseHull(data:ByteArray) : TankHull
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
         var hull:TankHull = new TankHull();
         var len:int = int(parser.objects.length);
         hull.name = this.id;
         var i:int = 0;
         while(i < len)
         {
            mesh = parser.objects[i] as Mesh;
            objectName = mesh.name.toLowerCase();
            if(objectName.indexOf("hull") == 0)
            {
               hull.kuca = mesh;
               mesh.sorting = Sorting.DYNAMIC_BSP;
               mesh.optimizeForDynamicBSP();
               mesh.calculateVerticesNormalsByAngle(GameData.angle,GameData.threshold);
            }
            else if(objectName.indexOf("mount") == 0)
            {
               position = Mesh(mesh).matrix.position;
               hull.sih.reset(position.x,position.y,position.z);
            }
            i++;
         }
         return hull;
      }
   }
}

