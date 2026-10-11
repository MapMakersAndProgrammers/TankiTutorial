package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.textures.Texture;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import alternativa.gfx.alternativagfx;
   
   use namespace alternativagfx;

   public class CompressedTextureResource extends TextureResource
   {
      
      private var _byteArray:ByteArray;
      
      private var _width:int;
      
      private var _height:int;
      
      public function CompressedTextureResource(byteArray:ByteArray)
      {
         super();
         this._byteArray = byteArray;
         this._byteArray.endian = Endian.LITTLE_ENDIAN;
         this._byteArray.position = 7;
         this._width = 1 << this._byteArray.readByte();
         this._height = 1 << this._byteArray.readByte();
         this._byteArray.position = 0;
      }
      
      public function get byteArray() : ByteArray
      {
         return this._byteArray;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._byteArray = null;
         this._width = 0;
         this._height = 0;
      }
      
      override public function get available() : Boolean
      {
         return this._byteArray != null;
      }
      
      override alternativagfx function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         textures[stage3DIndex] = context.createTexture(this._width,this._height,Context3DTextureFormat.COMPRESSED,false);
      }
      
      override alternativagfx function upload(stage3DIndex:int) : void
      {
         super.upload(stage3DIndex);
         Texture(textures[stage3DIndex]).uploadCompressedTextureFromByteArray(this._byteArray,0);
      }
   }
}

