package tutorial
{
   import alternativa.tanks.vehicles.tank.TankHull;
   import alternativa.utils.MathUtils;
   
   public class Hulls
   {
      
      public static const jopanybi:String = "viking";
      
      public static const zelutabi:String = "hornet";
      
      public static const leqib:Object = {};
      
      public function Hulls()
      {
         super();
      }
      
      public static function applyProfile(param1:XML, param2:TankHull) : void
      {
         param2.tuwykus = param1.@mass;
         param2.sasi = param1.@damping;
         param2.quj = param1.@health;
         param2.wiciqy = param1.@speed;
         param2.cozo = param1.@acceleration;
         param2.qezuw = param1.@reverseAcceleration;
         param2.wito = param1.@sideAcceleration;
         param2.pyfika = MathUtils.toRadians(param1.@turnSpeed);
         param2.qupi = MathUtils.toRadians(param1.@turnAcceleration);
         param2.beg = MathUtils.toRadians(param1.@reverseTurnAcceleration);
      }
   }
}

