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
         hull.sasi = xml.@damping;
         hull.quj = xml.@health;
         hull.speed = xml.@speed;
         hull.acceleration = xml.@acceleration;
         hull.qezuw = xml.@reverseAcceleration;
         hull.wito = xml.@sideAcceleration;
         hull.pyfika = MathUtils.toRadians(xml.@turnSpeed);
         hull.qupi = MathUtils.toRadians(xml.@turnAcceleration);
         hull.beg = MathUtils.toRadians(xml.@reverseTurnAcceleration);
      }
   }
}

