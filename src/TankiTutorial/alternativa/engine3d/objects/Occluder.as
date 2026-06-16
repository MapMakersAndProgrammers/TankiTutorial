package alternativa.engine3d.objects
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import flash.display.Sprite;
   
   use namespace alternativa3d;
   
   public class Occluder extends Object3D
   {
      
      alternativa3d var faceList:Face;
      
      alternativa3d var edgeList:Edge;
      
      alternativa3d var vertexList:Vertex;
      
      public var minSize:Number = 0;
      
      public function Occluder()
      {
         super();
      }
      
      public function createForm(sourceGeometry:Mesh, clearSource:Boolean = false) : void
      {
         this.destroyForm();
         if(!clearSource)
         {
            sourceGeometry = sourceGeometry.clone() as Mesh;
         }
         this.faceList = sourceGeometry.faceList;
         this.vertexList = sourceGeometry.vertexList;
         sourceGeometry.faceList = null;
         sourceGeometry.vertexList = null;
         for(var vertex:Vertex = this.vertexList; vertex != null; vertex = vertex.next)
         {
            vertex.transformId = 0;
            vertex.id = null;
         }
         for(var face:Face = this.faceList; face != null; face = face.next)
         {
            face.id = null;
         }
         var error:String = this.calculateEdges();
         if(error != null)
         {
            this.destroyForm();
            throw new ArgumentError(error);
         }
         calculateBounds();
      }
      
      public function destroyForm() : void
      {
         this.faceList = null;
         this.edgeList = null;
         this.vertexList = null;
      }
      
      override public function clone() : Object3D
      {
         var res:Occluder = new Occluder();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         var vertex:Vertex = null;
         var face:Face = null;
         var lastVertex:Vertex = null;
         var lastFace:Face = null;
         var lastEdge:Edge = null;
         var newVertex:Vertex = null;
         var newFace:Face = null;
         var lastWrapper:Wrapper = null;
         var wrapper:Wrapper = null;
         var newWrapper:Wrapper = null;
         var newEdge:Edge = null;
         super.clonePropertiesFrom(source);
         var src:Occluder = source as Occluder;
         this.minSize = src.minSize;
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
         for(face = src.faceList; face != null; face = face.next)
         {
            newFace = new Face();
            newFace.material = face.material;
            newFace.normalX = face.normalX;
            newFace.normalY = face.normalY;
            newFace.normalZ = face.normalZ;
            newFace.offset = face.offset;
            face.processNext = newFace;
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
         for(var edge:Edge = src.edgeList; edge != null; edge = edge.next)
         {
            newEdge = new Edge();
            newEdge.a = edge.a.value;
            newEdge.b = edge.b.value;
            newEdge.left = edge.left.processNext;
            newEdge.right = edge.right.processNext;
            if(lastEdge != null)
            {
               lastEdge.next = newEdge;
            }
            else
            {
               this.edgeList = newEdge;
            }
            lastEdge = newEdge;
         }
         for(vertex = src.vertexList; vertex != null; vertex = vertex.next)
         {
            vertex.value = null;
         }
         for(face = src.faceList; face != null; face = face.next)
         {
            face.processNext = null;
         }
      }
      
      private function calculateEdges() : String
      {
         var face:Face = null;
         var wrapper:Wrapper = null;
         var edge:Edge = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var crx:Number = NaN;
         var cry:Number = NaN;
         var crz:Number = NaN;
         for(face = this.faceList; face != null; face = face.next)
         {
            face.calculateBestSequenceAndNormal();
            for(wrapper = face.wrapper; wrapper != null; )
            {
               a = wrapper.vertex;
               b = wrapper.next != null ? wrapper.next.vertex : face.wrapper.vertex;
               edge = this.edgeList;
               while(true)
               {
                  if(edge != null)
                  {
                     if(edge.a == a && edge.b == b)
                     {
                        return "The supplied geometry is not valid.";
                     }
                     if(!(edge.a == b && edge.b == a))
                     {
                        continue;
                     }
                  }
                  if(edge != null)
                  {
                     edge.right = face;
                  }
                  else
                  {
                     edge = new Edge();
                     edge.a = a;
                     edge.b = b;
                     edge.left = face;
                     edge.next = this.edgeList;
                     this.edgeList = edge;
                  }
                  wrapper = wrapper.next;
                  a = b;
                  break;
                  edge = edge.next;
               }
            }
         }
         for(edge = this.edgeList; edge != null; edge = edge.next)
         {
            if(edge.left == null || edge.right == null)
            {
               return "The supplied geometry is non whole.";
            }
            abx = edge.b.x - edge.a.x;
            aby = edge.b.y - edge.a.y;
            abz = edge.b.z - edge.a.z;
            crx = edge.right.normalZ * edge.left.normalY - edge.right.normalY * edge.left.normalZ;
            cry = edge.right.normalX * edge.left.normalZ - edge.right.normalZ * edge.left.normalX;
            crz = edge.right.normalY * edge.left.normalX - edge.right.normalX * edge.left.normalY;
            if(abx * crx + aby * cry + abz * crz < 0)
            {
               trace("Warning: " + this + ": geometry is non convex.");
            }
         }
         return null;
      }
      
      override alternativa3d function draw(camera:Camera3D) : void
      {
         var debug:int = 0;
         var canvas:Sprite = null;
         var occluder:Vertex = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var bz:Number = NaN;
         var t:Number = NaN;
         var projected:Vertex = null;
         var frame:Vertex = null;
         var square:Number = NaN;
         if(this.faceList == null || this.edgeList == null)
         {
            return;
         }
         calculateInverseMatrix();
         var cameraInside:Boolean = true;
         for(var face:Face = this.faceList; face != null; )
         {
            if(face.normalX * imd + face.normalY * imh + face.normalZ * iml > face.offset)
            {
               face.distance = 1;
               cameraInside = false;
            }
            else
            {
               face.distance = 0;
            }
            face = face.next;
         }
         if(cameraInside)
         {
            return;
         }
         var num:int = 0;
         var occludeAll:Boolean = true;
         var viewSizeX:Number = camera.viewSizeX;
         var viewSizeY:Number = camera.viewSizeY;
         for(var edge:Edge = this.edgeList; edge != null; edge = edge.next)
         {
            if(edge.left.distance != edge.right.distance)
            {
               if(edge.left.distance > 0)
               {
                  a = edge.a;
                  b = edge.b;
               }
               else
               {
                  a = edge.b;
                  b = edge.a;
               }
               ax = ma * a.x + mb * a.y + mc * a.z + md;
               ay = me * a.x + mf * a.y + mg * a.z + mh;
               az = mi * a.x + mj * a.y + mk * a.z + ml;
               bx = ma * b.x + mb * b.y + mc * b.z + md;
               by = me * b.x + mf * b.y + mg * b.z + mh;
               bz = mi * b.x + mj * b.y + mk * b.z + ml;
               if(culling > 0)
               {
                  if(az <= -ax && bz <= -bx)
                  {
                     if(occludeAll && by * ax - bx * ay > 0)
                     {
                        occludeAll = false;
                     }
                     continue;
                  }
                  if(bz > -bx && az <= -ax)
                  {
                     t = (ax + az) / (ax + az - bx - bz);
                     ax += (bx - ax) * t;
                     ay += (by - ay) * t;
                     az += (bz - az) * t;
                  }
                  else if(bz <= -bx && az > -ax)
                  {
                     t = (ax + az) / (ax + az - bx - bz);
                     bx = ax + (bx - ax) * t;
                     by = ay + (by - ay) * t;
                     bz = az + (bz - az) * t;
                  }
                  if(az <= ax && bz <= bx)
                  {
                     if(occludeAll && by * ax - bx * ay > 0)
                     {
                        occludeAll = false;
                     }
                     continue;
                  }
                  if(bz > bx && az <= ax)
                  {
                     t = (az - ax) / (az - ax + bx - bz);
                     ax += (bx - ax) * t;
                     ay += (by - ay) * t;
                     az += (bz - az) * t;
                  }
                  else if(bz <= bx && az > ax)
                  {
                     t = (az - ax) / (az - ax + bx - bz);
                     bx = ax + (bx - ax) * t;
                     by = ay + (by - ay) * t;
                     bz = az + (bz - az) * t;
                  }
                  if(az <= -ay && bz <= -by)
                  {
                     if(occludeAll && by * ax - bx * ay > 0)
                     {
                        occludeAll = false;
                     }
                     continue;
                  }
                  if(bz > -by && az <= -ay)
                  {
                     t = (ay + az) / (ay + az - by - bz);
                     ax += (bx - ax) * t;
                     ay += (by - ay) * t;
                     az += (bz - az) * t;
                  }
                  else if(bz <= -by && az > -ay)
                  {
                     t = (ay + az) / (ay + az - by - bz);
                     bx = ax + (bx - ax) * t;
                     by = ay + (by - ay) * t;
                     bz = az + (bz - az) * t;
                  }
                  if(az <= ay && bz <= by)
                  {
                     if(occludeAll && by * ax - bx * ay > 0)
                     {
                        occludeAll = false;
                     }
                     continue;
                  }
                  if(bz > by && az <= ay)
                  {
                     t = (az - ay) / (az - ay + by - bz);
                     ax += (bx - ax) * t;
                     ay += (by - ay) * t;
                     az += (bz - az) * t;
                  }
                  else if(bz <= by && az > ay)
                  {
                     t = (az - ay) / (az - ay + by - bz);
                     bx = ax + (bx - ax) * t;
                     by = ay + (by - ay) * t;
                     bz = az + (bz - az) * t;
                  }
                  occludeAll = false;
               }
               a = a.create();
               a.next = occluder;
               num++;
               occluder = a;
               occluder.cameraX = bz * ay - by * az;
               occluder.cameraY = bx * az - bz * ax;
               occluder.cameraZ = by * ax - bx * ay;
               occluder.x = ax;
               occluder.y = ay;
               occluder.z = az;
               occluder.u = bx;
               occluder.v = by;
               occluder.offset = bz;
            }
         }
         if(occluder != null)
         {
            if(this.minSize > 0)
            {
               projected = Vertex.createList(num);
               a = occluder;
               b = projected;
               while(a != null)
               {
                  b.x = a.x * viewSizeX / a.z;
                  b.y = a.y * viewSizeY / a.z;
                  b.u = a.u * viewSizeX / a.offset;
                  b.v = a.v * viewSizeY / a.offset;
                  b.cameraX = b.y - b.v;
                  b.cameraY = b.u - b.x;
                  b.offset = b.cameraX * b.x + b.cameraY * b.y;
                  a = a.next;
                  b = b.next;
               }
               if(culling > 0)
               {
                  if(Boolean(culling & 4))
                  {
                     ax = -camera.viewSizeX;
                     ay = -camera.viewSizeY;
                     bx = -camera.viewSizeX;
                     by = camera.viewSizeY;
                     for(a = projected; a != null; )
                     {
                        az = ax * a.cameraX + ay * a.cameraY - a.offset;
                        bz = bx * a.cameraX + by * a.cameraY - a.offset;
                        if(!(az < 0 || bz < 0))
                        {
                           break;
                        }
                        if(az >= 0 && bz < 0)
                        {
                           t = az / (az - bz);
                           ax += (bx - ax) * t;
                           ay += (by - ay) * t;
                        }
                        else if(az < 0 && bz >= 0)
                        {
                           t = az / (az - bz);
                           bx = ax + (bx - ax) * t;
                           by = ay + (by - ay) * t;
                        }
                        a = a.next;
                     }
                     if(a == null)
                     {
                        b = occluder.create();
                        b.next = frame;
                        frame = b;
                        frame.x = ax;
                        frame.y = ay;
                        frame.u = bx;
                        frame.v = by;
                     }
                  }
                  if(Boolean(culling & 8))
                  {
                     ax = camera.viewSizeX;
                     ay = camera.viewSizeY;
                     bx = camera.viewSizeX;
                     by = -camera.viewSizeY;
                     for(a = projected; a != null; )
                     {
                        az = ax * a.cameraX + ay * a.cameraY - a.offset;
                        bz = bx * a.cameraX + by * a.cameraY - a.offset;
                        if(!(az < 0 || bz < 0))
                        {
                           break;
                        }
                        if(az >= 0 && bz < 0)
                        {
                           t = az / (az - bz);
                           ax += (bx - ax) * t;
                           ay += (by - ay) * t;
                        }
                        else if(az < 0 && bz >= 0)
                        {
                           t = az / (az - bz);
                           bx = ax + (bx - ax) * t;
                           by = ay + (by - ay) * t;
                        }
                        a = a.next;
                     }
                     if(a == null)
                     {
                        b = occluder.create();
                        b.next = frame;
                        frame = b;
                        frame.x = ax;
                        frame.y = ay;
                        frame.u = bx;
                        frame.v = by;
                     }
                  }
                  if(Boolean(culling & 0x10))
                  {
                     ax = camera.viewSizeX;
                     ay = -camera.viewSizeY;
                     bx = -camera.viewSizeX;
                     by = -camera.viewSizeY;
                     for(a = projected; a != null; )
                     {
                        az = ax * a.cameraX + ay * a.cameraY - a.offset;
                        bz = bx * a.cameraX + by * a.cameraY - a.offset;
                        if(!(az < 0 || bz < 0))
                        {
                           break;
                        }
                        if(az >= 0 && bz < 0)
                        {
                           t = az / (az - bz);
                           ax += (bx - ax) * t;
                           ay += (by - ay) * t;
                        }
                        else if(az < 0 && bz >= 0)
                        {
                           t = az / (az - bz);
                           bx = ax + (bx - ax) * t;
                           by = ay + (by - ay) * t;
                        }
                        a = a.next;
                     }
                     if(a == null)
                     {
                        b = occluder.create();
                        b.next = frame;
                        frame = b;
                        frame.x = ax;
                        frame.y = ay;
                        frame.u = bx;
                        frame.v = by;
                     }
                  }
                  if(Boolean(culling & 0x20))
                  {
                     ax = -camera.viewSizeX;
                     ay = camera.viewSizeY;
                     bx = camera.viewSizeX;
                     by = camera.viewSizeY;
                     for(a = projected; a != null; )
                     {
                        az = ax * a.cameraX + ay * a.cameraY - a.offset;
                        bz = bx * a.cameraX + by * a.cameraY - a.offset;
                        if(!(az < 0 || bz < 0))
                        {
                           break;
                        }
                        if(az >= 0 && bz < 0)
                        {
                           t = az / (az - bz);
                           ax += (bx - ax) * t;
                           ay += (by - ay) * t;
                        }
                        else if(az < 0 && bz >= 0)
                        {
                           t = az / (az - bz);
                           bx = ax + (bx - ax) * t;
                           by = ay + (by - ay) * t;
                        }
                        a = a.next;
                     }
                     if(a == null)
                     {
                        b = occluder.create();
                        b.next = frame;
                        frame = b;
                        frame.x = ax;
                        frame.y = ay;
                        frame.u = bx;
                        frame.v = by;
                     }
                  }
               }
               square = 0;
               az = projected.x;
               bz = projected.y;
               for(a = projected; a.next != null; )
               {
                  a = a.next;
               }
               a.next = frame;
               a = projected;
               while(a != null)
               {
                  square += (a.u - az) * (a.y - bz) - (a.v - bz) * (a.x - az);
                  if(a.next == null)
                  {
                     break;
                  }
                  a = a.next;
               }
               a.next = Vertex.collector;
               Vertex.collector = projected;
               if(square / (camera.viewSizeX * camera.viewSizeY * 8) < this.minSize)
               {
                  for(a = occluder; a.next != null; )
                  {
                     a = a.next;
                  }
                  a.next = Vertex.collector;
                  Vertex.collector = occluder;
                  return;
               }
            }
            if(camera.debug && (debug = camera.checkInDebug(this)) > 0)
            {
               if(Boolean(debug & Debug.EDGES))
               {
                  for(a = occluder; a != null; a = a.next)
                  {
                     ax = a.x * viewSizeX / a.z;
                     ay = a.y * viewSizeY / a.z;
                     bx = a.u * viewSizeX / a.offset;
                     by = a.v * viewSizeY / a.offset;
                     canvas = camera.view.canvas;
                     canvas.graphics.moveTo(ax,ay);
                     canvas.graphics.lineStyle(3,255);
                     canvas.graphics.lineTo(ax + (bx - ax) * 0.8,ay + (by - ay) * 0.8);
                     canvas.graphics.lineStyle(3,16711680);
                     canvas.graphics.lineTo(bx,by);
                  }
               }
               if(Boolean(debug & Debug.BOUNDS))
               {
                  Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            camera.occluders[camera.numOccluders] = occluder;
            ++camera.numOccluders;
         }
         else if(occludeAll)
         {
            if(camera.debug && (debug = camera.checkInDebug(this)) > 0)
            {
               if(Boolean(debug & Debug.EDGES))
               {
                  t = 1.5;
                  canvas = camera.view.canvas;
                  canvas.graphics.moveTo(-viewSizeX + t,-viewSizeY + t);
                  canvas.graphics.lineStyle(3,255);
                  canvas.graphics.lineTo(-viewSizeX + t,viewSizeY * 0.6);
                  canvas.graphics.lineStyle(3,16711680);
                  canvas.graphics.lineTo(-viewSizeX + t,viewSizeY - t);
                  canvas.graphics.lineStyle(3,255);
                  canvas.graphics.lineTo(viewSizeX * 0.6,viewSizeY - t);
                  canvas.graphics.lineStyle(3,16711680);
                  canvas.graphics.lineTo(viewSizeX - t,viewSizeY - t);
                  canvas.graphics.lineStyle(3,255);
                  canvas.graphics.lineTo(viewSizeX - t,-viewSizeY * 0.6);
                  canvas.graphics.lineStyle(3,16711680);
                  canvas.graphics.lineTo(viewSizeX - t,-viewSizeY + t);
                  canvas.graphics.lineStyle(3,255);
                  canvas.graphics.lineTo(-viewSizeX * 0.6,-viewSizeY + t);
                  canvas.graphics.lineStyle(3,16711680);
                  canvas.graphics.lineTo(-viewSizeX + t,-viewSizeY + t);
               }
               if(Boolean(debug & Debug.BOUNDS))
               {
                  Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            camera.clearOccluders();
            camera.occludedAll = true;
         }
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
   }
}

import alternativa.engine3d.core.Face;
import alternativa.engine3d.core.Vertex;

class Edge
{
   
   public var next:Edge;
   
   public var a:Vertex;
   
   public var b:Vertex;
   
   public var left:Face;
   
   public var right:Face;
   
   public function Edge()
   {
      super();
   }
}
