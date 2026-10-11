package tutorial.loader
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class MeshesLoader extends TanksLoader
   {
      
      private var meshes:Vector.<XML>;
      
      private var id:String;
      
      private var baseURL:String;
      
      private var index:int;
      
      private var current:Mesh;
      
      private var urlLoader:URLLoader;
      
      public function MeshesLoader()
      {
         super();
      }
      
      override public function check(sceneXML:XML) : Boolean
      {
         return sceneXML.meshes.length() > 0;
      }
      
      override public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
         var meshXML:XML = null;
         this.xml = sceneXML.meshes[0];
         this.callback = completeListener;
         this.meshes = new Vector.<XML>();
         this.index = 0;
         this.baseURL = sceneURL + xml.@baseURL;
         var i:int = 0;
         for each(meshXML in xml.elements("mesh"))
         {
            this.meshes[i] = meshXML;
            i++;
         }
         this.loadMesh();
      }
      
      private function loadMesh(bitmapData:BitmapData = null) : void
      {
         var meshXML:XML = null;
         var data:ByteArray = null;
         var texture:BitmapData = null;
         var mesh:Mesh = null;
         if(bitmapData != null)
         {
            this.current.setMaterialToAllFaces(new TextureMaterial(bitmapData,false,true,MipMapping.PER_PIXEL,2.5));
            Assets.saveData(this.id,this.current,Mesh);
            this.current = null;
            ++this.index;
         }
         if(this.index < this.meshes.length)
         {
            meshXML = this.meshes[this.index];
            this.id = meshXML.@id.toString();
            if(Assets.hasData(this.id,ByteArray))
            {
               data = Assets.getData(this.id,ByteArray);
               texture = Assets.getData(this.id,BitmapData);
               mesh = this.parseMesh(data);
               mesh.setMaterialToAllFaces(new TextureMaterial(texture,false,true,MipMapping.PER_PIXEL,2.5));
               Assets.saveData(this.id,mesh,Mesh);
               ++this.index;
               this.loadMesh();
            }
            else
            {
               this.urlLoader = createURLLoader(this.loadTexture,onError,onProgress);
               this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
               currentURL = this.baseURL + meshXML.@url.toString();
               this.urlLoader.load(new URLRequest(currentURL));
            }
         }
         else if(callback != null)
         {
            callback();
         }
      }
      
      private function loadTexture(e:Event) : void
      {
         this.current = this.parseMesh(this.urlLoader.data);
         this.urlLoader = null;
         var meshXML:XML = this.meshes[this.index];
         var textureURL:String = this.baseURL + meshXML.@texture.toString();
         imageLoader.load(textureURL,this.loadMesh);
      }
      
      private function parseMesh(data:ByteArray) : Mesh
      {
         var mesh:Mesh = null;
         var parser:Parser3DS = new Parser3DS();
         parser.parse(data);
         var len:int = int(parser.objects.length);
         var i:int = 0;
         while(i < len)
         {
            mesh = parser.objects[i] as Mesh;
            if(mesh != null)
            {
               mesh.sorting = Sorting.DYNAMIC_BSP;
               mesh.optimizeForDynamicBSP();
               mesh.calculateVerticesNormalsByAngle(GameData.angle,GameData.threshold);
               return mesh;
            }
            i++;
         }
         return null;
      }
   }
}

