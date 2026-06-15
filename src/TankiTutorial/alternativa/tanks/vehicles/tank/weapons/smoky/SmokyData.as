package alternativa.tanks.vehicles.tank.weapons.smoky
{
   import alternativa.tanks.sfx.smoky.SmokyEffects;
   import alternativa.tanks.sfx.smoky.SmokySFXData;
   import alternativa.tanks.vehicles.tank.weapons.CommonTargetingSystem;
   import alternativa.tanks.vehicles.tank.weapons.DMCommonTargetEvaluator;
   import alternativa.tanks.vehicles.tank.weapons.WeaponSettings;
   import tutorial.GameData;
   
   public class SmokyData
   {
      
      public var syli:WeaponSettings;
      
      public var hobuna:SmokyEffects;
      
      public var namekazaf:CommonTargetingSystem;
      
      public function SmokyData()
      {
         super();
         this.syli = new WeaponSettings(1.8,1.3,200,1500);
         this.hobuna = new SmokyEffects(new SmokySFXData());
         var _loc1_:Number = 9 * Math.PI / 180;
         var _loc2_:Number = 12 * Math.PI / 180;
         this.namekazaf = new CommonTargetingSystem(9000,_loc1_,WeaponSettings.getNumRays(_loc1_),_loc2_,WeaponSettings.getNumRays(_loc2_),GameData.kymaqos,new DMCommonTargetEvaluator());
      }
   }
}

