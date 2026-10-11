package alternativa.tanks.sfx.smoky
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import flash.media.Sound;
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.sfx.LightData;
   import alternativa.tanks.sfx.LightAnimation;
   import tutorial.commons.Assets;
   
   public class SmokySFXData
   {
      
      public var shotMaterial:TextureMaterial;
      
      public var explosionAnimation:TextureAnimation;
      
      public var dodywytuq:TextureMaterial;
      
      public var shotSound:Sound;
      
      public var explosionSound:Sound;
      
      public var shotLight:LightAnimation = LightData.smokyShotLight;
      
      public var explosionLight:LightAnimation = LightData.smokyExplosionLight;
      
      private var _isReady:Boolean;
      
      public function SmokySFXData()
      {
         super();
      }
      
      public function init() : void
      {
         this.explosionAnimation = Assets.getData("smoky_explosion",TextureAnimation);
         this.shotMaterial = new TextureMaterial(Assets.getData("smoky_shot",BitmapData),false,true,MipMapping.PER_PIXEL,2.5);
         this.explosionSound = Assets.getData("smoky_explosion",Sound);
         this.shotSound = Assets.getData("smoky_shot",Sound);
         this._isReady = true;
      }
      
      public function get isReady() : Boolean
      {
         return this._isReady;
      }
   }
}

