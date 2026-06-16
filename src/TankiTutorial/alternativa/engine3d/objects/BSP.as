package alternativa.engine3d.objects
{
   import §5e§.§-!$§;
   import §5e§.§`c§;
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
   
   use namespace alternativa3d;
   
   public class BSP extends Object3D
   {
      
      public var clipping:int = 2;
      
      public var threshold:Number = 0.01;
      
      public var splitAnalysis:Boolean = true;
      
      alternativa3d var vertexList:Vertex;
      
      alternativa3d var root:Node;
      
      alternativa3d var faces:Vector.<Face> = new Vector.<Face>();
      
      alternativa3d var vertexBuffer:§-!$§;
      
      alternativa3d var indexBuffer:§`c§;
      
      alternativa3d var numTriangles:int;
      
      public function BSP()
      {
         super();
      }
      
      public function createTree(sourceGeometry:Mesh, clearSource:Boolean = false) : void
      {
         this.destroyTree();
         if(!clearSource)
         {
            sourceGeometry = sourceGeometry.clone() as Mesh;
         }
         var faceList:Face = sourceGeometry.faceList;
         this.vertexList = sourceGeometry.vertexList;
         sourceGeometry.faceList = null;
         sourceGeometry.vertexList = null;
         for(var vertex:Vertex = this.vertexList; vertex != null; vertex = vertex.next)
         {
            vertex.transformId = 0;
            vertex.id = null;
         }
         var facesLength:int = 0;
         for(var face:Face = faceList; face != null; face = face.next)
         {
            face.calculateBestSequenceAndNormal();
            face.id = null;
            this.faces[facesLength] = face;
            facesLength++;
         }
         if(faceList != null)
         {
            this.root = this.createNode(faceList);
         }
         calculateBounds();
      }
      
      public function destroyTree() : void
      {
         this.deleteResources();
         this.vertexList = null;
         if(this.root != null)
         {
            this.destroyNode(this.root);
            this.root = null;
         }
         this.faces.length = 0;
      }
      
      public function setMaterialToAllFaces(material:Material) : void
      {
         var face:Face = null;
         this.deleteResources();
         var facesLength:int = int(this.faces.length);
         for(var i:int = 0; i < facesLength; i++)
         {
            face = this.faces[i];
            face.material = material;
         }
         if(this.root != null)
         {
            this.setMaterialToNode(this.root,material);
         }
      }
      
      override public function intersectRay(origin:Vector3D, direction:Vector3D, excludedObjects:Dictionary = null, camera:Camera3D = null) : RayIntersectionData
      {
         if(Boolean(excludedObjects != null) && Boolean(excludedObjects[this]) || this.root == null)
         {
            return null;
         }
         if(!boundIntersectRay(origin,direction,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return null;
         }
         return this.intersectRayNode(this.root,origin.x,origin.y,origin.z,direction.x,direction.y,direction.z);
      }
      
      private function intersectRayNode(node:Node, ox:Number, oy:Number, oz:Number, dx:Number, dy:Number, dz:Number) : RayIntersectionData
      {
         var data:RayIntersectionData = null;
         var dot:Number = NaN;
         var time:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var cz:Number = NaN;
         var face:Face = null;
         var wrapper:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var normalX:Number = node.normalX;
         var normalY:Number = node.normalY;
         var normalZ:Number = node.normalZ;
         var offset:Number = normalX * ox + normalY * oy + normalZ * oz - node.offset;
         if(offset > 0)
         {
            if(node.positive != null)
            {
               data = this.intersectRayNode(node.positive,ox,oy,oz,dx,dy,dz);
               if(data != null)
               {
                  return data;
               }
            }
            dot = dx * normalX + dy * normalY + dz * normalZ;
            if(dot < 0)
            {
               time = -offset / dot;
               cx = ox + dx * time;
               cy = oy + dy * time;
               cz = oz + dz * time;
               for(face = node.faceList; face != null; )
               {
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
                        data = new RayIntersectionData();
                        data.object = this;
                        data.face = face;
                        data.point = new Vector3D(cx,cy,cz);
                        data.uv = face.getUV(data.point);
                        data.time = time;
                        return data;
                     }
                     break;
                     wrapper = wrapper.next;
                  }
                  face = face.next;
               }
               if(node.negative != null)
               {
                  return this.intersectRayNode(node.negative,ox,oy,oz,dx,dy,dz);
               }
            }
         }
         else
         {
            if(node.negative != null)
            {
               data = this.intersectRayNode(node.negative,ox,oy,oz,dx,dy,dz);
               if(data != null)
               {
                  return data;
               }
            }
            if(node.positive != null && dx * normalX + dy * normalY + dz * normalZ > 0)
            {
               return this.intersectRayNode(node.positive,ox,oy,oz,dx,dy,dz);
            }
         }
         return null;
      }
      
      override alternativa3d function checkIntersection(ox:Number, oy:Number, oz:Number, dx:Number, dy:Number, dz:Number, dw:Number, excludedObjects:Dictionary) : Boolean
      {
         return this.root != null ? this.checkIntersectionNode(this.root,ox,oy,oz,dx,dy,dz,dw) : false;
      }
      
      private function checkIntersectionNode(node:Node, ox:Number, oy:Number, oz:Number, dx:Number, dy:Number, dz:Number, dw:Number) : Boolean
      {
         var dot:Number = NaN;
         var time:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var cz:Number = NaN;
         var face:Face = null;
         var wrapper:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var normalX:Number = node.normalX;
         var normalY:Number = node.normalY;
         var normalZ:Number = node.normalZ;
         var offset:Number = normalX * ox + normalY * oy + normalZ * oz - node.offset;
         if(offset > 0)
         {
            dot = dx * normalX + dy * normalY + dz * normalZ;
            if(dot < 0)
            {
               time = -offset / dot;
               if(time < dw)
               {
                  cx = ox + dx * time;
                  cy = oy + dy * time;
                  cz = oz + dz * time;
                  for(face = node.faceList; face != null; )
                  {
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
                     face = face.next;
                  }
                  if(node.negative != null && this.checkIntersectionNode(node.negative,ox,oy,oz,dx,dy,dz,dw))
                  {
                     return true;
                  }
               }
            }
            return node.positive != null && this.checkIntersectionNode(node.positive,ox,oy,oz,dx,dy,dz,dw);
         }
         if(node.negative != null && this.checkIntersectionNode(node.negative,ox,oy,oz,dx,dy,dz,dw))
         {
            return true;
         }
         if(node.positive != null)
         {
            dot = dx * normalX + dy * normalY + dz * normalZ;
            return dot > 0 && -offset / dot < dw && this.checkIntersectionNode(node.positive,ox,oy,oz,dx,dy,dz,dw);
         }
         return false;
      }
      
      override alternativa3d function collectPlanes(center:Vector3D, a:Vector3D, b:Vector3D, c:Vector3D, d:Vector3D, collector:Vector.<Face>, excludedObjects:Dictionary = null) : void
      {
         if(Boolean(excludedObjects != null) && Boolean(excludedObjects[this]) || this.root == null)
         {
            return;
         }
         var sphere:Vector3D = calculateSphere(center,a,b,c,d);
         if(!boundIntersectSphere(sphere,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return;
         }
         this.collectPlanesNode(this.root,sphere,collector);
      }
      
      private function collectPlanesNode(node:Node, sphere:Vector3D, collector:Vector.<Face>) : void
      {
         var face:Face = null;
         var wrapper:Wrapper = null;
         var vertex:Vertex = null;
         var offset:Number = node.normalX * sphere.x + node.normalY * sphere.y + node.normalZ * sphere.z - node.offset;
         if(offset >= sphere.w)
         {
            if(node.positive != null)
            {
               this.collectPlanesNode(node.positive,sphere,collector);
            }
         }
         else if(offset <= -sphere.w)
         {
            if(node.negative != null)
            {
               this.collectPlanesNode(node.negative,sphere,collector);
            }
         }
         else
         {
            for(face = node.faceList; face != null; )
            {
               for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
               {
                  vertex = wrapper.vertex;
                  vertex.cameraX = ma * vertex.x + mb * vertex.y + mc * vertex.z + md;
                  vertex.cameraY = me * vertex.x + mf * vertex.y + mg * vertex.z + mh;
                  vertex.cameraZ = mi * vertex.x + mj * vertex.y + mk * vertex.z + ml;
               }
               collector.push(face);
               face = face.next;
            }
            if(node.positive != null)
            {
               this.collectPlanesNode(node.positive,sphere,collector);
            }
            if(node.negative != null)
            {
               this.collectPlanesNode(node.negative,sphere,collector);
            }
         }
      }
      
      override public function clone() : Object3D
      {
         var res:BSP = new BSP();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         var vertex:Vertex = null;
         var lastVertex:Vertex = null;
         var newVertex:Vertex = null;
         var face:Face = null;
         var newFace:Face = null;
         var lastWrapper:Wrapper = null;
         var wrapper:Wrapper = null;
         var newWrapper:Wrapper = null;
         super.clonePropertiesFrom(source);
         var src:BSP = source as BSP;
         this.clipping = src.clipping;
         this.threshold = src.threshold;
         this.splitAnalysis = src.splitAnalysis;
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
         var map:Dictionary = new Dictionary();
         var facesLength:int = int(src.faces.length);
         for(var i:int = 0; i < facesLength; i++)
         {
            face = src.faces[i];
            newFace = new Face();
            newFace.material = face.material;
            newFace.smoothingGroups = face.smoothingGroups;
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
            this.faces[i] = newFace;
            map[face] = newFace;
         }
         if(src.root != null)
         {
            this.root = src.cloneNode(src.root,map);
         }
         for(vertex = src.vertexList; vertex != null; vertex = vertex.next)
         {
            vertex.value = null;
         }
      }
      
      private function cloneNode(node:Node, map:Dictionary) : Node
      {
         var last:Face = null;
         var newFace:Face = null;
         var lastWrapper:Wrapper = null;
         var wrapper:Wrapper = null;
         var newWrapper:Wrapper = null;
         var newNode:Node = new Node();
         for(var face:Face = node.faceList; face != null; face = face.next)
         {
            newFace = map[face];
            if(newFace == null)
            {
               newFace = new Face();
               newFace.material = face.material;
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
            }
            if(newNode.faceList != null)
            {
               last.next = newFace;
            }
            else
            {
               newNode.faceList = newFace;
            }
            last = newFace;
         }
         newNode.normalX = node.normalX;
         newNode.normalY = node.normalY;
         newNode.normalZ = node.normalZ;
         newNode.offset = node.offset;
         if(node.negative != null)
         {
            newNode.negative = this.cloneNode(node.negative,map);
         }
         if(node.positive != null)
         {
            newNode.positive = this.cloneNode(node.positive,map);
         }
         return newNode;
      }
      
      private function setMaterialToNode(node:Node, material:Material) : void
      {
         for(var face:Face = node.faceList; face != null; face = face.next)
         {
            face.material = material;
         }
         if(node.negative != null)
         {
            this.setMaterialToNode(node.negative,material);
         }
         if(node.positive != null)
         {
            this.setMaterialToNode(node.positive,material);
         }
      }
      
      override alternativa3d function draw(camera:Camera3D) : void
      {
         var list:Face = null;
         var next:Face = null;
         var inverse:Face = null;
         var face:Face = null;
         var vertex:Vertex = null;
         if(this.root == null)
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
         var debug:int = camera.debug ? camera.checkInDebug(this) : 0;
         var faceList:Face = this.faces[0];
         if(concatenatedAlpha >= 1 && concatenatedBlendMode == "normal" && faceList.material != null && !faceList.material.transparent)
         {
            camera.addOpaque(faceList.material,this.vertexBuffer,this.indexBuffer,0,this.numTriangles,this);
            needTransformConst = true;
            if(debug > 0)
            {
               if(Boolean(debug & Debug.EDGES))
               {
                  Debug.drawEdges(camera,null,16777215);
               }
               if(Boolean(debug & Debug.BOUNDS))
               {
                  Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
         }
         else
         {
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
            list = this.collectNode(this.root);
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
            if(debug > 0)
            {
               if(Boolean(debug & Debug.EDGES))
               {
                  Debug.drawEdges(camera,list,16777215);
               }
               if(Boolean(debug & Debug.BOUNDS))
               {
                  Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
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
      }
      
      override alternativa3d function getVG(camera:Camera3D) : VG
      {
         var tree:Face = null;
         var vertex:Vertex = null;
         if(this.root == null)
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
         var debug:int = camera.debug ? camera.checkInDebug(this) : 0;
         var faceList:Face = this.faces[0];
         if(concatenatedAlpha >= 1 && concatenatedBlendMode == "normal" && faceList.material != null && !faceList.material.transparent)
         {
            camera.addOpaque(faceList.material,this.vertexBuffer,this.indexBuffer,0,this.numTriangles,this);
            needTransformConst = true;
            if(debug > 0)
            {
               if(Boolean(debug & Debug.EDGES))
               {
                  Debug.drawEdges(camera,null,16777215);
               }
               if(Boolean(debug & Debug.BOUNDS))
               {
                  Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
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
         tree = this.prepareNode(this.root,culling,camera);
         if(tree != null)
         {
            return VG.create(this,tree,3,debug,false);
         }
         return null;
      }
      
      alternativa3d function prepareResources() : void
      {
         var verts:Vector.<Number> = null;
         var vertsLen:int = 0;
         var vertsCount:int = 0;
         var vertex:Vertex = null;
         var inds:Vector.<uint> = null;
         var indsLen:int = 0;
         var face:Face = null;
         var wrapper:Wrapper = null;
         var a:uint = 0;
         var b:uint = 0;
         var c:uint = 0;
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
            this.vertexBuffer = new §-!$§(verts,8);
            inds = new Vector.<uint>();
            indsLen = 0;
            this.numTriangles = 0;
            for each(face in this.faces)
            {
               wrapper = face.wrapper;
               a = uint(wrapper.vertex.index);
               wrapper = wrapper.next;
               b = uint(wrapper.vertex.index);
               for(wrapper = wrapper.next; wrapper != null; wrapper = wrapper.next)
               {
                  c = uint(wrapper.vertex.index);
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
            this.indexBuffer = new §`c§(inds);
         }
      }
      
      alternativa3d function deleteResources() : void
      {
         if(this.vertexBuffer != null)
         {
            this.vertexBuffer.§[P§();
            this.vertexBuffer = null;
            this.indexBuffer.§[P§();
            this.indexBuffer = null;
            this.numTriangles = 0;
         }
      }
      
      private function collectNode(node:Node, result:Face = null) : Face
      {
         var face:Face = null;
         var wrapper:Wrapper = null;
         var vertex:Vertex = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         if(node.normalX * imd + node.normalY * imh + node.normalZ * iml > node.offset)
         {
            if(node.positive != null)
            {
               result = this.collectNode(node.positive,result);
            }
            for(face = node.faceList; face != null; face = face.next)
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
               face.processNext = result;
               result = face;
            }
            if(node.negative != null)
            {
               result = this.collectNode(node.negative,result);
            }
         }
         else
         {
            if(node.negative != null)
            {
               result = this.collectNode(node.negative,result);
            }
            if(node.positive != null)
            {
               result = this.collectNode(node.positive,result);
            }
         }
         return result;
      }
      
      private function prepareNode(node:Node, culling:int, camera:Camera3D) : Face
      {
         var list:Face = null;
         var w:Wrapper = null;
         var face:Face = null;
         var v:Vertex = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
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
         var nl:Number = NaN;
         if(imd * node.normalX + imh * node.normalY + iml * node.normalZ > node.offset)
         {
            list = node.faceList;
            for(face = list; face != null; face = face.next)
            {
               for(w = face.wrapper; w != null; w = w.next)
               {
                  v = w.vertex;
                  if(v.transformId != transformId)
                  {
                     x = v.x;
                     y = v.y;
                     z = v.z;
                     v.cameraX = ma * x + mb * y + mc * z + md;
                     v.cameraY = me * x + mf * y + mg * z + mh;
                     v.cameraZ = mi * x + mj * y + mk * z + ml;
                     v.transformId = transformId;
                     v.drawId = 0;
                  }
               }
               face.processNext = face.next;
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
            }
         }
         var negative:Face = node.negative != null ? this.prepareNode(node.negative,culling,camera) : null;
         var positive:Face = node.positive != null ? this.prepareNode(node.positive,culling,camera) : null;
         if(list != null || negative != null && positive != null)
         {
            if(list == null)
            {
               list = node.faceList.create();
               camera.lastFace.next = list;
               camera.lastFace = list;
            }
            w = node.faceList.wrapper;
            a = w.vertex;
            w = w.next;
            b = w.vertex;
            w = w.next;
            c = w.vertex;
            if(a.transformId != transformId)
            {
               a.cameraX = ma * a.x + mb * a.y + mc * a.z + md;
               a.cameraY = me * a.x + mf * a.y + mg * a.z + mh;
               a.cameraZ = mi * a.x + mj * a.y + mk * a.z + ml;
               a.transformId = transformId;
               a.drawId = 0;
            }
            if(b.transformId != transformId)
            {
               b.cameraX = ma * b.x + mb * b.y + mc * b.z + md;
               b.cameraY = me * b.x + mf * b.y + mg * b.z + mh;
               b.cameraZ = mi * b.x + mj * b.y + mk * b.z + ml;
               b.transformId = transformId;
               b.drawId = 0;
            }
            if(c.transformId != transformId)
            {
               c.cameraX = ma * c.x + mb * c.y + mc * c.z + md;
               c.cameraY = me * c.x + mf * c.y + mg * c.z + mh;
               c.cameraZ = mi * c.x + mj * c.y + mk * c.z + ml;
               c.transformId = transformId;
               c.drawId = 0;
            }
            abx = b.cameraX - a.cameraX;
            aby = b.cameraY - a.cameraY;
            abz = b.cameraZ - a.cameraZ;
            acx = c.cameraX - a.cameraX;
            acy = c.cameraY - a.cameraY;
            acz = c.cameraZ - a.cameraZ;
            nx = acz * aby - acy * abz;
            ny = acx * abz - acz * abx;
            nz = acy * abx - acx * aby;
            nl = nx * nx + ny * ny + nz * nz;
            if(nl > 0)
            {
               nl = 1 / Math.sqrt(length);
               nx *= nl;
               ny *= nl;
               nz *= nl;
            }
            list.normalX = nx;
            list.normalY = ny;
            list.normalZ = nz;
            list.offset = a.cameraX * nx + a.cameraY * ny + a.cameraZ * nz;
            list.processNegative = negative;
            list.processPositive = positive;
         }
         else
         {
            list = negative != null ? negative : positive;
         }
         return list;
      }
      
      override alternativa3d function updateBounds(bounds:Object3D, transformation:Object3D = null) : void
      {
         for(var vertex:Vertex = this.vertexList; vertex != null; vertex = vertex.next)
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
         var v:Vertex = null;
         var nextVertex:Vertex = null;
         var negativeFirst:Face = null;
         var negativeLast:Face = null;
         var positiveFirst:Face = null;
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
         var res:Vector.<Object3D> = new Vector.<Object3D>(2);
         var plane:Vector3D = calculatePlane(a,b,c);
         var offsetMin:Number = plane.w - threshold;
         var offsetMax:Number = plane.w + threshold;
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
         if(this.root != null)
         {
            this.destroyNode(this.root);
            this.root = null;
         }
         var faces:Vector.<Face> = this.faces;
         this.faces = new Vector.<Face>();
         var negativeBSP:BSP = this.clone() as BSP;
         var positiveBSP:BSP = this.clone() as BSP;
         var negativeFacesLength:int = 0;
         var positiveFacesLength:int = 0;
         var facesLength:int = int(faces.length);
         for(var i:int = 0; i < facesLength; )
         {
            face = faces[i];
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
                  positiveFirst = face;
               }
               positiveLast = face;
               positiveBSP.faces[positiveFacesLength] = face;
               positiveFacesLength++;
            }
            else if(!infront)
            {
               if(negativeLast != null)
               {
                  negativeLast.next = face;
               }
               else
               {
                  negativeFirst = face;
               }
               negativeLast = face;
               negativeBSP.faces[negativeFacesLength] = face;
               negativeFacesLength++;
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
                  negativeFirst = negative;
               }
               negativeLast = negative;
               negativeBSP.faces[negativeFacesLength] = negative;
               negativeFacesLength++;
               positive.material = face.material;
               positive.calculateBestSequenceAndNormal();
               if(positiveLast != null)
               {
                  positiveLast.next = positive;
               }
               else
               {
                  positiveFirst = positive;
               }
               positiveLast = positive;
               positiveBSP.faces[positiveFacesLength] = positive;
               positiveFacesLength++;
            }
            i++;
         }
         if(negativeLast != null)
         {
            negativeLast.next = null;
            ++negativeBSP.transformId;
            negativeBSP.collectVertices();
            negativeBSP.root = negativeBSP.createNode(negativeFirst);
            negativeBSP.calculateBounds();
            res[0] = negativeBSP;
         }
         if(positiveLast != null)
         {
            positiveLast.next = null;
            ++positiveBSP.transformId;
            positiveBSP.collectVertices();
            positiveBSP.root = positiveBSP.createNode(positiveFirst);
            positiveBSP.calculateBounds();
            res[1] = positiveBSP;
         }
         return res;
      }
      
      private function collectVertices() : void
      {
         var face:Face = null;
         var w:Wrapper = null;
         var v:Vertex = null;
         var facesLength:int = int(this.faces.length);
         for(var i:int = 0; i < facesLength; i++)
         {
            face = this.faces[i];
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
      
      private function createNode(list:Face) : Node
      {
         var w:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var v:Vertex = null;
         var behind:Boolean = false;
         var infront:Boolean = false;
         var ao:Number = NaN;
         var bo:Number = NaN;
         var co:Number = NaN;
         var vo:Number = NaN;
         var normalX:Number = NaN;
         var normalY:Number = NaN;
         var normalZ:Number = NaN;
         var offset:Number = NaN;
         var offsetMin:Number = NaN;
         var offsetMax:Number = NaN;
         var negativeFirst:Face = null;
         var negativeLast:Face = null;
         var positiveFirst:Face = null;
         var positiveLast:Face = null;
         var bestSplits:int = 0;
         var face:Face = null;
         var splits:int = 0;
         var f:Face = null;
         var next:Face = null;
         var negative:Face = null;
         var positive:Face = null;
         var wNegative:Wrapper = null;
         var wPositive:Wrapper = null;
         var wNew:Wrapper = null;
         var t:Number = NaN;
         var node:Node = new Node();
         var splitter:Face = list;
         if(this.splitAnalysis && list.next != null)
         {
            bestSplits = 2147483647;
            loop0:
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
               loop1:
               while(true)
               {
                  if(f != null)
                  {
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
                              continue loop1;
                           }
                           splits++;
                           if(splits < bestSplits)
                           {
                              continue loop1;
                           }
                           w = w.next;
                        }
                     }
                     continue;
                  }
                  if(splits < bestSplits)
                  {
                     splitter = face;
                     bestSplits = splits;
                     if(bestSplits == 0)
                     {
                        break loop0;
                     }
                  }
                  break;
                  f = f.next;
               }
               face = face.next;
            }
         }
         var splitterLast:Face = splitter;
         var splitterNext:Face = splitter.next;
         normalX = splitter.normalX;
         normalY = splitter.normalY;
         normalZ = splitter.normalZ;
         offset = splitter.offset;
         offsetMin = offset - this.threshold;
         for(offsetMax = offset + this.threshold; list != null; )
         {
            if(list != splitter)
            {
               next = list.next;
               w = list.wrapper;
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
               for(infront = ao > offsetMax || bo > offsetMax || co > offsetMax; w != null; )
               {
                  v = w.vertex;
                  vo = v.x * normalX + v.y * normalY + v.z * normalZ;
                  if(vo < offsetMin)
                  {
                     behind = true;
                  }
                  else if(vo > offsetMax)
                  {
                     infront = true;
                  }
                  v.offset = vo;
                  w = w.next;
               }
               if(!behind)
               {
                  if(!infront)
                  {
                     if(list.normalX * normalX + list.normalY * normalY + list.normalZ * normalZ > 0)
                     {
                        splitterLast.next = list;
                        splitterLast = list;
                     }
                     else
                     {
                        if(negativeFirst != null)
                        {
                           negativeLast.next = list;
                        }
                        else
                        {
                           negativeFirst = list;
                        }
                        negativeLast = list;
                     }
                  }
                  else
                  {
                     if(positiveFirst != null)
                     {
                        positiveLast.next = list;
                     }
                     else
                     {
                        positiveFirst = list;
                     }
                     positiveLast = list;
                  }
               }
               else if(!infront)
               {
                  if(negativeFirst != null)
                  {
                     negativeLast.next = list;
                  }
                  else
                  {
                     negativeFirst = list;
                  }
                  negativeLast = list;
               }
               else
               {
                  a.offset = ao;
                  b.offset = bo;
                  c.offset = co;
                  negative = new Face();
                  positive = new Face();
                  wNegative = null;
                  wPositive = null;
                  for(w = list.wrapper.next.next; w.next != null; )
                  {
                     w = w.next;
                  }
                  a = w.vertex;
                  ao = a.offset;
                  for(w = list.wrapper; w != null; w = w.next)
                  {
                     b = w.vertex;
                     bo = b.offset;
                     if(ao < offsetMin && bo > offsetMax || ao > offsetMax && bo < offsetMin)
                     {
                        t = (offset - ao) / (bo - ao);
                        v = new Vertex();
                        v.next = this.vertexList;
                        this.vertexList = v;
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.u = a.u + (b.u - a.u) * t;
                        v.v = a.v + (b.v - a.v) * t;
                        v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                        v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                        v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
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
                        wNew = new Wrapper();
                        wNew.vertex = v;
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
                     if(bo <= offsetMax)
                     {
                        wNew = new Wrapper();
                        wNew.vertex = b;
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
                     if(bo >= offsetMin)
                     {
                        wNew = new Wrapper();
                        wNew.vertex = b;
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
                     a = b;
                     ao = bo;
                  }
                  negative.material = list.material;
                  negative.smoothingGroups = list.smoothingGroups;
                  negative.calculateBestSequenceAndNormal();
                  if(negativeFirst != null)
                  {
                     negativeLast.next = negative;
                  }
                  else
                  {
                     negativeFirst = negative;
                  }
                  negativeLast = negative;
                  positive.material = list.material;
                  positive.smoothingGroups = list.smoothingGroups;
                  positive.calculateBestSequenceAndNormal();
                  if(positiveFirst != null)
                  {
                     positiveLast.next = positive;
                  }
                  else
                  {
                     positiveFirst = positive;
                  }
                  positiveLast = positive;
               }
               list = next;
            }
            else
            {
               list = splitterNext;
            }
         }
         if(negativeFirst != null)
         {
            negativeLast.next = null;
            node.negative = this.createNode(negativeFirst);
         }
         splitterLast.next = null;
         node.faceList = splitter;
         node.normalX = normalX;
         node.normalY = normalY;
         node.normalZ = normalZ;
         node.offset = offset;
         if(positiveFirst != null)
         {
            positiveLast.next = null;
            node.positive = this.createNode(positiveFirst);
         }
         return node;
      }
      
      private function destroyNode(node:Node) : void
      {
         var next:Face = null;
         if(node.negative != null)
         {
            this.destroyNode(node.negative);
            node.negative = null;
         }
         if(node.positive != null)
         {
            this.destroyNode(node.positive);
            node.positive = null;
         }
         for(var face:Face = node.faceList; face != null; face = next)
         {
            next = face.next;
            face.next = null;
         }
      }
   }
}

import alternativa.engine3d.core.Face;

class Node
{
   
   public var negative:Node;
   
   public var positive:Node;
   
   public var faceList:Face;
   
   public var normalX:Number;
   
   public var normalY:Number;
   
   public var normalZ:Number;
   
   public var offset:Number;
   
   public function Node()
   {
      super();
   }
}
