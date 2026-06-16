package alternativa.tanks.shared.physics
{
   import alternativa.physics.Body;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.primitives.CollisionBox;
   
   public class TankBody
   {
      
      public var wucejydy:int;
      
      public var body:Body;
      
      public var kyripama:CollisionBox;
      
      public const kodasy:Vector.<CollisionShape> = new Vector.<CollisionShape>();
      
      public var vahuzys:Boolean;
      
      public var put:Boolean;
      
      public function TankBody(param1:Body)
      {
         super();
         this.body = param1;
      }
      
      public function clearCollisionShapes() : void
      {
         this.body.clearCollisionShapes();
         this.kodasy.length = 0;
         this.kyripama = null;
      }
   }
}

