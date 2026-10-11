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
      
      private var nextShotTime:uint;
      
      private const hitInfo:HitInfo = new HitInfo();
      
      private var targetingSystem:CommonTargetingSystem;
      
      private var settings:WeaponSettings;
      
      private var effects:SmokyEffects;
      
      public function SmokyWeapon(settings:WeaponSettings, targetingSystem:CommonTargetingSystem, effects:SmokyEffects)
      {
         super("Smoky Gun");
         this.settings = settings;
         this.targetingSystem = targetingSystem;
         this.effects = effects;
      }
      
      override public function update(time:int, deltaTime:int) : void
      {
         if(active && time >= this.nextShotTime)
         {
            this.nextShotTime = time + this.settings.reloadTime;
            this.fire();
         }
         _status = 1 - (this.nextShotTime - time) / this.settings.reloadTime;
         if(_status > 1)
         {
            _status = 1;
         }
      }
      
      override public function getTarget() : Tank
      {
         var turretData:TurretData = getData();
         var _loc2_:Tank = getTank();
         turretData.update(_loc2_,0);
         if(this.targetingSystem.getTarget(turretData.barrelOrigin,turretData.direction,turretData.xAxis,_loc2_.body,10000000000,this.hitInfo))
         {
            if(this.hitInfo.body != null)
            {
               return this.hitInfo.body.data as Tank;
            }
         }
         return null;
      }
      
      private function fire() : void
      {
         var target:Tank = null;
         var turretData:TurretData = getData();
         var _loc2_:Tank = getTank();
         turretData.update(_loc2_,0);
         this.effects.createShotEffects(turretData.localMuzzlePosition,turretData.turretMesh);
         if(this.targetingSystem.getTarget(turretData.barrelOrigin,turretData.direction,turretData.xAxis,_loc2_.body,10000000000,this.hitInfo))
         {
            this.effects.createExplosionEffects(this.hitInfo.position,1);
            if(this.hitInfo.body != null)
            {
               target = this.hitInfo.body.data as Tank;
               if(target != null)
               {
                  this.hitInfo.body.addWorldForceScaled(this.hitInfo.position,this.hitInfo.direction,this.settings.impactForce);
                  target.substructHealth(this.settings.damage * damageMultiplier);
               }
            }
         }
         _loc2_.body.addWorldForceScaled(turretData.barrelOrigin,turretData.direction,-this.settings.recoilForce);
      }
   }
}

