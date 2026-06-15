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
      
      private static var mohesefyw:Sound;
      
      private static const zaf:int = 10;
      
      public static const cumutobe:int = 120;
      
      private static const pyzarije:int = 50;
      
      private static const sakel:int = 50;
      
      private static const murow:ObjectPool = GameData.murow;
      
      private static const bijatil:ISoundManager = GameData.bijatil;
      
      public var qos:LightAnimation = LightData.soqi;
      
      public function PlasmaEffects()
      {
         super();
      }
      
      public function createShotEffects(param1:Mesh, param2:Vector3) : void
      {
         this.createGraphicEffect(param2,param1);
         this.createMuzzleLightEffect(param2,param1);
         this.createSoundEffect(param1);
      }
      
      private function createGraphicEffect(param1:Vector3, param2:Mesh) : void
      {
      }
      
      private function createMuzzleLightEffect(param1:Vector3, param2:Mesh) : void
      {
         var _loc3_:AnimatedLightEffect = AnimatedLightEffect(murow.getObject(AnimatedLightEffect));
         var _loc4_:MuzzlePositionProvider = MuzzlePositionProvider(murow.getObject(MuzzlePositionProvider));
         _loc4_.init(param2,param1,0);
         _loc3_.init(_loc4_,this.qos);
         GameData.hobuna.addEffect(_loc3_);
      }
      
      private function createSoundEffect(param1:Mesh) : void
      {
         if(mohesefyw == null)
         {
            mohesefyw = Assets.getData("plasma_shot",Sound);
         }
         var _loc2_:Number = 0.8;
         var _loc3_:Sound3D = Sound3D.create(mohesefyw,SoundOptions.suwyc,SoundOptions.bapewa,SoundOptions.fyvilyv,_loc2_);
         Utils3D.neputi.reset(param1.x,param1.y,param1.z);
         bijatil.addEffect(Sound3DEffect.create(murow,Utils3D.neputi,_loc3_));
      }
   }
}

