package alternativa.tanks.vehicles.tank
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.tanks.shared.usertitle.UserTitle;
   import alternativa.tanks.vehicles.tank.controllers.TurretController;
   import alternativa.physics.Body;
   import alternativa.physics.TanksPhysicsScene;
   import alternativa.physics.PhysicsUtils;
   import alternativa.tanks.vehicles.tank.physics.SuspensionParams;
   import alternativa.tanks.vehicles.tank.physics.Track;
   import flash.display.BitmapData;
   import flash.media.Sound;
   import flash.utils.setTimeout;
   import tutorial.Turrets;
   import tutorial.Hulls;
   import tutorial.GameData;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.sound.ISoundManager;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import tutorial.tasks.ChangeCameraAngleTask;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.battle.PhysicsController;
   import alternativa.tanks.battle.PhysicsInterpolator;
   import alternativa.tanks.sfx.TankExplosionFactory;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sfx.TankSounds;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.RenderGroup;
   import alternativa.tanks.vehicles.tank.skin.TankSkin;
   import tutorial.commons.Assets;
   import alternativa.physics.collision.BodyCollisionFilter;
   import alternativa.tanks.shared.physics.TankBody;
   import alternativa.tanks.vehicles.tank.weapons.Weapon;
   
   public class Tank implements CameraTarget, PhysicsInterpolator, PhysicsController, Renderer, BodyCollisionFilter
   {
      
      private static const radanigys:Number = 0.4;
      
      private static const lilotes:Vector3 = new Vector3();
      
      private static const wokymityf:Matrix3 = new Matrix3();
      
      private static const qef:Matrix4 = new Matrix4();
      
      private static const rizy:Matrix4 = new Matrix4();
      
      private static const qalolyris:Vector3 = new Vector3();
      
      private static const dedit:Vector3 = new Vector3();
      
      private static const hyqirufy:Vector3 = new Vector3();
      
      private static const jygef:Vector3 = new Vector3();
      
      private static const baven:Vector3 = new Vector3();
      
      private static const gof:Vector3 = new Vector3();
      
      private const zeneti:Vector3 = new Vector3();
      
      private const lobozofeh:Quaternion = new Quaternion();
      
      private var jifav:ValueSmoother = new SimpleValueSmoother(100,1000,0,0);
      
      private var vibewyge:ValueSmoother = new SimpleValueSmoother(0.3,10,0,0);
      
      private const bijatil:ISoundManager = GameData.bijatil;
      
      private const guzinizub:KDContainer = GameData.guzinizub;
      
      private const butefu:GameCamera = GameData.butefu;
      
      private const gov:TanksPhysicsScene = GameData.gov;
      
      private const murow:ObjectPool = GameData.murow;
      
      private const jypadif:RenderGroup = GameData.jypadif;
      
      private var civacofo:Vector.<Vector3>;
      
      private var nyryp:Number = 0;
      
      public var nariw:TankHull;
      
      public var firaqe:TankTurret;
      
      public var hogys:TankBody;
      
      private var tuwykus:Number;
      
      private var fusisywa:int;
      
      private var bedepidy:Number = 0;
      
      public var kuca:TankSkin;
      
      private var quj:Number;
      
      private var wibo:Number;
      
      public var kat:Boolean;
      
      private var tasapupat:Weapon;
      
      public var kakow:UserTitle;
      
      public var lysecof:TankSounds;
      
      private var wom:Boolean;
      
      private var zafutonaz:String;
      
      private const zywanywy:Vector3 = new Vector3();
      
      private const josi:Quaternion = new Quaternion();
      
      private const faqes:Vector3 = new Vector3();
      
      private const wykuc:Quaternion = new Quaternion();
      
      private var mum:TurretController;
      
      private var momomafoj:Number = 0;
      
      public var fysa:Number;
      
      private var gobo:SuspensionParams = new SuspensionParams();
      
      private var hag:TrackedChassis;
      
      private var viqi:TracksAnimator;
      
      private var diniqu:Boolean = false;
      
      public function Tank()
      {
         super();
         this.kuca = new TankSkin();
      }
      
      public function get body() : Body
      {
         if(this.hogys == null)
         {
            throw new Error();
         }
         return this.hogys.body;
      }
      
      public function setWeaponDamageMultiplier(param1:Number) : void
      {
         if(this.tasapupat != null)
         {
            this.tasapupat.kuqy = param1;
         }
      }
      
      private function setMaxHealth(param1:Number) : void
      {
         this.wibo = param1;
         this.quj = this.wibo;
      }
      
      public function substructHealth(param1:Number) : void
      {
         if(this == GameData.jifom && this.quj <= this.wibo * 0.5)
         {
            this.quj -= this.quj / this.wibo * param1;
         }
         else
         {
            this.quj -= param1;
         }
         if(this.quj < 0)
         {
            this.quj = 0;
         }
         if(this.kakow != null)
         {
            this.kakow.setHealth(this.quj,this.wibo);
         }
      }
      
      public function get currentHealth() : Number
      {
         return this.quj;
      }
      
      public function init(param1:String, param2:String, param3:String, param4:Number = 0) : void
      {
         if(param4 > 0)
         {
            this.momomafoj = param4;
         }
         this.zafutonaz = param3;
         this.setHull(param1);
         this.setTurret(param2);
         this.setColormap(param3);
      }
      
      public function setHull(param1:String) : void
      {
         var _loc3_:Mesh = null;
         var _loc4_:Vector3 = null;
         var _loc2_:TankHull = Hulls.leqib[param1];
         if(_loc2_ == null)
         {
            throw new ArgumentError("Hull is null");
         }
         if(this.nariw != _loc2_)
         {
            this.gobo.miqelina = _loc2_.sasi;
            this.setMaxHealth(this.momomafoj > 0 ? this.momomafoj : Number(_loc2_.quj));
            this.nariw = _loc2_;
            this.kuca.setHull(_loc2_);
            this.tuwykus = _loc2_.tuwykus;
            this.setMaxSpeed(_loc2_.wiciqy,true);
            this.setMaxTurnSpeed(_loc2_.pyfika,true);
            _loc3_ = _loc2_.kuca;
            _loc3_.calculateBounds();
            _loc4_ = new Vector3(2 * _loc3_.boundMaxX,2 * _loc3_.boundMaxY,_loc3_.boundMaxZ);
            this.createBody(this.tuwykus,_loc4_);
            this.createChassis(_loc4_,_loc2_);
            this.setOptimalZCorrection(_loc4_);
            this.setBodyCollisionGroup(CollisionGroup.pisyse | CollisionGroup.bywowe | CollisionGroup.deli | CollisionGroup.nuqa);
            this.setTracksCollisionGroup(CollisionGroup.bywowe);
         }
      }
      
      private function createBody(param1:Number, param2:Vector3) : void
      {
         var _loc4_:Body = null;
         if(this.hogys == null)
         {
            _loc4_ = new Body(param1,Matrix3.nyra);
            _loc4_.katuf = this;
            this.hogys = new TankBody(_loc4_);
         }
         var _loc3_:Vector3 = param2.clone();
         _loc3_.scale(0.5);
         PhysicsUtils.setBoxInvInertia(param1,_loc3_,this.hogys.body.wofurys);
         this.hogys.body.tuwykus = param1;
         this.hogys.body.jutelycu = 1 / param1;
         this.createCollisionPrimitives(_loc3_);
         this.createVisibilityPoints(_loc3_);
      }
      
      private function createCollisionPrimitives(param1:Vector3) : void
      {
         this.hogys.clearCollisionShapes();
         var _loc2_:Number = 2 * param1.z - (this.gobo.vocuqih - TankConst.kyr);
         CollisionBoxesBuilder.createTankCollisionBox(param1,_loc2_,this.hogys);
         CollisionBoxesBuilder.createStaticCollisionBoxes(param1,_loc2_,this.hogys);
         this.setBoundSphereRadius(param1,_loc2_);
      }
      
      private function setBoundSphereRadius(param1:Vector3, param2:Number) : void
      {
         var _loc3_:Vector3 = new Vector3(param1.x,param1.y,param2 / 2);
         var _loc4_:Matrix4 = this.hogys.kyripama.koma;
         this.fysa = _loc3_.length() + Math.abs(_loc4_.sunafepo);
      }
      
      private function createVisibilityPoints(param1:Vector3) : void
      {
         var _loc2_:Number = Number(param1.x);
         var _loc3_:Number = Number(param1.y);
         this.civacofo = Vector.<Vector3>([new Vector3(-_loc2_,_loc3_,0),new Vector3(_loc2_,_loc3_,0),new Vector3(-_loc2_,0,0),new Vector3(_loc2_,0,0),new Vector3(-_loc2_,-_loc3_,0),new Vector3(_loc2_,-_loc3_,0)]);
      }
      
      private function createChassis(param1:Vector3, param2:TankHull) : void
      {
         this.hag = new TrackedChassis(this.hogys.body,this.gobo,this.jifav,param1);
         this.hag.setAcceleration(param2.cozo);
         this.hag.setReverseAcceleration(param2.qezuw);
         this.hag.setSideAcceleration(param2.wito);
         this.hag.setTurnAcceleration(param2.qupi);
         this.hag.setReverseTurnAcceleration(param2.beg);
         this.viqi = new TracksAnimator(this.hag,this.kuca,this.jifav);
      }
      
      public function setTurret(param1:String) : void
      {
         var _loc2_:TankTurret = Turrets.leqib[param1];
         if(_loc2_ == null)
         {
            throw new ArgumentError("Turret is null");
         }
         if(this.firaqe != _loc2_)
         {
            if(this.tasapupat != null)
            {
               this.tasapupat.stop();
            }
            this.tasapupat = Turrets.getWeapon(param1);
            if(this.mum != null)
            {
               this.mum.setMaxTurnSpeed(_loc2_.gejebuke,false);
               this.mum.setTurnAcceleration(_loc2_.qupi);
            }
            this.tasapupat.setTank(this);
            this.firaqe = _loc2_;
            this.kuca.setTurret(_loc2_);
         }
      }
      
      public function getCameraParams(param1:Vector3, param2:Vector3) : void
      {
         this.lobozofeh.toMatrix3(wokymityf);
         lilotes.copy(this.zeneti);
         lilotes.x += this.nyryp * wokymityf.sivy;
         lilotes.y += this.nyryp * wokymityf.wyvukog;
         lilotes.z += this.nyryp * wokymityf.tari;
         qef.setFromMatrix3(wokymityf,lilotes);
         var _loc3_:Vector3 = this.kuca.getHull().sih;
         rizy.setMatrix(_loc3_.x,_loc3_.y,_loc3_.z,0,0,GameData.kumiteva ? Number(this.mum.getCameraDirection()) : Number(this.mum.getDirection()));
         rizy.append(qef);
         param1.reset(rizy.kyvuru,rizy.zumidynip,rizy.sunafepo);
         param2.reset(rizy.cydop,rizy.qanezycap,rizy.luwym);
      }
      
      public function setMaxSpeed(param1:Number, param2:Boolean) : void
      {
         if(param2)
         {
            this.jifav.reset(param1);
         }
         else
         {
            this.jifav.setTargetValue(param1);
         }
      }
      
      public function setMaxTurnSpeed(param1:Number, param2:Boolean) : void
      {
         if(param2)
         {
            this.vibewyge.reset(param1);
         }
         else
         {
            this.vibewyge.setTargetValue(param1);
         }
      }
      
      public function setCheckpoint() : void
      {
         this.zywanywy.copy(this.faqes);
         this.josi.copy(this.wykuc);
         this.faqes.copy(this.hogys.body.kejo.position);
         this.wykuc.copy(this.hogys.body.kejo.bej);
      }
      
      public function setColormap(param1:String) : void
      {
         var _loc2_:BitmapData = Assets.getData(param1,BitmapData);
         this.kuca.setColormap(_loc2_);
      }
      
      public function kill() : void
      {
         if(this.mum != null)
         {
            this.mum.lock(1);
         }
         this.kat = false;
         this.bijatil.removeEffect(this.lysecof);
         TankExplosionFactory.createEffect(this);
         this.setColormap("dead");
         if(this.kakow != null)
         {
            this.kakow.hide();
         }
         this.hogys.body.kejo.zerus.z += 500;
         this.hogys.body.kejo.fev.reset(2,2,2);
         var _loc1_:Sound3D = Sound3D.create(Assets.getData("tank_explosion",Sound),SoundOptions.suwyc,SoundOptions.bapewa,SoundOptions.fyvilyv,radanigys);
         this.bijatil.addEffect(Sound3DEffect.create(this.murow,this.hogys.body.kejo.position,_loc1_,0,0));
      }
      
      public function respawn() : void
      {
         this.kuca.turretMesh.visible = false;
         this.kuca.hullMesh.visible = false;
         this.kuca.nuvyma.alpha = 0;
         this.bijatil.addEffect(this.lysecof);
         this.setColormap(this.zafutonaz);
         this.quj = this.wibo;
         this.hogys.body.setVelocityXYZ(0,0,0);
         this.hogys.body.setPosition(this.zywanywy);
         this.hogys.body.setOrientation(this.josi);
         if(this.mum != null)
         {
            this.mum.reset();
            this.mum.unlock(1);
         }
         GameData.namab.addTask(new ChangeCameraAngleTask(0.2,2));
         setTimeout(this.showAfterRespawn,1000);
      }
      
      private function showAfterRespawn() : void
      {
         this.kuca.turretMesh.visible = true;
         this.kuca.hullMesh.visible = true;
         this.kuca.nuvyma.alpha = 1;
         if(this.kakow != null)
         {
            this.kakow.show();
         }
         this.kat = true;
      }
      
      public function addToGame() : void
      {
         this.gov.addTankBody(this.hogys);
         this.gov.addPhysicsController(this);
         this.gov.addPhysicsInterpolator(this);
         this.kat = true;
         this.jypadif.addRenderer(this);
         this.kuca.addToContainer(this.guzinizub,this.butefu);
         GameData.gido.addTank(this);
         this.wom = true;
         this.lysecof = new TankSounds();
         this.lysecof.setTank(this);
         this.lysecof.turretSoundEnabled = true;
         this.addSoundToSoundManager();
      }
      
      public function addSoundToSoundManager() : void
      {
         if(!this.diniqu)
         {
            this.diniqu = this.bijatil.addEffect(this.lysecof);
         }
      }
      
      public function removeFromGame() : void
      {
         this.bijatil.removeEffect(this.lysecof);
         this.gov.removeTankBody(this.hogys);
         this.gov.removePhysicsInterpolator(this);
         this.gov.removePhysicsController(this);
         this.jypadif.removeRenderer(this);
         this.kuca.removeFromContainer();
         GameData.gido.removeTank(this);
         this.wom = false;
      }
      
      public function heal() : void
      {
         this.quj = this.wibo;
      }
      
      public function setMovementParams(param1:int, param2:int, param3:Boolean) : void
      {
         this.hag.rucumopak = param1;
         this.hag.wuzyvodew = param2;
         this.hag.cewubegy = param3;
         this.updateEngineSound();
      }
      
      private function updateEngineSound() : void
      {
         if(this.hag.dajy)
         {
            this.lysecof.setIdleMode();
         }
         else if(this.hag.rucumopak != 0)
         {
            this.lysecof.setAccelerationMode();
         }
         else if(this.hag.wuzyvodew != 0)
         {
            this.lysecof.setTurningMode();
         }
         else
         {
            this.lysecof.setIdleMode();
         }
      }
      
      public function interpolatePhysicsState(param1:Number) : void
      {
         this.hogys.body.interpolate(param1,this.zeneti,this.lobozofeh);
         this.lobozofeh.normalize();
         if(this.mum != null)
         {
            this.bedepidy = -this.mum.getInterpolatedDirection(param1);
         }
      }
      
      public function render(param1:int, param2:int) : void
      {
         this.lobozofeh.toMatrix3(wokymityf);
         lilotes.copy(this.zeneti);
         lilotes.x += this.nyryp * wokymityf.sivy;
         lilotes.y += this.nyryp * wokymityf.wyvukog;
         lilotes.z += this.nyryp * wokymityf.tari;
         this.kuca.updateTransform(lilotes,this.lobozofeh,this.bedepidy);
         var _loc3_:Number = param2 * 0.001;
         this.viqi.animate(_loc3_);
         lilotes.x = this.kuca.turretMesh.x;
         lilotes.y = this.kuca.turretMesh.y;
         lilotes.z = this.kuca.turretMesh.z;
         if(this.tasapupat != null)
         {
            this.tasapupat.update(param1,param2);
         }
         if(this.kakow != null)
         {
            this.kakow.setWeaponStatus(100 * this.tasapupat.status);
            this.kakow.setHealth(this.quj,this.wibo);
            this.kakow.update(lilotes);
         }
         if(this.mum != null)
         {
            this.mum.setTankDirection(this.calculateTankDirection());
         }
      }
      
      private function calculateTankDirection() : Number
      {
         this.lobozofeh.toMatrix3(wokymityf);
         wokymityf.transformVector(Vector3.nesicuryn,dedit);
         dedit.normalize();
         qalolyris.z = this.nyryp;
         lilotes.reset();
         lilotes.transform3(wokymityf);
         lilotes.add(this.zeneti);
         qef.setFromMatrix3(wokymityf,lilotes);
         hyqirufy.reset(qef.kyvuru,qef.zumidynip,qef.sunafepo);
         jygef.reset(qef.cydop,qef.qanezycap,qef.luwym);
         jygef.normalize();
         baven.copy(Vector3.giv);
         gof.copy(Vector3.pypymu);
         baven.projectOnPlane(dedit);
         gof.projectOnPlane(dedit);
         baven.normalize();
         gof.normalize();
         var _loc1_:Number = Number(gof.dot(jygef));
         var _loc2_:Number = Number(baven.dot(jygef));
         return Math.acos(_loc1_) * (_loc2_ > 0 ? -1 : 1);
      }
      
      public function runBeforePhysicsUpdate(param1:Number) : void
      {
         this.fusisywa = 0;
         var _loc2_:Number = Number(this.jifav.update(param1));
         var _loc3_:Number = Number(this.vibewyge.update(param1));
         this.hag.applyForces(_loc2_,_loc3_,param1);
         this.rotateTurret(param1);
      }
      
      private function rotateTurret(param1:Number) : void
      {
         if(this.mum != null)
         {
            this.mum.rotate(param1);
            this.lysecof.playTurretSound(this.mum.isRotating());
         }
      }
      
      private function setOptimalZCorrection(param1:Vector3) : void
      {
         this.nyryp = 0;
      }
      
      public function getWeapon() : Weapon
      {
         return this.tasapupat;
      }
      
      public function get inGame() : Boolean
      {
         return this.wom;
      }
      
      public function considerBodies(param1:Body, param2:Body) : Boolean
      {
         if(param1.fosa != null && param2.fosa == null)
         {
            ++Tank(param1.katuf).fusisywa;
         }
         else if(param1.fosa == null && param2.fosa != null)
         {
            ++Tank(param2.katuf).fusisywa;
         }
         return false;
      }
      
      public function setTracksCollisionGroup(param1:int) : void
      {
         this.hag.setTracksCollisionGroup(param1);
      }
      
      public function setBodyCollisionGroup(param1:int) : void
      {
         this.hogys.kyripama.nute = param1;
      }
      
      public function get turretController() : TurretController
      {
         return this.mum;
      }
      
      public function set turretController(param1:TurretController) : void
      {
         this.mum = param1;
         if(this.firaqe != null)
         {
            this.mum.setMaxTurnSpeed(this.firaqe.gejebuke,false);
            this.mum.setTurnAcceleration(this.firaqe.qupi);
         }
      }
      
      public function lockMovement() : void
      {
         this.hag.dajy = true;
         this.updateEngineSound();
      }
      
      public function unlockMovement() : void
      {
         this.hag.dajy = false;
         this.updateEngineSound();
      }
      
      public function getLeftTrack() : Track
      {
         return this.hag.vapal;
      }
      
      public function getRightTrack() : Track
      {
         return this.hag.mof;
      }
      
      public function setPosition(param1:Vector3) : void
      {
         this.hogys.body.setPosition(param1);
         this.hogys.body.saveState();
         this.zeneti.copy(param1);
      }
      
      public function setOrientation(param1:Quaternion) : void
      {
         this.hogys.body.setOrientation(param1);
         this.hogys.body.saveState();
         this.lobozofeh.copy(param1);
      }
   }
}

