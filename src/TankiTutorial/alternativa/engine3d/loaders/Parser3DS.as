package alternativa.engine3d.loaders
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import flash.geom.Matrix;
   import flash.geom.Vector3D;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   use namespace alternativa3d;
   
   public class Parser3DS
   {
      
      private static const CHUNK_MAIN:int = 19789;
      
      private static const CHUNK_VERSION:int = 2;
      
      private static const CHUNK_SCENE:int = 15677;
      
      private static const CHUNK_ANIMATION:int = 45056;
      
      private static const CHUNK_OBJECT:int = 16384;
      
      private static const CHUNK_TRIMESH:int = 16640;
      
      private static const CHUNK_VERTICES:int = 16656;
      
      private static const CHUNK_FACES:int = 16672;
      
      private static const CHUNK_FACESMATERIAL:int = 16688;
      
      private static const CHUNK_FACESSMOOTH:int = 16720;
      
      private static const CHUNK_MAPPINGCOORDS:int = 16704;
      
      private static const CHUNK_TRANSFORMATION:int = 16736;
      
      private static const CHUNK_MATERIAL:int = 45055;
      
      private var data:ByteArray;
      
      private var objectDatas:Object;
      
      private var animationDatas:Array;
      
      private var materialDatas:Object;
      
      public var objects:Vector.<Object3D>;
      
      public var parents:Vector.<Object3D>;
      
      public var materials:Vector.<Material>;
      
      public var textureMaterials:Vector.<TextureMaterial>;
      
      public function Parser3DS()
      {
         super();
      }
      
      public function getObjectByName(name:String) : Object3D
      {
         var object:Object3D = null;
         for each(object in this.objects)
         {
            if(object.name == name)
            {
               return object;
            }
         }
         return null;
      }
      
      public function parse(data:ByteArray, texturesBaseURL:String = "", scale:Number = 1) : void
      {
         if(data.bytesAvailable < 6)
         {
            return;
         }
         this.data = data;
         data.endian = Endian.LITTLE_ENDIAN;
         this.parse3DSChunk(data.position,data.bytesAvailable);
         this.objects = new Vector.<Object3D>();
         this.parents = new Vector.<Object3D>();
         this.materials = new Vector.<Material>();
         this.textureMaterials = new Vector.<TextureMaterial>();
         this.buildContent(texturesBaseURL,scale);
         data = null;
         this.objectDatas = null;
         this.animationDatas = null;
         this.materialDatas = null;
      }
      
      private function readChunkInfo(dataPosition:int) : ChunkInfo
      {
         this.data.position = dataPosition;
         var chunkInfo:ChunkInfo = new ChunkInfo();
         chunkInfo.id = this.data.readUnsignedShort();
         chunkInfo.size = this.data.readUnsignedInt();
         chunkInfo.dataSize = chunkInfo.size - 6;
         chunkInfo.dataPosition = this.data.position;
         chunkInfo.nextChunkPosition = dataPosition + chunkInfo.size;
         return chunkInfo;
      }
      
      private function parse3DSChunk(dataPosition:int, bytesAvailable:int) : void
      {
         if(bytesAvailable < 6)
         {
            return;
         }
         var chunkInfo:ChunkInfo = this.readChunkInfo(dataPosition);
         this.data.position = dataPosition;
         switch(chunkInfo.id)
         {
            case CHUNK_MAIN:
               this.parseMainChunk(chunkInfo.dataPosition,chunkInfo.dataSize);
         }
         this.parse3DSChunk(chunkInfo.nextChunkPosition,bytesAvailable - chunkInfo.size);
      }
      
      private function parseMainChunk(dataPosition:int, bytesAvailable:int) : void
      {
         if(bytesAvailable < 6)
         {
            return;
         }
         var chunkInfo:ChunkInfo = this.readChunkInfo(dataPosition);
         switch(chunkInfo.id)
         {
            case CHUNK_VERSION:
               break;
            case CHUNK_SCENE:
               this.parse3DChunk(chunkInfo.dataPosition,chunkInfo.dataSize);
               break;
            case CHUNK_ANIMATION:
               this.parseAnimationChunk(chunkInfo.dataPosition,chunkInfo.dataSize);
         }
         this.parseMainChunk(chunkInfo.nextChunkPosition,bytesAvailable - chunkInfo.size);
      }
      
      private function parse3DChunk(dataPosition:int, bytesAvailable:int) : void
      {
         var chunkInfo:ChunkInfo = null;
         var material:MaterialData = null;
         while(bytesAvailable >= 6)
         {
            chunkInfo = this.readChunkInfo(dataPosition);
            switch(chunkInfo.id)
            {
               case CHUNK_MATERIAL:
                  material = new MaterialData();
                  this.parseMaterialChunk(material,chunkInfo.dataPosition,chunkInfo.dataSize);
                  break;
               case CHUNK_OBJECT:
                  this.parseObject(chunkInfo);
            }
            dataPosition = chunkInfo.nextChunkPosition;
            bytesAvailable -= chunkInfo.size;
         }
      }
      
      private function parseObject(chunkInfo:ChunkInfo) : void
      {
         if(this.objectDatas == null)
         {
            this.objectDatas = new Object();
         }
         var object:ObjectData = new ObjectData();
         object.name = this.getString(chunkInfo.dataPosition);
         this.objectDatas[object.name] = object;
         var offset:int = object.name.length + 1;
         this.parseObjectChunk(object,chunkInfo.dataPosition + offset,chunkInfo.dataSize - offset);
      }
      
      private function parseObjectChunk(object:ObjectData, dataPosition:int, bytesAvailable:int) : void
      {
         if(bytesAvailable < 6)
         {
            return;
         }
         var chunkInfo:ChunkInfo = this.readChunkInfo(dataPosition);
         switch(chunkInfo.id)
         {
            case CHUNK_TRIMESH:
               this.parseMeshChunk(object,chunkInfo.dataPosition,chunkInfo.dataSize);
               break;
            case 17920:
            case 18176:
         }
         this.parseObjectChunk(object,chunkInfo.nextChunkPosition,bytesAvailable - chunkInfo.size);
      }
      
      private function parseMeshChunk(object:ObjectData, dataPosition:int, bytesAvailable:int) : void
      {
         if(bytesAvailable < 6)
         {
            return;
         }
         var chunkInfo:ChunkInfo = this.readChunkInfo(dataPosition);
         switch(chunkInfo.id)
         {
            case CHUNK_VERTICES:
               this.parseVertices(object);
               break;
            case CHUNK_MAPPINGCOORDS:
               this.parseUVs(object);
               break;
            case CHUNK_TRANSFORMATION:
               this.parseMatrix(object);
               break;
            case CHUNK_FACES:
               this.parseFaces(object,chunkInfo);
         }
         this.parseMeshChunk(object,chunkInfo.nextChunkPosition,bytesAvailable - chunkInfo.size);
      }
      
      private function parseVertices(object:ObjectData) : void
      {
         var num:int = int(this.data.readUnsignedShort());
         object.vertices = new Vector.<Number>();
         var i:int = 0;
         var j:int = 0;
         while(i < num)
         {
            object.vertices[j++] = this.data.readFloat();
            object.vertices[j++] = this.data.readFloat();
            object.vertices[j++] = this.data.readFloat();
            i++;
         }
      }
      
      private function parseUVs(object:ObjectData) : void
      {
         var num:int = int(this.data.readUnsignedShort());
         object.uvs = new Vector.<Number>();
         var i:int = 0;
         var j:int = 0;
         while(i < num)
         {
            object.uvs[j++] = this.data.readFloat();
            object.uvs[j++] = this.data.readFloat();
            i++;
         }
      }
      
      private function parseMatrix(object:ObjectData) : void
      {
         object.a = this.data.readFloat();
         object.e = this.data.readFloat();
         object.i = this.data.readFloat();
         object.b = this.data.readFloat();
         object.f = this.data.readFloat();
         object.j = this.data.readFloat();
         object.c = this.data.readFloat();
         object.g = this.data.readFloat();
         object.k = this.data.readFloat();
         object.d = this.data.readFloat();
         object.h = this.data.readFloat();
         object.l = this.data.readFloat();
      }
      
      private function parseFaces(object:ObjectData, chunkInfo:ChunkInfo) : void
      {
         var num:int = int(this.data.readUnsignedShort());
         object.faces = new Vector.<int>(num * 3);
         object.smoothingGroups = new Vector.<uint>(num);
         var i:int = 0;
         var j:int = 0;
         while(i < num)
         {
            object.faces[j++] = this.data.readUnsignedShort();
            object.faces[j++] = this.data.readUnsignedShort();
            object.faces[j++] = this.data.readUnsignedShort();
            this.data.position += 2;
            i++;
         }
         var offset:int = 2 + 8 * num;
         this.parseFacesChunk(object,chunkInfo.dataPosition + offset,chunkInfo.dataSize - offset);
      }
      
      private function parseFacesChunk(object:ObjectData, dataPosition:int, bytesAvailable:int) : void
      {
         if(bytesAvailable < 6)
         {
            return;
         }
         var chunkInfo:ChunkInfo = this.readChunkInfo(dataPosition);
         switch(chunkInfo.id)
         {
            case CHUNK_FACESMATERIAL:
               this.parseSurface(object);
               break;
            case CHUNK_FACESSMOOTH:
               this.parseSmoothingGroups(object);
         }
         this.parseFacesChunk(object,chunkInfo.nextChunkPosition,bytesAvailable - chunkInfo.size);
      }
      
      private function parseSurface(object:ObjectData) : void
      {
         if(object.surfaces == null)
         {
            object.surfaces = new Object();
         }
         var surface:Vector.<int> = new Vector.<int>();
         object.surfaces[this.getString(this.data.position)] = surface;
         var num:int = int(this.data.readUnsignedShort());
         for(var i:int = 0; i < num; i++)
         {
            surface[i] = this.data.readUnsignedShort();
         }
      }
      
      private function parseSmoothingGroups(object:ObjectData) : void
      {
         var len:int = object.faces.length / 3;
         for(var i:int = 0; i < len; i++)
         {
            object.smoothingGroups[i] = this.data.readUnsignedInt();
         }
      }
      
      private function parseAnimationChunk(dataPosition:int, bytesAvailable:int) : void
      {
         var chunkInfo:ChunkInfo = null;
         var animation:AnimationData = null;
         while(bytesAvailable >= 6)
         {
            chunkInfo = this.readChunkInfo(dataPosition);
            switch(chunkInfo.id)
            {
               case 45057:
               case 45058:
               case 45059:
               case 45060:
               case 45061:
               case 45062:
               case 45063:
                  if(this.animationDatas == null)
                  {
                     this.animationDatas = new Array();
                  }
                  animation = new AnimationData();
                  this.animationDatas.push(animation);
                  this.parseObjectAnimationChunk(animation,chunkInfo.dataPosition,chunkInfo.dataSize);
                  break;
               case 45064:
            }
            dataPosition = chunkInfo.nextChunkPosition;
            bytesAvailable -= chunkInfo.size;
         }
      }
      
      private function parseObjectAnimationChunk(animation:AnimationData, dataPosition:int, bytesAvailable:int) : void
      {
         if(bytesAvailable < 6)
         {
            return;
         }
         var chunkInfo:ChunkInfo = this.readChunkInfo(dataPosition);
         switch(chunkInfo.id)
         {
            case 45072:
               animation.objectName = this.getString(this.data.position);
               this.data.position += 4;
               animation.parentIndex = this.data.readUnsignedShort();
               break;
            case 45073:
               animation.objectName = this.getString(this.data.position);
               break;
            case 45075:
               animation.pivot = new Vector3D(this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
               break;
            case 45088:
               this.data.position += 20;
               animation.position = new Vector3D(this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
               break;
            case 45089:
               this.data.position += 20;
               animation.rotation = this.getRotationFrom3DSAngleAxis(this.data.readFloat(),this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
               break;
            case 45090:
               this.data.position += 20;
               animation.scale = new Vector3D(this.data.readFloat(),this.data.readFloat(),this.data.readFloat());
         }
         this.parseObjectAnimationChunk(animation,chunkInfo.nextChunkPosition,bytesAvailable - chunkInfo.size);
      }
      
      private function parseMaterialChunk(material:MaterialData, dataPosition:int, bytesAvailable:int) : void
      {
         if(bytesAvailable < 6)
         {
            return;
         }
         var chunkInfo:ChunkInfo = this.readChunkInfo(dataPosition);
         switch(chunkInfo.id)
         {
            case 40960:
               this.parseMaterialName(material);
               break;
            case 40976:
               break;
            case 40992:
               this.data.position = chunkInfo.dataPosition + 6;
               material.color = (this.data.readUnsignedByte() << 16) + (this.data.readUnsignedByte() << 8) + this.data.readUnsignedByte();
               break;
            case 41008:
               break;
            case 41024:
               this.data.position = chunkInfo.dataPosition + 6;
               material.glossiness = this.data.readUnsignedShort();
               break;
            case 41025:
               this.data.position = chunkInfo.dataPosition + 6;
               material.specular = this.data.readUnsignedShort();
               break;
            case 41040:
               this.data.position = chunkInfo.dataPosition + 6;
               material.transparency = this.data.readUnsignedShort();
               break;
            case 41472:
               material.diffuseMap = new MapData();
               this.parseMapChunk(material.name,material.diffuseMap,chunkInfo.dataPosition,chunkInfo.dataSize);
               break;
            case 41786:
               break;
            case 41488:
               material.opacityMap = new MapData();
               this.parseMapChunk(material.name,material.opacityMap,chunkInfo.dataPosition,chunkInfo.dataSize);
               break;
            case 41520:
            case 41788:
            case 41476:
            case 41789:
            case 41504:
         }
         this.parseMaterialChunk(material,chunkInfo.nextChunkPosition,bytesAvailable - chunkInfo.size);
      }
      
      private function parseMaterialName(material:MaterialData) : void
      {
         if(this.materialDatas == null)
         {
            this.materialDatas = new Object();
         }
         material.name = this.getString(this.data.position);
         this.materialDatas[material.name] = material;
      }
      
      private function parseMapChunk(materialName:String, map:MapData, dataPosition:int, bytesAvailable:int) : void
      {
         if(bytesAvailable < 6)
         {
            return;
         }
         var chunkInfo:ChunkInfo = this.readChunkInfo(dataPosition);
         switch(chunkInfo.id)
         {
            case 41728:
               map.filename = this.getString(chunkInfo.dataPosition).toLowerCase();
               break;
            case 41809:
               break;
            case 41812:
               map.scaleU = this.data.readFloat();
               break;
            case 41814:
               map.scaleV = this.data.readFloat();
               break;
            case 41816:
               map.offsetU = this.data.readFloat();
               break;
            case 41818:
               map.offsetV = this.data.readFloat();
               break;
            case 41820:
               map.rotation = this.data.readFloat();
         }
         this.parseMapChunk(materialName,map,chunkInfo.nextChunkPosition,bytesAvailable - chunkInfo.size);
      }
      
      private function buildContent(texturesBaseURL:String, scale:Number) : void
      {
         var materialName:String = null;
         var objectName:String = null;
         var objectData:ObjectData = null;
         var object:Object3D = null;
         var materialData:MaterialData = null;
         var mapData:MapData = null;
         var materialMatrix:Matrix = null;
         var rot:Number = NaN;
         var textureMaterial:TextureMaterial = null;
         var fillMaterial:FillMaterial = null;
         var i:int = 0;
         var length:int = 0;
         var animationData:AnimationData = null;
         var j:int = 0;
         var nameCounter:int = 0;
         var animationData2:AnimationData = null;
         var newObjectData:ObjectData = null;
         var newName:String = null;
         for(materialName in this.materialDatas)
         {
            materialData = this.materialDatas[materialName];
            mapData = materialData.diffuseMap;
            if(mapData != null)
            {
               materialMatrix = new Matrix();
               rot = mapData.rotation * Math.PI / 180;
               materialMatrix.translate(-mapData.offsetU,mapData.offsetV);
               materialMatrix.translate(-0.5,-0.5);
               materialMatrix.rotate(-rot);
               materialMatrix.scale(mapData.scaleU,mapData.scaleV);
               materialMatrix.translate(0.5,0.5);
               materialData.matrix = materialMatrix;
               textureMaterial = new TextureMaterial();
               textureMaterial.name = materialName;
               textureMaterial.diffuseMapURL = texturesBaseURL + mapData.filename;
               textureMaterial.opacityMapURL = materialData.opacityMap != null ? texturesBaseURL + materialData.opacityMap.filename : null;
               materialData.material = textureMaterial;
               textureMaterial.name = materialData.name;
               this.textureMaterials.push(textureMaterial);
            }
            else
            {
               fillMaterial = new FillMaterial(materialData.color);
               materialData.material = fillMaterial;
               fillMaterial.name = materialData.name;
            }
            this.materials.push(materialData.material);
         }
         if(this.animationDatas != null)
         {
            if(this.objectDatas != null)
            {
               length = int(this.animationDatas.length);
               for(i = 0; i < length; i++)
               {
                  animationData = this.animationDatas[i];
                  objectName = animationData.objectName;
                  objectData = this.objectDatas[objectName];
                  if(objectData != null)
                  {
                     j = i + 1;
                     nameCounter = 1;
                     while(j < length)
                     {
                        animationData2 = this.animationDatas[j];
                        if(!animationData2.isInstance && objectName == animationData2.objectName)
                        {
                           newObjectData = new ObjectData();
                           newName = objectName + nameCounter++;
                           newObjectData.name = newName;
                           this.objectDatas[newName] = newObjectData;
                           animationData2.objectName = newName;
                           newObjectData.vertices = objectData.vertices;
                           newObjectData.uvs = objectData.uvs;
                           newObjectData.faces = objectData.faces;
                           newObjectData.smoothingGroups = objectData.smoothingGroups;
                           newObjectData.surfaces = objectData.surfaces;
                           newObjectData.a = objectData.a;
                           newObjectData.b = objectData.b;
                           newObjectData.c = objectData.c;
                           newObjectData.d = objectData.d;
                           newObjectData.e = objectData.e;
                           newObjectData.f = objectData.f;
                           newObjectData.g = objectData.g;
                           newObjectData.h = objectData.h;
                           newObjectData.i = objectData.i;
                           newObjectData.j = objectData.j;
                           newObjectData.k = objectData.k;
                           newObjectData.l = objectData.l;
                        }
                        j++;
                     }
                  }
                  if(objectData != null && objectData.vertices != null)
                  {
                     object = new Mesh();
                     this.buildMesh(object as Mesh,objectData,animationData,scale);
                  }
                  else
                  {
                     object = new Object3D();
                  }
                  object.name = objectName;
                  animationData.object = object;
                  if(animationData.position != null)
                  {
                     object.x = animationData.position.x * scale;
                     object.y = animationData.position.y * scale;
                     object.z = animationData.position.z * scale;
                  }
                  if(animationData.rotation != null)
                  {
                     object.rotationX = animationData.rotation.x;
                     object.rotationY = animationData.rotation.y;
                     object.rotationZ = animationData.rotation.z;
                  }
                  if(animationData.scale != null)
                  {
                     object.scaleX = animationData.scale.x;
                     object.scaleY = animationData.scale.y;
                     object.scaleZ = animationData.scale.z;
                  }
               }
               for(i = 0; i < length; i++)
               {
                  animationData = this.animationDatas[i];
                  this.objects.push(animationData.object);
                  this.parents.push(animationData.parentIndex == 65535 ? null : AnimationData(this.animationDatas[animationData.parentIndex]).object);
               }
            }
         }
         else
         {
            for(objectName in this.objectDatas)
            {
               objectData = this.objectDatas[objectName];
               if(objectData.vertices != null)
               {
                  object = new Mesh();
                  object.name = objectName;
                  this.buildMesh(object as Mesh,objectData,null,scale);
                  this.objects.push(object);
                  this.parents.push(null);
               }
            }
         }
      }
      
      private function buildMesh(mesh:Mesh, objectData:ObjectData, animationData:AnimationData, scale:Number) : void
      {
         var n:int = 0;
         var m:int = 0;
         var face:Face = null;
         var vertex:Vertex = null;
         var len:int = 0;
         var a:Number = NaN;
         var b:Number = NaN;
         var c:Number = NaN;
         var d:Number = NaN;
         var e:Number = NaN;
         var f:Number = NaN;
         var g:Number = NaN;
         var h:Number = NaN;
         var i:Number = NaN;
         var j:Number = NaN;
         var k:Number = NaN;
         var l:Number = NaN;
         var det:Number = NaN;
         var uv:Boolean = false;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         var last:Face = null;
         var key:String = null;
         var surface:Vector.<int> = null;
         var materialData:MaterialData = null;
         var material:Material = null;
         var w:Wrapper = null;
         var u:Number = NaN;
         var v:Number = NaN;
         var vertices:Vector.<Vertex> = new Vector.<Vertex>();
         var faces:Vector.<Face> = new Vector.<Face>();
         var numVertices:int = 0;
         var numFaces:int = 0;
         var correct:Boolean = false;
         if(animationData != null)
         {
            a = objectData.a;
            b = objectData.b;
            c = objectData.c;
            d = objectData.d;
            e = objectData.e;
            f = objectData.f;
            g = objectData.g;
            h = objectData.h;
            i = objectData.i;
            j = objectData.j;
            k = objectData.k;
            l = objectData.l;
            det = 1 / (-c * f * i + b * g * i + c * e * j - a * g * j - b * e * k + a * f * k);
            objectData.a = (-g * j + f * k) * det;
            objectData.b = (c * j - b * k) * det;
            objectData.c = (-c * f + b * g) * det;
            objectData.d = (d * g * j - c * h * j - d * f * k + b * h * k + c * f * l - b * g * l) * det;
            objectData.e = (g * i - e * k) * det;
            objectData.f = (-c * i + a * k) * det;
            objectData.g = (c * e - a * g) * det;
            objectData.h = (c * h * i - d * g * i + d * e * k - a * h * k - c * e * l + a * g * l) * det;
            objectData.i = (-f * i + e * j) * det;
            objectData.j = (b * i - a * j) * det;
            objectData.k = (-b * e + a * f) * det;
            objectData.l = (d * f * i - b * h * i - d * e * j + a * h * j + b * e * l - a * f * l) * det;
            if(animationData.pivot != null)
            {
               objectData.d -= animationData.pivot.x;
               objectData.h -= animationData.pivot.y;
               objectData.l -= animationData.pivot.z;
            }
            correct = true;
         }
         if(objectData.vertices != null)
         {
            uv = objectData.uvs != null && objectData.uvs.length > 0;
            n = 0;
            m = 0;
            len = int(objectData.vertices.length);
            while(n < len)
            {
               vertex = new Vertex();
               if(correct)
               {
                  x = objectData.vertices[n++];
                  y = objectData.vertices[n++];
                  z = objectData.vertices[n++];
                  vertex.x = objectData.a * x + objectData.b * y + objectData.c * z + objectData.d;
                  vertex.y = objectData.e * x + objectData.f * y + objectData.g * z + objectData.h;
                  vertex.z = objectData.i * x + objectData.j * y + objectData.k * z + objectData.l;
               }
               else
               {
                  vertex.x = objectData.vertices[n++];
                  vertex.y = objectData.vertices[n++];
                  vertex.z = objectData.vertices[n++];
               }
               vertex.x *= scale;
               vertex.y *= scale;
               vertex.z *= scale;
               if(uv)
               {
                  vertex.u = objectData.uvs[m++];
                  vertex.v = 1 - objectData.uvs[m++];
               }
               vertex.transformId = -1;
               vertices[numVertices++] = vertex;
               vertex.next = mesh.vertexList;
               mesh.vertexList = vertex;
            }
         }
         if(objectData.faces != null)
         {
            n = 0;
            m = 0;
            len = int(objectData.faces.length);
            while(n < len)
            {
               face = new Face();
               face.wrapper = new Wrapper();
               face.wrapper.next = new Wrapper();
               face.wrapper.next.next = new Wrapper();
               face.wrapper.vertex = vertices[objectData.faces[n++]];
               face.wrapper.next.vertex = vertices[objectData.faces[n++]];
               face.wrapper.next.next.vertex = vertices[objectData.faces[n++]];
               face.smoothingGroups = objectData.smoothingGroups[m++];
               faces[numFaces++] = face;
               if(last != null)
               {
                  last.next = face;
               }
               else
               {
                  mesh.faceList = face;
               }
               last = face;
            }
         }
         if(objectData.surfaces != null)
         {
            for(key in objectData.surfaces)
            {
               surface = objectData.surfaces[key];
               materialData = this.materialDatas[key];
               material = materialData.material;
               for(n = 0; n < surface.length; n++)
               {
                  face = faces[surface[n]];
                  face.material = material;
                  if(materialData.matrix != null)
                  {
                     for(w = face.wrapper; w != null; w = w.next)
                     {
                        vertex = w.vertex;
                        if(vertex.transformId < 0)
                        {
                           u = vertex.u;
                           v = vertex.v;
                           vertex.u = materialData.matrix.a * u + materialData.matrix.b * v + materialData.matrix.tx;
                           vertex.v = materialData.matrix.c * u + materialData.matrix.d * v + materialData.matrix.ty;
                           vertex.transformId = 0;
                        }
                     }
                  }
               }
            }
         }
         var defaultMaterial:FillMaterial = new FillMaterial(8355711);
         defaultMaterial.name = "default";
         for(face = mesh.faceList; face != null; face = face.next)
         {
            if(face.material == null)
            {
               face.material = defaultMaterial;
            }
         }
         mesh.calculateFacesNormals(true);
         mesh.calculateBounds();
      }
      
      private function getString(index:int) : String
      {
         var charCode:int = 0;
         this.data.position = index;
         for(var res:String = ""; (charCode = this.data.readByte()) != 0; )
         {
            res += String.fromCharCode(charCode);
         }
         return res;
      }
      
      private function getRotationFrom3DSAngleAxis(angle:Number, x:Number, z:Number, y:Number) : Vector3D
      {
         var half:Number = NaN;
         var res:Vector3D = new Vector3D();
         var s:Number = Math.sin(angle);
         var c:Number = Math.cos(angle);
         var t:Number = 1 - c;
         var k:Number = x * y * t + z * s;
         if(k >= 1)
         {
            half = angle / 2;
            res.z = -2 * Math.atan2(x * Math.sin(half),Math.cos(half));
            res.y = -Math.PI / 2;
            res.x = 0;
            return res;
         }
         if(k <= -1)
         {
            half = angle / 2;
            res.z = 2 * Math.atan2(x * Math.sin(half),Math.cos(half));
            res.y = Math.PI / 2;
            res.x = 0;
            return res;
         }
         res.z = -Math.atan2(y * s - x * z * t,1 - (y * y + z * z) * t);
         res.y = -Math.asin(x * y * t + z * s);
         res.x = -Math.atan2(x * s - y * z * t,1 - (x * x + z * z) * t);
         return res;
      }
   }
}

import alternativa.engine3d.core.Object3D;
import alternativa.engine3d.materials.Material;
import flash.geom.Matrix;
import flash.geom.Vector3D;

class MaterialData
{
   
   public var name:String;
   
   public var color:int;
   
   public var specular:int;
   
   public var glossiness:int;
   
   public var transparency:int;
   
   public var diffuseMap:MapData;
   
   public var opacityMap:MapData;
   
   public var matrix:Matrix;
   
   public var material:Material;
   
   public function MaterialData()
   {
      super();
   }
}

class MapData
{
   
   public var filename:String;
   
   public var scaleU:Number = 1;
   
   public var scaleV:Number = 1;
   
   public var offsetU:Number = 0;
   
   public var offsetV:Number = 0;
   
   public var rotation:Number = 0;
   
   public function MapData()
   {
      super();
   }
}

class ObjectData
{
   
   public var name:String;
   
   public var vertices:Vector.<Number>;
   
   public var uvs:Vector.<Number>;
   
   public var faces:Vector.<int>;
   
   public var smoothingGroups:Vector.<uint>;
   
   public var surfaces:Object;
   
   public var a:Number;
   
   public var b:Number;
   
   public var c:Number;
   
   public var d:Number;
   
   public var e:Number;
   
   public var f:Number;
   
   public var g:Number;
   
   public var h:Number;
   
   public var i:Number;
   
   public var j:Number;
   
   public var k:Number;
   
   public var l:Number;
   
   public function ObjectData()
   {
      super();
   }
}

class AnimationData
{
   
   public var objectName:String;
   
   public var object:Object3D;
   
   public var parentIndex:int;
   
   public var pivot:Vector3D;
   
   public var position:Vector3D;
   
   public var rotation:Vector3D;
   
   public var scale:Vector3D;
   
   public var isInstance:Boolean;
   
   public function AnimationData()
   {
      super();
   }
}

class ChunkInfo
{
   
   public var id:int;
   
   public var size:int;
   
   public var dataSize:int;
   
   public var dataPosition:int;
   
   public var nextChunkPosition:int;
   
   public function ChunkInfo()
   {
      super();
   }
}
