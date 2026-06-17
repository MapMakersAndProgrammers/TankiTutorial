package alternativa.engine3d.objects
{
   import alternativa.gfx.core.VertexBufferResource;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.RayIntersectionData;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.errors.IllegalOperationError;
   
   use namespace alternativa3d;
   
   public class Mesh extends Object3D
   {
      
      public var clipping:int = 2;
      
      public var sorting:int = 1;
      
      public var threshold:Number = 0.01;
      
      alternativa3d var vertexList:Vertex;
      
      alternativa3d var faceList:Face;
      
      alternativa3d var vertexBuffer:VertexBufferResource;
      
      alternativa3d var indexBuffer:IndexBufferResource;
      
      alternativa3d var numOpaqueTriangles:int;
      
      alternativa3d var numTriangles:int;
      
      private var opaqueMaterials:Vector.<Material> = new Vector.<Material>();
      
      private var opaqueBegins:Vector.<int> = new Vector.<int>();
      
      private var opaqueNums:Vector.<int> = new Vector.<int>();
      
      private var opaqueLength:int = 0;
      
      private var transparentList:Face;
      
      public function Mesh()
      {
         super();
      }
      
      public static function calculateVerticesNormalsBySmoothingGroupsForMeshList(meshList:Vector.<Object3D>, distanceThreshold:Number = 0) : void
      {
         var i:int = 0;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         var key:* = undefined;
         var mesh:Mesh = null;
         var face:Face = null;
         var vertex:Vertex = null;
         var wrapper:Wrapper = null;
         var root:Object3D = null;
         var newVertex:Vertex = null;
         var len:Number = NaN;
         var sibling:Face = null;
         var map:Dictionary = new Dictionary();
         var meshesLength:int = int(meshList.length);
         for(i = 0; i < meshesLength; )
         {
            mesh = meshList[i] as Mesh;
            if(mesh != null)
            {
               mesh.deleteResources();
               mesh.composeMatrix();
               for(root = mesh; root._parent != null; )
               {
                  root = root._parent;
                  root.composeMatrix();
                  mesh.appendMatrix(root);
               }
               for(vertex = mesh.vertexList; vertex != null; vertex = vertex.next)
               {
                  x = vertex.x;
                  y = vertex.y;
                  z = vertex.z;
                  vertex.x = mesh.ma * x + mesh.mb * y + mesh.mc * z + mesh.md;
                  vertex.y = mesh.me * x + mesh.mf * y + mesh.mg * z + mesh.mh;
                  vertex.z = mesh.mi * x + mesh.mj * y + mesh.mk * z + mesh.ml;
               }
               mesh.calculateNormalsAndRemoveDegenerateFaces();
               for(face = mesh.faceList; face != null; face = face.next)
               {
                  if(face.smoothingGroups > 0)
                  {
                     for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
                     {
                        vertex = wrapper.vertex;
                        if(!map[vertex])
                        {
                           map[vertex] = new Dictionary();
                        }
                        map[vertex][face] = true;
                     }
                  }
               }
            }
            i++;
         }
         var verts:Vector.<Vertex> = new Vector.<Vertex>();
         var vertsLength:int = 0;
         for(key in map)
         {
            verts[vertsLength] = key;
            vertsLength++;
         }
         if(vertsLength > 0)
         {
            shareFaces(verts,0,vertsLength,0,distanceThreshold,new Vector.<int>(),map);
         }
         for(i = 0; i < meshesLength; )
         {
            mesh = meshList[i] as Mesh;
            if(mesh != null)
            {
               mesh.vertexList = null;
               for(face = mesh.faceList; face != null; face = face.next)
               {
                  for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
                  {
                     vertex = wrapper.vertex;
                     newVertex = new Vertex();
                     newVertex.x = vertex.x;
                     newVertex.y = vertex.y;
                     newVertex.z = vertex.z;
                     newVertex.u = vertex.u;
                     newVertex.v = vertex.v;
                     newVertex.id = vertex.id;
                     newVertex.normalX = face.normalX;
                     newVertex.normalY = face.normalY;
                     newVertex.normalZ = face.normalZ;
                     if(face.smoothingGroups > 0)
                     {
                        for(key in map[vertex])
                        {
                           sibling = key;
                           if(face != sibling && (face.smoothingGroups & sibling.smoothingGroups) > 0)
                           {
                              newVertex.normalX += sibling.normalX;
                              newVertex.normalY += sibling.normalY;
                              newVertex.normalZ += sibling.normalZ;
                           }
                        }
                        len = newVertex.normalX * newVertex.normalX + newVertex.normalY * newVertex.normalY + newVertex.normalZ * newVertex.normalZ;
                        if(len > 0.001)
                        {
                           len = 1 / Math.sqrt(len);
                           newVertex.normalX *= len;
                           newVertex.normalY *= len;
                           newVertex.normalZ *= len;
                        }
                     }
                     wrapper.vertex = newVertex;
                     newVertex.next = mesh.vertexList;
                     mesh.vertexList = newVertex;
                  }
               }
            }
            i++;
         }
         for(i = 0; i < meshesLength; )
         {
            mesh = meshList[i] as Mesh;
            if(mesh != null)
            {
               mesh.invertMatrix();
               for(vertex = mesh.vertexList; vertex != null; vertex = vertex.next)
               {
                  x = vertex.x;
                  y = vertex.y;
                  z = vertex.z;
                  vertex.x = mesh.ma * x + mesh.mb * y + mesh.mc * z + mesh.md;
                  vertex.y = mesh.me * x + mesh.mf * y + mesh.mg * z + mesh.mh;
                  vertex.z = mesh.mi * x + mesh.mj * y + mesh.mk * z + mesh.ml;
                  x = vertex.normalX;
                  y = vertex.normalY;
                  z = vertex.normalZ;
                  vertex.normalX = mesh.ma * x + mesh.mb * y + mesh.mc * z;
                  vertex.normalY = mesh.me * x + mesh.mf * y + mesh.mg * z;
                  vertex.normalZ = mesh.mi * x + mesh.mj * y + mesh.mk * z;
               }
               for(face = mesh.faceList; face != null; face = face.next)
               {
                  x = face.normalX;
                  y = face.normalY;
                  z = face.normalZ;
                  face.normalX = mesh.ma * x + mesh.mb * y + mesh.mc * z;
                  face.normalY = mesh.me * x + mesh.mf * y + mesh.mg * z;
                  face.normalZ = mesh.mi * x + mesh.mj * y + mesh.mk * z;
                  face.offset = face.wrapper.vertex.x * face.normalX + face.wrapper.vertex.y * face.normalY + face.wrapper.vertex.z * face.normalZ;
               }
            }
            i++;
         }
      }
      
      private static function shareFaces(verts:Vector.<Vertex>, begin:int, end:int, depth:int, threshold:Number, stack:Vector.<int>, map:Dictionary) : void
      {
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var vertex:Vertex = null;
         var compared:Vertex = null;
         var r:int = 0;
         var l:int = 0;
         var median:Number = NaN;
         var left:Vertex = null;
         var right:Vertex = null;
         var f:* = undefined;
         switch(depth)
         {
            case 0:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.x;
               }
               break;
            case 1:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.y;
               }
               break;
            case 2:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.z;
               }
         }
         stack[0] = begin;
         stack[1] = end - 1;
         for(var index:int = 2; index > 0; )
         {
            index--;
            r = stack[index];
            j = r;
            index--;
            l = stack[index];
            i = l;
            vertex = verts[r + l >> 1];
            for(median = vertex.offset; i <= j; )
            {
               for(left = verts[i]; left.offset > median; )
               {
                  i++;
                  left = verts[i];
               }
               for(right = verts[j]; right.offset < median; )
               {
                  j--;
                  right = verts[j];
               }
               if(i <= j)
               {
                  verts[i] = right;
                  verts[j] = left;
                  i++;
                  j--;
               }
            }
            if(l < j)
            {
               stack[index] = l;
               index++;
               stack[index] = j;
               index++;
            }
            if(i < r)
            {
               stack[index] = i;
               index++;
               stack[index] = r;
               index++;
            }
         }
         i = begin;
         vertex = verts[i];
         for(j = i + 1; j <= end; j++)
         {
            if(j < end)
            {
               compared = verts[j];
            }
            if(j == end || vertex.offset - compared.offset > threshold)
            {
               if(j - i > 1)
               {
                  if(depth < 2)
                  {
                     shareFaces(verts,i,j,depth + 1,threshold,stack,map);
                  }
                  else
                  {
                     for(k = i + 1; k < j; )
                     {
                        compared = verts[k];
                        for(f in map[compared])
                        {
                           map[vertex][f] = true;
                        }
                        k++;
                     }
                     for(k = i + 1; k < j; k++)
                     {
                        compared = verts[k];
                        for(f in map[vertex])
                        {
                           map[compared][f] = true;
                        }
                     }
                  }
               }
               if(j < end)
               {
                  i = j;
                  vertex = verts[i];
               }
            }
         }
      }
      
      public function addVertex(x:Number, y:Number, z:Number, u:Number = 0, v:Number = 0, id:Object = null) : Vertex
      {
         var last:Vertex = null;
         this.deleteResources();
         var vertex:Vertex = new Vertex();
         vertex.x = x;
         vertex.y = y;
         vertex.z = z;
         vertex.u = u;
         vertex.v = v;
         vertex.id = id;
         if(this.vertexList != null)
         {
            for(last = this.vertexList; last.next != null; )
            {
               last = last.next;
            }
            last.next = vertex;
         }
         else
         {
            this.vertexList = vertex;
         }
         return vertex;
      }
      
      public function removeVertex(vertex:Vertex) : Vertex
      {
         var pv:Vertex = null;
         var pf:Face = null;
         var nf:Face = null;
         var w:Wrapper = null;
         this.deleteResources();
         if(vertex == null)
         {
            throw new TypeError("Parameter vertex must be non-null.");
         }
         for(var v:Vertex = this.vertexList; v != null; )
         {
            if(v == vertex)
            {
               if(pv != null)
               {
                  pv.next = v.next;
               }
               else
               {
                  this.vertexList = v.next;
               }
               v.next = null;
               break;
            }
            pv = v;
            v = v.next;
         }
         if(v == null)
         {
            throw new ArgumentError("Vertex not found.");
         }
         for(var f:Face = this.faceList; f != null; )
         {
            nf = f.next;
            w = f.wrapper;
            while(true)
            {
               if(w != null)
               {
                  if(w.vertex != v)
                  {
                     continue;
                  }
               }
               if(w != null)
               {
                  if(pf != null)
                  {
                     pf.next = nf;
                  }
                  else
                  {
                     this.faceList = nf;
                  }
                  f.next = null;
               }
               else
               {
                  pf = f;
               }
               f = nf;
               break;
               w = w.next;
            }
         }
         return v;
      }
      
      public function removeVertexById(id:Object) : Vertex
      {
         var pv:Vertex = null;
         var pf:Face = null;
         var nf:Face = null;
         var w:Wrapper = null;
         this.deleteResources();
         if(id == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         for(var v:Vertex = this.vertexList; v != null; )
         {
            if(v.id == id)
            {
               if(pv != null)
               {
                  pv.next = v.next;
               }
               else
               {
                  this.vertexList = v.next;
               }
               v.next = null;
               break;
            }
            pv = v;
            v = v.next;
         }
         if(v == null)
         {
            throw new ArgumentError("Vertex not found.");
         }
         for(var f:Face = this.faceList; f != null; )
         {
            nf = f.next;
            w = f.wrapper;
            while(true)
            {
               if(w != null)
               {
                  if(w.vertex != v)
                  {
                     continue;
                  }
               }
               if(w != null)
               {
                  if(pf != null)
                  {
                     pf.next = nf;
                  }
                  else
                  {
                     this.faceList = nf;
                  }
                  f.next = null;
               }
               else
               {
                  pf = f;
               }
               f = nf;
               break;
               w = w.next;
            }
         }
         return v;
      }
      
      public function containsVertex(vertex:Vertex) : Boolean
      {
         if(vertex == null)
         {
            throw new TypeError("Parameter vertex must be non-null.");
         }
         for(var v:Vertex = this.vertexList; v != null; v = v.next)
         {
            if(v == vertex)
            {
               return true;
            }
         }
         return false;
      }
      
      public function containsVertexWithId(id:Object) : Boolean
      {
         if(id == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         for(var v:Vertex = this.vertexList; v != null; v = v.next)
         {
            if(v.id == id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getVertexById(id:Object) : Vertex
      {
         if(id == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         for(var v:Vertex = this.vertexList; v != null; v = v.next)
         {
            if(v.id == id)
            {
               return v;
            }
         }
         return null;
      }
      
      public function addFace(vertices:Vector.<Vertex>, material:Material = null, id:Object = null) : Face
      {
         var nw:Wrapper = null;
         var v:Vertex = null;
         var last:Face = null;
         this.deleteResources();
         if(vertices == null)
         {
            throw new TypeError("Parameter vertices must be non-null.");
         }
         var len:int = int(vertices.length);
         if(len < 3)
         {
            throw new ArgumentError(len + " vertices not enough.");
         }
         var face:Face = new Face();
         face.material = material;
         face.id = id;
         var lw:Wrapper = null;
         for(var i:int = 0; i < len; i++)
         {
            nw = new Wrapper();
            v = vertices[i];
            if(v == null)
            {
               throw new ArgumentError("Null vertex in vector.");
            }
            if(!this.containsVertex(v))
            {
               throw new ArgumentError("Vertex not found.");
            }
            nw.vertex = v;
            if(lw != null)
            {
               lw.next = nw;
            }
            else
            {
               face.wrapper = nw;
            }
            lw = nw;
         }
         if(this.faceList != null)
         {
            for(last = this.faceList; last.next != null; )
            {
               last = last.next;
            }
            last.next = face;
         }
         else
         {
            this.faceList = face;
         }
         return face;
      }
      
      public function addFaceByIds(vertexIds:Array, material:Material = null, id:Object = null) : Face
      {
         var nw:Wrapper = null;
         var v:Vertex = null;
         var last:Face = null;
         this.deleteResources();
         if(vertexIds == null)
         {
            throw new TypeError("Parameter vertices must be non-null.");
         }
         var len:int = int(vertexIds.length);
         if(len < 3)
         {
            throw new ArgumentError(len + " vertices not enough.");
         }
         var face:Face = new Face();
         face.material = material;
         face.id = id;
         var lw:Wrapper = null;
         for(var i:int = 0; i < len; i++)
         {
            nw = new Wrapper();
            v = this.getVertexById(vertexIds[i]);
            if(v == null)
            {
               throw new ArgumentError("Vertex not found.");
            }
            nw.vertex = v;
            if(lw != null)
            {
               lw.next = nw;
            }
            else
            {
               face.wrapper = nw;
            }
            lw = nw;
         }
         if(this.faceList != null)
         {
            for(last = this.faceList; last.next != null; )
            {
               last = last.next;
            }
            last.next = face;
         }
         else
         {
            this.faceList = face;
         }
         return face;
      }
      
      public function addTriFace(a:Vertex, b:Vertex, c:Vertex, material:Material = null, id:Object = null) : Face
      {
         var last:Face = null;
         this.deleteResources();
         if(a == null)
         {
            throw new TypeError("Parameter v1 must be non-null.");
         }
         if(b == null)
         {
            throw new TypeError("Parameter v2 must be non-null.");
         }
         if(c == null)
         {
            throw new TypeError("Parameter v3 must be non-null.");
         }
         if(!this.containsVertex(a))
         {
            throw new ArgumentError("Vertex not found.");
         }
         if(!this.containsVertex(b))
         {
            throw new ArgumentError("Vertex not found.");
         }
         if(!this.containsVertex(c))
         {
            throw new ArgumentError("Vertex not found.");
         }
         var face:Face = new Face();
         face.material = material;
         face.id = id;
         face.wrapper = new Wrapper();
         face.wrapper.vertex = a;
         face.wrapper.next = new Wrapper();
         face.wrapper.next.vertex = b;
         face.wrapper.next.next = new Wrapper();
         face.wrapper.next.next.vertex = c;
         if(this.faceList != null)
         {
            for(last = this.faceList; last.next != null; )
            {
               last = last.next;
            }
            last.next = face;
         }
         else
         {
            this.faceList = face;
         }
         return face;
      }
      
      public function addQuadFace(a:Vertex, b:Vertex, c:Vertex, d:Vertex, material:Material = null, id:Object = null) : Face
      {
         var last:Face = null;
         this.deleteResources();
         if(a == null)
         {
            throw new TypeError("Parameter v1 must be non-null.");
         }
         if(b == null)
         {
            throw new TypeError("Parameter v2 must be non-null.");
         }
         if(c == null)
         {
            throw new TypeError("Parameter v3 must be non-null.");
         }
         if(d == null)
         {
            throw new TypeError("Parameter v4 must be non-null.");
         }
         if(!this.containsVertex(a))
         {
            throw new ArgumentError("Vertex not found.");
         }
         if(!this.containsVertex(b))
         {
            throw new ArgumentError("Vertex not found.");
         }
         if(!this.containsVertex(c))
         {
            throw new ArgumentError("Vertex not found.");
         }
         if(!this.containsVertex(d))
         {
            throw new ArgumentError("Vertex not found.");
         }
         var face:Face = new Face();
         face.material = material;
         face.id = id;
         face.wrapper = new Wrapper();
         face.wrapper.vertex = a;
         face.wrapper.next = new Wrapper();
         face.wrapper.next.vertex = b;
         face.wrapper.next.next = new Wrapper();
         face.wrapper.next.next.vertex = c;
         face.wrapper.next.next.next = new Wrapper();
         face.wrapper.next.next.next.vertex = d;
         if(this.faceList != null)
         {
            for(last = this.faceList; last.next != null; )
            {
               last = last.next;
            }
            last.next = face;
         }
         else
         {
            this.faceList = face;
         }
         return face;
      }
      
      public function removeFace(face:Face) : Face
      {
         var pf:Face = null;
         this.deleteResources();
         if(face == null)
         {
            throw new TypeError("Parameter face must be non-null.");
         }
         for(var f:Face = this.faceList; f != null; )
         {
            if(f == face)
            {
               if(pf != null)
               {
                  pf.next = f.next;
               }
               else
               {
                  this.faceList = f.next;
               }
               f.next = null;
               break;
            }
            pf = f;
            f = f.next;
         }
         if(f == null)
         {
            throw new ArgumentError("Face not found.");
         }
         return f;
      }
      
      public function removeFaceById(id:Object) : Face
      {
         var pf:Face = null;
         this.deleteResources();
         if(id == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         for(var f:Face = this.faceList; f != null; )
         {
            if(f.id == id)
            {
               if(pf != null)
               {
                  pf.next = f.next;
               }
               else
               {
                  this.faceList = f.next;
               }
               f.next = null;
               break;
            }
            pf = f;
            f = f.next;
         }
         if(f == null)
         {
            throw new ArgumentError("Face not found.");
         }
         return f;
      }
      
      public function containsFace(face:Face) : Boolean
      {
         if(face == null)
         {
            throw new TypeError("Parameter face must be non-null.");
         }
         for(var f:Face = this.faceList; f != null; f = f.next)
         {
            if(f == face)
            {
               return true;
            }
         }
         return false;
      }
      
      public function containsFaceWithId(id:Object) : Boolean
      {
         if(id == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         for(var f:Face = this.faceList; f != null; f = f.next)
         {
            if(f.id == id)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getFaceById(id:Object) : Face
      {
         if(id == null)
         {
            throw new TypeError("Parameter id must be non-null.");
         }
         for(var f:Face = this.faceList; f != null; f = f.next)
         {
            if(f.id == id)
            {
               return f;
            }
         }
         return null;
      }
      
      public function addVerticesAndFaces(vertices:Vector.<Number>, uvs:Vector.<Number>, indices:Vector.<int>, poly:Boolean = false, material:Material = null) : void
      {
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var lastVertex:Vertex = null;
         var lastFace:Face = null;
         var face:Face = null;
         var lw:Wrapper = null;
         var index:int = 0;
         var num:int = 0;
         var vertex:Vertex = null;
         var nw:Wrapper = null;
         this.deleteResources();
         if(vertices == null)
         {
            throw new TypeError("Parameter vertices must be non-null.");
         }
         if(uvs == null)
         {
            throw new TypeError("Parameter uvs must be non-null.");
         }
         if(indices == null)
         {
            throw new TypeError("Parameter indices must be non-null.");
         }
         var vertsLength:int = vertices.length / 3;
         if(vertsLength != uvs.length / 2)
         {
            throw new ArgumentError("Vertices count and uvs count doesn\'t match.");
         }
         var indicesLength:int = int(indices.length);
         if(!poly && Boolean(indicesLength % 3))
         {
            throw new ArgumentError("Incorrect indices.");
         }
         i = 0;
         k = 0;
         while(i < indicesLength)
         {
            if(i == k)
            {
               num = poly ? indices[i] : 3;
               if(num < 3)
               {
                  throw new ArgumentError(num + " vertices not enough.");
               }
               k = poly ? int(num + ++i) : int(i + num);
               if(k > indicesLength)
               {
                  throw new ArgumentError("Incorrect indices.");
               }
            }
            index = indices[i];
            if(index < 0 || index >= vertsLength)
            {
               throw new RangeError("Index is out of bounds.");
            }
            i++;
         }
         if(this.vertexList != null)
         {
            for(lastVertex = this.vertexList; lastVertex.next != null; )
            {
               lastVertex = lastVertex.next;
            }
         }
         var verts:Vector.<Vertex> = new Vector.<Vertex>(vertsLength);
         i = 0;
         j = 0;
         k = 0;
         while(i < vertsLength)
         {
            vertex = new Vertex();
            vertex.x = vertices[j];
            j++;
            vertex.y = vertices[j];
            j++;
            vertex.z = vertices[j];
            j++;
            vertex.u = uvs[k];
            k++;
            vertex.v = uvs[k];
            k++;
            verts[i] = vertex;
            if(lastVertex != null)
            {
               lastVertex.next = vertex;
            }
            else
            {
               this.vertexList = vertex;
            }
            lastVertex = vertex;
            i++;
         }
         if(this.faceList != null)
         {
            for(lastFace = this.faceList; lastFace.next != null; )
            {
               lastFace = lastFace.next;
            }
         }
         i = 0;
         k = 0;
         while(i < indicesLength)
         {
            if(i == k)
            {
               k = poly ? int(indices[i] + ++i) : int(i + 3);
               lw = null;
               face = new Face();
               face.material = material;
               if(lastFace != null)
               {
                  lastFace.next = face;
               }
               else
               {
                  this.faceList = face;
               }
               lastFace = face;
            }
            nw = new Wrapper();
            nw.vertex = verts[indices[i]];
            if(lw != null)
            {
               lw.next = nw;
            }
            else
            {
               face.wrapper = nw;
            }
            lw = nw;
            i++;
         }
      }
      
      public function get vertices() : Vector.<Vertex>
      {
         var res:Vector.<Vertex> = new Vector.<Vertex>();
         var len:int = 0;
         for(var vertex:Vertex = this.vertexList; vertex != null; vertex = vertex.next)
         {
            res[len] = vertex;
            len++;
         }
         return res;
      }
      
      public function get faces() : Vector.<Face>
      {
         var res:Vector.<Face> = new Vector.<Face>();
         var len:int = 0;
         for(var face:Face = this.faceList; face != null; face = face.next)
         {
            res[len] = face;
            len++;
         }
         return res;
      }
      
      public function weldVertices(distanceThreshold:Number = 0, uvThreshold:Number = 0) : void
      {
         var vertex:Vertex = null;
         var next:Vertex = null;
         var wrapper:Wrapper = null;
         this.deleteResources();
         var verts:Vector.<Vertex> = new Vector.<Vertex>();
         var vertsLength:int = 0;
         for(vertex = this.vertexList; vertex != null; vertex = next)
         {
            next = vertex.next;
            vertex.next = null;
            verts[vertsLength] = vertex;
            vertsLength++;
         }
         this.vertexList = null;
         this.group(verts,0,vertsLength,0,distanceThreshold,uvThreshold,new Vector.<int>());
         for(var face:Face = this.faceList; face != null; face = face.next)
         {
            for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               if(wrapper.vertex.value != null)
               {
                  wrapper.vertex = wrapper.vertex.value;
               }
            }
         }
         for(var i:int = 0; i < vertsLength; i++)
         {
            vertex = verts[i];
            if(vertex.value == null)
            {
               vertex.next = this.vertexList;
               this.vertexList = vertex;
            }
         }
      }
      
      public function weldFaces(angleThreshold:Number = 0, uvThreshold:Number = 0, convexThreshold:Number = 0, pairWeld:Boolean = false) : void
      {
         var i:int = 0;
         var j:int = 0;
         var key:* = undefined;
         var sibling:Face = null;
         var face:Face = null;
         var next:Face = null;
         var wp:Wrapper = null;
         var sp:Wrapper = null;
         var w:Wrapper = null;
         var s:Wrapper = null;
         var wn:Wrapper = null;
         var sn:Wrapper = null;
         var wm:Wrapper = null;
         var sm:Wrapper = null;
         var vertex:Vertex = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var abu:Number = NaN;
         var abv:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var acu:Number = NaN;
         var acv:Number = NaN;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var nz:Number = NaN;
         var nl:Number = NaN;
         var dictionary:Dictionary = null;
         var num:int = 0;
         var det:Number = NaN;
         var ima:Number = NaN;
         var imb:Number = NaN;
         var imc:Number = NaN;
         var imd:Number = NaN;
         var ime:Number = NaN;
         var imf:Number = NaN;
         var img:Number = NaN;
         var imh:Number = NaN;
         var ma:Number = NaN;
         var mb:Number = NaN;
         var mc:Number = NaN;
         var md:Number = NaN;
         var me:Number = NaN;
         var mf:Number = NaN;
         var mg:Number = NaN;
         var mh:Number = NaN;
         var du:Number = NaN;
         var dv:Number = NaN;
         var weld:Boolean = false;
         var newFace:Face = null;
         this.deleteResources();
         angleThreshold = Math.cos(angleThreshold) - 0.001;
         uvThreshold += 0.001;
         convexThreshold = Math.cos(Math.PI - convexThreshold) - 0.001;
         var faceSet:Dictionary = new Dictionary();
         var map:Dictionary = new Dictionary();
         face = this.faceList;
         while(face != null)
         {
            next = face.next;
            face.next = null;
            a = face.wrapper.vertex;
            b = face.wrapper.next.vertex;
            c = face.wrapper.next.next.vertex;
            abx = b.x - a.x;
            aby = b.y - a.y;
            abz = b.z - a.z;
            acx = c.x - a.x;
            acy = c.y - a.y;
            acz = c.z - a.z;
            nx = acz * aby - acy * abz;
            ny = acx * abz - acz * abx;
            nz = acy * abx - acx * aby;
            nl = nx * nx + ny * ny + nz * nz;
            if(nl > 0.001)
            {
               nl = 1 / Math.sqrt(nl);
               nx *= nl;
               ny *= nl;
               nz *= nl;
               face.normalX = nx;
               face.normalY = ny;
               face.normalZ = nz;
               face.offset = a.x * nx + a.y * ny + a.z * nz;
               faceSet[face] = true;
               wn = face.wrapper;
               while(wn != null)
               {
                  vertex = wn.vertex;
                  dictionary = map[vertex];
                  if(dictionary == null)
                  {
                     dictionary = new Dictionary();
                     map[vertex] = dictionary;
                  }
                  dictionary[face] = true;
                  wn = wn.next;
               }
            }
            face = next;
         }
         this.faceList = null;
         var island:Vector.<Face> = new Vector.<Face>();
         var siblings:Dictionary = new Dictionary();
         var unfit:Dictionary = new Dictionary();
         while(true)
         {
            face = null;
            var _loc66_:int = 0;
            var _loc67_:* = faceSet;
            for(key in _loc67_)
            {
               face = key;
               delete faceSet[key];
            }
            if(face == null)
            {
               break;
            }
            num = 0;
            island[num] = face;
            num++;
            a = face.wrapper.vertex;
            b = face.wrapper.next.vertex;
            c = face.wrapper.next.next.vertex;
            abx = b.x - a.x;
            aby = b.y - a.y;
            abz = b.z - a.z;
            abu = b.u - a.u;
            abv = b.v - a.v;
            acx = c.x - a.x;
            acy = c.y - a.y;
            acz = c.z - a.z;
            acu = c.u - a.u;
            acv = c.v - a.v;
            nx = face.normalX;
            ny = face.normalY;
            nz = face.normalZ;
            det = -nx * acy * abz + acx * ny * abz + nx * aby * acz - abx * ny * acz - acx * aby * nz + abx * acy * nz;
            ima = (-ny * acz + acy * nz) / det;
            imb = (nx * acz - acx * nz) / det;
            imc = (-nx * acy + acx * ny) / det;
            imd = (a.x * ny * acz - nx * a.y * acz - a.x * acy * nz + acx * a.y * nz + nx * acy * a.z - acx * ny * a.z) / det;
            ime = (ny * abz - aby * nz) / det;
            imf = (-nx * abz + abx * nz) / det;
            img = (nx * aby - abx * ny) / det;
            imh = (nx * a.y * abz - a.x * ny * abz + a.x * aby * nz - abx * a.y * nz - nx * aby * a.z + abx * ny * a.z) / det;
            ma = abu * ima + acu * ime;
            mb = abu * imb + acu * imf;
            mc = abu * imc + acu * img;
            md = abu * imd + acu * imh + a.u;
            me = abv * ima + acv * ime;
            mf = abv * imb + acv * imf;
            mg = abv * imc + acv * img;
            mh = abv * imd + acv * imh + a.v;
            for(key in unfit)
            {
               delete unfit[key];
            }
            i = 0;
            while(i < num)
            {
               face = island[i];
               for(key in siblings)
               {
                  delete siblings[key];
               }
               w = face.wrapper;
               while(w != null)
               {
                  for(key in map[w.vertex])
                  {
                     if(Boolean(faceSet[key]) && !unfit[key])
                     {
                        siblings[key] = true;
                     }
                  }
                  w = w.next;
               }
               for(key in siblings)
               {
                  sibling = key;
                  if(nx * sibling.normalX + ny * sibling.normalY + nz * sibling.normalZ >= angleThreshold)
                  {
                     s = sibling.wrapper;
                     while(s != null)
                     {
                        vertex = s.vertex;
                        du = ma * vertex.x + mb * vertex.y + mc * vertex.z + md - vertex.u;
                        dv = me * vertex.x + mf * vertex.y + mg * vertex.z + mh - vertex.v;
                        if(du > uvThreshold || du < -uvThreshold || dv > uvThreshold || dv < -uvThreshold)
                        {
                           break;
                        }
                        s = s.next;
                     }
                     if(s == null)
                     {
                        w = face.wrapper;
                        while(w != null)
                        {
                           wn = w.next != null ? w.next : face.wrapper;
                           s = sibling.wrapper;
                           while(s != null)
                           {
                              sn = s.next != null ? s.next : sibling.wrapper;
                              if(w.vertex == sn.vertex && wn.vertex == s.vertex)
                              {
                                 break;
                              }
                              s = s.next;
                           }
                           if(s != null)
                           {
                              break;
                           }
                           w = w.next;
                        }
                        if(w != null)
                        {
                           island[num] = sibling;
                           num++;
                           delete faceSet[sibling];
                        }
                     }
                     else
                     {
                        unfit[sibling] = true;
                     }
                  }
                  else
                  {
                     unfit[sibling] = true;
                  }
               }
               i++;
            }
            if(num == 1)
            {
               face = island[0];
               face.next = this.faceList;
               this.faceList = face;
            }
            else
            {
               do
               {
                  weld = false;
                  i = 0;
                  while(i < num - 1)
                  {
                     face = island[i];
                     if(face != null)
                     {
                        j = 1;
                        for(; j < num; j++)
                        {
                           sibling = island[j];
                           if(sibling != null)
                           {
                              w = face.wrapper;
                              while(w != null)
                              {
                                 wn = w.next != null ? w.next : face.wrapper;
                                 s = sibling.wrapper;
                                 while(s != null)
                                 {
                                    sn = s.next != null ? s.next : sibling.wrapper;
                                    if(w.vertex == sn.vertex && wn.vertex == s.vertex)
                                    {
                                       break;
                                    }
                                    s = s.next;
                                 }
                                 if(s != null)
                                 {
                                    break;
                                 }
                                 w = w.next;
                              }
                              if(w != null)
                              {
                                 while(true)
                                 {
                                    wm = wn.next != null ? wn.next : face.wrapper;
                                    sp = sibling.wrapper;
                                    while(sp.next != s && sp.next != null)
                                    {
                                       sp = sp.next;
                                    }
                                    if(wm.vertex != sp.vertex)
                                    {
                                       break;
                                    }
                                    wn = wm;
                                    s = sp;
                                 }
                                 while(true)
                                 {
                                    wp = face.wrapper;
                                    while(wp.next != w && wp.next != null)
                                    {
                                       wp = wp.next;
                                    }
                                    sm = sn.next != null ? sn.next : sibling.wrapper;
                                    if(wp.vertex != sm.vertex)
                                    {
                                       break;
                                    }
                                    w = wp;
                                    sn = sm;
                                 }
                                 a = w.vertex;
                                 b = sm.vertex;
                                 c = wp.vertex;
                                 abx = b.x - a.x;
                                 aby = b.y - a.y;
                                 abz = b.z - a.z;
                                 acx = c.x - a.x;
                                 acy = c.y - a.y;
                                 acz = c.z - a.z;
                                 nx = acz * aby - acy * abz;
                                 ny = acx * abz - acz * abx;
                                 nz = acy * abx - acx * aby;
                                 if(nx < 0.001 && nx > -0.001 && ny < 0.001 && ny > -0.001 && nz < 0.001 && nz > -0.001)
                                 {
                                    if(abx * acx + aby * acy + abz * acz > 0)
                                    {
                                       continue;
                                    }
                                 }
                                 else if(face.normalX * nx + face.normalY * ny + face.normalZ * nz < 0)
                                 {
                                    continue;
                                 }
                                 nl = 1 / Math.sqrt(abx * abx + aby * aby + abz * abz);
                                 abx *= nl;
                                 aby *= nl;
                                 abz *= nl;
                                 nl = 1 / Math.sqrt(acx * acx + acy * acy + acz * acz);
                                 acx *= nl;
                                 acy *= nl;
                                 acz *= nl;
                                 if(abx * acx + aby * acy + abz * acz >= convexThreshold)
                                 {
                                    a = s.vertex;
                                    b = wm.vertex;
                                    c = sp.vertex;
                                    abx = b.x - a.x;
                                    aby = b.y - a.y;
                                    abz = b.z - a.z;
                                    acx = c.x - a.x;
                                    acy = c.y - a.y;
                                    acz = c.z - a.z;
                                    nx = acz * aby - acy * abz;
                                    ny = acx * abz - acz * abx;
                                    nz = acy * abx - acx * aby;
                                    if(nx < 0.001 && nx > -0.001 && ny < 0.001 && ny > -0.001 && nz < 0.001 && nz > -0.001)
                                    {
                                       if(abx * acx + aby * acy + abz * acz > 0)
                                       {
                                          continue;
                                       }
                                    }
                                    else if(face.normalX * nx + face.normalY * ny + face.normalZ * nz < 0)
                                    {
                                       continue;
                                    }
                                    nl = 1 / Math.sqrt(abx * abx + aby * aby + abz * abz);
                                    abx *= nl;
                                    aby *= nl;
                                    abz *= nl;
                                    nl = 1 / Math.sqrt(acx * acx + acy * acy + acz * acz);
                                    acx *= nl;
                                    acy *= nl;
                                    acz *= nl;
                                    if(abx * acx + aby * acy + abz * acz >= convexThreshold)
                                    {
                                       weld = true;
                                       newFace = new Face();
                                       newFace.material = face.material;
                                       newFace.smoothingGroups = face.smoothingGroups;
                                       newFace.normalX = face.normalX;
                                       newFace.normalY = face.normalY;
                                       newFace.normalZ = face.normalZ;
                                       newFace.offset = face.offset;
                                       newFace.id = face.id;
                                       wm = null;
                                       while(wn != w)
                                       {
                                          sm = new Wrapper();
                                          sm.vertex = wn.vertex;
                                          if(wm != null)
                                          {
                                             wm.next = sm;
                                          }
                                          else
                                          {
                                             newFace.wrapper = sm;
                                          }
                                          wm = sm;
                                          wn = wn.next != null ? wn.next : face.wrapper;
                                       }
                                       while(sn != s)
                                       {
                                          sm = new Wrapper();
                                          sm.vertex = sn.vertex;
                                          if(wm != null)
                                          {
                                             wm.next = sm;
                                          }
                                          else
                                          {
                                             newFace.wrapper = sm;
                                          }
                                          wm = sm;
                                          sn = sn.next != null ? sn.next : sibling.wrapper;
                                       }
                                       island[i] = newFace;
                                       island[j] = null;
                                       face = newFace;
                                       if(pairWeld)
                                       {
                                          break;
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                     i++;
                  }
               }
               while(weld);
               i = 0;
               while(i < num)
               {
                  face = island[i];
                  if(face != null)
                  {
                     face.calculateBestSequenceAndNormal();
                     face.next = this.faceList;
                     this.faceList = face;
                  }
                  i++;
               }
            }
         }
      }
      
      private function group(verts:Vector.<Vertex>, begin:int, end:int, depth:int, distanceThreshold:Number, uvThreshold:Number, stack:Vector.<int>) : void
      {
         var i:int = 0;
         var j:int = 0;
         var vertex:Vertex = null;
         var threshold:Number = NaN;
         var compared:Vertex = null;
         var r:int = 0;
         var l:int = 0;
         var median:Number = NaN;
         var left:Vertex = null;
         var right:Vertex = null;
         switch(depth)
         {
            case 0:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.x;
               }
               threshold = distanceThreshold;
               break;
            case 1:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.y;
               }
               threshold = distanceThreshold;
               break;
            case 2:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.z;
               }
               threshold = distanceThreshold;
               break;
            case 3:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.u;
               }
               threshold = uvThreshold;
               break;
            case 4:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.v;
               }
               threshold = uvThreshold;
         }
         stack[0] = begin;
         stack[1] = end - 1;
         for(var index:int = 2; index > 0; )
         {
            index--;
            r = stack[index];
            j = r;
            index--;
            l = stack[index];
            i = l;
            vertex = verts[r + l >> 1];
            for(median = vertex.offset; i <= j; )
            {
               for(left = verts[i]; left.offset > median; )
               {
                  i++;
                  left = verts[i];
               }
               for(right = verts[j]; right.offset < median; )
               {
                  j--;
                  right = verts[j];
               }
               if(i <= j)
               {
                  verts[i] = right;
                  verts[j] = left;
                  i++;
                  j--;
               }
            }
            if(l < j)
            {
               stack[index] = l;
               index++;
               stack[index] = j;
               index++;
            }
            if(i < r)
            {
               stack[index] = i;
               index++;
               stack[index] = r;
               index++;
            }
         }
         i = begin;
         vertex = verts[i];
         for(j = i + 1; j <= end; )
         {
            if(j < end)
            {
               compared = verts[j];
            }
            if(j == end || vertex.offset - compared.offset > threshold)
            {
               if(depth < 4 && j - i > 1)
               {
                  this.group(verts,i,j,depth + 1,distanceThreshold,uvThreshold,stack);
               }
               if(j < end)
               {
                  i = j;
                  vertex = verts[i];
               }
            }
            else if(depth == 4)
            {
               compared.value = vertex;
            }
            j++;
         }
      }
      
      public function setMaterialToAllFaces(material:Material) : void
      {
         this.deleteResources();
         for(var face:Face = this.faceList; face != null; face = face.next)
         {
            face.material = material;
         }
      }
      
      public function calculateFacesNormals(normalize:Boolean = true) : void
      {
         var w:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var nz:Number = NaN;
         var length:Number = NaN;
         this.deleteResources();
         for(var face:Face = this.faceList; face != null; face = face.next)
         {
            w = face.wrapper;
            a = w.vertex;
            w = w.next;
            b = w.vertex;
            w = w.next;
            c = w.vertex;
            abx = b.x - a.x;
            aby = b.y - a.y;
            abz = b.z - a.z;
            acx = c.x - a.x;
            acy = c.y - a.y;
            acz = c.z - a.z;
            nx = acz * aby - acy * abz;
            ny = acx * abz - acz * abx;
            nz = acy * abx - acx * aby;
            if(normalize)
            {
               length = nx * nx + ny * ny + nz * nz;
               if(length > 0.001)
               {
                  length = 1 / Math.sqrt(length);
                  nx *= length;
                  ny *= length;
                  nz *= length;
               }
            }
            face.normalX = nx;
            face.normalY = ny;
            face.normalZ = nz;
            face.offset = a.x * nx + a.y * ny + a.z * nz;
         }
      }
      
      public function calculateVerticesNormals(weldSeams:Boolean = false, distanceThreshold:Number = 0) : void
      {
         var vertex:Vertex = null;
         var length:Number = NaN;
         var w:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var nz:Number = NaN;
         var verts:Vector.<Vertex> = null;
         this.deleteResources();
         for(vertex = this.vertexList; vertex != null; vertex = vertex.next)
         {
            vertex.normalX = 0;
            vertex.normalY = 0;
            vertex.normalZ = 0;
         }
         for(var face:Face = this.faceList; face != null; face = face.next)
         {
            w = face.wrapper;
            a = w.vertex;
            w = w.next;
            b = w.vertex;
            w = w.next;
            c = w.vertex;
            abx = b.x - a.x;
            aby = b.y - a.y;
            abz = b.z - a.z;
            acx = c.x - a.x;
            acy = c.y - a.y;
            acz = c.z - a.z;
            nx = acz * aby - acy * abz;
            ny = acx * abz - acz * abx;
            nz = acy * abx - acx * aby;
            length = nx * nx + ny * ny + nz * nz;
            if(length > 0.001)
            {
               length = 1 / Math.sqrt(length);
               nx *= length;
               ny *= length;
               nz *= length;
            }
            for(w = face.wrapper; w != null; w = w.next)
            {
               vertex = w.vertex;
               vertex.normalX += nx;
               vertex.normalY += ny;
               vertex.normalZ += nz;
            }
         }
         if(weldSeams)
         {
            verts = this.vertices;
            this.weldNormals(verts,0,verts.length,0,distanceThreshold,new Vector.<int>());
         }
         for(vertex = this.vertexList; vertex != null; vertex = vertex.next)
         {
            length = vertex.normalX * vertex.normalX + vertex.normalY * vertex.normalY + vertex.normalZ * vertex.normalZ;
            if(length > 0.001)
            {
               length = 1 / Math.sqrt(length);
               vertex.normalX *= length;
               vertex.normalY *= length;
               vertex.normalZ *= length;
            }
         }
      }
      
      alternativa3d function weldNormals(verts:Vector.<Vertex>, begin:int, end:int, depth:int, threshold:Number, stack:Vector.<int>) : void
      {
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         var vertex:Vertex = null;
         var compared:Vertex = null;
         var r:int = 0;
         var l:int = 0;
         var median:Number = NaN;
         var left:Vertex = null;
         var right:Vertex = null;
         switch(depth)
         {
            case 0:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.x;
               }
               break;
            case 1:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.y;
               }
               break;
            case 2:
               for(i = begin; i < end; i++)
               {
                  vertex = verts[i];
                  vertex.offset = vertex.z;
               }
         }
         stack[0] = begin;
         stack[1] = end - 1;
         for(var index:int = 2; index > 0; )
         {
            index--;
            r = stack[index];
            j = r;
            index--;
            l = stack[index];
            i = l;
            vertex = verts[r + l >> 1];
            for(median = vertex.offset; i <= j; )
            {
               for(left = verts[i]; left.offset > median; )
               {
                  i++;
                  left = verts[i];
               }
               for(right = verts[j]; right.offset < median; )
               {
                  j--;
                  right = verts[j];
               }
               if(i <= j)
               {
                  verts[i] = right;
                  verts[j] = left;
                  i++;
                  j--;
               }
            }
            if(l < j)
            {
               stack[index] = l;
               index++;
               stack[index] = j;
               index++;
            }
            if(i < r)
            {
               stack[index] = i;
               index++;
               stack[index] = r;
               index++;
            }
         }
         i = begin;
         vertex = verts[i];
         for(j = i + 1; j <= end; j++)
         {
            if(j < end)
            {
               compared = verts[j];
            }
            if(j == end || vertex.offset - compared.offset > threshold)
            {
               if(j - i > 1)
               {
                  if(depth < 2)
                  {
                     this.weldNormals(verts,i,j,depth + 1,threshold,stack);
                  }
                  else
                  {
                     for(k = i + 1; k < j; )
                     {
                        compared = verts[k];
                        vertex.normalX += compared.normalX;
                        vertex.normalY += compared.normalY;
                        vertex.normalZ += compared.normalZ;
                        k++;
                     }
                     for(k = i + 1; k < j; k++)
                     {
                        compared = verts[k];
                        compared.normalX = vertex.normalX;
                        compared.normalY = vertex.normalY;
                        compared.normalZ = vertex.normalZ;
                     }
                  }
               }
               if(j < end)
               {
                  i = j;
                  vertex = verts[i];
               }
            }
         }
      }
      
      public function calculateVerticesNormalsByAngle(angleThreshold:Number, distanceThreshold:Number = 0) : void
      {
         var face:Face = null;
         var wrapper:Wrapper = null;
         var vertex:Vertex = null;
         var newVertex:Vertex = null;
         var key:* = undefined;
         var len:Number = NaN;
         var sibling:Face = null;
         this.deleteResources();
         this.calculateNormalsAndRemoveDegenerateFaces();
         var map:Dictionary = new Dictionary();
         for(vertex = this.vertexList; vertex != null; vertex = vertex.next)
         {
            map[vertex] = new Dictionary();
         }
         for(face = this.faceList; face != null; face = face.next)
         {
            for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               vertex = wrapper.vertex;
               map[vertex][face] = true;
            }
         }
         var verts:Vector.<Vertex> = this.vertices;
         shareFaces(verts,0,verts.length,0,distanceThreshold,new Vector.<int>(),map);
         this.vertexList = null;
         angleThreshold = Math.cos(angleThreshold);
         for(face = this.faceList; face != null; face = face.next)
         {
            for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               vertex = wrapper.vertex;
               newVertex = new Vertex();
               newVertex.x = vertex.x;
               newVertex.y = vertex.y;
               newVertex.z = vertex.z;
               newVertex.u = vertex.u;
               newVertex.v = vertex.v;
               newVertex.id = vertex.id;
               newVertex.normalX = face.normalX;
               newVertex.normalY = face.normalY;
               newVertex.normalZ = face.normalZ;
               for(key in map[vertex])
               {
                  sibling = key;
                  if(face != sibling && face.normalX * sibling.normalX + face.normalY * sibling.normalY + face.normalZ * sibling.normalZ >= angleThreshold)
                  {
                     newVertex.normalX += sibling.normalX;
                     newVertex.normalY += sibling.normalY;
                     newVertex.normalZ += sibling.normalZ;
                  }
               }
               len = newVertex.normalX * newVertex.normalX + newVertex.normalY * newVertex.normalY + newVertex.normalZ * newVertex.normalZ;
               if(len > 0.001)
               {
                  len = 1 / Math.sqrt(len);
                  newVertex.normalX *= len;
                  newVertex.normalY *= len;
                  newVertex.normalZ *= len;
               }
               wrapper.vertex = newVertex;
               newVertex.next = this.vertexList;
               this.vertexList = newVertex;
            }
         }
      }
      
      public function calculateVerticesNormalsBySmoothingGroups(distanceThreshold:Number = 0) : void
      {
         var key:* = undefined;
         var face:Face = null;
         var vertex:Vertex = null;
         var wrapper:Wrapper = null;
         var newVertex:Vertex = null;
         var len:Number = NaN;
         var sibling:Face = null;
         this.deleteResources();
         this.calculateNormalsAndRemoveDegenerateFaces();
         var map:Dictionary = new Dictionary();
         for(face = this.faceList; face != null; face = face.next)
         {
            if(face.smoothingGroups > 0)
            {
               for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
               {
                  vertex = wrapper.vertex;
                  if(!map[vertex])
                  {
                     map[vertex] = new Dictionary();
                  }
                  map[vertex][face] = true;
               }
            }
         }
         var verts:Vector.<Vertex> = new Vector.<Vertex>();
         var vertsLength:int = 0;
         for(key in map)
         {
            verts[vertsLength] = key;
            vertsLength++;
         }
         if(vertsLength > 0)
         {
            shareFaces(verts,0,vertsLength,0,distanceThreshold,new Vector.<int>(),map);
         }
         this.vertexList = null;
         for(face = this.faceList; face != null; face = face.next)
         {
            for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               vertex = wrapper.vertex;
               newVertex = new Vertex();
               newVertex.x = vertex.x;
               newVertex.y = vertex.y;
               newVertex.z = vertex.z;
               newVertex.u = vertex.u;
               newVertex.v = vertex.v;
               newVertex.id = vertex.id;
               newVertex.normalX = face.normalX;
               newVertex.normalY = face.normalY;
               newVertex.normalZ = face.normalZ;
               if(face.smoothingGroups > 0)
               {
                  for(key in map[vertex])
                  {
                     sibling = key;
                     if(face != sibling && (face.smoothingGroups & sibling.smoothingGroups) > 0)
                     {
                        newVertex.normalX += sibling.normalX;
                        newVertex.normalY += sibling.normalY;
                        newVertex.normalZ += sibling.normalZ;
                     }
                  }
                  len = newVertex.normalX * newVertex.normalX + newVertex.normalY * newVertex.normalY + newVertex.normalZ * newVertex.normalZ;
                  if(len > 0.001)
                  {
                     len = 1 / Math.sqrt(len);
                     newVertex.normalX *= len;
                     newVertex.normalY *= len;
                     newVertex.normalZ *= len;
                  }
               }
               wrapper.vertex = newVertex;
               newVertex.next = this.vertexList;
               this.vertexList = newVertex;
            }
         }
      }
      
      private function calculateNormalsAndRemoveDegenerateFaces() : void
      {
         var next:Face = null;
         var w:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var length:Number = NaN;
         var face:Face = this.faceList;
         for(this.faceList = null; face != null; )
         {
            next = face.next;
            w = face.wrapper;
            a = w.vertex;
            w = w.next;
            b = w.vertex;
            w = w.next;
            c = w.vertex;
            abx = b.x - a.x;
            aby = b.y - a.y;
            abz = b.z - a.z;
            acx = c.x - a.x;
            acy = c.y - a.y;
            acz = c.z - a.z;
            face.normalX = acz * aby - acy * abz;
            face.normalY = acx * abz - acz * abx;
            face.normalZ = acy * abx - acx * aby;
            length = face.normalX * face.normalX + face.normalY * face.normalY + face.normalZ * face.normalZ;
            if(length > 0.001)
            {
               length = 1 / Math.sqrt(length);
               face.normalX *= length;
               face.normalY *= length;
               face.normalZ *= length;
               face.offset = a.x * face.normalX + a.y * face.normalY + a.z * face.normalZ;
               face.next = this.faceList;
               this.faceList = face;
            }
            else
            {
               face.next = null;
            }
            face = next;
         }
      }
      
      public function optimizeForDynamicBSP(iterations:int = 1) : void
      {
         var last:Face = null;
         var prev:Face = null;
         var face:Face = null;
         var normalX:Number = NaN;
         var normalY:Number = NaN;
         var normalZ:Number = NaN;
         var offset:Number = NaN;
         var offsetMin:Number = NaN;
         var offsetMax:Number = NaN;
         var splits:int = 0;
         var f:Face = null;
         var w:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var ao:Number = NaN;
         var bo:Number = NaN;
         var co:Number = NaN;
         var behind:Boolean = false;
         var infront:Boolean = false;
         var v:Vertex = null;
         var vo:Number = NaN;
         this.deleteResources();
         var list:Face = this.faceList;
         for(var i:int = 0; i < iterations; )
         {
            prev = null;
            for(face = list; face != null; )
            {
               normalX = face.normalX;
               normalY = face.normalY;
               normalZ = face.normalZ;
               offset = face.offset;
               offsetMin = offset - this.threshold;
               offsetMax = offset + this.threshold;
               splits = 0;
               f = list;
               loop2:
               while(true)
               {
                  if(f == null)
                  {
                     if(f == null)
                     {
                        if(prev != null)
                        {
                           prev.next = face.next;
                        }
                        else
                        {
                           list = face.next;
                        }
                        if(last != null)
                        {
                           last.next = face;
                        }
                        else
                        {
                           this.faceList = face;
                        }
                        last = face;
                     }
                     else
                     {
                        prev = face;
                     }
                     face = face.next;
                  }
                  if(f != face)
                  {
                     w = f.wrapper;
                     a = w.vertex;
                     w = w.next;
                     b = w.vertex;
                     w = w.next;
                     c = w.vertex;
                     w = w.next;
                     ao = a.x * normalX + a.y * normalY + a.z * normalZ;
                     bo = b.x * normalX + b.y * normalY + b.z * normalZ;
                     co = c.x * normalX + c.y * normalY + c.z * normalZ;
                     behind = ao < offsetMin || bo < offsetMin || co < offsetMin;
                     infront = ao > offsetMax || bo > offsetMax || co > offsetMax;
                     while(true)
                     {
                        if(w != null)
                        {
                           v = w.vertex;
                           vo = v.x * normalX + v.y * normalY + v.z * normalZ;
                           if(vo < offsetMin)
                           {
                              behind = true;
                              if(!infront)
                              {
                                 continue;
                              }
                           }
                           else
                           {
                              if(vo <= offsetMax)
                              {
                                 continue;
                              }
                              infront = true;
                              if(!behind)
                              {
                                 continue;
                              }
                           }
                        }
                        if(!(infront && behind))
                        {
                           continue loop2;
                        }
                        splits++;
                        if(splits <= i)
                        {
                           continue loop2;
                        }
                        w = w.next;
                     }
                  }
                  f = f.next;
               }
            }
            if(list == null)
            {
               break;
            }
            i++;
         }
         if(last != null)
         {
            last.next = list;
         }
      }
      
      override public function intersectRay(origin:Vector3D, direction:Vector3D, excludedObjects:Dictionary = null, camera:Camera3D = null) : RayIntersectionData
      {
         var point:Vector3D = null;
         var nearFace:Face = null;
         var normalX:Number = NaN;
         var normalY:Number = NaN;
         var normalZ:Number = NaN;
         var dot:Number = NaN;
         var offset:Number = NaN;
         var time:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var cz:Number = NaN;
         var wrapper:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var res:RayIntersectionData = null;
         if(excludedObjects != null && Boolean(excludedObjects[this]))
         {
            return null;
         }
         if(!boundIntersectRay(origin,direction,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return null;
         }
         var ox:Number = origin.x;
         var oy:Number = origin.y;
         var oz:Number = origin.z;
         var dx:Number = direction.x;
         var dy:Number = direction.y;
         var dz:Number = direction.z;
         var minTime:Number = 1e+22;
         for(var face:Face = this.faceList; face != null; face = face.next)
         {
            normalX = face.normalX;
            normalY = face.normalY;
            normalZ = face.normalZ;
            dot = dx * normalX + dy * normalY + dz * normalZ;
            if(dot < 0)
            {
               offset = ox * normalX + oy * normalY + oz * normalZ - face.offset;
               if(offset > 0)
               {
                  time = -offset / dot;
                  if(point == null || time < minTime)
                  {
                     cx = ox + dx * time;
                     cy = oy + dy * time;
                     cz = oz + dz * time;
                     wrapper = face.wrapper;
                     while(true)
                     {
                        if(wrapper != null)
                        {
                           a = wrapper.vertex;
                           b = wrapper.next != null ? wrapper.next.vertex : face.wrapper.vertex;
                           abx = b.x - a.x;
                           aby = b.y - a.y;
                           abz = b.z - a.z;
                           acx = cx - a.x;
                           acy = cy - a.y;
                           acz = cz - a.z;
                           if((acz * aby - acy * abz) * normalX + (acx * abz - acz * abx) * normalY + (acy * abx - acx * aby) * normalZ >= 0)
                           {
                              continue;
                           }
                        }
                        if(wrapper == null)
                        {
                           if(time < minTime)
                           {
                              minTime = time;
                              if(point == null)
                              {
                                 point = new Vector3D();
                              }
                              point.x = cx;
                              point.y = cy;
                              point.z = cz;
                              nearFace = face;
                           }
                        }
                        break;
                        wrapper = wrapper.next;
                     }
                  }
               }
            }
         }
         if(point != null)
         {
            res = new RayIntersectionData();
            res.object = this;
            res.face = nearFace;
            res.point = point;
            res.uv = nearFace.getUV(point);
            res.time = minTime;
            return res;
         }
         return null;
      }
      
      override alternativa3d function checkIntersection(ox:Number, oy:Number, oz:Number, dx:Number, dy:Number, dz:Number, dw:Number, excludedObjects:Dictionary) : Boolean
      {
         var normalX:Number = NaN;
         var normalY:Number = NaN;
         var normalZ:Number = NaN;
         var dot:Number = NaN;
         var offset:Number = NaN;
         var time:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var cz:Number = NaN;
         var wrapper:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         for(var face:Face = this.faceList; face != null; )
         {
            normalX = face.normalX;
            normalY = face.normalY;
            normalZ = face.normalZ;
            dot = dx * normalX + dy * normalY + dz * normalZ;
            if(dot < 0)
            {
               offset = ox * normalX + oy * normalY + oz * normalZ - face.offset;
               if(offset > 0)
               {
                  time = -offset / dot;
                  if(time < dw)
                  {
                     cx = ox + dx * time;
                     cy = oy + dy * time;
                     cz = oz + dz * time;
                     wrapper = face.wrapper;
                     while(true)
                     {
                        if(wrapper != null)
                        {
                           a = wrapper.vertex;
                           b = wrapper.next != null ? wrapper.next.vertex : face.wrapper.vertex;
                           abx = b.x - a.x;
                           aby = b.y - a.y;
                           abz = b.z - a.z;
                           acx = cx - a.x;
                           acy = cy - a.y;
                           acz = cz - a.z;
                           if((acz * aby - acy * abz) * normalX + (acx * abz - acz * abx) * normalY + (acy * abx - acx * aby) * normalZ >= 0)
                           {
                              continue;
                           }
                        }
                        if(wrapper == null)
                        {
                           return true;
                        }
                        break;
                        wrapper = wrapper.next;
                     }
                  }
               }
            }
            face = face.next;
         }
         return false;
      }
      
      override alternativa3d function collectPlanes(center:Vector3D, a:Vector3D, b:Vector3D, c:Vector3D, d:Vector3D, collector:Vector.<Face>, excludedObjects:Dictionary = null) : void
      {
         var vertex:Vertex = null;
         var offset:Number = NaN;
         var wrapper:Wrapper = null;
         if(excludedObjects != null && Boolean(excludedObjects[this]))
         {
            return;
         }
         var sphere:Vector3D = calculateSphere(center,a,b,c,d);
         if(!boundIntersectSphere(sphere,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return;
         }
         if(transformId > 500000000)
         {
            transformId = 0;
            vertex = this.vertexList;
            while(vertex != null)
            {
               vertex.transformId = 0;
               vertex = vertex.next;
            }
         }
         ++transformId;
         for(var face:Face = this.faceList; face != null; face = face.next)
         {
            offset = sphere.x * face.normalX + sphere.y * face.normalY + sphere.z * face.normalZ - face.offset;
            if(offset < sphere.w && offset > -sphere.w)
            {
               for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
               {
                  vertex = wrapper.vertex;
                  if(vertex.transformId != transformId)
                  {
                     vertex.cameraX = ma * vertex.x + mb * vertex.y + mc * vertex.z + md;
                     vertex.cameraY = me * vertex.x + mf * vertex.y + mg * vertex.z + mh;
                     vertex.cameraZ = mi * vertex.x + mj * vertex.y + mk * vertex.z + ml;
                     vertex.transformId = transformId;
                  }
               }
               collector.push(face);
            }
         }
      }
      
      override public function clone() : Object3D
      {
         var res:Mesh = new Mesh();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         var vertex:Vertex = null;
         var lastVertex:Vertex = null;
         var lastFace:Face = null;
         var newVertex:Vertex = null;
         var newFace:Face = null;
         var lastWrapper:Wrapper = null;
         var wrapper:Wrapper = null;
         var newWrapper:Wrapper = null;
         super.clonePropertiesFrom(source);
         var src:Mesh = source as Mesh;
         this.clipping = src.clipping;
         this.sorting = src.sorting;
         this.threshold = src.threshold;
         for(vertex = src.vertexList; vertex != null; vertex = vertex.next)
         {
            newVertex = new Vertex();
            newVertex.x = vertex.x;
            newVertex.y = vertex.y;
            newVertex.z = vertex.z;
            newVertex.u = vertex.u;
            newVertex.v = vertex.v;
            newVertex.normalX = vertex.normalX;
            newVertex.normalY = vertex.normalY;
            newVertex.normalZ = vertex.normalZ;
            newVertex.offset = vertex.offset;
            newVertex.id = vertex.id;
            vertex.value = newVertex;
            if(lastVertex != null)
            {
               lastVertex.next = newVertex;
            }
            else
            {
               this.vertexList = newVertex;
            }
            lastVertex = newVertex;
         }
         for(var face:Face = src.faceList; face != null; face = face.next)
         {
            newFace = new Face();
            newFace.material = face.material;
            newFace.smoothingGroups = face.smoothingGroups;
            newFace.id = face.id;
            newFace.normalX = face.normalX;
            newFace.normalY = face.normalY;
            newFace.normalZ = face.normalZ;
            newFace.offset = face.offset;
            lastWrapper = null;
            for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               newWrapper = new Wrapper();
               newWrapper.vertex = wrapper.vertex.value;
               if(lastWrapper != null)
               {
                  lastWrapper.next = newWrapper;
               }
               else
               {
                  newFace.wrapper = newWrapper;
               }
               lastWrapper = newWrapper;
            }
            if(lastFace != null)
            {
               lastFace.next = newFace;
            }
            else
            {
               this.faceList = newFace;
            }
            lastFace = newFace;
         }
         for(vertex = src.vertexList; vertex != null; vertex = vertex.next)
         {
            vertex.value = null;
         }
      }
      
      override alternativa3d function draw(camera:Camera3D) : void
      {
         var list:Face = null;
         var vertex:Vertex = null;
         if(this.faceList == null)
         {
            return;
         }
         if(this.clipping == 0)
         {
            if(Boolean(culling & 1))
            {
               return;
            }
            culling = 0;
         }
         this.prepareResources();
         var needTransformConst:Boolean = false;
         if(useDepth = !camera.view.constrained && (camera.softTransparency && camera.softTransparencyStrength > 0 || camera.ssao && camera.ssaoStrength > 0 || camera.deferredLighting && camera.deferredLightingStrength > 0) && concatenatedAlpha >= depthMapAlphaThreshold)
         {
            camera.depthObjects[camera.depthCount] = this;
            ++camera.depthCount;
            needTransformConst = true;
         }
         if(concatenatedAlpha >= 1 && concatenatedBlendMode == "normal")
         {
            this.addOpaque(camera);
            if(this.opaqueLength > 0)
            {
               needTransformConst = true;
            }
            list = this.transparentList;
         }
         else
         {
            list = this.faceList;
         }
         if(needTransformConst)
         {
            transformConst[0] = ma;
            transformConst[1] = mb;
            transformConst[2] = mc;
            transformConst[3] = md;
            transformConst[4] = me;
            transformConst[5] = mf;
            transformConst[6] = mg;
            transformConst[7] = mh;
            transformConst[8] = mi;
            transformConst[9] = mj;
            transformConst[10] = mk;
            transformConst[11] = ml;
         }
         var debug:int = camera.debug ? camera.checkInDebug(this) : 0;
         if(Boolean(debug & Debug.BOUNDS))
         {
            Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
         }
         if(list == null)
         {
            return;
         }
         if(transformId > 500000000)
         {
            transformId = 0;
            vertex = this.vertexList;
            while(vertex != null)
            {
               vertex.transformId = 0;
               vertex = vertex.next;
            }
         }
         ++transformId;
         calculateInverseMatrix();
         list = this.prepareFaces(camera,list);
         if(list == null)
         {
            return;
         }
         if(culling > 0)
         {
            if(this.clipping == 1)
            {
               list = camera.cull(list,culling);
            }
            else
            {
               list = camera.clip(list,culling);
            }
            if(list == null)
            {
               return;
            }
         }
         if(list.processNext != null)
         {
            if(this.sorting == 1)
            {
               list = camera.sortByAverageZ(list);
            }
            else if(this.sorting == 2)
            {
               list = camera.sortByDynamicBSP(list,this.threshold);
            }
         }
         if(Boolean(debug & Debug.EDGES))
         {
            Debug.drawEdges(camera,list,16777215);
         }
         this.drawFaces(camera,list);
      }
      
      override alternativa3d function getVG(camera:Camera3D) : VG
      {
         var list:Face = null;
         var vertex:Vertex = null;
         if(this.faceList == null)
         {
            return null;
         }
         if(this.clipping == 0)
         {
            if(Boolean(culling & 1))
            {
               return null;
            }
            culling = 0;
         }
         this.prepareResources();
         var needTransformConst:Boolean = false;
         if(useDepth = !camera.view.constrained && (camera.softTransparency && camera.softTransparencyStrength > 0 || camera.ssao && camera.ssaoStrength > 0 || camera.deferredLighting && camera.deferredLightingStrength > 0) && concatenatedAlpha >= depthMapAlphaThreshold)
         {
            camera.depthObjects[camera.depthCount] = this;
            ++camera.depthCount;
            needTransformConst = true;
         }
         if(concatenatedAlpha >= 1 && concatenatedBlendMode == "normal")
         {
            this.addOpaque(camera);
            if(this.opaqueLength > 0)
            {
               needTransformConst = true;
            }
            list = this.transparentList;
         }
         else
         {
            list = this.faceList;
         }
         if(needTransformConst)
         {
            transformConst[0] = ma;
            transformConst[1] = mb;
            transformConst[2] = mc;
            transformConst[3] = md;
            transformConst[4] = me;
            transformConst[5] = mf;
            transformConst[6] = mg;
            transformConst[7] = mh;
            transformConst[8] = mi;
            transformConst[9] = mj;
            transformConst[10] = mk;
            transformConst[11] = ml;
         }
         var debug:int = camera.debug ? camera.checkInDebug(this) : 0;
         if(Boolean(debug & Debug.BOUNDS))
         {
            Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
         }
         if(list == null)
         {
            return null;
         }
         if(transformId > 500000000)
         {
            transformId = 0;
            vertex = this.vertexList;
            while(vertex != null)
            {
               vertex.transformId = 0;
               vertex = vertex.next;
            }
         }
         ++transformId;
         calculateInverseMatrix();
         list = this.prepareFaces(camera,list);
         if(list == null)
         {
            return null;
         }
         if(culling > 0)
         {
            if(this.clipping == 1)
            {
               list = camera.cull(list,culling);
            }
            else
            {
               list = camera.clip(list,culling);
            }
            if(list == null)
            {
               return null;
            }
         }
         return VG.create(this,list,this.sorting,debug,false);
      }
      
      alternativa3d function prepareResources() : void
      {
         var verts:Vector.<Number> = null;
         var vertsLen:int = 0;
         var vertsCount:int = 0;
         var vertex:Vertex = null;
         var a:int = 0;
         var b:int = 0;
         var c:int = 0;
         var face:Face = null;
         var next:Face = null;
         var last:Face = null;
         var wrapper:Wrapper = null;
         var map:Dictionary = null;
         var inds:Vector.<uint> = null;
         var indsLen:int = 0;
         var key:* = undefined;
         var list:Face = null;
         if(this.vertexBuffer == null)
         {
            verts = new Vector.<Number>();
            vertsLen = 0;
            vertsCount = 0;
            for(vertex = this.vertexList; vertex != null; vertex = vertex.next)
            {
               verts[vertsLen] = vertex.x;
               vertsLen++;
               verts[vertsLen] = vertex.y;
               vertsLen++;
               verts[vertsLen] = vertex.z;
               vertsLen++;
               verts[vertsLen] = vertex.u;
               vertsLen++;
               verts[vertsLen] = vertex.v;
               vertsLen++;
               verts[vertsLen] = vertex.normalX;
               vertsLen++;
               verts[vertsLen] = vertex.normalY;
               vertsLen++;
               verts[vertsLen] = vertex.normalZ;
               vertsLen++;
               vertex.index = vertsCount;
               vertsCount++;
            }
            if(vertsCount > 0)
            {
               this.vertexBuffer = new VertexBufferResource(verts,8);
            }
            map = new Dictionary();
            for(face = this.faceList; face != null; )
            {
               next = face.next;
               face.next = null;
               if(face.material != null && !face.material.transparent)
               {
                  face.next = map[face.material];
                  map[face.material] = face;
               }
               else
               {
                  if(last != null)
                  {
                     last.next = face;
                  }
                  else
                  {
                     this.transparentList = face;
                  }
                  last = face;
               }
               face = next;
            }
            this.faceList = this.transparentList;
            inds = new Vector.<uint>();
            indsLen = 0;
            for(key in map)
            {
               list = map[key];
               this.opaqueMaterials[this.opaqueLength] = list.material;
               this.opaqueBegins[this.opaqueLength] = this.numTriangles * 3;
               for(face = list; face != null; face = face.next)
               {
                  wrapper = face.wrapper;
                  a = wrapper.vertex.index;
                  wrapper = wrapper.next;
                  b = wrapper.vertex.index;
                  for(wrapper = wrapper.next; wrapper != null; wrapper = wrapper.next)
                  {
                     c = wrapper.vertex.index;
                     inds[indsLen] = a;
                     indsLen++;
                     inds[indsLen] = b;
                     indsLen++;
                     inds[indsLen] = c;
                     indsLen++;
                     b = c;
                     ++this.numTriangles;
                  }
                  if(face.next == null)
                  {
                     last = face;
                  }
               }
               this.opaqueNums[this.opaqueLength] = this.numTriangles - this.opaqueBegins[this.opaqueLength] / 3;
               ++this.opaqueLength;
               last.next = this.faceList;
               this.faceList = list;
            }
            this.numOpaqueTriangles = this.numTriangles;
            for(face = this.transparentList; face != null; face = face.next)
            {
               wrapper = face.wrapper;
               a = wrapper.vertex.index;
               wrapper = wrapper.next;
               b = wrapper.vertex.index;
               for(wrapper = wrapper.next; wrapper != null; wrapper = wrapper.next)
               {
                  c = wrapper.vertex.index;
                  inds[indsLen] = a;
                  indsLen++;
                  inds[indsLen] = b;
                  indsLen++;
                  inds[indsLen] = c;
                  indsLen++;
                  b = c;
                  ++this.numTriangles;
               }
            }
            if(indsLen > 0)
            {
               this.indexBuffer = new IndexBufferResource(inds);
            }
         }
      }
      
      alternativa3d function deleteResources() : void
      {
         if(this.vertexBuffer != null)
         {
            this.vertexBuffer.dispose();
            this.vertexBuffer = null;
            this.indexBuffer.dispose();
            this.indexBuffer = null;
            this.numTriangles = 0;
            this.opaqueMaterials.length = 0;
            this.opaqueBegins.length = 0;
            this.opaqueNums.length = 0;
            this.opaqueLength = 0;
            this.transparentList = null;
         }
      }
      
      alternativa3d function addOpaque(camera:Camera3D) : void
      {
         for(var i:int = 0; i < this.opaqueLength; i++)
         {
            camera.addOpaque(this.opaqueMaterials[i],this.vertexBuffer,this.indexBuffer,this.opaqueBegins[i],this.opaqueNums[i],this);
         }
      }
      
      alternativa3d function prepareFaces(camera:Camera3D, list:Face) : Face
      {
         var first:Face = null;
         var last:Face = null;
         var face:Face = null;
         var wrapper:Wrapper = null;
         var vertex:Vertex = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         for(face = list; face != null; face = face.next)
         {
            if(face.normalX * imd + face.normalY * imh + face.normalZ * iml > face.offset)
            {
               for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
               {
                  vertex = wrapper.vertex;
                  if(vertex.transformId != transformId)
                  {
                     x = vertex.x;
                     y = vertex.y;
                     z = vertex.z;
                     vertex.cameraX = ma * x + mb * y + mc * z + md;
                     vertex.cameraY = me * x + mf * y + mg * z + mh;
                     vertex.cameraZ = mi * x + mj * y + mk * z + ml;
                     vertex.transformId = transformId;
                     vertex.drawId = 0;
                  }
               }
               if(first != null)
               {
                  last.processNext = face;
               }
               else
               {
                  first = face;
               }
               last = face;
            }
         }
         if(last != null)
         {
            last.processNext = null;
         }
         return first;
      }
      
      alternativa3d function drawFaces(camera:Camera3D, list:Face) : void
      {
         var next:Face = null;
         var inverse:Face = null;
         var face:Face = null;
         for(face = list; face != null; face = next)
         {
            next = face.processNext;
            if(next == null || next.material != list.material)
            {
               face.processNext = null;
               if(list.material != null)
               {
                  list.processNegative = inverse;
                  inverse = list;
               }
               else
               {
                  while(list != null)
                  {
                     face = list.processNext;
                     list.processNext = null;
                     list = face;
                  }
               }
               list = next;
            }
         }
         for(list = inverse; list != null; list = next)
         {
            next = list.processNegative;
            list.processNegative = null;
            camera.addTransparent(list,this);
         }
      }
      
      override alternativa3d function updateBounds(bounds:Object3D, transformation:Object3D = null) : void
      {
         var vertex:Vertex = null;
         for(vertex = this.vertexList; vertex != null; vertex = vertex.next)
         {
            if(transformation != null)
            {
               vertex.cameraX = transformation.ma * vertex.x + transformation.mb * vertex.y + transformation.mc * vertex.z + transformation.md;
               vertex.cameraY = transformation.me * vertex.x + transformation.mf * vertex.y + transformation.mg * vertex.z + transformation.mh;
               vertex.cameraZ = transformation.mi * vertex.x + transformation.mj * vertex.y + transformation.mk * vertex.z + transformation.ml;
            }
            else
            {
               vertex.cameraX = vertex.x;
               vertex.cameraY = vertex.y;
               vertex.cameraZ = vertex.z;
            }
            if(vertex.cameraX < bounds.boundMinX)
            {
               bounds.boundMinX = vertex.cameraX;
            }
            if(vertex.cameraX > bounds.boundMaxX)
            {
               bounds.boundMaxX = vertex.cameraX;
            }
            if(vertex.cameraY < bounds.boundMinY)
            {
               bounds.boundMinY = vertex.cameraY;
            }
            if(vertex.cameraY > bounds.boundMaxY)
            {
               bounds.boundMaxY = vertex.cameraY;
            }
            if(vertex.cameraZ < bounds.boundMinZ)
            {
               bounds.boundMinZ = vertex.cameraZ;
            }
            if(vertex.cameraZ > bounds.boundMaxZ)
            {
               bounds.boundMaxZ = vertex.cameraZ;
            }
         }
      }
      
      override alternativa3d function split(a:Vector3D, b:Vector3D, c:Vector3D, threshold:Number) : Vector.<Object3D>
      {
         var res:Vector.<Object3D> = null;
         var plane:Vector3D = null;
         var offsetMin:Number = NaN;
         var offsetMax:Number = NaN;
         var v:Vertex = null;
         var nextVertex:Vertex = null;
         var faceList:Face = null;
         var negativeMesh:Mesh = null;
         var positiveMesh:Mesh = null;
         var negativeLast:Face = null;
         var positiveLast:Face = null;
         var face:Face = null;
         var next:Face = null;
         var w:Wrapper = null;
         var va:Vertex = null;
         var vb:Vertex = null;
         var vc:Vertex = null;
         var behind:Boolean = false;
         var infront:Boolean = false;
         var negative:Face = null;
         var positive:Face = null;
         var wNegative:Wrapper = null;
         var wPositive:Wrapper = null;
         var wNew:Wrapper = null;
         var t:Number = NaN;
         var v2:Vertex = null;
         this.deleteResources();
         res = new Vector.<Object3D>(2);
         plane = calculatePlane(a,b,c);
         offsetMin = plane.w - threshold;
         offsetMax = plane.w + threshold;
         for(v = this.vertexList; v != null; v = nextVertex)
         {
            nextVertex = v.next;
            v.next = null;
            v.offset = v.x * plane.x + v.y * plane.y + v.z * plane.z;
            if(v.offset >= offsetMin && v.offset <= offsetMax)
            {
               v.value = new Vertex();
               v.value.x = v.x;
               v.value.y = v.y;
               v.value.z = v.z;
               v.value.u = v.u;
               v.value.v = v.v;
               v.value.normalX = v.normalX;
               v.value.normalY = v.normalY;
               v.value.normalZ = v.normalZ;
            }
            v.transformId = 0;
         }
         this.vertexList = null;
         faceList = this.faceList;
         this.faceList = null;
         negativeMesh = this.clone() as Mesh;
         positiveMesh = this.clone() as Mesh;
         for(face = faceList; face != null; )
         {
            next = face.next;
            w = face.wrapper;
            va = w.vertex;
            w = w.next;
            vb = w.vertex;
            w = w.next;
            vc = w.vertex;
            behind = va.offset < offsetMin || vb.offset < offsetMin || vc.offset < offsetMin;
            infront = va.offset > offsetMax || vb.offset > offsetMax || vc.offset > offsetMax;
            for(w = w.next; w != null; )
            {
               v = w.vertex;
               if(v.offset < offsetMin)
               {
                  behind = true;
               }
               else if(v.offset > offsetMax)
               {
                  infront = true;
               }
               w = w.next;
            }
            if(!behind)
            {
               if(positiveLast != null)
               {
                  positiveLast.next = face;
               }
               else
               {
                  positiveMesh.faceList = face;
               }
               positiveLast = face;
            }
            else if(!infront)
            {
               if(negativeLast != null)
               {
                  negativeLast.next = face;
               }
               else
               {
                  negativeMesh.faceList = face;
               }
               negativeLast = face;
               for(w = face.wrapper; w != null; w = w.next)
               {
                  if(w.vertex.value != null)
                  {
                     w.vertex = w.vertex.value;
                  }
               }
            }
            else
            {
               negative = new Face();
               positive = new Face();
               wNegative = null;
               wPositive = null;
               for(w = face.wrapper.next.next; w.next != null; )
               {
                  w = w.next;
               }
               va = w.vertex;
               for(w = face.wrapper; w != null; w = w.next)
               {
                  vb = w.vertex;
                  if(va.offset < offsetMin && vb.offset > offsetMax || va.offset > offsetMax && vb.offset < offsetMin)
                  {
                     t = (plane.w - va.offset) / (vb.offset - va.offset);
                     v = new Vertex();
                     v.x = va.x + (vb.x - va.x) * t;
                     v.y = va.y + (vb.y - va.y) * t;
                     v.z = va.z + (vb.z - va.z) * t;
                     v.u = va.u + (vb.u - va.u) * t;
                     v.v = va.v + (vb.v - va.v) * t;
                     v.normalX = va.normalX + (vb.normalX - va.normalX) * t;
                     v.normalY = va.normalY + (vb.normalY - va.normalY) * t;
                     v.normalZ = va.normalZ + (vb.normalZ - va.normalZ) * t;
                     wNew = new Wrapper();
                     wNew.vertex = v;
                     if(wNegative != null)
                     {
                        wNegative.next = wNew;
                     }
                     else
                     {
                        negative.wrapper = wNew;
                     }
                     wNegative = wNew;
                     v2 = new Vertex();
                     v2.x = v.x;
                     v2.y = v.y;
                     v2.z = v.z;
                     v2.u = v.u;
                     v2.v = v.v;
                     v2.normalX = v.normalX;
                     v2.normalY = v.normalY;
                     v2.normalZ = v.normalZ;
                     wNew = new Wrapper();
                     wNew.vertex = v2;
                     if(wPositive != null)
                     {
                        wPositive.next = wNew;
                     }
                     else
                     {
                        positive.wrapper = wNew;
                     }
                     wPositive = wNew;
                  }
                  if(vb.offset < offsetMin)
                  {
                     wNew = w.create();
                     wNew.vertex = vb;
                     if(wNegative != null)
                     {
                        wNegative.next = wNew;
                     }
                     else
                     {
                        negative.wrapper = wNew;
                     }
                     wNegative = wNew;
                  }
                  else if(vb.offset > offsetMax)
                  {
                     wNew = w.create();
                     wNew.vertex = vb;
                     if(wPositive != null)
                     {
                        wPositive.next = wNew;
                     }
                     else
                     {
                        positive.wrapper = wNew;
                     }
                     wPositive = wNew;
                  }
                  else
                  {
                     wNew = w.create();
                     wNew.vertex = vb.value;
                     if(wNegative != null)
                     {
                        wNegative.next = wNew;
                     }
                     else
                     {
                        negative.wrapper = wNew;
                     }
                     wNegative = wNew;
                     wNew = w.create();
                     wNew.vertex = vb;
                     if(wPositive != null)
                     {
                        wPositive.next = wNew;
                     }
                     else
                     {
                        positive.wrapper = wNew;
                     }
                     wPositive = wNew;
                  }
                  va = vb;
               }
               negative.material = face.material;
               negative.calculateBestSequenceAndNormal();
               if(negativeLast != null)
               {
                  negativeLast.next = negative;
               }
               else
               {
                  negativeMesh.faceList = negative;
               }
               negativeLast = negative;
               positive.material = face.material;
               positive.calculateBestSequenceAndNormal();
               if(positiveLast != null)
               {
                  positiveLast.next = positive;
               }
               else
               {
                  positiveMesh.faceList = positive;
               }
               positiveLast = positive;
            }
            face = next;
         }
         if(negativeLast != null)
         {
            negativeLast.next = null;
            ++negativeMesh.transformId;
            negativeMesh.collectVertices();
            negativeMesh.calculateBounds();
            res[0] = negativeMesh;
         }
         if(positiveLast != null)
         {
            positiveLast.next = null;
            ++positiveMesh.transformId;
            positiveMesh.collectVertices();
            positiveMesh.calculateBounds();
            res[1] = positiveMesh;
         }
         return res;
      }
      
      private function collectVertices() : void
      {
         var face:Face = null;
         var w:Wrapper = null;
         var v:Vertex = null;
         for(face = this.faceList; face != null; face = face.next)
         {
            for(w = face.wrapper; w != null; w = w.next)
            {
               v = w.vertex;
               if(v.transformId != transformId)
               {
                  v.next = this.vertexList;
                  this.vertexList = v;
                  v.transformId = transformId;
                  v.value = null;
               }
            }
         }
      }
   }
}

