package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import flash.display3D.Context3DTextureFormat;
   import alternativa.gfx.alternativagfx;
   
   use namespace alternativagfx;

   public class RenderTargetTextureResource extends TextureResource
   {
      
      private var _width:int;
      
      private var _height:int;
      
      private var _available:Boolean = true;
      
      public function RenderTargetTextureResource(width:int, height:int)
      {
         super();
         this._width = width;
         this._height = height;
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
         this._available = false;
      }
      
      override public function get available() : Boolean
      {
         return this._available;
      }
      
      override alternativagfx function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         textures[stage3DIndex] = context.createTexture(this._width,this._height,Context3DTextureFormat.BGRA,true);
      }
   }
}

