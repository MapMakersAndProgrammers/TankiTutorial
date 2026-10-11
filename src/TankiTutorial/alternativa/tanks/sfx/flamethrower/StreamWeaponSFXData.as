package alternativa.tanks.sfx.flamethrower
{
   import alternativa.tanks.sfx.LightAnimation;
   import alternativa.tanks.sfx.LightData;
   import alternativa.tanks.sfx.TextureAnimation;
   import flash.media.Sound;
   
   public class StreamWeaponSFXData
   {
      
      public var particleAnimation:TextureAnimation;
      
      public var muzzleAnimation:TextureAnimation;
      
      public var flameSound:Sound;
      
      public var particleColorTransforms:Vector.<ColorTransformEntry> = getColorTransforms();
      
      public var muzzleColorTransforms:Vector.<ColorTransformEntry> = getColorTransforms();
      
      public var muzzleStartLight:LightAnimation = LightData.flameMuzzleStartLight;
      
      public var muzzleLoopLight:LightAnimation = LightData.flameMuzzleLoopLight;
      
      public var streamStartLight:LightAnimation = LightData.flameStreamStartLight;
      
      public var streamLoopLight:LightAnimation = LightData.flameStreamLoopLight;
      
      public function StreamWeaponSFXData()
      {
         super();
      }
      
      private static function getColorTransforms() : Vector.<ColorTransformEntry>
      {
         var colorTransforms:Vector.<ColorTransformEntry> = new Vector.<ColorTransformEntry>();
         colorTransforms.push(new ColorTransformEntry(1,1,1,1,100,150,100,0,0));
         colorTransforms.push(new ColorTransformEntry(1,1,1,1,50,100,60,0,0.05));
         colorTransforms.push(new ColorTransformEntry(1,1,1,1,100,100,40,0,0.1));
         colorTransforms.push(new ColorTransformEntry(0.5,0.3,0.3,1,50,80,50,0,0.65));
         colorTransforms.push(new ColorTransformEntry(0,0,0,1,50,50,50,0,0.75));
         colorTransforms.push(new ColorTransformEntry(0,0,0,0,20,20,20,0,1));
         return colorTransforms;
      }
   }
}

