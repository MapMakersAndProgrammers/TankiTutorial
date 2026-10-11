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
      
      public var settings:WeaponSettings;
      
      public var effects:SmokyEffects;
      
      public var targetingSystem:CommonTargetingSystem;
      
      public function SmokyData()
      {
         super();
         this.settings = new WeaponSettings(1.8,1.3,200,1500);
         this.effects = new SmokyEffects(new SmokySFXData());
         var angleUp:Number = 9 * Math.PI / 180;
         var angleDown:Number = 12 * Math.PI / 180;
         this.targetingSystem = new CommonTargetingSystem(9000,angleUp,WeaponSettings.getNumRays(angleUp),angleDown,WeaponSettings.getNumRays(angleDown),GameData.collisionDetector,new DMCommonTargetEvaluator());
      }
   }
}

