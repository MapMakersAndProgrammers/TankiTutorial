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
      
      private var originX:Number;
      
      private var originY:Number;
      
      public function SimplePlane(param1:Number, param2:Number, originX:Number, originY:Number)
      {
         super();
         this.originX = originX;
         this.originY = originY;
         boundMinX = -originX * param1;
         boundMaxX = boundMinX + param1;
         boundMinY = -originY * param2;
         boundMaxY = boundMinY + param2;
         boundMinZ = 0;
         boundMaxZ = 0;
         var _loc5_:Vector.<Number> = Vector.<Number>([boundMinX,boundMinY,0,boundMaxX,boundMinY,0,boundMaxX,boundMaxY,0,boundMinX,boundMaxY,0]);
         var uvs:Vector.<Number> = Vector.<Number>([0,1,1,1,1,0,0,0]);
         var indices:Vector.<int> = Vector.<int>([4,0,1,2,3]);
         addVerticesAndFaces(_loc5_,uvs,indices,true);
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
      
      public function setUVs(u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number) : void
      {
         this.gar.u = u0;
         this.gar.v = v0;
         this.nityt.u = u1;
         this.nityt.v = v1;
         this.fysu.u = u2;
         this.fysu.v = v2;
         this.rok.u = u3;
         this.rok.v = v3;
      }
      
      public function set width(value:Number) : void
      {
         boundMinX = this.gar.x = this.rok.x = -this.originX * value;
         boundMaxX = this.nityt.x = this.fysu.x = boundMinX + value;
      }
      
      public function get length() : Number
      {
         return boundMaxY - boundMinY;
      }
      
      public function set length(value:Number) : void
      {
         boundMinY = this.gar.y = this.nityt.y = -this.originY * value;
         boundMaxY = this.rok.y = this.fysu.y = boundMinY + value;
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         this.width = param1;
         this.length = param2;
      }
   }
}

