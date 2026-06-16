package alternativa.engine3d.core
{
   import §5e§.§-!$§;
   import §5e§.§0!>§;
   import §5e§.§8B§;
   import §5e§.§^i§;
   import §5e§.§`c§;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Vector3D;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class Shadow
   {
      
      private static var casterProgram:§8B§;
      
      private static var volumeProgram:§8B§;
      
      private static var casterConst:Vector.<Number> = Vector.<Number>([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0]);
      
      private static var volumeVertexBuffer:§-!$§ = new §-!$§(Vector.<Number>([0,0,0,0,1,0,1,1,0,1,0,0,0,0,1,0,1,1,1,1,1,1,0,1]),3);
      
      private static var volumeIndexBuffer:§`c§ = new §`c§(Vector.<uint>([0,1,3,2,3,1,7,6,4,5,4,6,4,5,0,1,0,5,3,2,7,6,7,2,0,3,4,7,4,3,5,6,1,2,1,6]));
      
      private static var volumeTransformConst:Vector.<Number> = new Vector.<Number>(20);
      
      private static var volumeFragmentConst:Vector.<Number> = Vector.<Number>([1,0,1,0.5]);
      
      private static var shadowPrograms:Array = new Array();
      
      private static var facePrograms:Array = new Array();
      
      public var mapSize:int;
      
      public var blur:int;
      
      public var attenuation:Number;
      
      public var nearDistance:Number;
      
      public var farDistance:Number;
      
      public var color:int;
      
      public var alpha:Number;
      
      public var direction:Vector3D = new Vector3D(0,0,-1);
      
      public var offset:Number = 0;
      
      public var backFadeRange:Number = 0;
      
      private var casters:Vector.<Mesh> = new Vector.<Mesh>();
      
      private var castersCount:int = 0;
      
      alternativa3d var receiversBuffers:Vector.<int> = new Vector.<int>();
      
      alternativa3d var receiversFirstIndexes:Vector.<int> = new Vector.<int>();
      
      alternativa3d var receiversNumsTriangles:Vector.<int> = new Vector.<int>();
      
      alternativa3d var receiversCount:int = 0;
      
      private var dir:Vector3D = new Vector3D();
      
      private var light:DirectionalLight = new DirectionalLight(0);
      
      private var boundVertexList:Vertex = Vertex.createList(8);
      
      private var planeX:Number;
      
      private var planeY:Number;
      
      private var planeSize:Number;
      
      private var minZ:Number;
      
      alternativa3d var boundMinX:Number;
      
      alternativa3d var boundMinY:Number;
      
      alternativa3d var boundMinZ:Number;
      
      alternativa3d var boundMaxX:Number;
      
      alternativa3d var boundMaxY:Number;
      
      alternativa3d var boundMaxZ:Number;
      
      alternativa3d var cameraInside:Boolean;
      
      private var transformConst:Vector.<Number> = new Vector.<Number>(16);
      
      private var colorConst:Vector.<Number> = new Vector.<Number>(12);
      
      private var clampConst:Vector.<Number> = new Vector.<Number>(4);
      
      alternativa3d var texture:§^i§;
      
      alternativa3d var textureScaleU:Number;
      
      alternativa3d var textureScaleV:Number;
      
      alternativa3d var textureOffsetU:Number;
      
      alternativa3d var textureOffsetV:Number;
      
      public function Shadow(mapSize:int, blur:int, attenuation:Number, nearDistance:Number, farDistance:Number, color:int = 0, alpha:Number = 1)
      {
         super();
         if(mapSize > ShadowAtlas.sizeLimit)
         {
            throw new Error("Value of mapSize too big.");
         }
         var pow:Number = Math.log(mapSize) / Math.LN2;
         if(pow != int(pow))
         {
            throw new Error("Value of mapSize must be power of 2.");
         }
         this.mapSize = mapSize;
         this.blur = blur;
         this.attenuation = attenuation;
         this.nearDistance = nearDistance;
         this.farDistance = farDistance;
         this.color = color;
         this.alpha = alpha;
      }
      
      alternativa3d static function getCasterProgram() : §8B§
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var program:§8B§ = casterProgram;
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["dp4 vt0.x, va0, vc0","dp4 vt0.y, va0, vc1","dp4 vt0.z, va0, vc2","mul vt0.xy, vt0.xy, vc4.xy","add vt0.xy, vt0.xy, vc4.zw","mov op.xyz, vt0.xyz","mov op.w, vc3.w","mov v0.xyz, va0.w","mov v0.w, vt0.z"]);
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["mov oc, v0"]);
            program = new §8B§(vertexProgram,fragmentProgram);
            casterProgram = program;
         }
         return program;
      }
      
      public function addCaster(caster:Mesh) : void
      {
         this.casters[this.castersCount] = caster;
         ++this.castersCount;
      }
      
      public function removeCaster(caster:Mesh) : void
      {
         for(var i:int = 0; i < this.castersCount; )
         {
            if(this.casters[i] == caster)
            {
               for(--this.castersCount; i < this.castersCount; )
               {
                  this.casters[i] = this.casters[int(i + 1)];
                  i++;
               }
               this.casters.length = this.castersCount;
               break;
            }
            i++;
         }
      }
      
      public function removeAllCasters() : void
      {
         this.castersCount = 0;
         this.casters.length = 0;
      }
      
      alternativa3d function checkVisibility(camera:Camera3D) : Boolean
      {
         var caster:Object3D = null;
         var root:Object3D = null;
         var vertex:Vertex = null;
         var coord:Number = NaN;
         if(this.castersCount == 0)
         {
            return false;
         }
         if(this.direction != null)
         {
            this.dir.x = this.direction.x;
            this.dir.y = this.direction.y;
            this.dir.z = this.direction.z;
            this.dir.normalize();
         }
         else
         {
            this.dir.x = 0;
            this.dir.y = 0;
            this.dir.z = -1;
         }
         this.light.rotationX = Math.atan2(this.dir.z,Math.sqrt(this.dir.x * this.dir.x + this.dir.y * this.dir.y)) - Math.PI / 2;
         this.light.rotationY = 0;
         this.light.rotationZ = -Math.atan2(this.dir.x,this.dir.y);
         this.light.composeMatrix();
         var ma:Number = this.light.ma;
         var mb:Number = this.light.mb;
         var mc:Number = this.light.mc;
         var md:Number = this.light.md;
         var me:Number = this.light.me;
         var mf:Number = this.light.mf;
         var mg:Number = this.light.mg;
         var mh:Number = this.light.mh;
         var mi:Number = this.light.mi;
         var mj:Number = this.light.mj;
         var mk:Number = this.light.mk;
         var ml:Number = this.light.ml;
         this.light.invertMatrix();
         this.light.ima = this.light.ma;
         this.light.imb = this.light.mb;
         this.light.imc = this.light.mc;
         this.light.imd = this.light.md;
         this.light.ime = this.light.me;
         this.light.imf = this.light.mf;
         this.light.img = this.light.mg;
         this.light.imh = this.light.mh;
         this.light.imi = this.light.mi;
         this.light.imj = this.light.mj;
         this.light.imk = this.light.mk;
         this.light.iml = this.light.ml;
         this.light.boundMinX = 1e+22;
         this.light.boundMinY = 1e+22;
         this.light.boundMinZ = 1e+22;
         this.light.boundMaxX = -1e+22;
         this.light.boundMaxY = -1e+22;
         this.light.boundMaxZ = -1e+22;
         for(var i:int = 0; i < this.castersCount; i++)
         {
            caster = this.casters[i];
            caster.composeMatrix();
            for(root = caster._parent; root != null; )
            {
               Object3D.tA.composeMatrixFromSource(root);
               caster.appendMatrix(Object3D.tA);
               root = root._parent;
            }
            caster.appendMatrix(this.light);
            vertex = this.boundVertexList;
            vertex.x = caster.boundMinX;
            vertex.y = caster.boundMinY;
            vertex.z = caster.boundMinZ;
            vertex = vertex.next;
            vertex.x = caster.boundMaxX;
            vertex.y = caster.boundMinY;
            vertex.z = caster.boundMinZ;
            vertex = vertex.next;
            vertex.x = caster.boundMinX;
            vertex.y = caster.boundMaxY;
            vertex.z = caster.boundMinZ;
            vertex = vertex.next;
            vertex.x = caster.boundMaxX;
            vertex.y = caster.boundMaxY;
            vertex.z = caster.boundMinZ;
            vertex = vertex.next;
            vertex.x = caster.boundMinX;
            vertex.y = caster.boundMinY;
            vertex.z = caster.boundMaxZ;
            vertex = vertex.next;
            vertex.x = caster.boundMaxX;
            vertex.y = caster.boundMinY;
            vertex.z = caster.boundMaxZ;
            vertex = vertex.next;
            vertex.x = caster.boundMinX;
            vertex.y = caster.boundMaxY;
            vertex.z = caster.boundMaxZ;
            vertex = vertex.next;
            vertex.x = caster.boundMaxX;
            vertex.y = caster.boundMaxY;
            vertex.z = caster.boundMaxZ;
            for(vertex = this.boundVertexList; vertex != null; vertex = vertex.next)
            {
               vertex.cameraX = caster.ma * vertex.x + caster.mb * vertex.y + caster.mc * vertex.z + caster.md;
               vertex.cameraY = caster.me * vertex.x + caster.mf * vertex.y + caster.mg * vertex.z + caster.mh;
               vertex.cameraZ = caster.mi * vertex.x + caster.mj * vertex.y + caster.mk * vertex.z + caster.ml;
               if(vertex.cameraX < this.light.boundMinX)
               {
                  this.light.boundMinX = vertex.cameraX;
               }
               if(vertex.cameraX > this.light.boundMaxX)
               {
                  this.light.boundMaxX = vertex.cameraX;
               }
               if(vertex.cameraY < this.light.boundMinY)
               {
                  this.light.boundMinY = vertex.cameraY;
               }
               if(vertex.cameraY > this.light.boundMaxY)
               {
                  this.light.boundMaxY = vertex.cameraY;
               }
               if(vertex.cameraZ < this.light.boundMinZ)
               {
                  this.light.boundMinZ = vertex.cameraZ;
               }
               if(vertex.cameraZ > this.light.boundMaxZ)
               {
                  this.light.boundMaxZ = vertex.cameraZ;
               }
            }
         }
         var cms:int = this.mapSize - 1 - 1 - this.blur - this.blur;
         var w:Number = this.light.boundMaxX - this.light.boundMinX;
         var h:Number = this.light.boundMaxY - this.light.boundMinY;
         var s:Number = w > h ? w : h;
         var px:Number = s / cms;
         var dw:Number = (1 + this.blur) * px;
         var dh:Number = (1 + this.blur) * px;
         if(w > h)
         {
            dh += (Math.ceil((h - 0.01) / (px + px)) * (px + px) - h) * 0.5;
         }
         else
         {
            dw += (Math.ceil((w - 0.01) / (px + px)) * (px + px) - w) * 0.5;
         }
         this.light.boundMinX -= dw;
         this.light.boundMaxX += dw;
         this.light.boundMinY -= dh;
         this.light.boundMaxY += dh;
         this.light.boundMinZ += this.offset;
         this.light.boundMaxZ += this.attenuation;
         this.planeSize = s * this.mapSize / cms;
         if(w > h)
         {
            this.planeX = this.light.boundMinX;
            this.planeY = this.light.boundMinY - (this.light.boundMaxX - this.light.boundMinX - (this.light.boundMaxY - this.light.boundMinY)) * 0.5;
         }
         else
         {
            this.planeX = this.light.boundMinX - (this.light.boundMaxY - this.light.boundMinY - (this.light.boundMaxX - this.light.boundMinX)) * 0.5;
            this.planeY = this.light.boundMinY;
         }
         var far:Number = camera.farClipping;
         camera.farClipping = this.farDistance * camera.shadowsDistanceMultiplier;
         this.light.ma = ma;
         this.light.mb = mb;
         this.light.mc = mc;
         this.light.md = md;
         this.light.me = me;
         this.light.mf = mf;
         this.light.mg = mg;
         this.light.mh = mh;
         this.light.mi = mi;
         this.light.mj = mj;
         this.light.mk = mk;
         this.light.ml = ml;
         this.light.appendMatrix(camera);
         var visible:Boolean = this.cullingInCamera(camera);
         camera.farClipping = far;
         if(visible)
         {
            if(camera.debug && Boolean(camera.checkInDebug(this.light) & Debug.BOUNDS))
            {
               Debug.drawBounds(camera,this.light,this.light.boundMinX,this.light.boundMinY,this.light.boundMinZ,this.light.boundMaxX,this.light.boundMaxY,this.light.boundMaxZ,16711935);
            }
            this.boundMinX = 1e+22;
            this.boundMinY = 1e+22;
            this.boundMinZ = 1e+22;
            this.boundMaxX = -1e+22;
            this.boundMaxY = -1e+22;
            this.boundMaxZ = -1e+22;
            for(vertex = this.boundVertexList; vertex != null; vertex = vertex.next)
            {
               vertex.cameraX = ma * vertex.x + mb * vertex.y + mc * vertex.z + md;
               vertex.cameraY = me * vertex.x + mf * vertex.y + mg * vertex.z + mh;
               vertex.cameraZ = mi * vertex.x + mj * vertex.y + mk * vertex.z + ml;
               if(vertex.cameraX < this.boundMinX)
               {
                  this.boundMinX = vertex.cameraX;
               }
               if(vertex.cameraX > this.boundMaxX)
               {
                  this.boundMaxX = vertex.cameraX;
               }
               if(vertex.cameraY < this.boundMinY)
               {
                  this.boundMinY = vertex.cameraY;
               }
               if(vertex.cameraY > this.boundMaxY)
               {
                  this.boundMaxY = vertex.cameraY;
               }
               if(vertex.cameraZ < this.boundMinZ)
               {
                  this.boundMinZ = vertex.cameraZ;
               }
               if(vertex.cameraZ > this.boundMaxZ)
               {
                  this.boundMaxZ = vertex.cameraZ;
               }
            }
            this.cameraInside = false;
            if(this.minZ <= camera.nearClipping)
            {
               coord = this.light.ima * camera.gmd + this.light.imb * camera.gmh + this.light.imc * camera.gml + this.light.imd;
               if(coord - camera.nearClipping <= this.light.boundMaxX && coord + camera.nearClipping >= this.light.boundMinX)
               {
                  coord = this.light.ime * camera.gmd + this.light.imf * camera.gmh + this.light.img * camera.gml + this.light.imh;
                  if(coord - camera.nearClipping <= this.light.boundMaxY && coord + camera.nearClipping >= this.light.boundMinY)
                  {
                     coord = this.light.imi * camera.gmd + this.light.imj * camera.gmh + this.light.imk * camera.gml + this.light.iml;
                     if(coord - camera.nearClipping <= this.light.boundMaxZ && coord + camera.nearClipping >= this.light.boundMinZ)
                     {
                        this.cameraInside = true;
                     }
                  }
               }
            }
         }
         return visible;
      }
      
      alternativa3d function renderCasters(camera:Camera3D) : void
      {
         var caster:Mesh = null;
         var device:§0!>§ = camera.device;
         var m0:Number = 2 / this.planeSize;
         var m5:Number = -2 / this.planeSize;
         var m10:Number = 1 / (this.light.boundMaxZ - this.attenuation - (this.light.boundMinZ - this.offset));
         var m14:Number = -(this.light.boundMinZ - this.offset) * m10;
         var dx:Number = (this.light.boundMinX + this.light.boundMaxX) * 0.5;
         var dy:Number = (this.light.boundMinY + this.light.boundMaxY) * 0.5;
         for(var i:int = 0; i < this.castersCount; i++)
         {
            caster = this.casters[i];
            caster.prepareResources();
            casterConst[0] = caster.ma * m0;
            casterConst[1] = caster.mb * m0;
            casterConst[2] = caster.mc * m0;
            casterConst[3] = (caster.md - dx) * m0;
            casterConst[4] = caster.me * m5;
            casterConst[5] = caster.mf * m5;
            casterConst[6] = caster.mg * m5;
            casterConst[7] = (caster.mh - dy) * m5;
            casterConst[8] = caster.mi * m10;
            casterConst[9] = caster.mj * m10;
            casterConst[10] = caster.mk * m10;
            casterConst[11] = caster.ml * m10 + m14;
            casterConst[16] = this.textureScaleU;
            casterConst[17] = this.textureScaleV;
            casterConst[18] = 2 * this.textureOffsetU - 1 + this.textureScaleU;
            casterConst[19] = -(2 * this.textureOffsetV - 1 + this.textureScaleV);
            device.§"J§(0,caster.vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
            device.§%&§(Context3DProgramType.VERTEX,0,casterConst,5,false);
            device.§>c§(caster.indexBuffer,0,caster.numTriangles);
         }
         this.clampConst[0] = this.textureOffsetU;
         this.clampConst[1] = this.textureOffsetV;
         this.clampConst[2] = this.textureOffsetU + this.textureScaleU;
         this.clampConst[3] = this.textureOffsetV + this.textureScaleV;
      }
      
      alternativa3d function renderVolume(camera:Camera3D) : void
      {
         var device:§0!>§ = camera.device;
         volumeTransformConst[0] = this.light.ma;
         volumeTransformConst[1] = this.light.mb;
         volumeTransformConst[2] = this.light.mc;
         volumeTransformConst[3] = this.light.md;
         volumeTransformConst[4] = this.light.me;
         volumeTransformConst[5] = this.light.mf;
         volumeTransformConst[6] = this.light.mg;
         volumeTransformConst[7] = this.light.mh;
         volumeTransformConst[8] = this.light.mi;
         volumeTransformConst[9] = this.light.mj;
         volumeTransformConst[10] = this.light.mk;
         volumeTransformConst[11] = this.light.ml;
         volumeTransformConst[12] = this.light.boundMaxX - this.light.boundMinX;
         volumeTransformConst[13] = this.light.boundMaxY - this.light.boundMinY;
         volumeTransformConst[14] = this.light.boundMaxZ - this.light.boundMinZ;
         volumeTransformConst[15] = 1;
         volumeTransformConst[16] = this.light.boundMinX;
         volumeTransformConst[17] = this.light.boundMinY;
         volumeTransformConst[18] = this.light.boundMinZ;
         volumeTransformConst[19] = 1;
         device.§"W§(this.getVolumeProgram());
         device.§"J§(0,volumeVertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
         device.§%&§(Context3DProgramType.VERTEX,11,volumeTransformConst,5,false);
         device.§%&§(Context3DProgramType.VERTEX,16,camera.projection,1);
         device.§%&§(Context3DProgramType.VERTEX,17,camera.correction,1);
         device.§%&§(Context3DProgramType.FRAGMENT,13,volumeFragmentConst,1);
         device.§>c§(volumeIndexBuffer,0,12);
      }
      
      alternativa3d function renderReceivers(camera:Camera3D) : void
      {
         var buffer:int = 0;
         var device:§0!>§ = camera.device;
         var planeZ:Number = this.light.boundMinZ - this.offset;
         var zSize:Number = this.light.boundMaxZ - this.attenuation - planeZ;
         var ma:Number = this.light.ima / this.planeSize;
         var mb:Number = this.light.imb / this.planeSize;
         var mc:Number = this.light.imc / this.planeSize;
         var md:Number = (this.light.imd - this.planeX) / this.planeSize;
         var me:Number = this.light.ime / this.planeSize;
         var mf:Number = this.light.imf / this.planeSize;
         var mg:Number = this.light.img / this.planeSize;
         var mh:Number = (this.light.imh - this.planeY) / this.planeSize;
         var mi:Number = this.light.imi / zSize;
         var mj:Number = this.light.imj / zSize;
         var mk:Number = this.light.imk / zSize;
         var ml:Number = (this.light.iml - planeZ) / zSize;
         this.transformConst[0] = ma * camera.gma + mb * camera.gme + mc * camera.gmi;
         this.transformConst[1] = ma * camera.gmb + mb * camera.gmf + mc * camera.gmj;
         this.transformConst[2] = ma * camera.gmc + mb * camera.gmg + mc * camera.gmk;
         this.transformConst[3] = ma * camera.gmd + mb * camera.gmh + mc * camera.gml + md;
         this.transformConst[4] = me * camera.gma + mf * camera.gme + mg * camera.gmi;
         this.transformConst[5] = me * camera.gmb + mf * camera.gmf + mg * camera.gmj;
         this.transformConst[6] = me * camera.gmc + mf * camera.gmg + mg * camera.gmk;
         this.transformConst[7] = me * camera.gmd + mf * camera.gmh + mg * camera.gml + mh;
         this.transformConst[8] = mi * camera.gma + mj * camera.gme + mk * camera.gmi;
         this.transformConst[9] = mi * camera.gmb + mj * camera.gmf + mk * camera.gmj;
         this.transformConst[10] = mi * camera.gmc + mj * camera.gmg + mk * camera.gmk;
         this.transformConst[11] = mi * camera.gmd + mj * camera.gmh + mk * camera.gml + ml;
         this.transformConst[12] = this.textureScaleU;
         this.transformConst[13] = this.textureScaleV;
         this.transformConst[14] = this.textureOffsetU;
         this.transformConst[15] = this.textureOffsetV;
         var near:Number = this.nearDistance * camera.shadowsDistanceMultiplier;
         var far:Number = this.farDistance * camera.shadowsDistanceMultiplier;
         var distAlpha:Number = 1 - (this.minZ - near) / (far - near);
         if(distAlpha < 0)
         {
            distAlpha = 0;
         }
         if(distAlpha > 1)
         {
            distAlpha = 1;
         }
         this.colorConst[0] = 0;
         this.colorConst[1] = 256;
         this.colorConst[2] = this.attenuation / zSize;
         this.colorConst[3] = 1;
         this.colorConst[4] = this.offset / zSize;
         this.colorConst[5] = this.backFadeRange / zSize;
         this.colorConst[6] = 0;
         this.colorConst[7] = 1;
         this.colorConst[8] = (this.color >> 16 & 0xFF) / 255;
         this.colorConst[9] = (this.color >> 8 & 0xFF) / 255;
         this.colorConst[10] = (this.color & 0xFF) / 255;
         this.colorConst[11] = this.alpha * distAlpha * camera.shadowsStrength;
         device.§"W§(this.getShadowProgram(camera.view.quality,this.cameraInside));
         device.§%&§(Context3DProgramType.VERTEX,11,camera.transform,3);
         device.§%&§(Context3DProgramType.VERTEX,14,camera.projection,1);
         device.§%&§(Context3DProgramType.VERTEX,15,this.transformConst,4);
         device.§%&§(Context3DProgramType.VERTEX,19,camera.correction,1);
         device.§%&§(Context3DProgramType.FRAGMENT,13,this.colorConst,3);
         device.§%&§(Context3DProgramType.FRAGMENT,16,this.clampConst,1);
         for(var i:int = 0; i < this.receiversCount; i++)
         {
            buffer = this.receiversBuffers[i];
            device.§"J§(0,camera.receiversVertexBuffers[buffer],0,Context3DVertexBufferFormat.FLOAT_3);
            device.§>c§(camera.receiversIndexBuffers[buffer],this.receiversFirstIndexes[i],this.receiversNumsTriangles[i]);
            ++camera.numShadows;
         }
         this.receiversCount = 0;
      }
      
      alternativa3d function renderFace(camera:Camera3D, numTriangles:int) : void
      {
         var device:§0!>§ = camera.device;
         device.§"W§(this.getFaceProgram(camera.view.quality));
         device.§4! §(1,this.texture);
         device.§%&§(Context3DProgramType.VERTEX,123,this.transformConst,4);
         device.§%&§(Context3DProgramType.FRAGMENT,13,this.colorConst,3);
         device.§%&§(Context3DProgramType.FRAGMENT,16,this.clampConst,1);
         device.§>c§(TextureMaterial.indexBuffer,0,numTriangles);
      }
      
      private function getVolumeProgram() : §8B§
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var program:§8B§ = volumeProgram;
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["mul vt1.xyz, va0.xyz, vc14.xyz","add vt1.xyz, vt1.xyz, vc15.xyz","mov vt1.w, va0.w","dp4 vt0.x, vt1, vc11","dp4 vt0.y, vt1, vc12","dp4 vt0.z, vt1, vc13","mov vt0.w, vt1.w","mul vt0.xy, vt0.xy, vc17.xy","mul vt1.xy, vc17.zw, vt0.z","add vt0.xy, vt0.xy, vt1.xy","mov op.xw, vt0.xz","neg op.y, vt0.y","mul vt0.z, vt0.z, vc16.z","add op.z, vt0.z, vc16.w"]);
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["mov oc, fc13"]);
            program = new §8B§(vertexProgram,fragmentProgram);
            volumeProgram = program;
         }
         return program;
      }
      
      private function getShadowProgram(quality:Boolean, clamp:Boolean) : §8B§
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var key:int = int(quality) | int(clamp) << 1;
         var program:§8B§ = shadowPrograms[key];
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["dp4 vt0.x, va0, vc11","dp4 vt0.y, va0, vc12","dp4 vt0.z, va0, vc13","mov vt0.w, va0.w","dp4 vt1.x, vt0, vc15","dp4 vt1.y, vt0, vc16","mul vt1.xy, vt1.xy, vc18.xy","add v0.xy, vt1.xy, vc18.zw","dp4 v0.z, vt0, vc17","mov v0.w, vt0.w","div vt1.z, vc14.w, vt0.z","add vt1.z, vt1.z, vc14.z","mul vt1.z, vt1.z, vc14.x","sub vt1.z, vt1.z, vc14.y","div vt1.z, vt1.z, vc14.x","sub vt1.z, vt1.z, vc14.z","div vt1.z, vc14.w, vt1.z","nrm vt2.xyz, vt0.xyz","sub vt1.z, vt0.z, vt1.z","div vt1.z, vt1.z, vt2.z","mul vt2.xyz, vt2.xyz, vt1.z","sub vt0.xyz, vt0.xyz, vt2.xyz","mul vt0.xy, vt0.xy, vc19.xy","mul vt1.xy, vc19.zw, vt0.z","add vt0.xy, vt0.xy, vt1.xy","mov op.xw, vt0.xz","neg op.y, vt0.y","mul vt0.z, vt0.z, vc14.z","add op.z, vt0.z, vc14.w"]);
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["mov ft1, v0" + (clamp ? "rem" : ""),"max ft1, v0, fc16" + (!clamp ? "rem" : ""),"min ft1.xy, ft1.xy, fc16.zw" + (!clamp ? "rem" : ""),"tex ft0, ft1, fs0 <2d,clamp," + (quality ? "linear,miplinear" : "nearest,mipnearest") + ">","sub ft1.w, v0.z, fc13.w","div ft1.z, ft1.w, fc13.z","max ft1.x, ft1.w, fc13.x","mul ft1.x, ft1.x, fc13.y","min ft1.x, ft1.x, fc13.w","sub ft1.y, fc13.w, ft1.x","mul ft1.z, ft1.z, ft1.x","mul ft1.w, ft1.w, ft1.y","add ft1.z, ft1.w, ft1.z","sub ft1.z, fc13.w, ft1.z","mul ft0.w, ft0.w, ft1.z","sub ft1.z, v0.z, fc14.x","div ft1.z, ft1.z, fc14.y","sat ft1.z, ft1.z","mul ft0.w, ft0.w, ft1.z","mov ft0.xyz, fc15.xyz","mul ft0.w, ft0.w, fc15.w","mov oc, ft0"]);
            program = new §8B§(vertexProgram,fragmentProgram);
            shadowPrograms[key] = program;
         }
         return program;
      }
      
      private function getFaceProgram(quality:Boolean) : §8B§
      {
         var vertexProgram:ByteArray = null;
         var fragmentProgram:ByteArray = null;
         var key:int = int(quality);
         var program:§8B§ = facePrograms[key];
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["mov vt0, vc[va0.x]","mov vt0.w, vc3.y","dp4 vt1.x, vt0, vc123","dp4 vt1.y, vt0, vc124","mul vt1.xy, vt1.xy, vc126.xy","add v0.xy, vt1.xy, vc126.zw","dp4 v0.z, vt0, vc125","mov v0.w, vt0.w","div vt1.z, vc3.w, vt0.z","add vt1.z, vt1.z, vc3.z","mul vt1.z, vt1.z, vc3.x","sub vt1.z, vt1.z, vc3.y","div vt1.z, vt1.z, vc3.x","sub vt1.z, vt1.z, vc3.z","div vt1.z, vc3.w, vt1.z","nrm vt2.xyz, vt0.xyz","sub vt1.z, vt0.z, vt1.z","div vt1.z, vt1.z, vt2.z","mul vt2.xyz, vt2.xyz, vt1.z","sub vt0.xyz, vt0.xyz, vt2.xyz","mul vt0.xy, vt0.xy, vc13.xy","mul vt1.xy, vc13.zw, vt0.z","add vt0.xy, vt0.xy, vt1.xy","mov op.xw, vt0.xz","neg op.y, vt0.y","mul vt0.z, vt0.z, vc3.z","add op.z, vt0.z, vc3.w","mov v1, vc[va0.x+1]"]);
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["max ft1, v0, fc16","min ft1.xy, ft1.xy, fc16.zw","tex ft0, ft1, fs1 <2d,clamp," + (quality ? "linear,miplinear" : "nearest,mipnearest") + ">","sub ft1.w, v0.z, fc13.w","div ft1.z, ft1.w, fc13.z","max ft1.x, ft1.w, fc13.x","mul ft1.x, ft1.x, fc13.y","min ft1.x, ft1.x, fc13.w","sub ft1.y, fc13.w, ft1.x","mul ft1.z, ft1.z, ft1.x","mul ft1.w, ft1.w, ft1.y","add ft1.z, ft1.w, ft1.z","sub ft1.z, fc13.w, ft1.z","mul ft0.w, ft0.w, ft1.z","sub ft1.z, v0.z, fc14.x","div ft1.z, ft1.z, fc14.y","sat ft1.z, ft1.z","mul ft0.w, ft0.w, ft1.z","mov ft0.xyz, fc15.xyz","mul ft0.w, ft0.w, fc15.w","tex ft1, v1, fs0 <2d,clamp," + (quality ? "linear,miplinear" : "nearest,mipnearest") + ">","mul ft0.w, ft0.w, ft1.w","mov oc, ft0"]);
            program = new §8B§(vertexProgram,fragmentProgram);
            facePrograms[key] = program;
         }
         return program;
      }
      
      private function cullingInCamera(camera:Camera3D) : Boolean
      {
         var infront:Boolean = false;
         var behind:Boolean = false;
         var vertex:Vertex = this.boundVertexList;
         vertex.x = this.light.boundMinX;
         vertex.y = this.light.boundMinY;
         vertex.z = this.light.boundMinZ;
         vertex = vertex.next;
         vertex.x = this.light.boundMaxX;
         vertex.y = this.light.boundMinY;
         vertex.z = this.light.boundMinZ;
         vertex = vertex.next;
         vertex.x = this.light.boundMinX;
         vertex.y = this.light.boundMaxY;
         vertex.z = this.light.boundMinZ;
         vertex = vertex.next;
         vertex.x = this.light.boundMaxX;
         vertex.y = this.light.boundMaxY;
         vertex.z = this.light.boundMinZ;
         vertex = vertex.next;
         vertex.x = this.light.boundMinX;
         vertex.y = this.light.boundMinY;
         vertex.z = this.light.boundMaxZ;
         vertex = vertex.next;
         vertex.x = this.light.boundMaxX;
         vertex.y = this.light.boundMinY;
         vertex.z = this.light.boundMaxZ;
         vertex = vertex.next;
         vertex.x = this.light.boundMinX;
         vertex.y = this.light.boundMaxY;
         vertex.z = this.light.boundMaxZ;
         vertex = vertex.next;
         vertex.x = this.light.boundMaxX;
         vertex.y = this.light.boundMaxY;
         vertex.z = this.light.boundMaxZ;
         this.minZ = 1e+22;
         for(vertex = this.boundVertexList; vertex != null; vertex = vertex.next)
         {
            vertex.cameraX = this.light.ma * vertex.x + this.light.mb * vertex.y + this.light.mc * vertex.z + this.light.md;
            vertex.cameraY = this.light.me * vertex.x + this.light.mf * vertex.y + this.light.mg * vertex.z + this.light.mh;
            vertex.cameraZ = this.light.mi * vertex.x + this.light.mj * vertex.y + this.light.mk * vertex.z + this.light.ml;
            if(vertex.cameraZ < this.minZ)
            {
               this.minZ = vertex.cameraZ;
            }
         }
         var near:Number = camera.nearClipping;
         vertex = this.boundVertexList;
         infront = false;
         behind = false;
         while(vertex != null)
         {
            if(vertex.cameraZ > near)
            {
               infront = true;
               if(behind)
               {
                  break;
               }
            }
            else
            {
               behind = true;
               if(infront)
               {
                  break;
               }
            }
            vertex = vertex.next;
         }
         if(behind && !infront)
         {
            return false;
         }
         var far:Number = camera.farClipping;
         vertex = this.boundVertexList;
         infront = false;
         behind = false;
         while(vertex != null)
         {
            if(vertex.cameraZ < far)
            {
               infront = true;
               if(behind)
               {
                  break;
               }
            }
            else
            {
               behind = true;
               if(infront)
               {
                  break;
               }
            }
            vertex = vertex.next;
         }
         if(behind && !infront)
         {
            return false;
         }
         vertex = this.boundVertexList;
         infront = false;
         behind = false;
         while(vertex != null)
         {
            if(-vertex.cameraX < vertex.cameraZ)
            {
               infront = true;
               if(behind)
               {
                  break;
               }
            }
            else
            {
               behind = true;
               if(infront)
               {
                  break;
               }
            }
            vertex = vertex.next;
         }
         if(behind && !infront)
         {
            return false;
         }
         vertex = this.boundVertexList;
         infront = false;
         behind = false;
         while(vertex != null)
         {
            if(vertex.cameraX < vertex.cameraZ)
            {
               infront = true;
               if(behind)
               {
                  break;
               }
            }
            else
            {
               behind = true;
               if(infront)
               {
                  break;
               }
            }
            vertex = vertex.next;
         }
         if(behind && !infront)
         {
            return false;
         }
         vertex = this.boundVertexList;
         infront = false;
         behind = false;
         while(vertex != null)
         {
            if(-vertex.cameraY < vertex.cameraZ)
            {
               infront = true;
               if(behind)
               {
                  break;
               }
            }
            else
            {
               behind = true;
               if(infront)
               {
                  break;
               }
            }
            vertex = vertex.next;
         }
         if(behind && !infront)
         {
            return false;
         }
         vertex = this.boundVertexList;
         infront = false;
         behind = false;
         while(vertex != null)
         {
            if(vertex.cameraY < vertex.cameraZ)
            {
               infront = true;
               if(behind)
               {
                  break;
               }
            }
            else
            {
               behind = true;
               if(infront)
               {
                  break;
               }
            }
            vertex = vertex.next;
         }
         if(behind && !infront)
         {
            return false;
         }
         return true;
      }
   }
}

