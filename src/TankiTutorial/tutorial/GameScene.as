package tutorial
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Occluder;
   
   public class GameScene
   {
      
      private var objects:Vector.<Object3D> = new Vector.<Object3D>();
      
      private var dynamics:Vector.<Object3D> = new Vector.<Object3D>();
      
      private var occluders:Vector.<Occluder> = new Vector.<Occluder>();
      
      private var namedObjects:Object = new Object();
      
      private var changed:Boolean = false;
      
      private var helperMesh:HelperMesh;
      
      public function GameScene()
      {
         super();
      }
      
      public function addObject(object:Object3D) : void
      {
         this.objects.push(object);
         if(object.name != null)
         {
            this.namedObjects[object.name] = object;
         }
         this.changed = true;
      }
      
      public function addOccluder(occluder:Occluder) : void
      {
         this.occluders.push(occluder);
      }
      
      public function addDynamic(object:Object3D) : void
      {
         this.dynamics.push(object);
         if(object.name != null)
         {
            this.namedObjects[object.name] = object;
         }
         this.changed = true;
      }
      
      public function getObject(name:String) : Object3D
      {
         return this.namedObjects[name];
      }
      
      public function buildKDTree(kdContainer:KDContainer) : void
      {
         var smoothed:Object = null;
         var mesh:Mesh = null;
         var i:int = 0;
         var len:int = 0;
         var object:Object3D = null;
         var face:Face = null;
         var bsp:BSP = null;
         if(this.changed)
         {
            smoothed = new Object();
            smoothed["hang_1"] = true;
            smoothed["hang_2"] = true;
            smoothed["hang_3"] = true;
            smoothed["SmHouse008"] = true;
            smoothed["wall_broke_1"] = true;
            smoothed["wall_broke_2"] = true;
            smoothed["Bk_roof1"] = true;
            smoothed["Bk_roof2"] = true;
            smoothed["Tree01"] = true;
            smoothed["Tree02"] = true;
            smoothed["tube_1"] = true;
            smoothed["tube_2"] = true;
            smoothed["tube_3"] = true;
            smoothed["tube_cor"] = true;
            smoothed["cliff_3"] = true;
            smoothed["cliff_1"] = true;
            smoothed["cliff_2"] = true;
            smoothed["cliff_4"] = true;
            smoothed["cliff_inco"] = true;
            smoothed["cliff_cor"] = true;
            smoothed["cliff_r2"] = true;
            smoothed["cliff_ri"] = true;
            smoothed["Big_Rock04"] = true;
            smoothed["Big_Rock"] = true;
            smoothed["Change01"] = true;
            smoothed["Change02"] = true;
            smoothed["Corn1"] = true;
            smoothed["Corn2"] = true;
            smoothed["Corn3"] = true;
            smoothed["Corn4"] = true;
            smoothed["Corn_B"] = true;
            smoothed["crater"] = true;
            smoothed["Land02"] = true;
            smoothed["Land03"] = true;
            smoothed["Land04"] = true;
            smoothed["Land05"] = true;
            smoothed["Land06"] = true;
            smoothed["Land07"] = true;
            smoothed["Land08"] = true;
            smoothed["Land09"] = true;
            smoothed["Land22"] = true;
            smoothed["Land33"] = true;
            smoothed["Line"] = true;
            smoothed["Med_Rock"] = true;
            smoothed["rise_g1"] = true;
            smoothed["rise_g2"] = true;
            smoothed["rise_g3"] = true;
            smoothed["rise_g4"] = true;
            smoothed["rise_g5"] = true;
            smoothed["rise_g6"] = true;
            smoothed["Rise_gr1"] = true;
            smoothed["Rise_gr2"] = true;
            smoothed["rise_r1"] = true;
            smoothed["sm_rock1"] = true;
            smoothed["sm_rock2"] = true;
            smoothed["up_Brock"] = true;
            smoothed["Up_Rock"] = true;
            smoothed["Up_Rock1"] = true;
            smoothed["Up_Rock2"] = true;
            smoothed["Up_Rock14"] = true;
            for each(mesh in this.objects)
            {
               if(smoothed[mesh.name] == undefined)
               {
                  for each(face in mesh.faces)
                  {
                     face.smoothingGroups = 0;
                  }
               }
            }
            Mesh.calculateVerticesNormalsBySmoothingGroupsForMeshList(this.objects,0.01);
            i = 0;
            len = int(this.objects.length);
            while(i < len)
            {
               mesh = this.objects[i] as Mesh;
               if(GameData.bisoga && mesh.name == "bilboard")
               {
                  this.cutBillboard(mesh);
               }
               bsp = new BSP();
               bsp.createTree(mesh,true);
               bsp.name = mesh.name;
               bsp.matrix = mesh.matrix;
               this.objects[i] = bsp;
               i++;
            }
            if(this.helperMesh == null)
            {
               this.helperMesh = new HelperMesh();
               this.objects.push(this.helperMesh);
            }
            kdContainer.createTree(this.objects,this.occluders);
            for each(object in this.dynamics)
            {
               kdContainer.addChild(object);
            }
            this.changed = false;
         }
      }
      
      private function cutBillboard(mesh:Mesh) : void
      {
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var d:Vertex = null;
         var vertex:Vertex = null;
         var threshold:Number = 1;
         var material:Material = mesh.faces[0].material;
         for each(vertex in mesh.vertices)
         {
            if(vertex.z > threshold)
            {
               mesh.removeVertex(vertex);
            }
            else if(vertex.x < mesh.boundMinX + threshold)
            {
               if(vertex.y < mesh.boundMinY + threshold)
               {
                  a = vertex;
               }
               else if(vertex.y > mesh.boundMaxY - threshold)
               {
                  d = vertex;
               }
               else
               {
                  mesh.removeVertex(vertex);
               }
            }
            else if(vertex.x > mesh.boundMaxX - threshold)
            {
               if(vertex.y < mesh.boundMinY + threshold)
               {
                  b = vertex;
               }
               else if(vertex.y > mesh.boundMaxY - threshold)
               {
                  c = vertex;
               }
               else
               {
                  mesh.removeVertex(vertex);
               }
            }
            else
            {
               mesh.removeVertex(vertex);
            }
         }
         mesh.addQuadFace(a,b,c,d,material);
         mesh.calculateFacesNormals();
         mesh.calculateVerticesNormals();
         mesh.calculateBounds();
      }
   }
}

