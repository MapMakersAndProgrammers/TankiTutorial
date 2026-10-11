package alternativa.tanks.sfx.flamethrower
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.physics.Body;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.sfx.GraphicEffect;
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.sfx.SFXUtils;
   import alternativa.tanks.physics.CollisionGroup;
   import tutorial.commons.Assets;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: needed to access and object3d property
   use namespace alternativa3d;

   public class StreamWeaponGraphicEffect extends PooledObject implements GraphicEffect
   {
      
      private static const MAX_PARTICLES:int = 20;
      
      private static const ROTATION_SPEED:Number = 3;
      
      private static const gijalatyt:Matrix3 = new Matrix3();
      
      private static const matrix:Matrix4 = new Matrix4();
      
      private static const barrelOrigin:Vector3 = new Vector3();
      
      private static const direction:Vector3 = new Vector3();
      
      private static const xAxis:Vector3 = new Vector3();
      
      private static const particlePosition:Vector3 = new Vector3();
      
      private static const muzzlePosition:Vector3 = new Vector3();
      
      private static const rayHit:RayHit = new RayHit();
      
      private var _range:Number;
      
      private var marehod:Number;
      
      private var particleSpeed:Number;
      
      private var localMuzzlePosition:Vector3 = new Vector3();
      
      private var turret:Object3D;
      
      private var sfxData:StreamWeaponSFXData;
      
      private var collisionDetector:CollisionDetector;
      
      private var _particles:Vector.<StreamWeaponParticle> = new Vector.<StreamWeaponParticle>(MAX_PARTICLES);
      
      private var jadeqy:Number;
      
      private var particleInterval:Number;
      
      private var time:int;
      
      private var nextParticleTime:int;
      
      private var _numParticles:int;
      
      private var container:Object3DContainer;
      
      private var killed:Boolean;
      
      private var muzzlePlane:StreamWeaponMuzzlePlane;
      
      private var body:Body;
      
      private var minParticleSize:Number;
      
      private var maxParticleSize:Number;
      
      private var nel:Number;
      
      private var tizymaku:Number;
      
      public function StreamWeaponGraphicEffect(pool:Pool)
      {
         super(pool);
         this.muzzlePlane = new StreamWeaponMuzzlePlane();
      }
      
      public function init(body:Body, range:Number, coneAngle:Number, particleSpeed:Number, localMuzzlePosition:Vector3, turret:Object3D, sfxData:StreamWeaponSFXData, collisionDetector:CollisionDetector, planeWidth:Number, planeLength:Number, minParticleSize:Number, maxParticleSize:Number, param13:Number, param14:Number) : void
      {
         this.body = body;
         this._range = range;
         this.marehod = Math.tan(0.5 * coneAngle);
         this.particleSpeed = particleSpeed;
         this.localMuzzlePosition.copy(localMuzzlePosition);
         this.turret = turret;
         this.sfxData = sfxData;
         this.collisionDetector = collisionDetector;
         this.minParticleSize = minParticleSize;
         this.maxParticleSize = maxParticleSize;
         this.nel = param13;
         this.tizymaku = param14;
         sfxData.muzzleAnimation = Assets.getData("flame_muzzle",TextureAnimation);
         this.muzzlePlane.resize(planeWidth,planeLength);
         this.jadeqy = 2 * (maxParticleSize - minParticleSize) / range;
         this.particleInterval = 1000 * range / (MAX_PARTICLES * particleSpeed);
         this._numParticles = 0;
         this.time = this.nextParticleTime = getTimer();
         this.initMuzzlePlane(sfxData);
         this.killed = false;
      }
      
      private function initMuzzlePlane(param1:StreamWeaponSFXData) : void
      {
         var entry:ColorTransformEntry = null;
         var colorTransform:ColorTransform = null;
         this.muzzlePlane.init(param1.muzzleAnimation);
         if(param1.muzzleColorTransforms != null)
         {
            entry = param1.muzzleColorTransforms[0];
            colorTransform = this.muzzlePlane.colorTransform == null ? new ColorTransform() : this.muzzlePlane.colorTransform;
            colorTransform.alphaMultiplier = entry.alphaMultiplier;
            colorTransform.alphaOffset = entry.alphaOffset;
            colorTransform.redMultiplier = entry.redMultiplier;
            colorTransform.redOffset = entry.redOffset;
            colorTransform.greenMultiplier = entry.greenMultiplier;
            colorTransform.greenOffset = entry.greenOffset;
            colorTransform.blueMultiplier = entry.blueMultiplier;
            colorTransform.blueOffset = entry.blueOffset;
            this.muzzlePlane.colorTransform = colorTransform;
         }
         else
         {
            this.muzzlePlane.colorTransform = null;
         }
      }
      
      public function destroy() : void
      {
         while(this._numParticles > 0)
         {
            this.removeParticle(0);
         }
         this.muzzlePlane.removeFromParent();
         this.muzzlePlane.clear();
         this.container = null;
         this.body = null;
         this.turret = null;
         this.sfxData = null;
         this.collisionDetector = null;
         recycle();
      }
      
      public function play(deltaTime:int, camera:GameCamera) : Boolean
      {
         var dt:Number = NaN;
         var particle:StreamWeaponParticle = null;
         var velocity:Vector3 = null;
         var size:Number = NaN;
         this.calculateParameters();
         dt = deltaTime / 1000;
         if(this.collisionDetector.raycastStatic(barrelOrigin,direction,CollisionGroup.STATIC,this.localMuzzlePosition.y + this.muzzlePlane.length,null,rayHit))
         {
            this.muzzlePlane.visible = false;
         }
         else
         {
            this.muzzlePlane.visible = true;
            this.muzzlePlane.update(dt,this.sfxData.muzzleAnimation.fps);
            SFXUtils.alignObjectPlaneToView(this.muzzlePlane,muzzlePosition,direction,camera.position);
         }
         if(!this.killed && this._numParticles < MAX_PARTICLES && this.time >= this.nextParticleTime)
         {
            this.nextParticleTime += this.particleInterval;
            this.addParticle();
         }
         var i:int = 0;
         while(i < this._numParticles)
         {
            particle = this._particles[i];
            particlePosition.x = particle.x;
            particlePosition.y = particle.y;
            particlePosition.z = particle.z;
            if(particle.flightDistance > this._range || Boolean(this.collisionDetector.raycastStatic(particlePosition,particle.velocity,CollisionGroup.WEAPON,dt,null,rayHit)))
            {
               this.removeParticle(i--);
            }
            else
            {
               velocity = particle.velocity;
               particle.x += velocity.x * dt;
               particle.y += velocity.y * dt;
               particle.z += velocity.z * dt;
               particle.flightDistance += this.particleSpeed * dt;
               particle.rotation += ROTATION_SPEED * dt * particle.rotationDirection;
               particle.setFrameIndex(particle.frameIndex);
               particle.frameIndex += this.sfxData.particleAnimation.fps * dt;
               size = this.minParticleSize + this.jadeqy * particle.flightDistance;
               if(size > this.maxParticleSize)
               {
                  size = this.maxParticleSize;
               }
               particle.width = size;
               particle.height = size;
               particle.updateColorTransofrm(this._range,this.sfxData.particleColorTransforms);
            }
            i++;
         }
         this.time += deltaTime;
         return !this.killed || this._numParticles > 0;
      }
      
      public function kill() : void
      {
         if(!this.killed)
         {
            this.killed = true;
            this.muzzlePlane.removeFromParent();
         }
      }
      
      public function addedToScene(container:Object3DContainer) : void
      {
         this.container = container;
         container.addChild(this.muzzlePlane);
      }
      
      private function calculateParameters() : void
      {
         var _loc1_:Number = NaN;
         matrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         xAxis.x = matrix.ma;
         xAxis.y = matrix.me;
         xAxis.z = matrix.mi;
         direction.x = matrix.mb;
         direction.y = matrix.mf;
         direction.z = matrix.mj;
         matrix.transformVector(this.localMuzzlePosition,muzzlePosition);
         _loc1_ = Number(this.localMuzzlePosition.y);
         barrelOrigin.x = muzzlePosition.x - _loc1_ * direction.x;
         barrelOrigin.y = muzzlePosition.y - _loc1_ * direction.y;
         barrelOrigin.z = muzzlePosition.z - _loc1_ * direction.z;
      }
      
      private function addParticle() : void
      {
         var distance:Number = this.nel + Math.random() * this.tizymaku;
         if(!this.muzzlePlane.visible && rayHit.time < this.localMuzzlePosition.y + distance)
         {
            return;
         }
         var particle:StreamWeaponParticle = StreamWeaponParticle.getParticle();
         particle.setAnimationData(this.sfxData.particleAnimation);
         particle.rotation = Math.random() * Math.PI * 2;
         particle.frameIndex = Math.random() * particle.getNumFrames();
         this.getParticleFlightDirection(direction);
         particle.velocity.x = this.particleSpeed * direction.x;
         particle.velocity.y = this.particleSpeed * direction.y;
         particle.velocity.z = this.particleSpeed * direction.z;
         particle.velocity.add(this.body.state.velocity);
         particle.flightDistance = distance;
         particle.x = muzzlePosition.x + distance * direction.x;
         particle.y = muzzlePosition.y + distance * direction.y;
         particle.z = muzzlePosition.z + distance * direction.z;
         particle.rotationDirection = Math.random() < 0.5 ? 1 : -1;
         this._particles[this._numParticles++] = particle;
         this.container.addChild(particle);
      }
      
      private function removeParticle(index:int) : void
      {
         var particle:StreamWeaponParticle = this._particles[index];
         this._particles[index] = this._particles[--this._numParticles];
         this._particles[this._numParticles] = null;
         particle.dispose();
      }
      
      private function getParticleFlightDirection(param1:Vector3) : void
      {
         var _loc3_:Number = NaN;
         var angle:Number = 2 * Math.PI * Math.random();
         gijalatyt.fromAxisAngle(param1,angle);
         xAxis.transform3(gijalatyt);
         _loc3_ = this._range * this.marehod * Math.random();
         param1.x = param1.x * this._range + xAxis.x * _loc3_;
         param1.y = param1.y * this._range + xAxis.y * _loc3_;
         param1.z = param1.z * this._range + xAxis.z * _loc3_;
         param1.normalize();
      }
      
      public function get particles() : Vector.<StreamWeaponParticle>
      {
         return this._particles;
      }
      
      public function get numParticles() : int
      {
         return this._numParticles;
      }
      
      public function get range() : Number
      {
         return this._range;
      }
   }
}

