package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Mesh;
   
   public class SimplePlane extends Mesh
   {
      
      protected var gar:Vertex;
      
      protected var nityt:Vertex;
      
      protected var fysu:Vertex;
      
      protected var rok:Vertex;
      
      private var lezebyk:Number;
      
      private var cofydyz:Number;
      
      public function SimplePlane(param1:Number, param2:Number, param3:Number, param4:Number)
      {
         super();
         this.lezebyk = param3;
         this.cofydyz = param4;
         boundMinX = -param3 * param1;
         boundMaxX = boundMinX + param1;
         boundMinY = -param4 * param2;
         boundMaxY = boundMinY + param2;
         boundMinZ = 0;
         boundMaxZ = 0;
         var _loc5_:Vector.<Number> = Vector.<Number>([boundMinX,boundMinY,0,boundMaxX,boundMinY,0,boundMaxX,boundMaxY,0,boundMinX,boundMaxY,0]);
         var _loc6_:Vector.<Number> = Vector.<Number>([0,1,1,1,1,0,0,0]);
         var _loc7_:Vector.<int> = Vector.<int>([4,0,1,2,3]);
         addVerticesAndFaces(_loc5_,_loc6_,_loc7_,true);
         calculateFacesNormals();
         this.writeVertices();
         useShadowMap = false;
         useLight = false;
         shadowMapAlphaThreshold = 2;
         depthMapAlphaThreshold = 2;
      }
      
      private function writeVertices() : void
      {
         var _loc1_:Vector.<Vertex> = this.vertices;
         this.gar = _loc1_[0];
         this.nityt = _loc1_[1];
         this.fysu = _loc1_[2];
         this.rok = _loc1_[3];
      }
      
      public function setUVs(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : void
      {
         this.gar.u = param1;
         this.gar.v = param2;
         this.nityt.u = param3;
         this.nityt.v = param4;
         this.fysu.u = param5;
         this.fysu.v = param6;
         this.rok.u = param7;
         this.rok.v = param8;
      }
      
      public function set width(param1:Number) : void
      {
         boundMinX = this.gar.x = this.rok.x = -this.lezebyk * param1;
         boundMaxX = this.nityt.x = this.fysu.x = boundMinX + param1;
      }
      
      public function get length() : Number
      {
         return boundMaxY - boundMinY;
      }
      
      public function set length(param1:Number) : void
      {
         boundMinY = this.gar.y = this.nityt.y = -this.cofydyz * param1;
         boundMaxY = this.rok.y = this.fysu.y = boundMinY + param1;
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         this.width = param1;
         this.length = param2;
      }
   }
}

