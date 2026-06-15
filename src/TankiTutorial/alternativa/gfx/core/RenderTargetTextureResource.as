package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import flash.display3D.Context3DTextureFormat;
   
   public class RenderTargetTextureResource extends TextureResource
   {
      
      private var cof:int;
      
      private var gugap:int;
      
      private var rubajam:Boolean = true;
      
      public function RenderTargetTextureResource(width:int, height:int)
      {
         super();
         this.cof = width;
         this.gugap = height;
      }
      
      public function get width() : int
      {
         return this.cof;
      }
      
      public function get height() : int
      {
         return this.gugap;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.rubajam = false;
      }
      
      override public function get available() : Boolean
      {
         return this.rubajam;
      }
      
      override §§namespace("http://alternativaplatform.com/en/alternativagfx") function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         tylu[stage3DIndex] = context.createTexture(this.cof,this.gugap,Context3DTextureFormat.BGRA,true);
      }
   }
}

