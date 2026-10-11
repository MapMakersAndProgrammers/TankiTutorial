package alternativa.tanks.sfx
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.TanksPhysicsScene;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.vehicles.tank.Tank;
   import tutorial.EffectsManager;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class TankExplosionFactory
   {
      
      private static var smokeAnimation:TextureAnimation;
      
      private static var shockWaveAnimation:TextureAnimation;
      
      private static var fireAnimation:TextureAnimation;
      
      private static const FIRE_SIZE:Number = 800;
      
      private static const SMOKE_SIZE:Number = 400;
      
      private static const SHOCK_WAVE_SIZE:Number = 1000;
      
      private static const funa:Number = 600;
      
      private static const dyjedic:Number = 800;
      
      private static const juwizi:Number = 200;
      
      private static const SMOKE_ACCELERATION:Number = -2000;
      
      private static const gubeneb:int = 200;
      
      private static const rayHit:RayHit = new RayHit();
      
      private static const position:Vector3 = new Vector3();
      
      private static const eulerAngles:Vector3 = new Vector3();
      
      private static const velocity:Vector3 = new Vector3();
      
      private static const matrix:Matrix3 = new Matrix3();
      
      private static const wova:Number = 1;
      
      private static const effects:EffectsManager = GameData.effects;
      
      private static const physicsScene:TanksPhysicsScene = GameData.physicsScene;
      
      private static const objectPool:ObjectPool = GameData.objectPool;
      
      private static const bec:Vector3 = new Vector3(0,0,-1);
      
      private static const axis:Vector3 = new Vector3();
      
      public function TankExplosionFactory()
      {
         super();
      }
      
      public static function createEffect(tank:Tank) : void
      {
         var scale:Number = getEffectScale(tank);
         createExplosionShockWave(tank,scale);
         createExplosionFire(scale);
         createExplosionSmoke(scale);
      }
      
      private static function getEffectScale(tank:Tank) : Number
      {
         var hullMesh:Mesh = tank.skin.hullMesh;
         var sizeX:Number = hullMesh.boundMaxX - hullMesh.boundMinX;
         var sizeY:Number = hullMesh.boundMaxY - hullMesh.boundMinY;
         var sizeZ:Number = hullMesh.boundMaxZ - hullMesh.boundMinZ;
         var size:Number = Math.sqrt(sizeX * sizeX + sizeY * sizeY + sizeZ * sizeZ);
         return size / funa;
      }
      
      private static function createExplosionShockWave(tank:Tank, scale:Number) : void
      {
         var size:Number = NaN;
         var _loc6_:Number = NaN;
         var normal:Vector3 = null;
         var angle:Number = NaN;
         var planeEffect:AnimatedPlaneEffect = null;
         if(shockWaveAnimation == null)
         {
            shockWaveAnimation = Assets.getData("tank_explosion/shockwave",TextureAnimation);
         }
         var _loc3_:Number = 500;
         position.copy(tank.tankBody.body.state.position);
         var collisionDetector:CollisionDetector = physicsScene.collisionDetector;
         if(collisionDetector.raycastStatic(position,bec,255,_loc3_,null,rayHit))
         {
            rayHit.position.z += 10;
            size = SHOCK_WAVE_SIZE;
            _loc6_ = 200;
            if(rayHit.jomuc > _loc6_)
            {
               size *= (_loc3_ - rayHit.jomuc) / (_loc3_ - _loc6_);
            }
            normal = rayHit.normal;
            angle = Math.acos(normal.z);
            axis.x = -normal.y;
            axis.y = normal.x;
            axis.z = 0;
            axis.normalize();
            matrix.fromAxisAngle(axis,angle);
            matrix.getEulerAngles(eulerAngles);
            planeEffect = AnimatedPlaneEffect(objectPool.getObject(AnimatedPlaneEffect));
            planeEffect.init(scale * size,rayHit.position,eulerAngles,shockWaveAnimation.fps,shockWaveAnimation,wova);
            effects.addEffect(planeEffect);
         }
      }
      
      private static function createExplosionFire(scale:Number) : void
      {
         if(fireAnimation == null)
         {
            fireAnimation = Assets.getData("tank_explosion/explosion",TextureAnimation);
         }
         position.z += 50;
         var positionProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPool.getObject(StaticObject3DPositionProvider));
         positionProvider.init(position,gubeneb);
         var spriteEffect:AnimatedSpriteEffect = AnimatedSpriteEffect(objectPool.getObject(AnimatedSpriteEffect));
         var size:Number = FIRE_SIZE * scale;
         spriteEffect.init(size,size,fireAnimation,Math.random() * 2 * Math.PI,fireAnimation.fps,positionProvider);
         effects.addEffect(spriteEffect);
      }
      
      private static function createExplosionSmoke(scale:Number) : void
      {
         var speed:Number = NaN;
         var positionProvider:MovingObject3DPositionProvider = null;
         var spriteEffect:AnimatedSpriteEffect = null;
         var size:Number = NaN;
         if(smokeAnimation == null)
         {
            smokeAnimation = Assets.getData("tank_explosion/smoke",TextureAnimation);
         }
         var i:int = 0;
         while(i < 3)
         {
            speed = dyjedic + Math.random() * juwizi;
            velocity.x = speed * (1 - 2 * Math.random());
            velocity.y = speed * (1 - 2 * Math.random());
            velocity.z = speed * 0.5 * (1 + Math.random());
            positionProvider = MovingObject3DPositionProvider(objectPool.getObject(MovingObject3DPositionProvider));
            positionProvider.init(position,velocity,SMOKE_ACCELERATION);
            spriteEffect = AnimatedSpriteEffect(objectPool.getObject(AnimatedSpriteEffect));
            size = SMOKE_SIZE * scale;
            spriteEffect.init(size,size,smokeAnimation,Math.random() * 2 * Math.PI,smokeAnimation.fps,positionProvider);
            effects.addEffect(spriteEffect);
            i++;
         }
      }
   }
}

