package alternativa.physics.collision.primitives
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.types.AABB;
   
   public class CollisionRect extends CollisionShape
   {
      
      private static const EPSILON:Number = 0.005;
      
      public var halfSize:Vector3 = new Vector3();
      
      public function CollisionRect(halfSize:Vector3, collisionGroup:int, material:PhysicsMaterial)
      {
         super(RECT,collisionGroup,material);
         this.halfSize.copy(halfSize);
      }
      
      override public function calculateAABB() : AABB
      {
         var matrix:Matrix4 = null;
         matrix = transform;
         var _loc2_:Number = matrix.ma < 0 ? -matrix.ma : matrix.ma;
         var _loc3_:Number = matrix.mb < 0 ? -matrix.mb : matrix.mb;
         var _loc4_:Number = matrix.mc < 0 ? -matrix.mc : matrix.mc;
         var bounds:AABB = this.aabb;
         bounds.maxX = this.halfSize.x * _loc2_ + this.halfSize.y * _loc3_ + EPSILON * _loc4_;
         bounds.minX = -bounds.maxX;
         _loc2_ = matrix.me < 0 ? -matrix.me : matrix.me;
         _loc3_ = matrix.mf < 0 ? -matrix.mf : matrix.mf;
         _loc4_ = matrix.mg < 0 ? -matrix.mg : matrix.mg;
         bounds.maxY = this.halfSize.x * _loc2_ + this.halfSize.y * _loc3_ + EPSILON * _loc4_;
         bounds.minY = -bounds.maxY;
         _loc2_ = matrix.mi < 0 ? -matrix.mi : matrix.mi;
         _loc3_ = matrix.mj < 0 ? -matrix.mj : matrix.mj;
         _loc4_ = matrix.mk < 0 ? -matrix.mk : matrix.mk;
         bounds.maxZ = this.halfSize.x * _loc2_ + this.halfSize.y * _loc3_ + EPSILON * _loc4_;
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
         var rect:CollisionRect = source as CollisionRect;
         if(rect == null)
         {
            return this;
         }
         super.copyFrom(rect);
         this.halfSize.copy(rect.halfSize);
         return this;
      }
      
      override protected function createPrimitive() : CollisionShape
      {
         return new CollisionRect(this.halfSize,collisionGroup,material);
      }
      
      override public function raycast(origin:Vector3, direction:Vector3, epsilon:Number, normal:Vector3) : Number
      {
         var matrix:Matrix4 = null;
         matrix = this.transform;
         var dx:Number = origin.x - matrix.md;
         var dy:Number = origin.y - matrix.mh;
         var dz:Number = origin.z - matrix.ml;
         var ox:Number = matrix.ma * dx + matrix.me * dy + matrix.mi * dz;
         var oy:Number = matrix.mb * dx + matrix.mf * dy + matrix.mj * dz;
         var oz:Number = matrix.mc * dx + matrix.mg * dy + matrix.mk * dz;
         dx = matrix.ma * direction.x + matrix.me * direction.y + matrix.mi * direction.z;
         dy = matrix.mb * direction.x + matrix.mf * direction.y + matrix.mj * direction.z;
         dz = matrix.mc * direction.x + matrix.mg * direction.y + matrix.mk * direction.z;
         if(dz > -epsilon && dz < epsilon)
         {
            return -1;
         }
         var t:Number = -oz / dz;
         if(t < 0)
         {
            return -1;
         }
         ox += dx * t;
         oy += dy * t;
         oz = 0;
         if(ox < -this.halfSize.x - epsilon || ox > this.halfSize.x + epsilon || oy < -this.halfSize.y - epsilon || oy > this.halfSize.y + epsilon)
         {
            return -1;
         }
         if(direction.x * matrix.mc + direction.y * matrix.mg + direction.z * matrix.mk > 0)
         {
            normal.x = -matrix.mc;
            normal.y = -matrix.mg;
            normal.z = -matrix.mk;
         }
         else
         {
            normal.x = matrix.mc;
            normal.y = matrix.mg;
            normal.z = matrix.mk;
         }
         return t;
      }
   }
}

