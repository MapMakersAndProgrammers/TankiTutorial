package alternativa.tanks
{
   import alternativa.tanks.battle.Renderer;
   
   public class RenderGroup
   {
      
      private var renderers:Vector.<Renderer> = new Vector.<Renderer>();
      
      private var numRenderers:int;
      
      public function RenderGroup()
      {
         super();
      }
      
      public function addRenderer(renderer:Renderer) : void
      {
         if(this.renderers.indexOf(renderer) < 0)
         {
            this.renderers[this.numRenderers++] = renderer;
         }
      }
      
      public function removeRenderer(renderer:Renderer) : void
      {
         var index:int = this.renderers.indexOf(renderer);
         if(index >= 0)
         {
            this.renderers[index] = this.renderers[--this.numRenderers];
            this.renderers[this.numRenderers] = null;
         }
      }
      
      public function render(time:int, deltaTime:int) : void
      {
         var i:int = 0;
         while(i < this.numRenderers)
         {
            Renderer(this.renderers[i]).render(time,deltaTime);
            i++;
         }
      }
   }
}

