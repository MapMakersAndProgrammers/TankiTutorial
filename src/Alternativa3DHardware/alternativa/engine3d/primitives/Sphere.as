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
   
   public class Sphere extends Mesh
   {
      
      public function Sphere(radius:Number = 100, radialSegments:uint = 8, heightSegments:uint = 8, reverse:Boolean = false, material:Material = null)
      {
         var radial:uint = 0;
         var segment:uint = 0;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var currentHeightAngle:Number = NaN;
         var segmentRadius:Number = NaN;
         var segmentZ:Number = NaN;
         var currentRadialAngle:Number = NaN;
         super();
         if(radialSegments < 3)
         {
            throw new ArgumentError(radialSegments + " radial segments not enough.");
         }
         if(heightSegments < 2)
         {
            throw new ArgumentError(heightSegments + " height segments not enough.");
         }
         radius = radius < 0 ? 0 : radius;
         var map:Object = new Object();
         var radialAngle:Number = Math.PI * 2 / radialSegments;
         var heightAngle:Number = Math.PI * 2 / (heightSegments << 1);
         for(segment = 0; segment <= heightSegments; segment++)
         {
            currentHeightAngle = heightAngle * segment;
            segmentRadius = Math.sin(currentHeightAngle) * radius;
            segmentZ = Math.cos(currentHeightAngle) * radius;
            for(radial = 0; radial <= radialSegments; radial++)
            {
               currentRadialAngle = radialAngle * radial;
               this.createVertex(-Math.sin(currentRadialAngle) * segmentRadius,Math.cos(currentRadialAngle) * segmentRadius,segmentZ,radial / radialSegments,segment / heightSegments,radial + "_" + segment,map);
            }
         }
         var prevRadial:uint = 0;
         for(radial = 1; radial <= radialSegments; radial++)
         {
            for(segment = 0; segment < heightSegments; )
            {
               if(segment < heightSegments - 1)
               {
                  a = map[prevRadial + "_" + segment];
                  b = map[prevRadial + "_" + (segment + 1)];
                  c = map[radial + "_" + (segment + 1)];
                  if(reverse)
                  {
                     this.createFace(a,c,b,material);
                  }
                  else
                  {
                     this.createFace(a,b,c,material);
                  }
               }
               if(segment > 0)
               {
                  a = map[radial + "_" + (segment + 1)];
                  b = map[radial + "_" + segment];
                  c = map[prevRadial + "_" + segment];
                  if(reverse)
                  {
                     this.createFace(a,c,b,material);
                  }
                  else
                  {
                     this.createFace(a,b,c,material);
                  }
               }
               segment++;
            }
            prevRadial = radial;
         }
         calculateFacesNormals(true);
         boundMinX = -radius;
         boundMinY = -radius;
         boundMinZ = -radius;
         boundMaxX = radius;
         boundMaxY = radius;
         boundMaxZ = radius;
      }
      
      private function createVertex(x:Number, y:Number, z:Number, u:Number, v:Number, id:String, map:Object) : Vertex
      {
         var vertex:Vertex = new Vertex();
         vertex.x = x;
         vertex.y = y;
         vertex.z = z;
         vertex.u = u;
         vertex.v = v;
         vertex.next = vertexList;
         vertexList = vertex;
         map[id] = vertex;
         return vertex;
      }
      
      private function createFace(a:Vertex, b:Vertex, c:Vertex, material:Material) : void
      {
         var face:Face = new Face();
         face.material = material;
         face.wrapper = new Wrapper();
         face.wrapper.vertex = a;
         face.wrapper.next = new Wrapper();
         face.wrapper.next.vertex = b;
         face.wrapper.next.next = new Wrapper();
         face.wrapper.next.next.vertex = c;
         face.next = faceList;
         faceList = face;
      }
      
      override public function clone() : Object3D
      {
         var res:Sphere = new Sphere();
         res.clonePropertiesFrom(this);
         return res;
      }
   }
}

