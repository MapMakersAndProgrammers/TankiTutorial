package alternativa.physics.collision.types
{
   import flash.utils.getQualifiedClassName;
   
   public class AABB
   {
      
      public var minX:Number = 1e+308;
      
      public var minY:Number = 1e+308;
      
      public var minZ:Number = 1e+308;
      
      public var maxX:Number = -1e+308;
      
      public var maxY:Number = -1e+308;
      
      public var maxZ:Number = -1e+308;
      
      public function AABB()
      {
         super();
      }
      
      public function setSize(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number) : void
      {
         this.minX = minX;
         this.minY = minY;
         this.minZ = minZ;
         this.maxX = maxX;
         this.maxY = maxY;
         this.maxZ = maxZ;
      }
      
      public function addBoundBox(boundBox:AABB) : void
      {
         this.minX = boundBox.minX < this.minX ? boundBox.minX : this.minX;
         this.minY = boundBox.minY < this.minY ? boundBox.minY : this.minY;
         this.minZ = boundBox.minZ < this.minZ ? boundBox.minZ : this.minZ;
         this.maxX = boundBox.maxX > this.maxX ? boundBox.maxX : this.maxX;
         this.maxY = boundBox.maxY > this.maxY ? boundBox.maxY : this.maxY;
         this.maxZ = boundBox.maxZ > this.maxZ ? boundBox.maxZ : this.maxZ;
      }
      
      public function addPoint(x:Number, y:Number, z:Number) : void
      {
         if(x < this.minX)
         {
            this.minX = x;
         }
         if(x > this.maxX)
         {
            this.maxX = x;
         }
         if(y < this.minY)
         {
            this.minY = y;
         }
         if(y > this.maxY)
         {
            this.maxY = y;
         }
         if(z < this.minZ)
         {
            this.minZ = z;
         }
         if(z > this.maxZ)
         {
            this.maxZ = z;
         }
      }
      
      public function infinity() : void
      {
         this.minX = 1e+308;
         this.minY = 1e+308;
         this.minZ = 1e+308;
         this.maxX = -1e+308;
         this.maxY = -1e+308;
         this.maxZ = -1e+308;
      }
      
      public function intersects(aabb:AABB, epsilon:Number) : Boolean
      {
         return !(this.minX > aabb.maxX + epsilon || this.maxX < aabb.minX - epsilon || this.minY > aabb.maxY + epsilon || this.maxY < aabb.minY - epsilon || this.minZ > aabb.maxZ + epsilon || this.maxZ < aabb.minZ - epsilon);
      }
      
      public function copyFrom(aabb:AABB) : void
      {
         this.minX = aabb.minX;
         this.minY = aabb.minY;
         this.minZ = aabb.minZ;
         this.maxX = aabb.maxX;
         this.maxY = aabb.maxY;
         this.maxZ = aabb.maxZ;
      }
      
      public function clone() : AABB
      {
         var aabb:AABB = new AABB();
         aabb.copyFrom(this);
         return aabb;
      }
      
      public function getSizeX() : Number
      {
         return this.maxX - this.minX;
      }
      
      public function getSizeY() : Number
      {
         return this.maxY - this.minY;
      }
      
      public function getSizeZ() : Number
      {
         return this.maxZ - this.minZ;
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + "(" + this.minX.toFixed(3) + ", " + this.minY.toFixed(3) + ", " + this.minZ.toFixed(3) + ": " + this.maxX.toFixed(3) + ", " + this.maxY.toFixed(3) + ", " + this.maxZ.toFixed(3) + ")";
      }
   }
}

