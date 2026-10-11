package alternativa.tanks.vehicles.tank.weapons.twins
{
   import alternativa.tanks.sfx.twins.PlasmaEffects;
   import alternativa.tanks.sfx.twins.PlasmaShot;
   import alternativa.tanks.vehicles.tank.weapons.CommonTargetingSystem;
   import alternativa.tanks.vehicles.tank.weapons.DMCommonTargetEvaluator;
   import alternativa.tanks.vehicles.tank.weapons.WeaponSettings;
   import tutorial.GameData;
   
   public class TwinsData
   {
      
      public var settings:WeaponSettings;
      
      public var effects:PlasmaEffects;
      
      public var targetingSystem:CommonTargetingSystem;
      
      public function TwinsData()
      {
         super();
         this.settings = new WeaponSettings(0.3,0.25,50,330);
         this.effects = new PlasmaEffects();
         var angleUp:Number = 10 * Math.PI / 180;
         var angleDown:Number = 14 * Math.PI / 180;
         this.targetingSystem = new CommonTargetingSystem(PlasmaShot.MAX_DISTANCE,angleUp,WeaponSettings.getNumRays(angleUp),angleDown,WeaponSettings.getNumRays(angleDown),GameData.collisionDetector,new DMCommonTargetEvaluator());
      }
   }
}

