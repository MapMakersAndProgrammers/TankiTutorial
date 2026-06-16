package alternativa.engine3d.materials
{
   import alternativa.gfx.core.BitmapTextureResource
   import alternativa.gfx.core.CompressedTextureResource;
   import alternativa.gfx.core.VertexBufferResource;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.ProgramResource;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.objects.SkyBox;
   import alternativa.engine3d.objects.Sprite3D;
   import flash.display.BitmapData;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class TextureMaterial extends Material
   {
      
      private static var vertexBuffer:VertexBufferResource;
      
      alternativa3d static var indexBuffer:IndexBufferResource;
      
      private static const offset:int = 14;
      
      private static const limit:int = 18;
      
      private static const constants:Vector.<Number> = new Vector.<Number>(limit * 3 * 2 * 4);
      
      private static const skyFogConst:Vector.<Number> = Vector.<Number>([0,0,0,1]);
      
      private static const softConst:Vector.<Number> = Vector.<Number>([0,0,0,255]);
      
      private static const correctionConst:Vector.<Number> = Vector.<Number>([0,0,0,1,0,0,0,1]);
      
      private static var programs:Array = new Array();
      
      public var diffuseMapURL:String;
      
      public var opacityMapURL:String;
      
      public var repeat:Boolean = false;
      
      public var smooth:Boolean = true;
      
      public var resolution:Number = 1;
      
      public var threshold:Number = 0.01;
      
      public var correctUV:Boolean = false;
      
      alternativa3d var _texture:BitmapData;
      
      alternativa3d var _textureATF:ByteArray;
      
      alternativa3d var _textureATFAlpha:ByteArray;
      
      alternativa3d var _mipMapping:int = 0;
      
      alternativa3d var _hardwareMipMaps:Boolean = false;
      
      alternativa3d var textureResource:BitmapTextureResource
      
      alternativa3d var textureATFResource:CompressedTextureResource;
      
      alternativa3d var textureATFAlphaResource:CompressedTextureResource;
      
      public function TextureMaterial(texture:BitmapData = null, repeat:Boolean = false, smooth:Boolean = true, mipMapping:int = 0, resolution:Number = 1)
      {
         var vertices:Vector.<Number> = null;
         var indices:Vector.<uint> = null;
         var count:int = 0;
         var i:int = 0;
         var j:int = 0;
         var index:int = 0;
         super();
         this._texture = texture;
         this.repeat = repeat;
         this.smooth = smooth;
         this._mipMapping = mipMapping;
         this.resolution = resolution;
         if(this._texture != null)
         {
            this.textureResource = new BitmapTextureResource(this._texture,this._mipMapping > 0,this.repeat,this._hardwareMipMaps);
         }
         if(vertexBuffer == null)
         {
            vertices = new Vector.<Number>();
            indices = new Vector.<uint>();
            count = limit * 3;
            for(i = 0; i < count; i++)
            {
               vertices.push((i << 1) + offset);
               indices.push(i);
            }
            for(j = 0; j < count << 1; j++)
            {
               index = j * 4 + 3;
               constants[index] = 1;
            }
            vertexBuffer = new VertexBufferResource(vertices,1);
            alternativa3d::indexBuffer = new IndexBufferResource(indices);
         }
      }
      
      public function get texture() : BitmapData
      {
         return this._texture;
      }
      
      public function set texture(value:BitmapData) : void
      {
         if(value != this._texture)
         {
            if(this._texture != null)
            {
               this.textureResource.dispose();
               this.textureResource = null;
            }
            this._texture = value;
            if(this._texture != null)
            {
               this.textureResource = new BitmapTextureResource(this._texture,this._mipMapping > 0,this.repeat,this._hardwareMipMaps);
            }
         }
      }
      
      public function get textureATF() : ByteArray
      {
         return this._textureATF;
      }
      
      public function set textureATF(value:ByteArray) : void
      {
         if(value != this._textureATF)
         {
            if(this._textureATF != null)
            {
               this.textureATFResource.dispose();
               this.textureATFResource = null;
            }
            this._textureATF = value;
            if(this._textureATF != null)
            {
               this.textureATFResource = new CompressedTextureResource(this._textureATF);
            }
         }
      }
      
      public function get textureATFAlpha() : ByteArray
      {
         return this._textureATFAlpha;
      }
      
      public function set textureATFAlpha(value:ByteArray) : void
      {
         if(value != this._textureATFAlpha)
         {
            if(this._textureATFAlpha != null)
            {
               this.textureATFAlphaResource.dispose();
               this.textureATFAlphaResource = null;
            }
            this._textureATFAlpha = value;
            if(this._textureATFAlpha != null)
            {
               this.textureATFAlphaResource = new CompressedTextureResource(this._textureATFAlpha);
            }
         }
      }
      
      public function get mipMapping() : int
      {
         return this._mipMapping;
      }
      
      public function set mipMapping(value:int) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         var changed:Boolean = this._mipMapping > 0 && value == 0 || this._mipMapping == 0 && value > 0;
         this._mipMapping = value;
         if(changed && this._texture != null)
         {
            this.textureResource.dispose();
            this.textureResource = new BitmapTextureResource(this._texture,this._mipMapping > 0,this.repeat,this._hardwareMipMaps);
         }
      }
      
      public function get hardwareMipMaps() : Boolean
      {
         return this._hardwareMipMaps;
      }
      
      public function set hardwareMipMaps(value:Boolean) : void
      {
         if(value != this._hardwareMipMaps)
         {
            this._hardwareMipMaps = value;
            if(this._texture != null)
            {
               this.textureResource.calculateMipMapsUsingGPU = this._hardwareMipMaps;
            }
         }
      }
      
      override public function clone() : Material
      {
         var res:TextureMaterial = new TextureMaterial(this._texture,this.repeat,this.smooth,this._mipMapping,this.resolution);
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Material) : void
      {
         super.clonePropertiesFrom(source);
         var src:TextureMaterial = source as TextureMaterial;
         this.diffuseMapURL = src.diffuseMapURL;
         this.opacityMapURL = src.opacityMapURL;
         this.threshold = src.threshold;
         this.correctUV = src.correctUV;
         this.textureATF = src.textureATF;
         this.textureATFAlpha = src.textureATFAlpha;
         this.hardwareMipMaps = src.hardwareMipMaps;
      }
      
      override alternativa3d function get transparent() : Boolean
      {
         if(this._texture != null)
         {
            return this._texture.transparent;
         }
         if(this._textureATF != null)
         {
            return this._textureATFAlpha != null;
         }
         return false;
      }
      
      override alternativa3d function drawOpaque(camera:Camera3D, vertexBuffer:VertexBufferResource, indexBuffer:IndexBufferResource, firstIndex:int, numTriangles:int, object:Object3D) : void
      {
         if(this._texture == null && this._textureATF == null)
         {
            return;
         }
         var device:Device = camera.device;
         var sky:Boolean = object is SkyBox && SkyBox(object).autoSize;
         var fog:Boolean = camera.fogAlpha > 0 && camera.fogStrength > 0;
         var cameraSsao:Boolean = !camera.view.constrained && camera.ssao && camera.ssaoStrength > 0;
         var ssao:Boolean = cameraSsao && object.useDepth && !sky;
         var direct:Boolean = !camera.view.constrained && camera.directionalLight != null && camera.directionalLightStrength > 0 && object.useLight && !sky;
         var cameraShadow:Boolean = !camera.view.constrained && camera.shadowMap != null && camera.shadowMapStrength > 0;
         var shadow:Boolean = cameraShadow && object.useLight && object.useShadowMap && !sky;
         var cameraLight:Boolean = !camera.view.constrained && camera.deferredLighting && camera.deferredLightingStrength > 0;
         var light:Boolean = cameraLight && object.useDepth && object.useLight && !sky;
         device.setProgram(this.getProgram(true,sky,false,false,camera.view.quality,this.repeat,this._mipMapping > 0,object.concatenatedColorTransform != null,false,fog,false,ssao,direct,shadow,this._texture == null,false,light,false,camera.view.correction));
         if(this._texture != null)
         {
            device.setTextureAt(0,this.textureResource);
            uvCorrection[0] = this.textureResource.correctionU;
            uvCorrection[1] = this.textureResource.correctionV;
         }
         else
         {
            device.setTextureAt(0,this.textureATFResource);
            uvCorrection[0] = 1;
            uvCorrection[1] = 1;
         }
         device.setVertexBufferAt(0,vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
         device.setVertexBufferAt(1,vertexBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
         device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,object.transformConst,3,false);
         device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,uvCorrection,1);
         if(!ssao && cameraSsao)
         {
            device.setTextureAt(1,null);
         }
         if(!shadow && cameraShadow)
         {
            device.setTextureAt(2,null);
            device.setTextureAt(3,null);
         }
         if(!light && cameraLight)
         {
            device.setTextureAt(5,null);
         }
         if(sky)
         {
            device.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
            device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,SkyBox(object).transform,1);
            if(fog)
            {
               skyFogConst[0] = camera.fogFragment[0] * camera.fogFragment[3];
               skyFogConst[1] = camera.fogFragment[1] * camera.fogFragment[3];
               skyFogConst[2] = camera.fogFragment[2] * camera.fogFragment[3];
               skyFogConst[3] = 1 - camera.fogFragment[3];
               device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,13,skyFogConst,1);
            }
         }
         if(direct)
         {
            device.setVertexBufferAt(2,vertexBuffer,5,Context3DVertexBufferFormat.FLOAT_3);
         }
         if(object.concatenatedColorTransform != null)
         {
            device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,object.colorConst,2,false);
         }
         device.drawTriangles(indexBuffer,firstIndex,numTriangles);
         if(sky)
         {
            device.setDepthTest(true,Context3DCompareMode.LESS);
         }
         if(direct)
         {
            device.setVertexBufferAt(2,null);
         }
         if(!ssao && cameraSsao)
         {
            device.setTextureAt(1,camera.depthMap);
         }
         if(!shadow && cameraShadow)
         {
            device.setTextureAt(2,camera.shadowMap.map);
            device.setTextureAt(3,camera.shadowMap.noise);
         }
         if(!light && cameraLight)
         {
            device.setTextureAt(5,camera.lightMap);
         }
         ++camera.numDraws;
         camera.numTriangles += numTriangles;
      }
      
      override alternativa3d function drawTransparent(camera:Camera3D, list:Face, object:Object3D) : void
      {
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var wrapper:Wrapper = null;
         var next:Face = null;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var bz:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var cz:Number = NaN;
         if(this._texture == null && this._textureATF == null)
         {
            clearLinks(list);
            return;
         }
         var ku:Number = 1;
         var kv:Number = 1;
         var device:Device = camera.device;
         var decal:Boolean = object is Decal;
         var asDecal:Boolean = !decal && name == "decal";
         var fog:Boolean = camera.fogAlpha > 0 && camera.fogStrength > 0;
         var sprite:Boolean = object is Sprite3D;
         var soft:Boolean = !camera.view.constrained && camera.softTransparency && camera.softTransparencyStrength > 0 && object.softAttenuation > 0 && !decal;
         var ssao:Boolean = !camera.view.constrained && camera.ssao && camera.ssaoStrength > 0 && object.useDepth;
         var direct:Boolean = !camera.view.constrained && camera.directionalLight != null && camera.directionalLightStrength > 0 && object.useLight;
         var cameraShadow:Boolean = !camera.view.constrained && camera.shadowMap != null && camera.shadowMapStrength > 0;
         var shadow:Boolean = cameraShadow && object.useLight && object.useShadowMap;
         var cameraLight:Boolean = !camera.view.constrained && camera.deferredLighting && camera.deferredLightingStrength > 0;
         var light:Boolean = cameraLight && object.useDepth && object.useLight && !sprite;
         var lightSprite:Boolean = cameraLight && sprite && object.useLight;
         device.setProgram(this.getProgram(false,false,decal || asDecal,sprite,camera.view.quality,this.repeat,this._mipMapping > 0,object.concatenatedColorTransform != null,object.concatenatedAlpha < 1,fog,soft,ssao,direct,shadow,this._texture == null,this._texture == null && this._textureATFAlpha != null,light,lightSprite,camera.view.correction));
         if(this._texture != null)
         {
            device.setTextureAt(0,this.textureResource);
            ku = this.textureResource.correctionU;
            kv = this.textureResource.correctionV;
         }
         else
         {
            device.setTextureAt(0,this.textureATFResource);
            if(this._textureATFAlpha != null)
            {
               device.setTextureAt(4,this.textureATFAlphaResource);
            }
         }
         device.setVertexBufferAt(0,vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_1);
         if(!soft && !ssao && camera.depthMap != null)
         {
            device.setTextureAt(1,null);
         }
         if(!shadow && cameraShadow)
         {
            device.setTextureAt(2,null);
            device.setTextureAt(3,null);
         }
         if(!light && cameraLight)
         {
            device.setTextureAt(5,null);
         }
         if(soft || ssao || light)
         {
            softConst[2] = object.softAttenuation * camera.softTransparencyStrength * 255 / camera.farClipping;
            device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,14,softConst,1);
         }
         if(decal)
         {
            correctionConst[0] = object.md * camera.correctionX;
            correctionConst[1] = object.mh * camera.correctionY;
            correctionConst[2] = object.ml;
            correctionConst[3] = camera.correctionX;
            correctionConst[4] = object.mc * camera.correctionX / Decal(object).attenuation;
            correctionConst[5] = object.mg * camera.correctionY / Decal(object).attenuation;
            correctionConst[6] = object.mk / Decal(object).attenuation;
            correctionConst[7] = camera.correctionY;
            device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,correctionConst,2,false);
         }
         else if(asDecal)
         {
            correctionConst[0] = 0;
            correctionConst[1] = 0;
            correctionConst[2] = 0;
            correctionConst[3] = camera.correctionX;
            correctionConst[4] = 0;
            correctionConst[5] = 0;
            correctionConst[6] = 0;
            correctionConst[7] = camera.correctionY;
            device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,correctionConst,2,false);
         }
         else if(sprite)
         {
            if(direct)
            {
               correctionConst[0] = -object.md * camera.correctionX;
               correctionConst[1] = -object.mh * camera.correctionY;
               correctionConst[2] = -object.ml;
               correctionConst[3] = camera.correctionX;
               correctionConst[6] = 0.5;
               correctionConst[7] = camera.correctionY;
               device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,11,correctionConst,2,false);
            }
            if(lightSprite)
            {
               device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,13,Sprite3D(object).lightConst,1,false);
            }
         }
         if(object.concatenatedColorTransform != null)
         {
            device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,object.colorConst,2,false);
         }
         else
         {
            device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,object.colorConst,1);
         }
         var counter:int = 0;
         var i:int = 0;
         if(direct && !sprite)
         {
            while(list != null)
            {
               next = list.processNext;
               list.processNext = null;
               wrapper = list.wrapper;
               a = wrapper.vertex;
               ax = a.normalX * object.ma + a.normalY * object.mb + a.normalZ * object.mc;
               ay = a.normalX * object.me + a.normalY * object.mf + a.normalZ * object.mg;
               az = a.normalX * object.mi + a.normalY * object.mj + a.normalZ * object.mk;
               wrapper = wrapper.next;
               b = wrapper.vertex;
               bx = b.normalX * object.ma + b.normalY * object.mb + b.normalZ * object.mc;
               by = b.normalX * object.me + b.normalY * object.mf + b.normalZ * object.mg;
               bz = b.normalX * object.mi + b.normalY * object.mj + b.normalZ * object.mk;
               for(wrapper = wrapper.next; wrapper != null; wrapper = wrapper.next)
               {
                  c = wrapper.vertex;
                  cx = c.normalX * object.ma + c.normalY * object.mb + c.normalZ * object.mc;
                  cy = c.normalX * object.me + c.normalY * object.mf + c.normalZ * object.mg;
                  cz = c.normalX * object.mi + c.normalY * object.mj + c.normalZ * object.mk;
                  if(counter >= limit)
                  {
                     device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,offset,constants,limit * 6,false);
                     device.drawTriangles(indexBuffer,0,counter);
                     counter = 0;
                     i = 0;
                     ++camera.numDraws;
                  }
                  constants[i] = a.cameraX;
                  i++;
                  constants[i] = a.cameraY;
                  i++;
                  constants[i] = a.cameraZ;
                  i++;
                  constants[i] = ax;
                  i++;
                  constants[i] = a.u * ku;
                  i++;
                  constants[i] = a.v * kv;
                  i++;
                  constants[i] = ay;
                  i++;
                  constants[i] = az;
                  i++;
                  constants[i] = b.cameraX;
                  i++;
                  constants[i] = b.cameraY;
                  i++;
                  constants[i] = b.cameraZ;
                  i++;
                  constants[i] = bx;
                  i++;
                  constants[i] = b.u * ku;
                  i++;
                  constants[i] = b.v * kv;
                  i++;
                  constants[i] = by;
                  i++;
                  constants[i] = bz;
                  i++;
                  constants[i] = c.cameraX;
                  i++;
                  constants[i] = c.cameraY;
                  i++;
                  constants[i] = c.cameraZ;
                  i++;
                  constants[i] = cx;
                  i++;
                  constants[i] = c.u * ku;
                  i++;
                  constants[i] = c.v * kv;
                  i++;
                  constants[i] = cy;
                  i++;
                  constants[i] = cz;
                  i++;
                  counter++;
                  b = c;
                  bx = cx;
                  by = cy;
                  bz = cz;
                  ++camera.numTriangles;
               }
               list = next;
            }
         }
         else
         {
            while(list != null)
            {
               next = list.processNext;
               list.processNext = null;
               wrapper = list.wrapper;
               a = wrapper.vertex;
               wrapper = wrapper.next;
               b = wrapper.vertex;
               for(wrapper = wrapper.next; wrapper != null; wrapper = wrapper.next)
               {
                  c = wrapper.vertex;
                  if(counter >= limit)
                  {
                     device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,offset,constants,limit * 6,false);
                     device.drawTriangles(indexBuffer,0,counter);
                     counter = 0;
                     i = 0;
                     ++camera.numDraws;
                  }
                  constants[i] = a.cameraX;
                  i++;
                  constants[i] = a.cameraY;
                  i++;
                  constants[i] = a.cameraZ;
                  i += 2;
                  constants[i] = a.u * ku;
                  i++;
                  constants[i] = a.v * kv;
                  i += 3;
                  constants[i] = b.cameraX;
                  i++;
                  constants[i] = b.cameraY;
                  i++;
                  constants[i] = b.cameraZ;
                  i += 2;
                  constants[i] = b.u * ku;
                  i++;
                  constants[i] = b.v * kv;
                  i += 3;
                  constants[i] = c.cameraX;
                  i++;
                  constants[i] = c.cameraY;
                  i++;
                  constants[i] = c.cameraZ;
                  i += 2;
                  constants[i] = c.u * ku;
                  i++;
                  constants[i] = c.v * kv;
                  i += 3;
                  counter++;
                  b = c;
                  ++camera.numTriangles;
               }
               list = next;
            }
         }
         if(counter > 0)
         {
            device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,offset,constants,counter * 6,false);
            device.drawTriangles(indexBuffer,0,counter);
            ++camera.numDraws;
         }
         if(this._texture == null && this._textureATFAlpha != null)
         {
            device.setTextureAt(4,null);
         }
         if(!soft && !ssao && camera.depthMap != null)
         {
            device.setTextureAt(1,camera.depthMap);
         }
         if(!shadow && cameraShadow)
         {
            device.setTextureAt(2,camera.shadowMap.map);
            device.setTextureAt(3,camera.shadowMap.noise);
         }
         if(!light && cameraLight)
         {
            device.setTextureAt(5,camera.lightMap);
         }
      }
      
      private function getProgram(opaque:Boolean, sky:Boolean, decal:Boolean, sprite:Boolean, quality:Boolean, repeat:Boolean, mip:Boolean, color:Boolean, alpha:Boolean, fog:Boolean, soft:Boolean, ssao:Boolean, direct:Boolean, shadow:Boolean, atf:Boolean, map:Boolean, light:Boolean, lightSprite:Boolean, correction:Boolean) : ProgramResource
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var key:int = int(opaque) | int(sky) << 1 | int(decal) << 2 | int(sprite) << 3 | int(quality) << 4 | int(repeat) << 5 | int(mip) << 6 | int(color) << 7 | int(alpha) << 8 | int(fog) << 9 | int(soft) << 10 | int(ssao) << 11 | int(direct) << 12 | int(shadow) << 13 | int(atf) << 14 | int(map) << 15 | int(light) << 16 | int(lightSprite) << 17 | int(correction) << 18;
         var program:ProgramResource = programs[key];
         if(program == null)
         {
            vertexProgram = compileProgram(Context3DProgramType.VERTEX,opaque ? (!sky ? ["dp4 vt0.x, va0, vc0","dp4 vt0.y, va0, vc1","dp4 vt0.z, va0, vc2","mov vt0.w, vc4.w","mov v2, vt0" + (!direct && !shadow && !ssao && !light ? "rem" : ""),"dp3 vt1.x, va2, vc0" + (!direct ? "rem" : ""),"dp3 vt1.y, va2, vc1" + (!direct ? "rem" : ""),"dp3 vt1.z, va2, vc2" + (!direct ? "rem" : ""),"dp3 vt1.w, vt1.xyz, vc10.xyz" + (!direct ? "rem" : ""),"sub v2.w, vc4.w, vt1.w" + (!direct ? "rem" : ""),"dp4 v3.x, vt0, vc6" + (!shadow ? "rem" : ""),"dp4 v3.y, vt0, vc7" + (!shadow ? "rem" : ""),"dp4 v3.z, vt0, vc8" + (!shadow ? "rem" : ""),"sub vt1.w, vt0.z, vc9.x" + (!shadow ? "rem" : ""),"div vt1.w, vt1.w, vc9.y" + (!shadow ? "rem" : ""),"sub v3.w, vc4.w, vt1.w" + (!shadow ? "rem" : ""),"mov v1.xyz, va0.w" + (!fog ? "rem" : ""),"sub vt0.w, vt0.z, vc5.z" + (!fog ? "rem" : ""),"div v1.w, vt0.w, vc5.w" + (!fog ? "rem" : ""),"mul vt0.xy, vt0.xy, vc13.xy" + (!correction ? "rem" : ""),"mul vt1.xy, vc13.zw, vt0.z" + (!correction ? "rem" : "")
            ,"add vt0.xy, vt0.xy, vt1.xy" + (!correction ? "rem" : ""),"mov op.xw, vt0.xz","neg op.y, vt0.y","mul vt0.z, vt0.z, vc3.z","add op.z, vt0.z, vc3.w","mul v0, va1, vc4"] : ["sub vt1.xyz, va0.xyz, vc11.xyz","mul vt1.xyz, vt1.xyz, vc11.w","add vt1.xyz, vt1.xyz, vc11.xyz","mov vt1.w, va0.w","dp4 vt0.x, vt1, vc0","dp4 vt0.y, vt1, vc1","dp4 vt0.z, vt1, vc2","mul vt0.xy, vt0.xy, vc13.xy" + (!correction ? "rem" : ""),"mul vt1.xy, vc13.zw, vt0.z" + (!correction ? "rem" : ""),"add vt0.xy, vt0.xy, vt1.xy" + (!correction ? "rem" : ""),"mov op.xw, vt0.xz","neg op.y, vt0.y","mul vt0.z, vt0.z, vc3.z","add op.z, vt0.z, vc3.w","mul v0, va1, vc4"]) : ["mov vt0, vc[va0.x]","mov vt0.w, vc3.y","mov v2, vt0" + (!direct && !shadow && !soft && !ssao && !light ? "rem" : ""),"mov vt1.x, vc[va0.x].w" + (!direct || sprite ? "rem" : ""),"mov vt1.y, vc[va0.x+1].z" + (!direct || sprite ? "rem" : ""),"mov vt1.z, vc[va0.x+1].w" + (!direct || sprite ? "rem" : ""),"mov vt1, vc11" + (!direct || !sprite ? "rem" : ""),"nrm vt1.xyz, vt1.xyz" + (!direct || !sprite ? "rem" : "")
            ,"div vt1.x, vt1.x, vc11.w" + (!direct || !sprite ? "rem" : ""),"div vt1.y, vt1.y, vc12.w" + (!direct || !sprite ? "rem" : ""),"dp3 vt1.w, vt1.xyz, vc10.xyz" + (!direct ? "rem" : ""),"sub v2.w, vc3.y, vt1.w" + (!direct || sprite ? "rem" : ""),"sub vt1.w, vc3.y, vt1.w" + (!direct || !sprite ? "rem" : ""),"mul v2.w, vt1.w, vc12.z" + (!direct || !sprite ? "rem" : ""),"dp4 v3.x, vt0, vc6" + (!shadow ? "rem" : ""),"dp4 v3.y, vt0, vc7" + (!shadow ? "rem" : ""),"dp4 v3.z, vt0, vc8" + (!shadow ? "rem" : ""),"sub vt1.w, vt0.z, vc9.x" + (!shadow ? "rem" : ""),"div vt1.w, vt1.w, vc9.y" + (!shadow ? "rem" : ""),"sub v3.w, vc9.w, vt1.w" + (!shadow ? "rem" : ""),"mul vt2.x, vt0.x, vc11.w" + (!decal ? "rem" : ""),"mul vt2.y, vt0.y, vc12.w" + (!decal ? "rem" : ""),"mov vt2.z, vt0.z" + (!decal ? "rem" : ""),"sub vt2.xyz, vt2.xyz, vc11.xyz" + (!decal ? "rem" : ""),"dp3 v0.z, vt2.xyz, vc12.xyz" + (!decal ? "rem" : ""),"mov v0.w, vc3.y" + (!decal ? "rem" : ""),"mov v1.xyz, vc5.x" + (!fog ? "rem" : ""),"sub vt0.w, vt0.z, vc5.z" + (!fog ? "rem" : "")
            ,"div v1.w, vt0.w, vc5.w" + (!fog ? "rem" : ""),"div vt1.z, vc3.w, vt0.z" + (!decal ? "rem" : ""),"add vt1.z, vt1.z, vc3.z" + (!decal ? "rem" : ""),"mul vt1.z, vt1.z, vc3.x" + (!decal ? "rem" : ""),"sub vt1.z, vt1.z, vc3.y" + (!decal ? "rem" : ""),"div vt1.z, vt1.z, vc3.x" + (!decal ? "rem" : ""),"sub vt1.z, vt1.z, vc3.z" + (!decal ? "rem" : ""),"div vt1.z, vc3.w, vt1.z" + (!decal ? "rem" : ""),"nrm vt2.xyz, vt0.xyz" + (!decal ? "rem" : ""),"sub vt1.z, vt0.z, vt1.z" + (!decal ? "rem" : ""),"div vt1.z, vt1.z, vt2.z" + (!decal ? "rem" : ""),"mul vt2.xyz, vt2.xyz, vt1.z" + (!decal ? "rem" : ""),"sub vt0.xyz, vt0.xyz, vt2.xyz" + (!decal ? "rem" : ""),"mul vt0.xy, vt0.xy, vc13.xy" + (!correction ? "rem" : ""),"mul vt1.xy, vc13.zw, vt0.z" + (!correction ? "rem" : ""),"add vt0.xy, vt0.xy, vt1.xy" + (!correction ? "rem" : ""),"mov op.xw, vt0.xz","neg op.y, vt0.y","mul vt0.z, vt0.z, vc3.z","add op.z, vt0.z, vc3.w","mov v0, vc[va0.x+1]" + (decal ? "rem" : ""),"mov v0.xy, vc[va0.x+1].xy" + (!decal ? "rem" : "")]);
            fragmentProgram = compileProgram(Context3DProgramType.FRAGMENT,["tex ft0, v0, fs0 <2d," + (repeat ? "wrap" : "clamp") + "," + (quality ? "linear," : "nearest,") + (mip ? (quality ? "miplinear" : "mipnearest") : "mipnone") + (atf ? ",dxt1" : "") + ">","tex ft1, v0, fs4 <2d," + (repeat ? "wrap" : "clamp") + "," + (quality ? "linear," : "nearest,") + (mip ? (quality ? "miplinear" : "mipnearest") : "mipnone") + (atf ? ",dxt1" : "") + ">" + (!map ? "rem" : ""),"mov ft0.w, ft1.x" + (!map ? "rem" : ""),"add ft4.w, ft0.w, fc0.x" + (opaque || map ? "rem" : (color ? "rem" : "")),"add ft4.w, ft0.w, fc1.w" + (opaque || map ? "rem" : (!color ? "rem" : "")),"div ft0.xyz, ft0.xyz, ft4.w" + (opaque || map ? "rem" : ""),"mul ft0.xyz, ft0.xyz, fc0.xyz" + (!color ? "rem" : ""),"add ft0.xyz, ft0.xyz, fc1.xyz" + (!color ? "rem" : ""),"mul ft0.w, ft0.w, fc0.w" + (!alpha ? "rem" : ""),"div ft1.xy, v2.xy, v2.z" + (!soft && !ssao && !light ? "rem" : ""),"mul ft1.xy, ft1.xy, fc4.w" + (!soft && !ssao && !light ? "rem" : "")
            ,"add ft1.xy, ft1.xy, fc4.w" + (!soft && !ssao && !light ? "rem" : ""),"mul ft3.xy, ft1.xy, fc4.xy" + (!soft && !ssao && !light ? "rem" : ""),"mul ft3.z, v2.z, fc4.z" + (!soft && !ssao && !light ? "rem" : ""),"mov ft3.w, v2.z" + (!soft && !ssao && !light ? "rem" : ""),"tex ft1, ft3, fs1 <2d,clamp,nearest,mipnone>" + (!soft && !ssao ? "rem" : ""),"tex ft6, ft3, fs5 <2d,clamp,nearest,mipnone>" + (!light ? "rem" : ""),"mul ft2.z, ft1.x, fc14.w" + (!soft ? "rem" : ""),"add ft2.z, ft2.z, ft1.y" + (!soft ? "rem" : ""),"sub ft2.w, ft2.z, ft3.z" + (!soft ? "rem" : ""),"abs ft2.w, ft2.w" + (!soft ? "rem" : ""),"div ft2.w, ft2.w, fc14.z" + (!soft ? "rem" : ""),"sat ft2.w, ft2.w" + (!soft ? "rem" : ""),"mul ft0.w, ft0.w, ft2.w" + (!soft ? "rem" : ""),"mul ft2.xyz, fc12.xyz, ft1.w" + (!ssao ? "rem" : ""),"sub ft2.xyz, fc12.w, ft2.xyz" + (!ssao ? "rem" : ""),"mul ft0.xyz, ft0.xyz, ft2.xyz" + (!ssao ? "rem" : ""),"abs ft1.w, v0.z" + (!decal ? "rem" : ""),"sat ft1.w, ft1.w" + (!decal ? "rem" : ""),"sub ft1.w, v0.w, ft1.w" + (!decal ? "rem" : "")
            ,"mul ft0.w, ft0.w, ft1.w" + (!decal ? "rem" : ""),"mov ft5, fc5" + (!shadow ? "rem" : ""),"sub ft1.z, v3.z, fc6.z" + (!shadow ? "rem" : ""),"mul ft5.z, ft5.z, ft1.z" + (!shadow ? "rem" : ""),"div ft1, v2, v2.z" + (!shadow ? "rem" : ""),"mul ft1.xy, ft1.xy, fc7.z" + (!shadow ? "rem" : ""),"add ft1.xy, ft1.xy, fc7.z" + (!shadow ? "rem" : ""),"mul ft1.xy, ft1.xy, fc7.xy" + (!shadow ? "rem" : ""),"tex ft1, ft1, fs3 <2d,wrap,nearest,mipnone>" + (!shadow ? "rem" : ""),"mul ft2.x, ft1.z, fc6.x" + (!shadow ? "rem" : ""),"sub ft2.y, ft1.z, ft1.z" + (!shadow ? "rem" : ""),"mov ft2.zw, ft1.zw" + (!shadow ? "rem" : ""),"mul ft3.x, ft2.x, ft1.y" + (!shadow ? "rem" : ""),"mul ft3.y, ft2.y, ft1.x" + (!shadow ? "rem" : ""),"mul ft3.z, ft2.y, ft1.y" + (!shadow ? "rem" : ""),"mul ft3.w, ft2.x, ft1.x" + (!shadow ? "rem" : ""),"add ft2.x, ft3.x, ft3.y" + (!shadow ? "rem" : ""),"add ft2.y, ft3.z, ft3.w" + (!shadow ? "rem" : ""),"add ft3, ft2, v3" + (!shadow ? "rem" : ""),"tex ft1, ft3, fs2 <2d,clamp,nearest,mipnone>" + (!shadow ? "rem" : "")
            ,"dp3 ft2.z, ft1, ft5" + (!shadow ? "rem" : ""),"sat ft2.z, ft2.z" + (!shadow ? "rem" : ""),"mov ft4.z, ft2.z" + (!shadow ? "rem" : ""),"dp3 ft3.x, ft2, fc8" + (!shadow ? "rem" : ""),"dp3 ft3.y, ft2, fc9" + (!shadow ? "rem" : ""),"mov ft2, ft3" + (!shadow ? "rem" : ""),"add ft3, ft2, v3" + (!shadow ? "rem" : ""),"tex ft1, ft3, fs2 <2d,clamp,nearest,mipnone>" + (!shadow ? "rem" : ""),"dp3 ft2.z, ft1, ft5" + (!shadow ? "rem" : ""),"sat ft2.z, ft2.z" + (!shadow ? "rem" : ""),"add ft4.z, ft4.z, ft2.z" + (!shadow ? "rem" : ""),"dp3 ft3.x, ft2, fc8" + (!shadow ? "rem" : ""),"dp3 ft3.y, ft2, fc9" + (!shadow ? "rem" : ""),"mov ft2, ft3" + (!shadow ? "rem" : ""),"add ft3, ft2, v3" + (!shadow ? "rem" : ""),"tex ft1, ft3, fs2 <2d,clamp,nearest,mipnone>" + (!shadow ? "rem" : ""),"dp3 ft2.z, ft1, ft5" + (!shadow ? "rem" : ""),"sat ft2.z, ft2.z" + (!shadow ? "rem" : ""),"add ft4.z, ft4.z, ft2.z" + (!shadow ? "rem" : ""),"dp3 ft3.x, ft2, fc8" + (!shadow ? "rem" : ""),"dp3 ft3.y, ft2, fc9" + (!shadow ? "rem" : "")
            ,"mov ft2, ft3" + (!shadow ? "rem" : ""),"add ft3, ft2, v3" + (!shadow ? "rem" : ""),"tex ft1, ft3, fs2 <2d,clamp,nearest,mipnone>" + (!shadow ? "rem" : ""),"dp3 ft2.z, ft1, ft5" + (!shadow ? "rem" : ""),"sat ft2.z, ft2.z" + (!shadow ? "rem" : ""),"add ft4.z, ft4.z, ft2.z" + (!shadow ? "rem" : ""),"dp3 ft3.x, ft2, fc8" + (!shadow ? "rem" : ""),"dp3 ft3.y, ft2, fc9" + (!shadow ? "rem" : ""),"mov ft2, ft3" + (!shadow ? "rem" : ""),"add ft3, ft2, v3" + (!shadow ? "rem" : ""),"tex ft1, ft3, fs2 <2d,clamp,nearest,mipnone>" + (!shadow ? "rem" : ""),"dp3 ft2.z, ft1, ft5" + (!shadow ? "rem" : ""),"sat ft2.z, ft2.z" + (!shadow ? "rem" : ""),"add ft4.z, ft4.z, ft2.z" + (!shadow ? "rem" : ""),"dp3 ft3.x, ft2, fc8" + (!shadow ? "rem" : ""),"dp3 ft3.y, ft2, fc9" + (!shadow ? "rem" : ""),"mov ft2, ft3" + (!shadow ? "rem" : ""),"add ft3, ft2, v3" + (!shadow ? "rem" : ""),"tex ft1, ft3, fs2 <2d,clamp,nearest,mipnone>" + (!shadow ? "rem" : ""),"dp3 ft2.z, ft1, ft5" + (!shadow ? "rem" : ""),"sat ft2.z, ft2.z" + (!shadow ? "rem" : "")
            ,"add ft4.z, ft4.z, ft2.z" + (!shadow ? "rem" : ""),"dp3 ft3.x, ft2, fc8" + (!shadow ? "rem" : ""),"dp3 ft3.y, ft2, fc9" + (!shadow ? "rem" : ""),"mov ft2, ft3" + (!shadow ? "rem" : ""),"add ft3, ft2, v3" + (!shadow ? "rem" : ""),"tex ft1, ft3, fs2 <2d,clamp,nearest,mipnone>" + (!shadow ? "rem" : ""),"dp3 ft2.z, ft1, ft5" + (!shadow ? "rem" : ""),"sat ft2.z, ft2.z" + (!shadow ? "rem" : ""),"add ft4.z, ft4.z, ft2.z" + (!shadow ? "rem" : ""),"dp3 ft3.x, ft2, fc8" + (!shadow ? "rem" : ""),"dp3 ft3.y, ft2, fc9" + (!shadow ? "rem" : ""),"mov ft2, ft3" + (!shadow ? "rem" : ""),"add ft3, ft2, v3" + (!shadow ? "rem" : ""),"tex ft1, ft3, fs2 <2d,clamp,nearest,mipnone>" + (!shadow ? "rem" : ""),"dp3 ft2.z, ft1, ft5" + (!shadow ? "rem" : ""),"sat ft2.z, ft2.z" + (!shadow ? "rem" : ""),"add ft4.z, ft4.z, ft2.z" + (!shadow ? "rem" : ""),"div ft2.w, ft4.z, fc6.y" + (!shadow ? "rem" : ""),"sat ft1.w, v3.w" + (!shadow ? "rem" : ""),"mul ft2.w, ft2.w, ft1.w" + (!shadow ? "rem" : ""),"mul ft2.w, ft2.w, fc6.w" + (!shadow ? "rem" : "")
            ,"min ft1.w, v2.w, fc10.w" + (!direct ? "rem" : ""),"max ft2.w, ft2.w, ft1.w" + (!direct || !shadow ? "rem" : ""),"mov ft2.w, ft1.w" + (!direct || shadow ? "rem" : ""),"sub ft2.w, fc10.w, ft2.w" + (!direct && !shadow ? "rem" : ""),"mul ft2.xyz, fc10.xyz, ft2.w" + (!direct && !shadow ? "rem" : ""),"add ft2.xyz, ft2.xyz, fc11.xyz" + (!direct && !shadow ? "rem" : ""),"add ft6.xyz, ft6.xyz, ft6.xyz" + (!light ? "rem" : ""),"add ft2.xyz, ft2.xyz, ft6.xyz" + (!light || !direct && !shadow ? "rem" : ""),"mov ft2.xyz, ft6.xyz" + (!light || direct || shadow ? "rem" : ""),"add ft2.xyz, ft2.xyz, fc13.xyz" + (!lightSprite || !direct && !shadow ? "rem" : ""),"mov ft2.xyz, fc13.xyz" + (!lightSprite || direct || shadow ? "rem" : ""),"mul ft0.xyz, ft0.xyz, ft2.xyz" + (!direct && !shadow && !light && !lightSprite ? "rem" : ""),"sat ft1.w, v1.w" + (!fog || sky ? "rem" : ""),"mul ft1.w, ft1.w, fc2.w" + (!fog || sky ? "rem" : ""),"mul ft1.xyz, fc2.xyz, ft1.w" + (!fog || sky ? "rem" : ""),"sub ft1.w, v1.x, ft1.w" + (!fog || sky ? "rem" : "")
            ,"mul ft0.xyz, ft0.xyz, ft1.w" + (!fog || sky ? "rem" : ""),"add ft0.xyz, ft0.xyz, ft1.xyz" + (!fog || sky ? "rem" : ""),"mul ft0.xyz, ft0.xyz, fc13.w" + (!fog || !sky ? "rem" : ""),"add ft0.xyz, ft0.xyz, fc13.xyz" + (!fog || !sky ? "rem" : ""),"mov oc, ft0"]);
            program = new ProgramResource(vertexProgram,fragmentProgram);
            programs[key] = program;
         }
         return program;
      }
   }
}

