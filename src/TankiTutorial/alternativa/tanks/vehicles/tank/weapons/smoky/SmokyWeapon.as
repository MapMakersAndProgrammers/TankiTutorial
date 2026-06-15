package alternativa.tanks.vehicles.tank.weapons.smoky
{
   import alternativa.tanks.sfx.smoky.SmokyEffects;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.weapons.CommonTargetingSystem;
   import alternativa.tanks.vehicles.tank.weapons.HitInfo;
   import alternativa.tanks.vehicles.tank.weapons.TurretData;
   import alternativa.tanks.vehicles.tank.weapons.Weapon;
   import alternativa.tanks.vehicles.tank.weapons.WeaponSettings;
   
   public class SmokyWeapon extends Weapon
   {
      
      private var hur:uint;
      
      private const vimub:HitInfo = new HitInfo();
      
      private var namekazaf:CommonTargetingSystem;
      
      private var syli:WeaponSettings;
      
      private var hobuna:SmokyEffects;
      
      public function SmokyWeapon(param1:WeaponSettings, param2:CommonTargetingSystem, param3:SmokyEffects)
      {
         super("Smoky Gun");
         this.syli = param1;
         this.namekazaf = param2;
         this.hobuna = param3;
      }
      
      override public function update(param1:int, param2:int) : void
      {
         if(zadawe && param1 >= this.hur)
         {
            this.hur = param1 + this.syli.qyvynefi;
            this.fire();
         }
         mamifoma = 1 - (this.hur - param1) / this.syli.qyvynefi;
         if(mamifoma > 1)
         {
            mamifoma = 1;
         }
      }
      
      override public function getTarget() : Tank
      {
         var _loc1_:TurretData = getData();
         var _loc2_:Tank = getTank();
         _loc1_.update(_loc2_,0);
         if(this.namekazaf.getTarget(_loc1_.fybumu,_loc1_.ruda,_loc1_.zequsir,_loc2_.body,10000000000,this.vimub))
         {
            if(this.vimub.body != null)
            {
               return this.vimub.body.katuf as Tank;
            }
         }
         return null;
      }
      
      private function fire() : void
      {
         var _loc3_:Tank = null;
         var _loc1_:TurretData = getData();
         var _loc2_:Tank = getTank();
         _loc1_.update(_loc2_,0);
         this.hobuna.createShotEffects(_loc1_.toqumyc,_loc1_.turretMesh);
         if(this.namekazaf.getTarget(_loc1_.fybumu,_loc1_.ruda,_loc1_.zequsir,_loc2_.body,10000000000,this.vimub))
         {
            this.hobuna.createExplosionEffects(this.vimub.wimybu,1);
            if(this.vimub.body != null)
            {
               _loc3_ = this.vimub.body.katuf as Tank;
               if(_loc3_ != null)
               {
                  this.vimub.body.addWorldForceScaled(this.vimub.wimybu,this.vimub.bec,this.syli.myd);
                  _loc3_.substructHealth(this.syli.beryfitu * kuqy);
               }
            }
         }
         _loc2_.body.addWorldForceScaled(_loc1_.fybumu,_loc1_.ruda,-this.syli.pocobyr);
      }
   }
}

