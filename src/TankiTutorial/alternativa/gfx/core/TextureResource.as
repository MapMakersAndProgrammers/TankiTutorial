package alternativa.gfx.core
{
   import flash.display3D.textures.TextureBase;
   
   public class TextureResource extends Resource
   {
      
      §§namespace("http://alternativaplatform.com/en/alternativagfx") var tylu:Vector.<TextureBase> = new Vector.<TextureBase>(4);
      
      public function TextureResource()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.tylu[i] != null)
            {
               this.tylu[i].dispose();
               this.tylu[i] = null;
            }
         }
      }
      
      override public function reset() : void
      {
         super.reset();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.tylu[i] != null)
            {
               this.tylu[i].dispose();
               this.tylu[i] = null;
            }
         }
      }
   }
}

