package alternativa.physics.collision
{
   import alternativa.math.Vector3;
   import alternativa.physics.BodyContact;
   import alternativa.physics.ShapeContact;
   import alternativa.physics.collision.types.RayHit;
   
   public interface CollisionDetector
   {
      
      function getBodyContacts(contacts:Vector.<BodyContact>) : void;
      
      function raycast(origin:Vector3, direction:Vector3, collisionGroup:int, maxTime:Number, filter:IRayCollisionFilter, result:RayHit) : Boolean;
      
      function raycastStatic(origin:Vector3, direction:Vector3, collisionGroup:int, maxTime:Number, filter:IRayCollisionFilter, result:RayHit) : Boolean;
      
      function hasStaticHit(origin:Vector3, direction:Vector3, collisionGroup:int, maxTime:Number, filter:IRayCollisionFilter = null) : Boolean;
      
      function getContacts(shape1:CollisionShape, shape2:CollisionShape, contacts:Vector.<ShapeContact>) : void;
      
      function testCollision(shape1:CollisionShape, shape2:CollisionShape) : Boolean;
   }
}

