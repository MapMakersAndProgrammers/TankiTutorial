package alternativa.physics.collision.primitives
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.types.AABB;
   
   public class CollisionTriangle extends CollisionShape
   {
      
      public var lyzud:Vector3 = new Vector3();
      
      public var pedake:Vector3 = new Vector3();
      
      public var bykecy:Vector3 = new Vector3();
      
      public var dodupypic:Vector3 = new Vector3();
      
      public var cilozuj:Vector3 = new Vector3();
      
      public var dij:Vector3 = new Vector3();
      
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
         _loc4_ = this.lyzud.x * matrix.ma + this.lyzud.y * matrix.mb;
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
         _loc4_ = this.lyzud.x * matrix.me + this.lyzud.y * matrix.mf;
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
         _loc4_ = this.lyzud.x * matrix.mi + this.lyzud.y * matrix.mj;
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
         _loc4_ = this.pedake.x * matrix.ma + this.pedake.y * matrix.mb;
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
         _loc4_ = this.pedake.x * matrix.me + this.pedake.y * matrix.mf;
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
         _loc4_ = this.pedake.x * matrix.mi + this.pedake.y * matrix.mj;
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
         _loc4_ = this.bykecy.x * matrix.ma + this.bykecy.y * matrix.mb;
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
         _loc4_ = this.bykecy.x * matrix.me + this.bykecy.y * matrix.mf;
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
         _loc4_ = this.bykecy.x * matrix.mi + this.bykecy.y * matrix.mj;
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
         if(this.dodupypic.x * (_loc8_ - this.lyzud.y) - this.dodupypic.y * (_loc7_ - this.lyzud.x) < 0 || this.cilozuj.x * (_loc8_ - this.pedake.y) - this.cilozuj.y * (_loc7_ - this.pedake.x) < 0 || this.dij.x * (_loc8_ - this.bykecy.y) - this.dij.y * (_loc7_ - this.bykecy.x) < 0)
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
            this.lyzud.copy(triangle.lyzud);
            this.pedake.copy(triangle.pedake);
            this.bykecy.copy(triangle.bykecy);
            this.dodupypic.copy(triangle.dodupypic);
            this.cilozuj.copy(triangle.cilozuj);
            this.dij.copy(triangle.dij);
         }
         return this;
      }
      
      override protected function createPrimitive() : CollisionShape
      {
         return new CollisionTriangle(this.lyzud,this.pedake,this.bykecy,collisionGroup,material);
      }
      
      private function initVertices(a:Vector3, b:Vector3, c:Vector3) : void
      {
         this.lyzud.copy(a);
         this.pedake.copy(b);
         this.bykecy.copy(c);
         this.dodupypic.diff(b,a);
         this.dodupypic.normalize();
         this.cilozuj.diff(c,b);
         this.cilozuj.normalize();
         this.dij.diff(a,c);
         this.dij.normalize();
      }
   }
}

