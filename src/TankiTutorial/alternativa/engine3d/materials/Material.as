package alternativa.engine3d.materials
{
   import §5e§.§-!$§;
   import §5e§.§`c§;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   use namespace alternativa3d;
   
   public class Material
   {
      
      protected static var uvCorrection:Vector.<Number> = Vector.<Number>([1,1,0,1]);
      
      public var name:String;
      
      alternativa3d var useVerticesNormals:Boolean = true;
      
      public function Material()
      {
         super();
      }
      
      alternativa3d static function compileProgram(mode:String, code:Array) : ByteArray
      {
         var line:String = null;
         var string:String = "";
         var length:int = int(code.length);
         for(var i:int = 0; i < length; i++)
         {
            line = code[i];
            if(line.indexOf("rem") < 0)
            {
               string += line + (i < length - 1 ? " \n" : "");
            }
         }
         return new AGALMiniAssembler().assemble(mode,string);
      }
      
      alternativa3d function get transparent() : Boolean
      {
         return false;
      }
      
      public function clone() : Material
      {
         var res:Material = new Material();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      protected function clonePropertiesFrom(source:Material) : void
      {
         this.name = source.name;
         this.useVerticesNormals = source.useVerticesNormals;
      }
      
      public function toString() : String
      {
         var className:String = getQualifiedClassName(this);
         return "[" + className.substr(className.indexOf("::") + 2) + " " + this.name + "]";
      }
      
      alternativa3d function drawOpaque(camera:Camera3D, vertexBuffer:§-!$§, indexBuffer:§`c§, firstIndex:int, numTriangles:int, object:Object3D) : void
      {
      }
      
      alternativa3d function drawTransparent(camera:Camera3D, list:Face, object:Object3D) : void
      {
         this.clearLinks(list);
      }
      
      alternativa3d function clearLinks(list:Face) : void
      {
         for(var next:Face = null; list != null; )
         {
            next = list.processNext;
            list.processNext = null;
            list = next;
         }
      }
   }
}

