package alternativa.physics.collision
{
   import alternativa.physics.collision.types.AABB;
   
   public class CollisionKdNode
   {
      
      public var indices:Vector.<int>;
      
      public var splitIndices:Vector.<int>;
      
      public var boundBox:AABB;
      
      public var parent:CollisionKdNode;
      
      public var splitTree:CollisionKdTree2D;
      
      public var axis:int = -1;
      
      public var coord:Number;
      
      public var positive:CollisionKdNode;
      
      public var negative:CollisionKdNode;
      
      public function CollisionKdNode()
      {
         super();
      }
   }
}

