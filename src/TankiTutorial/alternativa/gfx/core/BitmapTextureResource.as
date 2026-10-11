package alternativa.gfx.core
{
   import flash.display.BitmapData;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.textures.Texture;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import alternativa.gfx.alternativagfx;
   
   use namespace alternativagfx;

   public class BitmapTextureResource extends TextureResource
   {
      
      private static const destPoint:Point = new Point();
      
      private static const sourceRect:Rectangle = new Rectangle();
      
      private static const matrix:Matrix = new Matrix();
      
      private var _bitmapData:BitmapData;
      
      private var _mipMapping:Boolean;
      
      private var _stretchNotPowerOf2Textures:Boolean;
      
      private var _calculateMipMapsUsingGPU:Boolean;
      
      private var _correctionU:Number = 1;
      
      private var _correctionV:Number = 1;
      
      private var textureWidth:int;
      
      private var textureHeight:int;
      
      public function BitmapTextureResource(bitmapData:BitmapData, mipMapping:Boolean, stretchNotPowerOf2Textures:Boolean = false, calculateMipMapsUsingGPU:Boolean = false)
      {
         super();
         this._bitmapData = bitmapData;
         this._mipMapping = mipMapping;
         this._stretchNotPowerOf2Textures = stretchNotPowerOf2Textures;
         this._calculateMipMapsUsingGPU = calculateMipMapsUsingGPU;
         this.textureWidth = Math.pow(2,Math.ceil(Math.log(this._bitmapData.width) / Math.LN2));
         this.textureHeight = Math.pow(2,Math.ceil(Math.log(this._bitmapData.height) / Math.LN2));
         if(this.textureWidth > 2048)
         {
            this.textureWidth = 2048;
         }
         if(this.textureHeight > 2048)
         {
            this.textureHeight = 2048;
         }
         if((this._bitmapData.width != this.textureWidth || this._bitmapData.height != this.textureHeight) && !this._stretchNotPowerOf2Textures && this._bitmapData.width <= 2048 && this._bitmapData.height <= 2048)
         {
            this._correctionU = this._bitmapData.width / this.textureWidth;
            this._correctionV = this._bitmapData.height / this.textureHeight;
         }
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
      
      public function get mipMapping() : Boolean
      {
         return this._mipMapping;
      }
      
      public function get stretchNotPowerOf2Textures() : Boolean
      {
         return this._stretchNotPowerOf2Textures;
      }
      
      public function get correctionU() : Number
      {
         return this._correctionU;
      }
      
      public function get correctionV() : Number
      {
         return this._correctionV;
      }
      
      public function get calculateMipMapsUsingGPU() : Boolean
      {
         return this._calculateMipMapsUsingGPU;
      }
      
      public function set calculateMipMapsUsingGPU(value:Boolean) : void
      {
         this._calculateMipMapsUsingGPU = value;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this._bitmapData = null;
      }
      
      override public function get available() : Boolean
      {
         return this._bitmapData != null;
      }
      
      override alternativagfx function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         textures[stage3DIndex] = context.createTexture(this.textureWidth,this.textureHeight,Context3DTextureFormat.BGRA,false);
      }
      
      override alternativagfx function upload(stage3DIndex:int) : void
      {
         var source:BitmapData = null;
         var pix:BitmapData = null;
         var level:int = 0;
         var width:int = 0;
         var height:int = 0;
         var bmp:BitmapData = null;
         super.upload(stage3DIndex);
         if(this._bitmapData.width == this.textureWidth && this._bitmapData.height == this.textureHeight)
         {
            source = this._bitmapData;
         }
         else
         {
            source = new BitmapData(this.textureWidth,this.textureHeight,this._bitmapData.transparent,0);
            if(this._bitmapData.width <= 2048 && this._bitmapData.height <= 2048 && !this._stretchNotPowerOf2Textures)
            {
               source.copyPixels(this._bitmapData,this._bitmapData.rect,destPoint);
               if(this._bitmapData.width < source.width)
               {
                  pix = new BitmapData(1,this._bitmapData.height,this._bitmapData.transparent,0);
                  sourceRect.setTo(this._bitmapData.width - 1,0,1,this._bitmapData.height);
                  pix.copyPixels(this._bitmapData,sourceRect,destPoint);
                  matrix.setTo(source.width - this._bitmapData.width,0,0,1,this._bitmapData.width,0);
                  source.draw(pix,matrix,null,null,null,false);
                  pix.dispose();
               }
               if(this._bitmapData.height < source.height)
               {
                  pix = new BitmapData(this._bitmapData.width,1,this._bitmapData.transparent,0);
                  sourceRect.setTo(0,this._bitmapData.height - 1,this._bitmapData.width,1);
                  pix.copyPixels(this._bitmapData,sourceRect,destPoint);
                  matrix.setTo(1,0,0,source.height - this._bitmapData.height,0,this._bitmapData.height);
                  source.draw(pix,matrix,null,null,null,false);
                  pix.dispose();
               }
               if(this._bitmapData.width < source.width && this._bitmapData.height < source.height)
               {
                  pix = new BitmapData(1,1,this._bitmapData.transparent,0);
                  sourceRect.setTo(this._bitmapData.width - 1,this._bitmapData.height - 1,1,1);
                  pix.copyPixels(this._bitmapData,sourceRect,destPoint);
                  matrix.setTo(source.width - this._bitmapData.width,0,0,source.height - this._bitmapData.height,this._bitmapData.width,this._bitmapData.height);
                  source.draw(pix,matrix,null,null,null,false);
                  pix.dispose();
               }
            }
            else
            {
               matrix.setTo(this.textureWidth / this._bitmapData.width,0,0,this.textureHeight / this._bitmapData.height,0,0);
               source.draw(this._bitmapData,matrix,null,null,null,true);
            }
         }
         var texture:Texture = textures[stage3DIndex] as Texture;
         if(this._mipMapping > 0)
         {
            texture.uploadFromBitmapData(source,0);
            matrix.identity();
            level = 1;
            width = source.width;
            height = source.height;
            while(width % 2 == 0 || height % 2 == 0)
            {
               width >>= 1;
               height >>= 1;
               if(width == 0)
               {
                  width = 1;
               }
               if(height == 0)
               {
                  height = 1;
               }
               bmp = new BitmapData(width,height,source.transparent,0);
               matrix.a = width / source.width;
               matrix.d = height / source.height;
               bmp.draw(source,matrix,null,null,null,false);
               texture.uploadFromBitmapData(bmp,level++);
               bmp.dispose();
            }
         }
         else
         {
            texture.uploadFromBitmapData(source,0);
         }
         if(source != this._bitmapData)
         {
            source.dispose();
         }
      }
   }
}

