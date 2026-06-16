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
      
      private static const rotybuc:Point = new Point();
      
      private static const sotiby:Rectangle = new Rectangle();
      
      private static const gijalatyt:Matrix = new Matrix();
      
      private var byfap:BitmapData;
      
      private var gyk:Boolean;
      
      private var nutiveqyg:Boolean;
      
      private var japir:Boolean;
      
      private var korody:Number = 1;
      
      private var diqez:Number = 1;
      
      private var req:int;
      
      private var vot:int;
      
      public function BitmapTextureResource(bitmapData:BitmapData, mipMapping:Boolean, stretchNotPowerOf2Textures:Boolean = false, calculateMipMapsUsingGPU:Boolean = false)
      {
         super();
         this.byfap = bitmapData;
         this.gyk = mipMapping;
         this.nutiveqyg = stretchNotPowerOf2Textures;
         this.japir = calculateMipMapsUsingGPU;
         this.req = Math.pow(2,Math.ceil(Math.log(this.byfap.width) / Math.LN2));
         this.vot = Math.pow(2,Math.ceil(Math.log(this.byfap.height) / Math.LN2));
         if(this.req > 2048)
         {
            this.req = 2048;
         }
         if(this.vot > 2048)
         {
            this.vot = 2048;
         }
         if((this.byfap.width != this.req || this.byfap.height != this.vot) && !this.nutiveqyg && this.byfap.width <= 2048 && this.byfap.height <= 2048)
         {
            this.korody = this.byfap.width / this.req;
            this.diqez = this.byfap.height / this.vot;
         }
      }
      
      public function get bitmapData() : BitmapData
      {
         return this.byfap;
      }
      
      public function get mipMapping() : Boolean
      {
         return this.gyk;
      }
      
      public function get stretchNotPowerOf2Textures() : Boolean
      {
         return this.nutiveqyg;
      }
      
      public function get correctionU() : Number
      {
         return this.korody;
      }
      
      public function get correctionV() : Number
      {
         return this.diqez;
      }
      
      public function get calculateMipMapsUsingGPU() : Boolean
      {
         return this.japir;
      }
      
      public function set calculateMipMapsUsingGPU(value:Boolean) : void
      {
         this.japir = value;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.byfap = null;
      }
      
      override public function get available() : Boolean
      {
         return this.byfap != null;
      }
      
      override alternativagfx function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         tylu[stage3DIndex] = context.createTexture(this.req,this.vot,Context3DTextureFormat.BGRA,false);
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
         if(this.byfap.width == this.req && this.byfap.height == this.vot)
         {
            source = this.byfap;
         }
         else
         {
            source = new BitmapData(this.req,this.vot,this.byfap.transparent,0);
            if(this.byfap.width <= 2048 && this.byfap.height <= 2048 && !this.nutiveqyg)
            {
               source.copyPixels(this.byfap,this.byfap.rect,rotybuc);
               if(this.byfap.width < source.width)
               {
                  pix = new BitmapData(1,this.byfap.height,this.byfap.transparent,0);
                  sotiby.setTo(this.byfap.width - 1,0,1,this.byfap.height);
                  pix.copyPixels(this.byfap,sotiby,rotybuc);
                  gijalatyt.setTo(source.width - this.byfap.width,0,0,1,this.byfap.width,0);
                  source.draw(pix,gijalatyt,null,null,null,false);
                  pix.dispose();
               }
               if(this.byfap.height < source.height)
               {
                  pix = new BitmapData(this.byfap.width,1,this.byfap.transparent,0);
                  sotiby.setTo(0,this.byfap.height - 1,this.byfap.width,1);
                  pix.copyPixels(this.byfap,sotiby,rotybuc);
                  gijalatyt.setTo(1,0,0,source.height - this.byfap.height,0,this.byfap.height);
                  source.draw(pix,gijalatyt,null,null,null,false);
                  pix.dispose();
               }
               if(this.byfap.width < source.width && this.byfap.height < source.height)
               {
                  pix = new BitmapData(1,1,this.byfap.transparent,0);
                  sotiby.setTo(this.byfap.width - 1,this.byfap.height - 1,1,1);
                  pix.copyPixels(this.byfap,sotiby,rotybuc);
                  gijalatyt.setTo(source.width - this.byfap.width,0,0,source.height - this.byfap.height,this.byfap.width,this.byfap.height);
                  source.draw(pix,gijalatyt,null,null,null,false);
                  pix.dispose();
               }
            }
            else
            {
               gijalatyt.setTo(this.req / this.byfap.width,0,0,this.vot / this.byfap.height,0,0);
               source.draw(this.byfap,gijalatyt,null,null,null,true);
            }
         }
         var texture:Texture = tylu[stage3DIndex] as Texture;
         if(this.gyk > 0)
         {
            texture.uploadFromBitmapData(source,0);
            gijalatyt.identity();
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
               gijalatyt.a = width / source.width;
               gijalatyt.d = height / source.height;
               bmp.draw(source,gijalatyt,null,null,null,false);
               texture.uploadFromBitmapData(bmp,level++);
               bmp.dispose();
            }
         }
         else
         {
            texture.uploadFromBitmapData(source,0);
         }
         if(source != this.byfap)
         {
            source.dispose();
         }
      }
   }
}

