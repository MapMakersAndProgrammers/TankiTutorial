package alternativa.tanks.sfx.smoky
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.sfx.AnimatedLightEffect;
   import alternativa.tanks.sfx.AnimatedSpriteEffect;
   import alternativa.tanks.sfx.MuzzlePositionProvider;
   import alternativa.tanks.sfx.SmokyMuzzleFlashEffect;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.sound.ISoundManager;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import tutorial.EffectsManager;
   import tutorial.GameData;
   
   public class SmokyEffects
   {
      
      public static const EXPLOSION_SIZE:Number = 900;
      
      private static const nydas:Number = 1;
      
      private static const qalibi:Number = 200;
      
      private static const MUZZLE_FLASH_DURATION:int = 100;
      
      private static const EXPLOSION_SOUND_DELAY:int = 100;
      
      private static const EXPLOSION_FPS:int = 30;
      
      private const soundManager:ISoundManager = GameData.soundManager;
      
      private const objectPool:ObjectPool = GameData.objectPool;
      
      private const effects:EffectsManager = GameData.effects;
      
      private var sfxData:SmokySFXData;
      
      public function SmokyEffects(sfxData:SmokySFXData)
      {
         super();
         this.sfxData = sfxData;
      }
      
      public function createShotEffects(localMuzzlePosition:Vector3, turretMesh:Mesh) : void
      {
         if(!this.sfxData.isReady)
         {
            this.sfxData.init();
         }
         this.createShotSoundEffect(turretMesh);
         this.createMuzzleFlashEffect(localMuzzlePosition,turretMesh);
         this.createMuzzleFlashLightEffect(localMuzzlePosition,turretMesh);
      }
      
      private function createShotSoundEffect(turretMesh:Mesh) : void
      {
         var sound:Sound3D = Sound3D.create(this.sfxData.shotSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.fyvilyv,nydas);
         this.soundManager.addEffect(Sound3DEffect.create(this.objectPool,new Vector3(turretMesh.x,turretMesh.y,turretMesh.z),sound));
      }
      
      private function createMuzzleFlashEffect(localMuzzlePosition:Vector3, turretMesh:Mesh) : void
      {
         var muzzleFlashEffect:SmokyMuzzleFlashEffect = SmokyMuzzleFlashEffect(this.objectPool.getObject(SmokyMuzzleFlashEffect));
         muzzleFlashEffect.init(localMuzzlePosition,turretMesh,this.sfxData.shotMaterial,MUZZLE_FLASH_DURATION);
         this.effects.addEffect(muzzleFlashEffect);
      }
      
      private function createMuzzleFlashLightEffect(localMuzzlePosition:Vector3, turretMesh:Mesh) : void
      {
         var lightEffect:AnimatedLightEffect = AnimatedLightEffect(this.objectPool.getObject(AnimatedLightEffect));
         var positionProvider:MuzzlePositionProvider = MuzzlePositionProvider(this.objectPool.getObject(MuzzlePositionProvider));
         positionProvider.init(turretMesh,localMuzzlePosition,0);
         lightEffect.init(positionProvider,this.sfxData.shotLight);
         this.effects.addEffect(lightEffect);
      }
      
      public function createExplosionEffects(position:Vector3, scale:Number) : void
      {
         this.createExplosionSoundEffect(position);
         this.createExplosionGraphicEffect(position,scale);
         this.createExplosionLightEffect(position);
      }
      
      private function createExplosionSoundEffect(position:Vector3) : void
      {
         var sound:Sound3D = Sound3D.create(this.sfxData.explosionSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.fyvilyv,1);
         this.soundManager.addEffect(Sound3DEffect.create(this.objectPool,position,sound,EXPLOSION_SOUND_DELAY));
      }
      
      private function createExplosionGraphicEffect(position:Vector3, scale:Number) : void
      {
         var positionProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(this.objectPool.getObject(StaticObject3DPositionProvider));
         positionProvider.init(position,qalibi);
         var spriteEffect:AnimatedSpriteEffect = AnimatedSpriteEffect(this.objectPool.getObject(AnimatedSpriteEffect));
         var size:Number = EXPLOSION_SIZE * scale;
         spriteEffect.init(size,size,this.sfxData.explosionAnimation,0,EXPLOSION_FPS,positionProvider);
         this.effects.addEffect(spriteEffect);
      }
      
      private function createExplosionLightEffect(position:Vector3) : void
      {
         var lightEffect:AnimatedLightEffect = AnimatedLightEffect(this.objectPool.getObject(AnimatedLightEffect));
         var positionProvider:StaticObject3DPositionProvider = StaticObject3DPositionProvider(this.objectPool.getObject(StaticObject3DPositionProvider));
         positionProvider.init(position,qalibi);
         lightEffect.init(positionProvider,this.sfxData.explosionLight);
         this.effects.addEffect(lightEffect);
      }
   }
}

