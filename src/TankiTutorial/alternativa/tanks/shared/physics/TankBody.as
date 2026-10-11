package alternativa.tanks.shared.physics
{
   import alternativa.physics.Body;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.primitives.CollisionBox;
   
   public class TankBody
   {
      
      public var id:int;
      
      public var body:Body;
      
      public var tankCollisionBox:CollisionBox;
      
      public const staticCollisionBoxes:Vector.<CollisionShape> = new Vector.<CollisionShape>();
      
      public var vahuzys:Boolean;
      
      public var put:Boolean;
      
      public function TankBody(body:Body)
      {
         super();
         this.body = body;
      }
      
      public function clearCollisionShapes() : void
      {
         this.body.clearCollisionShapes();
         this.staticCollisionBoxes.length = 0;
         this.tankCollisionBox = null;
      }
   }
}

