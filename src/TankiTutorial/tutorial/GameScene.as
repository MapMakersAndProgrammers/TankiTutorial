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
      
      private var leqib:Vector.<Object3D> = new Vector.<Object3D>();
      
      private var bemevem:Vector.<Object3D> = new Vector.<Object3D>();
      
      private var lucubegul:Vector.<Occluder> = new Vector.<Occluder>();
      
      private var dyb:Object = new Object();
      
      private var juzote:Boolean = false;
      
      private var woju:HelperMesh;
      
      public function GameScene()
      {
         super();
      }
      
      public function addObject(param1:Object3D) : void
      {
         this.leqib.push(param1);
         if(param1.name != null)
         {
            this.dyb[param1.name] = param1;
         }
         this.juzote = true;
      }
      
      public function addOccluder(param1:Occluder) : void
      {
         this.lucubegul.push(param1);
      }
      
      public function addDynamic(param1:Object3D) : void
      {
         this.bemevem.push(param1);
         if(param1.name != null)
         {
            this.dyb[param1.name] = param1;
         }
         this.juzote = true;
      }
      
      public function getObject(param1:String) : Object3D
      {
         return this.dyb[param1];
      }
      
      public function buildKDTree(param1:KDContainer) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Mesh = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object3D = null;
         var _loc7_:Face = null;
         var _loc8_:BSP = null;
         if(this.juzote)
         {
            _loc2_ = new Object();
            _loc2_["hang_1"] = true;
            _loc2_["hang_2"] = true;
            _loc2_["hang_3"] = true;
            _loc2_["SmHouse008"] = true;
            _loc2_["wall_broke_1"] = true;
            _loc2_["wall_broke_2"] = true;
            _loc2_["Bk_roof1"] = true;
            _loc2_["Bk_roof2"] = true;
            _loc2_["Tree01"] = true;
            _loc2_["Tree02"] = true;
            _loc2_["tube_1"] = true;
            _loc2_["tube_2"] = true;
            _loc2_["tube_3"] = true;
            _loc2_["tube_cor"] = true;
            _loc2_["cliff_3"] = true;
            _loc2_["cliff_1"] = true;
            _loc2_["cliff_2"] = true;
            _loc2_["cliff_4"] = true;
            _loc2_["cliff_inco"] = true;
            _loc2_["cliff_cor"] = true;
            _loc2_["cliff_r2"] = true;
            _loc2_["cliff_ri"] = true;
            _loc2_["Big_Rock04"] = true;
            _loc2_["Big_Rock"] = true;
            _loc2_["Change01"] = true;
            _loc2_["Change02"] = true;
            _loc2_["Corn1"] = true;
            _loc2_["Corn2"] = true;
            _loc2_["Corn3"] = true;
            _loc2_["Corn4"] = true;
            _loc2_["Corn_B"] = true;
            _loc2_["crater"] = true;
            _loc2_["Land02"] = true;
            _loc2_["Land03"] = true;
            _loc2_["Land04"] = true;
            _loc2_["Land05"] = true;
            _loc2_["Land06"] = true;
            _loc2_["Land07"] = true;
            _loc2_["Land08"] = true;
            _loc2_["Land09"] = true;
            _loc2_["Land22"] = true;
            _loc2_["Land33"] = true;
            _loc2_["Line"] = true;
            _loc2_["Med_Rock"] = true;
            _loc2_["rise_g1"] = true;
            _loc2_["rise_g2"] = true;
            _loc2_["rise_g3"] = true;
            _loc2_["rise_g4"] = true;
            _loc2_["rise_g5"] = true;
            _loc2_["rise_g6"] = true;
            _loc2_["Rise_gr1"] = true;
            _loc2_["Rise_gr2"] = true;
            _loc2_["rise_r1"] = true;
            _loc2_["sm_rock1"] = true;
            _loc2_["sm_rock2"] = true;
            _loc2_["up_Brock"] = true;
            _loc2_["Up_Rock"] = true;
            _loc2_["Up_Rock1"] = true;
            _loc2_["Up_Rock2"] = true;
            _loc2_["Up_Rock14"] = true;
            for each(_loc3_ in this.leqib)
            {
               if(_loc2_[_loc3_.name] == undefined)
               {
                  for each(_loc7_ in _loc3_.faces)
                  {
                     _loc7_.smoothingGroups = 0;
                  }
               }
            }
            Mesh.calculateVerticesNormalsBySmoothingGroupsForMeshList(this.leqib,0.01);
            _loc4_ = 0;
            _loc5_ = int(this.leqib.length);
            while(_loc4_ < _loc5_)
            {
               _loc3_ = this.leqib[_loc4_] as Mesh;
               if(GameData.bisoga && _loc3_.name == "bilboard")
               {
                  this.cutBillboard(_loc3_);
               }
               _loc8_ = new BSP();
               _loc8_.createTree(_loc3_,true);
               _loc8_.name = _loc3_.name;
               _loc8_.matrix = _loc3_.matrix;
               this.leqib[_loc4_] = _loc8_;
               _loc4_++;
            }
            if(this.woju == null)
            {
               this.woju = new HelperMesh();
               this.leqib.push(this.woju);
            }
            param1.createTree(this.leqib,this.lucubegul);
            for each(_loc6_ in this.bemevem)
            {
               param1.addChild(_loc6_);
            }
            this.juzote = false;
         }
      }
      
      private function cutBillboard(param1:Mesh) : void
      {
         var _loc3_:Vertex = null;
         var _loc4_:Vertex = null;
         var _loc5_:Vertex = null;
         var _loc6_:Vertex = null;
         var _loc8_:Vertex = null;
         var _loc2_:Number = 1;
         var _loc7_:Material = param1.faces[0].material;
         for each(_loc8_ in param1.vertices)
         {
            if(_loc8_.z > _loc2_)
            {
               param1.removeVertex(_loc8_);
            }
            else if(_loc8_.x < param1.boundMinX + _loc2_)
            {
               if(_loc8_.y < param1.boundMinY + _loc2_)
               {
                  _loc3_ = _loc8_;
               }
               else if(_loc8_.y > param1.boundMaxY - _loc2_)
               {
                  _loc6_ = _loc8_;
               }
               else
               {
                  param1.removeVertex(_loc8_);
               }
            }
            else if(_loc8_.x > param1.boundMaxX - _loc2_)
            {
               if(_loc8_.y < param1.boundMinY + _loc2_)
               {
                  _loc4_ = _loc8_;
               }
               else if(_loc8_.y > param1.boundMaxY - _loc2_)
               {
                  _loc5_ = _loc8_;
               }
               else
               {
                  param1.removeVertex(_loc8_);
               }
            }
            else
            {
               param1.removeVertex(_loc8_);
            }
         }
         param1.addQuadFace(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
         param1.calculateFacesNormals();
         param1.calculateVerticesNormals();
         param1.calculateBounds();
      }
   }
}

