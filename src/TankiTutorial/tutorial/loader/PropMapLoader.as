package tutorial.loader
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.TanksPhysicsScene;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.tanks.physics.CollisionGroup;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import tutorial.GameData;
   import tutorial.GameScene;
   import tutorial.commons.Assets;
   import tutorial.commons.Shared;
   import tutorial.loader.proplib.PropObject;
   import tutorial.loader.proplib.XMLUtils;
   import tutorial.script.ScriptStep;
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;

   public class PropMapLoader extends TanksLoader
   {
      
      public static const BONUS_REGION_SIZE:int = 500;
      
      private static const matrix3D:Matrix3D = new Matrix3D();
      
      private static const matrix4:Matrix4 = new Matrix4();
      
      private var urlLoader:URLLoader;
      
      private var props:Vector.<PropObject>;
      
      private var propXMLs:Vector.<XML>;
      
      private var index:int;
      
      private var scene:GameScene = GameData.scene;
      
      private var physicsScene:TanksPhysicsScene = GameData.physicsScene;
      
      private var compressed:Boolean = false;
      
      private var dynamics:Object = {};
      
      public function PropMapLoader()
      {
         super();
      }
      
      private static function initBonusRegionMaterial(size:Number, texture:BitmapData) : TextureMaterial
      {
         var material:TextureMaterial = new TextureMaterial();
         material.texture = texture;
         material.mipMapping = MipMapping.PER_PIXEL;
         material.resolution = size / material.texture.width;
         return material;
      }
      
      private static function createBonusRegion(position:Vector3, rotation:Vector3, material:TextureMaterial) : Decal
      {
         var decal:Decal = new Decal();
         var halfSize:Number = BONUS_REGION_SIZE / 2;
         var z:Number = 0;
         if(!Shared.gpu)
         {
            z = 0.5;
         }
         var a:Vertex = decal.addVertex(-halfSize,halfSize,z,0,0);
         var b:Vertex = decal.addVertex(-halfSize,-halfSize,z,0,1);
         var c:Vertex = decal.addVertex(halfSize,-halfSize,z,1,1);
         var d:Vertex = decal.addVertex(halfSize,halfSize,z,1,0);
         decal.addQuadFace(a,b,c,d,material);
         decal.calculateFacesNormals();
         decal.calculateVerticesNormals();
         decal.x = position.x;
         decal.y = position.y;
         decal.z = position.z;
         decal.rotationX = rotation.x;
         decal.rotationY = rotation.y;
         decal.rotationZ = rotation.z;
         return decal;
      }
      
      override public function check(sceneXML:XML) : Boolean
      {
         return sceneXML.@propmap.toString() != "";
      }
      
      override public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
         this.callback = completeListener;
         var url:String = sceneURL + XMLUtils.getAttributeAsString(sceneXML,"propmap");
         this.parseDynamics(sceneXML);
         if(Assets.hasData(url,ByteArray))
         {
            this.compressed = true;
            this.parse(Assets.getData(url,ByteArray));
         }
         else if(Assets.hasData(url,XML))
         {
            this.compressed = false;
            this.parse(Assets.getData(url,XML));
         }
         else
         {
            this.compressed = url.indexOf(".bin") > 0;
            this.urlLoader = createURLLoader(this.onLoaded,onError,onProgress);
            if(this.compressed)
            {
               this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            }
            this.urlLoader.load(new URLRequest(url));
         }
      }
      
      private function onLoaded(e:Event) : void
      {
         var data:* = this.urlLoader.data;
         this.urlLoader = null;
         onFinishLoad();
         this.parse(data);
      }
      
      private function parse(data:*) : void
      {
         var propXML:XML = null;
         var bytes:ByteArray = null;
         if(this.compressed)
         {
            bytes = data;
            bytes.uncompress();
            data = bytes.readUTFBytes(bytes.length);
         }
         xml = XML(data);
         this.props = new Vector.<PropObject>();
         this.propXMLs = new Vector.<XML>();
         this.index = 0;
         for each(propXML in xml.prop)
         {
            this.propXMLs.push(propXML);
         }
         this.loadProp();
      }
      
      private function loadProp(prop:PropObject = null) : void
      {
         var propObject:PropObject = null;
         if(prop != null)
         {
            this.props.push(prop);
            ++this.index;
         }
         if(this.index < this.propXMLs.length)
         {
            propObject = new PropObject();
            propObject.load(this.propXMLs[this.index],this.loadProp);
         }
         else
         {
            this.parseMap();
         }
      }
      
      private function parseMap() : void
      {
         this.parseMeshes();
         this.parseSprites();
         this.parseAndAddBonusRegions();
         callback();
      }
      
      private function parseAndAddBonusRegions() : void
      {
         var scriptXML:XML = null;
         var stepXML:XML = null;
         var actionXML:XML = null;
         var position:Vector3 = null;
         var material:TextureMaterial = initBonusRegionMaterial(BONUS_REGION_SIZE,Assets.getData("repairKitBonusRegion",BitmapData));
         for each(scriptXML in Assets.scripts.script)
         {
            for each(stepXML in scriptXML.elements("step"))
            {
               for each(actionXML in stepXML.elements())
               {
                  if(actionXML.name().toString() == ScriptStep.MEDICINE)
                  {
                     position = new Vector3(Number(actionXML.@x),Number(actionXML.@y),Number(actionXML.@z));
                     GameData.bonusRegions.push(position);
                     this.scene.addDynamic(createBonusRegion(position,new Vector3(),material));
                  }
               }
            }
         }
      }
      
      private function parseDynamics(sceneXML:XML) : void
      {
         var str:String = sceneXML.@dynamics.toString();
         var names:Array = str.split(",");
         for each(str in names)
         {
            this.dynamics[str] = true;
         }
      }
      
      private function parseMeshes() : void
      {
         var meshXML:XML = null;
         var propIndex:int = 0;
         var prop:PropObject = null;
         var positionXML:XML = null;
         var position:Vector3 = null;
         var rotationZ:Number = NaN;
         var textureIndex:int = 0;
         var object:Object3D = null;
         for each(meshXML in xml.mesh)
         {
            propIndex = XMLUtils.getAttributeAsInt(meshXML,"prop-index");
            prop = this.props[propIndex];
            positionXML = meshXML.position[0];
            position = new Vector3(positionXML.@x,positionXML.@y,positionXML.@z);
            rotationZ = Number(meshXML.elements("rotation-z"));
            matrix3D.identity();
            matrix3D.appendRotation(rotationZ * 180 / Math.PI,Vector3D.Z_AXIS);
            matrix3D.appendTranslation(position.x,position.y,position.z);
            textureIndex = meshXML.elements("texture-index").length() > 0 ? int(int(meshXML.elements("texture-index")) + 1) : 0;
            object = prop.objects[textureIndex];
            if(Boolean(this.dynamics[prop.name]))
            {
               this.parseDynamicObject(object,prop);
            }
            else
            {
               this.parseStaticObject(object,prop,position,rotationZ);
            }
         }
      }
      
      private function parseDynamicObject(object:Object3D, prop:PropObject) : void
      {
         var shape:CollisionShape = null;
         var newShape:CollisionShape = null;
         object = this.parseMesh(object as Mesh,prop.priority,matrix3D);
         this.scene.addDynamic(object);
         var body:Body = new Body(1,Matrix3.identity);
         body.name = prop.name;
         body.movable = false;
         for each(shape in prop.collisionShapes)
         {
            newShape = shape.clone();
            body.addCollisionShape(newShape,newShape.transform.clone());
         }
         body.setPositionXYZ(object.x,object.y,object.z);
         this.physicsScene.addKinematicBody(body);
      }
      
      private function parseStaticObject(object:Object3D, prop:PropObject, position:Vector3, rotationZ:Number) : void
      {
         var shape:CollisionShape = null;
         var newShape:CollisionShape = null;
         var mesh:Mesh = this.parseBSP(object as Mesh,prop.priority,matrix3D) as Mesh;
         this.scene.addObject(mesh);
         var face:Face = mesh.faces[0];
         var collisionGroup:int = face.material == null ? CollisionGroup.STATIC : 255;
         for each(shape in prop.collisionShapes)
         {
            matrix4.setMatrix(position.x,position.y,position.z,0,0,rotationZ);
            newShape = shape.clone();
            newShape.collisionGroup = collisionGroup;
            newShape.transform.append(matrix4);
            this.physicsScene.addCollisionPrimitive(newShape);
         }
      }
      
      private function parseBSP(mesh:Mesh, priority:int, matrix:Matrix3D) : Object3D
      {
         var result:Mesh = mesh.clone() as Mesh;
         result.matrix = matrix;
         var material:TextureMaterial = mesh.faceList.material as TextureMaterial;
         if(material != null)
         {
            material.mipMapping = MipMapping.PER_PIXEL;
            material.resolution = 5;
            result.setMaterialToAllFaces(material);
            GameData.texturesLoader.addToQueue(material,priority,true);
         }
         return result;
      }
      
      private function parseMesh(mesh:Mesh, priority:int, matrix:Matrix3D) : Object3D
      {
         var result:Mesh = mesh.clone() as Mesh;
         var material:TextureMaterial = mesh.faceList.material as TextureMaterial;
         if(material != null)
         {
            material.mipMapping = MipMapping.PER_PIXEL;
            material.resolution = 5;
            result.setMaterialToAllFaces(material);
            GameData.texturesLoader.addToQueue(material,priority,true);
         }
         result.matrix = matrix;
         result.sorting = Sorting.DYNAMIC_BSP;
         return result;
      }
      
      private function parseSprites() : void
      {
         var spriteXML:XML = null;
         var propIndex:int = 0;
         var prop:PropObject = null;
         var sprite:Sprite3D = null;
         var copy:Sprite3D = null;
         var positionXML:XML = null;
         var material:TextureMaterial = null;
         for each(spriteXML in xml.sprite)
         {
            propIndex = XMLUtils.getAttributeAsInt(spriteXML,"prop-index");
            prop = this.props[propIndex];
            sprite = prop.objects[0] as Sprite3D;
            copy = sprite.clone() as Sprite3D;
            positionXML = spriteXML.position[0];
            copy.x = positionXML.@x;
            copy.y = positionXML.@y;
            copy.z = positionXML.@z;
            material = sprite.material as TextureMaterial;
            material.mipMapping = MipMapping.PER_PIXEL;
            material.resolution = 5;
            GameData.texturesLoader.addToQueue(material,0,false);
            copy.material = material;
            this.scene.addDynamic(copy);
         }
      }
   }
}

