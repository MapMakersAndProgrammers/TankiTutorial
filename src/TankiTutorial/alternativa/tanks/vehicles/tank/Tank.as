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
      
      private static const EXPLOSION_VOLUME:Number = 0.4;
      
      private static const lilotes:Vector3 = new Vector3();
      
      private static const wokymityf:Matrix3 = new Matrix3();
      
      private static const qef:Matrix4 = new Matrix4();
      
      private static const rizy:Matrix4 = new Matrix4();
      
      private static const qalolyris:Vector3 = new Vector3();
      
      private static const zAxis:Vector3 = new Vector3();
      
      private static const position:Vector3 = new Vector3();
      
      private static const direction:Vector3 = new Vector3();
      
      private static const xAxis:Vector3 = new Vector3();
      
      private static const yAxis:Vector3 = new Vector3();
      
      private const interpolatedPosition:Vector3 = new Vector3();
      
      private const interpolatedOrientation:Quaternion = new Quaternion();
      
      private var maxSpeedSmoother:ValueSmoother = new SimpleValueSmoother(100,1000,0,0);
      
      private var maxTurnSpeedSmoother:ValueSmoother = new SimpleValueSmoother(0.3,10,0,0);
      
      private const soundManager:ISoundManager = GameData.soundManager;
      
      private const kdContainer:KDContainer = GameData.kdContainer;
      
      private const camera:GameCamera = GameData.camera;
      
      private const physicsScene:TanksPhysicsScene = GameData.physicsScene;
      
      private const objectPool:ObjectPool = GameData.objectPool;
      
      private const renderers:RenderGroup = GameData.renderers;
      
      private var visibilityPoints:Vector.<Vector3>;
      
      private var zCorrection:Number = 0;
      
      public var hull:TankHull;
      
      public var turret:TankTurret;
      
      public var tankBody:TankBody;
      
      private var mass:Number;
      
      private var fusisywa:int;
      
      private var turretDirection:Number = 0;
      
      public var skin:TankSkin;
      
      private var health:Number;
      
      private var maxHealth:Number;
      
      public var alive:Boolean;
      
      private var weapon:Weapon;
      
      public var userTitle:UserTitle;
      
      public var sounds:TankSounds;
      
      private var _inGame:Boolean;
      
      private var colormapName:String;
      
      private const respawnPosition:Vector3 = new Vector3();
      
      private const respawnOrientation:Quaternion = new Quaternion();
      
      private const checkpointPosition:Vector3 = new Vector3();
      
      private const checkpointOrientation:Quaternion = new Quaternion();
      
      private var _turretController:TurretController;
      
      private var momomafoj:Number = 0;
      
      public var boundSphereRadius:Number;
      
      private var suspensionParams:SuspensionParams = new SuspensionParams();
      
      private var chassis:TrackedChassis;
      
      private var tracksAnimator:TracksAnimator;
      
      private var soundAdded:Boolean = false;
      
      public function Tank()
      {
         super();
         this.skin = new TankSkin();
      }
      
      public function get body() : Body
      {
         if(this.tankBody == null)
         {
            throw new Error();
         }
         return this.tankBody.body;
      }
      
      public function setWeaponDamageMultiplier(value:Number) : void
      {
         if(this.weapon != null)
         {
            this.weapon.damageMultiplier = value;
         }
      }
      
      private function setMaxHealth(value:Number) : void
      {
         this.maxHealth = value;
         this.health = this.maxHealth;
      }
      
      public function substructHealth(damage:Number) : void
      {
         if(this == GameData.playerTank && this.health <= this.maxHealth * 0.5)
         {
            this.health -= this.health / this.maxHealth * damage;
         }
         else
         {
            this.health -= damage;
         }
         if(this.health < 0)
         {
            this.health = 0;
         }
         if(this.userTitle != null)
         {
            this.userTitle.setHealth(this.health,this.maxHealth);
         }
      }
      
      public function get currentHealth() : Number
      {
         return this.health;
      }
      
      public function init(hullName:String, turretName:String, colormapName:String, param4:Number = 0) : void
      {
         if(param4 > 0)
         {
            this.momomafoj = param4;
         }
         this.colormapName = colormapName;
         this.setHull(hullName);
         this.setTurret(turretName);
         this.setColormap(colormapName);
      }
      
      public function setHull(hullName:String) : void
      {
         var mesh:Mesh = null;
         var size:Vector3 = null;
         var newHull:TankHull = Hulls.objects[hullName];
         if(newHull == null)
         {
            throw new ArgumentError("Hull is null");
         }
         if(this.hull != newHull)
         {
            this.suspensionParams.dampingCoeff = newHull.damping;
            this.setMaxHealth(this.momomafoj > 0 ? this.momomafoj : Number(newHull.health));
            this.hull = newHull;
            this.skin.setHull(newHull);
            this.mass = newHull.mass;
            this.setMaxSpeed(newHull.speed,true);
            this.setMaxTurnSpeed(newHull.turnSpeed,true);
            mesh = newHull.skin;
            mesh.calculateBounds();
            size = new Vector3(2 * mesh.boundMaxX,2 * mesh.boundMaxY,mesh.boundMaxZ);
            this.createBody(this.mass,size);
            this.createChassis(size,newHull);
            this.setOptimalZCorrection(size);
            this.setBodyCollisionGroup(CollisionGroup.pisyse | CollisionGroup.bywowe | CollisionGroup.WEAPON | CollisionGroup.BONUS);
            this.setTracksCollisionGroup(CollisionGroup.bywowe);
         }
      }
      
      private function createBody(param1:Number, size:Vector3) : void
      {
         var _loc4_:Body = null;
         if(this.tankBody == null)
         {
            _loc4_ = new Body(param1,Matrix3.identity);
            _loc4_.data = this;
            this.tankBody = new TankBody(_loc4_);
         }
         var halfSize:Vector3 = size.clone();
         halfSize.scale(0.5);
         PhysicsUtils.setBoxInvInertia(param1,halfSize,this.tankBody.body.invInertia);
         this.tankBody.body.mass = param1;
         this.tankBody.body.invMass = 1 / param1;
         this.createCollisionPrimitives(halfSize);
         this.createVisibilityPoints(halfSize);
      }
      
      private function createCollisionPrimitives(halfSize:Vector3) : void
      {
         this.tankBody.clearCollisionShapes();
         var height:Number = 2 * halfSize.z - (this.suspensionParams.nominalRayLength - TankConst.kyr);
         CollisionBoxesBuilder.createTankCollisionBox(halfSize,height,this.tankBody);
         CollisionBoxesBuilder.createStaticCollisionBoxes(halfSize,height,this.tankBody);
         this.setBoundSphereRadius(halfSize,height);
      }
      
      private function setBoundSphereRadius(halfSize:Vector3, height:Number) : void
      {
         var boxHalfSize:Vector3 = new Vector3(halfSize.x,halfSize.y,height / 2);
         var transform:Matrix4 = this.tankBody.tankCollisionBox.localTransform;
         this.boundSphereRadius = boxHalfSize.length() + Math.abs(transform.ml);
      }
      
      private function createVisibilityPoints(halfSize:Vector3) : void
      {
         var halfX:Number = Number(halfSize.x);
         var halfY:Number = Number(halfSize.y);
         this.visibilityPoints = Vector.<Vector3>([new Vector3(-halfX,halfY,0),new Vector3(halfX,halfY,0),new Vector3(-halfX,0,0),new Vector3(halfX,0,0),new Vector3(-halfX,-halfY,0),new Vector3(halfX,-halfY,0)]);
      }
      
      private function createChassis(size:Vector3, tankHull:TankHull) : void
      {
         this.chassis = new TrackedChassis(this.tankBody.body,this.suspensionParams,this.maxSpeedSmoother,size);
         this.chassis.setAcceleration(tankHull.acceleration);
         this.chassis.setReverseAcceleration(tankHull.reverseAcceleration);
         this.chassis.setSideAcceleration(tankHull.sideAcceleration);
         this.chassis.setTurnAcceleration(tankHull.turnAcceleration);
         this.chassis.setReverseTurnAcceleration(tankHull.reverseTurnAcceleration);
         this.tracksAnimator = new TracksAnimator(this.chassis,this.skin,this.maxSpeedSmoother);
      }
      
      public function setTurret(turretName:String) : void
      {
         var newTurret:TankTurret = Turrets.objects[turretName];
         if(newTurret == null)
         {
            throw new ArgumentError("Turret is null");
         }
         if(this.turret != newTurret)
         {
            if(this.weapon != null)
            {
               this.weapon.stop();
            }
            this.weapon = Turrets.getWeapon(turretName);
            if(this._turretController != null)
            {
               this._turretController.setMaxTurnSpeed(newTurret.maxTurnSpeed,false);
               this._turretController.setTurnAcceleration(newTurret.turnAcceleration);
            }
            this.weapon.setTank(this);
            this.turret = newTurret;
            this.skin.setTurret(newTurret);
         }
      }
      
      public function getCameraParams(position:Vector3, direction:Vector3) : void
      {
         this.interpolatedOrientation.toMatrix3(wokymityf);
         lilotes.copy(this.interpolatedPosition);
         lilotes.x += this.zCorrection * wokymityf.mc;
         lilotes.y += this.zCorrection * wokymityf.mg;
         lilotes.z += this.zCorrection * wokymityf.mk;
         qef.setFromMatrix3(wokymityf,lilotes);
         var mountPoint:Vector3 = this.skin.getHull().mountPoint;
         rizy.setMatrix(mountPoint.x,mountPoint.y,mountPoint.z,0,0,GameData.mouseModeEnabled ? Number(this._turretController.getCameraDirection()) : Number(this._turretController.getDirection()));
         rizy.append(qef);
         position.reset(rizy.md,rizy.mh,rizy.ml);
         direction.reset(rizy.mb,rizy.mf,rizy.mj);
      }
      
      public function setMaxSpeed(value:Number, immediately:Boolean) : void
      {
         if(immediately)
         {
            this.maxSpeedSmoother.reset(value);
         }
         else
         {
            this.maxSpeedSmoother.setTargetValue(value);
         }
      }
      
      public function setMaxTurnSpeed(value:Number, immediately:Boolean) : void
      {
         if(immediately)
         {
            this.maxTurnSpeedSmoother.reset(value);
         }
         else
         {
            this.maxTurnSpeedSmoother.setTargetValue(value);
         }
      }
      
      public function setCheckpoint() : void
      {
         this.respawnPosition.copy(this.checkpointPosition);
         this.respawnOrientation.copy(this.checkpointOrientation);
         this.checkpointPosition.copy(this.tankBody.body.state.position);
         this.checkpointOrientation.copy(this.tankBody.body.state.orientation);
      }
      
      public function setColormap(param1:String) : void
      {
         var colormap:BitmapData = Assets.getData(param1,BitmapData);
         this.skin.setColormap(colormap);
      }
      
      public function kill() : void
      {
         if(this._turretController != null)
         {
            this._turretController.lock(1);
         }
         this.alive = false;
         this.soundManager.removeEffect(this.sounds);
         TankExplosionFactory.createEffect(this);
         this.setColormap("dead");
         if(this.userTitle != null)
         {
            this.userTitle.hide();
         }
         this.tankBody.body.state.velocity.z += 500;
         this.tankBody.body.state.rotation.reset(2,2,2);
         var sound:Sound3D = Sound3D.create(Assets.getData("tank_explosion",Sound),SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.fyvilyv,EXPLOSION_VOLUME);
         this.soundManager.addEffect(Sound3DEffect.create(this.objectPool,this.tankBody.body.state.position,sound,0,0));
      }
      
      public function respawn() : void
      {
         this.skin.turretMesh.visible = false;
         this.skin.hullMesh.visible = false;
         this.skin.shadow.alpha = 0;
         this.soundManager.addEffect(this.sounds);
         this.setColormap(this.colormapName);
         this.health = this.maxHealth;
         this.tankBody.body.setVelocityXYZ(0,0,0);
         this.tankBody.body.setPosition(this.respawnPosition);
         this.tankBody.body.setOrientation(this.respawnOrientation);
         if(this._turretController != null)
         {
            this._turretController.reset();
            this._turretController.unlock(1);
         }
         GameData.taskGroup.addTask(new ChangeCameraAngleTask(0.2,2));
         setTimeout(this.showAfterRespawn,1000);
      }
      
      private function showAfterRespawn() : void
      {
         this.skin.turretMesh.visible = true;
         this.skin.hullMesh.visible = true;
         this.skin.shadow.alpha = 1;
         if(this.userTitle != null)
         {
            this.userTitle.show();
         }
         this.alive = true;
      }
      
      public function addToGame() : void
      {
         this.physicsScene.addTankBody(this.tankBody);
         this.physicsScene.addPhysicsController(this);
         this.physicsScene.addPhysicsInterpolator(this);
         this.alive = true;
         this.renderers.addRenderer(this);
         this.skin.addToContainer(this.kdContainer,this.camera);
         GameData.dust.addTank(this);
         this._inGame = true;
         this.sounds = new TankSounds();
         this.sounds.setTank(this);
         this.sounds.turretSoundEnabled = true;
         this.addSoundToSoundManager();
      }
      
      public function addSoundToSoundManager() : void
      {
         if(!this.soundAdded)
         {
            this.soundAdded = this.soundManager.addEffect(this.sounds);
         }
      }
      
      public function removeFromGame() : void
      {
         this.soundManager.removeEffect(this.sounds);
         this.physicsScene.removeTankBody(this.tankBody);
         this.physicsScene.removePhysicsInterpolator(this);
         this.physicsScene.removePhysicsController(this);
         this.renderers.removeRenderer(this);
         this.skin.removeFromContainer();
         GameData.dust.removeTank(this);
         this._inGame = false;
      }
      
      public function heal() : void
      {
         this.health = this.maxHealth;
      }
      
      public function setMovementParams(movementDirection:int, turnDirection:int, param3:Boolean) : void
      {
         this.chassis.movementDirection = movementDirection;
         this.chassis.turnDirection = turnDirection;
         this.chassis.cewubegy = param3;
         this.updateEngineSound();
      }
      
      private function updateEngineSound() : void
      {
         if(this.chassis.movementLocked)
         {
            this.sounds.setIdleMode();
         }
         else if(this.chassis.movementDirection != 0)
         {
            this.sounds.setAccelerationMode();
         }
         else if(this.chassis.turnDirection != 0)
         {
            this.sounds.setTurningMode();
         }
         else
         {
            this.sounds.setIdleMode();
         }
      }
      
      public function interpolatePhysicsState(t:Number) : void
      {
         this.tankBody.body.interpolate(t,this.interpolatedPosition,this.interpolatedOrientation);
         this.interpolatedOrientation.normalize();
         if(this._turretController != null)
         {
            this.turretDirection = -this._turretController.getInterpolatedDirection(t);
         }
      }
      
      public function render(time:int, deltaTime:int) : void
      {
         this.interpolatedOrientation.toMatrix3(wokymityf);
         lilotes.copy(this.interpolatedPosition);
         lilotes.x += this.zCorrection * wokymityf.mc;
         lilotes.y += this.zCorrection * wokymityf.mg;
         lilotes.z += this.zCorrection * wokymityf.mk;
         this.skin.updateTransform(lilotes,this.interpolatedOrientation,this.turretDirection);
         var dt:Number = deltaTime * 0.001;
         this.tracksAnimator.animate(dt);
         lilotes.x = this.skin.turretMesh.x;
         lilotes.y = this.skin.turretMesh.y;
         lilotes.z = this.skin.turretMesh.z;
         if(this.weapon != null)
         {
            this.weapon.update(time,deltaTime);
         }
         if(this.userTitle != null)
         {
            this.userTitle.setWeaponStatus(100 * this.weapon.status);
            this.userTitle.setHealth(this.health,this.maxHealth);
            this.userTitle.update(lilotes);
         }
         if(this._turretController != null)
         {
            this._turretController.setTankDirection(this.calculateTankDirection());
         }
      }
      
      private function calculateTankDirection() : Number
      {
         this.interpolatedOrientation.toMatrix3(wokymityf);
         wokymityf.transformVector(Vector3.zAxis,zAxis);
         zAxis.normalize();
         qalolyris.z = this.zCorrection;
         lilotes.reset();
         lilotes.transform3(wokymityf);
         lilotes.add(this.interpolatedPosition);
         qef.setFromMatrix3(wokymityf,lilotes);
         position.reset(qef.md,qef.mh,qef.ml);
         direction.reset(qef.mb,qef.mf,qef.mj);
         direction.normalize();
         xAxis.copy(Vector3.xAxis);
         yAxis.copy(Vector3.yAxis);
         xAxis.projectOnPlane(zAxis);
         yAxis.projectOnPlane(zAxis);
         xAxis.normalize();
         yAxis.normalize();
         var yDot:Number = Number(yAxis.dot(direction));
         var xDot:Number = Number(xAxis.dot(direction));
         return Math.acos(yDot) * (xDot > 0 ? -1 : 1);
      }
      
      public function runBeforePhysicsUpdate(dt:Number) : void
      {
         this.fusisywa = 0;
         var maxSpeed:Number = Number(this.maxSpeedSmoother.update(dt));
         var maxTurnSpeed:Number = Number(this.maxTurnSpeedSmoother.update(dt));
         this.chassis.applyForces(maxSpeed,maxTurnSpeed,dt);
         this.rotateTurret(dt);
      }
      
      private function rotateTurret(dt:Number) : void
      {
         if(this._turretController != null)
         {
            this._turretController.rotate(dt);
            this.sounds.playTurretSound(this._turretController.isRotating());
         }
      }
      
      private function setOptimalZCorrection(size:Vector3) : void
      {
         this.zCorrection = 0;
      }
      
      public function getWeapon() : Weapon
      {
         return this.weapon;
      }
      
      public function get inGame() : Boolean
      {
         return this._inGame;
      }
      
      public function considerBodies(body1:Body, body2:Body) : Boolean
      {
         if(body1.collisionFilter != null && body2.collisionFilter == null)
         {
            ++Tank(body1.data).fusisywa;
         }
         else if(body1.collisionFilter == null && body2.collisionFilter != null)
         {
            ++Tank(body2.data).fusisywa;
         }
         return false;
      }
      
      public function setTracksCollisionGroup(collisionGroup:int) : void
      {
         this.chassis.setTracksCollisionGroup(collisionGroup);
      }
      
      public function setBodyCollisionGroup(collisionGroup:int) : void
      {
         this.tankBody.tankCollisionBox.collisionGroup = collisionGroup;
      }
      
      public function get turretController() : TurretController
      {
         return this._turretController;
      }
      
      public function set turretController(value:TurretController) : void
      {
         this._turretController = value;
         if(this.turret != null)
         {
            this._turretController.setMaxTurnSpeed(this.turret.maxTurnSpeed,false);
            this._turretController.setTurnAcceleration(this.turret.turnAcceleration);
         }
      }
      
      public function lockMovement() : void
      {
         this.chassis.movementLocked = true;
         this.updateEngineSound();
      }
      
      public function unlockMovement() : void
      {
         this.chassis.movementLocked = false;
         this.updateEngineSound();
      }
      
      public function getLeftTrack() : Track
      {
         return this.chassis.leftTrack;
      }
      
      public function getRightTrack() : Track
      {
         return this.chassis.rightTrack;
      }
      
      public function setPosition(position:Vector3) : void
      {
         this.tankBody.body.setPosition(position);
         this.tankBody.body.saveState();
         this.interpolatedPosition.copy(position);
      }
      
      public function setOrientation(orientation:Quaternion) : void
      {
         this.tankBody.body.setOrientation(orientation);
         this.tankBody.body.saveState();
         this.interpolatedOrientation.copy(orientation);
      }
   }
}

