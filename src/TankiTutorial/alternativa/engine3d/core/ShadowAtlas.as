package alternativa.engine3d.core
{
   import §5e§.§-!$§;
   import §5e§.§0!>§;
   import §5e§.§1!8§;
   import §5e§.§8B§;
   import §5e§.§`c§;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.materials.Material;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.utils.ByteArray;
   
   use namespace alternativa3d;
   
   public class ShadowAtlas
   {
      
      alternativa3d static const sizeLimit:int = 1024;
      
      private static var blurPrograms:Array = new Array();
      
      private static var blurVertexBuffer:§-!$§ = new §-!$§(Vector.<Number>([-1,1,0,0,0,-1,-1,0,0,1,1,-1,0,1,1,1,1,0,1,0]),5);
      
      private static var blurIndexBuffer:§`c§ = new §`c§(Vector.<uint>([0,1,3,2,3,1]));
      
      private static var blurConst:Vector.<Number> = Vector.<Number>([0,0,0,1]);
      
      alternativa3d var shadows:Vector.<Shadow> = new Vector.<Shadow>();
      
      alternativa3d var shadowsCount:int = 0;
      
      private var mapSize:int;
      
      private var blur:int;
      
      private var maps:Array = new Array();
      
      private var map1:§1!8§;
      
      private var map2:§1!8§;
      
      public function ShadowAtlas(mapSize:int, blur:int)
      {
         super();
         this.mapSize = mapSize;
         this.blur = blur;
      }
      
      alternativa3d function renderCasters(camera:Camera3D) : void
      {
         var shadow:Shadow = null;
         var device:§0!>§ = camera.device;
         var max:int = sizeLimit / this.mapSize;
         var rows:int = Math.ceil(this.shadowsCount / max);
         var cols:int = this.shadowsCount > max ? max : this.shadowsCount;
         rows = 1 << Math.ceil(Math.log(rows) / Math.LN2);
         cols = 1 << Math.ceil(Math.log(cols) / Math.LN2);
         if(rows > max)
         {
            rows = max;
            this.shadowsCount = rows * cols;
         }
         var key1:int = rows << 8 | cols;
         this.map1 = this.maps[key1];
         var key2:int = 1 << 16 | key1;
         this.map2 = this.maps[key2];
         if(this.map1 == null)
         {
            this.map1 = new §1!8§(cols * this.mapSize,rows * this.mapSize);
            this.map2 = new §1!8§(cols * this.mapSize,rows * this.mapSize);
            this.maps[key1] = this.map1;
            this.maps[key2] = this.map2;
         }
         device.§!0§(this.map1,true);
         device.§9+§(0,0,0,0,0);
         for(var i:int = 0; i < this.shadowsCount; i++)
         {
            shadow = this.shadows[i];
            shadow.texture = this.map1;
            shadow.textureScaleU = 1 / cols;
            shadow.textureScaleV = 1 / rows;
            shadow.textureOffsetU = i % cols / cols;
            shadow.textureOffsetV = int(i / cols) / rows;
            shadow.renderCasters(camera);
         }
      }
      
      alternativa3d function renderBlur(camera:Camera3D) : void
      {
         var device:§0!>§ = camera.device;
         if(this.blur > 0)
         {
            blurConst[2] = 1 + this.blur + this.blur;
            device.§"J§(0,blurVertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
            device.§"J§(1,blurVertexBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
            device.§!0§(this.map2,false);
            device.§9+§(0,0,0,0);
            device.§"W§(this.getBlurProgram(1,this.blur));
            device.§4! §(0,this.map1);
            blurConst[0] = 1 / this.map1.§[]§;
            blurConst[1] = this.blur / this.map1.§[]§;
            device.§%&§(Context3DProgramType.FRAGMENT,0,blurConst,1);
            device.§>c§(blurIndexBuffer,0,2);
            device.§!0§(this.map1,false);
            device.§9+§(0,0,0,0);
            device.§"W§(this.getBlurProgram(2,this.blur));
            device.§4! §(0,this.map2);
            blurConst[0] = 1 / this.map1.§'d§;
            blurConst[1] = this.blur / this.map1.§'d§;
            device.§%&§(Context3DProgramType.FRAGMENT,0,blurConst,1);
            device.§>c§(blurIndexBuffer,0,2);
         }
      }
      
      alternativa3d function clear() : void
      {
         var shadow:Shadow = null;
         for(var i:int = 0; i < this.shadowsCount; i++)
         {
            shadow = this.shadows[i];
            shadow.texture = null;
         }
         this.shadows.length = 0;
         this.shadowsCount = 0;
      }
      
      private function getBlurProgram(pass:int, blur:int) : §8B§
      {
         var vertexProgram:ByteArray = null;
         var i:int = 0;
         var code:Array = null;
         var fragmentProgram:ByteArray = null;
         var key:int = (pass << 16) + blur;
         var program:§8B§ = blurPrograms[key];
         if(program == null)
         {
            vertexProgram = Material.compileProgram(Context3DProgramType.VERTEX,["mov op, va0","mov v0, va1"]);
            if(pass == 1)
            {
               code = ["mov ft1, v0","tex ft3, ft1, fs0 <2d,clamp,nearest,mipnone>","sub ft1.x, v0.x, fc0.y"];
               for(i = -blur; i <= blur; i++)
               {
                  if(i != 0)
                  {
                     code.push("tex ft2, ft1, fs0 <2d,clamp,nearest,mipnone>","add ft3.w, ft3.w, ft2.w");
                  }
                  code.push("add ft1.x, ft1.x, fc0.x");
               }
               code.push("div ft3.w, ft3.w, fc0.z","mov oc, ft3");
            }
            else
            {
               code = ["mov ft1, v0","tex ft3, ft1, fs0 <2d,clamp,nearest,mipnone>","sub ft1.y, v0.y, fc0.y"];
               for(i = -blur; i <= blur; i++)
               {
                  if(i != 0)
                  {
                     code.push("tex ft2, ft1, fs0 <2d,clamp,nearest,mipnone>","add ft3.w, ft3.w, ft2.w");
                  }
                  code.push("add ft1.y, ft1.y, fc0.x");
               }
               code.push("div ft3.w, ft3.w, fc0.z","mov oc, ft3");
            }
            fragmentProgram = Material.compileProgram(Context3DProgramType.FRAGMENT,code);
            program = new §8B§(vertexProgram,fragmentProgram);
            blurPrograms[key] = program;
         }
         return program;
      }
   }
}

