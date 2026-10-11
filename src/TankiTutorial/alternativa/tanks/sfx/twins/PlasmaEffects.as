package alternativa.tanks.sfx.twins
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.sfx.AnimatedLightEffect;
   import alternativa.tanks.sfx.LightAnimation;
   import alternativa.tanks.sfx.LightData;
   import alternativa.tanks.sfx.MuzzlePositionProvider;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sound.ISoundManager;
   import alternativa.tanks.utils.Utils3D;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import flash.media.Sound;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class PlasmaEffects
   {
      
      private static var shotSound:Sound;
      
      private static const zaf:int = 10;
      
      public static const cumutobe:int = 120;
      
      private static const pyzarije:int = 50;
      
      private static const sakel:int = 50;
      
      private static const objectPool:ObjectPool = GameData.objectPool;
      
      private static const soundManager:ISoundManager = GameData.soundManager;
      
      public var muzzleLight:LightAnimation = LightData.plasmaMuzzleLight;
      
      public function PlasmaEffects()
      {
         super();
      }
      
      public function createShotEffects(turretMesh:Mesh, localMuzzlePosition:Vector3) : void
      {
         this.createGraphicEffect(localMuzzlePosition,turretMesh);
         this.createMuzzleLightEffect(localMuzzlePosition,turretMesh);
         this.createSoundEffect(turretMesh);
      }
      
      private function createGraphicEffect(localMuzzlePosition:Vector3, turretMesh:Mesh) : void
      {
      }
      
      private function createMuzzleLightEffect(localMuzzlePosition:Vector3, turretMesh:Mesh) : void
      {
         var lightEffect:AnimatedLightEffect = AnimatedLightEffect(objectPool.getObject(AnimatedLightEffect));
         var positionProvider:MuzzlePositionProvider = MuzzlePositionProvider(objectPool.getObject(MuzzlePositionProvider));
         positionProvider.init(turretMesh,localMuzzlePosition,0);
         lightEffect.init(positionProvider,this.muzzleLight);
         GameData.effects.addEffect(lightEffect);
      }
      
      private function createSoundEffect(turretMesh:Mesh) : void
      {
         if(shotSound == null)
         {
            shotSound = Assets.getData("plasma_shot",Sound);
         }
         var volume:Number = 0.8;
         var sound:Sound3D = Sound3D.create(shotSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.fyvilyv,volume);
         Utils3D.neputi.reset(turretMesh.x,turretMesh.y,turretMesh.z);
         soundManager.addEffect(Sound3DEffect.create(objectPool,Utils3D.neputi,sound));
      }
   }
}

