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
      
      private static var zuby:ConicAreaTargetingSystem;
      
      private static var gohosumy:SmokyData;
      
      private static var zehedori:TwinsData;
      
      public static const meco:String = "thunder";
      
      public static const daduhah:String = "twins";
      
      public static const byqif:String = "flamethrower";
      
      public static const leqib:Object = new Object();
      
      public function Turrets()
      {
         super();
      }
      
      public static function getWeapon(param1:String) : Weapon
      {
         var _loc2_:TankTurret = leqib[param1];
         switch(param1)
         {
            case meco:
               if(gohosumy == null)
               {
                  gohosumy = new SmokyData();
                  gohosumy.syli.beryfitu = _loc2_.beryfitu;
               }
               return new SmokyWeapon(gohosumy.syli,gohosumy.namekazaf,gohosumy.hobuna);
            case daduhah:
               if(zehedori == null)
               {
                  zehedori = new TwinsData();
                  zehedori.syli.beryfitu = _loc2_.beryfitu;
               }
               return new PlasmaWeapon(zehedori.syli,zehedori.namekazaf,zehedori.hobuna,2);
            case byqif:
               if(zuby == null)
               {
                  zuby = new ConicAreaTargetingSystem(2000,20 * Math.PI / 180,5,6,GameData.kymaqos,new DefaultConicAreaTargetValidator());
               }
               return new StreamWeapon(_loc2_.beryfitu,1000,100,80,500,zuby,getFlamethrowerEffects());
            default:
               return null;
         }
      }
      
      private static function getFlamethrowerEffects() : FlamethrowerEffects
      {
         var _loc1_:StreamWeaponSFXData = new StreamWeaponSFXData();
         _loc1_.mutovudi = Assets.getData("flame",Sound);
         _loc1_.qywyr = Assets.getData("flame",TextureAnimation);
         _loc1_.qywyr.fps = 30;
         return new FlamethrowerEffects(2000,20 * Math.PI / 180,_loc1_);
      }
   }
}

