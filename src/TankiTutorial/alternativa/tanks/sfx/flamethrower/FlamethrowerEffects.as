package alternativa.tanks.sfx.flamethrower
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.tanks.sfx.CollisionObject3DPositionProvider;
   import alternativa.tanks.sfx.MobileSound3DEffect;
   import alternativa.tanks.sfx.MuzzlePositionProvider;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sound.ISoundManager;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import tutorial.EffectsManager;
   import tutorial.GameData;
   
   public class FlamethrowerEffects implements StreamWeaponEffects
   {
      
      private static const MAX_PARTICLES:int = 20;
      
      private static const PARTICLE_SPEED:int = 2000;
      
      private static const SOUND_VOLUME:Number = 1;
      
      private static const PLANE_WIDTH:int = 100;
      
      private static const PLANE_LENGTH:int = 300;
      
      private var objectPool:ObjectPool = GameData.objectPool;
      
      private var effects:EffectsManager = GameData.effects;
      
      private var soundManager:ISoundManager = GameData.soundManager;
      
      private var range:Number;
      
      private var coneAngle:Number;
      
      private var sfxData:StreamWeaponSFXData;
      
      private var graphicEffect:StreamWeaponGraphicEffect;
      
      private var soundEffect:MobileSound3DEffect;
      
      private var muzzleLightEffect:OmniStreamLightEffect;
      
      private var streamLightEffect:OmniStreamLightEffect;
      
      public function FlamethrowerEffects(range:Number, coneAngle:Number, sfxData:StreamWeaponSFXData)
      {
         super();
         this.range = range;
         this.coneAngle = coneAngle;
         this.sfxData = sfxData;
      }
      
      public function startEffects(body:Body, localMuzzlePosition:Vector3, turretMesh:Mesh) : void
      {
         var sound:Sound3D = null;
         var muzzlePositionProvider:MuzzlePositionProvider = null;
         var collisionPositionProvider:CollisionObject3DPositionProvider = null;
         var particlesPositionProvider:StreamWeaponParticlesPositionProvider = null;
         if(this.graphicEffect == null)
         {
            this.graphicEffect = StreamWeaponGraphicEffect(this.objectPool.getObject(StreamWeaponGraphicEffect));
            this.graphicEffect.init(body,this.range,this.coneAngle,FlamethrowerEffectsParams.PARTICLE_SPEED,localMuzzlePosition,turretMesh,this.sfxData,GameData.physicsScene.collisionDetector,FlamethrowerEffectsParams.PLANE_WIDTH,FlamethrowerEffectsParams.PLANE_LENGTH,FlamethrowerEffectsParams.MIN_PARTICLE_SIZE,FlamethrowerEffectsParams.MAX_PARTICLE_SIZE,FlamethrowerEffectsParams.coteci,FlamethrowerEffectsParams.tasimep);
            this.effects.addEffect(this.graphicEffect);
            sound = Sound3D.create(this.sfxData.flameSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.fyvilyv,FlamethrowerEffectsParams.SOUND_VOLUME);
            if(sound != null)
            {
               this.soundEffect = MobileSound3DEffect(this.objectPool.getObject(MobileSound3DEffect));
               this.soundEffect.init(sound,turretMesh,0,2);
               this.soundManager.addEffect(this.soundEffect);
            }
            this.muzzleLightEffect = OmniStreamLightEffect(this.objectPool.getObject(OmniStreamLightEffect));
            muzzlePositionProvider = MuzzlePositionProvider(this.objectPool.getObject(MuzzlePositionProvider));
            muzzlePositionProvider.init(turretMesh,localMuzzlePosition,0);
            this.muzzleLightEffect.init(muzzlePositionProvider,this.sfxData.muzzleStartLight,this.sfxData.muzzleLoopLight);
            this.effects.addEffect(this.muzzleLightEffect);
            this.streamLightEffect = OmniStreamLightEffect(this.objectPool.getObject(OmniStreamLightEffect));
            collisionPositionProvider = CollisionObject3DPositionProvider(this.objectPool.getObject(CollisionObject3DPositionProvider));
            collisionPositionProvider.init(turretMesh,localMuzzlePosition,GameData.physicsScene.collisionDetector,FlamethrowerEffectsParams.zowoma);
            particlesPositionProvider = StreamWeaponParticlesPositionProvider(this.objectPool.getObject(StreamWeaponParticlesPositionProvider));
            particlesPositionProvider.init(this.graphicEffect,collisionPositionProvider);
            this.streamLightEffect.init(particlesPositionProvider,this.sfxData.streamStartLight,this.sfxData.streamLoopLight);
            this.effects.addEffect(this.streamLightEffect);
         }
      }
      
      public function stopEffects() : void
      {
         if(this.graphicEffect != null)
         {
            this.graphicEffect.kill();
            this.graphicEffect = null;
         }
         if(Boolean(this.soundEffect))
         {
            this.soundEffect.kill();
            this.soundEffect = null;
         }
         if(Boolean(this.muzzleLightEffect))
         {
            this.muzzleLightEffect.stop();
            this.muzzleLightEffect = null;
         }
         if(this.streamLightEffect != null)
         {
            this.streamLightEffect.stop();
            this.streamLightEffect = null;
         }
      }
   }
}

