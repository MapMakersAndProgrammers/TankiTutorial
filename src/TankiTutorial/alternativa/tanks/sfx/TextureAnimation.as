package alternativa.tanks.sfx
{
   import alternativa.engine3d.materials.TextureMaterial;
   
   public class TextureAnimation
   {
      
      public var material:TextureMaterial;
      
      public var frames:Vector.<UVFrame>;
      
      public var fps:Number;
      
      public function TextureAnimation(material:TextureMaterial, frames:Vector.<UVFrame>, fps:Number)
      {
         super();
         this.material = material;
         this.frames = frames;
         this.fps = fps;
      }
   }
}

