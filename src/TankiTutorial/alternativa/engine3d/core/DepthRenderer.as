package alternativa.engine3d.core
{
   import §5e§.§!!?§;
   import §5e§.§-!$§;
   import §5e§.§0!>§;
   import §5e§.§1!8§;
   import §5e§.§8B§;
   import §5e§.§`c§;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.lights.SpotLight;
   import alternativa.engine3d.lights.TubeLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.objects.Mesh;
   import flash.display.BitmapData;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class DepthRenderer
   {
      
      private static const limit2const:int = 62;
      
      private static const limit5const:int = 24;
      
      private var depthProgram:§8B§;
      
      private var depthNormalsProgram:§8B§;
      
      private var correction:Vector.<Number>;
      
      private var depthFragment:Vector.<Number>;
      
      private var ssaoProgram:§8B§;
      
      private var ssaoVertexBuffer:§-!$§;
      
      private var ssaoIndexBuffer:§`c§;
      
      private var ssaoVertex:Vector.<Number>;
      
      private var ssaoFragment:Vector.<Number>;
      
      private var blurProgram:§8B§;
      
      private var blurFragment:Vector.<Number>;
      
      private var omniProgram:§8B§;
      
      private var spotProgram:§8B§;
      
      private var tubeProgram:§8B§;
      
      private var lightConst:Vector.<Number>;
      
      private var lightVertexBuffer:§-!$§;
      
      private var lightIndexBuffer:§`c§;
      
      alternativa3d var depthBuffer:§1!8§;
      
      alternativa3d var lightBuffer:§1!8§;
      
      private var temporaryBuffer:§1!8§;
      
      private var scissor:Rectangle;
      
      private var table:§!!?§;
      
      private var noise:§!!?§;
      
      private var bias:Number = 0.1;
      
      private var tableSize:int = 128;
      
      private var noiseSize:int = 4;
      
      private var blurSamples:int = 16;
      
      private var intensity:Number = 2.5;
      
      private var noiseRandom:Number = 0.2;
      
      private var samples:int = 6;
      
      private var noiseAngle:Number;
      
      alternativa3d var correctionX:Number;
      
      alternativa3d var correctionY:Number;
      
      public function DepthRenderer()
      {
         var i:int = 0;
         var j:int = 0;
         var indexO:int = 0;
         var indexS:int = 0;
         var a:int = 0;
         var b:int = 0;
         var c:int = 0;
         var d:int = 0;
         var e:int = 0;
         var f:int = 0;
         var g:int = 0;
         var h:int = 0;
         var y:Number = NaN;
         var x:Number = NaN;
         var an:Number = NaN;
         var rnd:Number = NaN;
         var cos:int = 0;
         var sin:int = 0;
         var len:int = 0;
         this.correction = Vector.<Number>([0,0,0,1,0,0,0,1,0,0,0,0.5]);
         this.depthFragment = Vector.<Number>([1 / 255,0,0,0.5]);
         this.ssaoVertexBuffer = new §-!$§(Vector.<Number>([-1,1,0,0,0,-1,-1,0,0,1,1,-1,0,1,1,1,1,0,1,0]),5);
         this.ssaoIndexBuffer = new §`c§(Vector.<uint>([0,1,3,2,3,1]));
         this.ssaoVertex = Vector.<Number>([0,0,0,1]);
         this.ssaoFragment = Vector.<Number>([0,0,0,Math.PI * 2,0,0,0,1,0,0,0,1,0,0,1,1,0,0,0,1,0,0,0,1,0,0,0,1]);
         this.blurFragment = Vector.<Number>([0,0,0,1,0,0,0,1]);
         this.lightConst = new Vector.<Number>();
         this.scissor = new Rectangle();
         this.noiseAngle = Math.PI * 2 / this.samples;
         super();
         var v:int = 0;
         var t:int = 0;
         var verts:Vector.<Number> = new Vector.<Number>();
         var inds:Vector.<uint> = new Vector.<uint>();
         for(i = 0; i < limit2const; i++)
         {
            indexO = 4 + i * 2;
            indexS = 4 + i * 5;
            a = i * 8;
            verts[v] = -1;
            v++;
            verts[v] = 1;
            v++;
            verts[v] = -1;
            v++;
            verts[v] = indexO;
            v++;
            verts[v] = indexS;
            v++;
            b = a + 1;
            verts[v] = 1;
            v++;
            verts[v] = 1;
            v++;
            verts[v] = -1;
            v++;
            verts[v] = indexO;
            v++;
            verts[v] = indexS;
            v++;
            c = b + 1;
            verts[v] = 1;
            v++;
            verts[v] = 1;
            v++;
            verts[v] = 1;
            v++;
            verts[v] = indexO;
            v++;
            verts[v] = indexS;
            v++;
            d = c + 1;
            verts[v] = -1;
            v++;
            verts[v] = 1;
            v++;
            verts[v] = 1;
            v++;
            verts[v] = indexO;
            v++;
            verts[v] = indexS;
            v++;
            e = d + 1;
            verts[v] = -1;
            v++;
            verts[v] = -1;
            v++;
            verts[v] = -1;
            v++;
            verts[v] = indexO;
            v++;
            verts[v] = indexS;
            v++;
            f = e + 1;
            verts[v] = 1;
            v++;
            verts[v] = -1;
            v++;
            verts[v] = -1;
            v++;
            verts[v] = indexO;
            v++;
            verts[v] = indexS;
            v++;
            g = f + 1;
            verts[v] = 1;
            v++;
            verts[v] = -1;
            v++;
            verts[v] = 1;
            v++;
            verts[v] = indexO;
            v++;
            verts[v] = indexS;
            v++;
            h = g + 1;
            verts[v] = -1;
            v++;
            verts[v] = -1;
            v++;
            verts[v] = 1;
            v++;
            verts[v] = indexO;
            v++;
            verts[v] = indexS;
            v++;
            inds[t] = a;
            t++;
            inds[t] = e;
            t++;
            inds[t] = b;
            t++;
            inds[t] = b;
            t++;
            inds[t] = e;
            t++;
            inds[t] = f;
            t++;
            inds[t] = b;
            t++;
            inds[t] = f;
            t++;
            inds[t] = g;
            t++;
            inds[t] = b;
            t++;
            inds[t] = g;
            t++;
            inds[t] = c;
            t++;
            inds[t] = e;
            t++;
            inds[t] = g;
            t++;
            inds[t] = f;
            t++;
            inds[t] = e;
            t++;
            inds[t] = h;
            t++;
            inds[t] = g;
            t++;
            inds[t] = c;
            t++;
            inds[t] = g;
            t++;
            inds[t] = h;
            t++;
            inds[t] = c;
            t++;
            inds[t] = h;
            t++;
            inds[t] = d;
            t++;
            inds[t] = a;
            t++;
            inds[t] = d;
            t++;
            inds[t] = h;
            t++;
            inds[t] = a;
            t++;
            inds[t] = h;
            t++;
            inds[t] = e;
            t++;
            inds[t] = a;
            t++;
            inds[t] = b;
            t++;
            inds[t] = c;
            t++;
            inds[t] = a;
            t++;
            inds[t] = c;
            t++;
            inds[t] = d;
            t++;
         }
         this.lightVertexBuffer = new §-!$§(verts,5);
         this.lightIndexBuffer = new §`c§(inds);
         var data:Vector.<uint> = new Vector.<uint>();
         var dataLength:int = 0;
         var p2:Number = Math.PI * 2;
         var s:int = this.tableSize - 1;
         for(i = 0; i < this.tableSize; i++)
         {
            y = (i / s - 0.5) * 2;
            for(j = 0; j < this.tableSize; j++)
            {
               x = (j / s - 0.5) * 2;
               an = Math.atan2(y,x);
               if(an < 0)
               {
                  an += p2;
               }
               data[dataLength] = Math.round(255 * an / p2) << 16;
               dataLength++;
            }
         }
         this.table = new §!!?§(new BitmapData(this.tableSize,this.tableSize,false,0),false);
         this.table.§<s§.setVector(this.table.§<s§.rect,data);
         data = new Vector.<uint>();
         dataLength = 0;
         for(i = 0; i < this.noiseSize; i++)
         {
            for(j = 0; j < this.noiseSize; j++)
            {
               rnd = Math.random() * this.noiseAngle;
               cos = Math.cos(rnd) * 255;
               sin = Math.sin(rnd) * 255;
               len = (this.noiseRandom + Math.random() * (1 - this.noiseRandom)) * 255;
               data[dataLength] = cos << 16 | sin << 8 | len;
               dataLength++;
            }
         }
         this.noise = new §!!?§(new BitmapData(this.noiseSize,this.noiseSize,false,0),false);
         this.noise.§<s§.setVector(this.noise.§<s§.rect,data);
         this.depthBuffer = new §1!8§(1,1);
         this.temporaryBuffer = new §1!8§(1,1);
         this.lightBuffer = new §1!8§(1,1);
      }
      
      alternativa3d function render(camera:Camera3D, viewWidth:Number, viewHeight:Number, scale:Number, ssao:Boolean, deferredLight:Boolean, ambient:Number, objects:Vector.<Object3D>, objectsLength:int) : void
      {
         var i:int = 0;
         var object:Object3D = null;
         var vertexBuffer:§-!$§ = null;
         var indexBuffer:§`c§ = null;
         var numTriangles:int = 0;
         var mesh:Mesh = null;
         var bsp:BSP = null;
         var j:int = 0;
         var count:int = 0;
         var omni:OmniLight = null;
         var spot:SpotLight = null;
         var hotspot:Number = NaN;
         var falloff:Number = NaN;
         var tube:TubeLight = null;
         var device:§0!>§ = camera.device;
         if(viewWidth > 2048)
         {
            viewWidth = 2048;
         }
         if(viewHeight > 2048)
         {
            viewHeight = 2048;
         }
         if(scale > 1)
         {
            scale = 1;
         }
         viewWidth = Math.round(viewWidth * scale);
         viewHeight = Math.round(viewHeight * scale);
         if(viewWidth < 1)
         {
            viewWidth = 1;
         }
         if(viewHeight < 1)
         {
            viewHeight = 1;
         }
         this.scissor.width = viewWidth;
         this.scissor.height = viewHeight;
         var mapWidth:int = 1 << Math.ceil(Math.log(viewWidth) / Math.LN2);
         var mapHeight:int = 1 << Math.ceil(Math.log(viewHeight) / Math.LN2);
         if(mapWidth != this.depthBuffer.§[]§ || mapHeight != this.depthBuffer.§'d§)
         {
            this.depthBuffer.§[P§();
            this.depthBuffer = new §1!8§(mapWidth,mapHeight);
            this.temporaryBuffer.§[P§();
            this.temporaryBuffer = new §1!8§(mapWidth,mapHeight);
            this.lightBuffer.§[P§();
            this.lightBuffer = new §1!8§(mapWidth,mapHeight);
         }
         if(!ssao)
         {
            this.noise.§[!§();
            this.temporaryBuffer.§[!§();
            this.ssaoVertexBuffer.§[!§();
            this.ssaoIndexBuffer.§[!§();
         }
         if(!deferredLight)
         {
            this.lightBuffer.§[!§();
            this.lightVertexBuffer.§[!§();
            this.lightIndexBuffer.§[!§();
         }
         if(!ssao && !deferredLight)
         {
            this.table.§[!§();
         }
         this.correctionX = viewWidth / this.depthBuffer.§[]§;
         this.correctionY = viewHeight / this.depthBuffer.§'d§;
         device.§!0§(this.depthBuffer,true);
         device.§9+§(1,0,0.25,1);
         device.§?!&§(this.scissor);
         device.§"W§(this.getDepthProgram(ssao || deferredLight));
         this.correction[0] = this.correctionX;
         this.correction[1] = this.correctionY;
         this.correction[2] = 255 / camera.farClipping;
         this.correction[4] = 1 - this.correctionX;
         this.correction[5] = 1 - this.correctionY;
         this.correction[8] = camera.correctionX;
         this.correction[9] = camera.correctionY;
         device.§%&§(Context3DProgramType.VERTEX,3,camera.projection,1,false);
         device.§%&§(Context3DProgramType.VERTEX,4,this.correction,3,false);
         if(ssao || deferredLight)
         {
            device.§4! §(0,this.table);
         }
         for(i = 0; i < objectsLength; i++)
         {
            object = objects[i];
            if(object is Mesh)
            {
               mesh = Mesh(object);
               vertexBuffer = mesh.vertexBuffer;
               indexBuffer = mesh.indexBuffer;
               numTriangles = mesh.numTriangles;
            }
            else if(object is BSP)
            {
               bsp = BSP(object);
               vertexBuffer = bsp.vertexBuffer;
               indexBuffer = bsp.indexBuffer;
               numTriangles = bsp.numTriangles;
            }
            device.§"J§(0,vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
            device.§%&§(Context3DProgramType.VERTEX,0,object.transformConst,3,false);
            device.§%&§(Context3DProgramType.FRAGMENT,0,this.depthFragment,1);
            if(ssao || deferredLight)
            {
               device.§"J§(1,vertexBuffer,5,Context3DVertexBufferFormat.FLOAT_3);
            }
            device.§>c§(indexBuffer,0,numTriangles);
         }
         if(deferredLight)
         {
            device.§!0§(this.lightBuffer,false);
            device.§9+§(ambient,ambient,ambient,0);
            device.§ >§(Context3DBlendFactor.ONE,Context3DBlendFactor.ONE);
            device.§4! §(0,this.depthBuffer);
            device.§"J§(0,this.lightVertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
            device.§"J§(1,this.lightVertexBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
            device.§%&§(Context3DProgramType.VERTEX,0,camera.projection,1,false);
            device.§%&§(Context3DProgramType.VERTEX,1,this.correction,3,false);
            this.ssaoFragment[0] = camera.farClipping;
            this.ssaoFragment[1] = camera.farClipping / 255;
            this.ssaoFragment[4] = 2 / this.correctionX;
            this.ssaoFragment[5] = 2 / this.correctionY;
            this.ssaoFragment[8] = camera.correctionX;
            this.ssaoFragment[9] = camera.correctionY;
            this.ssaoFragment[10] = 0.5;
            device.§%&§(Context3DProgramType.FRAGMENT,0,this.ssaoFragment,3,false);
            device.§"W§(this.getOmniProgram());
            j = 0;
            count = 0;
            for(i = 0; i < camera.omniesCount; i++)
            {
               omni = camera.omnies[i];
               this.lightConst[j] = omni.cmd * camera.correctionX;
               j++;
               this.lightConst[j] = omni.cmh * camera.correctionY;
               j++;
               this.lightConst[j] = omni.cml;
               j++;
               this.lightConst[j] = omni.attenuationEnd;
               j++;
               this.lightConst[j] = omni.intensity * camera.deferredLightingStrength * (omni.color >> 16 & 0xFF) / 255;
               j++;
               this.lightConst[j] = omni.intensity * camera.deferredLightingStrength * (omni.color >> 8 & 0xFF) / 255;
               j++;
               this.lightConst[j] = omni.intensity * camera.deferredLightingStrength * (omni.color & 0xFF) / 255;
               j++;
               this.lightConst[j] = 1 / (omni.attenuationEnd - omni.attenuationBegin);
               j++;
               count++;
               if(count == limit2const || i == camera.omniesCount - 1)
               {
                  device.§%&§(Context3DProgramType.VERTEX,4,this.lightConst,count * 2,false);
                  device.§>c§(this.lightIndexBuffer,0,count * 6 * 2);
                  count = 0;
                  j = 0;
               }
            }
            device.§"W§(this.getSpotProgram());
            j = 0;
            count = 0;
            for(i = 0; i < camera.spotsCount; i++)
            {
               spot = camera.spots[i];
               hotspot = Math.cos(spot.hotspot * 0.5);
               falloff = Math.cos(spot.falloff * 0.5);
               this.lightConst[j] = spot.cma;
               j++;
               this.lightConst[j] = spot.cmb;
               j++;
               this.lightConst[j] = spot.cmc;
               j++;
               this.lightConst[j] = spot.cmd;
               j++;
               this.lightConst[j] = spot.cme;
               j++;
               this.lightConst[j] = spot.cmf;
               j++;
               this.lightConst[j] = spot.cmg;
               j++;
               this.lightConst[j] = spot.cmh;
               j++;
               this.lightConst[j] = spot.cmi;
               j++;
               this.lightConst[j] = spot.cmj;
               j++;
               this.lightConst[j] = spot.cmk;
               j++;
               this.lightConst[j] = spot.cml;
               j++;
               this.lightConst[j] = spot.attenuationEnd;
               j++;
               this.lightConst[j] = 1 / (spot.attenuationEnd - spot.attenuationBegin);
               j++;
               this.lightConst[j] = falloff;
               j++;
               this.lightConst[j] = 1 / (hotspot - falloff);
               j++;
               this.lightConst[j] = spot.intensity * camera.deferredLightingStrength * (spot.color >> 16 & 0xFF) / 255;
               j++;
               this.lightConst[j] = spot.intensity * camera.deferredLightingStrength * (spot.color >> 8 & 0xFF) / 255;
               j++;
               this.lightConst[j] = spot.intensity * camera.deferredLightingStrength * (spot.color & 0xFF) / 255;
               j++;
               this.lightConst[j] = Math.sin(spot.falloff * 0.5) * spot.attenuationEnd;
               j++;
               count++;
               if(count == limit5const || i == camera.spotsCount - 1)
               {
                  device.§%&§(Context3DProgramType.VERTEX,4,this.lightConst,count * 5,false);
                  device.§>c§(this.lightIndexBuffer,0,count * 6 * 2);
                  count = 0;
                  j = 0;
               }
            }
            device.§"W§(this.getTubeProgram());
            j = 0;
            count = 0;
            for(i = 0; i < camera.tubesCount; i++)
            {
               tube = camera.tubes[i];
               this.lightConst[j] = tube.cma;
               j++;
               this.lightConst[j] = tube.cmb;
               j++;
               this.lightConst[j] = tube.cmc;
               j++;
               this.lightConst[j] = tube.cmd;
               j++;
               this.lightConst[j] = tube.cme;
               j++;
               this.lightConst[j] = tube.cmf;
               j++;
               this.lightConst[j] = tube.cmg;
               j++;
               this.lightConst[j] = tube.cmh;
               j++;
               this.lightConst[j] = tube.cmi;
               j++;
               this.lightConst[j] = tube.cmj;
               j++;
               this.lightConst[j] = tube.cmk;
               j++;
               this.lightConst[j] = tube.cml;
               j++;
               this.lightConst[j] = tube.attenuationEnd;
               j++;
               this.lightConst[j] = 1 / (tube.attenuationEnd - tube.attenuationBegin);
               j++;
               this.lightConst[j] = tube.length * 0.5 + tube.falloff;
               j++;
               this.lightConst[j] = 1 / tube.falloff;
               j++;
               this.lightConst[j] = tube.intensity * camera.deferredLightingStrength * (tube.color >> 16 & 0xFF) / 255;
               j++;
               this.lightConst[j] = tube.intensity * camera.deferredLightingStrength * (tube.color >> 8 & 0xFF) / 255;
               j++;
               this.lightConst[j] = tube.intensity * camera.deferredLightingStrength * (tube.color & 0xFF) / 255;
               j++;
               this.lightConst[j] = tube.length * 0.5;
               j++;
               count++;
               if(count == limit5const || i == camera.tubesCount - 1)
               {
                  device.§%&§(Context3DProgramType.VERTEX,4,this.lightConst,count * 5,false);
                  device.§>c§(this.lightIndexBuffer,0,count * 6 * 2);
                  count = 0;
                  j = 0;
               }
            }
            device.§ >§(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         }
         if(ssao)
         {
            device.§!0§(this.temporaryBuffer,false);
            device.§9+§(0,0,0,0);
            device.§"W§(this.getSSAOProgram());
            device.§4! §(0,this.depthBuffer);
            device.§4! §(1,this.noise);
            device.§"J§(0,this.ssaoVertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
            device.§"J§(1,this.ssaoVertexBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
            this.ssaoVertex[0] = mapWidth / this.noiseSize;
            this.ssaoVertex[1] = mapHeight / this.noiseSize;
            device.§%&§(Context3DProgramType.VERTEX,0,this.ssaoVertex,1,false);
            this.ssaoFragment[0] = camera.farClipping;
            this.ssaoFragment[1] = camera.farClipping / 255;
            this.ssaoFragment[4] = 2 / this.correctionX;
            this.ssaoFragment[5] = 2 / this.correctionY;
            this.ssaoFragment[8] = camera.ssaoRadius;
            this.ssaoFragment[9] = 1 / camera.ssaoRange;
            this.ssaoFragment[10] = this.bias;
            this.ssaoFragment[11] = this.intensity * 1 / this.samples;
            this.ssaoFragment[12] = camera.correctionX;
            this.ssaoFragment[13] = camera.correctionY;
            this.ssaoFragment[16] = Math.cos(this.noiseAngle);
            this.ssaoFragment[17] = Math.sin(this.noiseAngle);
            this.ssaoFragment[20] = -Math.sin(this.noiseAngle);
            this.ssaoFragment[21] = Math.cos(this.noiseAngle);
            this.ssaoFragment[24] = this.correctionX - 1 / mapWidth;
            this.ssaoFragment[25] = this.correctionY - 1 / mapHeight;
            device.§%&§(Context3DProgramType.FRAGMENT,0,this.ssaoFragment,7,false);
            device.§>c§(this.ssaoIndexBuffer,0,2);
            device.§4! §(1,null);
            device.§!0§(this.depthBuffer,false);
            device.§9+§(0,0,0,0);
            device.§"W§(this.getBlurProgram());
            device.§4! §(0,this.temporaryBuffer);
            this.blurFragment[0] = 1 / mapWidth;
            this.blurFragment[1] = 1 / mapHeight;
            this.blurFragment[3] = 1 / this.blurSamples;
            this.blurFragment[4] = this.correctionX - 1 / mapWidth;
            this.blurFragment[5] = this.correctionY - 1 / mapHeight;
            device.§%&§(Context3DProgramType.FRAGMENT,0,this.blurFragment,2,false);
            device.§>c§(this.ssaoIndexBuffer,0,2);
         }
         device.§"J§(1,null);
         device.§4! §(0,null);
         device.§?!&§(null);
      }
      
      alternativa3d function resetResources() : void
      {
         this.noise.§[!§();
         this.table.§[!§();
         this.depthBuffer.§[!§();
         this.temporaryBuffer.§[!§();
         this.lightBuffer.§[!§();
         this.ssaoVertexBuffer.§[!§();
         this.ssaoIndexBuffer.§[!§();
         this.lightVertexBuffer.§[!§();
         this.lightIndexBuffer.§[!§();
      }
      
      private function getDepthProgram(ssao:Boolean) : §8B§
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var program:§8B§ = ssao ? this.depthNormalsProgram : this.depthProgram;
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["dp4 vt0.x, va0, vc0","dp4 vt0.y, va0, vc1","dp4 vt0.z, va0, vc2","mul vt0.xy, vt0.xy, vc4.xy","mul vt1.xy, vc5.xy, vt0.z","sub vt0.xy, vt0.xy, vt1.xy","mul v0, vt0.z, vc4.z","dp3 vt1.x, va1, vc0" + (!ssao ? "rem" : ""),"dp3 vt1.y, va1, vc1" + (!ssao ? "rem" : ""),"mul v0.xy, vt1.xy, vc6.xy" + (!ssao ? "rem" : ""),"dp3 v0.z, va1, vc2" + (!ssao ? "rem" : ""),"mov op.xw, vt0.xz","neg op.y, vt0.y","mul vt0.z, vt0.z, vc3.z","add op.z, vt0.z, vc3.w"]);
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["frc ft0.y, v0.w","sub ft0.x, v0.w, ft0.y","mul ft0.x, ft0.x, fc0.x","mov ft0.zw, fc0.z" + (ssao ? "rem" : ""),"mov ft1.xy, v0.xy" + (!ssao ? "rem" : ""),"mov ft1.zw, fc0.z" + (!ssao ? "rem" : ""),"nrm ft1.xyz, ft1.xyz" + (!ssao ? "rem" : ""),"mul ft1.xy, ft1.xy, fc0.w" + (!ssao ? "rem" : ""),"add ft1.xy, ft1.xy, fc0.w" + (!ssao ? "rem" : ""),"tex ft2, ft1, fs0 <2d,clamp,nearest,mipnone>" + (!ssao ? "rem" : ""),"mov ft0.w, ft2.x" + (!ssao ? "rem" : ""),"mul ft1.xy, v0.xy, v0.xy" + (!ssao ? "rem" : ""),"add ft1.x, ft1.x, ft1.y" + (!ssao ? "rem" : ""),"sqt ft1.x, ft1.x" + (!ssao ? "rem" : ""),"neg ft1.y, v0.z" + (!ssao ? "rem" : ""),"mul ft1.xy, ft1.xy, fc0.w" + (!ssao ? "rem" : ""),"add ft1.xy, ft1.xy, fc0.w" + (!ssao ? "rem" : ""),"tex ft2, ft1, fs0 <2d,clamp,nearest,mipnone>" + (!ssao ? "rem" : ""),"mov ft0.z, ft2.x" + (!ssao ? "rem" : ""),"mov oc, ft0"]);
            program = new §8B§(vertexProgram,fragmentProgram);
            if(ssao)
            {
               this.depthNormalsProgram = program;
            }
            else
            {
               this.depthProgram = program;
            }
         }
         return program;
      }
      
      private function getSSAOProgram() : §8B§
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var program:§8B§ = this.ssaoProgram;
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["mov op, va0","mov v0, va1","mul v1, va1, vc0"]);
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["tex ft0, v0, fs0 <2d,clamp,nearest,mipnone>","mul ft0.z, ft0.z, fc0.w","mul ft0.w, ft0.w, fc0.w","cos ft1.w, ft0.z","sin ft1.z, ft0.z","neg ft1.z, ft1.z","cos ft0.z, ft0.w","sin ft0.w, ft0.w","mul ft1.xy, ft0.zw, ft1.w","dp3 ft2.z, ft0, fc0","mul ft2.xy, v0.xy, fc1.xy","sub ft2.xy, ft2.xy, fc1.w","mul ft2.xy, ft2.xy, ft2.z","tex ft3, v1, fs1 <2d,wrap,nearest,mipnone>","mul ft3.xy, ft3.xy, ft3.z","mul ft3.xy, ft3.xy, fc2.x","div ft4, ft3, fc3","div ft4.xy, ft4.xy, ft2.z","div ft4.xy, ft4.xy, fc1.xy","add ft4, v0, ft4","min ft5, ft4, fc6","tex ft5, ft5, fs0 <2d,clamp,nearest,mipnone>","dp3 ft5.z, ft5, fc0","mul ft5.xy, ft4.xy, fc1.xy","sub ft5.xy, ft5.xy, fc1.w","mul ft5.xy, ft5.xy, ft5.z","sub ft5.xyz, ft5.xyz, ft2.xyz","mul ft5, ft5, fc3","dp3 ft5.w, ft5, ft5","sqt ft5.w, ft5.w","div ft5.xyz, ft5.xyz, ft5.w","mul ft5.w, ft5.w, fc2.y","sub ft5.w, fc1.w, ft5.w","max ft5.w, ft5.w, fc0.z","dp3 ft5.z, ft5, ft1","sub ft5.z, ft5.z, fc2.z"
            ,"max ft5.z, ft5.z, fc0.z","mul ft5.w, ft5.z, ft5.w","mov ft0.w, ft5.w","dp3 ft3.w, ft3, fc4","dp3 ft3.y, ft3, fc5","mov ft3.x, ft3.w","div ft4, ft3, fc3","div ft4.xy, ft4.xy, ft2.z","div ft4.xy, ft4.xy, fc1.xy","add ft4, v0, ft4","min ft5, ft4, fc6","tex ft5, ft5, fs0 <2d,clamp,nearest,mipnone>","dp3 ft5.z, ft5, fc0","mul ft5.xy, ft4.xy, fc1.xy","sub ft5.xy, ft5.xy, fc1.w","mul ft5.xy, ft5.xy, ft5.z","sub ft5.xyz, ft5.xyz, ft2.xyz","mul ft5, ft5, fc3","dp3 ft5.w, ft5, ft5","sqt ft5.w, ft5.w","div ft5.xyz, ft5.xyz, ft5.w","mul ft5.w, ft5.w, fc2.y","sub ft5.w, fc1.w, ft5.w","max ft5.w, ft5.w, fc0.z","dp3 ft5.z, ft5, ft1","sub ft5.z, ft5.z, fc2.z","max ft5.z, ft5.z, fc0.z","mul ft5.w, ft5.z, ft5.w","add ft0.w, ft0.w, ft5.w","dp3 ft3.w, ft3, fc4","dp3 ft3.y, ft3, fc5","mov ft3.x, ft3.w","div ft4, ft3, fc3","div ft4.xy, ft4.xy, ft2.z","div ft4.xy, ft4.xy, fc1.xy","add ft4, v0, ft4","min ft5, ft4, fc6","tex ft5, ft5, fs0 <2d,clamp,nearest,mipnone>","dp3 ft5.z, ft5, fc0","mul ft5.xy, ft4.xy, fc1.xy"
            ,"sub ft5.xy, ft5.xy, fc1.w","mul ft5.xy, ft5.xy, ft5.z","sub ft5.xyz, ft5.xyz, ft2.xyz","mul ft5, ft5, fc3","dp3 ft5.w, ft5, ft5","sqt ft5.w, ft5.w","div ft5.xyz, ft5.xyz, ft5.w","mul ft5.w, ft5.w, fc2.y","sub ft5.w, fc1.w, ft5.w","max ft5.w, ft5.w, fc0.z","dp3 ft5.z, ft5, ft1","sub ft5.z, ft5.z, fc2.z","max ft5.z, ft5.z, fc0.z","mul ft5.w, ft5.z, ft5.w","add ft0.w, ft0.w, ft5.w","dp3 ft3.w, ft3, fc4","dp3 ft3.y, ft3, fc5","mov ft3.x, ft3.w","div ft4, ft3, fc3","div ft4.xy, ft4.xy, ft2.z","div ft4.xy, ft4.xy, fc1.xy","add ft4, v0, ft4","min ft5, ft4, fc6","tex ft5, ft5, fs0 <2d,clamp,nearest,mipnone>","dp3 ft5.z, ft5, fc0","mul ft5.xy, ft4.xy, fc1.xy","sub ft5.xy, ft5.xy, fc1.w","mul ft5.xy, ft5.xy, ft5.z","sub ft5.xyz, ft5.xyz, ft2.xyz","mul ft5, ft5, fc3","dp3 ft5.w, ft5, ft5","sqt ft5.w, ft5.w","div ft5.xyz, ft5.xyz, ft5.w","mul ft5.w, ft5.w, fc2.y","sub ft5.w, fc1.w, ft5.w","max ft5.w, ft5.w, fc0.z","dp3 ft5.z, ft5, ft1","sub ft5.z, ft5.z, fc2.z","max ft5.z, ft5.z, fc0.z","mul ft5.w, ft5.z, ft5.w"
            ,"add ft0.w, ft0.w, ft5.w","dp3 ft3.w, ft3, fc4","dp3 ft3.y, ft3, fc5","mov ft3.x, ft3.w","div ft4, ft3, fc3","div ft4.xy, ft4.xy, ft2.z","div ft4.xy, ft4.xy, fc1.xy","add ft4, v0, ft4","min ft5, ft4, fc6","tex ft5, ft5, fs0 <2d,clamp,nearest,mipnone>","dp3 ft5.z, ft5, fc0","mul ft5.xy, ft4.xy, fc1.xy","sub ft5.xy, ft5.xy, fc1.w","mul ft5.xy, ft5.xy, ft5.z","sub ft5.xyz, ft5.xyz, ft2.xyz","mul ft5, ft5, fc3","dp3 ft5.w, ft5, ft5","sqt ft5.w, ft5.w","div ft5.xyz, ft5.xyz, ft5.w","mul ft5.w, ft5.w, fc2.y","sub ft5.w, fc1.w, ft5.w","max ft5.w, ft5.w, fc0.z","dp3 ft5.z, ft5, ft1","sub ft5.z, ft5.z, fc2.z","max ft5.z, ft5.z, fc0.z","mul ft5.w, ft5.z, ft5.w","add ft0.w, ft0.w, ft5.w","dp3 ft3.w, ft3, fc4","dp3 ft3.y, ft3, fc5","mov ft3.x, ft3.w","div ft4, ft3, fc3","div ft4.xy, ft4.xy, ft2.z","div ft4.xy, ft4.xy, fc1.xy","add ft4, v0, ft4","min ft5, ft4, fc6","tex ft5, ft5, fs0 <2d,clamp,nearest,mipnone>","dp3 ft5.z, ft5, fc0","mul ft5.xy, ft4.xy, fc1.xy","sub ft5.xy, ft5.xy, fc1.w","mul ft5.xy, ft5.xy, ft5.z"
            ,"sub ft5.xyz, ft5.xyz, ft2.xyz","mul ft5, ft5, fc3","dp3 ft5.w, ft5, ft5","sqt ft5.w, ft5.w","div ft5.xyz, ft5.xyz, ft5.w","mul ft5.w, ft5.w, fc2.y","sub ft5.w, fc1.w, ft5.w","max ft5.w, ft5.w, fc0.z","dp3 ft5.z, ft5, ft1","sub ft5.z, ft5.z, fc2.z","max ft5.z, ft5.z, fc0.z","mul ft5.w, ft5.z, ft5.w","add ft0.w, ft0.w, ft5.w","mul ft0.w, ft0.w, fc2.w","mov oc, ft0"]);
            program = new §8B§(vertexProgram,fragmentProgram);
            this.ssaoProgram = program;
         }
         return program;
      }
      
      private function getBlurProgram() : §8B§
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var program:§8B§ = this.blurProgram;
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["mov op, va0","mov v0, va1"]);
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["mov ft1, v0","tex ft0, ft1, fs0 <2d,clamp,nearest,mipnone>","sub ft1.y, ft1.y, fc0.y","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","sub ft1.x, ft1.x, fc0.x","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","add ft1.y, ft1.y, fc0.y","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","add ft1.y, ft1.y, fc0.y","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","add ft1.y, ft1.y, fc0.y","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","add ft1.x, ft1.x, fc0.x","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","add ft1.x, ft1.x, fc0.x","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","add ft1.x, ft1.x, fc0.x","min ft2, ft1, fc1"
            ,"tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","sub ft1.y, ft1.y, fc0.y","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","sub ft1.y, ft1.y, fc0.y","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","sub ft1.y, ft1.y, fc0.y","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","sub ft1.x, ft1.x, fc0.x","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","add ft1.y, ft1.y, fc0.y","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","add ft1.y, ft1.y, fc0.y","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","sub ft1.x, ft1.x, fc0.x","min ft2, ft1, fc1","tex ft2, ft2, fs0 <2d,clamp,nearest,mipnone>","add ft0.w, ft0.w, ft2.w","mul ft0.w, ft0.w, fc0.w","mov oc, ft0"]);
            program = new §8B§(vertexProgram,fragmentProgram);
            this.blurProgram = program;
         }
         return program;
      }
      
      private function getOmniProgram() : §8B§
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var program:§8B§ = this.omniProgram;
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["mov v1, vc[va1.x]","mov v2, vc[va1.x+1]","mul vt0, va0, vc[va1.x].w","add vt0, vt0, vc[va1.x]","div vt0.xy, vt0.xy, vc3.xy","mul vt0.xy, vt0.xy, vc1.xy","mul vt1.xy, vc2.xy, vt0.z","sub vt0.xy, vt0.xy, vt1.xy","mov v0, vt0","mov op.xw, vt0.xz","neg op.y, vt0.y","mul vt0.z, vt0.z, vc0.z","add op.z, vt0.z, vc0.w"]);
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["div ft4, v0, v0.z","mul ft4, ft4, fc2.z","add ft4, ft4, fc2.z","tex ft0, ft4, fs0 <2d,clamp,nearest,mipnone>","mul ft0.z, ft0.z, fc0.w","mul ft0.w, ft0.w, fc0.w","cos ft1.w, ft0.z","sin ft1.z, ft0.z","neg ft1.z, ft1.z","cos ft0.z, ft0.w","sin ft0.w, ft0.w","mul ft1.xy, ft0.zw, ft1.w","dp3 ft2.z, ft0, fc0","mul ft2.xy, ft4.xy, fc1.xy","sub ft2.xy, ft2.xy, fc1.w","mul ft2.xy, ft2.xy, ft2.z","mul ft2.xy, ft2.xy, fc2.xy","sub ft3.xyz, v1.xyz, ft2.xyz","dp3 ft3.w, ft3.xyz, ft3.xyz","sqt ft3.w, ft3.w","div ft3.xyz, ft3.xyz, ft3.w","sub ft3.w, v1.w, ft3.w","mul ft3.w, ft3.w, v2.w","sat ft3.w, ft3.w","mul ft3.w, ft3.w, ft3.w","dp3 ft3.z, ft3, ft1","max ft3.z, ft3.z, fc1.z","mul ft3.w, ft3.w, ft3.z","mul ft0.xyz, v2.xyz, ft3.w","mov oc, ft0"]);
            program = new §8B§(vertexProgram,fragmentProgram);
            this.omniProgram = program;
         }
         return program;
      }
      
      private function getSpotProgram() : §8B§
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var program:§8B§ = this.spotProgram;
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["mov vt2, vc[va1.y]","mov vt3, vc[va1.y+1]","mov vt4, vc[va1.y+2]","mul v1.x, vt2.w, vc3.x","mul v1.y, vt3.w, vc3.y","mov v1.z, vt4.w","mov v1.w, vc1.w","mul v2.x, vt2.z, vc3.x","mul v2.y, vt3.z, vc3.y","mov v2.z, vt4.z","mov v2.w, vc1.w","mov v3, vc[va1.y+3]","mov v4, vc[va1.y+4]","mul vt0.xy, va0.xy, vc[va1.y+4].w","mul vt0.z, va0.z, vc[va1.y+3].x","add vt0.z, vt0.z, vc[va1.y+3].x","mul vt0.z, vt0.z, vc3.w","mov vt0.w, vc1.w","dp4 vt1.x, vt0, vt2","dp4 vt1.y, vt0, vt3","dp4 vt1.z, vt0, vt4","mov vt0.xyz, vt1.xyz","mul vt0.xy, vt0.xy, vc1.xy","mul vt1.xy, vc2.xy, vt0.z","sub vt0.xy, vt0.xy, vt1.xy","mov v0, vt0","mov op.xw, vt0.xz","neg op.y, vt0.y","mul vt0.z, vt0.z, vc0.z","add op.z, vt0.z, vc0.w"]);
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["div ft4, v0, v0.z","mul ft4, ft4, fc2.z","add ft4, ft4, fc2.z","tex ft0, ft4, fs0 <2d,clamp,nearest,mipnone>","mul ft0.z, ft0.z, fc0.w","mul ft0.w, ft0.w, fc0.w","cos ft1.w, ft0.z","sin ft1.z, ft0.z","neg ft1.z, ft1.z","cos ft0.z, ft0.w","sin ft0.w, ft0.w","mul ft1.xy, ft0.zw, ft1.w","dp3 ft2.z, ft0, fc0","mul ft2.xy, ft4.xy, fc1.xy","sub ft2.xy, ft2.xy, fc1.w","mul ft2.xy, ft2.xy, ft2.z","mul ft2.xy, ft2.xy, fc2.xy","sub ft3.xyz, v1.xyz, ft2.xyz","dp3 ft3.w, ft3.xyz, ft3.xyz","sqt ft3.w, ft3.w","div ft3.xyz, ft3.xyz, ft3.w","sub ft3.w, v3.x, ft3.w","mul ft3.w, ft3.w, v3.y","sat ft3.w, ft3.w","mul ft3.w, ft3.w, ft3.w","dp3 ft4.w, ft3, ft1","max ft4.w, ft4.w, fc1.z","mul ft3.w, ft3.w, ft4.w","dp3 ft4.w, ft3, v2","neg ft4.w, ft4.w","sub ft4.w, ft4.w, v3.z","mul ft4.w, ft4.w, v3.w","sat ft4.w, ft4.w","mul ft4.w, ft4.w, ft4.w","mul ft3.w, ft3.w, ft4.w","mul ft0.xyz, v4.xyz, ft3.w","mov oc, ft0"]);
            program = new §8B§(vertexProgram,fragmentProgram);
            this.spotProgram = program;
         }
         return program;
      }
      
      private function getTubeProgram() : §8B§
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var program:§8B§ = this.tubeProgram;
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["mov vt2, vc[va1.y]","mov vt3, vc[va1.y+1]","mov vt4, vc[va1.y+2]","mul vt0.x, vt2.z, vc3.x","mul vt0.y, vt3.z, vc3.y","mov vt0.z, vt4.z","mov vt0.w, vc1.w","mov v2, vt0","mul vt1.x, vt2.w, vc3.x","mul vt1.y, vt3.w, vc3.y","mov vt1.z, vt4.w","mov vt1.w, vc1.w","mul vt0, vt0, vc[va1.y+4].w","add v1, vt1, vt0","mov v3, vc[va1.y+3]","mov v4, vc[va1.y+4]","mul vt0.xy, va0.xy, vc[va1.y+3].x","mul vt0.z, va0.z, vc[va1.y+3].z","add vt0.z, vt0.z, vc[va1.y+4].w","mov vt0.w, vc1.w","dp4 vt1.x, vt0, vt2","dp4 vt1.y, vt0, vt3","dp4 vt1.z, vt0, vt4","mov vt0.xyz, vt1.xyz","mul vt0.xy, vt0.xy, vc1.xy","mul vt1.xy, vc2.xy, vt0.z","sub vt0.xy, vt0.xy, vt1.xy","mov v0, vt0","mov op.xw, vt0.xz","neg op.y, vt0.y","mul vt0.z, vt0.z, vc0.z","add op.z, vt0.z, vc0.w"]);
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["div ft4, v0, v0.z","mul ft4, ft4, fc2.z","add ft4, ft4, fc2.z","tex ft0, ft4, fs0 <2d,clamp,nearest,mipnone>","mul ft0.z, ft0.z, fc0.w","mul ft0.w, ft0.w, fc0.w","cos ft1.w, ft0.z","sin ft1.z, ft0.z","neg ft1.z, ft1.z","cos ft0.z, ft0.w","sin ft0.w, ft0.w","mul ft1.xy, ft0.zw, ft1.w","dp3 ft2.z, ft0, fc0","mul ft2.xy, ft4.xy, fc1.xy","sub ft2.xy, ft2.xy, fc1.w","mul ft2.xy, ft2.xy, ft2.z","mul ft2.xy, ft2.xy, fc2.xy","sub ft4.xyz, ft2.xyz, v1.xyz","dp3 ft4.w, ft4.xyz, v2.xyz","mul ft4.xyz, v2.xyz, ft4.w","add ft4.xyz, v1.xyz, ft4.xyz","abs ft4.w, ft4.w","sub ft4.w, v3.z, ft4.w","mul ft4.w, ft4.w, v3.w","sat ft4.w, ft4.w","mul ft4.w, ft4.w, ft4.w","sub ft3.xyz, ft4.xyz, ft2.xyz","dp3 ft3.w, ft3.xyz, ft3.xyz","sqt ft3.w, ft3.w","div ft3.xyz, ft3.xyz, ft3.w","sub ft3.w, v3.x, ft3.w","mul ft3.w, ft3.w, v3.y","sat ft3.w, ft3.w","mul ft3.w, ft3.w, ft3.w","mul ft3.w, ft3.w, ft4.w","dp3 ft4.w, ft3, ft1","max ft4.w, ft4.w, fc1.z"
            ,"mul ft3.w, ft3.w, ft4.w","mul ft0.xyz, v4.xyz, ft3.w","mov oc, ft0"]);
            program = new §8B§(vertexProgram,fragmentProgram);
            this.tubeProgram = program;
         }
         return program;
      }
   }
}

