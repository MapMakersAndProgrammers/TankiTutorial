package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Mesh;
   
   public class AnimatedPlane extends Mesh
   {
      
      private var gar:Vertex;
      
      private var nityt:Vertex;
      
      private var fysu:Vertex;
      
      private var rok:Vertex;
      
      private var gepoky:Vector.<UVFrame>;
      
      private var nomupiz:int;
      
      private var lelypa:Number = 0;
      
      public function AnimatedPlane(param1:Number)
      {
         super();
         this.createFaces(param1);
         sorting = Sorting.DYNAMIC_BSP;
         calculateBounds();
         calculateFacesNormals();
         this.writeVertices();
         useShadowMap = false;
         useLight = false;
         shadowMapAlphaThreshold = 2;
         depthMapAlphaThreshold = 2;
      }
      
      private function createFaces(param1:Number) : void
      {
         var _loc2_:Number = param1 / 2;
         var _loc3_:Vector.<Number> = Vector.<Number>([-_loc2_,_loc2_,0,-_loc2_,-_loc2_,0,_loc2_,-_loc2_,0,_loc2_,_loc2_,0]);
         var _loc4_:Vector.<Number> = Vector.<Number>([0,0,0,1,1,1,1,0]);
         var _loc5_:Vector.<int> = Vector.<int>([4,0,1,2,3,4,0,3,2,1]);
         addVerticesAndFaces(_loc3_,_loc4_,_loc5_,true);
      }
      
      private function writeVertices() : void
      {
         var _loc1_:Vector.<Vertex> = this.vertices;
         this.gar = _loc1_[0];
         this.nityt = _loc1_[1];
         this.fysu = _loc1_[2];
         this.rok = _loc1_[3];
      }
      
      public function init(param1:TextureAnimation, param2:Number) : void
      {
         setMaterialToAllFaces(param1.material);
         this.gepoky = param1.qyvoladeg;
         this.nomupiz = this.gepoky.length;
         this.lelypa = param2;
      }
      
      public function setTime(param1:Number) : void
      {
         var _loc2_:int = param1 * this.lelypa;
         if(_loc2_ >= this.nomupiz)
         {
            _loc2_ = this.nomupiz - 1;
         }
         this.setFrame(this.gepoky[_loc2_]);
      }
      
      public function clear() : void
      {
         setMaterialToAllFaces(null);
         this.gepoky = null;
         this.nomupiz = 0;
      }
      
      public function getOneLoopTime() : Number
      {
         return this.nomupiz / this.lelypa;
      }
      
      private function setFrame(param1:UVFrame) : void
      {
         this.gar.u = param1.picylyno;
         this.gar.v = param1.lesenac;
         this.nityt.u = param1.picylyno;
         this.nityt.v = param1.salemat;
         this.fysu.u = param1.pusunawy;
         this.fysu.v = param1.salemat;
         this.rok.u = param1.pusunawy;
         this.rok.v = param1.lesenac;
      }
   }
}

