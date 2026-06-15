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
   
   [Event(name="context3DCreate",type="flash.events.Event")]
   public class Device extends EventDispatcher
   {
      
      private static const dapymat:String = "Resource is not available.";
      
      private static const horec:Vector.<Boolean> = Vector.<Boolean>([false,false,false,false]);
      
      private static const jewu:Vector.<int> = Vector.<int>([-1,-1,-1,-1]);
      
      private var tejijezaq:Stage;
      
      private var vivu:int;
      
      private var pyjic:String;
      
      private var qyvaququ:String;
      
      private var zyzafyg:int;
      
      private var rogu:int;
      
      private var cof:int;
      
      private var gugap:int;
      
      private var pucel:int;
      
      private var cowativi:Boolean;
      
      private var pypop:Boolean;
      
      private var habyvem:Stage3D;
      
      private var ruw:int = -1;
      
      private var rubajam:Boolean = true;
      
      private var dasybi:RenderState = new RenderState();
      
      private var wofew:Boolean = false;
      
      private var pepitoso:int = -1;
      
      private var jegicakof:int = -1;
      
      private var fide:int = -1;
      
      private var zoje:Boolean = false;
      
      private var legyj:Dictionary = new Dictionary();
      
      public function Device(stage:Stage, stage3DIndex:int = 0, renderMode:String = "auto", profile:String = "baseline")
      {
         super();
         if(stage3DIndex < 0 || stage3DIndex >= stage.stage3Ds.length)
         {
            throw new Error("Invalid index.");
         }
         if(horec[stage3DIndex])
         {
            throw new Error("Index already used.");
         }
         this.tejijezaq = stage;
         this.vivu = stage3DIndex;
         this.pyjic = renderMode;
         this.qyvaququ = profile;
         horec[this.vivu] = true;
         this.habyvem = this.tejijezaq.stage3Ds[this.vivu];
         this.zyzafyg = this.habyvem.x;
         this.rogu = this.habyvem.y;
         this.cof = stage.stageWidth;
         this.gugap = stage.stageHeight;
         this.pucel = 0;
         this.cowativi = true;
         this.pypop = false;
         this.habyvem.addEventListener(Event.CONTEXT3D_CREATE,this.onContext3DCreate);
         if(this.habyvem.requestContext3D.length > 1)
         {
            this.habyvem.requestContext3D(renderMode,profile);
         }
         else
         {
            this.habyvem.requestContext3D(renderMode);
         }
      }
      
      private function onContext3DCreate(e:Event) : void
      {
         var key:* = undefined;
         var texture:TextureResource = null;
         var vertexBuffer:VertexBufferResource = null;
         ++jewu[this.vivu];
         this.ruw = jewu[this.vivu];
         this.wofew = false;
         this.pepitoso = -1;
         this.jegicakof = -1;
         this.fide = -1;
         this.zoje = false;
         var context:Context3D = this.habyvem.context3D;
         context.enableErrorChecking = this.pypop;
         for(key in this.legyj)
         {
            this.uploadResource(key);
            delete this.legyj[key];
         }
         context.setBlendFactors(this.dasybi.wipiby,this.dasybi.koj);
         context.setColorMask(this.dasybi.jyjogo,this.dasybi.qebubo,this.dasybi.cevib,this.dasybi.bolilequ);
         context.setCulling(this.dasybi.qihe);
         context.setDepthTest(this.dasybi.tukoweti,this.dasybi.cuki);
         if(this.dasybi.topodizok != null)
         {
            if(!this.dasybi.topodizok.available)
            {
               throw new Error(dapymat);
            }
            this.prepareResource(context,this.dasybi.topodizok);
            context.setProgram(this.dasybi.topodizok.tecemyl[this.vivu]);
         }
         if(this.dasybi.wucukyj != null)
         {
            if(!this.dasybi.wucukyj.available)
            {
               throw new Error(dapymat);
            }
            this.prepareResource(context,this.dasybi.wucukyj);
            context.setRenderToTexture(this.dasybi.wucukyj.tylu[this.vivu],this.dasybi.gewoz,this.dasybi.tefug,this.dasybi.qapi);
         }
         if(this.dasybi.ficobavam)
         {
            context.setScissorRectangle(this.dasybi.rugakyr);
         }
         else
         {
            context.setScissorRectangle(null);
         }
         context.setStencilActions(this.dasybi.woq,this.dasybi.gugi,this.dasybi.qegop,this.dasybi.kerepiluh,this.dasybi.mokufyr);
         context.setStencilReferenceValue(this.dasybi.bavavove,this.dasybi.bohyha,this.dasybi.libywarer);
         for(var i:int = 0; i < 8; i++)
         {
            texture = this.dasybi.tylu[i];
            if(texture != null)
            {
               if(!texture.available)
               {
                  throw new Error(dapymat);
               }
               this.prepareResource(context,texture);
               context.setTextureAt(i,texture.tylu[this.vivu]);
            }
            vertexBuffer = this.dasybi.kewyv[i];
            if(vertexBuffer != null)
            {
               if(!vertexBuffer.available)
               {
                  throw new Error(dapymat);
               }
               this.prepareResource(context,vertexBuffer);
               context.setVertexBufferAt(i,vertexBuffer.putiwyfa[this.vivu],this.dasybi.qumovi[i],this.dasybi.totuqo[i]);
            }
         }
         context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,this.dasybi.badoh,128);
         context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.dasybi.befyjut,28);
         dispatchEvent(new Event(Event.CONTEXT3D_CREATE));
      }
      
      public function dispose() : void
      {
         var key:* = undefined;
         this.habyvem.removeEventListener(Event.CONTEXT3D_CREATE,this.onContext3DCreate);
         if(this.habyvem.context3D != null)
         {
            this.habyvem.context3D.dispose();
         }
         horec[this.vivu] = false;
         for(key in this.legyj)
         {
            delete this.legyj[key];
         }
         this.dasybi = new RenderState();
         this.rubajam = false;
      }
      
      public function reset() : void
      {
         var _loc1_:* = undefined;
         if(this.habyvem.context3D != null)
         {
            this.habyvem.context3D.dispose();
         }
         else
         {
            for(_loc1_ in this.legyj)
            {
               delete this.legyj[_loc1_];
            }
         }
         this.dasybi = new RenderState();
      }
      
      public function get available() : Boolean
      {
         return this.rubajam;
      }
      
      public function get ready() : Boolean
      {
         return this.habyvem.context3D != null;
      }
      
      public function get stage() : Stage
      {
         return this.tejijezaq;
      }
      
      public function get stage3DIndex() : int
      {
         return this.vivu;
      }
      
      public function get context3DId() : int
      {
         return this.ruw;
      }
      
      public function get renderMode() : String
      {
         return this.pyjic;
      }
      
      public function get profile() : String
      {
         return this.qyvaququ;
      }
      
      public function get x() : int
      {
         return this.zyzafyg;
      }
      
      public function set x(value:int) : void
      {
         this.zyzafyg = value;
      }
      
      public function get y() : int
      {
         return this.rogu;
      }
      
      public function set y(value:int) : void
      {
         this.rogu = value;
      }
      
      public function get width() : int
      {
         return this.cof;
      }
      
      public function set width(value:int) : void
      {
         this.cof = value;
      }
      
      public function get height() : int
      {
         return this.gugap;
      }
      
      public function set height(value:int) : void
      {
         this.gugap = value;
      }
      
      public function get antiAlias() : int
      {
         return this.pucel;
      }
      
      public function set antiAlias(value:int) : void
      {
         if(value != 0 && value != 2 && value != 4 && value != 16)
         {
            throw new Error("Invalid antialiasing value.");
         }
         this.pucel = value;
      }
      
      public function get enableDepthAndStencil() : Boolean
      {
         return this.cowativi;
      }
      
      public function set enableDepthAndStencil(value:Boolean) : void
      {
         this.cowativi = value;
      }
      
      public function get enableErrorChecking() : Boolean
      {
         return this.pypop;
      }
      
      public function set enableErrorChecking(value:Boolean) : void
      {
         this.pypop = value;
         var context:Context3D = this.habyvem.context3D;
         if(context != null && context.enableErrorChecking != this.pypop)
         {
            context.enableErrorChecking = this.pypop;
         }
      }
      
      public function uploadResource(resource:Resource) : void
      {
         if(!resource.available)
         {
            throw new Error(dapymat);
         }
         var context:Context3D = this.habyvem.context3D;
         if(context != null)
         {
            if(resource.jewu[this.vivu] != this.ruw)
            {
               resource.jewu[this.vivu] = this.ruw;
               resource.create(context,this.vivu);
            }
            resource.upload(this.vivu);
         }
         else
         {
            this.legyj[resource] = true;
         }
      }
      
      private function prepareResource(context:Context3D, resource:Resource) : void
      {
         if(resource.jewu[this.vivu] != this.ruw)
         {
            resource.jewu[this.vivu] = this.ruw;
            resource.create(context,this.vivu);
            resource.upload(this.vivu);
         }
      }
      
      public function setBlendFactors(sourceFactor:String, destinationFactor:String) : void
      {
         var context:Context3D = null;
         if(sourceFactor != this.dasybi.wipiby || destinationFactor != this.dasybi.koj)
         {
            this.dasybi.wipiby = sourceFactor;
            this.dasybi.koj = destinationFactor;
            context = this.habyvem.context3D;
            if(context != null)
            {
               context.setBlendFactors(sourceFactor,destinationFactor);
            }
         }
      }
      
      public function setColorMask(red:Boolean, green:Boolean, blue:Boolean, alpha:Boolean) : void
      {
         var context:Context3D = null;
         if(red != this.dasybi.jyjogo || green != this.dasybi.qebubo || blue != this.dasybi.cevib || alpha != this.dasybi.bolilequ)
         {
            this.dasybi.jyjogo = red;
            this.dasybi.qebubo = green;
            this.dasybi.cevib = blue;
            this.dasybi.bolilequ = alpha;
            context = this.habyvem.context3D;
            if(context != null)
            {
               context.setColorMask(red,green,blue,alpha);
            }
         }
      }
      
      public function setCulling(triangleFaceToCull:String) : void
      {
         var context:Context3D = null;
         if(triangleFaceToCull != this.dasybi.qihe)
         {
            this.dasybi.qihe = triangleFaceToCull;
            context = this.habyvem.context3D;
            if(context != null)
            {
               context.setCulling(triangleFaceToCull);
            }
         }
      }
      
      public function setDepthTest(depthMask:Boolean, passCompareMode:String) : void
      {
         var context:Context3D = null;
         if(depthMask != this.dasybi.tukoweti || passCompareMode != this.dasybi.cuki)
         {
            this.dasybi.tukoweti = depthMask;
            this.dasybi.cuki = passCompareMode;
            context = this.habyvem.context3D;
            if(context != null)
            {
               context.setDepthTest(depthMask,passCompareMode);
            }
         }
      }
      
      public function setProgram(program:ProgramResource) : void
      {
         var context:Context3D = null;
         if(program != this.dasybi.topodizok)
         {
            if(!program.available)
            {
               throw new Error(dapymat);
            }
            this.dasybi.topodizok = program;
            context = this.habyvem.context3D;
            if(context != null)
            {
               this.prepareResource(context,program);
               context.setProgram(program.tecemyl[this.vivu]);
            }
         }
      }
      
      public function setRenderToBackBuffer() : void
      {
         var context:Context3D = null;
         if(this.dasybi.wucukyj != null)
         {
            this.dasybi.wucukyj = null;
            context = this.habyvem.context3D;
            if(context != null)
            {
               context.setRenderToBackBuffer();
            }
         }
      }
      
      public function setRenderToTexture(texture:TextureResource, enableDepthAndStencil:Boolean = false, antiAlias:int = 0, surfaceSelector:int = 0) : void
      {
         var context:Context3D = null;
         if(texture != this.dasybi.wucukyj || enableDepthAndStencil != this.dasybi.gewoz || antiAlias != this.dasybi.tefug || surfaceSelector != this.dasybi.qapi)
         {
            if(texture != null && !texture.available)
            {
               throw new Error(dapymat);
            }
            this.dasybi.wucukyj = texture;
            this.dasybi.gewoz = enableDepthAndStencil;
            this.dasybi.tefug = antiAlias;
            this.dasybi.qapi = surfaceSelector;
            context = this.habyvem.context3D;
            if(context != null)
            {
               if(texture != null)
               {
                  this.prepareResource(context,texture);
                  context.setRenderToTexture(texture.tylu[this.vivu],enableDepthAndStencil,antiAlias,surfaceSelector);
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
         var context:Context3D = this.habyvem.context3D;
         if(rectangle != null)
         {
            if(this.dasybi.ficobavam)
            {
               if(rectangle.x != this.dasybi.rugakyr.x || rectangle.y != this.dasybi.rugakyr.y || rectangle.width != this.dasybi.rugakyr.width || rectangle.height != this.dasybi.rugakyr.height)
               {
                  this.dasybi.rugakyr.x = rectangle.x;
                  this.dasybi.rugakyr.y = rectangle.y;
                  this.dasybi.rugakyr.width = rectangle.width;
                  this.dasybi.rugakyr.height = rectangle.height;
                  if(context != null)
                  {
                     context.setScissorRectangle(rectangle);
                  }
               }
            }
            else
            {
               this.dasybi.ficobavam = true;
               this.dasybi.rugakyr.x = rectangle.x;
               this.dasybi.rugakyr.y = rectangle.y;
               this.dasybi.rugakyr.width = rectangle.width;
               this.dasybi.rugakyr.height = rectangle.height;
               if(context != null)
               {
                  context.setScissorRectangle(rectangle);
               }
            }
         }
         else
         {
            this.dasybi.ficobavam = false;
            if(context != null)
            {
               context.setScissorRectangle(null);
            }
         }
      }
      
      public function setStencilActions(triangleFace:String = "frontAndBack", compareMode:String = "always", actionOnBothPass:String = "keep", actionOnDepthFail:String = "keep", actionOnDepthPassStencilFail:String = "keep") : void
      {
         var context:Context3D = null;
         if(triangleFace != this.dasybi.woq || compareMode != this.dasybi.gugi || actionOnBothPass != this.dasybi.qegop || actionOnDepthFail != this.dasybi.kerepiluh || actionOnDepthPassStencilFail != this.dasybi.mokufyr)
         {
            this.dasybi.woq = triangleFace;
            this.dasybi.gugi = compareMode;
            this.dasybi.qegop = actionOnBothPass;
            this.dasybi.kerepiluh = actionOnDepthFail;
            this.dasybi.mokufyr = actionOnDepthPassStencilFail;
            context = this.habyvem.context3D;
            if(context != null)
            {
               context.setStencilActions(triangleFace,compareMode,actionOnBothPass,actionOnDepthFail,actionOnDepthPassStencilFail);
            }
         }
      }
      
      public function setStencilReferenceValue(referenceValue:uint, readMask:uint = 255, writeMask:uint = 255) : void
      {
         var context:Context3D = null;
         if(referenceValue != this.dasybi.bavavove || readMask != this.dasybi.bohyha || writeMask != this.dasybi.libywarer)
         {
            this.dasybi.bavavove = referenceValue;
            this.dasybi.bohyha = readMask;
            this.dasybi.libywarer = writeMask;
            context = this.habyvem.context3D;
            if(context != null)
            {
               context.setStencilReferenceValue(referenceValue,readMask,writeMask);
            }
         }
      }
      
      public function setTextureAt(sampler:int, texture:TextureResource) : void
      {
         var context:Context3D = null;
         if(texture != this.dasybi.tylu[sampler])
         {
            if(texture != null && !texture.available)
            {
               throw new Error(dapymat);
            }
            this.dasybi.tylu[sampler] = texture;
            context = this.habyvem.context3D;
            if(context != null)
            {
               if(texture != null)
               {
                  this.prepareResource(context,texture);
                  context.setTextureAt(sampler,texture.tylu[this.vivu]);
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
         if(buffer != this.dasybi.kewyv[index] || bufferOffset != this.dasybi.qumovi[index] || format != this.dasybi.totuqo[index])
         {
            if(buffer != null && !buffer.available)
            {
               throw new Error(dapymat);
            }
            this.dasybi.kewyv[index] = buffer;
            this.dasybi.qumovi[index] = bufferOffset;
            this.dasybi.totuqo[index] = format;
            context = this.habyvem.context3D;
            if(context != null)
            {
               if(buffer != null)
               {
                  this.prepareResource(context,buffer);
                  context.setVertexBufferAt(index,buffer.putiwyfa[this.vivu],bufferOffset,format);
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
         var constants:Vector.<Number> = programType == "vertex" ? this.dasybi.badoh : this.dasybi.befyjut;
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
               context = this.habyvem.context3D;
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
            context = this.habyvem.context3D;
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
         var context:Context3D = this.habyvem.context3D;
         if(context != null)
         {
            if(!this.wofew)
            {
               if(this.qyvaququ == "baselineConstrained")
               {
                  cx = this.zyzafyg;
                  cy = this.rogu;
                  cw = this.cof;
                  ch = this.gugap;
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
                  if(cx != this.habyvem.x || cy != this.habyvem.y || cw != this.pepitoso || ch != this.jegicakof || this.cowativi != this.zoje)
                  {
                     context.configureBackBuffer(50,50,0,this.cowativi);
                     this.habyvem.x = cx;
                     this.habyvem.y = cy;
                     context.configureBackBuffer(cw,ch,0,this.cowativi);
                     this.pepitoso = cw;
                     this.jegicakof = ch;
                     this.fide = this.pucel;
                     this.zoje = this.cowativi;
                  }
               }
               else
               {
                  if(this.habyvem.x != this.zyzafyg)
                  {
                     this.habyvem.x = this.zyzafyg;
                  }
                  if(this.habyvem.y != this.rogu)
                  {
                     this.habyvem.y = this.rogu;
                  }
                  if(this.cof != this.pepitoso || this.gugap != this.jegicakof || this.pucel != this.fide || this.cowativi != this.zoje)
                  {
                     context.configureBackBuffer(this.cof,this.gugap,this.pucel,this.cowativi);
                     this.pepitoso = this.cof;
                     this.jegicakof = this.gugap;
                     this.fide = this.pucel;
                     this.zoje = this.cowativi;
                  }
               }
               this.wofew = true;
            }
            context.clear(red,green,blue,alpha,depth,stencil,mask);
         }
      }
      
      public function drawToBitmapData(destination:BitmapData) : void
      {
         var context:Context3D = this.habyvem.context3D;
         if(context != null)
         {
            context.drawToBitmapData(destination);
         }
      }
      
      public function drawTriangles(indexBuffer:IndexBufferResource, firstIndex:int = 0, numTriangles:int = -1) : void
      {
         if(!indexBuffer.available)
         {
            throw new Error(dapymat);
         }
         var context:Context3D = this.habyvem.context3D;
         if(context != null)
         {
            this.prepareResource(context,indexBuffer);
            context.drawTriangles(indexBuffer.putiwyfa[this.vivu],firstIndex,numTriangles);
         }
      }
      
      public function present() : void
      {
         this.dasybi.wucukyj = null;
         var context:Context3D = this.habyvem.context3D;
         if(context != null)
         {
            context.present();
         }
         this.wofew = false;
      }
   }
}

