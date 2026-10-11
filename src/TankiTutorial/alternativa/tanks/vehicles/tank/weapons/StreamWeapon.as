package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.physics.Body;
   import alternativa.tanks.sfx.flamethrower.FlamethrowerEffects;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.utils.getTimer;
   import tutorial.GameData;
   
   public class StreamWeapon extends Weapon
   {
      
      private static const wuvyt:int = 1000;
      
      private static const qipuji:Number = 0.3;
      
      private static const targets:Vector.<Body> = new Vector.<Body>();
      
      private static const distances:Vector.<Number> = new Vector.<Number>();
      
      private var maxEnergy:Number;
      
      private var energyDischargeRate:Number;
      
      private var energyRechargeRate:Number;
      
      private var tickInterval:int;
      
      private var targetingSystem:ConicAreaTargetingSystem;
      
      private var effects:FlamethrowerEffects;
      
      private var nextTickTime:int;
      
      private var shooting:Boolean;
      
      private var baseTime:int;
      
      private var numTicks:int;
      
      private var damage:Number;
      
      private var outOfEnergy:Boolean = false;
      
      public function StreamWeapon(damage:Number, maxEnergy:Number, energyDischargeRate:Number, energyRechargeRate:Number, tickInterval:int, targetingSystem:ConicAreaTargetingSystem, effects:FlamethrowerEffects)
      {
         super("Flamethrower");
         this.damage = damage;
         this.maxEnergy = maxEnergy;
         this.energyDischargeRate = energyDischargeRate;
         this.energyRechargeRate = energyRechargeRate;
         this.tickInterval = tickInterval;
         this.targetingSystem = targetingSystem;
         this.effects = effects;
      }
      
      public function reset() : void
      {
         this.shooting = false;
         active = false;
         this.baseTime = 0;
         this.nextTickTime = 0;
         this.numTicks = 0;
      }
      
      override public function get status() : Number
      {
         var energy:Number = NaN;
         if(active && !this.outOfEnergy)
         {
            energy = this.getCurrentEnergyInShootingMode(getTimer());
         }
         else
         {
            energy = this.getCurrentEnergyInIdleMode(getTimer());
         }
         return energy / this.maxEnergy;
      }
      
      override public function update(time:int, deltaTime:int) : void
      {
         if(this.shooting)
         {
            this.runLogicForShootingMode(time);
         }
         else
         {
            this.runLogicForIdleMode(time);
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         this.effects.stopEffects();
      }
      
      private function runLogicForShootingMode(time:int) : void
      {
         if(active)
         {
            this.tryToTick(time);
            this.stopIfNecessary(time);
         }
         else
         {
            this.outOfEnergy = false;
            this.stopShoot(time);
         }
      }
      
      override public function start() : void
      {
         if(active)
         {
            return;
         }
         active = true;
         this.outOfEnergy = false;
      }
      
      private function tryToTick(time:int) : void
      {
         if(this.numTicks > 0)
         {
            if(this.nextTickTime <= time)
            {
               this.tick(time);
               this.numTicks -= 1;
            }
         }
      }
      
      private function stopIfNecessary(time:int) : void
      {
         if(this.numTicks == 0)
         {
            if(this.getCurrentEnergyInShootingMode(time) <= 0)
            {
               this.outOfEnergy = true;
               this.stopShoot(time);
            }
         }
      }
      
      private function runLogicForIdleMode(time:int) : void
      {
         if(active && !this.outOfEnergy)
         {
            this.startShoot(time);
         }
      }
      
      private function startShoot(time:int) : void
      {
         var energy:Number = NaN;
         var _loc3_:Tank = null;
         if(!this.shooting)
         {
            this.shooting = true;
            energy = this.getCurrentEnergyInIdleMode(time);
            this.baseTime = this.getBaseTimeForShootingMode(time,energy);
            this.calculateTicksNumber(energy);
            this.nextTickTime = time + this.tickInterval;
            _loc3_ = getTank();
            this.effects.startEffects(_loc3_.tankBody.body,_loc3_.turret.muzzles[0],_loc3_.skin.turretMesh);
         }
      }
      
      private function calculateTicksNumber(energy:Number) : void
      {
         this.numTicks = wuvyt * energy / (this.energyDischargeRate * this.tickInterval);
      }
      
      private function stopShoot(time:int) : void
      {
         if(this.shooting)
         {
            this.shooting = false;
            this.baseTime = time - this.getCurrentEnergyInShootingMode(time) / this.energyRechargeRate * wuvyt;
            this.numTicks = 0;
            this.effects.stopEffects();
         }
      }
      
      override public function getTarget() : Tank
      {
         var target:Tank = null;
         var i:int = 0;
         var body:Body = null;
         var targetTank:Tank = null;
         var turretData:TurretData = getData();
         var _loc2_:Tank = getTank();
         turretData.update(_loc2_,0);
         this.targetingSystem.getTargets(_loc2_.tankBody.body,turretData.barrelLength,qipuji,turretData.barrelOrigin,turretData.direction,turretData.xAxis,targets,distances);
         var numTargets:int = int(targets.length);
         if(numTargets == 1)
         {
            i = 0;
            while(i < numTargets)
            {
               body = targets[i];
               targetTank = body.data as Tank;
               if(targetTank == GameData.playerTank)
               {
                  target = targetTank;
               }
               i++;
            }
         }
         targets.length = 0;
         distances.length = 0;
         return target;
      }
      
      private function tick(time:int) : void
      {
         var body:Body = null;
         var targetTank:Tank = null;
         this.nextTickTime = time + this.tickInterval;
         var turretData:TurretData = getData();
         var _loc3_:Tank = getTank();
         turretData.update(_loc3_,0);
         targets.length = 0;
         distances.length = 0;
         this.targetingSystem.getTargets(_loc3_.tankBody.body,turretData.barrelLength,qipuji,turretData.barrelOrigin,turretData.direction,turretData.xAxis,targets,distances);
         var numTargets:int = int(targets.length);
         var i:int = 0;
         while(i < numTargets)
         {
            body = targets[i];
            targetTank = body.data as Tank;
            if(targetTank != null)
            {
               targetTank.substructHealth(this.damage * damageMultiplier);
            }
            i++;
         }
         targets.length = 0;
         distances.length = 0;
      }
      
      private function getCurrentEnergyInIdleMode(time:int) : Number
      {
         var _loc2_:Number = this.maxEnergy;
         var energy:Number = this.energyRechargeRate * (time - this.baseTime) / wuvyt;
         return energy > _loc2_ ? _loc2_ : energy;
      }
      
      private function getCurrentEnergyInShootingMode(time:int) : Number
      {
         var energy:Number = this.maxEnergy - this.energyDischargeRate * (time - this.baseTime) / wuvyt;
         return energy < 0 ? 0 : energy;
      }
      
      private function getBaseTimeForIdleMode(time:int, energy:Number) : int
      {
         return time - energy / this.energyRechargeRate * wuvyt;
      }
      
      private function getBaseTimeForShootingMode(time:int, energy:Number) : int
      {
         return time - (this.maxEnergy - energy) / this.energyDischargeRate * wuvyt;
      }
   }
}

