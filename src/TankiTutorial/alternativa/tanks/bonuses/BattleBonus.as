package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   import alternativa.types.Long;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.physics.collision.types.RayHit;
   import org.osflash.signals.Signal;
   import org.osflash.signals.ISignal;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.battle.PhysicsController;
   import alternativa.tanks.battle.BattleService;
   import alternativa.tanks.battle.PhysicsInterpolator;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.physics.collision.CollisionDetector;
   
   public class BattleBonus extends PooledObject implements PhysicsController, PhysicsInterpolator, Renderer, Bonus
   {
      
      private static const MAX_RAY_TIME:Number = 10000000000;
      
      private static const groundNormal:Vector3 = new Vector3();
      
      private static const groundPoint:Vector3 = new Vector3();
      
      private static const landingPoint:Vector3 = new Vector3();
      
      private static const jarunazyk:Vector3 = new Vector3();
      
      private static const natyjy:Vector3 = new Vector3();
      
      private static const cokis:Vector3 = new Vector3();
      
      private static const rayOrigin:Vector3 = new Vector3();
      
      private static const rayHit:RayHit = new RayHit();
      
      private static const matrix:Matrix3 = new Matrix3();
      
      private static const qopo:Matrix3 = new Matrix3();
      
      private static const axis:Vector3 = new Vector3();
      
      private static const eulerAngles:Vector3 = new Vector3();
      
      private static const offset:Vector3 = new Vector3();
      
      private var bonusMesh:BonusMesh;
      
      private var parachute:Parachute;
      
      private var cords:Cords;
      
      private var battleService:BattleService;
      
      private var fallSpeed:Number = 0;
      
      private var objectId:Long;
      
      private var bonusData:BattleBonusData;
      
      private var _bonusId:Long;
      
      private var active:Boolean;
      
      private var trigger:BonusTrigger;
      
      private var controllers:Vector.<BonusController> = new Vector.<BonusController>();
      
      private var currentController:BonusController;
      
      private var fallController:FallController;
      
      private var landingController:LandingController;
      
      public const nuziged:ISignal = new Signal();
      
      public const lybaluh:ISignal = new Signal();
      
      public const gave:ISignal = new Signal();
      
      private const hery:ISignal = new Signal();
      
      public function BattleBonus(param1:Pool)
      {
         super(param1);
         this.trigger = new BonusTrigger(this);
         this.fallController = new FallController(this);
         this.landingController = new LandingController(this);
      }
      
      private static function isFlatSurface(normal:Vector3) : Boolean
      {
         return normal.z > BonusConst.bepy;
      }
      
      public function init(param1:Long, param2:Long, param3:BattleBonusData, param4:BattleService) : void
      {
         this.objectId = param1;
         this._bonusId = param2;
         this.bonusData = param3;
         this.battleService = param4;
         this.controllers.length = 0;
      }
      
      public function spawn(position:Vector3, param2:int, param3:Number, param4:Function) : void
      {
         var fallTime:int = 0;
         this.fallSpeed = param3;
         this.hery.add(param4);
         this.initBonusMesh();
         this.active = false;
         this.controllers.length = 0;
         this.getGroundPointAndNormal(position,groundPoint,groundNormal);
         if(this.isUnderCeil(position))
         {
            this.initOnGround(groundPoint,groundNormal);
         }
         else
         {
            this.initAirborne(position,groundPoint,groundNormal,param2);
            this.trigger.enable(this.battleService.getBattleRunner());
            fallTime = (groundPoint.distanceTo(position) - BonusConst.BONUS_HALF_SIZE) / param3 * 1000;
         }
         this.initRemovalAnimation(fallTime + this.bonusData.lifeTime - param2);
         if(this.runNextController())
         {
            this.activateRendererAndPhysicsController();
         }
      }
      
      private function initOnGround(point:Vector3, normal:Vector3) : void
      {
         var angle:Number = NaN;
         offset.reset(0,0,BonusConst.BONUS_HALF_SIZE);
         if(isFlatSurface(normal))
         {
            eulerAngles.reset(0,0,this.getStartingAngleZ());
         }
         else
         {
            axis.cross2(Vector3.zAxis,normal);
            axis.normalize();
            angle = Math.acos(normal.z);
            matrix.fromAxisAngle(axis,angle);
            qopo.setRotationMatrix(0,0,this.getStartingAngleZ());
            qopo.append(matrix);
            qopo.getEulerAngles(eulerAngles);
            offset.transform3(matrix);
         }
         this.bonusMesh.rotationX = eulerAngles.x;
         this.bonusMesh.rotationY = eulerAngles.y;
         this.bonusMesh.rotationZ = eulerAngles.z;
         this.bonusMesh.x = point.x + offset.x;
         this.bonusMesh.y = point.y + offset.y;
         this.bonusMesh.z = point.z + offset.z;
         this.updateTriggerFromMesh();
         this.battleService.getBattleScene3D().addObject(this.bonusMesh);
         this.startGroundSpawnAnimation();
      }
      
      private function startGroundSpawnAnimation() : void
      {
         var groundSpawnRenderer:GroundSpawnRenderer = GroundSpawnRenderer(this.battleService.getObjectPool().getObject(GroundSpawnRenderer));
         groundSpawnRenderer.start(this,this.battleService);
      }
      
      private function updateTriggerFromMesh() : void
      {
         this.trigger.update(this.bonusMesh.x,this.bonusMesh.y,this.bonusMesh.z,this.bonusMesh.rotationX,this.bonusMesh.rotationY,this.bonusMesh.rotationZ);
      }
      
      private function getStartingAngleZ() : Number
      {
         return Math.PI * 10 * this._bonusId.low / 180;
      }
      
      private function initAirborne(position:Vector3, point:Vector3, normal:Vector3, param4:int) : void
      {
         var fallTime:Number = NaN;
         if(isFlatSurface(normal))
         {
            fallTime = this.calculateFallTime(position,point);
            landingPoint.copy(point);
         }
         else
         {
            jarunazyk.cross2(normal,Vector3.zAxis);
            jarunazyk.normalize();
            natyjy.cross2(normal,jarunazyk);
            cokis.cross2(Vector3.zAxis,jarunazyk);
            rayOrigin.copy(position);
            rayOrigin.addScaled(-BonusConst.BONUS_HALF_SIZE,cokis);
            landingPoint.copy(point);
            landingPoint.addScaled(-BonusConst.BONUS_HALF_SIZE / normal.z,natyjy);
            if(this.battleService.getBattleRunner().getCollisionDetector().raycastStatic(rayOrigin,Vector3.down,CollisionGroup.STATIC,MAX_RAY_TIME,null,rayHit))
            {
               if(point.z < rayHit.position.z && rayHit.position.z < landingPoint.z)
               {
                  landingPoint.addScaled(BonusConst.BONUS_HALF_SIZE / normal.z * (landingPoint.z - rayHit.position.z) / (landingPoint.z - point.z),natyjy);
               }
            }
            fallTime = this.calculateFallTime(position,landingPoint);
            this.landingController.init(landingPoint,normal);
            this.controllers.push(this.landingController);
         }
         var minZ:Number = landingPoint.z + BonusConst.BONUS_HALF_SIZE + BonusConst.wucaruw;
         var startingAngleZ:Number = this.getStartingAngleZ();
         if(fallTime * 1000 <= param4)
         {
            this.bonusMesh.x = position.x;
            this.bonusMesh.y = position.y;
            this.bonusMesh.z = point.z + BonusConst.BONUS_HALF_SIZE;
            this.bonusMesh.rotationZ = startingAngleZ + fallTime * BonusConst.ROTATION_SPEED;
            this.updateTriggerFromMesh();
            this.battleService.getBattleScene3D().addObject(this.bonusMesh);
         }
         else
         {
            this.initParachute();
            this.addAllToScene();
            this.startSpawnAnimation(this.battleService);
            this.fallController.init(position,this.fallSpeed,minZ,-fallTime,param4 / 1000,startingAngleZ);
            this.controllers.push(this.fallController);
         }
      }
      
      private function isUnderCeil(position:Vector3) : Boolean
      {
         var collisionDetector:CollisionDetector = this.battleService.getBattleRunner().getCollisionDetector();
         return collisionDetector.hasStaticHit(position,Vector3.zAxis,CollisionGroup.STATIC,MAX_RAY_TIME);
      }
      
      private function getGroundPointAndNormal(position:Vector3, point:Vector3, normal:Vector3) : void
      {
         var collisionDetector:CollisionDetector = this.battleService.getBattleRunner().getCollisionDetector();
         if(collisionDetector.raycastStatic(position,Vector3.down,CollisionGroup.STATIC,MAX_RAY_TIME,null,rayHit))
         {
            normal.copy(rayHit.normal);
            point.copy(rayHit.position);
         }
         else
         {
            normal.copy(Vector3.zAxis);
            point.copy(position);
            point.z -= 1000;
         }
      }
      
      public function get bonusId() : Long
      {
         return this._bonusId;
      }
      
      public function pickup() : void
      {
         this.nuziged.dispatch();
         this.playPickupSound();
         this.detachParachute();
         this.startPickupAnimation();
         this.destroy();
      }
      
      private function playPickupSound() : void
      {
         var sound:Sound3D = null;
         var position:Vector3 = null;
         if(this.bonusData.pickupSound != null)
         {
            sound = Sound3D.create(this.bonusData.pickupSound,SoundOptions.suwyc,SoundOptions.bapewa,SoundOptions.fyvilyv,0.5);
            position = new Vector3(this.bonusMesh.x,this.bonusMesh.y,this.bonusMesh.z);
            this.battleService.addSound3DEffect(Sound3DEffect.create(this.battleService.getObjectPool(),position,sound));
         }
      }
      
      private function startPickupAnimation() : void
      {
         var bonusPickupAnimation:BonusPickupAnimation = BonusPickupAnimation(this.battleService.getObjectPool().getObject(BonusPickupAnimation));
         bonusPickupAnimation.start(this.bonusMesh,this.battleService.getBattleScene3D());
         this.bonusMesh = null;
      }
      
      public function remove() : void
      {
         this.lybaluh.dispatch();
         this.bonusMesh = null;
         this.destroy();
      }
      
      private function destroy() : void
      {
         this.gave.dispatch();
         this.nuziged.removeAll();
         this.lybaluh.removeAll();
         this.gave.removeAll();
         this.destroyBonusMesh();
         this.destroyParachute();
         this.deactivateRendererAndPhysicsController();
         this.trigger.disable();
         this.hery.removeAll();
         this.battleService = null;
         this.bonusData = null;
         recycle();
      }
      
      private function destroyBonusMesh() : void
      {
         if(this.bonusMesh != null)
         {
            this.battleService.getBattleScene3D().removeObject(this.bonusMesh);
            this.bonusMesh.recycle();
            this.bonusMesh = null;
         }
      }
      
      private function destroyParachute() : void
      {
         if(this.parachute != null)
         {
            this.battleService.getBattleScene3D().removeObject(this.parachute);
            this.parachute.recycle();
            this.parachute = null;
            this.battleService.getBattleScene3D().removeObject(this.cords);
            this.cords.recycle();
            this.cords = null;
         }
      }
      
      private function calculateFallTime(position:Vector3, point:Vector3) : Number
      {
         return (position.z - point.z - BonusConst.BONUS_HALF_SIZE) / this.fallSpeed;
      }
      
      private function initRemovalAnimation(lifeTime:int) : void
      {
         var removalAnimation:RemovalAnimation = RemovalAnimation(this.battleService.getObjectPool().getObject(RemovalAnimation));
         removalAnimation.init(this.battleService.getBattleScene3D(),this,lifeTime);
      }
      
      private function startSpawnAnimation(param1:BattleService) : void
      {
         var spawnAnimation:SpawnAnimation = SpawnAnimation(param1.getObjectPool().getObject(SpawnAnimation));
         spawnAnimation.start(this,param1.getBattleScene3D());
      }
      
      private function activateRendererAndPhysicsController() : void
      {
         if(!this.active)
         {
            this.active = true;
            this.battleService.getBattleRunner().addPhysicsController(this);
            this.battleService.getBattleRunner().addPhysicsInterpolator(this);
            this.battleService.getBattleScene3D().addRenderer(this,0);
         }
      }
      
      private function initParachute() : void
      {
         if(BonusCache.isParachuteCacheEmpty())
         {
            this.parachute = new Parachute(this.bonusData.parachuteMesh,this.bonusData.parachuteInnerMesh);
         }
         else
         {
            this.parachute = BonusCache.getParachute();
         }
         if(BonusCache.isCordsCacheEmpty())
         {
            this.cords = new Cords(Parachute.RADIUS,BonusConst.BONUS_HALF_SIZE,Parachute.NUM_CORDS,this.bonusData.cordsMaterial);
         }
         else
         {
            this.cords = BonusCache.getCords();
         }
         this.cords.init(this.bonusMesh,this.parachute);
      }
      
      private function initBonusMesh() : void
      {
         if(BonusCache.isBonusMeshCacheEmpty(this.objectId))
         {
            this.bonusMesh = new BonusMesh(this.objectId,this.bonusData.bonusMesh);
         }
         else
         {
            this.bonusMesh = BonusCache.getBonusMesh(this.objectId);
         }
         this.bonusMesh.init();
      }
      
      private function addAllToScene() : void
      {
         this.battleService.getBattleScene3D().addObject(this.parachute);
         this.battleService.getBattleScene3D().addObject(this.bonusMesh);
         this.battleService.getBattleScene3D().addObject(this.cords);
      }
      
      public function runBeforePhysicsUpdate(dt:Number) : void
      {
         this.currentController.runBeforePhysicsUpdate(dt);
      }
      
      private function deactivateRendererAndPhysicsController() : void
      {
         if(this.active)
         {
            this.active = false;
            this.battleService.getBattleRunner().removePhysicsController(this);
            this.battleService.getBattleRunner().removePhysicsInterpolator(this);
            this.battleService.getBattleScene3D().removeRenderer(this,0);
         }
      }
      
      private function detachParachute() : void
      {
         var parachuteDetachAnimation:ParachuteDetachAnimation = null;
         if(this.parachute != null)
         {
            parachuteDetachAnimation = ParachuteDetachAnimation(this.battleService.getObjectPool().getObject(ParachuteDetachAnimation));
            parachuteDetachAnimation.start(this.battleService.getBattleScene3D(),this.parachute,this.cords,this.fallSpeed / 2);
            this.parachute = null;
            this.cords = null;
         }
      }
      
      public function interpolatePhysicsState(t:Number) : void
      {
         this.currentController.interpolatePhysicsState(t);
      }
      
      public function render(time:int, deltaTime:int) : void
      {
         this.currentController.render();
      }
      
      public function setAlpha(value:Number) : void
      {
         this.bonusMesh.setAlpha(value);
         if(this.parachute != null)
         {
            this.parachute.setAlpha(value);
            this.cords.setAlpha(value);
         }
      }
      
      public function onTriggerActivated() : void
      {
         this.trigger.disable();
         this.hery.dispatch(this);
      }
      
      public function onTouchGround() : void
      {
         this.detachParachute();
         if(!this.runNextController())
         {
            this.stopMovement();
         }
      }
      
      public function onLandingComplete() : void
      {
         this.stopMovement();
      }
      
      private function stopMovement() : void
      {
         this.deactivateRendererAndPhysicsController();
      }
      
      public function getBonusMesh() : BonusMesh
      {
         return this.bonusMesh;
      }
      
      private function runNextController() : Boolean
      {
         this.currentController = this.controllers.pop();
         if(this.currentController == null)
         {
            return false;
         }
         this.currentController.start();
         return true;
      }
      
      public function getParachute() : Object3D
      {
         return this.parachute;
      }
      
      public function getCords() : Cords
      {
         return this.cords;
      }
      
      public function getTrigger() : BonusTrigger
      {
         return this.trigger;
      }
      
      public function enableTrigger() : void
      {
         this.trigger.enable(this.battleService.getBattleRunner());
      }
   }
}

