package alternativa.physics.collision.colliders
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.primitives.CollisionRect;
   import alternativa.physics.collision.primitives.CollisionTriangle;
   import alternativa.physics.collision.primitives.CollisionBox;
   
   public class ColliderUtils
   {
      
      private static const basisX:Vector3 = new Vector3();
      
      private static const basisY:Vector3 = new Vector3();
      
      public function ColliderUtils()
      {
         super();
      }
      
      public static function buildContactBasis(normal:Vector3, transform1:Matrix4, transform2:Matrix4, basis:Matrix4) : void
      {
         var xAxis:Vector3 = basisX;
         var yAxis:Vector3 = basisY;
         if(Math.abs(normal.x) < Math.abs(normal.y))
         {
            xAxis.x = 0;
            xAxis.y = normal.z;
            xAxis.z = -normal.y;
         }
         else
         {
            xAxis.x = -normal.z;
            xAxis.y = 0;
            xAxis.z = normal.x;
         }
         xAxis.normalize();
         yAxis.x = normal.y * xAxis.z - normal.z * xAxis.y;
         yAxis.y = normal.z * xAxis.x - normal.x * xAxis.z;
         yAxis.z = normal.x * xAxis.y - normal.y * xAxis.x;
         basis.ma = xAxis.x;
         basis.me = xAxis.y;
         basis.mi = xAxis.z;
         basis.mb = yAxis.x;
         basis.mf = yAxis.y;
         basis.mj = yAxis.z;
         basis.mc = normal.x;
         basis.mg = normal.y;
         basis.mk = normal.z;
      }
      
      public static function transformFaceToReferenceSpace(basis:Matrix4, transform:Matrix4, vertices:Vector.<Vertex>, numVertices:int) : void
      {
         var vertex:Vertex = null;
         var i:int = 0;
         while(i < numVertices)
         {
            vertex = vertices[i];
            transform.transformVector(vertex.localPosition,vertex.worldPosition);
            basis.transformVectorInverse(vertex.worldPosition,vertex.referencePosition);
            i++;
         }
      }
      
      public static function getBoxFaceVerticesInCCWOrder(box:CollisionBox, normal:Vector3, side:FaceSide, vertices:Vector.<Vertex>) : void
      {
         var bestDot:Number = NaN;
         var bestAbsDot:Number = NaN;
         var absDot:Number = NaN;
         var dot:Number = NaN;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var sign:Number = NaN;
         var v:Vector3 = null;
         var hs:Vector3 = null;
         var vertex:Vertex = null;
         var matrix:Matrix4 = box.transform;
         var faceAxis:int = 0;
         ax = matrix.ma;
         ay = matrix.me;
         az = matrix.mi;
         bestDot = ax * normal.x + ay * normal.y + az * normal.z;
         bestAbsDot = Math.abs(bestDot);
         ax = matrix.mb;
         ay = matrix.mf;
         az = matrix.mj;
         dot = ax * normal.x + ay * normal.y + az * normal.z;
         absDot = Math.abs(dot);
         if(absDot > bestAbsDot)
         {
            bestAbsDot = absDot;
            bestDot = dot;
            faceAxis = 1;
         }
         ax = matrix.mc;
         ay = matrix.mg;
         az = matrix.mk;
         dot = ax * normal.x + ay * normal.y + az * normal.z;
         absDot = Math.abs(dot);
         if(absDot > bestAbsDot)
         {
            bestDot = dot;
            faceAxis = 2;
         }
         sign = bestDot > 0 ? 1 : -1;
         if(side == FaceSide.back)
         {
            sign = -sign;
         }
         hs = box.halfSize;
         switch(faceAxis)
         {
            case 0:
               v = Vertex(vertices[0]).localPosition;
               v.x = sign * hs.x;
               v.y = hs.y;
               v.z = hs.z;
               v = Vertex(vertices[1]).localPosition;
               v.x = sign * hs.x;
               v.y = -hs.y;
               v.z = hs.z;
               v = Vertex(vertices[2]).localPosition;
               v.x = sign * hs.x;
               v.y = -hs.y;
               v.z = -hs.z;
               v = Vertex(vertices[3]).localPosition;
               v.x = sign * hs.x;
               v.y = hs.y;
               v.z = -hs.z;
               break;
            case 1:
               v = Vertex(vertices[0]).localPosition;
               v.x = hs.x;
               v.y = sign * hs.y;
               v.z = hs.z;
               v = Vertex(vertices[1]).localPosition;
               v.x = hs.x;
               v.y = sign * hs.y;
               v.z = -hs.z;
               v = Vertex(vertices[2]).localPosition;
               v.x = -hs.x;
               v.y = sign * hs.y;
               v.z = -hs.z;
               v = Vertex(vertices[3]).localPosition;
               v.x = -hs.x;
               v.y = sign * hs.y;
               v.z = hs.z;
               break;
            case 2:
               v = Vertex(vertices[0]).localPosition;
               v.x = hs.x;
               v.y = hs.y;
               v.z = sign * hs.z;
               v = Vertex(vertices[1]).localPosition;
               v.x = -hs.x;
               v.y = hs.y;
               v.z = sign * hs.z;
               v = Vertex(vertices[2]).localPosition;
               v.x = -hs.x;
               v.y = -hs.y;
               v.z = sign * hs.z;
               v = Vertex(vertices[3]).localPosition;
               v.x = hs.x;
               v.y = -hs.y;
               v.z = sign * hs.z;
               break;
            default:
               throw new Error();
         }
         if(bestDot < 0)
         {
            vertex = vertices[0];
            vertices[0] = vertices[3];
            vertices[3] = vertex;
            vertex = vertices[1];
            vertices[1] = vertices[2];
            vertices[2] = vertex;
         }
      }
      
      public static function getRectFaceInCCWOrder(rect:CollisionRect, normal:Vector3, vertices:Vector.<Vertex>) : void
      {
         var vertex:Vertex = null;
         var hs:Vector3 = rect.halfSize;
         vertex = vertices[0];
         vertex.localPosition.x = hs.x;
         vertex.localPosition.y = hs.y;
         vertex.localPosition.z = 0;
         vertex = vertices[1];
         vertex.localPosition.x = -hs.x;
         vertex.localPosition.y = hs.y;
         vertex.localPosition.z = 0;
         vertex = vertices[2];
         vertex.localPosition.x = -hs.x;
         vertex.localPosition.y = -hs.y;
         vertex.localPosition.z = 0;
         vertex = vertices[3];
         vertex.localPosition.x = hs.x;
         vertex.localPosition.y = -hs.y;
         vertex.localPosition.z = 0;
         var matrix:Matrix4 = rect.transform;
         var dot:Number = normal.x * matrix.mc + normal.y * matrix.mg + normal.z * matrix.mk;
         if(dot < 0)
         {
            vertex = vertices[0];
            vertices[0] = vertices[3];
            vertices[3] = vertex;
            vertex = vertices[1];
            vertices[1] = vertices[2];
            vertices[2] = vertex;
         }
      }
      
      public static function getTriangleFaceInCCWOrder(triangle:CollisionTriangle, normal:Vector3, vertices:Vector.<Vertex>) : void
      {
         var vertex:Vertex = null;
         vertex = vertices[0];
         vertex.localPosition.x = triangle.v0.x;
         vertex.localPosition.y = triangle.v0.y;
         vertex.localPosition.z = 0;
         vertex = vertices[1];
         vertex.localPosition.x = triangle.v1.x;
         vertex.localPosition.y = triangle.v1.y;
         vertex.localPosition.z = 0;
         vertex = vertices[2];
         vertex.localPosition.x = triangle.v2.x;
         vertex.localPosition.y = triangle.v2.y;
         vertex.localPosition.z = 0;
         var matrix:Matrix4 = triangle.transform;
         var dot:Number = normal.x * matrix.mc + normal.y * matrix.mg + normal.z * matrix.mk;
         if(dot < 0)
         {
            vertex = vertices[0];
            vertices[0] = vertices[2];
            vertices[2] = vertex;
         }
      }
   }
}

