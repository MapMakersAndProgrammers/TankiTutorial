package tutorial
{
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.sfx.flamethrower.FlamethrowerEffects;
   import alternativa.tanks.sfx.flamethrower.StreamWeaponSFXData;
   import alternativa.tanks.vehicles.tank.TankTurret;
   import alternativa.tanks.vehicles.tank.weapons.ConicAreaTargetingSystem;
   import alternativa.tanks.vehicles.tank.weapons.DefaultConicAreaTargetValidator;
   import alternativa.tanks.vehicles.tank.weapons.StreamWeapon;
   import alternativa.tanks.vehicles.tank.weapons.Weapon;
   import alternativa.tanks.vehicles.tank.weapons.smoky.SmokyData;
   import alternativa.tanks.vehicles.tank.weapons.smoky.SmokyWeapon;
   import alternativa.tanks.vehicles.tank.weapons.twins.PlasmaWeapon;
   import alternativa.tanks.vehicles.tank.weapons.twins.TwinsData;
   import flash.media.Sound;
   import tutorial.commons.Assets;
   
   public class Turrets
   {
      
      private static var targetingSystem:ConicAreaTargetingSystem;
      
      private static var smokyData:SmokyData;
      
      private static var twinsData:TwinsData;
      
      public static const THUNDER:String = "thunder";
      
      public static const TWINS:String = "twins";
      
      public static const FLAMETHROWER:String = "flamethrower";
      
      public static const objects:Object = new Object();
      
      public function Turrets()
      {
         super();
      }
      
      public static function getWeapon(name:String) : Weapon
      {
         var turret:TankTurret = objects[name];
         switch(name)
         {
            case THUNDER:
               if(smokyData == null)
               {
                  smokyData = new SmokyData();
                  smokyData.settings.damage = turret.damage;
               }
               return new SmokyWeapon(smokyData.settings,smokyData.targetingSystem,smokyData.effects);
            case TWINS:
               if(twinsData == null)
               {
                  twinsData = new TwinsData();
                  twinsData.settings.damage = turret.damage;
               }
               return new PlasmaWeapon(twinsData.settings,twinsData.targetingSystem,twinsData.effects,2);
            case FLAMETHROWER:
               if(targetingSystem == null)
               {
                  targetingSystem = new ConicAreaTargetingSystem(2000,20 * Math.PI / 180,5,6,GameData.collisionDetector,new DefaultConicAreaTargetValidator());
               }
               return new StreamWeapon(turret.damage,1000,100,80,500,targetingSystem,getFlamethrowerEffects());
            default:
               return null;
         }
      }
      
      private static function getFlamethrowerEffects() : FlamethrowerEffects
      {
         var sfxData:StreamWeaponSFXData = new StreamWeaponSFXData();
         sfxData.flameSound = Assets.getData("flame",Sound);
         sfxData.particleAnimation = Assets.getData("flame",TextureAnimation);
         sfxData.particleAnimation.fps = 30;
         return new FlamethrowerEffects(2000,20 * Math.PI / 180,sfxData);
      }
   }
}

