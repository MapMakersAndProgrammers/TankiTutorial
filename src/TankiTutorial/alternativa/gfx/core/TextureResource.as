package alternativa.gfx.core
{
   import flash.display3D.textures.TextureBase;
   import alternativa.gfx.alternativagfx;
   
   use namespace alternativagfx;

   public class TextureResource extends Resource
   {
      
      alternativagfx var textures:Vector.<TextureBase> = new Vector.<TextureBase>(4);
      
      public function TextureResource()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.textures[i] != null)
            {
               this.textures[i].dispose();
               this.textures[i] = null;
            }
         }
      }
      
      override public function reset() : void
      {
         super.reset();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.textures[i] != null)
            {
               this.textures[i].dispose();
               this.textures[i] = null;
            }
         }
      }
   }
}

