package tutorial
{
   import alternativa.tanks.vehicles.tank.TankHull;
   import alternativa.utils.MathUtils;
   
   public class Hulls
   {
      
      public static const VIKING:String = "viking";
      
      public static const HORNET:String = "hornet";
      
      public static const objects:Object = {};
      
      public function Hulls()
      {
         super();
      }
      
      public static function applyProfile(xml:XML, hull:TankHull) : void
      {
         hull.mass = xml.@mass;
         hull.damping = xml.@damping;
         hull.health = xml.@health;
         hull.speed = xml.@speed;
         hull.acceleration = xml.@acceleration;
         hull.reverseAcceleration = xml.@reverseAcceleration;
         hull.sideAcceleration = xml.@sideAcceleration;
         hull.turnSpeed = MathUtils.toRadians(xml.@turnSpeed);
         hull.turnAcceleration = MathUtils.toRadians(xml.@turnAcceleration);
         hull.reverseTurnAcceleration = MathUtils.toRadians(xml.@reverseTurnAcceleration);
      }
   }
}

