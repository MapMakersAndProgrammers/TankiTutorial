package tutorial.loader.proplib
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Occluder;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   import tutorial.loader.BaseLoader;
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;

   public class PropMesh extends BaseLoader
   {
      
      public static var threshold:Number = 0.01;
      
      public static var occluderDistanceThreshold:Number = 0.01;
      
      public static var occluderAngleThreshold:Number = 0.01;
      
      public static var occluderConvexThreshold:Number = 0.01;
      
      public static var occluderUVThreshold:int = 1;
      
      public static var distanceThreshold:Number = 0.001;
      
      public static var uvThreshold:Number = 0.0001;
      
      public static var angleThreshold:Number = 0.001;
      
      public static var convexThreshold:Number = 0.01;
      
      public var name:String;
      
      private var url:String;
      
      private var textures:Object;
      
      private var mesh:Mesh;
      
      private var callback:Function;
      
      public var occluders:Vector.<Occluder>;
      
      private var urlLoader:URLLoader;
      
      private var textureName:String;
      
      private var baseURL:String;
      
      public function PropMesh(xml:XML, baseURL:String)
      {
         var textureXML:XML = null;
         var texture:PropTexture = null;
         this.textures = new Object();
         super();
         this.baseURL = baseURL;
         this.url = baseURL + XMLUtils.getAttributeAsString(xml,"file");
         for each(textureXML in xml.texture)
         {
            texture = new PropTexture(textureXML.@name.toString(),XMLUtils.getAttributeAsString(textureXML,"diffuse-map"),baseURL);
            this.textures[texture.name] = texture;
         }
      }
      
      public function load(textureName:String, callback:Function) : void
      {
         this.textureName = textureName;
         if(this.mesh == null)
         {
            this.callback = callback;
            if(!Assets.hasData(this.url,Parser3DS))
            {
               currentURL = this.url;
               this.urlLoader = new URLLoader();
               this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
               this.urlLoader.addEventListener(ProgressEvent.PROGRESS,onProgress);
               this.urlLoader.addEventListener(Event.COMPLETE,this.onComplete);
               this.urlLoader.load(new URLRequest(this.url));
            }
            else if(this.url.indexOf(".3dz") >= 0)
            {
               this.parse2(Assets.getData(this.url,Parser3DS));
            }
            else
            {
               this.parse(Assets.getData(this.url,ByteArray));
            }
         }
         else
         {
            callback(this.getMesh(),this.occluders);
         }
      }
      
      private function initMesh(m:Mesh) : void
      {
         var newMaterial:TextureMaterial = null;
         m.weldVertices(distanceThreshold,uvThreshold);
         m.weldFaces(angleThreshold,uvThreshold,convexThreshold);
         m.calculateVerticesNormalsByAngle(GameData.angle,GameData.threshold);
         m.threshold = threshold;
         var material:TextureMaterial = m.faceList.material as TextureMaterial;
         if(material != null)
         {
            newMaterial = new TextureMaterial();
            newMaterial.diffuseMapURL = this.baseURL + material.diffuseMapURL;
            newMaterial.threshold = material.threshold;
            newMaterial.correctUV = material.correctUV;
            m.setMaterialToAllFaces(newMaterial);
         }
      }
      
      private function initMesh2(m:Mesh) : void
      {
         var newMaterial:TextureMaterial = null;
         m.threshold = threshold;
         var material:TextureMaterial = m.faceList.material as TextureMaterial;
         if(material != null)
         {
            newMaterial = new TextureMaterial();
            newMaterial.diffuseMapURL = this.baseURL + material.diffuseMapURL;
            newMaterial.threshold = material.threshold;
            newMaterial.correctUV = material.correctUV;
            m.setMaterialToAllFaces(newMaterial);
         }
      }
      
      private function parse(data:ByteArray) : void
      {
         var object:Object3D = null;
         var objectName:String = null;
         var parser:Parser3DS = new Parser3DS();
         var bytes:ByteArray = new ByteArray();
         bytes.writeBytes(data);
         if(this.url.indexOf(".3dz") > 0)
         {
            bytes.uncompress();
         }
         bytes.position = 0;
         this.urlLoader = null;
         onFinishLoad();
         parser.parse(bytes);
         var objects:Vector.<Object3D> = parser.objects;
         var len:int = int(objects.length);
         var i:int = 0;
         while(i < len)
         {
            object = objects[i];
            objectName = object.name.toLowerCase();
            if(objectName.indexOf("occl") == 0)
            {
               this.addOccluder(Mesh(object));
            }
            i++;
         }
         this.mesh = Mesh(objects[0]);
         this.initMesh(this.mesh);
         this.callback(this.getMesh(),this.occluders);
         this.callback = null;
      }
      
      private function parse2(parser:Parser3DS) : void
      {
         var object:Object3D = null;
         var objectName:String = null;
         var objects:Vector.<Object3D> = parser.objects;
         var len:int = int(objects.length);
         var i:int = 0;
         while(i < len)
         {
            object = objects[i];
            objectName = object.name.toLowerCase();
            if(objectName.indexOf("occl") == 0)
            {
               this.addOccluder(Mesh(object.clone()));
            }
            i++;
         }
         this.mesh = Mesh(objects[0]);
         this.initMesh2(this.mesh);
         this.callback(this.getMesh(),this.occluders);
         this.callback = null;
      }
      
      private function onComplete(e:Event) : void
      {
         Assets.saveData(this.url,this.urlLoader.data,ByteArray);
         this.parse(this.urlLoader.data);
      }
      
      private function getMesh() : Mesh
      {
         var res:Mesh = this.mesh.clone() as Mesh;
         if(this.textureName == null)
         {
            res.setMaterialToAllFaces(this.mesh.faceList.material);
         }
         else if(this.textureName == "invisible")
         {
            res.setMaterialToAllFaces(null);
         }
         else
         {
            res.setMaterialToAllFaces(PropTexture(this.textures[this.textureName]).material);
         }
         return res;
      }
      
      private function addOccluder(sourceGeometry:Mesh) : void
      {
         sourceGeometry.weldVertices(occluderDistanceThreshold,occluderUVThreshold);
         sourceGeometry.weldFaces(occluderAngleThreshold,occluderUVThreshold,occluderConvexThreshold);
         var occluder:Occluder = new Occluder();
         occluder.createForm(sourceGeometry,true);
         occluder.x = sourceGeometry.x;
         occluder.y = sourceGeometry.y;
         occluder.z = sourceGeometry.z;
         occluder.rotationX = sourceGeometry.rotationX;
         occluder.rotationY = sourceGeometry.rotationY;
         occluder.rotationZ = sourceGeometry.rotationZ;
         if(this.occluders == null)
         {
            this.occluders = new Vector.<Occluder>();
         }
         this.occluders.push(occluder);
      }
   }
}

