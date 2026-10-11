package alternativa.gfx.core
{
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.display.Stage3D;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DProgramType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import alternativa.gfx.alternativagfx;
   
   use namespace alternativagfx;

   [Event(name="context3DCreate",type="flash.events.Event")]
   public class Device extends EventDispatcher
   {
      
      private static const RESOURCE_NOT_AVAILABLE:String = "Resource is not available.";
      
      private static const usedStage3Ds:Vector.<Boolean> = Vector.<Boolean>([false,false,false,false]);
      
      private static const context3DIds:Vector.<int> = Vector.<int>([-1,-1,-1,-1]);
      
      private var _stage:Stage;
      
      private var _stage3DIndex:int;
      
      private var _renderMode:String;
      
      private var _profile:String;
      
      private var _x:int;
      
      private var _y:int;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _antiAlias:int;
      
      private var _enableDepthAndStencil:Boolean;
      
      private var _enableErrorChecking:Boolean;
      
      private var stage3D:Stage3D;
      
      private var _context3DId:int = -1;
      
      private var _available:Boolean = true;
      
      private var renderState:RenderState = new RenderState();
      
      private var configured:Boolean = false;
      
      private var backBufferWidth:int = -1;
      
      private var backBufferHeight:int = -1;
      
      private var backBufferAntiAlias:int = -1;
      
      private var backBufferEnableDepthAndStencil:Boolean = false;
      
      private var resourcesToUpload:Dictionary = new Dictionary();
      
      public function Device(stage:Stage, stage3DIndex:int = 0, renderMode:String = "auto", profile:String = "baseline")
      {
         super();
         if(stage3DIndex < 0 || stage3DIndex >= stage.stage3Ds.length)
         {
            throw new Error("Invalid index.");
         }
         if(usedStage3Ds[stage3DIndex])
         {
            throw new Error("Index already used.");
         }
         this._stage = stage;
         this._stage3DIndex = stage3DIndex;
         this._renderMode = renderMode;
         this._profile = profile;
         usedStage3Ds[this._stage3DIndex] = true;
         this.stage3D = this._stage.stage3Ds[this._stage3DIndex];
         this._x = this.stage3D.x;
         this._y = this.stage3D.y;
         this._width = stage.stageWidth;
         this._height = stage.stageHeight;
         this._antiAlias = 0;
         this._enableDepthAndStencil = true;
         this._enableErrorChecking = false;
         this.stage3D.addEventListener(Event.CONTEXT3D_CREATE,this.onContext3DCreate);
         if(this.stage3D.requestContext3D.length > 1)
         {
            this.stage3D.requestContext3D(renderMode,profile);
         }
         else
         {
            this.stage3D.requestContext3D(renderMode);
         }
      }
      
      private function onContext3DCreate(e:Event) : void
      {
         var key:* = undefined;
         var texture:TextureResource = null;
         var vertexBuffer:VertexBufferResource = null;
         ++context3DIds[this._stage3DIndex];
         this._context3DId = context3DIds[this._stage3DIndex];
         this.configured = false;
         this.backBufferWidth = -1;
         this.backBufferHeight = -1;
         this.backBufferAntiAlias = -1;
         this.backBufferEnableDepthAndStencil = false;
         var context:Context3D = this.stage3D.context3D;
         context.enableErrorChecking = this._enableErrorChecking;
         for(key in this.resourcesToUpload)
         {
            this.uploadResource(key);
            delete this.resourcesToUpload[key];
         }
         context.setBlendFactors(this.renderState.sourceFactor,this.renderState.destinationFactor);
         context.setColorMask(this.renderState.red,this.renderState.green,this.renderState.blue,this.renderState.alpha);
         context.setCulling(this.renderState.triangleFaceToCull);
         context.setDepthTest(this.renderState.depthMask,this.renderState.passCompareMode);
         if(this.renderState.program != null)
         {
            if(!this.renderState.program.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE);
            }
            this.prepareResource(context,this.renderState.program);
            context.setProgram(this.renderState.program.programs[this._stage3DIndex]);
         }
         if(this.renderState.texture != null)
         {
            if(!this.renderState.texture.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE);
            }
            this.prepareResource(context,this.renderState.texture);
            context.setRenderToTexture(this.renderState.texture.textures[this._stage3DIndex],this.renderState.enableDepthAndStencil,this.renderState.antiAlias,this.renderState.surfaceSelector);
         }
         if(this.renderState.scissorEnabled)
         {
            context.setScissorRectangle(this.renderState.scissorRectangle);
         }
         else
         {
            context.setScissorRectangle(null);
         }
         context.setStencilActions(this.renderState.triangleFace,this.renderState.compareMode,this.renderState.actionOnBothPass,this.renderState.actionOnDepthFail,this.renderState.actionOnDepthPassStencilFail);
         context.setStencilReferenceValue(this.renderState.referenceValue,this.renderState.readMask,this.renderState.writeMask);
         for(var i:int = 0; i < 8; i++)
         {
            texture = this.renderState.textures[i];
            if(texture != null)
            {
               if(!texture.available)
               {
                  throw new Error(RESOURCE_NOT_AVAILABLE);
               }
               this.prepareResource(context,texture);
               context.setTextureAt(i,texture.textures[this._stage3DIndex]);
            }
            vertexBuffer = this.renderState.vertexBuffers[i];
            if(vertexBuffer != null)
            {
               if(!vertexBuffer.available)
               {
                  throw new Error(RESOURCE_NOT_AVAILABLE);
               }
               this.prepareResource(context,vertexBuffer);
               context.setVertexBufferAt(i,vertexBuffer.buffers[this._stage3DIndex],this.renderState.bufferOffsets[i],this.renderState.formats[i]);
            }
         }
         context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,this.renderState.vertexConstants,128);
         context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.renderState.fragmentConstants,28);
         dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
      }
      
      public function dispose() : void
      {
         var key:* = undefined;
         this.stage3D.removeEventListener(Event.CONTEXT3D_CREATE,this.onContext3DCreate);
         if(this.stage3D.context3D != null)
         {
            this.stage3D.context3D.dispose();
         }
         usedStage3Ds[this._stage3DIndex] = false;
         for(key in this.resourcesToUpload)
         {
            delete this.resourcesToUpload[key];
         }
         this.renderState = new RenderState();
         this._available = false;
      }
      
      public function reset() : void
      {
         var key:* = undefined;
         if(this.stage3D.context3D != null)
         {
            this.stage3D.context3D.dispose();
         }
         else
         {
            for(key in this.resourcesToUpload)
            {
               delete this.resourcesToUpload[key];
            }
         }
         this.renderState = new RenderState();
      }
      
      public function get available() : Boolean
      {
         return this._available;
      }
      
      public function get ready() : Boolean
      {
         return this.stage3D.context3D != null;
      }
      
      public function get stage() : Stage
      {
         return this._stage;
      }
      
      public function get stage3DIndex() : int
      {
         return this._stage3DIndex;
      }
      
      public function get context3DId() : int
      {
         return this._context3DId;
      }
      
      public function get renderMode() : String
      {
         return this._renderMode;
      }
      
      public function get profile() : String
      {
         return this._profile;
      }
      
      public function get x() : int
      {
         return this._x;
      }
      
      public function set x(value:int) : void
      {
         this._x = value;
      }
      
      public function get y() : int
      {
         return this._y;
      }
      
      public function set y(value:int) : void
      {
         this._y = value;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function set width(value:int) : void
      {
         this._width = value;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function set height(value:int) : void
      {
         this._height = value;
      }
      
      public function get antiAlias() : int
      {
         return this._antiAlias;
      }
      
      public function set antiAlias(value:int) : void
      {
         if(value != 0 && value != 2 && value != 4 && value != 16)
         {
            throw new Error("Invalid antialiasing value.");
         }
         this._antiAlias = value;
      }
      
      public function get enableDepthAndStencil() : Boolean
      {
         return this._enableDepthAndStencil;
      }
      
      public function set enableDepthAndStencil(value:Boolean) : void
      {
         this._enableDepthAndStencil = value;
      }
      
      public function get enableErrorChecking() : Boolean
      {
         return this._enableErrorChecking;
      }
      
      public function set enableErrorChecking(value:Boolean) : void
      {
         this._enableErrorChecking = value;
         var context:Context3D = this.stage3D.context3D;
         if(context != null && context.enableErrorChecking != this._enableErrorChecking)
         {
            context.enableErrorChecking = this._enableErrorChecking;
         }
      }
      
      public function uploadResource(resource:Resource) : void
      {
         if(!resource.available)
         {
            throw new Error(RESOURCE_NOT_AVAILABLE);
         }
         var context:Context3D = this.stage3D.context3D;
         if(context != null)
         {
            if(resource.context3DIds[this._stage3DIndex] != this._context3DId)
            {
               resource.context3DIds[this._stage3DIndex] = this._context3DId;
               resource.create(context,this._stage3DIndex);
            }
            resource.upload(this._stage3DIndex);
         }
         else
         {
            this.resourcesToUpload[resource] = true;
         }
      }
      
      private function prepareResource(context:Context3D, resource:Resource) : void
      {
         if(resource.context3DIds[this._stage3DIndex] != this._context3DId)
         {
            resource.context3DIds[this._stage3DIndex] = this._context3DId;
            resource.create(context,this._stage3DIndex);
            resource.upload(this._stage3DIndex);
         }
      }
      
      public function setBlendFactors(sourceFactor:String, destinationFactor:String) : void
      {
         var context:Context3D = null;
         if(sourceFactor != this.renderState.sourceFactor || destinationFactor != this.renderState.destinationFactor)
         {
            this.renderState.sourceFactor = sourceFactor;
            this.renderState.destinationFactor = destinationFactor;
            context = this.stage3D.context3D;
            if(context != null)
            {
               context.setBlendFactors(sourceFactor,destinationFactor);
            }
         }
      }
      
      public function setColorMask(red:Boolean, green:Boolean, blue:Boolean, alpha:Boolean) : void
      {
         var context:Context3D = null;
         if(red != this.renderState.red || green != this.renderState.green || blue != this.renderState.blue || alpha != this.renderState.alpha)
         {
            this.renderState.red = red;
            this.renderState.green = green;
            this.renderState.blue = blue;
            this.renderState.alpha = alpha;
            context = this.stage3D.context3D;
            if(context != null)
            {
               context.setColorMask(red,green,blue,alpha);
            }
         }
      }
      
      public function setCulling(triangleFaceToCull:String) : void
      {
         var context:Context3D = null;
         if(triangleFaceToCull != this.renderState.triangleFaceToCull)
         {
            this.renderState.triangleFaceToCull = triangleFaceToCull;
            context = this.stage3D.context3D;
            if(context != null)
            {
               context.setCulling(triangleFaceToCull);
            }
         }
      }
      
      public function setDepthTest(depthMask:Boolean, passCompareMode:String) : void
      {
         var context:Context3D = null;
         if(depthMask != this.renderState.depthMask || passCompareMode != this.renderState.passCompareMode)
         {
            this.renderState.depthMask = depthMask;
            this.renderState.passCompareMode = passCompareMode;
            context = this.stage3D.context3D;
            if(context != null)
            {
               context.setDepthTest(depthMask,passCompareMode);
            }
         }
      }
      
      public function setProgram(program:ProgramResource) : void
      {
         var context:Context3D = null;
         if(program != this.renderState.program)
         {
            if(!program.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE);
            }
            this.renderState.program = program;
            context = this.stage3D.context3D;
            if(context != null)
            {
               this.prepareResource(context,program);
               context.setProgram(program.programs[this._stage3DIndex]);
            }
         }
      }
      
      public function setRenderToBackBuffer() : void
      {
         var context:Context3D = null;
         if(this.renderState.texture != null)
         {
            this.renderState.texture = null;
            context = this.stage3D.context3D;
            if(context != null)
            {
               context.setRenderToBackBuffer();
            }
         }
      }
      
      public function setRenderToTexture(texture:TextureResource, enableDepthAndStencil:Boolean = false, antiAlias:int = 0, surfaceSelector:int = 0) : void
      {
         var context:Context3D = null;
         if(texture != this.renderState.texture || enableDepthAndStencil != this.renderState.enableDepthAndStencil || antiAlias != this.renderState.antiAlias || surfaceSelector != this.renderState.surfaceSelector)
         {
            if(texture != null && !texture.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE);
            }
            this.renderState.texture = texture;
            this.renderState.enableDepthAndStencil = enableDepthAndStencil;
            this.renderState.antiAlias = antiAlias;
            this.renderState.surfaceSelector = surfaceSelector;
            context = this.stage3D.context3D;
            if(context != null)
            {
               if(texture != null)
               {
                  this.prepareResource(context,texture);
                  context.setRenderToTexture(texture.textures[this._stage3DIndex],enableDepthAndStencil,antiAlias,surfaceSelector);
               }
               else
               {
                  context.setRenderToBackBuffer();
               }
            }
         }
      }
      
      public function setScissorRectangle(rectangle:Rectangle) : void
      {
         var context:Context3D = this.stage3D.context3D;
         if(rectangle != null)
         {
            if(this.renderState.scissorEnabled)
            {
               if(rectangle.x != this.renderState.scissorRectangle.x || rectangle.y != this.renderState.scissorRectangle.y || rectangle.width != this.renderState.scissorRectangle.width || rectangle.height != this.renderState.scissorRectangle.height)
               {
                  this.renderState.scissorRectangle.x = rectangle.x;
                  this.renderState.scissorRectangle.y = rectangle.y;
                  this.renderState.scissorRectangle.width = rectangle.width;
                  this.renderState.scissorRectangle.height = rectangle.height;
                  if(context != null)
                  {
                     context.setScissorRectangle(rectangle);
                  }
               }
            }
            else
            {
               this.renderState.scissorEnabled = true;
               this.renderState.scissorRectangle.x = rectangle.x;
               this.renderState.scissorRectangle.y = rectangle.y;
               this.renderState.scissorRectangle.width = rectangle.width;
               this.renderState.scissorRectangle.height = rectangle.height;
               if(context != null)
               {
                  context.setScissorRectangle(rectangle);
               }
            }
         }
         else
         {
            this.renderState.scissorEnabled = false;
            if(context != null)
            {
               context.setScissorRectangle(null);
            }
         }
      }
      
      public function setStencilActions(triangleFace:String = "frontAndBack", compareMode:String = "always", actionOnBothPass:String = "keep", actionOnDepthFail:String = "keep", actionOnDepthPassStencilFail:String = "keep") : void
      {
         var context:Context3D = null;
         if(triangleFace != this.renderState.triangleFace || compareMode != this.renderState.compareMode || actionOnBothPass != this.renderState.actionOnBothPass || actionOnDepthFail != this.renderState.actionOnDepthFail || actionOnDepthPassStencilFail != this.renderState.actionOnDepthPassStencilFail)
         {
            this.renderState.triangleFace = triangleFace;
            this.renderState.compareMode = compareMode;
            this.renderState.actionOnBothPass = actionOnBothPass;
            this.renderState.actionOnDepthFail = actionOnDepthFail;
            this.renderState.actionOnDepthPassStencilFail = actionOnDepthPassStencilFail;
            context = this.stage3D.context3D;
            if(context != null)
            {
               context.setStencilActions(triangleFace,compareMode,actionOnBothPass,actionOnDepthFail,actionOnDepthPassStencilFail);
            }
         }
      }
      
      public function setStencilReferenceValue(referenceValue:uint, readMask:uint = 255, writeMask:uint = 255) : void
      {
         var context:Context3D = null;
         if(referenceValue != this.renderState.referenceValue || readMask != this.renderState.readMask || writeMask != this.renderState.writeMask)
         {
            this.renderState.referenceValue = referenceValue;
            this.renderState.readMask = readMask;
            this.renderState.writeMask = writeMask;
            context = this.stage3D.context3D;
            if(context != null)
            {
               context.setStencilReferenceValue(referenceValue,readMask,writeMask);
            }
         }
      }
      
      public function setTextureAt(sampler:int, texture:TextureResource) : void
      {
         var context:Context3D = null;
         if(texture != this.renderState.textures[sampler])
         {
            if(texture != null && !texture.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE);
            }
            this.renderState.textures[sampler] = texture;
            context = this.stage3D.context3D;
            if(context != null)
            {
               if(texture != null)
               {
                  this.prepareResource(context,texture);
                  context.setTextureAt(sampler,texture.textures[this._stage3DIndex]);
               }
               else
               {
                  context.setTextureAt(sampler,null);
               }
            }
         }
      }
      
      public function setVertexBufferAt(index:int, buffer:VertexBufferResource, bufferOffset:int = 0, format:String = "float4") : void
      {
         var context:Context3D = null;
         if(buffer != this.renderState.vertexBuffers[index] || bufferOffset != this.renderState.bufferOffsets[index] || format != this.renderState.formats[index])
         {
            if(buffer != null && !buffer.available)
            {
               throw new Error(RESOURCE_NOT_AVAILABLE);
            }
            this.renderState.vertexBuffers[index] = buffer;
            this.renderState.bufferOffsets[index] = bufferOffset;
            this.renderState.formats[index] = format;
            context = this.stage3D.context3D;
            if(context != null)
            {
               if(buffer != null)
               {
                  this.prepareResource(context,buffer);
                  context.setVertexBufferAt(index,buffer.buffers[this._stage3DIndex],bufferOffset,format);
               }
               else
               {
                  context.setVertexBufferAt(index,null);
               }
            }
         }
      }
      
      public function setProgramConstantsFromVector(programType:String, firstRegister:int, data:Vector.<Number>, numRegisters:int = -1, compare:Boolean = true) : void
      {
         var context:Context3D = null;
         var diff:Boolean = false;
         var val:Number = NaN;
         var i:int = 0;
         var j:int = firstRegister << 2;
         var count:int = numRegisters < 0 ? int(data.length) : numRegisters << 2;
         var constants:Vector.<Number> = programType == "vertex" ? this.renderState.vertexConstants : this.renderState.fragmentConstants;
         if(compare)
         {
            for(diff = false; i < count; )
            {
               val = data[i];
               if(val != constants[j])
               {
                  constants[j] = val;
                  diff = true;
               }
               i++;
               j++;
            }
            if(diff)
            {
               context = this.stage3D.context3D;
               if(context != null)
               {
                  context.setProgramConstantsFromVector(programType,firstRegister,data,numRegisters);
               }
            }
         }
         else
         {
            while(i < count)
            {
               constants[j] = data[i];
               i++;
               j++;
            }
            context = this.stage3D.context3D;
            if(context != null)
            {
               context.setProgramConstantsFromVector(programType,firstRegister,data,numRegisters);
            }
         }
      }
      
      public function clear(red:Number = 0, green:Number = 0, blue:Number = 0, alpha:Number = 1, depth:Number = 1, stencil:uint = 0, mask:uint = 4294967295) : void
      {
         var cx:int = 0;
         var cy:int = 0;
         var cw:int = 0;
         var ch:int = 0;
         var context:Context3D = this.stage3D.context3D;
         if(context != null)
         {
            if(!this.configured)
            {
               if(this._profile == "baselineConstrained")
               {
                  cx = this._x;
                  cy = this._y;
                  cw = this._width;
                  ch = this._height;
                  if(cx < 0)
                  {
                     cx = 0;
                  }
                  if(cy < 0)
                  {
                     cy = 0;
                  }
                  if(cx + cw > this.stage.stageWidth)
                  {
                     cw = this.stage.stageWidth - cx;
                  }
                  if(cy + ch > this.stage.stageHeight)
                  {
                     ch = this.stage.stageHeight - cy;
                  }
                  if(cx != this.stage3D.x || cy != this.stage3D.y || cw != this.backBufferWidth || ch != this.backBufferHeight || this._enableDepthAndStencil != this.backBufferEnableDepthAndStencil)
                  {
                     context.configureBackBuffer(50,50,0,this._enableDepthAndStencil);
                     this.stage3D.x = cx;
                     this.stage3D.y = cy;
                     context.configureBackBuffer(cw,ch,0,this._enableDepthAndStencil);
                     this.backBufferWidth = cw;
                     this.backBufferHeight = ch;
                     this.backBufferAntiAlias = this._antiAlias;
                     this.backBufferEnableDepthAndStencil = this._enableDepthAndStencil;
                  }
               }
               else
               {
                  if(this.stage3D.x != this._x)
                  {
                     this.stage3D.x = this._x;
                  }
                  if(this.stage3D.y != this._y)
                  {
                     this.stage3D.y = this._y;
                  }
                  if(this._width != this.backBufferWidth || this._height != this.backBufferHeight || this._antiAlias != this.backBufferAntiAlias || this._enableDepthAndStencil != this.backBufferEnableDepthAndStencil)
                  {
                     context.configureBackBuffer(this._width,this._height,this._antiAlias,this._enableDepthAndStencil);
                     this.backBufferWidth = this._width;
                     this.backBufferHeight = this._height;
                     this.backBufferAntiAlias = this._antiAlias;
                     this.backBufferEnableDepthAndStencil = this._enableDepthAndStencil;
                  }
               }
               this.configured = true;
            }
            context.clear(red,green,blue,alpha,depth,stencil,mask);
         }
      }
      
      public function drawToBitmapData(destination:BitmapData) : void
      {
         var context:Context3D = this.stage3D.context3D;
         if(context != null)
         {
            context.drawToBitmapData(destination);
         }
      }
      
      public function drawTriangles(indexBuffer:IndexBufferResource, firstIndex:int = 0, numTriangles:int = -1) : void
      {
         if(!indexBuffer.available)
         {
            throw new Error(RESOURCE_NOT_AVAILABLE);
         }
         var context:Context3D = this.stage3D.context3D;
         if(context != null)
         {
            this.prepareResource(context,indexBuffer);
            context.drawTriangles(indexBuffer.buffers[this._stage3DIndex],firstIndex,numTriangles);
         }
      }
      
      public function present() : void
      {
         this.renderState.texture = null;
         var context:Context3D = this.stage3D.context3D;
         if(context != null)
         {
            context.present();
         }
         this.configured = false;
      }
   }
}

