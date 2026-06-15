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
      
      public static const tilubizy:Number = 900;
      
      private static const nydas:Number = 1;
      
      private static const qalibi:Number = 200;
      
      private static const podahypoc:int = 100;
      
      private static const naj:int = 100;
      
      private static const karymo:int = 30;
      
      private const bijatil:ISoundManager = GameData.bijatil;
      
      private const murow:ObjectPool = GameData.murow;
      
      private const hobuna:EffectsManager = GameData.hobuna;
      
      private var dymojes:SmokySFXData;
      
      public function SmokyEffects(param1:SmokySFXData)
      {
         super();
         this.dymojes = param1;
      }
      
      public function createShotEffects(param1:Vector3, param2:Mesh) : void
      {
         if(!this.dymojes.isReady)
         {
            this.dymojes.init();
         }
         this.createShotSoundEffect(param2);
         this.createMuzzleFlashEffect(param1,param2);
         this.createMuzzleFlashLightEffect(param1,param2);
      }
      
      private function createShotSoundEffect(param1:Mesh) : void
      {
         var _loc2_:Sound3D = Sound3D.create(this.dymojes.kopefus,SoundOptions.suwyc,SoundOptions.bapewa,SoundOptions.fyvilyv,nydas);
         this.bijatil.addEffect(Sound3DEffect.create(this.murow,new Vector3(param1.x,param1.y,param1.z),_loc2_));
      }
      
      private function createMuzzleFlashEffect(param1:Vector3, param2:Mesh) : void
      {
         var _loc3_:SmokyMuzzleFlashEffect = SmokyMuzzleFlashEffect(this.murow.getObject(SmokyMuzzleFlashEffect));
         _loc3_.init(param1,param2,this.dymojes.pasinavuj,podahypoc);
         this.hobuna.addEffect(_loc3_);
      }
      
      private function createMuzzleFlashLightEffect(param1:Vector3, param2:Mesh) : void
      {
         var _loc3_:AnimatedLightEffect = AnimatedLightEffect(this.murow.getObject(AnimatedLightEffect));
         var _loc4_:MuzzlePositionProvider = MuzzlePositionProvider(this.murow.getObject(MuzzlePositionProvider));
         _loc4_.init(param2,param1,0);
         _loc3_.init(_loc4_,this.dymojes.quf);
         this.hobuna.addEffect(_loc3_);
      }
      
      public function createExplosionEffects(param1:Vector3, param2:Number) : void
      {
         this.createExplosionSoundEffect(param1);
         this.createExplosionGraphicEffect(param1,param2);
         this.createExplosionLightEffect(param1);
      }
      
      private function createExplosionSoundEffect(param1:Vector3) : void
      {
         var _loc2_:Sound3D = Sound3D.create(this.dymojes.lyrydab,SoundOptions.suwyc,SoundOptions.bapewa,SoundOptions.fyvilyv,1);
         this.bijatil.addEffect(Sound3DEffect.create(this.murow,param1,_loc2_,naj));
      }
      
      private function createExplosionGraphicEffect(param1:Vector3, param2:Number) : void
      {
         var _loc3_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(this.murow.getObject(StaticObject3DPositionProvider));
         _loc3_.init(param1,qalibi);
         var _loc4_:AnimatedSpriteEffect = AnimatedSpriteEffect(this.murow.getObject(AnimatedSpriteEffect));
         var _loc5_:Number = tilubizy * param2;
         _loc4_.init(_loc5_,_loc5_,this.dymojes.zabe,0,karymo,_loc3_);
         this.hobuna.addEffect(_loc4_);
      }
      
      private function createExplosionLightEffect(param1:Vector3) : void
      {
         var _loc2_:AnimatedLightEffect = AnimatedLightEffect(this.murow.getObject(AnimatedLightEffect));
         var _loc3_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(this.murow.getObject(StaticObject3DPositionProvider));
         _loc3_.init(param1,qalibi);
         _loc2_.init(_loc3_,this.dymojes.zucezu);
         this.hobuna.addEffect(_loc2_);
      }
   }
}

