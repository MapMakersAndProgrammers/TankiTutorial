package alternativa.physics.collision.primitives
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.types.AABB;
   
   public class CollisionTriangle extends CollisionShape
   {
      
      public var v0:Vector3 = new Vector3();
      
      public var v1:Vector3 = new Vector3();
      
      public var v2:Vector3 = new Vector3();
      
      public var e0:Vector3 = new Vector3();
      
      public var e1:Vector3 = new Vector3();
      
      public var e2:Vector3 = new Vector3();
      
      public function CollisionTriangle(v0:Vector3, v1:Vector3, v2:Vector3, collisionGroup:int, material:PhysicsMaterial)
      {
         super(TRIANGLE,collisionGroup,material);
         this.initVertices(v0,v1,v2);
      }
      
      override public function calculateAABB() : AABB
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var bounds:AABB = this.aabb;
         var matrix:Matrix4 = this.transform;
         var epsilon:Number = 0.005;
         var _loc6_:Number = epsilon * matrix.mc;
         var _loc7_:Number = epsilon * matrix.mg;
         var _loc8_:Number = epsilon * matrix.mk;
         _loc4_ = this.v0.x * matrix.ma + this.v0.y * matrix.mb;
         bounds.minX = bounds.maxX = _loc4_ + _loc6_;
         _loc5_ = _loc4_ - _loc6_;
         if(_loc5_ > bounds.maxX)
         {
            bounds.maxX = _loc5_;
         }
         else if(_loc5_ < bounds.minX)
         {
            bounds.minX = _loc5_;
         }
         _loc4_ = this.v0.x * matrix.me + this.v0.y * matrix.mf;
         bounds.minY = bounds.maxY = _loc4_ + _loc7_;
         _loc5_ = _loc4_ - _loc7_;
         if(_loc5_ > bounds.maxY)
         {
            bounds.maxY = _loc5_;
         }
         else if(_loc5_ < bounds.minY)
         {
            bounds.minY = _loc5_;
         }
         _loc4_ = this.v0.x * matrix.mi + this.v0.y * matrix.mj;
         bounds.minZ = bounds.maxZ = _loc4_ + _loc8_;
         _loc5_ = _loc4_ - _loc8_;
         if(_loc5_ > bounds.maxZ)
         {
            bounds.maxZ = _loc5_;
         }
         else if(_loc5_ < bounds.minZ)
         {
            bounds.minZ = _loc5_;
         }
         _loc4_ = this.v1.x * matrix.ma + this.v1.y * matrix.mb;
         _loc5_ = _loc4_ + _loc6_;
         if(_loc5_ > bounds.maxX)
         {
            bounds.maxX = _loc5_;
         }
         else if(_loc5_ < bounds.minX)
         {
            bounds.minX = _loc5_;
         }
         _loc5_ = _loc4_ - _loc6_;
         if(_loc5_ > bounds.maxX)
         {
            bounds.maxX = _loc5_;
         }
         else if(_loc5_ < bounds.minX)
         {
            bounds.minX = _loc5_;
         }
         _loc4_ = this.v1.x * matrix.me + this.v1.y * matrix.mf;
         _loc5_ = _loc4_ + _loc7_;
         if(_loc5_ > bounds.maxY)
         {
            bounds.maxY = _loc5_;
         }
         else if(_loc5_ < bounds.minY)
         {
            bounds.minY = _loc5_;
         }
         _loc5_ = _loc4_ - _loc7_;
         if(_loc5_ > bounds.maxY)
         {
            bounds.maxY = _loc5_;
         }
         else if(_loc5_ < bounds.minY)
         {
            bounds.minY = _loc5_;
         }
         _loc4_ = this.v1.x * matrix.mi + this.v1.y * matrix.mj;
         _loc5_ = _loc4_ + _loc8_;
         if(_loc5_ > bounds.maxZ)
         {
            bounds.maxZ = _loc5_;
         }
         else if(_loc5_ < bounds.minZ)
         {
            bounds.minZ = _loc5_;
         }
         _loc5_ = _loc4_ - _loc8_;
         if(_loc5_ > bounds.maxZ)
         {
            bounds.maxZ = _loc5_;
         }
         else if(_loc5_ < bounds.minZ)
         {
            bounds.minZ = _loc5_;
         }
         _loc4_ = this.v2.x * matrix.ma + this.v2.y * matrix.mb;
         _loc5_ = _loc4_ + _loc6_;
         if(_loc5_ > bounds.maxX)
         {
            bounds.maxX = _loc5_;
         }
         else if(_loc5_ < bounds.minX)
         {
            bounds.minX = _loc5_;
         }
         _loc5_ = _loc4_ - _loc6_;
         if(_loc5_ > bounds.maxX)
         {
            bounds.maxX = _loc5_;
         }
         else if(_loc5_ < bounds.minX)
         {
            bounds.minX = _loc5_;
         }
         _loc4_ = this.v2.x * matrix.me + this.v2.y * matrix.mf;
         _loc5_ = _loc4_ + _loc7_;
         if(_loc5_ > bounds.maxY)
         {
            bounds.maxY = _loc5_;
         }
         else if(_loc5_ < bounds.minY)
         {
            bounds.minY = _loc5_;
         }
         _loc5_ = _loc4_ - _loc7_;
         if(_loc5_ > bounds.maxY)
         {
            bounds.maxY = _loc5_;
         }
         else if(_loc5_ < bounds.minY)
         {
            bounds.minY = _loc5_;
         }
         _loc4_ = this.v2.x * matrix.mi + this.v2.y * matrix.mj;
         _loc5_ = _loc4_ + _loc8_;
         if(_loc5_ > bounds.maxZ)
         {
            bounds.maxZ = _loc5_;
         }
         else if(_loc5_ < bounds.minZ)
         {
            bounds.minZ = _loc5_;
         }
         _loc5_ = _loc4_ - _loc8_;
         if(_loc5_ > bounds.maxZ)
         {
            bounds.maxZ = _loc5_;
         }
         else if(_loc5_ < bounds.minZ)
         {
            bounds.minZ = _loc5_;
         }
         bounds.minX += matrix.md;
         bounds.maxX += matrix.md;
         bounds.minY += matrix.mh;
         bounds.maxY += matrix.mh;
         bounds.minZ += matrix.ml;
         bounds.maxZ += matrix.ml;
         return bounds;
      }
      
      override public function raycast(origin:Vector3, direction:Vector3, epsilon:Number, normal:Vector3) : Number
      {
         var matrix:Matrix4 = null;
         matrix = this.transform;
         var dot:Number = direction.x * matrix.mc + direction.y * matrix.mg + direction.z * matrix.mk;
         if(dot < epsilon && dot > -epsilon)
         {
            return -1;
         }
         var _loc7_:Number = origin.x - matrix.md;
         var _loc8_:Number = origin.y - matrix.mh;
         var _loc9_:Number = origin.z - matrix.ml;
         var distance:Number = _loc7_ * matrix.mc + _loc8_ * matrix.mg + _loc9_ * matrix.mk;
         var t:Number = -distance / dot;
         if(t < 0)
         {
            return -1;
         }
         var ox:Number = _loc7_ * matrix.ma + _loc8_ * matrix.me + _loc9_ * matrix.mi;
         var oy:Number = _loc7_ * matrix.mb + _loc8_ * matrix.mf + _loc9_ * matrix.mj;
         _loc7_ = ox + t * (direction.x * matrix.ma + direction.y * matrix.me + direction.z * matrix.mi);
         _loc8_ = oy + t * (direction.x * matrix.mb + direction.y * matrix.mf + direction.z * matrix.mj);
         if(this.e0.x * (_loc8_ - this.v0.y) - this.e0.y * (_loc7_ - this.v0.x) < 0 || this.e1.x * (_loc8_ - this.v1.y) - this.e1.y * (_loc7_ - this.v1.x) < 0 || this.e2.x * (_loc8_ - this.v2.y) - this.e2.y * (_loc7_ - this.v2.x) < 0)
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
      
      override public function copyFrom(source:CollisionShape) : CollisionShape
      {
         super.copyFrom(source);
         var triangle:CollisionTriangle = source as CollisionTriangle;
         if(triangle != null)
         {
            this.v0.copy(triangle.v0);
            this.v1.copy(triangle.v1);
            this.v2.copy(triangle.v2);
            this.e0.copy(triangle.e0);
            this.e1.copy(triangle.e1);
            this.e2.copy(triangle.e2);
         }
         return this;
      }
      
      override protected function createPrimitive() : CollisionShape
      {
         return new CollisionTriangle(this.v0,this.v1,this.v2,collisionGroup,material);
      }
      
      private function initVertices(a:Vector3, b:Vector3, c:Vector3) : void
      {
         this.v0.copy(a);
         this.v1.copy(b);
         this.v2.copy(c);
         this.e0.diff(b,a);
         this.e0.normalize();
         this.e1.diff(c,b);
         this.e1.normalize();
         this.e2.diff(a,c);
         this.e2.normalize();
      }
   }
}

