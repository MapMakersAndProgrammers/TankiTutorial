package alternativa.tanks.sfx.twins
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.physics.Body;
   import alternativa.physics.TanksPhysicsScene;
   import tutorial.EffectsManager;
   import tutorial.GameData;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.utils.MathUtils;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.battle.PhysicsController;
   import alternativa.tanks.battle.PhysicsInterpolator;
   import alternativa.tanks.sfx.AnimatedSprite3D;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.sfx.ExternalObject3DPositionProvider;
   import alternativa.tanks.sfx.AnimatedLightEffect;
   import alternativa.tanks.sfx.LightData;
   import alternativa.tanks.sfx.LightAnimation;
   import alternativa.tanks.sfx.AnimatedSpriteEffect;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.RenderGroup;
   import tutorial.commons.Assets;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.IRayCollisionFilter;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: this is needed to access some object3d properties
   use namespace alternativa3d;

   public class PlasmaShot extends PooledObject implements PhysicsController, PhysicsInterpolator, IRayCollisionFilter, Renderer
   {
      
      private static var shotAnimation:TextureAnimation;
      
      private static var explosionAnimation:TextureAnimation;
      
      public static const SPRITE_SIZE:Number = 250;
      
      public static const EXPLOSION_SIZE:Number = 300;
      
      private static const zily:int = 1000;
      
      private static const FPS:Number = 30;
      
      private static const NUM_RADIAL_POINTS:int = 8;
      
      private static const ANGLE_STEP:Number = 2 * Math.PI / NUM_RADIAL_POINTS;
      
      private static const matrix:Matrix3 = new Matrix3();
      
      private static const rayOrigin:Vector3 = new Vector3();
      
      private static const rayHit:RayHit = new RayHit();
      
      private static const radialOffset:Vector3 = new Vector3();
      
      public static const MAX_DISTANCE:Number = 6000;
      
      public static const SPEED:Number = 9000;
      
      public static const RADIUS:Number = 50;
      
      private static const physicsScene:TanksPhysicsScene = GameData.physicsScene;
      
      private static const kdContainer:KDContainer = GameData.kdContainer;
      
      private static const objectPool:ObjectPool = GameData.objectPool;
      
      private static const effects:EffectsManager = GameData.effects;
      
      private static const renderers:RenderGroup = GameData.renderers;
      
      private static const neputi:Vector3 = new Vector3();
      
      private const displacement:Vector3 = new Vector3();
      
      private var taramuty:Body;
      
      private var direction:Vector3 = new Vector3();
      
      private var impactForce:Number;
      
      private var firstTick:Boolean;
      
      private var currentPosition:Vector3 = new Vector3();
      
      private var prevPosition:Vector3 = new Vector3();
      
      private var barrelOrigin:Vector3 = new Vector3();
      
      private var interpolatedPosition:Vector3 = new Vector3();
      
      private var radialPoints:Vector.<Vector3>;
      
      private var distance:Number = 0;
      
      private var sprite:AnimatedSprite3D;
      
      private var numFrames:int;
      
      private var frameIndex:Number;
      
      private var damage:Number;
      
      public var shotLight:LightAnimation = LightData.plasmaShotLight;
      
      public var explosionLight:LightAnimation = LightData.plasmaExplosionLight;
      
      private var lightEffect:AnimatedLightEffect;
      
      private var positionProvider:ExternalObject3DPositionProvider;
      
      public function PlasmaShot(param1:Pool)
      {
         super(param1);
         this.radialPoints = new Vector.<Vector3>(NUM_RADIAL_POINTS);
         var i:int = 0;
         while(i < NUM_RADIAL_POINTS)
         {
            this.radialPoints[i] = new Vector3();
            i++;
         }
         this.sprite = new AnimatedSprite3D(SPRITE_SIZE,SPRITE_SIZE);
      }
      
      private static function getMostOrthogonalAxis(vector:Vector3, result:Vector3) : void
      {
         var index:int = 0;
         var minValue:Number = 10000000000;
         var value:Number = vector.x < 0 ? -vector.x : Number(vector.x);
         if(value < minValue)
         {
            minValue = value;
            index = 0;
         }
         value = vector.y < 0 ? -vector.y : Number(vector.y);
         if(value < minValue)
         {
            minValue = value;
            index = 1;
         }
         value = vector.z < 0 ? -vector.z : Number(vector.z);
         if(value < minValue)
         {
            index = 2;
         }
         switch(index)
         {
            case 0:
               result.x = 0;
               result.y = vector.z;
               result.z = -vector.y;
               break;
            case 1:
               result.x = -vector.z;
               result.y = 0;
               result.z = vector.x;
               break;
            case 2:
               result.x = vector.y;
               result.y = -vector.x;
               result.z = 0;
         }
      }
      
      public function init(param1:Number, param2:Number) : void
      {
         if(shotAnimation == null)
         {
            shotAnimation = Assets.getData("plasma",TextureAnimation);
         }
         this.impactForce = param1;
         this.damage = param2;
         this.sprite.setAnimationData(shotAnimation);
         this.numFrames = this.sprite.getNumFrames();
         this.frameIndex = this.numFrames * Math.random();
         this.sprite.rotation = MathUtils.PI2 * Math.random();
         this.distance = 0;
         this.firstTick = true;
      }
      
      public function addToGame(param1:Vector3, muzzlePosition:Vector3, param3:Vector3, body:Body) : void
      {
         this.barrelOrigin.copy(param1);
         this.currentPosition.copy(muzzlePosition);
         this.prevPosition.copy(muzzlePosition);
         this.interpolatedPosition.copy(muzzlePosition);
         this.sprite.x = muzzlePosition.x;
         this.sprite.y = muzzlePosition.y;
         this.sprite.z = muzzlePosition.z;
         this.direction.copy(param3);
         this.taramuty = body;
         this.lightEffect = AnimatedLightEffect(objectPool.getObject(AnimatedLightEffect));
         this.positionProvider = ExternalObject3DPositionProvider(objectPool.getObject(ExternalObject3DPositionProvider));
         this.positionProvider.setPosition(muzzlePosition);
         this.lightEffect.init(this.positionProvider,this.shotLight,AnimatedLightEffect.nimowu,true);
         effects.addEffect(this.lightEffect);
         physicsScene.addPhysicsController(this);
         physicsScene.addPhysicsInterpolator(this);
         renderers.addRenderer(this);
      }
      
      public function runBeforePhysicsUpdate(dt:Number) : void
      {
         var point:Vector3 = null;
         var collisionDetector:CollisionDetector = physicsScene.tanksCollisionDetector;
         if(this.firstTick)
         {
            if(this.processFirstTick(collisionDetector))
            {
               return;
            }
            this.firstTick = false;
         }
         if(this.distance > MAX_DISTANCE)
         {
            this.destroy();
            return;
         }
         var step:Number = SPEED * dt;
         this.distance += step;
         if(collisionDetector.raycast(this.currentPosition,this.direction,CollisionGroup.pisyse,step,this,rayHit))
         {
            this.applyImpact(rayHit.shape.body,rayHit.position,this.direction,this.distance);
            this.destroy();
            return;
         }
         this.displacement.copy(this.direction).scale(step);
         var i:int = 0;
         while(i < NUM_RADIAL_POINTS)
         {
            point = this.radialPoints[i];
            if(collisionDetector.raycast(point,this.direction,CollisionGroup.pisyse,step,this,rayHit))
            {
               if(rayHit.shape.body != null)
               {
                  this.applyImpact(rayHit.shape.body,rayHit.position,this.direction,this.distance);
                  this.destroy();
                  return;
               }
            }
            point.add(this.displacement);
            i++;
         }
         this.prevPosition.copy(this.currentPosition);
         this.currentPosition.add(this.displacement);
      }
      
      public function render(time:int, deltaTime:int) : void
      {
         if(!this.firstTick && this.sprite._parent == null)
         {
            kdContainer.addChild(this.sprite);
         }
         var dt:Number = deltaTime / zily;
         this.sprite.setFrameIndex(this.frameIndex);
         this.frameIndex += FPS * dt;
         if(this.frameIndex >= this.numFrames)
         {
            this.frameIndex = 0;
         }
         var size:Number = SPRITE_SIZE;
         this.sprite.width = size;
         this.sprite.height = size;
         this.sprite.x = this.interpolatedPosition.x;
         this.sprite.y = this.interpolatedPosition.y;
         this.sprite.z = this.interpolatedPosition.z;
         this.sprite.rotation -= 3 * dt;
         this.positionProvider.setPosition(this.interpolatedPosition);
      }
      
      public function destroy() : void
      {
         this.sprite.removeFromParent();
         this.taramuty = null;
         this.sprite.material = null;
         this.sprite.colorTransform = null;
         physicsScene.removePhysicsController(this);
         physicsScene.removePhysicsInterpolator(this);
         renderers.removeRenderer(this);
         this.lightEffect.kill();
         this.lightEffect = null;
         this.positionProvider = null;
         recycle();
      }
      
      public function considerBody(body:Body) : Boolean
      {
         return this.taramuty != body;
      }
      
      private function initRadialPoints(center:Vector3, axis:Vector3, radius:Number) : void
      {
         getMostOrthogonalAxis(axis,radialOffset);
         radialOffset.normalize().scale(radius);
         matrix.fromAxisAngle(axis,ANGLE_STEP);
         Vector3(this.radialPoints[0]).copy(center).add(radialOffset);
         var i:int = 1;
         while(i < NUM_RADIAL_POINTS)
         {
            radialOffset.transform3(matrix);
            Vector3(this.radialPoints[i]).copy(center).add(radialOffset);
            i++;
         }
      }
      
      private function createExplosionEffect(position:Vector3, param2:Number) : void
      {
         if(explosionAnimation == null)
         {
            explosionAnimation = Assets.getData("plasma_exp",TextureAnimation);
         }
         var offset:int = 50 + EXPLOSION_SIZE * 0.5;
         var staticPositionProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPool.getObject(StaticObject3DPositionProvider));
         staticPositionProvider.init(position,offset);
         var size:Number = EXPLOSION_SIZE * (1 + param2) / 2;
         var spriteEffect:AnimatedSpriteEffect = AnimatedSpriteEffect(objectPool.getObject(AnimatedSpriteEffect));
         var fps:int = 20;
         spriteEffect.init(size,size,explosionAnimation,MathUtils.PI2 * Math.random(),fps,staticPositionProvider,0.5,0.5,null);
         effects.addEffect(spriteEffect);
         this.createExplsionLightEffect(position);
      }
      
      private function createExplsionLightEffect(position:Vector3) : void
      {
         var offset:int = 50 + EXPLOSION_SIZE * 0.5;
         var animatedLightEffect:AnimatedLightEffect = AnimatedLightEffect(objectPool.getObject(AnimatedLightEffect));
         var staticPositionProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPool.getObject(StaticObject3DPositionProvider));
         staticPositionProvider.init(position,offset);
         animatedLightEffect.init(staticPositionProvider,this.explosionLight);
         effects.addEffect(animatedLightEffect);
      }
      
      private function applyImpact(body:Body, position:Vector3, param3:Vector3, param4:Number) : void
      {
         var tank:Tank = null;
         this.createExplosionEffect(position,1);
         if(body != null)
         {
            tank = body.data as Tank;
            if(tank != null)
            {
               body.addWorldForceScaled(position,param3,this.impactForce);
               tank.substructHealth(this.damage);
            }
         }
      }
      
      private function processFirstTick(collisionDetector:CollisionDetector) : Boolean
      {
         var point:Vector3 = null;
         var body:Body = null;
         rayOrigin.copy(this.currentPosition);
         var radius:Number = RADIUS;
         rayOrigin.z += radius;
         if(collisionDetector.raycast(rayOrigin,Vector3.down,CollisionGroup.STATIC,radius,null,rayHit))
         {
            this.applyImpact(null,rayHit.position,null,0);
            this.destroy();
            return true;
         }
         var dir:Vector3 = neputi;
         dir.diff(this.currentPosition,this.barrelOrigin);
         var rayLength:Number = Number(dir.length());
         dir.normalize();
         if(collisionDetector.raycast(this.barrelOrigin,dir,CollisionGroup.WEAPON,rayLength,this,rayHit))
         {
            this.barrelOrigin.addScaled(rayHit.jomuc,dir);
            this.applyImpact(rayHit.shape.body,this.barrelOrigin,dir,0);
            this.destroy();
            return true;
         }
         this.initRadialPoints(this.barrelOrigin,dir,radius);
         var i:int = 0;
         while(i < NUM_RADIAL_POINTS)
         {
            point = this.radialPoints[i];
            if(collisionDetector.raycast(point,this.direction,CollisionGroup.WEAPON,rayLength,this,rayHit))
            {
               body = rayHit.shape.body;
               if(body != null)
               {
                  this.barrelOrigin.addScaled(rayHit.jomuc,dir);
                  this.applyImpact(body,this.barrelOrigin,dir,0);
                  this.destroy();
                  return true;
               }
            }
            i++;
         }
         this.initRadialPoints(this.currentPosition,this.direction,radius);
         return false;
      }
      
      public function interpolatePhysicsState(t:Number) : void
      {
         this.interpolatedPosition.interpolate(t,this.prevPosition,this.currentPosition);
      }
   }
}

