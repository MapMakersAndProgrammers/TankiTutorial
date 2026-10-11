package alternativa.physics.collision.primitives
{
   import alternativa.physics.PhysicsMaterial;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix4;
   import alternativa.physics.collision.types.AABB;
   import alternativa.physics.collision.CollisionShape;
   
   public class CollisionBox extends CollisionShape
   {
      
      public var halfSize:Vector3 = new Vector3();
      
      public function CollisionBox(halfSize:Vector3, collisionGroup:int, material:PhysicsMaterial)
      {
         super(BOX,collisionGroup,material);
         this.halfSize.copy(halfSize);
      }
      
      override public function calculateAABB() : AABB
      {
         var matrix:Matrix4 = null;
         var bounds:AABB = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         matrix = transform;
         bounds = this.aabb;
         _loc3_ = matrix.ma < 0 ? -matrix.ma : Number(matrix.ma);
         _loc4_ = matrix.mb < 0 ? -matrix.mb : Number(matrix.mb);
         _loc5_ = matrix.mc < 0 ? -matrix.mc : Number(matrix.mc);
         bounds.maxX = this.halfSize.x * _loc3_ + this.halfSize.y * _loc4_ + this.halfSize.z * _loc5_;
         bounds.minX = -bounds.maxX;
         _loc3_ = matrix.me < 0 ? -matrix.me : Number(matrix.me);
         _loc4_ = matrix.mf < 0 ? -matrix.mf : Number(matrix.mf);
         _loc5_ = matrix.mg < 0 ? -matrix.mg : Number(matrix.mg);
         bounds.maxY = this.halfSize.x * _loc3_ + this.halfSize.y * _loc4_ + this.halfSize.z * _loc5_;
         bounds.minY = -bounds.maxY;
         _loc3_ = matrix.mi < 0 ? -matrix.mi : Number(matrix.mi);
         _loc4_ = matrix.mj < 0 ? -matrix.mj : Number(matrix.mj);
         _loc5_ = matrix.mk < 0 ? -matrix.mk : Number(matrix.mk);
         bounds.maxZ = this.halfSize.x * _loc3_ + this.halfSize.y * _loc4_ + this.halfSize.z * _loc5_;
         bounds.minZ = -bounds.maxZ;
         bounds.minX += matrix.md;
         bounds.maxX += matrix.md;
         bounds.minY += matrix.mh;
         bounds.maxY += matrix.mh;
         bounds.minZ += matrix.ml;
         bounds.maxZ += matrix.ml;
         return bounds;
      }
      
      override public function copyFrom(source:CollisionShape) : CollisionShape
      {
         var box:CollisionBox = source as CollisionBox;
         if(box == null)
         {
            return this;
         }
         super.copyFrom(box);
         this.halfSize.copy(box.halfSize);
         return this;
      }
      
      override protected function createPrimitive() : CollisionShape
      {
         return new CollisionBox(this.halfSize,collisionGroup,material);
      }
      
      override public function raycast(origin:Vector3, direction:Vector3, epsilon:Number, normal:Vector3) : Number
      {
         var t1:Number = NaN;
         var t2:Number = NaN;
         var matrix:Matrix4 = this.transform;
         var tMin:Number = -1;
         var tMax:Number = 1e+308;
         var dx:Number = origin.x - matrix.md;
         var dy:Number = origin.y - matrix.mh;
         var dz:Number = origin.z - matrix.ml;
         var ox:Number = matrix.ma * dx + matrix.me * dy + matrix.mi * dz;
         var oy:Number = matrix.mb * dx + matrix.mf * dy + matrix.mj * dz;
         var oz:Number = matrix.mc * dx + matrix.mg * dy + matrix.mk * dz;
         dx = matrix.ma * direction.x + matrix.me * direction.y + matrix.mi * direction.z;
         dy = matrix.mb * direction.x + matrix.mf * direction.y + matrix.mj * direction.z;
         dz = matrix.mc * direction.x + matrix.mg * direction.y + matrix.mk * direction.z;
         if(dx < epsilon && dx > -epsilon)
         {
            if(ox < -this.halfSize.x || ox > this.halfSize.x)
            {
               return -1;
            }
         }
         else
         {
            t1 = (-this.halfSize.x - ox) / dx;
            t2 = (this.halfSize.x - ox) / dx;
            if(t1 < t2)
            {
               if(t1 > tMin)
               {
                  tMin = t1;
                  normal.x = -1;
                  normal.y = normal.z = 0;
               }
               if(t2 < tMax)
               {
                  tMax = t2;
               }
            }
            else
            {
               if(t2 > tMin)
               {
                  tMin = t2;
                  normal.x = 1;
                  normal.y = normal.z = 0;
               }
               if(t1 < tMax)
               {
                  tMax = t1;
               }
            }
            if(tMax < tMin)
            {
               return -1;
            }
         }
         if(dy < epsilon && dy > -epsilon)
         {
            if(oy < -this.halfSize.y || oy > this.halfSize.y)
            {
               return -1;
            }
         }
         else
         {
            t1 = (-this.halfSize.y - oy) / dy;
            t2 = (this.halfSize.y - oy) / dy;
            if(t1 < t2)
            {
               if(t1 > tMin)
               {
                  tMin = t1;
                  normal.y = -1;
                  normal.x = normal.z = 0;
               }
               if(t2 < tMax)
               {
                  tMax = t2;
               }
            }
            else
            {
               if(t2 > tMin)
               {
                  tMin = t2;
                  normal.y = 1;
                  normal.x = normal.z = 0;
               }
               if(t1 < tMax)
               {
                  tMax = t1;
               }
            }
            if(tMax < tMin)
            {
               return -1;
            }
         }
         if(dz < epsilon && dz > -epsilon)
         {
            if(oz < -this.halfSize.z || oz > this.halfSize.z)
            {
               return -1;
            }
         }
         else
         {
            t1 = (-this.halfSize.z - oz) / dz;
            t2 = (this.halfSize.z - oz) / dz;
            if(t1 < t2)
            {
               if(t1 > tMin)
               {
                  tMin = t1;
                  normal.z = -1;
                  normal.x = normal.y = 0;
               }
               if(t2 < tMax)
               {
                  tMax = t2;
               }
            }
            else
            {
               if(t2 > tMin)
               {
                  tMin = t2;
                  normal.z = 1;
                  normal.x = normal.y = 0;
               }
               if(t1 < tMax)
               {
                  tMax = t1;
               }
            }
            if(tMax < tMin)
            {
               return -1;
            }
         }
         dx = Number(normal.x);
         dy = Number(normal.y);
         dz = Number(normal.z);
         normal.x = matrix.ma * dx + matrix.mb * dy + matrix.mc * dz;
         normal.y = matrix.me * dx + matrix.mf * dy + matrix.mg * dz;
         normal.z = matrix.mi * dx + matrix.mj * dy + matrix.mk * dz;
         return tMin;
      }
   }
}

