package alternativa.tanks.vehicles.tank.weapons
{
   public class WeaponSettings
   {
      
      public static const bogahyten:Number = 5000000;
      
      public var recoilForce:Number;
      
      public var impactForce:Number;
      
      public var damage:Number;
      
      public var reloadTime:uint;
      
      public function WeaponSettings(param1:Number, param2:Number, param3:Number, param4:int)
      {
         super();
         this.impactForce = param1 * bogahyten;
         this.recoilForce = param2 * bogahyten;
         this.damage = param3;
         this.reloadTime = param4;
      }
      
      public static function getNumRays(angle:Number) : int
      {
         return 2 * 180 * angle / Math.PI;
      }
   }
}

