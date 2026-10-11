package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix4;
   import alternativa.tanks.battle.hidablegraphicobjects.HidableGraphicObject;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: Needed to access some property inside Vertex
   use namespace alternativa3d;

   public class Cords extends Mesh implements HidableGraphicObject
   {
      
      private static const map:Matrix4 = new Matrix4();
      
      private var parachuteVertices:Vector.<Vertex>;
      
      private var parachutePoints:Vector.<Vector3>;
      
      private var bonusVertex:Vertex;
      
      private var bonusPoint:Vector3;
      
      private var numCords:int;
      
      private var bonusMesh:BonusMesh;
      
      private var parachute:Parachute;
      
      private var supy:Number = 1;
      
      private var alphaMultiplier:Number = 1;
      
      public function Cords(radius:Number, halfSize:Number, numCords:int, material:Material)
      {
         super();
         this.numCords = numCords;
         this.parachuteVertices = new Vector.<Vertex>(2 * numCords);
         this.parachutePoints = new Vector.<Vector3>(numCords);
         this.createGeometry(radius,halfSize);
         setMaterialToAllFaces(material);
         shadowMapAlphaThreshold = 2;
         depthMapAlphaThreshold = 2;
      }
      
      public function init(bonusMesh:BonusMesh, parachute:Parachute) : void
      {
         this.bonusMesh = bonusMesh;
         this.parachute = parachute;
         scaleX = 1;
         scaleY = 1;
         scaleZ = 1;
         alpha = 1;
         this.supy = 1;
      }
      
      public function recycle() : void
      {
         this.bonusMesh = null;
         this.parachute = null;
         BonusCache.putCords(this);
      }
      
      public function updateVertices() : void
      {
         var point:Vector3 = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var vertex:Vertex = null;
         map.setMatrix(this.parachute.x,this.parachute.y,this.parachute.z,this.parachute.rotationX,this.parachute.rotationY,this.parachute.rotationZ);
         var i:int = 0;
         while(i < this.numCords)
         {
            point = this.parachutePoints[i];
            _loc3_ = point.x * map.ma + point.y * map.mb + point.z * map.mc + map.md;
            _loc4_ = point.x * map.me + point.y * map.mf + point.z * map.mg + map.mh;
            _loc5_ = point.x * map.mi + point.y * map.mj + point.z * map.mk + map.ml;
            vertex = this.parachuteVertices[2 * i];
            vertex.x = _loc3_;
            vertex.y = _loc4_;
            vertex.z = _loc5_;
            vertex = this.parachuteVertices[2 * i + 1];
            vertex.x = _loc3_;
            vertex.y = _loc4_;
            vertex.z = _loc5_;
            i++;
         }
         map.setMatrix(this.bonusMesh.x,this.bonusMesh.y,this.bonusMesh.z,this.bonusMesh.rotationX,this.bonusMesh.rotationY,this.bonusMesh.rotationZ);
         point = this.bonusPoint;
         this.bonusVertex.x = point.x * map.ma + point.y * map.mb + point.z * map.mc + map.md;
         this.bonusVertex.y = point.x * map.me + point.y * map.mf + point.z * map.mg + map.mh;
         this.bonusVertex.z = point.x * map.mi + point.y * map.mj + point.z * map.mk + map.ml;
         calculateBounds();
         calculateFacesNormals();
      }
      
      private function createGeometry(radius:Number, halfSize:Number) : void
      {
         var angle:Number = NaN;
         var point:Vector3 = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.bonusPoint = new Vector3(0,0,halfSize);
         this.bonusVertex = this.createVertex(0,0,halfSize,0,1);
         var angleStep:Number = 2 * Math.PI / this.numCords;
         var i:int = 0;
         while(i < this.numCords)
         {
            angle = i * angleStep;
            point = new Vector3(radius * Math.cos(angle),radius * Math.sin(angle),0);
            this.parachutePoints[i] = point;
            this.parachuteVertices[2 * i] = this.createVertex(point.x,point.y,point.z,0,0);
            this.parachuteVertices[2 * i + 1] = this.createVertex(point.x,point.y,point.z,1,1);
            i++;
         }
         var j:int = 0;
         while(j < this.numCords)
         {
            _loc8_ = 2 * j;
            _loc9_ = _loc8_ + 3;
            if(_loc9_ >= 2 * this.numCords)
            {
               _loc9_ -= 2 * this.numCords;
            }
            this.createTriFace(this.bonusVertex,this.parachuteVertices[_loc8_],this.parachuteVertices[_loc9_]);
            this.createTriFace(this.bonusVertex,this.parachuteVertices[_loc9_],this.parachuteVertices[_loc8_]);
            j++;
         }
      }
      
      private function createVertex(param1:Number, param2:Number, param3:Number, u:Number, v:Number) : Vertex
      {
         var vertex:Vertex = new Vertex();
         vertex.next = vertexList;
         vertexList = vertex;
         vertex.x = param1;
         vertex.y = param2;
         vertex.z = param3;
         vertex.u = u;
         vertex.v = v;
         return vertex;
      }
      
      private function createTriFace(a:Vertex, b:Vertex, c:Vertex) : Face
      {
         var face:Face = new Face();
         face.next = faceList;
         faceList = face;
         face.wrapper = new Wrapper();
         face.wrapper.vertex = a;
         face.wrapper.next = new Wrapper();
         face.wrapper.next.vertex = b;
         face.wrapper.next.next = new Wrapper();
         face.wrapper.next.next.vertex = c;
         return face;
      }
      
      public function setAlpha(value:Number) : void
      {
         this.supy = value;
         this.updateAlpha();
      }
      
      private function updateAlpha() : void
      {
         alpha = this.alphaMultiplier * this.supy;
      }
      
      public function readPosition(result:Vector3) : void
      {
         result.x = x;
         result.y = y;
         result.z = z;
      }
      
      public function setAlphaMultiplier(value:Number) : void
      {
         this.alphaMultiplier = value;
         this.updateAlpha();
      }
   }
}

