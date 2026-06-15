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
      
      private static const migeru:int = 20;
      
      private static const zesim:int = 2000;
      
      private static const jelymy:Number = 1;
      
      private static const buwy:int = 100;
      
      private static const buku:int = 300;
      
      private var murow:ObjectPool = GameData.murow;
      
      private var hobuna:EffectsManager = GameData.hobuna;
      
      private var bijatil:ISoundManager = GameData.bijatil;
      
      private var range:Number;
      
      private var mopojuk:Number;
      
      private var dymojes:StreamWeaponSFXData;
      
      private var kologak:StreamWeaponGraphicEffect;
      
      private var tyzysala:MobileSound3DEffect;
      
      private var gagez:OmniStreamLightEffect;
      
      private var veliqe:OmniStreamLightEffect;
      
      public function FlamethrowerEffects(param1:Number, param2:Number, param3:StreamWeaponSFXData)
      {
         super();
         this.range = param1;
         this.mopojuk = param2;
         this.dymojes = param3;
      }
      
      public function startEffects(param1:Body, param2:Vector3, param3:Mesh) : void
      {
         var _loc4_:Sound3D = null;
         var _loc5_:MuzzlePositionProvider = null;
         var _loc6_:CollisionObject3DPositionProvider = null;
         var _loc7_:StreamWeaponParticlesPositionProvider = null;
         if(this.kologak == null)
         {
            this.kologak = StreamWeaponGraphicEffect(this.murow.getObject(StreamWeaponGraphicEffect));
            this.kologak.init(param1,this.range,this.mopojuk,FlamethrowerEffectsParams.zesim,param2,param3,this.dymojes,GameData.gov.kymaqos,FlamethrowerEffectsParams.qezizyj,FlamethrowerEffectsParams.kykihyf,FlamethrowerEffectsParams.vip,FlamethrowerEffectsParams.colarac,FlamethrowerEffectsParams.coteci,FlamethrowerEffectsParams.tasimep);
            this.hobuna.addEffect(this.kologak);
            _loc4_ = Sound3D.create(this.dymojes.mutovudi,SoundOptions.suwyc,SoundOptions.bapewa,SoundOptions.fyvilyv,FlamethrowerEffectsParams.jelymy);
            if(_loc4_ != null)
            {
               this.tyzysala = MobileSound3DEffect(this.murow.getObject(MobileSound3DEffect));
               this.tyzysala.init(_loc4_,param3,0,2);
               this.bijatil.addEffect(this.tyzysala);
            }
            this.gagez = OmniStreamLightEffect(this.murow.getObject(OmniStreamLightEffect));
            _loc5_ = MuzzlePositionProvider(this.murow.getObject(MuzzlePositionProvider));
            _loc5_.init(param3,param2,0);
            this.gagez.init(_loc5_,this.dymojes.puvulo,this.dymojes.div);
            this.hobuna.addEffect(this.gagez);
            this.veliqe = OmniStreamLightEffect(this.murow.getObject(OmniStreamLightEffect));
            _loc6_ = CollisionObject3DPositionProvider(this.murow.getObject(CollisionObject3DPositionProvider));
            _loc6_.init(param3,param2,GameData.gov.kymaqos,FlamethrowerEffectsParams.zowoma);
            _loc7_ = StreamWeaponParticlesPositionProvider(this.murow.getObject(StreamWeaponParticlesPositionProvider));
            _loc7_.init(this.kologak,_loc6_);
            this.veliqe.init(_loc7_,this.dymojes.jebiq,this.dymojes.defuhusyq);
            this.hobuna.addEffect(this.veliqe);
         }
      }
      
      public function stopEffects() : void
      {
         if(this.kologak != null)
         {
            this.kologak.kill();
            this.kologak = null;
         }
         if(Boolean(this.tyzysala))
         {
            this.tyzysala.kill();
            this.tyzysala = null;
         }
         if(Boolean(this.gagez))
         {
            this.gagez.stop();
            this.gagez = null;
         }
         if(this.veliqe != null)
         {
            this.veliqe.stop();
            this.veliqe = null;
         }
      }
   }
}

