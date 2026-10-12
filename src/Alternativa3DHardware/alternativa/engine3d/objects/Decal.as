package alternativa.engine3d.objects
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   
   use namespace alternativa3d;
   
   public class Decal extends Mesh
   {
      
      public var attenuation:Number = 1000000;
      
      public function Decal()
      {
         super();
      }
      
      public function createGeometry(sourceGeometry:Mesh, clearSource:Boolean = false) : void
      {
         if(!clearSource)
         {
            sourceGeometry = sourceGeometry.clone() as Mesh;
         }
         faceList = sourceGeometry.faceList;
         vertexList = sourceGeometry.vertexList;
         sourceGeometry.faceList = null;
         sourceGeometry.vertexList = null;
         for(var vertex:Vertex = vertexList; vertex != null; vertex = vertex.next)
         {
            vertex.transformId = 0;
            vertex.id = null;
         }
         for(var face:Face = faceList; face != null; face = face.next)
         {
            face.id = null;
         }
         calculateBounds();
      }
      
      override public function clone() : Object3D
      {
         var res:Decal = new Decal();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         super.clonePropertiesFrom(source);
         var src:Decal = source as Decal;
         this.attenuation = src.attenuation;
      }
      
      override alternativa3d function draw(camera:Camera3D) : void
      {
         var vertex:Vertex = null;
         var next:Face = null;
         if(faceList == null)
         {
            return;
         }
         if(clipping == 0)
         {
            if(Boolean(culling & 1))
            {
               return;
            }
            culling = 0;
         }
         useDepth = true;
         var debug:int = camera.debug ? camera.checkInDebug(this) : 0;
         if(Boolean(debug & Debug.BOUNDS))
         {
            Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
         }
         if(transformId > 500000000)
         {
            transformId = 0;
            vertex = vertexList;
            while(vertex != null)
            {
               vertex.transformId = 0;
               vertex = vertex.next;
            }
         }
         ++transformId;
         calculateInverseMatrix();
         var list:Face = prepareFaces(camera,faceList);
         if(list == null)
         {
            return;
         }
         if(Boolean(debug & Debug.EDGES))
         {
            Debug.drawEdges(camera,list,16777215);
         }
         for(var face:Face = list; face != null; face = next)
         {
            next = face.processNext;
            if(next == null || next.material != list.material)
            {
               face.processNext = null;
               if(list.material != null)
               {
                  camera.addDecal(list,this);
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
      }
      
      override alternativa3d function getVG(camera:Camera3D) : VG
      {
         this.draw(camera);
         return null;
      }
      
      override alternativa3d function prepareResources() : void
      {
      }
      
      override alternativa3d function deleteResources() : void
      {
      }
   }
}

