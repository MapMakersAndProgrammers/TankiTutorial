package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.textures.Texture;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class CompressedTextureResource extends TextureResource
   {
      
      private var qaso:ByteArray;
      
      private var cof:int;
      
      private var gugap:int;
      
      public function CompressedTextureResource(byteArray:ByteArray)
      {
         super();
         this.qaso = byteArray;
         this.qaso.endian = Endian.LITTLE_ENDIAN;
         this.qaso.position = 7;
         this.cof = 1 << this.qaso.readByte();
         this.gugap = 1 << this.qaso.readByte();
         this.qaso.position = 0;
      }
      
      public function get byteArray() : ByteArray
      {
         return this.qaso;
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
         this.qaso = null;
         this.cof = 0;
         this.gugap = 0;
      }
      
      override public function get available() : Boolean
      {
         return this.qaso != null;
      }
      
      override §§namespace("http://alternativaplatform.com/en/alternativagfx") function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         tylu[stage3DIndex] = context.createTexture(this.cof,this.gugap,Context3DTextureFormat.COMPRESSED,false);
      }
      
      override §§namespace("http://alternativaplatform.com/en/alternativagfx") function upload(stage3DIndex:int) : void
      {
         super.upload(stage3DIndex);
         Texture(tylu[stage3DIndex]).uploadCompressedTextureFromByteArray(this.qaso,0);
      }
   }
}

