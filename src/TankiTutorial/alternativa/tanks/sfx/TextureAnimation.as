package alternativa.tanks.sfx
{
   import alternativa.engine3d.materials.TextureMaterial;
   
   public class TextureAnimation
   {
      
      public var material:TextureMaterial;
      
      public var qyvoladeg:Vector.<UVFrame>;
      
      public var fps:Number;
      
      public function TextureAnimation(param1:TextureMaterial, param2:Vector.<UVFrame>, param3:Number)
      {
         super();
         this.material = param1;
         this.qyvoladeg = param2;
         this.fps = param3;
      }
   }
}

