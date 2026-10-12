package alternativa.engine3d.containers
{
   import alternativa.gfx.core.VertexBufferResource;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.RayIntersectionData;
   import alternativa.engine3d.core.ShadowAtlas;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Occluder;
   import alternativa.engine3d.objects.Sprite3D;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class KDContainer extends ConflictContainer
   {
      
      private static const treeSphere:Vector3D = new Vector3D();
      
      private static const splitCoordsX:Vector.<Number> = new Vector.<Number>();
      
      private static const splitCoordsY:Vector.<Number> = new Vector.<Number>();
      
      private static const splitCoordsZ:Vector.<Number> = new Vector.<Number>();
      
      public var debugAlphaFade:Number = 0.8;
      
      public var ignoreChildrenInCollider:Boolean = false;
      
      alternativa3d var root:KDNode;
      
      private var nearPlaneX:Number;
      
      private var nearPlaneY:Number;
      
      private var nearPlaneZ:Number;
      
      private var nearPlaneOffset:Number;
      
      private var farPlaneX:Number;
      
      private var farPlaneY:Number;
      
      private var farPlaneZ:Number;
      
      private var farPlaneOffset:Number;
      
      private var leftPlaneX:Number;
      
      private var leftPlaneY:Number;
      
      private var leftPlaneZ:Number;
      
      private var leftPlaneOffset:Number;
      
      private var rightPlaneX:Number;
      
      private var rightPlaneY:Number;
      
      private var rightPlaneZ:Number;
      
      private var rightPlaneOffset:Number;
      
      private var topPlaneX:Number;
      
      private var topPlaneY:Number;
      
      private var topPlaneZ:Number;
      
      private var topPlaneOffset:Number;
      
      private var bottomPlaneX:Number;
      
      private var bottomPlaneY:Number;
      
      private var bottomPlaneZ:Number;
      
      private var bottomPlaneOffset:Number;
      
      private var occluders:Vector.<Vertex> = new Vector.<Vertex>();
      
      private var numOccluders:int;
      
      private var materials:Dictionary = new Dictionary();
      
      private var opaqueList:Object3D;
      
      private var transparent:Vector.<Object3D> = new Vector.<Object3D>();
      
      private var transparentLength:int = 0;
      
      private var receiversVertexBuffers:Vector.<VertexBufferResource> = new Vector.<VertexBufferResource>();
      
      private var receiversIndexBuffers:Vector.<IndexBufferResource> = new Vector.<IndexBufferResource>();
      
      private var context3DIds:Vector.<int> = Vector.<int>([-1,-1,-1,-1]);
      
      public var batched:Boolean = true;
      
      public function KDContainer()
      {
         super();
      }
      
      public function createTree(staticObjects:Vector.<Object3D>, staticOccluders:Vector.<Occluder> = null) : void
      {
         var i:int = 0;
         var object:Object3D = null;
         var bound:Object3D = null;
         var objectList:Object3D = null;
         var objectBoundList:Object3D = null;
         var occluderList:Object3D = null;
         var occluderBoundList:Object3D = null;
         var material:Material = null;
         var minX:Number = NaN;
         var minY:Number = NaN;
         var minZ:Number = NaN;
         var maxX:Number = NaN;
         var maxY:Number = NaN;
         var maxZ:Number = NaN;
         var vx:Number = NaN;
         var vy:Number = NaN;
         var vz:Number = NaN;
         var vnx:Number = NaN;
         var vny:Number = NaN;
         var vnz:Number = NaN;
         var vertex:Vertex = null;
         var lastFace:Face = null;
         var lastVertex:Vertex = null;
         var composedMesh:Mesh = null;
         var mesh:Mesh = null;
         var bsp:BSP = null;
         var vertices:Vector.<Vector.<Number>> = null;
         var indices:Vector.<Vector.<uint>> = null;
         this.destroyTree();
         var staticObjectsLength:int = int(staticObjects.length);
         var staticOccludersLength:int = staticOccluders != null ? int(staticOccluders.length) : 0;
         var map:Dictionary = new Dictionary();
         for(i = 0; i < staticObjectsLength; )
         {
            object = staticObjects[i];
            material = object is Mesh ? (object as Mesh).faceList.material : (object is BSP ? (object as BSP).faces[0].material : null);
            if(material != null)
            {
               this.materials[material] = true;
               if(material.transparent)
               {
                  material.name = "decal";
                  this.transparent[this.transparentLength] = object;
                  ++this.transparentLength;
               }
               else
               {
                  composedMesh = map[material];
                  if(composedMesh == null)
                  {
                     composedMesh = new Mesh();
                     map[material] = composedMesh;
                     composedMesh.next = this.opaqueList;
                     this.opaqueList = composedMesh;
                     composedMesh.setParent(this);
                  }
                  object = object.clone();
                  object.composeMatrix();
                  if(object is Mesh)
                  {
                     mesh = object as Mesh;
                     if(mesh.faceList != null)
                     {
                        for(vertex = mesh.vertexList; vertex != null; vertex = vertex.next)
                        {
                           vx = vertex.x;
                           vy = vertex.y;
                           vz = vertex.z;
                           vertex.x = object.ma * vx + object.mb * vy + object.mc * vz + object.md;
                           vertex.y = object.me * vx + object.mf * vy + object.mg * vz + object.mh;
                           vertex.z = object.mi * vx + object.mj * vy + object.mk * vz + object.ml;
                           vnx = vertex.normalX;
                           vny = vertex.normalY;
                           vnz = vertex.normalZ;
                           vertex.normalX = object.ma * vnx + object.mb * vny + object.mc * vnz;
                           vertex.normalY = object.me * vnx + object.mf * vny + object.mg * vnz;
                           vertex.normalZ = object.mi * vnx + object.mj * vny + object.mk * vnz;
                           vertex.transformId = 0;
                           if(vertex.next == null)
                           {
                              lastVertex = vertex;
                           }
                        }
                        lastVertex.next = composedMesh.vertexList;
                        composedMesh.vertexList = mesh.vertexList;
                        mesh.vertexList = null;
                        for(lastFace = mesh.faceList; lastFace.next != null; )
                        {
                           lastFace = lastFace.next;
                        }
                        lastFace.next = composedMesh.faceList;
                        composedMesh.faceList = mesh.faceList;
                        mesh.faceList = null;
                     }
                  }
                  else if(object is BSP)
                  {
                     bsp = object as BSP;
                     if(bsp.root != null)
                     {
                        for(vertex = bsp.vertexList; vertex != null; vertex = vertex.next)
                        {
                           vx = vertex.x;
                           vy = vertex.y;
                           vz = vertex.z;
                           vertex.x = object.ma * vx + object.mb * vy + object.mc * vz + object.md;
                           vertex.y = object.me * vx + object.mf * vy + object.mg * vz + object.mh;
                           vertex.z = object.mi * vx + object.mj * vy + object.mk * vz + object.ml;
                           vnx = vertex.normalX;
                           vny = vertex.normalY;
                           vnz = vertex.normalZ;
                           vertex.normalX = object.ma * vnx + object.mb * vny + object.mc * vnz;
                           vertex.normalY = object.me * vnx + object.mf * vny + object.mg * vnz;
                           vertex.normalZ = object.mi * vnx + object.mj * vny + object.mk * vnz;
                           vertex.transformId = 0;
                           if(vertex.next == null)
                           {
                              lastVertex = vertex;
                           }
                        }
                        lastVertex.next = composedMesh.vertexList;
                        composedMesh.vertexList = bsp.vertexList;
                        bsp.vertexList = null;
                        for each(lastFace in bsp.faces)
                        {
                           lastFace.next = composedMesh.faceList;
                           composedMesh.faceList = lastFace;
                        }
                        bsp.faces.length = 0;
                        bsp.root = null;
                     }
                  }
               }
            }
            i++;
         }
         for each(composedMesh in map)
         {
            composedMesh.calculateFacesNormals(true);
            composedMesh.calculateBounds();
         }
         minX = 1e+22;
         minY = 1e+22;
         minZ = 1e+22;
         maxX = -1e+22;
         maxY = -1e+22;
         maxZ = -1e+22;
         for(i = 0; i < staticObjectsLength; i++)
         {
            object = staticObjects[i];
            bound = this.createObjectBounds(object);
            if(bound.boundMinX <= bound.boundMaxX)
            {
               if(object._parent != null)
               {
                  object._parent.removeChild(object);
               }
               object.setParent(this);
               object.next = objectList;
               objectList = object;
               bound.next = objectBoundList;
               objectBoundList = bound;
               if(bound.boundMinX < minX)
               {
                  minX = bound.boundMinX;
               }
               if(bound.boundMaxX > maxX)
               {
                  maxX = bound.boundMaxX;
               }
               if(bound.boundMinY < minY)
               {
                  minY = bound.boundMinY;
               }
               if(bound.boundMaxY > maxY)
               {
                  maxY = bound.boundMaxY;
               }
               if(bound.boundMinZ < minZ)
               {
                  minZ = bound.boundMinZ;
               }
               if(bound.boundMaxZ > maxZ)
               {
                  maxZ = bound.boundMaxZ;
               }
            }
         }
         for(i = 0; i < staticOccludersLength; )
         {
            object = staticOccluders[i];
            bound = this.createObjectBounds(object);
            if(bound.boundMinX <= bound.boundMaxX)
            {
               if(bound.boundMinX < minX || bound.boundMaxX > maxX || bound.boundMinY < minY || bound.boundMaxY > maxY || bound.boundMinZ < minZ || bound.boundMaxZ > maxZ)
               {
                  trace("Incorrect occluder size or position");
               }
               else
               {
                  if(object._parent != null)
                  {
                     object._parent.removeChild(object);
                  }
                  object.setParent(this);
                  object.next = occluderList;
                  occluderList = object;
                  bound.next = occluderBoundList;
                  occluderBoundList = bound;
               }
            }
            i++;
         }
         if(objectList != null)
         {
            this.root = this.createNode(objectList,objectBoundList,occluderList,occluderBoundList,minX,minY,minZ,maxX,maxY,maxZ);
            vertices = new Vector.<Vector.<Number>>();
            indices = new Vector.<Vector.<uint>>();
            vertices[0] = new Vector.<Number>();
            indices[0] = new Vector.<uint>();
            this.root.createReceivers(vertices,indices);
            for(i = 0; i < vertices.length; i++)
            {
               this.receiversVertexBuffers[i] = new VertexBufferResource(vertices[i],3);
               this.receiversIndexBuffers[i] = new IndexBufferResource(indices[i]);
            }
         }
      }
      
      public function destroyTree() : void
      {
         var i:int = 0;
         var key:* = undefined;
         var object:Object3D = null;
         var mesh:Mesh = null;
         var bsp:BSP = null;
         var textureMaterial:TextureMaterial = null;
         for(key in this.materials)
         {
            textureMaterial = key as TextureMaterial;
            if(textureMaterial._texture != null)
            {
               textureMaterial.textureResource.reset();
            }
            if(textureMaterial._textureATF != null)
            {
               textureMaterial.textureATFResource.reset();
            }
            if(textureMaterial._textureATFAlpha != null)
            {
               textureMaterial.textureATFAlphaResource.reset();
            }
         }
         for(object = this.opaqueList; object != null; )
         {
            if(object is Mesh)
            {
               mesh = object as Mesh;
               if(mesh.vertexBuffer != null)
               {
                  mesh.vertexBuffer.reset();
               }
               if(mesh.indexBuffer != null)
               {
                  mesh.indexBuffer.reset();
               }
            }
            else if(object is BSP)
            {
               bsp = object as BSP;
               if(bsp.vertexBuffer != null)
               {
                  bsp.vertexBuffer.reset();
               }
               if(bsp.indexBuffer != null)
               {
                  bsp.indexBuffer.reset();
               }
            }
            object = object.next;
         }
         for(i = 0; i < this.transparentLength; )
         {
            object = this.transparent[i];
            if(object is Mesh)
            {
               mesh = object as Mesh;
               if(mesh.vertexBuffer != null)
               {
                  mesh.vertexBuffer.reset();
               }
               if(mesh.indexBuffer != null)
               {
                  mesh.indexBuffer.reset();
               }
            }
            else if(object is BSP)
            {
               bsp = object as BSP;
               if(bsp.vertexBuffer != null)
               {
                  bsp.vertexBuffer.reset();
               }
               if(bsp.indexBuffer != null)
               {
                  bsp.indexBuffer.reset();
               }
            }
            i++;
         }
         this.materials = new Dictionary();
         this.opaqueList = null;
         this.transparent.length = 0;
         this.transparentLength = 0;
         if(this.root != null)
         {
            this.destroyNode(this.root);
            this.root = null;
         }
         for(i = 0; i < this.receiversVertexBuffers.length; i++)
         {
            VertexBufferResource(this.receiversVertexBuffers[i]).dispose();
            IndexBufferResource(this.receiversIndexBuffers[i]).dispose();
         }
         this.receiversVertexBuffers.length = 0;
         this.receiversIndexBuffers.length = 0;
         this.context3DIds = Vector.<int>([-1,-1,-1,-1]);
      }
      
      override public function intersectRay(origin:Vector3D, direction:Vector3D, excludedObjects:Dictionary = null, camera:Camera3D = null) : RayIntersectionData
      {
         var data:RayIntersectionData = null;
         if(excludedObjects != null && Boolean(excludedObjects[this]))
         {
            return null;
         }
         if(!boundIntersectRay(origin,direction,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return null;
         }
         var res:RayIntersectionData = super.intersectRay(origin,direction,excludedObjects,camera);
         if(this.root != null && boundIntersectRay(origin,direction,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ))
         {
            data = this.intersectRayNode(this.root,origin,direction,excludedObjects,camera);
            if(data != null && (res == null || data.time < res.time))
            {
               res = data;
            }
         }
         return res;
      }
      
      private function intersectRayNode(node:KDNode, origin:Vector3D, direction:Vector3D, excludedObjects:Dictionary, camera:Camera3D) : RayIntersectionData
      {
         var data:RayIntersectionData = null;
         var dot:Number = NaN;
         var child:Object3D = null;
         var bound:Object3D = null;
         var childOrigin:Vector3D = null;
         var childDirection:Vector3D = null;
         var axisX:Boolean = false;
         var axisY:Boolean = false;
         var offset:Number = NaN;
         var minTime:Number = NaN;
         var res:RayIntersectionData = null;
         if(node.negative != null)
         {
            axisX = node.axis == 0;
            axisY = node.axis == 1;
            offset = (axisX ? origin.x : (axisY ? origin.y : origin.z)) - node.coord;
            if(offset > 0)
            {
               if(boundIntersectRay(origin,direction,node.positive.boundMinX,node.positive.boundMinY,node.positive.boundMinZ,node.positive.boundMaxX,node.positive.boundMaxY,node.positive.boundMaxZ))
               {
                  data = this.intersectRayNode(node.positive,origin,direction,excludedObjects,camera);
                  if(data != null)
                  {
                     return data;
                  }
               }
               dot = axisX ? direction.x : (axisY ? direction.y : direction.z);
               if(dot < 0)
               {
                  child = node.objectList;
                  bound = node.objectBoundList;
                  while(child != null)
                  {
                     if(boundIntersectRay(origin,direction,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ))
                     {
                        child.composeMatrix();
                        child.invertMatrix();
                        if(childOrigin == null)
                        {
                           childOrigin = new Vector3D();
                           childDirection = new Vector3D();
                        }
                        childOrigin.x = child.ma * origin.x + child.mb * origin.y + child.mc * origin.z + child.md;
                        childOrigin.y = child.me * origin.x + child.mf * origin.y + child.mg * origin.z + child.mh;
                        childOrigin.z = child.mi * origin.x + child.mj * origin.y + child.mk * origin.z + child.ml;
                        childDirection.x = child.ma * direction.x + child.mb * direction.y + child.mc * direction.z;
                        childDirection.y = child.me * direction.x + child.mf * direction.y + child.mg * direction.z;
                        childDirection.z = child.mi * direction.x + child.mj * direction.y + child.mk * direction.z;
                        data = child.intersectRay(childOrigin,childDirection,excludedObjects,camera);
                        if(data != null)
                        {
                           return data;
                        }
                     }
                     child = child.next;
                     bound = bound.next;
                  }
                  if(boundIntersectRay(origin,direction,node.negative.boundMinX,node.negative.boundMinY,node.negative.boundMinZ,node.negative.boundMaxX,node.negative.boundMaxY,node.negative.boundMaxZ))
                  {
                     return this.intersectRayNode(node.negative,origin,direction,excludedObjects,camera);
                  }
               }
            }
            else
            {
               if(boundIntersectRay(origin,direction,node.negative.boundMinX,node.negative.boundMinY,node.negative.boundMinZ,node.negative.boundMaxX,node.negative.boundMaxY,node.negative.boundMaxZ))
               {
                  data = this.intersectRayNode(node.negative,origin,direction,excludedObjects,camera);
                  if(data != null)
                  {
                     return data;
                  }
               }
               dot = axisX ? direction.x : (axisY ? direction.y : direction.z);
               if(dot > 0)
               {
                  child = node.objectList;
                  bound = node.objectBoundList;
                  while(child != null)
                  {
                     if(boundIntersectRay(origin,direction,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ))
                     {
                        child.composeMatrix();
                        child.invertMatrix();
                        if(childOrigin == null)
                        {
                           childOrigin = new Vector3D();
                           childDirection = new Vector3D();
                        }
                        childOrigin.x = child.ma * origin.x + child.mb * origin.y + child.mc * origin.z + child.md;
                        childOrigin.y = child.me * origin.x + child.mf * origin.y + child.mg * origin.z + child.mh;
                        childOrigin.z = child.mi * origin.x + child.mj * origin.y + child.mk * origin.z + child.ml;
                        childDirection.x = child.ma * direction.x + child.mb * direction.y + child.mc * direction.z;
                        childDirection.y = child.me * direction.x + child.mf * direction.y + child.mg * direction.z;
                        childDirection.z = child.mi * direction.x + child.mj * direction.y + child.mk * direction.z;
                        data = child.intersectRay(childOrigin,childDirection,excludedObjects,camera);
                        if(data != null)
                        {
                           return data;
                        }
                     }
                     child = child.next;
                     bound = bound.next;
                  }
                  if(boundIntersectRay(origin,direction,node.positive.boundMinX,node.positive.boundMinY,node.positive.boundMinZ,node.positive.boundMaxX,node.positive.boundMaxY,node.positive.boundMaxZ))
                  {
                     return this.intersectRayNode(node.positive,origin,direction,excludedObjects,camera);
                  }
               }
            }
            return null;
         }
         minTime = 1e+22;
         for(child = node.objectList; child != null; child = child.next)
         {
            child.composeMatrix();
            child.invertMatrix();
            if(childOrigin == null)
            {
               childOrigin = new Vector3D();
               childDirection = new Vector3D();
            }
            childOrigin.x = child.ma * origin.x + child.mb * origin.y + child.mc * origin.z + child.md;
            childOrigin.y = child.me * origin.x + child.mf * origin.y + child.mg * origin.z + child.mh;
            childOrigin.z = child.mi * origin.x + child.mj * origin.y + child.mk * origin.z + child.ml;
            childDirection.x = child.ma * direction.x + child.mb * direction.y + child.mc * direction.z;
            childDirection.y = child.me * direction.x + child.mf * direction.y + child.mg * direction.z;
            childDirection.z = child.mi * direction.x + child.mj * direction.y + child.mk * direction.z;
            data = child.intersectRay(childOrigin,childDirection,excludedObjects,camera);
            if(data != null && data.time < minTime)
            {
               minTime = data.time;
               res = data;
            }
         }
         return res;
      }
      
      override alternativa3d function checkIntersection(ox:Number, oy:Number, oz:Number, dx:Number, dy:Number, dz:Number, dw:Number, excludedObjects:Dictionary) : Boolean
      {
         if(super.alternativa3d::checkIntersection(ox,oy,oz,dx,dy,dz,dw,excludedObjects))
         {
            return true;
         }
         if(this.root != null && boundCheckIntersection(ox,oy,oz,dx,dy,dz,dw,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ))
         {
            return this.checkIntersectionNode(this.root,ox,oy,oz,dx,dy,dz,dw,excludedObjects);
         }
         return false;
      }
      
      private function checkIntersectionNode(node:KDNode, ox:Number, oy:Number, oz:Number, dx:Number, dy:Number, dz:Number, dw:Number, excludedObjects:Dictionary) : Boolean
      {
         var child:Object3D = null;
         var bound:Object3D = null;
         var cox:Number = NaN;
         var coy:Number = NaN;
         var coz:Number = NaN;
         var cdx:Number = NaN;
         var cdy:Number = NaN;
         var cdz:Number = NaN;
         var time:Number = NaN;
         var axisX:Boolean = false;
         var axisY:Boolean = false;
         var offset:Number = NaN;
         var dot:Number = NaN;
         if(node.negative != null)
         {
            axisX = node.axis == 0;
            axisY = node.axis == 1;
            offset = (axisX ? ox : (axisY ? oy : oz)) - node.coord;
            dot = axisX ? dx : (axisY ? dy : dz);
            if(offset > 0)
            {
               if(dot < 0)
               {
                  time = -offset / dot;
                  if(time < dw)
                  {
                     child = node.objectList;
                     bound = node.objectBoundList;
                     while(child != null)
                     {
                        if(boundCheckIntersection(ox,oy,oz,dx,dy,dz,dw,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ))
                        {
                           child.composeMatrix();
                           child.invertMatrix();
                           cox = child.ma * ox + child.mb * oy + child.mc * oz + child.md;
                           coy = child.me * ox + child.mf * oy + child.mg * oz + child.mh;
                           coz = child.mi * ox + child.mj * oy + child.mk * oz + child.ml;
                           cdx = child.ma * dx + child.mb * dy + child.mc * dz;
                           cdy = child.me * dx + child.mf * dy + child.mg * dz;
                           cdz = child.mi * dx + child.mj * dy + child.mk * dz;
                           if(child.checkIntersection(cox,coy,coz,cdx,cdy,cdz,dw,excludedObjects))
                           {
                              return true;
                           }
                        }
                        child = child.next;
                        bound = bound.next;
                     }
                     if(boundCheckIntersection(ox,oy,oz,dx,dy,dz,dw,node.negative.boundMinX,node.negative.boundMinY,node.negative.boundMinZ,node.negative.boundMaxX,node.negative.boundMaxY,node.negative.boundMaxZ) && this.checkIntersectionNode(node.negative,ox,oy,oz,dx,dy,dz,dw,excludedObjects))
                     {
                        return true;
                     }
                  }
               }
               return boundCheckIntersection(ox,oy,oz,dx,dy,dz,dw,node.positive.boundMinX,node.positive.boundMinY,node.positive.boundMinZ,node.positive.boundMaxX,node.positive.boundMaxY,node.positive.boundMaxZ) && this.checkIntersectionNode(node.positive,ox,oy,oz,dx,dy,dz,dw,excludedObjects);
            }
            if(dot > 0)
            {
               time = -offset / dot;
               if(time < dw)
               {
                  child = node.objectList;
                  bound = node.objectBoundList;
                  while(child != null)
                  {
                     if(boundCheckIntersection(ox,oy,oz,dx,dy,dz,dw,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ))
                     {
                        child.composeMatrix();
                        child.invertMatrix();
                        cox = child.ma * ox + child.mb * oy + child.mc * oz + child.md;
                        coy = child.me * ox + child.mf * oy + child.mg * oz + child.mh;
                        coz = child.mi * ox + child.mj * oy + child.mk * oz + child.ml;
                        cdx = child.ma * dx + child.mb * dy + child.mc * dz;
                        cdy = child.me * dx + child.mf * dy + child.mg * dz;
                        cdz = child.mi * dx + child.mj * dy + child.mk * dz;
                        if(child.checkIntersection(cox,coy,coz,cdx,cdy,cdz,dw,excludedObjects))
                        {
                           return true;
                        }
                     }
                     child = child.next;
                     bound = bound.next;
                  }
                  if(boundCheckIntersection(ox,oy,oz,dx,dy,dz,dw,node.positive.boundMinX,node.positive.boundMinY,node.positive.boundMinZ,node.positive.boundMaxX,node.positive.boundMaxY,node.positive.boundMaxZ) && this.checkIntersectionNode(node.positive,ox,oy,oz,dx,dy,dz,dw,excludedObjects))
                  {
                     return true;
                  }
               }
            }
            return boundCheckIntersection(ox,oy,oz,dx,dy,dz,dw,node.negative.boundMinX,node.negative.boundMinY,node.negative.boundMinZ,node.negative.boundMaxX,node.negative.boundMaxY,node.negative.boundMaxZ) && this.checkIntersectionNode(node.negative,ox,oy,oz,dx,dy,dz,dw,excludedObjects);
         }
         for(child = node.objectList; child != null; )
         {
            child.composeMatrix();
            child.invertMatrix();
            cox = child.ma * ox + child.mb * oy + child.mc * oz + child.md;
            coy = child.me * ox + child.mf * oy + child.mg * oz + child.mh;
            coz = child.mi * ox + child.mj * oy + child.mk * oz + child.ml;
            cdx = child.ma * dx + child.mb * dy + child.mc * dz;
            cdy = child.me * dx + child.mf * dy + child.mg * dz;
            cdz = child.mi * dx + child.mj * dy + child.mk * dz;
            if(child.checkIntersection(cox,coy,coz,cdx,cdy,cdz,dw,excludedObjects))
            {
               return true;
            }
            child = child.next;
         }
         return false;
      }
      
      override alternativa3d function collectPlanes(center:Vector3D, a:Vector3D, b:Vector3D, c:Vector3D, d:Vector3D, collector:Vector.<Face>, excludedObjects:Dictionary = null) : void
      {
         var child:Object3D = null;
         if(excludedObjects != null && Boolean(excludedObjects[this]))
         {
            return;
         }
         var sphere:Vector3D = calculateSphere(center,a,b,c,d,treeSphere);
         if(!this.ignoreChildrenInCollider)
         {
            if(!boundIntersectSphere(sphere,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
            {
               return;
            }
            for(child = childrenList; child != null; )
            {
               child.composeAndAppend(this);
               child.collectPlanes(center,a,b,c,d,collector,excludedObjects);
               child = child.next;
            }
         }
         if(this.root != null && boundIntersectSphere(sphere,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ))
         {
            this.collectPlanesNode(this.root,sphere,center,a,b,c,d,collector,excludedObjects);
         }
      }
      
      private function collectPlanesNode(node:KDNode, sphere:Vector3D, center:Vector3D, a:Vector3D, b:Vector3D, c:Vector3D, d:Vector3D, collector:Vector.<Face>, excludedObjects:Dictionary = null) : void
      {
         var child:Object3D = null;
         var bound:Object3D = null;
         var axisX:Boolean = false;
         var axisY:Boolean = false;
         var offset:Number = NaN;
         if(node.negative != null)
         {
            axisX = node.axis == 0;
            axisY = node.axis == 1;
            offset = (axisX ? sphere.x : (axisY ? sphere.y : sphere.z)) - node.coord;
            if(offset >= sphere.w)
            {
               if(boundIntersectSphere(sphere,node.positive.boundMinX,node.positive.boundMinY,node.positive.boundMinZ,node.positive.boundMaxX,node.positive.boundMaxY,node.positive.boundMaxZ))
               {
                  this.collectPlanesNode(node.positive,sphere,center,a,b,c,d,collector,excludedObjects);
               }
            }
            else if(offset <= -sphere.w)
            {
               if(boundIntersectSphere(sphere,node.negative.boundMinX,node.negative.boundMinY,node.negative.boundMinZ,node.negative.boundMaxX,node.negative.boundMaxY,node.negative.boundMaxZ))
               {
                  this.collectPlanesNode(node.negative,sphere,center,a,b,c,d,collector,excludedObjects);
               }
            }
            else
            {
               child = node.objectList;
               bound = node.objectBoundList;
               while(child != null)
               {
                  if(boundIntersectSphere(sphere,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ))
                  {
                     child.composeAndAppend(this);
                     child.collectPlanes(center,a,b,c,d,collector,excludedObjects);
                  }
                  child = child.next;
                  bound = bound.next;
               }
               if(boundIntersectSphere(sphere,node.positive.boundMinX,node.positive.boundMinY,node.positive.boundMinZ,node.positive.boundMaxX,node.positive.boundMaxY,node.positive.boundMaxZ))
               {
                  this.collectPlanesNode(node.positive,sphere,center,a,b,c,d,collector,excludedObjects);
               }
               if(boundIntersectSphere(sphere,node.negative.boundMinX,node.negative.boundMinY,node.negative.boundMinZ,node.negative.boundMaxX,node.negative.boundMaxY,node.negative.boundMaxZ))
               {
                  this.collectPlanesNode(node.negative,sphere,center,a,b,c,d,collector,excludedObjects);
               }
            }
         }
         else
         {
            for(child = node.objectList; child != null; )
            {
               child.composeAndAppend(this);
               child.collectPlanes(center,a,b,c,d,collector,excludedObjects);
               child = child.next;
            }
         }
      }
      
      public function createDecal(point:Vector3D, normal:Vector3D, radius:Number, rotation:Number, angleLimit:Number, attenuation:Number, material:Material) : Decal
      {
         var decal:Decal = new Decal();
         decal.attenuation = attenuation;
         var matrix:Matrix3D = new Matrix3D();
         matrix.appendRotation(rotation * 180 / Math.PI,Vector3D.Z_AXIS);
         matrix.appendRotation(Math.atan2(-normal.z,Math.sqrt(normal.x * normal.x + normal.y * normal.y)) * 180 / Math.PI - 90,Vector3D.X_AXIS);
         matrix.appendRotation(-Math.atan2(-normal.x,-normal.y) * 180 / Math.PI,Vector3D.Z_AXIS);
         matrix.appendTranslation(point.x,point.y,point.z);
         decal.matrix = matrix;
         decal.composeMatrix();
         decal.boundMinX = -radius;
         decal.boundMaxX = radius;
         decal.boundMinY = -radius;
         decal.boundMaxY = radius;
         decal.boundMinZ = -attenuation;
         decal.boundMaxZ = attenuation;
         var minX:Number = 1e+22;
         var minY:Number = 1e+22;
         var minZ:Number = 1e+22;
         var maxX:Number = -1e+22;
         var maxY:Number = -1e+22;
         var maxZ:Number = -1e+22;
         var vertex:Vertex = boundVertexList;
         vertex.x = decal.boundMinX;
         vertex.y = decal.boundMinY;
         vertex.z = decal.boundMinZ;
         vertex = vertex.next;
         vertex.x = decal.boundMaxX;
         vertex.y = decal.boundMinY;
         vertex.z = decal.boundMinZ;
         vertex = vertex.next;
         vertex.x = decal.boundMinX;
         vertex.y = decal.boundMaxY;
         vertex.z = decal.boundMinZ;
         vertex = vertex.next;
         vertex.x = decal.boundMaxX;
         vertex.y = decal.boundMaxY;
         vertex.z = decal.boundMinZ;
         vertex = vertex.next;
         vertex.x = decal.boundMinX;
         vertex.y = decal.boundMinY;
         vertex.z = decal.boundMaxZ;
         vertex = vertex.next;
         vertex.x = decal.boundMaxX;
         vertex.y = decal.boundMinY;
         vertex.z = decal.boundMaxZ;
         vertex = vertex.next;
         vertex.x = decal.boundMinX;
         vertex.y = decal.boundMaxY;
         vertex.z = decal.boundMaxZ;
         vertex = vertex.next;
         vertex.x = decal.boundMaxX;
         vertex.y = decal.boundMaxY;
         vertex.z = decal.boundMaxZ;
         for(vertex = boundVertexList; vertex != null; vertex = vertex.next)
         {
            vertex.cameraX = decal.ma * vertex.x + decal.mb * vertex.y + decal.mc * vertex.z + decal.md;
            vertex.cameraY = decal.me * vertex.x + decal.mf * vertex.y + decal.mg * vertex.z + decal.mh;
            vertex.cameraZ = decal.mi * vertex.x + decal.mj * vertex.y + decal.mk * vertex.z + decal.ml;
            if(vertex.cameraX < minX)
            {
               minX = vertex.cameraX;
            }
            if(vertex.cameraX > maxX)
            {
               maxX = vertex.cameraX;
            }
            if(vertex.cameraY < minY)
            {
               minY = vertex.cameraY;
            }
            if(vertex.cameraY > maxY)
            {
               maxY = vertex.cameraY;
            }
            if(vertex.cameraZ < minZ)
            {
               minZ = vertex.cameraZ;
            }
            if(vertex.cameraZ > maxZ)
            {
               maxZ = vertex.cameraZ;
            }
         }
         decal.invertMatrix();
         if(angleLimit > Math.PI / 2)
         {
            angleLimit = Math.PI / 2;
         }
         if(this.root != null)
         {
            this.root.collectPolygons(decal,Math.sqrt(radius * radius + radius * radius + attenuation * attenuation),Math.cos(angleLimit) - 0.001,minX,maxX,minY,maxY,minZ,maxZ);
         }
         if(decal.faceList != null)
         {
            decal.calculateBounds();
         }
         else
         {
            decal.boundMinX = -1;
            decal.boundMinY = -1;
            decal.boundMinZ = -1;
            decal.boundMaxX = 1;
            decal.boundMaxY = 1;
            decal.boundMaxZ = 1;
         }
         decal.setMaterialToAllFaces(material);
         return decal;
      }
      
      override public function clone() : Object3D
      {
         var res:KDContainer = new KDContainer();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         super.clonePropertiesFrom(source);
         var src:KDContainer = source as KDContainer;
         this.debugAlphaFade = src.debugAlphaFade;
         if(src.root != null)
         {
            this.root = src.cloneNode(src.root,this);
         }
      }
      
      private function cloneNode(node:KDNode, parent:Object3DContainer) : KDNode
      {
         var object:Object3D = null;
         var lastObject:Object3D = null;
         var newObject:Object3D = null;
         var newNode:KDNode = new KDNode();
         newNode.axis = node.axis;
         newNode.coord = node.coord;
         newNode.minCoord = node.minCoord;
         newNode.maxCoord = node.maxCoord;
         newNode.boundMinX = node.boundMinX;
         newNode.boundMinY = node.boundMinY;
         newNode.boundMinZ = node.boundMinZ;
         newNode.boundMaxX = node.boundMaxX;
         newNode.boundMaxY = node.boundMaxY;
         newNode.boundMaxZ = node.boundMaxZ;
         object = node.objectList;
         lastObject = null;
         while(object != null)
         {
            newObject = object.clone();
            if(newNode.objectList != null)
            {
               lastObject.next = newObject;
            }
            else
            {
               newNode.objectList = newObject;
            }
            lastObject = newObject;
            newObject.setParent(parent);
            object = object.next;
         }
         object = node.objectBoundList;
         lastObject = null;
         while(object != null)
         {
            newObject = object.clone();
            if(newNode.objectBoundList != null)
            {
               lastObject.next = newObject;
            }
            else
            {
               newNode.objectBoundList = newObject;
            }
            lastObject = newObject;
            object = object.next;
         }
         object = node.occluderList;
         lastObject = null;
         while(object != null)
         {
            newObject = object.clone();
            if(newNode.occluderList != null)
            {
               lastObject.next = newObject;
            }
            else
            {
               newNode.occluderList = newObject;
            }
            lastObject = newObject;
            newObject.setParent(parent);
            object = object.next;
         }
         object = node.occluderBoundList;
         lastObject = null;
         while(object != null)
         {
            newObject = object.clone();
            if(newNode.occluderBoundList != null)
            {
               lastObject.next = newObject;
            }
            else
            {
               newNode.occluderBoundList = newObject;
            }
            lastObject = newObject;
            object = object.next;
         }
         if(node.negative != null)
         {
            newNode.negative = this.cloneNode(node.negative,parent);
         }
         if(node.positive != null)
         {
            newNode.positive = this.cloneNode(node.positive,parent);
         }
         return newNode;
      }
      
      override alternativa3d function draw(camera:Camera3D) : void
      {
         var i:int = 0;
         var child:Object3D = null;
         var current:VG = null;
         var geometry:VG = null;
         var cnt:Object3DContainer = null;
         var ch:Object3D = null;
         var cameraDebug:Boolean = false;
         var vg:VG = null;
         var rootCulling:int = 0;
         var first:Vertex = null;
         var last:Vertex = null;
         var atlas:ShadowAtlas = null;
         this.uploadResources(camera.device);
         calculateInverseMatrix();
         var debug:int = camera.debug ? camera.checkInDebug(this) : 0;
         if(Boolean(debug & Debug.BOUNDS))
         {
            Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
         }
         if(this.batched)
         {
            cameraDebug = camera.debug;
            if(Boolean(debug) && Boolean(debug & Debug.NODES))
            {
               camera.debug = false;
            }
            for(child = this.opaqueList; child != null; child = child.next)
            {
               child.ma = ma;
               child.mb = mb;
               child.mc = mc;
               child.md = md;
               child.me = me;
               child.mf = mf;
               child.mg = mg;
               child.mh = mh;
               child.mi = mi;
               child.mj = mj;
               child.mk = mk;
               child.ml = ml;
               child.concat(this);
               child.draw(camera);
               if(!camera.view.constrained && camera.shadowMap != null && camera.shadowMapStrength > 0 && child.concatenatedAlpha >= child.shadowMapAlphaThreshold)
               {
                  camera.casterObjects[camera.casterCount] = child;
                  ++camera.casterCount;
               }
            }
            camera.debug = cameraDebug;
            geometry = super.alternativa3d::getVG(camera);
            if(!camera.view.constrained && camera.shadowMap != null && camera.shadowMapStrength > 0)
            {
               for(child = childrenList; child != null; )
               {
                  if(child.visible)
                  {
                     if(child is Mesh)
                     {
                        if(!(child is Decal))
                        {
                           if(child.concatenatedAlpha >= child.shadowMapAlphaThreshold)
                           {
                              camera.casterObjects[camera.casterCount] = child;
                              ++camera.casterCount;
                           }
                        }
                     }
                     else if(child is Object3DContainer)
                     {
                        cnt = Object3DContainer(child);
                        for(ch = cnt.childrenList; ch != null; )
                        {
                           if(ch is Mesh)
                           {
                              if(!(ch is Decal))
                              {
                                 if(ch.concatenatedAlpha >= ch.shadowMapAlphaThreshold)
                                 {
                                    camera.casterObjects[camera.casterCount] = ch;
                                    ++camera.casterCount;
                                 }
                              }
                           }
                           ch = ch.next;
                        }
                     }
                     else if(child is Sprite3D && child.name == "bush")
                     {
                        camera.casterObjects[camera.casterCount] = child;
                        ++camera.casterCount;
                     }
                  }
                  child = child.next;
               }
            }
            for(i = 0; i < this.transparentLength; i++)
            {
               child = this.transparent[i];
               child.composeAndAppend(this);
               if(child.cullingInCamera(camera,culling) >= 0)
               {
                  child.concat(this);
                  vg = child.getVG(camera);
                  if(vg != null)
                  {
                     vg.next = geometry;
                     geometry = vg;
                  }
               }
               if(!camera.view.constrained && camera.shadowMap != null && camera.shadowMapStrength > 0 && child.concatenatedAlpha >= child.shadowMapAlphaThreshold)
               {
                  camera.casterObjects[camera.casterCount] = child;
                  ++camera.casterCount;
               }
            }
            if(geometry != null)
            {
               if(geometry.next != null)
               {
                  if(resolveByAABB)
                  {
                     for(current = geometry; current != null; current = current.next)
                     {
                        current.calculateAABB(ima,imb,imc,imd,ime,imf,img,imh,imi,imj,imk,iml);
                     }
                     drawAABBGeometry(camera,geometry);
                  }
                  else if(resolveByOOBB)
                  {
                     for(current = geometry; current != null; current = current.next)
                     {
                        current.calculateOOBB(this);
                     }
                     drawOOBBGeometry(camera,geometry);
                  }
                  else
                  {
                     drawConflictGeometry(camera,geometry);
                  }
               }
               else
               {
                  geometry.draw(camera,threshold,this);
                  geometry.destroy();
               }
            }
         }
         else if(this.root != null)
         {
            this.calculateCameraPlanes(camera.nearClipping,camera.farClipping);
            rootCulling = this.cullingInContainer(culling,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ);
            if(rootCulling >= 0)
            {
               this.numOccluders = 0;
               if(camera.numOccluders > 0)
               {
                  this.updateOccluders(camera);
               }
               geometry = super.alternativa3d::getVG(camera);
               if(!camera.view.constrained && camera.shadowMap != null && camera.shadowMapStrength > 0)
               {
                  for(child = childrenList; child != null; )
                  {
                     if(child.visible)
                     {
                        if(child is Mesh)
                        {
                           if(!(child is Decal))
                           {
                              if(child.concatenatedAlpha >= child.shadowMapAlphaThreshold)
                              {
                                 camera.casterObjects[camera.casterCount] = child;
                                 ++camera.casterCount;
                              }
                           }
                        }
                        else if(child is Object3DContainer)
                        {
                           cnt = Object3DContainer(child);
                           for(ch = cnt.childrenList; ch != null; )
                           {
                              if(ch is Mesh)
                              {
                                 if(!(ch is Decal))
                                 {
                                    if(ch.concatenatedAlpha >= ch.shadowMapAlphaThreshold)
                                    {
                                       camera.casterObjects[camera.casterCount] = ch;
                                       ++camera.casterCount;
                                    }
                                 }
                              }
                              ch = ch.next;
                           }
                        }
                        else if(child is Sprite3D && child.name == "bush")
                        {
                           camera.casterObjects[camera.casterCount] = child;
                           ++camera.casterCount;
                        }
                     }
                     child = child.next;
                  }
               }
               for(current = geometry; current != null; current = current.next)
               {
                  current.calculateAABB(ima,imb,imc,imd,ime,imf,img,imh,imi,imj,imk,iml);
               }
               this.drawNode(this.root,rootCulling,camera,geometry);
               for(i = 0; i < this.numOccluders; i++)
               {
                  first = this.occluders[i];
                  for(last = first; last.next != null; last = last.next)
                  {
                  }
                  last.next = Vertex.collector;
                  Vertex.collector = first;
                  this.occluders[i] = null;
               }
               this.numOccluders = 0;
            }
            else
            {
               super.alternativa3d::draw(camera);
            }
         }
         else
         {
            super.alternativa3d::draw(camera);
         }
         if(this.root != null && Boolean(debug & Debug.NODES))
         {
            this.debugNode(this.root,rootCulling,camera,1);
            Debug.drawBounds(camera,this,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ,14496733);
         }
         if(this.root != null)
         {
            camera.receiversVertexBuffers = this.receiversVertexBuffers;
            camera.receiversIndexBuffers = this.receiversIndexBuffers;
            for each(atlas in camera.shadowAtlases)
            {
               for(i = 0; i < atlas.shadowsCount; i++)
               {
                  this.root.collectReceivers(atlas.shadows[i],camera);
               }
            }
         }
      }
      
      override alternativa3d function getVG(camera:Camera3D) : VG
      {
         var rootCulling:int = 0;
         var res:VG = super.alternativa3d::getVG(camera);
         if(this.root != null)
         {
            this.numOccluders = 0;
            calculateInverseMatrix();
            this.calculateCameraPlanes(camera.nearClipping,camera.farClipping);
            rootCulling = this.cullingInContainer(culling,this.root.boundMinX,this.root.boundMinY,this.root.boundMinZ,this.root.boundMaxX,this.root.boundMaxY,this.root.boundMaxZ);
            if(rootCulling >= 0)
            {
               res = this.collectVGNode(this.root,rootCulling,camera,res);
            }
         }
         return res;
      }
      
      private function collectVGNode(node:KDNode, culling:int, camera:Camera3D, result:VG = null) : VG
      {
         var first:VG = null;
         var last:VG = null;
         var geometry:VG = null;
         var negativeCulling:int = 0;
         var positiveCulling:int = 0;
         var child:Object3D = node.objectList;
         var bound:Object3D = node.objectBoundList;
         while(child != null)
         {
            if(child.visible && ((child.culling = culling) == 0 || (child.culling = this.cullingInContainer(culling,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ)) >= 0))
            {
               child.composeAndAppend(this);
               child.concat(this);
               geometry = child.getVG(camera);
               if(geometry != null)
               {
                  if(first != null)
                  {
                     last.next = geometry;
                  }
                  else
                  {
                     first = geometry;
                     last = geometry;
                  }
                  while(last.next != null)
                  {
                     last = last.next;
                  }
               }
            }
            child = child.next;
            bound = bound.next;
         }
         if(first != null)
         {
            last.next = result;
            result = first;
         }
         if(node.negative != null)
         {
            negativeCulling = culling > 0 ? this.cullingInContainer(culling,node.negative.boundMinX,node.negative.boundMinY,node.negative.boundMinZ,node.negative.boundMaxX,node.negative.boundMaxY,node.negative.boundMaxZ) : 0;
            positiveCulling = culling > 0 ? this.cullingInContainer(culling,node.positive.boundMinX,node.positive.boundMinY,node.positive.boundMinZ,node.positive.boundMaxX,node.positive.boundMaxY,node.positive.boundMaxZ) : 0;
            if(negativeCulling >= 0)
            {
               result = this.collectVGNode(node.negative,negativeCulling,camera,result);
            }
            if(positiveCulling >= 0)
            {
               result = this.collectVGNode(node.positive,positiveCulling,camera,result);
            }
         }
         return result;
      }
      
      private function uploadResources(device:Device) : void
      {
         var key:* = undefined;
         var object:Object3D = null;
         var mesh:Mesh = null;
         var bsp:BSP = null;
         var i:int = 0;
         var textureMaterial:TextureMaterial = null;
         if(this.context3DIds[device.stage3DIndex] != device.context3DId)
         {
            this.context3DIds[device.stage3DIndex] = device.context3DId;
            for(key in this.materials)
            {
               textureMaterial = key as TextureMaterial;
               if(textureMaterial._texture != null)
               {
                  device.uploadResource(textureMaterial.textureResource);
               }
               if(textureMaterial._textureATF != null)
               {
                  device.uploadResource(textureMaterial.textureATFResource);
               }
               if(textureMaterial._textureATFAlpha != null)
               {
                  device.uploadResource(textureMaterial.textureATFAlphaResource);
               }
            }
            for(object = this.opaqueList; object != null; )
            {
               if(object is Mesh)
               {
                  mesh = object as Mesh;
                  mesh.prepareResources();
                  device.uploadResource(mesh.vertexBuffer);
                  device.uploadResource(mesh.indexBuffer);
               }
               else if(object is BSP)
               {
                  bsp = object as BSP;
                  bsp.prepareResources();
                  device.uploadResource(bsp.vertexBuffer);
                  device.uploadResource(bsp.indexBuffer);
               }
               object = object.next;
            }
            for(i = 0; i < this.transparentLength; )
            {
               object = this.transparent[i];
               if(object is Mesh)
               {
                  mesh = object as Mesh;
                  mesh.prepareResources();
                  device.uploadResource(mesh.vertexBuffer);
                  device.uploadResource(mesh.indexBuffer);
               }
               else if(object is BSP)
               {
                  bsp = object as BSP;
                  bsp.prepareResources();
                  device.uploadResource(bsp.vertexBuffer);
                  device.uploadResource(bsp.indexBuffer);
               }
               i++;
            }
            for(i = 0; i < this.receiversVertexBuffers.length; i++)
            {
               device.uploadResource(this.receiversVertexBuffers[i]);
               device.uploadResource(this.receiversIndexBuffers[i]);
            }
         }
      }
      
      override alternativa3d function updateBounds(bounds:Object3D, transformation:Object3D = null) : void
      {
         super.alternativa3d::updateBounds(bounds,transformation);
         if(this.root != null)
         {
            if(transformation != null)
            {
               this.updateBoundsNode(this.root,bounds,transformation);
            }
            else
            {
               if(this.root.boundMinX < bounds.boundMinX)
               {
                  bounds.boundMinX = this.root.boundMinX;
               }
               if(this.root.boundMaxX > bounds.boundMaxX)
               {
                  bounds.boundMaxX = this.root.boundMaxX;
               }
               if(this.root.boundMinY < bounds.boundMinY)
               {
                  bounds.boundMinY = this.root.boundMinY;
               }
               if(this.root.boundMaxY > bounds.boundMaxY)
               {
                  bounds.boundMaxY = this.root.boundMaxY;
               }
               if(this.root.boundMinZ < bounds.boundMinZ)
               {
                  bounds.boundMinZ = this.root.boundMinZ;
               }
               if(this.root.boundMaxZ > bounds.boundMaxZ)
               {
                  bounds.boundMaxZ = this.root.boundMaxZ;
               }
            }
         }
      }
      
      private function updateBoundsNode(node:KDNode, bounds:Object3D, transformation:Object3D) : void
      {
         for(var child:Object3D = node.objectList; child != null; child = child.next)
         {
            if(transformation != null)
            {
               child.composeAndAppend(transformation);
            }
            else
            {
               child.composeMatrix();
            }
            child.updateBounds(bounds,child);
         }
         if(node.negative != null)
         {
            this.updateBoundsNode(node.negative,bounds,transformation);
            this.updateBoundsNode(node.positive,bounds,transformation);
         }
      }
      
      private function debugNode(node:KDNode, culling:int, camera:Camera3D, alpha:Number) : void
      {
         var negativeCulling:int = 0;
         var positiveCulling:int = 0;
         if(node != null && node.negative != null)
         {
            negativeCulling = culling > 0 ? this.cullingInContainer(culling,node.negative.boundMinX,node.negative.boundMinY,node.negative.boundMinZ,node.negative.boundMaxX,node.negative.boundMaxY,node.negative.boundMaxZ) : 0;
            positiveCulling = culling > 0 ? this.cullingInContainer(culling,node.positive.boundMinX,node.positive.boundMinY,node.positive.boundMinZ,node.positive.boundMaxX,node.positive.boundMaxY,node.positive.boundMaxZ) : 0;
            if(negativeCulling >= 0)
            {
               this.debugNode(node.negative,negativeCulling,camera,alpha * this.debugAlphaFade);
            }
            Debug.drawKDNode(camera,this,node.axis,node.coord,node.boundMinX,node.boundMinY,node.boundMinZ,node.boundMaxX,node.boundMaxY,node.boundMaxZ,alpha);
            if(positiveCulling >= 0)
            {
               this.debugNode(node.positive,positiveCulling,camera,alpha * this.debugAlphaFade);
            }
         }
      }
      
      private function drawNode(node:KDNode, culling:int, camera:Camera3D, geometry:VG) : void
      {
         var i:int = 0;
         var next:VG = null;
         var negative:VG = null;
         var middle:VG = null;
         var positive:VG = null;
         var child:Object3D = null;
         var bound:Object3D = null;
         var negativeCulling:int = 0;
         var positiveCulling:int = 0;
         var axisX:Boolean = false;
         var axisY:Boolean = false;
         var min:Number = NaN;
         var max:Number = NaN;
         if(camera.occludedAll)
         {
            while(geometry != null)
            {
               next = geometry.next;
               geometry.destroy();
               geometry = next;
            }
            return;
         }
         if(node.negative != null)
         {
            negativeCulling = culling > 0 || this.numOccluders > 0 ? this.cullingInContainer(culling,node.negative.boundMinX,node.negative.boundMinY,node.negative.boundMinZ,node.negative.boundMaxX,node.negative.boundMaxY,node.negative.boundMaxZ) : 0;
            positiveCulling = culling > 0 || this.numOccluders > 0 ? this.cullingInContainer(culling,node.positive.boundMinX,node.positive.boundMinY,node.positive.boundMinZ,node.positive.boundMaxX,node.positive.boundMaxY,node.positive.boundMaxZ) : 0;
            axisX = node.axis == 0;
            axisY = node.axis == 1;
            if(negativeCulling >= 0 && positiveCulling >= 0)
            {
               while(geometry != null)
               {
                  next = geometry.next;
                  if(geometry.numOccluders < this.numOccluders && this.occludeGeometry(camera,geometry))
                  {
                     geometry.destroy();
                  }
                  else
                  {
                     min = axisX ? geometry.boundMinX : (axisY ? geometry.boundMinY : geometry.boundMinZ);
                     max = axisX ? geometry.boundMaxX : (axisY ? geometry.boundMaxY : geometry.boundMaxZ);
                     if(max <= node.maxCoord)
                     {
                        if(min < node.minCoord)
                        {
                           geometry.next = negative;
                           negative = geometry;
                        }
                        else
                        {
                           geometry.next = middle;
                           middle = geometry;
                        }
                     }
                     else if(min >= node.minCoord)
                     {
                        geometry.next = positive;
                        positive = geometry;
                     }
                     else
                     {
                        geometry.split(camera,node.axis == 0 ? 1 : 0,node.axis == 1 ? 1 : 0,node.axis == 2 ? 1 : 0,node.coord,threshold);
                        if(geometry.next != null)
                        {
                           geometry.next.next = negative;
                           negative = geometry.next;
                        }
                        if(geometry.faceStruct != null)
                        {
                           geometry.next = positive;
                           positive = geometry;
                        }
                        else
                        {
                           geometry.destroy();
                        }
                     }
                  }
                  geometry = next;
               }
               if(axisX && imd > node.coord || axisY && imh > node.coord || !axisX && !axisY && iml > node.coord)
               {
                  for(this.drawNode(node.positive,positiveCulling,camera,positive); middle != null; )
                  {
                     next = middle.next;
                     if(middle.numOccluders >= this.numOccluders || !this.occludeGeometry(camera,middle))
                     {
                        middle.draw(camera,threshold,this);
                     }
                     middle.destroy();
                     middle = next;
                  }
                  child = node.objectList;
                  bound = node.objectBoundList;
                  while(child != null)
                  {
                     if(child.visible && ((child.culling = culling) == 0 && this.numOccluders == 0 || (child.culling = this.cullingInContainer(culling,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ)) >= 0))
                     {
                        child.copyAndAppend(bound,this);
                        child.concat(this);
                        child.draw(camera);
                     }
                     child = child.next;
                     bound = bound.next;
                  }
                  child = node.occluderList;
                  bound = node.occluderBoundList;
                  while(child != null)
                  {
                     if(child.visible && ((child.culling = culling) == 0 && this.numOccluders == 0 || (child.culling = this.cullingInContainer(culling,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ)) >= 0))
                     {
                        child.copyAndAppend(bound,this);
                        child.concat(this);
                        child.draw(camera);
                     }
                     child = child.next;
                     bound = bound.next;
                  }
                  if(node.occluderList != null)
                  {
                     this.updateOccluders(camera);
                  }
                  this.drawNode(node.negative,negativeCulling,camera,negative);
               }
               else
               {
                  for(this.drawNode(node.negative,negativeCulling,camera,negative); middle != null; )
                  {
                     next = middle.next;
                     if(middle.numOccluders >= this.numOccluders || !this.occludeGeometry(camera,middle))
                     {
                        middle.draw(camera,threshold,this);
                     }
                     middle.destroy();
                     middle = next;
                  }
                  child = node.objectList;
                  bound = node.objectBoundList;
                  while(child != null)
                  {
                     if(child.visible && ((child.culling = culling) == 0 && this.numOccluders == 0 || (child.culling = this.cullingInContainer(culling,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ)) >= 0))
                     {
                        child.copyAndAppend(bound,this);
                        child.concat(this);
                        child.draw(camera);
                     }
                     child = child.next;
                     bound = bound.next;
                  }
                  child = node.occluderList;
                  bound = node.occluderBoundList;
                  while(child != null)
                  {
                     if(child.visible && ((child.culling = culling) == 0 && this.numOccluders == 0 || (child.culling = this.cullingInContainer(culling,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ)) >= 0))
                     {
                        child.copyAndAppend(bound,this);
                        child.concat(this);
                        child.draw(camera);
                     }
                     child = child.next;
                     bound = bound.next;
                  }
                  if(node.occluderList != null)
                  {
                     this.updateOccluders(camera);
                  }
                  this.drawNode(node.positive,positiveCulling,camera,positive);
               }
            }
            else if(negativeCulling >= 0)
            {
               while(geometry != null)
               {
                  next = geometry.next;
                  if(geometry.numOccluders < this.numOccluders && this.occludeGeometry(camera,geometry))
                  {
                     geometry.destroy();
                  }
                  else
                  {
                     min = axisX ? geometry.boundMinX : (axisY ? geometry.boundMinY : geometry.boundMinZ);
                     max = axisX ? geometry.boundMaxX : (axisY ? geometry.boundMaxY : geometry.boundMaxZ);
                     if(max <= node.maxCoord)
                     {
                        geometry.next = negative;
                        negative = geometry;
                     }
                     else if(min >= node.minCoord)
                     {
                        geometry.destroy();
                     }
                     else
                     {
                        geometry.crop(camera,node.axis == 0 ? -1 : 0,node.axis == 1 ? -1 : 0,node.axis == 2 ? -1 : 0,-node.coord,threshold);
                        if(geometry.faceStruct != null)
                        {
                           geometry.next = negative;
                           negative = geometry;
                        }
                        else
                        {
                           geometry.destroy();
                        }
                     }
                  }
                  geometry = next;
               }
               this.drawNode(node.negative,negativeCulling,camera,negative);
            }
            else if(positiveCulling >= 0)
            {
               while(geometry != null)
               {
                  next = geometry.next;
                  if(geometry.numOccluders < this.numOccluders && this.occludeGeometry(camera,geometry))
                  {
                     geometry.destroy();
                  }
                  else
                  {
                     min = axisX ? geometry.boundMinX : (axisY ? geometry.boundMinY : geometry.boundMinZ);
                     max = axisX ? geometry.boundMaxX : (axisY ? geometry.boundMaxY : geometry.boundMaxZ);
                     if(max <= node.maxCoord)
                     {
                        geometry.destroy();
                     }
                     else if(min >= node.minCoord)
                     {
                        geometry.next = positive;
                        positive = geometry;
                     }
                     else
                     {
                        geometry.crop(camera,node.axis == 0 ? 1 : 0,node.axis == 1 ? 1 : 0,node.axis == 2 ? 1 : 0,node.coord,threshold);
                        if(geometry.faceStruct != null)
                        {
                           geometry.next = positive;
                           positive = geometry;
                        }
                        else
                        {
                           geometry.destroy();
                        }
                     }
                  }
                  geometry = next;
               }
               this.drawNode(node.positive,positiveCulling,camera,positive);
            }
            else
            {
               while(geometry != null)
               {
                  next = geometry.next;
                  geometry.destroy();
                  geometry = next;
               }
            }
         }
         else
         {
            if(node.objectList != null)
            {
               if(node.objectList.next != null || geometry != null)
               {
                  while(geometry != null)
                  {
                     next = geometry.next;
                     if(geometry.numOccluders < this.numOccluders && this.occludeGeometry(camera,geometry))
                     {
                        geometry.destroy();
                     }
                     else
                     {
                        geometry.next = middle;
                        middle = geometry;
                     }
                     geometry = next;
                  }
                  child = node.objectList;
                  bound = node.objectBoundList;
                  while(child != null)
                  {
                     if(child.visible && ((child.culling = culling) == 0 && this.numOccluders == 0 || (child.culling = this.cullingInContainer(culling,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ)) >= 0))
                     {
                        child.copyAndAppend(bound,this);
                        child.concat(this);
                        for(geometry = child.getVG(camera); geometry != null; )
                        {
                           next = geometry.next;
                           geometry.next = middle;
                           middle = geometry;
                           geometry = next;
                        }
                     }
                     child = child.next;
                     bound = bound.next;
                  }
                  if(middle != null)
                  {
                     if(middle.next != null)
                     {
                        drawConflictGeometry(camera,middle);
                     }
                     else
                     {
                        middle.draw(camera,threshold,this);
                        middle.destroy();
                     }
                  }
               }
               else
               {
                  child = node.objectList;
                  if(child.visible)
                  {
                     child.copyAndAppend(node.objectBoundList,this);
                     child.culling = culling;
                     child.concat(this);
                     child.draw(camera);
                  }
               }
            }
            else if(geometry != null)
            {
               if(geometry.next != null)
               {
                  if(this.numOccluders > 0)
                  {
                     while(geometry != null)
                     {
                        next = geometry.next;
                        if(geometry.numOccluders < this.numOccluders && this.occludeGeometry(camera,geometry))
                        {
                           geometry.destroy();
                        }
                        else
                        {
                           geometry.next = middle;
                           middle = geometry;
                        }
                        geometry = next;
                     }
                     if(middle != null)
                     {
                        if(middle.next != null)
                        {
                           if(resolveByAABB)
                           {
                              drawAABBGeometry(camera,middle);
                           }
                           else if(resolveByOOBB)
                           {
                              for(geometry = middle; geometry != null; geometry = geometry.next)
                              {
                                 geometry.calculateOOBB(this);
                              }
                              drawOOBBGeometry(camera,middle);
                           }
                           else
                           {
                              drawConflictGeometry(camera,middle);
                           }
                        }
                        else
                        {
                           middle.draw(camera,threshold,this);
                           middle.destroy();
                        }
                     }
                  }
                  else
                  {
                     middle = geometry;
                     if(resolveByAABB)
                     {
                        drawAABBGeometry(camera,middle);
                     }
                     else if(resolveByOOBB)
                     {
                        for(geometry = middle; geometry != null; geometry = geometry.next)
                        {
                           geometry.calculateOOBB(this);
                        }
                        drawOOBBGeometry(camera,middle);
                     }
                     else
                     {
                        drawConflictGeometry(camera,middle);
                     }
                  }
               }
               else
               {
                  if(geometry.numOccluders >= this.numOccluders || !this.occludeGeometry(camera,geometry))
                  {
                     geometry.draw(camera,threshold,this);
                  }
                  geometry.destroy();
               }
            }
            child = node.occluderList;
            bound = node.occluderBoundList;
            while(child != null)
            {
               if(child.visible && ((child.culling = culling) == 0 && this.numOccluders == 0 || (child.culling = this.cullingInContainer(culling,bound.boundMinX,bound.boundMinY,bound.boundMinZ,bound.boundMaxX,bound.boundMaxY,bound.boundMaxZ)) >= 0))
               {
                  child.copyAndAppend(bound,this);
                  child.concat(this);
                  child.draw(camera);
               }
               child = child.next;
               bound = bound.next;
            }
            if(node.occluderList != null)
            {
               this.updateOccluders(camera);
            }
         }
      }
      
      private function createObjectBounds(object:Object3D) : Object3D
      {
         var bound:Object3D = new Object3D();
         bound.boundMinX = 1e+22;
         bound.boundMinY = 1e+22;
         bound.boundMinZ = 1e+22;
         bound.boundMaxX = -1e+22;
         bound.boundMaxY = -1e+22;
         bound.boundMaxZ = -1e+22;
         object.composeMatrix();
         object.updateBounds(bound,object);
         bound.ma = object.ma;
         bound.mb = object.mb;
         bound.mc = object.mc;
         bound.md = object.md;
         bound.me = object.me;
         bound.mf = object.mf;
         bound.mg = object.mg;
         bound.mh = object.mh;
         bound.mi = object.mi;
         bound.mj = object.mj;
         bound.mk = object.mk;
         bound.ml = object.ml;
         return bound;
      }
      
      private function createNode(objectList:Object3D, objectBoundList:Object3D, occluderList:Object3D, occluderBoundList:Object3D, minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number) : KDNode
      {
         var i:int = 0;
         var j:int = 0;
         var object:Object3D = null;
         var bound:Object3D = null;
         var coord:Number = NaN;
         var splitCoord:Number = NaN;
         var numNegative:int = 0;
         var numPositive:int = 0;
         var area:Number = NaN;
         var areaNegative:Number = NaN;
         var areaPositive:Number = NaN;
         var cost:Number = NaN;
         var negativeObjectList:Object3D = null;
         var negativeObjectBoundList:Object3D = null;
         var negativeOccluderList:Object3D = null;
         var negativeOccluderBoundList:Object3D = null;
         var positiveObjectList:Object3D = null;
         var positiveObjectBoundList:Object3D = null;
         var positiveOccluderList:Object3D = null;
         var positiveOccluderBoundList:Object3D = null;
         var min:Number = NaN;
         var max:Number = NaN;
         var nextObject:Object3D = null;
         var nextBound:Object3D = null;
         var negativeMinX:Number = NaN;
         var negativeMinY:Number = NaN;
         var negativeMinZ:Number = NaN;
         var negativeMaxX:Number = NaN;
         var negativeMaxY:Number = NaN;
         var negativeMaxZ:Number = NaN;
         var positiveMinX:Number = NaN;
         var positiveMinY:Number = NaN;
         var positiveMinZ:Number = NaN;
         var positiveMaxX:Number = NaN;
         var positiveMaxY:Number = NaN;
         var positiveMaxZ:Number = NaN;
         var node:KDNode = new KDNode();
         node.boundMinX = minX;
         node.boundMinY = minY;
         node.boundMinZ = minZ;
         node.boundMaxX = maxX;
         node.boundMaxY = maxY;
         node.boundMaxZ = maxZ;
         if(objectList == null)
         {
            if(occluderList != null)
            {
               trace("Incorrect occluder size or position");
            }
            return node;
         }
         var numSplitCoordsX:int = 0;
         var numSplitCoordsY:int = 0;
         var numSplitCoordsZ:int = 0;
         for(bound = objectBoundList; bound != null; bound = bound.next)
         {
            if(bound.boundMinX > minX + threshold)
            {
               j = 0;
               while(true)
               {
                  if(j < numSplitCoordsX)
                  {
                     if(!(bound.boundMinX >= splitCoordsX[j] - threshold && bound.boundMinX <= splitCoordsX[j] + threshold))
                     {
                        continue;
                     }
                  }
                  if(j == numSplitCoordsX)
                  {
                     splitCoordsX[numSplitCoordsX++] = bound.boundMinX;
                  }
                  j++;
               }
               continue;
            }
            if(bound.boundMaxX < maxX - threshold)
            {
               j = 0;
               while(true)
               {
                  if(j < numSplitCoordsX)
                  {
                     if(!(bound.boundMaxX >= splitCoordsX[j] - threshold && bound.boundMaxX <= splitCoordsX[j] + threshold))
                     {
                        continue;
                     }
                  }
                  if(j == numSplitCoordsX)
                  {
                     splitCoordsX[numSplitCoordsX++] = bound.boundMaxX;
                  }
                  j++;
               }
               continue;
            }
            if(bound.boundMinY > minY + threshold)
            {
               j = 0;
               while(true)
               {
                  if(j < numSplitCoordsY)
                  {
                     if(!(bound.boundMinY >= splitCoordsY[j] - threshold && bound.boundMinY <= splitCoordsY[j] + threshold))
                     {
                        continue;
                     }
                  }
                  if(j == numSplitCoordsY)
                  {
                     splitCoordsY[numSplitCoordsY++] = bound.boundMinY;
                  }
                  j++;
               }
               continue;
            }
            if(bound.boundMaxY < maxY - threshold)
            {
               j = 0;
               while(true)
               {
                  if(j < numSplitCoordsY)
                  {
                     if(!(bound.boundMaxY >= splitCoordsY[j] - threshold && bound.boundMaxY <= splitCoordsY[j] + threshold))
                     {
                        continue;
                     }
                  }
                  if(j == numSplitCoordsY)
                  {
                     splitCoordsY[numSplitCoordsY++] = bound.boundMaxY;
                  }
                  j++;
               }
               continue;
            }
            if(bound.boundMinZ > minZ + threshold)
            {
               j = 0;
               while(true)
               {
                  if(j < numSplitCoordsZ)
                  {
                     if(!(bound.boundMinZ >= splitCoordsZ[j] - threshold && bound.boundMinZ <= splitCoordsZ[j] + threshold))
                     {
                        continue;
                     }
                  }
                  if(j == numSplitCoordsZ)
                  {
                     splitCoordsZ[numSplitCoordsZ++] = bound.boundMinZ;
                  }
                  j++;
               }
               continue;
            }
            if(bound.boundMaxZ < maxZ - threshold)
            {
               j = 0;
               while(true)
               {
                  if(j < numSplitCoordsZ)
                  {
                     if(!(bound.boundMaxZ >= splitCoordsZ[j] - threshold && bound.boundMaxZ <= splitCoordsZ[j] + threshold))
                     {
                        continue;
                     }
                  }
                  if(j == numSplitCoordsZ)
                  {
                     splitCoordsZ[numSplitCoordsZ++] = bound.boundMaxZ;
                  }
                  break;
                  j++;
               }
            }
         }
         var splitAxis:int = -1;
         var bestCost:Number = 1e+22;
         area = (maxY - minY) * (maxZ - minZ);
         for(i = 0; i < numSplitCoordsX; )
         {
            coord = splitCoordsX[i];
            areaNegative = area * (coord - minX);
            areaPositive = area * (maxX - coord);
            numNegative = 0;
            numPositive = 0;
            bound = objectBoundList;
            while(true)
            {
               if(bound != null)
               {
                  if(bound.boundMaxX <= coord + threshold)
                  {
                     if(bound.boundMinX < coord - threshold)
                     {
                        numNegative++;
                     }
                     continue;
                  }
                  if(bound.boundMinX >= coord - threshold)
                  {
                     numPositive++;
                     continue;
                  }
               }
               if(bound == null)
               {
                  cost = areaNegative * numNegative + areaPositive * numPositive;
                  if(cost < bestCost)
                  {
                     bestCost = cost;
                     splitAxis = 0;
                     splitCoord = coord;
                  }
               }
               i++;
               break;
               bound = bound.next;
            }
         }
         area = (maxX - minX) * (maxZ - minZ);
         for(i = 0; i < numSplitCoordsY; )
         {
            coord = splitCoordsY[i];
            areaNegative = area * (coord - minY);
            areaPositive = area * (maxY - coord);
            numNegative = 0;
            numPositive = 0;
            bound = objectBoundList;
            while(true)
            {
               if(bound != null)
               {
                  if(bound.boundMaxY <= coord + threshold)
                  {
                     if(bound.boundMinY < coord - threshold)
                     {
                        numNegative++;
                     }
                     continue;
                  }
                  if(bound.boundMinY >= coord - threshold)
                  {
                     numPositive++;
                     continue;
                  }
               }
               if(bound == null)
               {
                  cost = areaNegative * numNegative + areaPositive * numPositive;
                  if(cost < bestCost)
                  {
                     bestCost = cost;
                     splitAxis = 1;
                     splitCoord = coord;
                  }
               }
               i++;
               break;
               bound = bound.next;
            }
         }
         area = (maxX - minX) * (maxY - minY);
         for(i = 0; i < numSplitCoordsZ; )
         {
            coord = splitCoordsZ[i];
            areaNegative = area * (coord - minZ);
            areaPositive = area * (maxZ - coord);
            numNegative = 0;
            numPositive = 0;
            bound = objectBoundList;
            while(true)
            {
               if(bound != null)
               {
                  if(bound.boundMaxZ <= coord + threshold)
                  {
                     if(bound.boundMinZ < coord - threshold)
                     {
                        numNegative++;
                     }
                     continue;
                  }
                  if(bound.boundMinZ >= coord - threshold)
                  {
                     numPositive++;
                     continue;
                  }
               }
               if(bound == null)
               {
                  cost = areaNegative * numNegative + areaPositive * numPositive;
                  if(cost < bestCost)
                  {
                     bestCost = cost;
                     splitAxis = 2;
                     splitCoord = coord;
                  }
               }
               i++;
               break;
               bound = bound.next;
            }
         }
         if(splitAxis < 0)
         {
            node.objectList = objectList;
            node.objectBoundList = objectBoundList;
            node.occluderList = occluderList;
            node.occluderBoundList = occluderBoundList;
         }
         else
         {
            node.axis = splitAxis;
            node.coord = splitCoord;
            node.minCoord = splitCoord - threshold;
            node.maxCoord = splitCoord + threshold;
            object = objectList;
            bound = objectBoundList;
            while(object != null)
            {
               nextObject = object.next;
               nextBound = bound.next;
               object.next = null;
               bound.next = null;
               min = splitAxis == 0 ? bound.boundMinX : (splitAxis == 1 ? bound.boundMinY : bound.boundMinZ);
               max = splitAxis == 0 ? bound.boundMaxX : (splitAxis == 1 ? bound.boundMaxY : bound.boundMaxZ);
               if(max <= splitCoord + threshold)
               {
                  if(min < splitCoord - threshold)
                  {
                     object.next = negativeObjectList;
                     negativeObjectList = object;
                     bound.next = negativeObjectBoundList;
                     negativeObjectBoundList = bound;
                  }
                  else
                  {
                     object.next = node.objectList;
                     node.objectList = object;
                     bound.next = node.objectBoundList;
                     node.objectBoundList = bound;
                  }
               }
               else if(min >= splitCoord - threshold)
               {
                  object.next = positiveObjectList;
                  positiveObjectList = object;
                  bound.next = positiveObjectBoundList;
                  positiveObjectBoundList = bound;
               }
               object = nextObject;
               bound = nextBound;
            }
            object = occluderList;
            bound = occluderBoundList;
            while(object != null)
            {
               nextObject = object.next;
               nextBound = bound.next;
               object.next = null;
               bound.next = null;
               min = splitAxis == 0 ? bound.boundMinX : (splitAxis == 1 ? bound.boundMinY : bound.boundMinZ);
               max = splitAxis == 0 ? bound.boundMaxX : (splitAxis == 1 ? bound.boundMaxY : bound.boundMaxZ);
               if(max <= splitCoord + threshold)
               {
                  if(min < splitCoord - threshold)
                  {
                     object.next = negativeOccluderList;
                     negativeOccluderList = object;
                     bound.next = negativeOccluderBoundList;
                     negativeOccluderBoundList = bound;
                  }
                  else
                  {
                     object.next = node.occluderList;
                     node.occluderList = object;
                     bound.next = node.occluderBoundList;
                     node.occluderBoundList = bound;
                  }
               }
               else if(min >= splitCoord - threshold)
               {
                  object.next = positiveOccluderList;
                  positiveOccluderList = object;
                  bound.next = positiveOccluderBoundList;
                  positiveOccluderBoundList = bound;
               }
               else
               {
                  trace("Incorrect occluder size or position");
               }
               object = nextObject;
               bound = nextBound;
            }
            negativeMinX = node.boundMinX;
            negativeMinY = node.boundMinY;
            negativeMinZ = node.boundMinZ;
            negativeMaxX = node.boundMaxX;
            negativeMaxY = node.boundMaxY;
            negativeMaxZ = node.boundMaxZ;
            positiveMinX = node.boundMinX;
            positiveMinY = node.boundMinY;
            positiveMinZ = node.boundMinZ;
            positiveMaxX = node.boundMaxX;
            positiveMaxY = node.boundMaxY;
            positiveMaxZ = node.boundMaxZ;
            if(splitAxis == 0)
            {
               negativeMaxX = splitCoord;
               positiveMinX = splitCoord;
            }
            else if(splitAxis == 1)
            {
               negativeMaxY = splitCoord;
               positiveMinY = splitCoord;
            }
            else
            {
               negativeMaxZ = splitCoord;
               positiveMinZ = splitCoord;
            }
            node.negative = this.createNode(negativeObjectList,negativeObjectBoundList,negativeOccluderList,negativeOccluderBoundList,negativeMinX,negativeMinY,negativeMinZ,negativeMaxX,negativeMaxY,negativeMaxZ);
            node.positive = this.createNode(positiveObjectList,positiveObjectBoundList,positiveOccluderList,positiveOccluderBoundList,positiveMinX,positiveMinY,positiveMinZ,positiveMaxX,positiveMaxY,positiveMaxZ);
         }
         return node;
      }
      
      private function destroyNode(node:KDNode) : void
      {
         var object:Object3D = null;
         var nextObject:Object3D = null;
         var nextReceiver:Receiver = null;
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
         for(object = node.objectList; object != null; object = nextObject)
         {
            nextObject = object.next;
            object.setParent(null);
            object.next = null;
         }
         for(object = node.objectBoundList; object != null; object = nextObject)
         {
            nextObject = object.next;
            object.next = null;
         }
         for(object = node.occluderList; object != null; object = nextObject)
         {
            nextObject = object.next;
            object.setParent(null);
            object.next = null;
         }
         for(object = node.occluderBoundList; object != null; object = nextObject)
         {
            nextObject = object.next;
            object.next = null;
         }
         for(var receiver:Receiver = node.receiverList; receiver != null; receiver = nextReceiver)
         {
            nextReceiver = receiver.next;
            receiver.next = null;
         }
         node.objectList = null;
         node.objectBoundList = null;
         node.occluderList = null;
         node.occluderBoundList = null;
         node.receiverList = null;
      }
      
      private function calculateCameraPlanes(near:Number, far:Number) : void
      {
         this.nearPlaneX = imc;
         this.nearPlaneY = img;
         this.nearPlaneZ = imk;
         this.nearPlaneOffset = (imc * near + imd) * this.nearPlaneX + (img * near + imh) * this.nearPlaneY + (imk * near + iml) * this.nearPlaneZ;
         this.farPlaneX = -imc;
         this.farPlaneY = -img;
         this.farPlaneZ = -imk;
         this.farPlaneOffset = (imc * far + imd) * this.farPlaneX + (img * far + imh) * this.farPlaneY + (imk * far + iml) * this.farPlaneZ;
         var ax:Number = -ima - imb + imc;
         var ay:Number = -ime - imf + img;
         var az:Number = -imi - imj + imk;
         var bx:Number = ima - imb + imc;
         var by:Number = ime - imf + img;
         var bz:Number = imi - imj + imk;
         this.topPlaneX = bz * ay - by * az;
         this.topPlaneY = bx * az - bz * ax;
         this.topPlaneZ = by * ax - bx * ay;
         this.topPlaneOffset = imd * this.topPlaneX + imh * this.topPlaneY + iml * this.topPlaneZ;
         ax = bx;
         ay = by;
         az = bz;
         bx = ima + imb + imc;
         by = ime + imf + img;
         bz = imi + imj + imk;
         this.rightPlaneX = bz * ay - by * az;
         this.rightPlaneY = bx * az - bz * ax;
         this.rightPlaneZ = by * ax - bx * ay;
         this.rightPlaneOffset = imd * this.rightPlaneX + imh * this.rightPlaneY + iml * this.rightPlaneZ;
         ax = bx;
         ay = by;
         az = bz;
         bx = -ima + imb + imc;
         by = -ime + imf + img;
         bz = -imi + imj + imk;
         this.bottomPlaneX = bz * ay - by * az;
         this.bottomPlaneY = bx * az - bz * ax;
         this.bottomPlaneZ = by * ax - bx * ay;
         this.bottomPlaneOffset = imd * this.bottomPlaneX + imh * this.bottomPlaneY + iml * this.bottomPlaneZ;
         ax = bx;
         ay = by;
         az = bz;
         bx = -ima - imb + imc;
         by = -ime - imf + img;
         bz = -imi - imj + imk;
         this.leftPlaneX = bz * ay - by * az;
         this.leftPlaneY = bx * az - bz * ax;
         this.leftPlaneZ = by * ax - bx * ay;
         this.leftPlaneOffset = imd * this.leftPlaneX + imh * this.leftPlaneY + iml * this.leftPlaneZ;
      }
      
      private function updateOccluders(camera:Camera3D) : void
      {
         var occluder:Vertex = null;
         var cameraOccluder:Vertex = null;
         var newOccluder:Vertex = null;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var bz:Number = NaN;
         for(var i:int = this.numOccluders; i < camera.numOccluders; i++)
         {
            occluder = null;
            for(cameraOccluder = camera.occluders[i]; cameraOccluder != null; cameraOccluder = cameraOccluder.next)
            {
               newOccluder = cameraOccluder.create();
               newOccluder.next = occluder;
               occluder = newOccluder;
               ax = ima * cameraOccluder.x + imb * cameraOccluder.y + imc * cameraOccluder.z;
               ay = ime * cameraOccluder.x + imf * cameraOccluder.y + img * cameraOccluder.z;
               az = imi * cameraOccluder.x + imj * cameraOccluder.y + imk * cameraOccluder.z;
               bx = ima * cameraOccluder.u + imb * cameraOccluder.v + imc * cameraOccluder.offset;
               by = ime * cameraOccluder.u + imf * cameraOccluder.v + img * cameraOccluder.offset;
               bz = imi * cameraOccluder.u + imj * cameraOccluder.v + imk * cameraOccluder.offset;
               occluder.x = bz * ay - by * az;
               occluder.y = bx * az - bz * ax;
               occluder.z = by * ax - bx * ay;
               occluder.offset = imd * occluder.x + imh * occluder.y + iml * occluder.z;
            }
            this.occluders[this.numOccluders] = occluder;
            ++this.numOccluders;
         }
      }
      
      private function cullingInContainer(culling:int, boundMinX:Number, boundMinY:Number, boundMinZ:Number, boundMaxX:Number, boundMaxY:Number, boundMaxZ:Number) : int
      {
         var occluder:Vertex = null;
         if(culling > 0)
         {
            if(Boolean(culling & 1))
            {
               if(this.nearPlaneX >= 0)
               {
                  if(this.nearPlaneY >= 0)
                  {
                     if(this.nearPlaneZ >= 0)
                     {
                        if(boundMaxX * this.nearPlaneX + boundMaxY * this.nearPlaneY + boundMaxZ * this.nearPlaneZ <= this.nearPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.nearPlaneX + boundMinY * this.nearPlaneY + boundMinZ * this.nearPlaneZ > this.nearPlaneOffset)
                        {
                           culling &= 62;
                        }
                     }
                     else
                     {
                        if(boundMaxX * this.nearPlaneX + boundMaxY * this.nearPlaneY + boundMinZ * this.nearPlaneZ <= this.nearPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.nearPlaneX + boundMinY * this.nearPlaneY + boundMaxZ * this.nearPlaneZ > this.nearPlaneOffset)
                        {
                           culling &= 62;
                        }
                     }
                  }
                  else if(this.nearPlaneZ >= 0)
                  {
                     if(boundMaxX * this.nearPlaneX + boundMinY * this.nearPlaneY + boundMaxZ * this.nearPlaneZ <= this.nearPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.nearPlaneX + boundMaxY * this.nearPlaneY + boundMinZ * this.nearPlaneZ > this.nearPlaneOffset)
                     {
                        culling &= 62;
                     }
                  }
                  else
                  {
                     if(boundMaxX * this.nearPlaneX + boundMinY * this.nearPlaneY + boundMinZ * this.nearPlaneZ <= this.nearPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.nearPlaneX + boundMaxY * this.nearPlaneY + boundMaxZ * this.nearPlaneZ > this.nearPlaneOffset)
                     {
                        culling &= 62;
                     }
                  }
               }
               else if(this.nearPlaneY >= 0)
               {
                  if(this.nearPlaneZ >= 0)
                  {
                     if(boundMinX * this.nearPlaneX + boundMaxY * this.nearPlaneY + boundMaxZ * this.nearPlaneZ <= this.nearPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.nearPlaneX + boundMinY * this.nearPlaneY + boundMinZ * this.nearPlaneZ > this.nearPlaneOffset)
                     {
                        culling &= 62;
                     }
                  }
                  else
                  {
                     if(boundMinX * this.nearPlaneX + boundMaxY * this.nearPlaneY + boundMinZ * this.nearPlaneZ <= this.nearPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.nearPlaneX + boundMinY * this.nearPlaneY + boundMaxZ * this.nearPlaneZ > this.nearPlaneOffset)
                     {
                        culling &= 62;
                     }
                  }
               }
               else if(this.nearPlaneZ >= 0)
               {
                  if(boundMinX * this.nearPlaneX + boundMinY * this.nearPlaneY + boundMaxZ * this.nearPlaneZ <= this.nearPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.nearPlaneX + boundMaxY * this.nearPlaneY + boundMinZ * this.nearPlaneZ > this.nearPlaneOffset)
                  {
                     culling &= 62;
                  }
               }
               else
               {
                  if(boundMinX * this.nearPlaneX + boundMinY * this.nearPlaneY + boundMinZ * this.nearPlaneZ <= this.nearPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.nearPlaneX + boundMaxY * this.nearPlaneY + boundMaxZ * this.nearPlaneZ > this.nearPlaneOffset)
                  {
                     culling &= 62;
                  }
               }
            }
            if(Boolean(culling & 2))
            {
               if(this.farPlaneX >= 0)
               {
                  if(this.farPlaneY >= 0)
                  {
                     if(this.farPlaneZ >= 0)
                     {
                        if(boundMaxX * this.farPlaneX + boundMaxY * this.farPlaneY + boundMaxZ * this.farPlaneZ <= this.farPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.farPlaneX + boundMinY * this.farPlaneY + boundMinZ * this.farPlaneZ > this.farPlaneOffset)
                        {
                           culling &= 61;
                        }
                     }
                     else
                     {
                        if(boundMaxX * this.farPlaneX + boundMaxY * this.farPlaneY + boundMinZ * this.farPlaneZ <= this.farPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.farPlaneX + boundMinY * this.farPlaneY + boundMaxZ * this.farPlaneZ > this.farPlaneOffset)
                        {
                           culling &= 61;
                        }
                     }
                  }
                  else if(this.farPlaneZ >= 0)
                  {
                     if(boundMaxX * this.farPlaneX + boundMinY * this.farPlaneY + boundMaxZ * this.farPlaneZ <= this.farPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.farPlaneX + boundMaxY * this.farPlaneY + boundMinZ * this.farPlaneZ > this.farPlaneOffset)
                     {
                        culling &= 61;
                     }
                  }
                  else
                  {
                     if(boundMaxX * this.farPlaneX + boundMinY * this.farPlaneY + boundMinZ * this.farPlaneZ <= this.farPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.farPlaneX + boundMaxY * this.farPlaneY + boundMaxZ * this.farPlaneZ > this.farPlaneOffset)
                     {
                        culling &= 61;
                     }
                  }
               }
               else if(this.farPlaneY >= 0)
               {
                  if(this.farPlaneZ >= 0)
                  {
                     if(boundMinX * this.farPlaneX + boundMaxY * this.farPlaneY + boundMaxZ * this.farPlaneZ <= this.farPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.farPlaneX + boundMinY * this.farPlaneY + boundMinZ * this.farPlaneZ > this.farPlaneOffset)
                     {
                        culling &= 61;
                     }
                  }
                  else
                  {
                     if(boundMinX * this.farPlaneX + boundMaxY * this.farPlaneY + boundMinZ * this.farPlaneZ <= this.farPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.farPlaneX + boundMinY * this.farPlaneY + boundMaxZ * this.farPlaneZ > this.farPlaneOffset)
                     {
                        culling &= 61;
                     }
                  }
               }
               else if(this.farPlaneZ >= 0)
               {
                  if(boundMinX * this.farPlaneX + boundMinY * this.farPlaneY + boundMaxZ * this.farPlaneZ <= this.farPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.farPlaneX + boundMaxY * this.farPlaneY + boundMinZ * this.farPlaneZ > this.farPlaneOffset)
                  {
                     culling &= 61;
                  }
               }
               else
               {
                  if(boundMinX * this.farPlaneX + boundMinY * this.farPlaneY + boundMinZ * this.farPlaneZ <= this.farPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.farPlaneX + boundMaxY * this.farPlaneY + boundMaxZ * this.farPlaneZ > this.farPlaneOffset)
                  {
                     culling &= 61;
                  }
               }
            }
            if(Boolean(culling & 4))
            {
               if(this.leftPlaneX >= 0)
               {
                  if(this.leftPlaneY >= 0)
                  {
                     if(this.leftPlaneZ >= 0)
                     {
                        if(boundMaxX * this.leftPlaneX + boundMaxY * this.leftPlaneY + boundMaxZ * this.leftPlaneZ <= this.leftPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.leftPlaneX + boundMinY * this.leftPlaneY + boundMinZ * this.leftPlaneZ > this.leftPlaneOffset)
                        {
                           culling &= 59;
                        }
                     }
                     else
                     {
                        if(boundMaxX * this.leftPlaneX + boundMaxY * this.leftPlaneY + boundMinZ * this.leftPlaneZ <= this.leftPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.leftPlaneX + boundMinY * this.leftPlaneY + boundMaxZ * this.leftPlaneZ > this.leftPlaneOffset)
                        {
                           culling &= 59;
                        }
                     }
                  }
                  else if(this.leftPlaneZ >= 0)
                  {
                     if(boundMaxX * this.leftPlaneX + boundMinY * this.leftPlaneY + boundMaxZ * this.leftPlaneZ <= this.leftPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.leftPlaneX + boundMaxY * this.leftPlaneY + boundMinZ * this.leftPlaneZ > this.leftPlaneOffset)
                     {
                        culling &= 59;
                     }
                  }
                  else
                  {
                     if(boundMaxX * this.leftPlaneX + boundMinY * this.leftPlaneY + boundMinZ * this.leftPlaneZ <= this.leftPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.leftPlaneX + boundMaxY * this.leftPlaneY + boundMaxZ * this.leftPlaneZ > this.leftPlaneOffset)
                     {
                        culling &= 59;
                     }
                  }
               }
               else if(this.leftPlaneY >= 0)
               {
                  if(this.leftPlaneZ >= 0)
                  {
                     if(boundMinX * this.leftPlaneX + boundMaxY * this.leftPlaneY + boundMaxZ * this.leftPlaneZ <= this.leftPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.leftPlaneX + boundMinY * this.leftPlaneY + boundMinZ * this.leftPlaneZ > this.leftPlaneOffset)
                     {
                        culling &= 59;
                     }
                  }
                  else
                  {
                     if(boundMinX * this.leftPlaneX + boundMaxY * this.leftPlaneY + boundMinZ * this.leftPlaneZ <= this.leftPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.leftPlaneX + boundMinY * this.leftPlaneY + boundMaxZ * this.leftPlaneZ > this.leftPlaneOffset)
                     {
                        culling &= 59;
                     }
                  }
               }
               else if(this.leftPlaneZ >= 0)
               {
                  if(boundMinX * this.leftPlaneX + boundMinY * this.leftPlaneY + boundMaxZ * this.leftPlaneZ <= this.leftPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.leftPlaneX + boundMaxY * this.leftPlaneY + boundMinZ * this.leftPlaneZ > this.leftPlaneOffset)
                  {
                     culling &= 59;
                  }
               }
               else
               {
                  if(boundMinX * this.leftPlaneX + boundMinY * this.leftPlaneY + boundMinZ * this.leftPlaneZ <= this.leftPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.leftPlaneX + boundMaxY * this.leftPlaneY + boundMaxZ * this.leftPlaneZ > this.leftPlaneOffset)
                  {
                     culling &= 59;
                  }
               }
            }
            if(Boolean(culling & 8))
            {
               if(this.rightPlaneX >= 0)
               {
                  if(this.rightPlaneY >= 0)
                  {
                     if(this.rightPlaneZ >= 0)
                     {
                        if(boundMaxX * this.rightPlaneX + boundMaxY * this.rightPlaneY + boundMaxZ * this.rightPlaneZ <= this.rightPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.rightPlaneX + boundMinY * this.rightPlaneY + boundMinZ * this.rightPlaneZ > this.rightPlaneOffset)
                        {
                           culling &= 55;
                        }
                     }
                     else
                     {
                        if(boundMaxX * this.rightPlaneX + boundMaxY * this.rightPlaneY + boundMinZ * this.rightPlaneZ <= this.rightPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.rightPlaneX + boundMinY * this.rightPlaneY + boundMaxZ * this.rightPlaneZ > this.rightPlaneOffset)
                        {
                           culling &= 55;
                        }
                     }
                  }
                  else if(this.rightPlaneZ >= 0)
                  {
                     if(boundMaxX * this.rightPlaneX + boundMinY * this.rightPlaneY + boundMaxZ * this.rightPlaneZ <= this.rightPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.rightPlaneX + boundMaxY * this.rightPlaneY + boundMinZ * this.rightPlaneZ > this.rightPlaneOffset)
                     {
                        culling &= 55;
                     }
                  }
                  else
                  {
                     if(boundMaxX * this.rightPlaneX + boundMinY * this.rightPlaneY + boundMinZ * this.rightPlaneZ <= this.rightPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.rightPlaneX + boundMaxY * this.rightPlaneY + boundMaxZ * this.rightPlaneZ > this.rightPlaneOffset)
                     {
                        culling &= 55;
                     }
                  }
               }
               else if(this.rightPlaneY >= 0)
               {
                  if(this.rightPlaneZ >= 0)
                  {
                     if(boundMinX * this.rightPlaneX + boundMaxY * this.rightPlaneY + boundMaxZ * this.rightPlaneZ <= this.rightPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.rightPlaneX + boundMinY * this.rightPlaneY + boundMinZ * this.rightPlaneZ > this.rightPlaneOffset)
                     {
                        culling &= 55;
                     }
                  }
                  else
                  {
                     if(boundMinX * this.rightPlaneX + boundMaxY * this.rightPlaneY + boundMinZ * this.rightPlaneZ <= this.rightPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.rightPlaneX + boundMinY * this.rightPlaneY + boundMaxZ * this.rightPlaneZ > this.rightPlaneOffset)
                     {
                        culling &= 55;
                     }
                  }
               }
               else if(this.rightPlaneZ >= 0)
               {
                  if(boundMinX * this.rightPlaneX + boundMinY * this.rightPlaneY + boundMaxZ * this.rightPlaneZ <= this.rightPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.rightPlaneX + boundMaxY * this.rightPlaneY + boundMinZ * this.rightPlaneZ > this.rightPlaneOffset)
                  {
                     culling &= 55;
                  }
               }
               else
               {
                  if(boundMinX * this.rightPlaneX + boundMinY * this.rightPlaneY + boundMinZ * this.rightPlaneZ <= this.rightPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.rightPlaneX + boundMaxY * this.rightPlaneY + boundMaxZ * this.rightPlaneZ > this.rightPlaneOffset)
                  {
                     culling &= 55;
                  }
               }
            }
            if(Boolean(culling & 0x10))
            {
               if(this.topPlaneX >= 0)
               {
                  if(this.topPlaneY >= 0)
                  {
                     if(this.topPlaneZ >= 0)
                     {
                        if(boundMaxX * this.topPlaneX + boundMaxY * this.topPlaneY + boundMaxZ * this.topPlaneZ <= this.topPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.topPlaneX + boundMinY * this.topPlaneY + boundMinZ * this.topPlaneZ > this.topPlaneOffset)
                        {
                           culling &= 47;
                        }
                     }
                     else
                     {
                        if(boundMaxX * this.topPlaneX + boundMaxY * this.topPlaneY + boundMinZ * this.topPlaneZ <= this.topPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.topPlaneX + boundMinY * this.topPlaneY + boundMaxZ * this.topPlaneZ > this.topPlaneOffset)
                        {
                           culling &= 47;
                        }
                     }
                  }
                  else if(this.topPlaneZ >= 0)
                  {
                     if(boundMaxX * this.topPlaneX + boundMinY * this.topPlaneY + boundMaxZ * this.topPlaneZ <= this.topPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.topPlaneX + boundMaxY * this.topPlaneY + boundMinZ * this.topPlaneZ > this.topPlaneOffset)
                     {
                        culling &= 47;
                     }
                  }
                  else
                  {
                     if(boundMaxX * this.topPlaneX + boundMinY * this.topPlaneY + boundMinZ * this.topPlaneZ <= this.topPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.topPlaneX + boundMaxY * this.topPlaneY + boundMaxZ * this.topPlaneZ > this.topPlaneOffset)
                     {
                        culling &= 47;
                     }
                  }
               }
               else if(this.topPlaneY >= 0)
               {
                  if(this.topPlaneZ >= 0)
                  {
                     if(boundMinX * this.topPlaneX + boundMaxY * this.topPlaneY + boundMaxZ * this.topPlaneZ <= this.topPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.topPlaneX + boundMinY * this.topPlaneY + boundMinZ * this.topPlaneZ > this.topPlaneOffset)
                     {
                        culling &= 47;
                     }
                  }
                  else
                  {
                     if(boundMinX * this.topPlaneX + boundMaxY * this.topPlaneY + boundMinZ * this.topPlaneZ <= this.topPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.topPlaneX + boundMinY * this.topPlaneY + boundMaxZ * this.topPlaneZ > this.topPlaneOffset)
                     {
                        culling &= 47;
                     }
                  }
               }
               else if(this.topPlaneZ >= 0)
               {
                  if(boundMinX * this.topPlaneX + boundMinY * this.topPlaneY + boundMaxZ * this.topPlaneZ <= this.topPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.topPlaneX + boundMaxY * this.topPlaneY + boundMinZ * this.topPlaneZ > this.topPlaneOffset)
                  {
                     culling &= 47;
                  }
               }
               else
               {
                  if(boundMinX * this.topPlaneX + boundMinY * this.topPlaneY + boundMinZ * this.topPlaneZ <= this.topPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.topPlaneX + boundMaxY * this.topPlaneY + boundMaxZ * this.topPlaneZ > this.topPlaneOffset)
                  {
                     culling &= 47;
                  }
               }
            }
            if(Boolean(culling & 0x20))
            {
               if(this.bottomPlaneX >= 0)
               {
                  if(this.bottomPlaneY >= 0)
                  {
                     if(this.bottomPlaneZ >= 0)
                     {
                        if(boundMaxX * this.bottomPlaneX + boundMaxY * this.bottomPlaneY + boundMaxZ * this.bottomPlaneZ <= this.bottomPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.bottomPlaneX + boundMinY * this.bottomPlaneY + boundMinZ * this.bottomPlaneZ > this.bottomPlaneOffset)
                        {
                           culling &= 31;
                        }
                     }
                     else
                     {
                        if(boundMaxX * this.bottomPlaneX + boundMaxY * this.bottomPlaneY + boundMinZ * this.bottomPlaneZ <= this.bottomPlaneOffset)
                        {
                           return -1;
                        }
                        if(boundMinX * this.bottomPlaneX + boundMinY * this.bottomPlaneY + boundMaxZ * this.bottomPlaneZ > this.bottomPlaneOffset)
                        {
                           culling &= 31;
                        }
                     }
                  }
                  else if(this.bottomPlaneZ >= 0)
                  {
                     if(boundMaxX * this.bottomPlaneX + boundMinY * this.bottomPlaneY + boundMaxZ * this.bottomPlaneZ <= this.bottomPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.bottomPlaneX + boundMaxY * this.bottomPlaneY + boundMinZ * this.bottomPlaneZ > this.bottomPlaneOffset)
                     {
                        culling &= 31;
                     }
                  }
                  else
                  {
                     if(boundMaxX * this.bottomPlaneX + boundMinY * this.bottomPlaneY + boundMinZ * this.bottomPlaneZ <= this.bottomPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMinX * this.bottomPlaneX + boundMaxY * this.bottomPlaneY + boundMaxZ * this.bottomPlaneZ > this.bottomPlaneOffset)
                     {
                        culling &= 31;
                     }
                  }
               }
               else if(this.bottomPlaneY >= 0)
               {
                  if(this.bottomPlaneZ >= 0)
                  {
                     if(boundMinX * this.bottomPlaneX + boundMaxY * this.bottomPlaneY + boundMaxZ * this.bottomPlaneZ <= this.bottomPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.bottomPlaneX + boundMinY * this.bottomPlaneY + boundMinZ * this.bottomPlaneZ > this.bottomPlaneOffset)
                     {
                        culling &= 31;
                     }
                  }
                  else
                  {
                     if(boundMinX * this.bottomPlaneX + boundMaxY * this.bottomPlaneY + boundMinZ * this.bottomPlaneZ <= this.bottomPlaneOffset)
                     {
                        return -1;
                     }
                     if(boundMaxX * this.bottomPlaneX + boundMinY * this.bottomPlaneY + boundMaxZ * this.bottomPlaneZ > this.bottomPlaneOffset)
                     {
                        culling &= 31;
                     }
                  }
               }
               else if(this.bottomPlaneZ >= 0)
               {
                  if(boundMinX * this.bottomPlaneX + boundMinY * this.bottomPlaneY + boundMaxZ * this.bottomPlaneZ <= this.bottomPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.bottomPlaneX + boundMaxY * this.bottomPlaneY + boundMinZ * this.bottomPlaneZ > this.bottomPlaneOffset)
                  {
                     culling &= 31;
                  }
               }
               else
               {
                  if(boundMinX * this.bottomPlaneX + boundMinY * this.bottomPlaneY + boundMinZ * this.bottomPlaneZ <= this.bottomPlaneOffset)
                  {
                     return -1;
                  }
                  if(boundMaxX * this.bottomPlaneX + boundMaxY * this.bottomPlaneY + boundMaxZ * this.bottomPlaneZ > this.bottomPlaneOffset)
                  {
                     culling &= 31;
                  }
               }
            }
         }
         var i:int = 0;
         while(i < this.numOccluders)
         {
            occluder = this.occluders[i];
            while(occluder != null)
            {
               if(occluder.x >= 0)
               {
                  if(occluder.y >= 0)
                  {
                     if(occluder.z >= 0)
                     {
                        if(boundMaxX * occluder.x + boundMaxY * occluder.y + boundMaxZ * occluder.z > occluder.offset)
                        {
                           break;
                        }
                     }
                     else if(boundMaxX * occluder.x + boundMaxY * occluder.y + boundMinZ * occluder.z > occluder.offset)
                     {
                        break;
                     }
                  }
                  else if(occluder.z >= 0)
                  {
                     if(boundMaxX * occluder.x + boundMinY * occluder.y + boundMaxZ * occluder.z > occluder.offset)
                     {
                        break;
                     }
                  }
                  else if(boundMaxX * occluder.x + boundMinY * occluder.y + boundMinZ * occluder.z > occluder.offset)
                  {
                     break;
                  }
               }
               else if(occluder.y >= 0)
               {
                  if(occluder.z >= 0)
                  {
                     if(boundMinX * occluder.x + boundMaxY * occluder.y + boundMaxZ * occluder.z > occluder.offset)
                     {
                        break;
                     }
                  }
                  else if(boundMinX * occluder.x + boundMaxY * occluder.y + boundMinZ * occluder.z > occluder.offset)
                  {
                     break;
                  }
               }
               else if(occluder.z >= 0)
               {
                  if(boundMinX * occluder.x + boundMinY * occluder.y + boundMaxZ * occluder.z > occluder.offset)
                  {
                     break;
                  }
               }
               else if(boundMinX * occluder.x + boundMinY * occluder.y + boundMinZ * occluder.z > occluder.offset)
               {
                  break;
               }
               occluder = occluder.next;
            }
            if(occluder == null)
            {
               return -1;
            }
            i++;
         }
         return culling;
      }
      
      private function occludeGeometry(camera:Camera3D, geometry:VG) : Boolean
      {
         var occluder:Vertex = null;
         var i:int = geometry.numOccluders;
         while(i < this.numOccluders)
         {
            occluder = this.occluders[i];
            while(occluder != null)
            {
               if(occluder.x >= 0)
               {
                  if(occluder.y >= 0)
                  {
                     if(occluder.z >= 0)
                     {
                        if(geometry.boundMaxX * occluder.x + geometry.boundMaxY * occluder.y + geometry.boundMaxZ * occluder.z > occluder.offset)
                        {
                           break;
                        }
                     }
                     else if(geometry.boundMaxX * occluder.x + geometry.boundMaxY * occluder.y + geometry.boundMinZ * occluder.z > occluder.offset)
                     {
                        break;
                     }
                  }
                  else if(occluder.z >= 0)
                  {
                     if(geometry.boundMaxX * occluder.x + geometry.boundMinY * occluder.y + geometry.boundMaxZ * occluder.z > occluder.offset)
                     {
                        break;
                     }
                  }
                  else if(geometry.boundMaxX * occluder.x + geometry.boundMinY * occluder.y + geometry.boundMinZ * occluder.z > occluder.offset)
                  {
                     break;
                  }
               }
               else if(occluder.y >= 0)
               {
                  if(occluder.z >= 0)
                  {
                     if(geometry.boundMinX * occluder.x + geometry.boundMaxY * occluder.y + geometry.boundMaxZ * occluder.z > occluder.offset)
                     {
                        break;
                     }
                  }
                  else if(geometry.boundMinX * occluder.x + geometry.boundMaxY * occluder.y + geometry.boundMinZ * occluder.z > occluder.offset)
                  {
                     break;
                  }
               }
               else if(occluder.z >= 0)
               {
                  if(geometry.boundMinX * occluder.x + geometry.boundMinY * occluder.y + geometry.boundMaxZ * occluder.z > occluder.offset)
                  {
                     break;
                  }
               }
               else if(geometry.boundMinX * occluder.x + geometry.boundMinY * occluder.y + geometry.boundMinZ * occluder.z > occluder.offset)
               {
                  break;
               }
               occluder = occluder.next;
            }
            if(occluder == null)
            {
               return true;
            }
            i++;
         }
         geometry.numOccluders = this.numOccluders;
         return false;
      }
   }
}

import alternativa.engine3d.alternativa3d;
import alternativa.engine3d.core.Camera3D;
import alternativa.engine3d.core.Face;
import alternativa.engine3d.core.Object3D;
import alternativa.engine3d.core.Shadow;
import alternativa.engine3d.core.Vertex;
import alternativa.engine3d.core.Wrapper;
import alternativa.engine3d.materials.TextureMaterial;
import alternativa.engine3d.objects.BSP;
import alternativa.engine3d.objects.Decal;
import alternativa.engine3d.objects.Mesh;

use namespace alternativa3d;

class KDNode
{
   
   public var negative:KDNode;
   
   public var positive:KDNode;
   
   public var axis:int;
   
   public var coord:Number;
   
   public var minCoord:Number;
   
   public var maxCoord:Number;
   
   public var boundMinX:Number;
   
   public var boundMinY:Number;
   
   public var boundMinZ:Number;
   
   public var boundMaxX:Number;
   
   public var boundMaxY:Number;
   
   public var boundMaxZ:Number;
   
   public var objectList:Object3D;
   
   public var objectBoundList:Object3D;
   
   public var occluderList:Object3D;
   
   public var occluderBoundList:Object3D;
   
   public var receiverList:Receiver;
   
   public function KDNode()
   {
      super();
   }
   
   public function createReceivers(vertices:Vector.<Vector.<Number>>, indices:Vector.<Vector.<uint>>) : void
   {
      var lastReceiver:Receiver = null;
      var receiver:Receiver = null;
      var vertex:Vertex = null;
      var vertexList:Vertex = null;
      var faces:Vector.<Face> = null;
      var facesLength:int = 0;
      var material:TextureMaterial = null;
      var add:int = 0;
      var buffer:int = 0;
      var verts:Vector.<Number> = null;
      var inds:Vector.<uint> = null;
      var vertsLen:int = 0;
      var vertsCount:int = 0;
      var indsLen:int = 0;
      var i:int = 0;
      var face:Face = null;
      var wrapper:Wrapper = null;
      var a:uint = 0;
      var b:uint = 0;
      var c:uint = 0;
      this.receiverList = null;
      for(var object:Object3D = this.objectList; object != null; object = object.next)
      {
         object.composeMatrix();
         receiver = new Receiver();
         if(lastReceiver != null)
         {
            lastReceiver.next = receiver;
         }
         else
         {
            this.receiverList = receiver;
         }
         lastReceiver = receiver;
         if(object is Mesh)
         {
            vertexList = (object as Mesh).vertexList;
            faces = (object as Mesh).faces;
         }
         else if(object is BSP)
         {
            vertexList = (object as BSP).vertexList;
            faces = (object as BSP).faces;
         }
         facesLength = int(faces.length);
         material = faces[0].material as TextureMaterial;
         if(facesLength > 0 && material != null)
         {
            add = 0;
            vertex = vertexList;
            while(vertex != null)
            {
               add++;
               vertex = vertex.next;
            }
            buffer = vertices.length - 1;
            verts = vertices[buffer];
            if(verts.length / 3 + add > 65535)
            {
               buffer++;
               vertices[buffer] = new Vector.<Number>();
               indices[buffer] = new Vector.<uint>();
               verts = vertices[buffer];
            }
            inds = indices[buffer];
            vertsLen = int(verts.length);
            vertsCount = vertsLen / 3;
            indsLen = int(inds.length);
            receiver.buffer = buffer;
            receiver.firstIndex = indsLen;
            receiver.transparent = material.transparent;
            for(vertex = vertexList; vertex != null; vertex = vertex.next)
            {
               verts[vertsLen] = vertex.x * object.ma + vertex.y * object.mb + vertex.z * object.mc + object.md;
               vertsLen++;
               verts[vertsLen] = vertex.x * object.me + vertex.y * object.mf + vertex.z * object.mg + object.mh;
               vertsLen++;
               verts[vertsLen] = vertex.x * object.mi + vertex.y * object.mj + vertex.z * object.mk + object.ml;
               vertsLen++;
               vertex.index = vertsCount;
               vertsCount++;
            }
            for(i = 0; i < facesLength; )
            {
               face = faces[i];
               if(face.normalX * object.mi + face.normalY * object.mj + face.normalZ * object.mk >= -0.5)
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
                     ++receiver.numTriangles;
                     b = c;
                  }
               }
               i++;
            }
         }
      }
      if(this.negative != null)
      {
         this.negative.createReceivers(vertices,indices);
      }
      if(this.positive != null)
      {
         this.positive.createReceivers(vertices,indices);
      }
   }
   
   public function collectReceivers(shadow:Shadow, camera:Camera3D) : void
   {
      var child:Object3D = null;
      var bound:Object3D = null;
      var receiver:Receiver = null;
      var axisX:Boolean = false;
      var axisY:Boolean = false;
      var min:Number = NaN;
      var max:Number = NaN;
      if(this.negative != null)
      {
         axisX = this.axis == 0;
         axisY = this.axis == 1;
         min = axisX ? shadow.boundMinX : (axisY ? shadow.boundMinY : shadow.boundMinZ);
         max = axisX ? shadow.boundMaxX : (axisY ? shadow.boundMaxY : shadow.boundMaxZ);
         if(max <= this.maxCoord)
         {
            this.negative.collectReceivers(shadow,camera);
         }
         else if(min >= this.minCoord)
         {
            this.positive.collectReceivers(shadow,camera);
         }
         else
         {
            if(axisX)
            {
               bound = this.objectBoundList;
               child = this.objectList;
               receiver = this.receiverList;
               while(bound != null)
               {
                  if(receiver.numTriangles > 0 && shadow.boundMinY < bound.boundMaxY && shadow.boundMaxY > bound.boundMinY && shadow.boundMinZ < bound.boundMaxZ && shadow.boundMaxZ > bound.boundMinZ)
                  {
                     if(receiver.transparent)
                     {
                        camera.shadedTransparentObjects[child] = true;
                        child.receivedShadows[child.receivedShadowsCount] = shadow;
                        ++child.receivedShadowsCount;
                     }
                     else
                     {
                        shadow.receiversBuffers[shadow.receiversCount] = receiver.buffer;
                        shadow.receiversFirstIndexes[shadow.receiversCount] = receiver.firstIndex;
                        shadow.receiversNumsTriangles[shadow.receiversCount] = receiver.numTriangles;
                        ++shadow.receiversCount;
                     }
                  }
                  bound = bound.next;
                  child = child.next;
                  receiver = receiver.next;
               }
            }
            else if(axisY)
            {
               bound = this.objectBoundList;
               child = this.objectList;
               receiver = this.receiverList;
               while(bound != null)
               {
                  if(receiver.numTriangles > 0 && shadow.boundMinX < bound.boundMaxX && shadow.boundMaxX > bound.boundMinX && shadow.boundMinZ < bound.boundMaxZ && shadow.boundMaxZ > bound.boundMinZ)
                  {
                     if(receiver.transparent)
                     {
                        camera.shadedTransparentObjects[child] = true;
                        child.receivedShadows[child.receivedShadowsCount] = shadow;
                        ++child.receivedShadowsCount;
                     }
                     else
                     {
                        shadow.receiversBuffers[shadow.receiversCount] = receiver.buffer;
                        shadow.receiversFirstIndexes[shadow.receiversCount] = receiver.firstIndex;
                        shadow.receiversNumsTriangles[shadow.receiversCount] = receiver.numTriangles;
                        ++shadow.receiversCount;
                     }
                  }
                  bound = bound.next;
                  child = child.next;
                  receiver = receiver.next;
               }
            }
            else
            {
               bound = this.objectBoundList;
               child = this.objectList;
               receiver = this.receiverList;
               while(bound != null)
               {
                  if(receiver.numTriangles > 0 && shadow.boundMinX < bound.boundMaxX && shadow.boundMaxX > bound.boundMinX && shadow.boundMinY < bound.boundMaxY && shadow.boundMaxY > bound.boundMinY)
                  {
                     if(receiver.transparent)
                     {
                        camera.shadedTransparentObjects[child] = true;
                        child.receivedShadows[child.receivedShadowsCount] = shadow;
                        ++child.receivedShadowsCount;
                     }
                     else
                     {
                        shadow.receiversBuffers[shadow.receiversCount] = receiver.buffer;
                        shadow.receiversFirstIndexes[shadow.receiversCount] = receiver.firstIndex;
                        shadow.receiversNumsTriangles[shadow.receiversCount] = receiver.numTriangles;
                        ++shadow.receiversCount;
                     }
                  }
                  bound = bound.next;
                  child = child.next;
                  receiver = receiver.next;
               }
            }
            this.negative.collectReceivers(shadow,camera);
            this.positive.collectReceivers(shadow,camera);
         }
      }
      else
      {
         child = this.objectList;
         receiver = this.receiverList;
         while(receiver != null)
         {
            if(receiver.numTriangles > 0)
            {
               if(receiver.transparent)
               {
                  camera.shadedTransparentObjects[child] = true;
                  child.receivedShadows[child.receivedShadowsCount] = shadow;
                  ++child.receivedShadowsCount;
               }
               else
               {
                  shadow.receiversBuffers[shadow.receiversCount] = receiver.buffer;
                  shadow.receiversFirstIndexes[shadow.receiversCount] = receiver.firstIndex;
                  shadow.receiversNumsTriangles[shadow.receiversCount] = receiver.numTriangles;
                  ++shadow.receiversCount;
               }
            }
            child = child.next;
            receiver = receiver.next;
         }
      }
   }
   
   public function collectPolygons(decal:Decal, radius:Number, cos:Number, minX:Number, maxX:Number, minY:Number, maxY:Number, minZ:Number, maxZ:Number) : void
   {
      var child:Object3D = null;
      var bound:Object3D = null;
      var axisX:Boolean = false;
      var axisY:Boolean = false;
      var min:Number = NaN;
      var max:Number = NaN;
      if(this.negative != null)
      {
         axisX = this.axis == 0;
         axisY = this.axis == 1;
         min = axisX ? minX : (axisY ? minY : minZ);
         max = axisX ? maxX : (axisY ? maxY : maxZ);
         if(max <= this.maxCoord)
         {
            this.negative.collectPolygons(decal,radius,cos,minX,maxX,minY,maxY,minZ,maxZ);
         }
         else if(min >= this.minCoord)
         {
            this.positive.collectPolygons(decal,radius,cos,minX,maxX,minY,maxY,minZ,maxZ);
         }
         else
         {
            bound = this.objectBoundList;
            child = this.objectList;
            while(bound != null)
            {
               if(axisX)
               {
                  if(minY < bound.boundMaxY && maxY > bound.boundMinY && minZ < bound.boundMaxZ && maxZ > bound.boundMinZ)
                  {
                     this.clip(decal,radius,cos,child);
                  }
               }
               else if(axisY)
               {
                  if(minX < bound.boundMaxX && maxX > bound.boundMinX && minZ < bound.boundMaxZ && maxZ > bound.boundMinZ)
                  {
                     this.clip(decal,radius,cos,child);
                  }
               }
               else if(minX < bound.boundMaxX && maxX > bound.boundMinX && minY < bound.boundMaxY && maxY > bound.boundMinY)
               {
                  this.clip(decal,radius,cos,child);
               }
               bound = bound.next;
               child = child.next;
            }
            this.negative.collectPolygons(decal,radius,cos,minX,maxX,minY,maxY,minZ,maxZ);
            this.positive.collectPolygons(decal,radius,cos,minX,maxX,minY,maxY,minZ,maxZ);
         }
      }
      else
      {
         for(child = this.objectList; child != null; )
         {
            this.clip(decal,radius,cos,child);
            child = child.next;
         }
      }
   }
   
   private function clip(decal:Decal, radius:Number, cos:Number, object:Object3D) : void
   {
      var face:Face = null;
      var vertex:Vertex = null;
      var wrapper:Wrapper = null;
      var vertexList:Vertex = null;
      var faces:Vector.<Face> = null;
      var facesLength:int = 0;
      var i:int = 0;
      var offset:Number = NaN;
      var t:Number = NaN;
      var a:Vertex = null;
      var b:Vertex = null;
      var v:Vertex = null;
      var vNext:Vertex = null;
      var vFirst:Vertex = null;
      var vLast:Vertex = null;
      var wLast:Wrapper = null;
      if(object is Mesh)
      {
         vertexList = Mesh(object).vertexList;
         face = Mesh(object).faceList;
         if(face.material == null || face.material.transparent)
         {
            return;
         }
         faces = Mesh(object).faces;
      }
      else if(object is BSP)
      {
         vertexList = BSP(object).vertexList;
         faces = BSP(object).faces;
         face = faces[0];
         if(face.material == null || face.material.transparent)
         {
            return;
         }
      }
      object.composeAndAppend(decal);
      object.calculateInverseMatrix();
      ++object.transformId;
      facesLength = int(faces.length);
      for(i = 0; i < facesLength; )
      {
         face = faces[i];
         if(-face.normalX * object.imc - face.normalY * object.img - face.normalZ * object.imk >= cos)
         {
            offset = face.normalX * object.imd + face.normalY * object.imh + face.normalZ * object.iml;
            if(!(offset <= face.offset - radius || offset >= face.offset + radius))
            {
               for(wrapper = face.wrapper; wrapper != null; )
               {
                  vertex = wrapper.vertex;
                  if(vertex.transformId != object.transformId)
                  {
                     vertex.cameraX = object.ma * vertex.x + object.mb * vertex.y + object.mc * vertex.z + object.md;
                     vertex.cameraY = object.me * vertex.x + object.mf * vertex.y + object.mg * vertex.z + object.mh;
                     vertex.cameraZ = object.mi * vertex.x + object.mj * vertex.y + object.mk * vertex.z + object.ml;
                     vertex.transformId = object.transformId;
                  }
                  wrapper = wrapper.next;
               }
               wrapper = face.wrapper;
               loop2:
               while(true)
               {
                  if(wrapper != null)
                  {
                     if(wrapper.vertex.cameraX <= decal.boundMinX)
                     {
                        continue;
                     }
                  }
                  if(wrapper != null)
                  {
                     wrapper = face.wrapper;
                     while(true)
                     {
                        if(wrapper != null)
                        {
                           if(wrapper.vertex.cameraX >= decal.boundMaxX)
                           {
                              continue;
                           }
                        }
                        if(wrapper != null)
                        {
                           wrapper = face.wrapper;
                           while(true)
                           {
                              if(wrapper != null)
                              {
                                 if(wrapper.vertex.cameraY <= decal.boundMinY)
                                 {
                                    continue;
                                 }
                              }
                              if(wrapper != null)
                              {
                                 wrapper = face.wrapper;
                                 while(true)
                                 {
                                    if(wrapper != null)
                                    {
                                       if(wrapper.vertex.cameraY >= decal.boundMaxY)
                                       {
                                          continue;
                                       }
                                    }
                                    if(wrapper != null)
                                    {
                                       wrapper = face.wrapper;
                                       while(true)
                                       {
                                          if(wrapper != null)
                                          {
                                             if(wrapper.vertex.cameraZ <= decal.boundMinZ)
                                             {
                                                continue;
                                             }
                                          }
                                          if(wrapper != null)
                                          {
                                             wrapper = face.wrapper;
                                             while(true)
                                             {
                                                if(wrapper != null)
                                                {
                                                   if(wrapper.vertex.cameraZ >= decal.boundMaxZ)
                                                   {
                                                      continue;
                                                   }
                                                }
                                                if(wrapper != null)
                                                {
                                                   vFirst = null;
                                                   vLast = null;
                                                   for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
                                                   {
                                                      vertex = wrapper.vertex;
                                                      v = new Vertex();
                                                      v.x = vertex.cameraX;
                                                      v.y = vertex.cameraY;
                                                      v.z = vertex.cameraZ;
                                                      v.normalX = object.ma * vertex.normalX + object.mb * vertex.normalY + object.mc * vertex.normalZ;
                                                      v.normalY = object.me * vertex.normalX + object.mf * vertex.normalY + object.mg * vertex.normalZ;
                                                      v.normalZ = object.mi * vertex.normalX + object.mj * vertex.normalY + object.mk * vertex.normalZ;
                                                      if(vLast != null)
                                                      {
                                                         vLast.next = v;
                                                      }
                                                      else
                                                      {
                                                         vFirst = v;
                                                      }
                                                      vLast = v;
                                                   }
                                                   a = vLast;
                                                   b = vFirst;
                                                   vFirst = null;
                                                   vLast = null;
                                                   while(b != null)
                                                   {
                                                      vNext = b.next;
                                                      b.next = null;
                                                      if(b.z > decal.boundMinZ && a.z <= decal.boundMinZ || b.z <= decal.boundMinZ && a.z > decal.boundMinZ)
                                                      {
                                                         t = (decal.boundMinZ - a.z) / (b.z - a.z);
                                                         v = new Vertex();
                                                         v.x = a.x + (b.x - a.x) * t;
                                                         v.y = a.y + (b.y - a.y) * t;
                                                         v.z = a.z + (b.z - a.z) * t;
                                                         v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                                                         v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                                                         v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                                                         if(vLast != null)
                                                         {
                                                            vLast.next = v;
                                                         }
                                                         else
                                                         {
                                                            vFirst = v;
                                                         }
                                                         vLast = v;
                                                      }
                                                      if(b.z > decal.boundMinZ)
                                                      {
                                                         if(vLast != null)
                                                         {
                                                            vLast.next = b;
                                                         }
                                                         else
                                                         {
                                                            vFirst = b;
                                                         }
                                                         vLast = b;
                                                      }
                                                      a = b;
                                                      b = vNext;
                                                   }
                                                   if(vFirst != null)
                                                   {
                                                      a = vLast;
                                                      b = vFirst;
                                                      vFirst = null;
                                                      vLast = null;
                                                      while(b != null)
                                                      {
                                                         vNext = b.next;
                                                         b.next = null;
                                                         if(b.z < decal.boundMaxZ && a.z >= decal.boundMaxZ || b.z >= decal.boundMaxZ && a.z < decal.boundMaxZ)
                                                         {
                                                            t = (decal.boundMaxZ - a.z) / (b.z - a.z);
                                                            v = new Vertex();
                                                            v.x = a.x + (b.x - a.x) * t;
                                                            v.y = a.y + (b.y - a.y) * t;
                                                            v.z = a.z + (b.z - a.z) * t;
                                                            v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                                                            v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                                                            v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                                                            if(vLast != null)
                                                            {
                                                               vLast.next = v;
                                                            }
                                                            else
                                                            {
                                                               vFirst = v;
                                                            }
                                                            vLast = v;
                                                         }
                                                         if(b.z < decal.boundMaxZ)
                                                         {
                                                            if(vLast != null)
                                                            {
                                                               vLast.next = b;
                                                            }
                                                            else
                                                            {
                                                               vFirst = b;
                                                            }
                                                            vLast = b;
                                                         }
                                                         a = b;
                                                         b = vNext;
                                                      }
                                                      if(vFirst != null)
                                                      {
                                                         a = vLast;
                                                         b = vFirst;
                                                         vFirst = null;
                                                         vLast = null;
                                                         while(b != null)
                                                         {
                                                            vNext = b.next;
                                                            b.next = null;
                                                            if(b.x > decal.boundMinX && a.x <= decal.boundMinX || b.x <= decal.boundMinX && a.x > decal.boundMinX)
                                                            {
                                                               t = (decal.boundMinX - a.x) / (b.x - a.x);
                                                               v = new Vertex();
                                                               v.x = a.x + (b.x - a.x) * t;
                                                               v.y = a.y + (b.y - a.y) * t;
                                                               v.z = a.z + (b.z - a.z) * t;
                                                               v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                                                               v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                                                               v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                                                               if(vLast != null)
                                                               {
                                                                  vLast.next = v;
                                                               }
                                                               else
                                                               {
                                                                  vFirst = v;
                                                               }
                                                               vLast = v;
                                                            }
                                                            if(b.x > decal.boundMinX)
                                                            {
                                                               if(vLast != null)
                                                               {
                                                                  vLast.next = b;
                                                               }
                                                               else
                                                               {
                                                                  vFirst = b;
                                                               }
                                                               vLast = b;
                                                            }
                                                            a = b;
                                                            b = vNext;
                                                         }
                                                         if(vFirst != null)
                                                         {
                                                            a = vLast;
                                                            b = vFirst;
                                                            vFirst = null;
                                                            vLast = null;
                                                            while(b != null)
                                                            {
                                                               vNext = b.next;
                                                               b.next = null;
                                                               if(b.x < decal.boundMaxX && a.x >= decal.boundMaxX || b.x >= decal.boundMaxX && a.x < decal.boundMaxX)
                                                               {
                                                                  t = (decal.boundMaxX - a.x) / (b.x - a.x);
                                                                  v = new Vertex();
                                                                  v.x = a.x + (b.x - a.x) * t;
                                                                  v.y = a.y + (b.y - a.y) * t;
                                                                  v.z = a.z + (b.z - a.z) * t;
                                                                  v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                                                                  v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                                                                  v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                                                                  if(vLast != null)
                                                                  {
                                                                     vLast.next = v;
                                                                  }
                                                                  else
                                                                  {
                                                                     vFirst = v;
                                                                  }
                                                                  vLast = v;
                                                               }
                                                               if(b.x < decal.boundMaxX)
                                                               {
                                                                  if(vLast != null)
                                                                  {
                                                                     vLast.next = b;
                                                                  }
                                                                  else
                                                                  {
                                                                     vFirst = b;
                                                                  }
                                                                  vLast = b;
                                                               }
                                                               a = b;
                                                               b = vNext;
                                                            }
                                                            if(vFirst != null)
                                                            {
                                                               a = vLast;
                                                               b = vFirst;
                                                               vFirst = null;
                                                               vLast = null;
                                                               while(b != null)
                                                               {
                                                                  vNext = b.next;
                                                                  b.next = null;
                                                                  if(b.y > decal.boundMinY && a.y <= decal.boundMinY || b.y <= decal.boundMinY && a.y > decal.boundMinY)
                                                                  {
                                                                     t = (decal.boundMinY - a.y) / (b.y - a.y);
                                                                     v = new Vertex();
                                                                     v.x = a.x + (b.x - a.x) * t;
                                                                     v.y = a.y + (b.y - a.y) * t;
                                                                     v.z = a.z + (b.z - a.z) * t;
                                                                     v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                                                                     v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                                                                     v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                                                                     if(vLast != null)
                                                                     {
                                                                        vLast.next = v;
                                                                     }
                                                                     else
                                                                     {
                                                                        vFirst = v;
                                                                     }
                                                                     vLast = v;
                                                                  }
                                                                  if(b.y > decal.boundMinY)
                                                                  {
                                                                     if(vLast != null)
                                                                     {
                                                                        vLast.next = b;
                                                                     }
                                                                     else
                                                                     {
                                                                        vFirst = b;
                                                                     }
                                                                     vLast = b;
                                                                  }
                                                                  a = b;
                                                                  b = vNext;
                                                               }
                                                               if(vFirst != null)
                                                               {
                                                                  a = vLast;
                                                                  b = vFirst;
                                                                  vFirst = null;
                                                                  vLast = null;
                                                                  while(b != null)
                                                                  {
                                                                     vNext = b.next;
                                                                     b.next = null;
                                                                     if(b.y < decal.boundMaxY && a.y >= decal.boundMaxY || b.y >= decal.boundMaxY && a.y < decal.boundMaxY)
                                                                     {
                                                                        t = (decal.boundMaxY - a.y) / (b.y - a.y);
                                                                        v = new Vertex();
                                                                        v.x = a.x + (b.x - a.x) * t;
                                                                        v.y = a.y + (b.y - a.y) * t;
                                                                        v.z = a.z + (b.z - a.z) * t;
                                                                        v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                                                                        v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                                                                        v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                                                                        if(vLast != null)
                                                                        {
                                                                           vLast.next = v;
                                                                        }
                                                                        else
                                                                        {
                                                                           vFirst = v;
                                                                        }
                                                                        vLast = v;
                                                                     }
                                                                     if(b.y < decal.boundMaxY)
                                                                     {
                                                                        if(vLast != null)
                                                                        {
                                                                           vLast.next = b;
                                                                        }
                                                                        else
                                                                        {
                                                                           vFirst = b;
                                                                        }
                                                                        vLast = b;
                                                                     }
                                                                     a = b;
                                                                     b = vNext;
                                                                  }
                                                                  if(vFirst != null)
                                                                  {
                                                                     face = new Face();
                                                                     wLast = null;
                                                                     for(vertex = vFirst; vertex != null; vertex = vNext)
                                                                     {
                                                                        vNext = vertex.next;
                                                                        vertex.next = decal.vertexList;
                                                                        decal.vertexList = vertex;
                                                                        vertex.u = (vertex.x - decal.boundMinX) / (decal.boundMaxX - decal.boundMinX);
                                                                        vertex.v = (vertex.y - decal.boundMinY) / (decal.boundMaxY - decal.boundMinY);
                                                                        if(wLast != null)
                                                                        {
                                                                           wLast.next = new Wrapper();
                                                                           wLast = wLast.next;
                                                                        }
                                                                        else
                                                                        {
                                                                           face.wrapper = new Wrapper();
                                                                           wLast = face.wrapper;
                                                                        }
                                                                        wLast.vertex = vertex;
                                                                     }
                                                                     face.calculateBestSequenceAndNormal();
                                                                     face.next = decal.faceList;
                                                                     decal.faceList = face;
                                                                  }
                                                               }
                                                            }
                                                         }
                                                      }
                                                   }
                                                }
                                                break loop2;
                                                wrapper = wrapper.next;
                                             }
                                             break;
                                          }
                                          break loop2;
                                          wrapper = wrapper.next;
                                       }
                                       break;
                                    }
                                    break loop2;
                                    wrapper = wrapper.next;
                                 }
                                 break;
                              }
                              break loop2;
                              wrapper = wrapper.next;
                           }
                           break;
                        }
                        break loop2;
                        wrapper = wrapper.next;
                     }
                     break;
                  }
                  break;
                  wrapper = wrapper.next;
               }
            }
         }
         i++;
      }
   }
}

class Receiver
{
   
   public var next:Receiver;
   
   public var transparent:Boolean = false;
   
   public var buffer:int = -1;
   
   public var firstIndex:int = -1;
   
   public var numTriangles:int = 0;
   
   public function Receiver()
   {
      super();
   }
}
