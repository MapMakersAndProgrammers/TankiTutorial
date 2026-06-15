package alternativa.tanks.sfx.flamethrower
{
   import alternativa.tanks.sfx.LightAnimation;
   import alternativa.tanks.sfx.LightData;
   import alternativa.tanks.sfx.TextureAnimation;
   import flash.media.Sound;
   
   public class StreamWeaponSFXData
   {
      
      public var qywyr:TextureAnimation;
      
      public var tazequd:TextureAnimation;
      
      public var mutovudi:Sound;
      
      public var qob:Vector.<ColorTransformEntry> = getColorTransforms();
      
      public var jowufeq:Vector.<ColorTransformEntry> = getColorTransforms();
      
      public var puvulo:LightAnimation = LightData.kozuk;
      
      public var div:LightAnimation = LightData.suho;
      
      public var jebiq:LightAnimation = LightData.qekar;
      
      public var defuhusyq:LightAnimation = LightData.wykalu;
      
      public function StreamWeaponSFXData()
      {
         super();
      }
      
      private static function getColorTransforms() : Vector.<ColorTransformEntry>
      {
         var _loc1_:Vector.<ColorTransformEntry> = new Vector.<ColorTransformEntry>();
         _loc1_.push(new ColorTransformEntry(1,1,1,1,100,150,100,0,0));
         _loc1_.push(new ColorTransformEntry(1,1,1,1,50,100,60,0,0.05));
         _loc1_.push(new ColorTransformEntry(1,1,1,1,100,100,40,0,0.1));
         _loc1_.push(new ColorTransformEntry(0.5,0.3,0.3,1,50,80,50,0,0.65));
         _loc1_.push(new ColorTransformEntry(0,0,0,1,50,50,50,0,0.75));
         _loc1_.push(new ColorTransformEntry(0,0,0,0,20,20,20,0,1));
         return _loc1_;
      }
   }
}

