package alternativa.engine3d.core
{
   import alternativa.gfx.core.BitmapTextureResource
   import alternativa.gfx.core.VertexBufferResource;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.RenderTargetTextureResource;
   import alternativa.gfx.core.ProgramResource;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Sprite3D;
   import flash.display.BitmapData;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class ShadowMap
   {
      
      private static const sizeLimit:int = 2048;
      
      private var opaqueProgram:ProgramResource;
      
      private var transparentProgram:ProgramResource;
      
      private var spriteProgram:ProgramResource;
      
      private var spriteVertexBuffer:VertexBufferResource;
      
      private var spriteIndexBuffer:IndexBufferResource;
      
      alternativa3d var transform:Vector.<Number>;
      
      alternativa3d var params:Vector.<Number>;
      
      private var coords:Vector.<Number>;
      
      private var fragment:Vector.<Number>;
      
      private var alphatest:Vector.<Number>;
      
      private var scissor:Rectangle;
      
      alternativa3d var map:RenderTargetTextureResource;
      
      alternativa3d var noise:BitmapTextureResource
      
      private var noiseSize:int = 64;
      
      private var noiseAngle:Number = 0.7853981633974483;
      
      private var noiseRadius:Number = 1.3;
      
      private var noiseRandom:Number = 0.3;
      
      public var mapSize:int;
      
      public var nearDistance:Number;
      
      public var farDistance:Number;
      
      public var bias:Number = 0;
      
      public var additionalSpace:Number = 0;
      
      public var alphaThreshold:Number = 0.1;
      
      private var defaultLight:DirectionalLight;
      
      private var boundVertexList:Vertex;
      
      private var light:DirectionalLight;
      
      private var dirZ:Number;
      
      private var planeX:Number;
      
      private var planeY:Number;
      
      private var planeSize:Number;
      
      private var pixel:Number;
      
      alternativa3d var boundMinX:Number;
      
      alternativa3d var boundMinY:Number;
      
      alternativa3d var boundMinZ:Number;
      
      alternativa3d var boundMaxX:Number;
      
      alternativa3d var boundMaxY:Number;
      
      alternativa3d var boundMaxZ:Number;
      
      public function ShadowMap(mapSize:int, nearDistance:Number, farDistance:Number, bias:Number = 0, additionalSpace:Number = 0)
      {
         var j:int = 0;
         var rnd:Number = NaN;
         var sin:int = 0;
         var cos:int = 0;
         var len:int = 0;
         this.spriteVertexBuffer = new VertexBufferResource(Vector.<Number>([0,2,4,6]),1);
         this.spriteIndexBuffer = new IndexBufferResource(Vector.<uint>([0,1,3,1,2,3]));
         this.transform = Vector.<Number>([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]);
         this.params = Vector.<Number>([-255 * 2048,-2048,2048,1,0,0,0,1,0,0,0.5,1,0,0,0,1,0,0,0,1]);
         this.coords = Vector.<Number>([0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,1 / 255,1]);
         this.fragment = Vector.<Number>([1 / 255,0,1,1]);
         this.alphatest = Vector.<Number>([0,0,0,1]);
         this.scissor = new Rectangle();
         this.defaultLight = new DirectionalLight(8355711);
         this.boundVertexList = Vertex.createList(8);
         super();
         if(mapSize > sizeLimit)
         {
            throw new Error("Value of mapSize too big.");
         }
         var pow:Number = Math.log(mapSize) / Math.LN2;
         if(pow != int(pow))
         {
            throw new Error("Value of mapSize must be power of 2.");
         }
         this.mapSize = mapSize;
         this.nearDistance = nearDistance;
         this.farDistance = farDistance;
         this.bias = bias;
         this.additionalSpace = additionalSpace;
         this.defaultLight.rotationX = Math.PI;
         this.map = new RenderTargetTextureResource(mapSize,mapSize);
         var data:Vector.<uint> = new Vector.<uint>();
         var dataLength:int = 0;
         for(var i:int = 0; i < this.noiseSize; i++)
         {
            for(j = 0; j < this.noiseSize; j++)
            {
               rnd = Math.random() * this.noiseAngle;
               sin = Math.sin(rnd) * 255;
               cos = Math.cos(rnd) * 255;
               len = (this.noiseRandom + Math.random() * (1 - this.noiseRandom)) * 255;
               data[dataLength] = 255 << 24 | sin << 16 | cos << 8 | len;
               dataLength++;
            }
         }
         this.noise = new BitmapTextureResource(new BitmapData(this.noiseSize,this.noiseSize,false,0),false);
         this.noise.bitmapData.setVector(this.noise.bitmapData.rect,data);
      }
      
      alternativa3d function calculateBounds(camera:Camera3D) : void
      {
         if(camera.directionalLight != null)
         {
            this.light = camera.directionalLight;
         }
         else
         {
            this.light = this.defaultLight;
         }
         this.light.composeMatrix();
         this.dirZ = this.light.mk;
         this.light.calculateInverseMatrix();
         var ma:Number = this.light.ima;
         var mb:Number = this.light.imb;
         var mc:Number = this.light.imc;
         var md:Number = this.light.imd;
         var me:Number = this.light.ime;
         var mf:Number = this.light.imf;
         var mg:Number = this.light.img;
         var mh:Number = this.light.imh;
         var mi:Number = this.light.imi;
         var mj:Number = this.light.imj;
         var mk:Number = this.light.imk;
         var ml:Number = this.light.iml;
         this.light.ima = ma * camera.gma + mb * camera.gme + mc * camera.gmi;
         this.light.imb = ma * camera.gmb + mb * camera.gmf + mc * camera.gmj;
         this.light.imc = ma * camera.gmc + mb * camera.gmg + mc * camera.gmk;
         this.light.imd = ma * camera.gmd + mb * camera.gmh + mc * camera.gml + md;
         this.light.ime = me * camera.gma + mf * camera.gme + mg * camera.gmi;
         this.light.imf = me * camera.gmb + mf * camera.gmf + mg * camera.gmj;
         this.light.img = me * camera.gmc + mf * camera.gmg + mg * camera.gmk;
         this.light.imh = me * camera.gmd + mf * camera.gmh + mg * camera.gml + mh;
         this.light.imi = mi * camera.gma + mj * camera.gme + mk * camera.gmi;
         this.light.imj = mi * camera.gmb + mj * camera.gmf + mk * camera.gmj;
         this.light.imk = mi * camera.gmc + mj * camera.gmg + mk * camera.gmk;
         this.light.iml = mi * camera.gmd + mj * camera.gmh + mk * camera.gml + ml;
         var vertex:Vertex = this.boundVertexList;
         vertex.x = -camera.nearClipping;
         vertex.y = -camera.nearClipping;
         vertex.z = camera.nearClipping;
         vertex = vertex.next;
         vertex.x = -camera.nearClipping;
         vertex.y = camera.nearClipping;
         vertex.z = camera.nearClipping;
         vertex = vertex.next;
         vertex.x = camera.nearClipping;
         vertex.y = camera.nearClipping;
         vertex.z = camera.nearClipping;
         vertex = vertex.next;
         vertex.x = camera.nearClipping;
         vertex.y = -camera.nearClipping;
         vertex.z = camera.nearClipping;
         vertex = vertex.next;
         vertex.x = -this.farDistance;
         vertex.y = -this.farDistance;
         vertex.z = this.farDistance;
         vertex = vertex.next;
         vertex.x = -this.farDistance;
         vertex.y = this.farDistance;
         vertex.z = this.farDistance;
         vertex = vertex.next;
         vertex.x = this.farDistance;
         vertex.y = this.farDistance;
         vertex.z = this.farDistance;
         vertex = vertex.next;
         vertex.x = this.farDistance;
         vertex.y = -this.farDistance;
         vertex.z = this.farDistance;
         this.light.boundMinX = 1e+22;
         this.light.boundMinY = 1e+22;
         this.light.boundMinZ = 1e+22;
         this.light.boundMaxX = -1e+22;
         this.light.boundMaxY = -1e+22;
         this.light.boundMaxZ = -1e+22;
         for(vertex = this.boundVertexList; vertex != null; vertex = vertex.next)
         {
            vertex.cameraX = this.light.ima * vertex.x + this.light.imb * vertex.y + this.light.imc * vertex.z + this.light.imd;
            vertex.cameraY = this.light.ime * vertex.x + this.light.imf * vertex.y + this.light.img * vertex.z + this.light.imh;
            vertex.cameraZ = this.light.imi * vertex.x + this.light.imj * vertex.y + this.light.imk * vertex.z + this.light.iml;
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
         var a:Vertex = this.boundVertexList;
         var b:Vertex = this.boundVertexList.next.next.next.next.next.next;
         var c:Vertex = this.boundVertexList.next.next.next.next;
         var abx:Number = b.cameraX - a.cameraX;
         var aby:Number = b.cameraY - a.cameraY;
         var abz:Number = b.cameraZ - a.cameraZ;
         var bcx:Number = c.cameraX - b.cameraX;
         var bcy:Number = c.cameraY - b.cameraY;
         var bcz:Number = c.cameraZ - b.cameraZ;
         var ab:Number = abx * abx + aby * aby + abz * abz;
         var bc:Number = bcx * bcx + bcy * bcy + bcz * bcz;
         var blur:int = Math.ceil(this.noiseRadius);
         this.planeSize = ab > bc ? Math.sqrt(ab) : Math.sqrt(bc);
         this.pixel = this.planeSize / (this.mapSize - 1 - this.noiseRadius);
         this.planeSize += blur * this.pixel * 2;
         this.light.boundMinX -= blur * this.pixel;
         this.light.boundMaxX += blur * this.pixel;
         this.light.boundMinY -= blur * this.pixel;
         this.light.boundMaxY += blur * this.pixel;
         this.light.boundMinZ -= this.additionalSpace;
         vertex = this.boundVertexList;
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
         this.boundMinX = 1e+22;
         this.boundMinY = 1e+22;
         this.boundMinZ = 1e+22;
         this.boundMaxX = -1e+22;
         this.boundMaxY = -1e+22;
         this.boundMaxZ = -1e+22;
         for(vertex = this.boundVertexList; vertex != null; vertex = vertex.next)
         {
            vertex.cameraX = this.light.ma * vertex.x + this.light.mb * vertex.y + this.light.mc * vertex.z + this.light.md;
            vertex.cameraY = this.light.me * vertex.x + this.light.mf * vertex.y + this.light.mg * vertex.z + this.light.mh;
            vertex.cameraZ = this.light.mi * vertex.x + this.light.mj * vertex.y + this.light.mk * vertex.z + this.light.ml;
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
      }
      
      alternativa3d function render(camera:Camera3D, objects:Vector.<Object3D>, objectsLength:int) : void
      {
         var object:Object3D = null;
         var vertexBuffer:VertexBufferResource = null;
         var indexBuffer:IndexBufferResource = null;
         var numTriangles:int = 0;
         var transparent:Boolean = false;
         var material:TextureMaterial = null;
         var sprite:Sprite3D = null;
         var ww:Number = NaN;
         var hh:Number = NaN;
         var tan:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var bz:Number = NaN;
         var deltaU:Number = NaN;
         var deltaV:Number = NaN;
         var mesh:Mesh = null;
         var bsp:BSP = null;
         var device:Device = camera.device;
         this.planeX = Math.floor(this.light.boundMinX / this.pixel) * this.pixel;
         this.planeY = Math.floor(this.light.boundMinY / this.pixel) * this.pixel;
         this.scissor.width = Math.ceil(this.light.boundMaxX / this.pixel) - this.planeX / this.pixel;
         this.scissor.height = Math.ceil(this.light.boundMaxY / this.pixel) - this.planeY / this.pixel;
         var sx:Number = 2 / this.planeSize;
         var sy:Number = -2 / this.planeSize;
         var sz:Number = 255 / (this.light.boundMaxZ - this.light.boundMinZ);
         var dx:Number = -(this.planeX + this.planeSize * 0.5) * sx;
         var dy:Number = -(this.planeY + this.planeSize * 0.5) * sy;
         var dz:Number = -this.light.boundMinZ * sz;
         if(this.mapSize != this.map.width)
         {
            this.map.dispose();
            this.map = new RenderTargetTextureResource(this.mapSize,this.mapSize);
         }
         device.setRenderToTexture(this.map,true);
         device.clear(1,0,0);
         device.setScissorRectangle(this.scissor);
         this.transform[14] = 1 / 255;
         for(var i:int = 0; i < objectsLength; i++)
         {
            object = objects[i];
            vertexBuffer = null;
            indexBuffer = null;
            transparent = false;
            if(object is Sprite3D)
            {
               sprite = Sprite3D(object);
               material = TextureMaterial(sprite.material);
               ww = sprite.width;
               hh = sprite.height;
               if(sprite.autoSize)
               {
                  deltaU = sprite.bottomRightU - sprite.topLeftU;
                  deltaV = sprite.bottomRightV - sprite.topLeftV;
                  ww = material.texture.width * deltaU;
                  hh = material.texture.height * deltaV;
               }
               tan = Math.tan(Math.asin(-this.dirZ));
               ww *= sprite.scaleX;
               hh *= sprite.scaleY;
               x = this.light.ima * object.md + this.light.imb * object.mh + this.light.imc * object.ml + this.light.imd;
               y = this.light.ime * object.md + this.light.imf * object.mh + this.light.img * object.ml + this.light.imh;
               z = this.light.imi * object.md + this.light.imj * object.mh + this.light.imk * object.ml + this.light.iml;
               y += Math.sin(-this.dirZ) * hh / 4;
               z -= Math.cos(-this.dirZ) * hh / 4;
               ax = -ww * sprite.originX;
               ay = -hh * sprite.originY;
               az = -ay / tan;
               bx = ax + ww;
               by = ay + hh;
               bz = -by / tan;
               ax = (ax + x) * sx + dx;
               ay = (ay + y) * sy + dy;
               az = (az + z) * sz + dz;
               bx = (bx + x) * sx + dx;
               by = (by + y) * sy + dy;
               bz = (bz + z) * sz + dz;
               az -= this.bias * sz * 30 / tan;
               bz -= this.bias * sz * 30 / tan;
               this.coords[0] = ax;
               this.coords[1] = ay;
               this.coords[2] = az;
               this.coords[4] = 0;
               this.coords[5] = 0;
               this.coords[8] = ax;
               this.coords[9] = by;
               this.coords[10] = bz;
               this.coords[12] = 0;
               this.coords[13] = 1;
               this.coords[16] = bx;
               this.coords[17] = by;
               this.coords[18] = bz;
               this.coords[20] = 1;
               this.coords[21] = 1;
               this.coords[24] = bx;
               this.coords[25] = ay;
               this.coords[26] = az;
               this.coords[28] = 1;
               this.coords[29] = 0;
               vertexBuffer = this.spriteVertexBuffer;
               indexBuffer = this.spriteIndexBuffer;
               numTriangles = 2;
               transparent = true;
               device.setProgram(this.getProgram(true,true));
               device.setVertexBufferAt(0,vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_1);
               device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,this.coords,9,false);
            }
            else
            {
               this.transform[0] = (this.light.ima * object.ma + this.light.imb * object.me + this.light.imc * object.mi) * sx;
               this.transform[1] = (this.light.ima * object.mb + this.light.imb * object.mf + this.light.imc * object.mj) * sx;
               this.transform[2] = (this.light.ima * object.mc + this.light.imb * object.mg + this.light.imc * object.mk) * sx;
               this.transform[3] = (this.light.ima * object.md + this.light.imb * object.mh + this.light.imc * object.ml + this.light.imd) * sx + dx;
               this.transform[4] = (this.light.ime * object.ma + this.light.imf * object.me + this.light.img * object.mi) * sy;
               this.transform[5] = (this.light.ime * object.mb + this.light.imf * object.mf + this.light.img * object.mj) * sy;
               this.transform[6] = (this.light.ime * object.mc + this.light.imf * object.mg + this.light.img * object.mk) * sy;
               this.transform[7] = (this.light.ime * object.md + this.light.imf * object.mh + this.light.img * object.ml + this.light.imh) * sy + dy;
               this.transform[8] = (this.light.imi * object.ma + this.light.imj * object.me + this.light.imk * object.mi) * sz;
               this.transform[9] = (this.light.imi * object.mb + this.light.imj * object.mf + this.light.imk * object.mj) * sz;
               this.transform[10] = (this.light.imi * object.mc + this.light.imj * object.mg + this.light.imk * object.mk) * sz;
               this.transform[11] = (this.light.imi * object.md + this.light.imj * object.mh + this.light.imk * object.ml + this.light.iml) * sz + dz;
               if(object is Mesh)
               {
                  mesh = Mesh(object);
                  mesh.prepareResources();
                  vertexBuffer = mesh.vertexBuffer;
                  indexBuffer = mesh.indexBuffer;
                  numTriangles = mesh.numTriangles;
                  device.setProgram(this.getProgram(false,false));
               }
               else if(object is BSP)
               {
                  bsp = BSP(object);
                  bsp.prepareResources();
                  vertexBuffer = bsp.vertexBuffer;
                  indexBuffer = bsp.indexBuffer;
                  numTriangles = bsp.numTriangles;
                  transparent = true;
                  device.setProgram(this.getProgram(true,false));
                  material = TextureMaterial(Face(bsp.faces[0]).material);
                  device.setVertexBufferAt(1,vertexBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
               }
               device.setVertexBufferAt(0,vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
               device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,this.transform,4,false);
            }
            if(vertexBuffer != null && indexBuffer != null)
            {
               if(transparent)
               {
                  device.setTextureAt(0,material.textureResource);
                  this.alphatest[0] = material.textureResource.correctionU;
                  this.alphatest[1] = material.textureResource.correctionV;
                  this.alphatest[3] = object is Sprite3D ? 0.99 : this.alphaThreshold;
                  device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,this.alphatest,1);
               }
               device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.fragment,1);
               device.drawTriangles(indexBuffer,0,numTriangles);
            }
            if(transparent)
            {
               device.setTextureAt(0,null);
               device.setVertexBufferAt(1,null);
            }
         }
         device.setScissorRectangle(null);
         sx = 1 / this.planeSize;
         sy = 1 / this.planeSize;
         dx = -this.planeX * sx;
         dy = -this.planeY * sy;
         this.transform[0] = this.light.ima * sx;
         this.transform[1] = this.light.imb * sx;
         this.transform[2] = this.light.imc * sx;
         this.transform[3] = this.light.imd * sx + dx;
         this.transform[4] = this.light.ime * sy;
         this.transform[5] = this.light.imf * sy;
         this.transform[6] = this.light.img * sy;
         this.transform[7] = this.light.imh * sy + dy;
         this.transform[8] = this.light.imi * sz;
         this.transform[9] = this.light.imj * sz;
         this.transform[10] = this.light.imk * sz;
         this.transform[11] = this.light.iml * sz + dz;
         this.transform[12] = this.nearDistance;
         this.transform[13] = this.farDistance - this.nearDistance;
         this.transform[14] = -sz;
         this.params[4] = this.noiseRadius / this.mapSize;
         this.params[5] = 8;
         this.params[6] = this.bias * sz * 30;
         this.params[7] = camera.directionalLight != null ? camera.directionalLightStrength * camera.shadowMapStrength : 0;
         this.params[8] = camera.view._width / this.noiseSize;
         this.params[9] = camera.view._height / this.noiseSize;
         this.params[12] = Math.cos(this.noiseAngle);
         this.params[13] = Math.sin(this.noiseAngle);
         this.params[16] = -Math.sin(this.noiseAngle);
         this.params[17] = Math.cos(this.noiseAngle);
      }
      
      public function dispose() : void
      {
         this.map.reset();
         this.noise.reset();
      }
      
      private function getProgram(transparent:Boolean, sprite:Boolean) : ProgramResource
      {
         var fragmentProgram:ByteArray = null;
         var vertexProgram:ByteArray = null;
         var program:ProgramResource = transparent ? (sprite ? this.spriteProgram : this.transparentProgram) : this.opaqueProgram;
         if(program == null)
         {
            if(transparent)
            {
               if(sprite)
               {
                  vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["mov vt0, vc[va0.x]","mov v0, vt0","mul vt0.z, vt0.z, vc8.z","mov op, vt0","mov v1, vc[va0.x+1]"]);
               }
               else
               {
                  vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["dp4 vt0.x, va0, vc0","dp4 vt0.y, va0, vc1","dp4 vt0.z, va0, vc2","mov vt0.w, vc3.w","mov v0, vt0","mul vt0.z, vt0.z, vc3.z","mov op, vt0","mov v1, va1"]);
               }
               fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["mul ft0, v1, fc1","tex ft1, ft0, fs0 <2d,clamp,linear,mipnone>","sub ft1.w, ft1.w, fc1.w","kil ft1.w","frc ft0.y, v0.z","sub ft0.x, v0.z, ft0.y","mul ft0.x, ft0.x, fc0.x","mov ft0.z, fc0.z","mov ft0.w, fc0.w","mov oc, ft0"]);
            }
            else
            {
               vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["dp4 vt0.x, va0, vc0","dp4 vt0.y, va0, vc1","dp4 vt0.z, va0, vc2","mov vt0.w, vc3.w","mov v0, vt0","mul vt0.z, vt0.z, vc3.z","mov op, vt0"]);
               fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,["frc ft0.y, v0.z","sub ft0.x, v0.z, ft0.y","mul ft0.x, ft0.x, fc0.x","mov ft0.z, fc0.z","mov ft0.w, fc0.w","mov oc, ft0"]);
            }
            program = new ProgramResource(vertexProgram,fragmentProgram);
            if(transparent)
            {
               if(sprite)
               {
                  this.spriteProgram = program;
               }
               else
               {
                  this.transparentProgram = program;
               }
            }
            else
            {
               this.opaqueProgram = program;
            }
         }
         return program;
      }
   }
}

