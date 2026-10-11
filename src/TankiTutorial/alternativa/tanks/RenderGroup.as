package alternativa.tanks
{
   import alternativa.tanks.battle.Renderer;
   
   public class RenderGroup
   {
      
      private var renderers:Vector.<Renderer> = new Vector.<Renderer>();
      
      private var jiso:int;
      
      public function RenderGroup()
      {
         super();
      }
      
      public function addRenderer(param1:Renderer) : void
      {
         if(this.renderers.indexOf(param1) < 0)
         {
            this.renderers[this.jiso++] = param1;
         }
      }
      
      public function removeRenderer(param1:Renderer) : void
      {
         var _loc2_:int = this.renderers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.renderers[_loc2_] = this.renderers[--this.jiso];
            this.renderers[this.jiso] = null;
         }
      }
      
      public function render(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.jiso)
         {
            Renderer(this.renderers[_loc3_]).render(param1,param2);
            _loc3_++;
         }
      }
   }
}

