package alternativa.physics.collision.colliders
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.ShapeContact;
   import alternativa.physics.collision.CollisionShape;
   import flash.geom.Point;
   
   public class PolygonsIntersectionUtils
   {
      
      private static const points1:Vector.<Point> = Vector.<Point>([new Point(),new Point(),new Point(),new Point(),new Point(),new Point(),new Point(),new Point()]);
      
      private static const points2:Vector.<Point> = Vector.<Point>([new Point(),new Point(),new Point(),new Point(),new Point(),new Point(),new Point(),new Point()]);
      
      private static const intersectionPoints:Vector.<Point> = Vector.<Point>([new Point(),new Point(),new Point(),new Point(),new Point(),new Point(),new Point(),new Point()]);
      
      private static var buffer1:Vector.<Point> = Vector.<Point>([new Point(),new Point(),new Point(),new Point(),new Point(),new Point(),new Point(),new Point()]);
      
      private static var buffer2:Vector.<Point> = Vector.<Point>([new Point(),new Point(),new Point(),new Point(),new Point(),new Point(),new Point(),new Point()]);
      
      private static const intersection:Point = new Point();
      
      private static const faceNormal1:Vector3 = new Vector3();
      
      private static const faceNormal2:Vector3 = new Vector3();
      
      public function PolygonsIntersectionUtils()
      {
         super();
      }
      
      public static function findContacts(primitive1:CollisionShape, vertices1:Vector.<Vertex>, numVertices1:int, primitive2:CollisionShape, vertices2:Vector.<Vertex>, numVertices2:int, basis:Matrix4, contacts:Vector.<ShapeContact>) : void
      {
         var point:Point = null;
         var z1:Number = NaN;
         var z2:Number = NaN;
         var contact:ShapeContact = null;
         var position:Vector3 = null;
         calculateFaceNormal(vertices1,faceNormal1);
         calculateFaceNormal(vertices2,faceNormal2);
         fillProjectedPoints(vertices1,numVertices1,points1);
         fillProjectedPoints(vertices2,numVertices2,points2);
         var numPoints:int = findPolygonsIntersection(points1,numVertices1,points2,numVertices2,intersectionPoints);
         var i:int = 0;
         while(i < numPoints)
         {
            point = intersectionPoints[i];
            z1 = getFaceZ(point,Vertex(vertices1[0]).referencePosition,faceNormal1);
            z2 = getFaceZ(point,Vertex(vertices2[0]).referencePosition,faceNormal2);
            if(z2 > z1)
            {
               contact = ShapeContact.create();
               contact.shape1 = primitive1;
               contact.shape2 = primitive2;
               position = contact.position;
               position.x = point.x;
               position.y = point.y;
               position.z = 0.5 * (z1 + z2);
               position.transform4(basis);
               contact.penetration = z2 - z1;
               contact.normal.x = basis.mc;
               contact.normal.y = basis.mg;
               contact.normal.z = basis.mk;
               contacts[contacts.length] = contact;
            }
            i++;
         }
      }
      
      private static function calculateFaceNormal(vertices:Vector.<Vertex>, normal:Vector3) : void
      {
         var abx:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acz:Number = NaN;
         var v0:Vertex = vertices[0];
         var v1:Vertex = vertices[1];
         var v2:Vertex = vertices[2];
         var a:Vector3 = v0.referencePosition;
         var b:Vector3 = v1.referencePosition;
         var c:Vector3 = v2.referencePosition;
         abx = b.x - a.x;
         var aby:Number = b.y - a.y;
         abz = b.z - a.z;
         acx = c.x - a.x;
         var acy:Number = c.y - a.y;
         acz = c.z - a.z;
         normal.x = aby * acz - abz * acy;
         normal.y = abz * acx - abx * acz;
         normal.z = abx * acy - aby * acx;
         normal.normalize();
      }
      
      private static function fillProjectedPoints(vertices:Vector.<Vertex>, numVertices:int, points:Vector.<Point>) : void
      {
         var vertex:Vertex = null;
         var point:Point = null;
         var i:int = 0;
         while(i < numVertices)
         {
            vertex = vertices[i];
            point = points[i];
            point.x = vertex.referencePosition.x;
            point.y = vertex.referencePosition.y;
            i++;
         }
      }
      
      private static function findPolygonsIntersection(polygon1:Vector.<Point>, numPoints1:int, polygon2:Vector.<Point>, numPoints2:int, result:Vector.<Point>) : int
      {
         var edgeEnd:Point = null;
         var tmp:Vector.<Point> = null;
         copyPoints(polygon2,buffer1,numPoints2);
         var numPoints:int = numPoints2;
         var edgeStart:Point = polygon1[numPoints1 - 1];
         var i:int = 0;
         while(i < numPoints1)
         {
            edgeEnd = polygon1[i];
            numPoints = clip(edgeStart,edgeEnd,buffer1,buffer2,numPoints);
            if(numPoints == 0)
            {
               break;
            }
            edgeStart = edgeEnd;
            tmp = buffer1;
            buffer1 = buffer2;
            buffer2 = tmp;
            i++;
         }
         copyPoints(buffer1,result,numPoints);
         return numPoints;
      }
      
      private static function copyPoints(src:Vector.<Point>, dst:Vector.<Point>, count:int) : void
      {
         var srcPoint:Point = null;
         var dstPoint:Point = null;
         var i:int = 0;
         while(i < count)
         {
            srcPoint = src[i];
            dstPoint = dst[i];
            dstPoint.x = srcPoint.x;
            dstPoint.y = srcPoint.y;
            i++;
         }
      }
      
      private static function clip(edgeStart:Point, edgeEnd:Point, points:Vector.<Point>, result:Vector.<Point>, numPoints:int) : int
      {
         var point:Point = null;
         var inside:Boolean = false;
         var prevPoint:Point = points[numPoints - 1];
         var prevInside:Boolean = arePointsCCW(edgeStart,edgeEnd,prevPoint);
         var numResult:int = 0;
         var i:int = 0;
         while(i < numPoints)
         {
            point = points[i];
            inside = arePointsCCW(edgeStart,edgeEnd,point);
            if(inside)
            {
               if(!prevInside)
               {
                  calculateIntersection(edgeStart,edgeEnd,prevPoint,point,intersection);
                  setPoint(intersection,result,numResult++);
               }
               setPoint(point,result,numResult++);
            }
            else if(prevInside)
            {
               calculateIntersection(edgeStart,edgeEnd,prevPoint,point,intersection);
               setPoint(intersection,result,numResult++);
            }
            prevInside = inside;
            prevPoint = point;
            i++;
         }
         return numResult;
      }
      
      private static function setPoint(point:Point, points:Vector.<Point>, index:int) : void
      {
         var dst:Point = points[index];
         dst.x = point.x;
         dst.y = point.y;
      }
      
      private static function arePointsCCW(a:Point, b:Point, c:Point) : Boolean
      {
         var abx:Number = b.x - a.x;
         var aby:Number = b.y - a.y;
         var acx:Number = c.x - a.x;
         var acy:Number = c.y - a.y;
         return abx * acy - aby * acx > 0;
      }
      
      private static function calculateIntersection(a:Point, b:Point, c:Point, d:Point, result:Point) : void
      {
         var abx:Number = b.x - a.x;
         var aby:Number = b.y - a.y;
         var cdx:Number = d.x - c.x;
         var cdy:Number = d.y - c.y;
         var acx:Number = c.x - a.x;
         var acy:Number = c.y - a.y;
         var t:Number = (abx * acy - aby * acx) / (aby * cdx - abx * cdy);
         result.x = c.x + t * cdx;
         result.y = c.y + t * cdy;
      }
      
      private static function getFaceZ(point:Point, facePoint:Vector3, normal:Vector3) : Number
      {
         var d:Number = facePoint.dot(normal);
         return (d - point.x * normal.x - point.y * normal.y) / normal.z;
      }
   }
}

