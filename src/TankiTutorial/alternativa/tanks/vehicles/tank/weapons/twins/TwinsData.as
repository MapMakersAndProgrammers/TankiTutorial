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
      
      public var syli:WeaponSettings;
      
      public var hobuna:PlasmaEffects;
      
      public var namekazaf:CommonTargetingSystem;
      
      public function TwinsData()
      {
         super();
         this.syli = new WeaponSettings(0.3,0.25,50,330);
         this.hobuna = new PlasmaEffects();
         var _loc1_:Number = 10 * Math.PI / 180;
         var _loc2_:Number = 14 * Math.PI / 180;
         this.namekazaf = new CommonTargetingSystem(PlasmaShot.qyk,_loc1_,WeaponSettings.getNumRays(_loc1_),_loc2_,WeaponSettings.getNumRays(_loc2_),GameData.kymaqos,new DMCommonTargetEvaluator());
      }
   }
}

