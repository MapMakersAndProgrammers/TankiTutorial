package alternativa.tanks.vehicles.tank.weapons
{
   public class WeaponSettings
   {
      
      public static const bogahyten:Number = 5000000;
      
      public var recoilForce:Number;
      
      public var impactForce:Number;
      
      public var damage:Number;
      
      public var reloadTime:uint;
      
      public function WeaponSettings(param1:Number, param2:Number, damage:Number, reloadTime:int)
      {
         super();
         this.impactForce = param1 * bogahyten;
         this.recoilForce = param2 * bogahyten;
         this.damage = damage;
         this.reloadTime = reloadTime;
      }
      
      public static function getNumRays(angle:Number) : int
      {
         return 2 * 180 * angle / Math.PI;
      }
   }
}

