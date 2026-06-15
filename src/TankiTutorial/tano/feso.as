package tano
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import flash.media.Sound;
   import lycikehe.dosu;
   import lycikehe.vifyhysod;
   import lycikehe.virah;
   import tutorial.commons.Assets;
   
   public class feso
   {
      
      public var pasinavuj:TextureMaterial;
      
      public var zabe:dosu;
      
      public var dodywytuq:TextureMaterial;
      
      public var kopefus:Sound;
      
      public var lyrydab:Sound;
      
      public var quf:virah = vifyhysod.defajykeb;
      
      public var zucezu:virah = vifyhysod.bevevy;
      
      private var qokohywyl:Boolean;
      
      public function feso()
      {
         super();
      }
      
      public function cabor() : void
      {
         this.zabe = Assets.getData("smoky_explosion",dosu);
         this.pasinavuj = new TextureMaterial(Assets.getData("smoky_shot",BitmapData),false,true,MipMapping.PER_PIXEL,2.5);
         this.lyrydab = Assets.getData("smoky_explosion",Sound);
         this.kopefus = Assets.getData("smoky_shot",Sound);
         this.qokohywyl = true;
      }
      
      public function get cafopik() : Boolean
      {
         return this.qokohywyl;
      }
   }
}

