package alternativa.physics.collision
{
   import alternativa.physics.ShapeContact;
   
   public interface Collider
   {
      
      function getContacts(shape1:CollisionShape, shape2:CollisionShape, contacts:Vector.<ShapeContact>) : void;
      
      function haveCollision(shape1:CollisionShape, shape2:CollisionShape) : Boolean;
   }
}

