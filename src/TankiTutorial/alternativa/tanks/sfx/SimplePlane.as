package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Mesh;
   
   public class SimplePlane extends Mesh
   {
      
      protected var a:Vertex;
      
      protected var b:Vertex;
      
      protected var c:Vertex;
      
      protected var d:Vertex;
      
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
         this.a = _loc1_[0];
         this.b = _loc1_[1];
         this.c = _loc1_[2];
         this.d = _loc1_[3];
      }
      
      public function setUVs(u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number) : void
      {
         this.a.u = u0;
         this.a.v = v0;
         this.b.u = u1;
         this.b.v = v1;
         this.c.u = u2;
         this.c.v = v2;
         this.d.u = u3;
         this.d.v = v3;
      }
      
      public function set width(value:Number) : void
      {
         boundMinX = this.a.x = this.d.x = -this.originX * value;
         boundMaxX = this.b.x = this.c.x = boundMinX + value;
      }
      
      public function get length() : Number
      {
         return boundMaxY - boundMinY;
      }
      
      public function set length(value:Number) : void
      {
         boundMinY = this.a.y = this.b.y = -this.originY * value;
         boundMaxY = this.d.y = this.c.y = boundMinY + value;
      }
      
      public function resize(width:Number, length:Number) : void
      {
         this.width = width;
         this.length = length;
      }
   }
}

