package alternativa.gfx.core
{
   import flash.geom.Rectangle;
   
   public class RenderState
   {
      
      public var sourceFactor:String = "one";
      
      public var destinationFactor:String = "zero";
      
      public var red:Boolean = true;
      
      public var green:Boolean = true;
      
      public var blue:Boolean = true;
      
      public var alpha:Boolean = true;
      
      public var triangleFaceToCull:String = "none";
      
      public var depthMask:Boolean = true;
      
      public var passCompareMode:String = "less";
      
      public var program:ProgramResource = null;
      
      public var texture:TextureResource = null;
      
      public var enableDepthAndStencil:Boolean = false;
      
      public var antiAlias:int = 0;
      
      public var surfaceSelector:int = 0;
      
      public var scissorEnabled:Boolean = false;
      
      public var scissorRectangle:Rectangle = new Rectangle();
      
      public var triangleFace:String = "frontAndBack";
      
      public var compareMode:String = "always";
      
      public var actionOnBothPass:String = "keep";
      
      public var actionOnDepthFail:String = "keep";
      
      public var actionOnDepthPassStencilFail:String = "keep";
      
      public var referenceValue:uint = 0;
      
      public var readMask:uint = 255;
      
      public var writeMask:uint = 255;
      
      public var textures:Vector.<TextureResource> = new Vector.<TextureResource>(8,true);
      
      public var vertexBuffers:Vector.<VertexBufferResource> = new Vector.<VertexBufferResource>(8,true);
      
      public var bufferOffsets:Vector.<int> = new Vector.<int>(8,true);
      
      public var formats:Vector.<String> = new Vector.<String>(8,true);
      
      public var vertexConstants:Vector.<Number> = new Vector.<Number>(128 * 4,true);
      
      public var fragmentConstants:Vector.<Number> = new Vector.<Number>(28 * 4,true);
      
      public function RenderState()
      {
         super();
      }
   }
}

