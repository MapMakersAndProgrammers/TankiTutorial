package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   
   public class Resource
   {
      
      §§namespace("http://alternativaplatform.com/en/alternativagfx") var jewu:Vector.<int> = Vector.<int>([-1,-1,-1,-1]);
      
      public function Resource()
      {
         super();
      }
      
      public function dispose() : void
      {
         for(var i:int = 0; i < 4; i++)
         {
            this.jewu[i] = -1;
         }
      }
      
      public function reset() : void
      {
         for(var i:int = 0; i < 4; i++)
         {
            this.jewu[i] = -1;
         }
      }
      
      public function get available() : Boolean
      {
         return false;
      }
      
      §§namespace("http://alternativaplatform.com/en/alternativagfx") function create(context:Context3D, stage3DIndex:int) : void
      {
      }
      
      §§namespace("http://alternativaplatform.com/en/alternativagfx") function upload(stage3DIndex:int) : void
      {
      }
   }
}

