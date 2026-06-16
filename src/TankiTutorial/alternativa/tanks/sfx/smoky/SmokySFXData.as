package alternativa.tanks.sfx.smoky
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import flash.media.Sound;
   import alternativa.tanks.sfx.dosu;
   import alternativa.tanks.sfx.LightData;
   import alternativa.tanks.sfx.virah;
   import tutorial.commons.Assets;
   
   public class SmokySFXData
   {
      
      public var pasinavuj:TextureMaterial;
      
      public var zabe:dosu;
      
      public var dodywytuq:TextureMaterial;
      
      public var kopefus:Sound;
      
      public var lyrydab:Sound;
      
      public var quf:virah = LightData.defajykeb;
      
      public var zucezu:virah = LightData.bevevy;
      
      private var qokohywyl:Boolean;
      
      public function SmokySFXData()
      {
         super();
      }
      
      public function init() : void
      {
         this.zabe = Assets.getData("smoky_explosion",dosu);
         this.pasinavuj = new TextureMaterial(Assets.getData("smoky_shot",BitmapData),false,true,MipMapping.PER_PIXEL,2.5);
         this.lyrydab = Assets.getData("smoky_explosion",Sound);
         this.kopefus = Assets.getData("smoky_shot",Sound);
         this.qokohywyl = true;
      }
      
      public function get isReady() : Boolean
      {
         return this.qokohywyl;
      }
   }
}

