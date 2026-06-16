package alternativa.engine3d.primitives
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   
   use namespace alternativa3d;
   
   public class Plane extends Mesh
   {
      
      public function Plane(width:Number = 100, length:Number = 100, widthSegments:uint = 1, lengthSegments:uint = 1, twoSided:Boolean = true, reverse:Boolean = false, triangulate:Boolean = false, bottom:Material = null, top:Material = null)
      {
         var x:int = 0;
         var y:int = 0;
         var z:int = 0;
         super();
         if(widthSegments < 1)
         {
            throw new ArgumentError(widthSegments + " width segments not enough.");
         }
         if(lengthSegments < 1)
         {
            throw new ArgumentError(lengthSegments + " length segments not enough.");
         }
         var wp:int = widthSegments + 1;
         var lp:int = lengthSegments + 1;
         var wh:Number = width * 0.5;
         var lh:Number = length * 0.5;
         var wd:Number = 1 / widthSegments;
         var ld:Number = 1 / lengthSegments;
         var ws:Number = width / widthSegments;
         var ls:Number = length / lengthSegments;
         var vertices:Vector.<Vertex> = new Vector.<Vertex>();
         var verticesLength:int = 0;
         for(x = 0; x < wp; x++)
         {
            for(y = 0; y < lp; y++)
            {
               vertices[verticesLength++] = this.createVertex(x * ws - wh,y * ls - lh,0,x * wd,(lengthSegments - y) * ld);
            }
         }
         for(x = 0; x < wp; x++)
         {
            for(y = 0; y < lp; y++)
            {
               if(x < widthSegments && y < lengthSegments)
               {
                  this.createFace(vertices[x * lp + y],vertices[(x + 1) * lp + y],vertices[(x + 1) * lp + y + 1],vertices[x * lp + y + 1],0,0,1,0,reverse,triangulate,top);
               }
            }
         }
         if(twoSided)
         {
            verticesLength = 0;
            for(x = 0; x < wp; x++)
            {
               for(y = 0; y < lp; y++)
               {
                  vertices[verticesLength++] = this.createVertex(x * ws - wh,y * ls - lh,0,(widthSegments - x) * wd,(lengthSegments - y) * ld);
               }
            }
            for(x = 0; x < wp; x++)
            {
               for(y = 0; y < lp; y++)
               {
                  if(x < widthSegments && y < lengthSegments)
                  {
                     this.createFace(vertices[(x + 1) * lp + y + 1],vertices[(x + 1) * lp + y],vertices[x * lp + y],vertices[x * lp + y + 1],0,0,-1,0,reverse,triangulate,bottom);
                  }
               }
            }
         }
         boundMinX = -wh;
         boundMinY = -lh;
         boundMinZ = 0;
         boundMaxX = wh;
         boundMaxY = lh;
         boundMaxZ = 0;
      }
      
      private function createVertex(x:Number, y:Number, z:Number, u:Number, v:Number) : Vertex
      {
         var vertex:Vertex = new Vertex();
         vertex.x = x;
         vertex.y = y;
         vertex.z = z;
         vertex.u = u;
         vertex.v = v;
         vertex.next = vertexList;
         vertexList = vertex;
         return vertex;
      }
      
      private function createFace(a:Vertex, b:Vertex, c:Vertex, d:Vertex, nx:Number, ny:Number, nz:Number, no:Number, reverse:Boolean, triangulate:Boolean, material:Material) : void
      {
         var v:Vertex = null;
         var face:Face = null;
         if(reverse)
         {
            nx = -nx;
            ny = -ny;
            nz = -nz;
            no = -no;
            v = a;
            a = d;
            d = v;
            v = b;
            b = c;
            c = v;
         }
         if(triangulate)
         {
            face = new Face();
            face.material = material;
            face.wrapper = new Wrapper();
            face.wrapper.vertex = a;
            face.wrapper.next = new Wrapper();
            face.wrapper.next.vertex = b;
            face.wrapper.next.next = new Wrapper();
            face.wrapper.next.next.vertex = c;
            face.normalX = nx;
            face.normalY = ny;
            face.normalZ = nz;
            face.offset = no;
            face.next = faceList;
            faceList = face;
            face = new Face();
            face.material = material;
            face.wrapper = new Wrapper();
            face.wrapper.vertex = a;
            face.wrapper.next = new Wrapper();
            face.wrapper.next.vertex = c;
            face.wrapper.next.next = new Wrapper();
            face.wrapper.next.next.vertex = d;
            face.normalX = nx;
            face.normalY = ny;
            face.normalZ = nz;
            face.offset = no;
            face.next = faceList;
            faceList = face;
         }
         else
         {
            face = new Face();
            face.material = material;
            face.wrapper = new Wrapper();
            face.wrapper.vertex = a;
            face.wrapper.next = new Wrapper();
            face.wrapper.next.vertex = b;
            face.wrapper.next.next = new Wrapper();
            face.wrapper.next.next.vertex = c;
            face.wrapper.next.next.next = new Wrapper();
            face.wrapper.next.next.next.vertex = d;
            face.normalX = nx;
            face.normalY = ny;
            face.normalZ = nz;
            face.offset = no;
            face.next = faceList;
            faceList = face;
         }
      }
      
      override public function clone() : Object3D
      {
         var res:Plane = new Plane();
         res.clonePropertiesFrom(this);
         return res;
      }
   }
}

