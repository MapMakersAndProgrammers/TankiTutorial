package alternativa.engine3d.materials
{
   import §5e§.§-!$§;
   import §5e§.§`c§;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import flash.display.BitmapData;
   
   use namespace alternativa3d;
   
   public class FillMaterial extends TextureMaterial
   {
      
      public var color:int;
      
      public var alpha:Number;
      
      public var lineThickness:Number;
      
      public var lineColor:int;
      
      public function FillMaterial(color:int = 8355711, alpha:Number = 1, lineThickness:Number = -1, lineColor:int = 16777215)
      {
         super();
         this.color = color;
         this.alpha = alpha;
         this.lineThickness = lineThickness;
         this.lineColor = lineColor;
         texture = new BitmapData(1,1,true,(alpha * 255 << 24) + color);
      }
      
      override alternativa3d function get transparent() : Boolean
      {
         return this.alpha < 1;
      }
      
      override public function clone() : Material
      {
         var res:FillMaterial = new FillMaterial(this.color,this.alpha,this.lineThickness,this.lineColor);
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override alternativa3d function drawOpaque(camera:Camera3D, vertexBuffer:§-!$§, indexBuffer:§`c§, firstIndex:int, numTriangles:int, object:Object3D) : void
      {
         var c:uint = (this.alpha * 255 << 24) + this.color;
         if(c != _texture.getPixel32(0,0))
         {
            _texture.setPixel32(0,0,c);
         }
         super.alternativa3d::drawOpaque(camera,vertexBuffer,indexBuffer,firstIndex,numTriangles,object);
      }
      
      override alternativa3d function drawTransparent(camera:Camera3D, list:Face, object:Object3D) : void
      {
         var c:uint = (this.alpha * 255 << 24) + this.color;
         if(c != _texture.getPixel32(0,0))
         {
            _texture.setPixel32(0,0,c);
         }
         super.alternativa3d::drawTransparent(camera,list,object);
      }
   }
}

