package alternativa.tanks.vehicles.tank.weapons
{
   public class WeaponSettings
   {
      
      public static const bogahyten:Number = 5000000;
      
      public var pocobyr:Number;
      
      public var myd:Number;
      
      public var beryfitu:Number;
      
      public var qyvynefi:uint;
      
      public function WeaponSettings(param1:Number, param2:Number, param3:Number, param4:int)
      {
         super();
         this.myd = param1 * bogahyten;
         this.pocobyr = param2 * bogahyten;
         this.beryfitu = param3;
         this.qyvynefi = param4;
      }
      
      public static function getNumRays(param1:Number) : int
      {
         return 2 * 180 * param1 / Math.PI;
      }
   }
}

