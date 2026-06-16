package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class EllipsoidCollider
   {
      
      public var radiusX:Number;
      
      public var radiusY:Number;
      
      public var radiusZ:Number;
      
      public var threshold:Number = 0.001;
      
      private var matrix:Object3D = new Object3D();
      
      private var faces:Vector.<Face> = new Vector.<Face>();
      
      private var facesLength:int;
      
      private var radius:Number;
      
      private var src:Vector3D = new Vector3D();
      
      private var displ:Vector3D = new Vector3D();
      
      private var dest:Vector3D = new Vector3D();
      
      private var collisionPoint:Vector3D = new Vector3D();
      
      private var collisionPlane:Vector3D = new Vector3D();
      
      private var vCenter:Vector3D = new Vector3D();
      
      private var vA:Vector3D = new Vector3D();
      
      private var vB:Vector3D = new Vector3D();
      
      private var vC:Vector3D = new Vector3D();
      
      private var vD:Vector3D = new Vector3D();
      
      public function EllipsoidCollider(radiusX:Number, radiusY:Number, radiusZ:Number)
      {
         super();
         this.radiusX = radiusX;
         this.radiusY = radiusY;
         this.radiusZ = radiusZ;
      }
      
      private function prepare(source:Vector3D, displacement:Vector3D, object:Object3D, excludedObjects:Dictionary) : void
      {
         this.radius = this.radiusX;
         if(this.radiusY > this.radius)
         {
            this.radius = this.radiusY;
         }
         if(this.radiusZ > this.radius)
         {
            this.radius = this.radiusZ;
         }
         this.matrix.scaleX = this.radiusX / this.radius;
         this.matrix.scaleY = this.radiusY / this.radius;
         this.matrix.scaleZ = this.radiusZ / this.radius;
         this.matrix.x = source.x;
         this.matrix.y = source.y;
         this.matrix.z = source.z;
         this.matrix.composeMatrix();
         this.matrix.invertMatrix();
         this.src.x = 0;
         this.src.y = 0;
         this.src.z = 0;
         this.displ.x = this.matrix.ma * displacement.x + this.matrix.mb * displacement.y + this.matrix.mc * displacement.z;
         this.displ.y = this.matrix.me * displacement.x + this.matrix.mf * displacement.y + this.matrix.mg * displacement.z;
         this.displ.z = this.matrix.mi * displacement.x + this.matrix.mj * displacement.y + this.matrix.mk * displacement.z;
         this.dest.x = this.src.x + this.displ.x;
         this.dest.y = this.src.y + this.displ.y;
         this.dest.z = this.src.z + this.displ.z;
         var rad:Number = this.radius + this.displ.length;
         object.composeAndAppend(this.matrix);
         this.vA.x = -rad;
         this.vA.y = -rad;
         this.vA.z = -rad;
         this.vB.x = rad;
         this.vB.y = -rad;
         this.vB.z = -rad;
         this.vC.x = rad;
         this.vC.y = rad;
         this.vC.z = -rad;
         this.vD.x = -rad;
         this.vD.y = rad;
         this.vD.z = -rad;
         object.collectPlanes(this.vCenter,this.vA,this.vB,this.vC,this.vD,this.faces,excludedObjects);
         this.facesLength = this.faces.length;
      }
      
      public function calculateDestination(source:Vector3D, displacement:Vector3D, object:Object3D, excludedObjects:Dictionary = null) : Vector3D
      {
         var limit:int = 0;
         var i:int = 0;
         var offset:Number = NaN;
         if(displacement.length <= this.threshold)
         {
            return source.clone();
         }
         this.prepare(source,displacement,object,excludedObjects);
         if(this.facesLength > 0)
         {
            limit = 50;
            for(i = 0; i < limit; )
            {
               if(!this.checkCollision())
               {
                  break;
               }
               offset = this.radius + this.threshold + this.collisionPlane.w - this.dest.x * this.collisionPlane.x - this.dest.y * this.collisionPlane.y - this.dest.z * this.collisionPlane.z;
               this.dest.x += this.collisionPlane.x * offset;
               this.dest.y += this.collisionPlane.y * offset;
               this.dest.z += this.collisionPlane.z * offset;
               this.src.x = this.collisionPoint.x + this.collisionPlane.x * (this.radius + this.threshold);
               this.src.y = this.collisionPoint.y + this.collisionPlane.y * (this.radius + this.threshold);
               this.src.z = this.collisionPoint.z + this.collisionPlane.z * (this.radius + this.threshold);
               this.displ.x = this.dest.x - this.src.x;
               this.displ.y = this.dest.y - this.src.y;
               this.displ.z = this.dest.z - this.src.z;
               if(this.displ.length < this.threshold)
               {
                  break;
               }
               i++;
            }
            this.faces.length = 0;
            this.matrix.composeMatrix();
            return new Vector3D(this.matrix.ma * this.dest.x + this.matrix.mb * this.dest.y + this.matrix.mc * this.dest.z + this.matrix.md,this.matrix.me * this.dest.x + this.matrix.mf * this.dest.y + this.matrix.mg * this.dest.z + this.matrix.mh,this.matrix.mi * this.dest.x + this.matrix.mj * this.dest.y + this.matrix.mk * this.dest.z + this.matrix.ml);
         }
         return new Vector3D(source.x + displacement.x,source.y + displacement.y,source.z + displacement.z);
      }
      
      public function getCollision(source:Vector3D, displacement:Vector3D, resCollisionPoint:Vector3D, resCollisionPlane:Vector3D, object:Object3D, excludedObjects:Dictionary = null) : Boolean
      {
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var abx2:Number = NaN;
         var aby2:Number = NaN;
         var abz2:Number = NaN;
         var acx2:Number = NaN;
         var acy2:Number = NaN;
         var acz2:Number = NaN;
         if(displacement.length <= this.threshold)
         {
            return false;
         }
         this.prepare(source,displacement,object,excludedObjects);
         if(this.facesLength > 0)
         {
            if(this.checkCollision())
            {
               this.matrix.composeMatrix();
               resCollisionPoint.x = this.matrix.ma * this.collisionPoint.x + this.matrix.mb * this.collisionPoint.y + this.matrix.mc * this.collisionPoint.z + this.matrix.md;
               resCollisionPoint.y = this.matrix.me * this.collisionPoint.x + this.matrix.mf * this.collisionPoint.y + this.matrix.mg * this.collisionPoint.z + this.matrix.mh;
               resCollisionPoint.z = this.matrix.mi * this.collisionPoint.x + this.matrix.mj * this.collisionPoint.y + this.matrix.mk * this.collisionPoint.z + this.matrix.ml;
               if(this.collisionPlane.x < this.collisionPlane.y)
               {
                  if(this.collisionPlane.x < this.collisionPlane.z)
                  {
                     abx = 0;
                     aby = -this.collisionPlane.z;
                     abz = this.collisionPlane.y;
                  }
                  else
                  {
                     abx = -this.collisionPlane.y;
                     aby = this.collisionPlane.x;
                     abz = 0;
                  }
               }
               else if(this.collisionPlane.y < this.collisionPlane.z)
               {
                  abx = this.collisionPlane.z;
                  aby = 0;
                  abz = -this.collisionPlane.x;
               }
               else
               {
                  abx = -this.collisionPlane.y;
                  aby = this.collisionPlane.x;
                  abz = 0;
               }
               acx = this.collisionPlane.z * aby - this.collisionPlane.y * abz;
               acy = this.collisionPlane.x * abz - this.collisionPlane.z * abx;
               acz = this.collisionPlane.y * abx - this.collisionPlane.x * aby;
               abx2 = this.matrix.ma * abx + this.matrix.mb * aby + this.matrix.mc * abz;
               aby2 = this.matrix.me * abx + this.matrix.mf * aby + this.matrix.mg * abz;
               abz2 = this.matrix.mi * abx + this.matrix.mj * aby + this.matrix.mk * abz;
               acx2 = this.matrix.ma * acx + this.matrix.mb * acy + this.matrix.mc * acz;
               acy2 = this.matrix.me * acx + this.matrix.mf * acy + this.matrix.mg * acz;
               acz2 = this.matrix.mi * acx + this.matrix.mj * acy + this.matrix.mk * acz;
               resCollisionPlane.x = abz2 * acy2 - aby2 * acz2;
               resCollisionPlane.y = abx2 * acz2 - abz2 * acx2;
               resCollisionPlane.z = aby2 * acx2 - abx2 * acy2;
               resCollisionPlane.normalize();
               resCollisionPlane.w = resCollisionPoint.x * resCollisionPlane.x + resCollisionPoint.y * resCollisionPlane.y + resCollisionPoint.z * resCollisionPlane.z;
               this.faces.length = 0;
               return true;
            }
            this.faces.length = 0;
            return false;
         }
         return false;
      }
      
      private function checkCollision() : Boolean
      {
         var face:Face = null;
         var w:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var normalX:Number = NaN;
         var normalY:Number = NaN;
         var normalZ:Number = NaN;
         var len:Number = NaN;
         var offset:Number = NaN;
         var distance:Number = NaN;
         var pointX:Number = NaN;
         var pointY:Number = NaN;
         var pointZ:Number = NaN;
         var faceX:Number = NaN;
         var faceY:Number = NaN;
         var faceZ:Number = NaN;
         var min:Number = NaN;
         var inside:Boolean = false;
         var wrapper:Wrapper = null;
         var deltaX:Number = NaN;
         var deltaY:Number = NaN;
         var deltaZ:Number = NaN;
         var t:Number = NaN;
         var crx:Number = NaN;
         var cry:Number = NaN;
         var crz:Number = NaN;
         var edgeLength:Number = NaN;
         var edgeDistanceSqr:Number = NaN;
         var acLen:Number = NaN;
         var backX:Number = NaN;
         var backY:Number = NaN;
         var backZ:Number = NaN;
         var deltaLength:Number = NaN;
         var projectionLength:Number = NaN;
         var projectionInsideLength:Number = NaN;
         var time:Number = NaN;
         var minTime:Number = 1;
         var displacementLength:Number = this.displ.length;
         for(var i:int = 0; i < this.facesLength; )
         {
            face = this.faces[i];
            w = face.wrapper;
            a = w.vertex;
            w = w.next;
            b = w.vertex;
            w = w.next;
            c = w.vertex;
            abx = b.cameraX - a.cameraX;
            aby = b.cameraY - a.cameraY;
            abz = b.cameraZ - a.cameraZ;
            acx = c.cameraX - a.cameraX;
            acy = c.cameraY - a.cameraY;
            acz = c.cameraZ - a.cameraZ;
            normalX = acz * aby - acy * abz;
            normalY = acx * abz - acz * abx;
            normalZ = acy * abx - acx * aby;
            len = normalX * normalX + normalY * normalY + normalZ * normalZ;
            if(len > 0.001)
            {
               len = 1 / Math.sqrt(len);
               normalX *= len;
               normalY *= len;
               normalZ *= len;
               offset = a.cameraX * normalX + a.cameraY * normalY + a.cameraZ * normalZ;
               distance = this.src.x * normalX + this.src.y * normalY + this.src.z * normalZ - offset;
               if(distance < this.radius)
               {
                  pointX = this.src.x - normalX * distance;
                  pointY = this.src.y - normalY * distance;
                  pointZ = this.src.z - normalZ * distance;
               }
               else
               {
                  t = (distance - this.radius) / (distance - this.dest.x * normalX - this.dest.y * normalY - this.dest.z * normalZ + offset);
                  pointX = this.src.x + this.displ.x * t - normalX * this.radius;
                  pointY = this.src.y + this.displ.y * t - normalY * this.radius;
                  pointZ = this.src.z + this.displ.z * t - normalZ * this.radius;
               }
               min = 1e+22;
               inside = true;
               for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
               {
                  a = wrapper.vertex;
                  b = wrapper.next != null ? wrapper.next.vertex : face.wrapper.vertex;
                  abx = b.cameraX - a.cameraX;
                  aby = b.cameraY - a.cameraY;
                  abz = b.cameraZ - a.cameraZ;
                  acx = pointX - a.cameraX;
                  acy = pointY - a.cameraY;
                  acz = pointZ - a.cameraZ;
                  crx = acz * aby - acy * abz;
                  cry = acx * abz - acz * abx;
                  crz = acy * abx - acx * aby;
                  if(crx * normalX + cry * normalY + crz * normalZ < 0)
                  {
                     edgeLength = abx * abx + aby * aby + abz * abz;
                     edgeDistanceSqr = (crx * crx + cry * cry + crz * crz) / edgeLength;
                     if(edgeDistanceSqr < min)
                     {
                        edgeLength = Math.sqrt(edgeLength);
                        abx /= edgeLength;
                        aby /= edgeLength;
                        abz /= edgeLength;
                        t = abx * acx + aby * acy + abz * acz;
                        if(t < 0)
                        {
                           acLen = acx * acx + acy * acy + acz * acz;
                           if(acLen < min)
                           {
                              min = acLen;
                              faceX = a.cameraX;
                              faceY = a.cameraY;
                              faceZ = a.cameraZ;
                           }
                        }
                        else if(t > edgeLength)
                        {
                           acx = pointX - b.cameraX;
                           acy = pointY - b.cameraY;
                           acz = pointZ - b.cameraZ;
                           acLen = acx * acx + acy * acy + acz * acz;
                           if(acLen < min)
                           {
                              min = acLen;
                              faceX = b.cameraX;
                              faceY = b.cameraY;
                              faceZ = b.cameraZ;
                           }
                        }
                        else
                        {
                           min = edgeDistanceSqr;
                           faceX = a.cameraX + abx * t;
                           faceY = a.cameraY + aby * t;
                           faceZ = a.cameraZ + abz * t;
                        }
                     }
                     inside = false;
                  }
               }
               if(inside)
               {
                  faceX = pointX;
                  faceY = pointY;
                  faceZ = pointZ;
               }
               deltaX = this.src.x - faceX;
               deltaY = this.src.y - faceY;
               deltaZ = this.src.z - faceZ;
               if(deltaX * this.displ.x + deltaY * this.displ.y + deltaZ * this.displ.z <= 0)
               {
                  backX = -this.displ.x / displacementLength;
                  backY = -this.displ.y / displacementLength;
                  backZ = -this.displ.z / displacementLength;
                  deltaLength = deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ;
                  projectionLength = deltaX * backX + deltaY * backY + deltaZ * backZ;
                  projectionInsideLength = this.radius * this.radius - deltaLength + projectionLength * projectionLength;
                  if(projectionInsideLength > 0)
                  {
                     time = (projectionLength - Math.sqrt(projectionInsideLength)) / displacementLength;
                     if(time < minTime)
                     {
                        minTime = time;
                        this.collisionPoint.x = faceX;
                        this.collisionPoint.y = faceY;
                        this.collisionPoint.z = faceZ;
                        if(inside)
                        {
                           this.collisionPlane.x = normalX;
                           this.collisionPlane.y = normalY;
                           this.collisionPlane.z = normalZ;
                           this.collisionPlane.w = offset;
                        }
                        else
                        {
                           deltaLength = Math.sqrt(deltaLength);
                           this.collisionPlane.x = deltaX / deltaLength;
                           this.collisionPlane.y = deltaY / deltaLength;
                           this.collisionPlane.z = deltaZ / deltaLength;
                           this.collisionPlane.w = this.collisionPoint.x * this.collisionPlane.x + this.collisionPoint.y * this.collisionPlane.y + this.collisionPoint.z * this.collisionPlane.z;
                        }
                     }
                  }
               }
            }
            i++;
         }
         return minTime < 1;
      }
   }
}

