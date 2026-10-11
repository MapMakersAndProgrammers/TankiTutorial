package alternativa.tanks.vehicles.tank.weapons.twins
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.sfx.twins.PlasmaEffects;
   import alternativa.tanks.sfx.twins.PlasmaShot;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.weapons.*;
   import flash.utils.getTimer;
   import tutorial.GameData;
   
   public class PlasmaWeapon extends Weapon
   {
      
      private static const shotDirection:Vector3 = new Vector3();
      
      private static const hitInfo:HitInfo = new HitInfo();
      
      private static const rayHit:RayHit = new RayHit();
      
      private var nextShotTime:int;
      
      private var targetingSystem:CommonTargetingSystem;
      
      private var numMuzzles:int;
      
      private var muzzleIndex:int;
      
      private var collisionDetector:CollisionDetector = GameData.collisionDetector;
      
      private var objectPool:ObjectPool = GameData.objectPool;
      
      private var settings:WeaponSettings;
      
      private var effects:PlasmaEffects;
      
      public function PlasmaWeapon(settings:WeaponSettings, targetingSystem:CommonTargetingSystem, effects:PlasmaEffects, numMuzzles:int)
      {
         super("Plasma");
         this.settings = settings;
         this.targetingSystem = targetingSystem;
         this.effects = effects;
         this.numMuzzles = numMuzzles;
      }
      
      override public function get status() : Number
      {
         var value:Number = 1 - (this.nextShotTime - getTimer()) / this.settings.reloadTime;
         return value > 1 ? 1 : value;
      }
      
      override public function update(time:int, deltaTime:int) : void
      {
         if(active && time >= this.nextShotTime)
         {
            this.shoot();
         }
      }
      
      override public function getTarget() : Tank
      {
         var turretData:TurretData = getData();
         var _loc2_:Tank = getTank();
         turretData.update(_loc2_,0);
         if(this.targetingSystem.getTarget(turretData.barrelOrigin,turretData.direction,turretData.xAxis,_loc2_.tankBody.body,10000000000,hitInfo))
         {
            if(hitInfo.body != null)
            {
               return hitInfo.body.data as Tank;
            }
         }
         return null;
      }
      
      private function shoot() : void
      {
         this.nextShotTime = getTimer() + this.settings.reloadTime;
         var _loc1_:Tank = getTank();
         var turretMesh:Mesh = _loc1_.skin.turretMesh;
         var muzzle:Vector3 = _loc1_.turret.muzzles[this.muzzleIndex];
         var turretData:TurretData = getData();
         turretData.update(_loc1_,this.muzzleIndex);
         _loc1_.tankBody.body.addWorldForceScaled(turretData.muzzlePosition,turretData.direction,-this.settings.recoilForce);
         this.effects.createShotEffects(turretMesh,_loc1_.turret.muzzles[this.muzzleIndex]);
         if(this.barrelCollidesWithStatic(turretData.barrelOrigin,turretData.direction,muzzle.y))
         {
            shotDirection.copy(turretData.direction);
         }
         else if(this.targetingSystem.getTarget(turretData.barrelOrigin,turretData.direction,turretData.xAxis,_loc1_.tankBody.body,10000000000,hitInfo))
         {
            shotDirection.diff(hitInfo.position,turretData.muzzlePosition).normalize();
         }
         else
         {
            shotDirection.copy(turretData.direction);
         }
         var shot:PlasmaShot = PlasmaShot(this.objectPool.getObject(PlasmaShot));
         shot.init(this.settings.impactForce,this.settings.damage * damageMultiplier);
         shot.addToGame(turretData.barrelOrigin,turretData.muzzlePosition,shotDirection,_loc1_.tankBody.body);
         this.muzzleIndex = (this.muzzleIndex + 1) % this.numMuzzles;
      }
      
      private function barrelCollidesWithStatic(origin:Vector3, direction:Vector3, length:Number) : Boolean
      {
         return this.collisionDetector.raycastStatic(origin,direction,CollisionGroup.STATIC,length,null,rayHit);
      }
   }
}

