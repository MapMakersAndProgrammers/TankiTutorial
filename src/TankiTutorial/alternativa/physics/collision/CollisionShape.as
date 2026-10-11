package alternativa.physics.collision
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.types.AABB;
   
   public class CollisionShape
   {
      
      public static const BOX:int = 1;
      
      public static const lumog:int = 2;
      
      public static const RECT:int = 4;
      
      public static const TRIANGLE:int = 8;
      
      public var type:int;
      
      public var collisionGroup:int;
      
      public var body:Body;
      
      public var localTransform:Matrix4;
      
      public var transform:Matrix4 = new Matrix4();
      
      public var aabb:AABB = new AABB();
      
      public var material:PhysicsMaterial;
      
      public function CollisionShape(type:int, collisionGroup:int, material:PhysicsMaterial)
      {
         super();
         this.type = type;
         this.collisionGroup = collisionGroup;
         this.material = material;
      }
      
      public function setBody(param1:Body, param2:Matrix4 = null) : void
      {
         if(this.body == param1)
         {
            return;
         }
         this.body = param1;
         if(param1 != null)
         {
            if(param2 != null)
            {
               if(this.localTransform == null)
               {
                  this.localTransform = new Matrix4();
               }
               this.localTransform.copy(param2);
            }
            else
            {
               this.localTransform = null;
            }
         }
      }
      
      public function calculateAABB() : AABB
      {
         return this.aabb;
      }
      
      public function raycast(origin:Vector3, direction:Vector3, epsilon:Number, normal:Vector3) : Number
      {
         return -1;
      }
      
      public function clone() : CollisionShape
      {
         var shape:CollisionShape = this.createPrimitive();
         return shape.copyFrom(this);
      }
      
      public function copyFrom(source:CollisionShape) : CollisionShape
      {
         if(source == null)
         {
            throw new ArgumentError("Parameter source cannot be null");
         }
         this.type = source.type;
         this.transform.copy(source.transform);
         this.collisionGroup = source.collisionGroup;
         this.setBody(source.body,source.localTransform);
         this.aabb.copyFrom(source.aabb);
         return this;
      }
      
      protected function createPrimitive() : CollisionShape
      {
         return new CollisionShape(this.type,this.collisionGroup,this.material);
      }
   }
}

