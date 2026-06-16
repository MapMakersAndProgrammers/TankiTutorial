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
      
      private static const manytaq:Number = 10000000000;
      
      private static const peveco:Vector3 = new Vector3();
      
      private static const docyqy:Vector3 = new Vector3();
      
      private static const nuk:Vector3 = new Vector3();
      
      private static const jarunazyk:Vector3 = new Vector3();
      
      private static const natyjy:Vector3 = new Vector3();
      
      private static const cokis:Vector3 = new Vector3();
      
      private static const vyhomopog:Vector3 = new Vector3();
      
      private static const tet:RayHit = new RayHit();
      
      private static const run:Matrix3 = new Matrix3();
      
      private static const qopo:Matrix3 = new Matrix3();
      
      private static const zekos:Vector3 = new Vector3();
      
      private static const fyqynyfy:Vector3 = new Vector3();
      
      private static const divogyvo:Vector3 = new Vector3();
      
      private var giqo:BonusMesh;
      
      private var kyvedu:Parachute;
      
      private var til:Cords;
      
      private var mij:BattleService;
      
      private var pobano:Number = 0;
      
      private var luk:Long;
      
      private var katuf:BattleBonusData;
      
      private var nimulul:Long;
      
      private var ledijym:Boolean;
      
      private var wyqitywi:BonusTrigger;
      
      private var lywajoqa:Vector.<BonusController> = new Vector.<BonusController>();
      
      private var syligatyl:BonusController;
      
      private var kewi:FallController;
      
      private var lyge:LandingController;
      
      public const nuziged:ISignal = new Signal();
      
      public const lybaluh:ISignal = new Signal();
      
      public const gave:ISignal = new Signal();
      
      private const hery:ISignal = new Signal();
      
      public function BattleBonus(param1:Pool)
      {
         super(param1);
         this.wyqitywi = new BonusTrigger(this);
         this.kewi = new FallController(this);
         this.lyge = new LandingController(this);
      }
      
      private static function isFlatSurface(param1:Vector3) : Boolean
      {
         return param1.z > BonusConst.bepy;
      }
      
      public function init(param1:Long, param2:Long, param3:BattleBonusData, param4:BattleService) : void
      {
         this.luk = param1;
         this.nimulul = param2;
         this.katuf = param3;
         this.mij = param4;
         this.lywajoqa.length = 0;
      }
      
      public function spawn(param1:Vector3, param2:int, param3:Number, param4:Function) : void
      {
         var _loc5_:int = 0;
         this.pobano = param3;
         this.hery.add(param4);
         this.initBonusMesh();
         this.ledijym = false;
         this.lywajoqa.length = 0;
         this.getGroundPointAndNormal(param1,docyqy,peveco);
         if(this.isUnderCeil(param1))
         {
            this.initOnGround(docyqy,peveco);
         }
         else
         {
            this.initAirborne(param1,docyqy,peveco,param2);
            this.wyqitywi.enable(this.mij.getBattleRunner());
            _loc5_ = (docyqy.distanceTo(param1) - BonusConst.numij) / param3 * 1000;
         }
         this.initRemovalAnimation(_loc5_ + this.katuf.wym - param2);
         if(this.runNextController())
         {
            this.activateRendererAndPhysicsController();
         }
      }
      
      private function initOnGround(param1:Vector3, param2:Vector3) : void
      {
         var _loc3_:Number = NaN;
         divogyvo.reset(0,0,BonusConst.numij);
         if(isFlatSurface(param2))
         {
            fyqynyfy.reset(0,0,this.getStartingAngleZ());
         }
         else
         {
            zekos.cross2(Vector3.nesicuryn,param2);
            zekos.normalize();
            _loc3_ = Math.acos(param2.z);
            run.fromAxisAngle(zekos,_loc3_);
            qopo.setRotationMatrix(0,0,this.getStartingAngleZ());
            qopo.append(run);
            qopo.getEulerAngles(fyqynyfy);
            divogyvo.transform3(run);
         }
         this.giqo.rotationX = fyqynyfy.x;
         this.giqo.rotationY = fyqynyfy.y;
         this.giqo.rotationZ = fyqynyfy.z;
         this.giqo.x = param1.x + divogyvo.x;
         this.giqo.y = param1.y + divogyvo.y;
         this.giqo.z = param1.z + divogyvo.z;
         this.updateTriggerFromMesh();
         this.mij.getBattleScene3D().addObject(this.giqo);
         this.startGroundSpawnAnimation();
      }
      
      private function startGroundSpawnAnimation() : void
      {
         var _loc1_:GroundSpawnRenderer = GroundSpawnRenderer(this.mij.getObjectPool().getObject(GroundSpawnRenderer));
         _loc1_.start(this,this.mij);
      }
      
      private function updateTriggerFromMesh() : void
      {
         this.wyqitywi.update(this.giqo.x,this.giqo.y,this.giqo.z,this.giqo.rotationX,this.giqo.rotationY,this.giqo.rotationZ);
      }
      
      private function getStartingAngleZ() : Number
      {
         return Math.PI * 10 * this.nimulul.low / 180;
      }
      
      private function initAirborne(param1:Vector3, param2:Vector3, param3:Vector3, param4:int) : void
      {
         var _loc5_:Number = NaN;
         if(isFlatSurface(param3))
         {
            _loc5_ = this.calculateFallTime(param1,param2);
            nuk.copy(param2);
         }
         else
         {
            jarunazyk.cross2(param3,Vector3.nesicuryn);
            jarunazyk.normalize();
            natyjy.cross2(param3,jarunazyk);
            cokis.cross2(Vector3.nesicuryn,jarunazyk);
            vyhomopog.copy(param1);
            vyhomopog.addScaled(-BonusConst.numij,cokis);
            nuk.copy(param2);
            nuk.addScaled(-BonusConst.numij / param3.z,natyjy);
            if(this.mij.getBattleRunner().getCollisionDetector().raycastStatic(vyhomopog,Vector3.lasis,CollisionGroup.neli,manytaq,null,tet))
            {
               if(param2.z < tet.position.z && tet.position.z < nuk.z)
               {
                  nuk.addScaled(BonusConst.numij / param3.z * (nuk.z - tet.position.z) / (nuk.z - param2.z),natyjy);
               }
            }
            _loc5_ = this.calculateFallTime(param1,nuk);
            this.lyge.init(nuk,param3);
            this.lywajoqa.push(this.lyge);
         }
         var _loc6_:Number = nuk.z + BonusConst.numij + BonusConst.wucaruw;
         var _loc7_:Number = this.getStartingAngleZ();
         if(_loc5_ * 1000 <= param4)
         {
            this.giqo.x = param1.x;
            this.giqo.y = param1.y;
            this.giqo.z = param2.z + BonusConst.numij;
            this.giqo.rotationZ = _loc7_ + _loc5_ * BonusConst.myr;
            this.updateTriggerFromMesh();
            this.mij.getBattleScene3D().addObject(this.giqo);
         }
         else
         {
            this.initParachute();
            this.addAllToScene();
            this.startSpawnAnimation(this.mij);
            this.kewi.init(param1,this.pobano,_loc6_,-_loc5_,param4 / 1000,_loc7_);
            this.lywajoqa.push(this.kewi);
         }
      }
      
      private function isUnderCeil(param1:Vector3) : Boolean
      {
         var _loc2_:CollisionDetector = this.mij.getBattleRunner().getCollisionDetector();
         return _loc2_.hasStaticHit(param1,Vector3.nesicuryn,CollisionGroup.neli,manytaq);
      }
      
      private function getGroundPointAndNormal(param1:Vector3, param2:Vector3, param3:Vector3) : void
      {
         var _loc4_:CollisionDetector = this.mij.getBattleRunner().getCollisionDetector();
         if(_loc4_.raycastStatic(param1,Vector3.lasis,CollisionGroup.neli,manytaq,null,tet))
         {
            param3.copy(tet.lefugefo);
            param2.copy(tet.position);
         }
         else
         {
            param3.copy(Vector3.nesicuryn);
            param2.copy(param1);
            param2.z -= 1000;
         }
      }
      
      public function get bonusId() : Long
      {
         return this.nimulul;
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
         var _loc1_:Sound3D = null;
         var _loc2_:Vector3 = null;
         if(this.katuf.ruzy != null)
         {
            _loc1_ = Sound3D.create(this.katuf.ruzy,SoundOptions.suwyc,SoundOptions.bapewa,SoundOptions.fyvilyv,0.5);
            _loc2_ = new Vector3(this.giqo.x,this.giqo.y,this.giqo.z);
            this.mij.addSound3DEffect(Sound3DEffect.create(this.mij.getObjectPool(),_loc2_,_loc1_));
         }
      }
      
      private function startPickupAnimation() : void
      {
         var _loc1_:BonusPickupAnimation = BonusPickupAnimation(this.mij.getObjectPool().getObject(BonusPickupAnimation));
         _loc1_.start(this.giqo,this.mij.getBattleScene3D());
         this.giqo = null;
      }
      
      public function remove() : void
      {
         this.lybaluh.dispatch();
         this.giqo = null;
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
         this.wyqitywi.disable();
         this.hery.removeAll();
         this.mij = null;
         this.katuf = null;
         recycle();
      }
      
      private function destroyBonusMesh() : void
      {
         if(this.giqo != null)
         {
            this.mij.getBattleScene3D().removeObject(this.giqo);
            this.giqo.recycle();
            this.giqo = null;
         }
      }
      
      private function destroyParachute() : void
      {
         if(this.kyvedu != null)
         {
            this.mij.getBattleScene3D().removeObject(this.kyvedu);
            this.kyvedu.recycle();
            this.kyvedu = null;
            this.mij.getBattleScene3D().removeObject(this.til);
            this.til.recycle();
            this.til = null;
         }
      }
      
      private function calculateFallTime(param1:Vector3, param2:Vector3) : Number
      {
         return (param1.z - param2.z - BonusConst.numij) / this.pobano;
      }
      
      private function initRemovalAnimation(param1:int) : void
      {
         var _loc2_:RemovalAnimation = RemovalAnimation(this.mij.getObjectPool().getObject(RemovalAnimation));
         _loc2_.init(this.mij.getBattleScene3D(),this,param1);
      }
      
      private function startSpawnAnimation(param1:BattleService) : void
      {
         var _loc2_:SpawnAnimation = SpawnAnimation(param1.getObjectPool().getObject(SpawnAnimation));
         _loc2_.start(this,param1.getBattleScene3D());
      }
      
      private function activateRendererAndPhysicsController() : void
      {
         if(!this.ledijym)
         {
            this.ledijym = true;
            this.mij.getBattleRunner().addPhysicsController(this);
            this.mij.getBattleRunner().addPhysicsInterpolator(this);
            this.mij.getBattleScene3D().addRenderer(this,0);
         }
      }
      
      private function initParachute() : void
      {
         if(BonusCache.isParachuteCacheEmpty())
         {
            this.kyvedu = new Parachute(this.katuf.vukuzub,this.katuf.berav);
         }
         else
         {
            this.kyvedu = BonusCache.getParachute();
         }
         if(BonusCache.isCordsCacheEmpty())
         {
            this.til = new Cords(Parachute.jonoga,BonusConst.numij,Parachute.lapocar,this.katuf.zerow);
         }
         else
         {
            this.til = BonusCache.getCords();
         }
         this.til.init(this.giqo,this.kyvedu);
      }
      
      private function initBonusMesh() : void
      {
         if(BonusCache.isBonusMeshCacheEmpty(this.luk))
         {
            this.giqo = new BonusMesh(this.luk,this.katuf.tipi);
         }
         else
         {
            this.giqo = BonusCache.getBonusMesh(this.luk);
         }
         this.giqo.init();
      }
      
      private function addAllToScene() : void
      {
         this.mij.getBattleScene3D().addObject(this.kyvedu);
         this.mij.getBattleScene3D().addObject(this.giqo);
         this.mij.getBattleScene3D().addObject(this.til);
      }
      
      public function runBeforePhysicsUpdate(param1:Number) : void
      {
         this.syligatyl.runBeforePhysicsUpdate(param1);
      }
      
      private function deactivateRendererAndPhysicsController() : void
      {
         if(this.ledijym)
         {
            this.ledijym = false;
            this.mij.getBattleRunner().removePhysicsController(this);
            this.mij.getBattleRunner().removePhysicsInterpolator(this);
            this.mij.getBattleScene3D().removeRenderer(this,0);
         }
      }
      
      private function detachParachute() : void
      {
         var _loc1_:ParachuteDetachAnimation = null;
         if(this.kyvedu != null)
         {
            _loc1_ = ParachuteDetachAnimation(this.mij.getObjectPool().getObject(ParachuteDetachAnimation));
            _loc1_.start(this.mij.getBattleScene3D(),this.kyvedu,this.til,this.pobano / 2);
            this.kyvedu = null;
            this.til = null;
         }
      }
      
      public function interpolatePhysicsState(param1:Number) : void
      {
         this.syligatyl.interpolatePhysicsState(param1);
      }
      
      public function render(param1:int, param2:int) : void
      {
         this.syligatyl.render();
      }
      
      public function setAlpha(param1:Number) : void
      {
         this.giqo.setAlpha(param1);
         if(this.kyvedu != null)
         {
            this.kyvedu.setAlpha(param1);
            this.til.setAlpha(param1);
         }
      }
      
      public function onTriggerActivated() : void
      {
         this.wyqitywi.disable();
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
         return this.giqo;
      }
      
      private function runNextController() : Boolean
      {
         this.syligatyl = this.lywajoqa.pop();
         if(this.syligatyl == null)
         {
            return false;
         }
         this.syligatyl.start();
         return true;
      }
      
      public function getParachute() : Object3D
      {
         return this.kyvedu;
      }
      
      public function getCords() : Cords
      {
         return this.til;
      }
      
      public function getTrigger() : BonusTrigger
      {
         return this.wyqitywi;
      }
      
      public function enableTrigger() : void
      {
         this.wyqitywi.enable(this.mij.getBattleRunner());
      }
   }
}

