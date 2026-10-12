package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import alternativa.gfx.alternativagfx;
   
   use namespace alternativagfx;
   
   public class Resource
   {
      
      alternativagfx var context3DIds:Vector.<int> = Vector.<int>([-1,-1,-1,-1]);
      
      public function Resource()
      {
         super();
      }
      
      public function dispose() : void
      {
         for(var i:int = 0; i < 4; i++)
         {
            this.context3DIds[i] = -1;
         }
      }
      
      public function reset() : void
      {
         for(var i:int = 0; i < 4; i++)
         {
            this.context3DIds[i] = -1;
         }
      }
      
      public function get available() : Boolean
      {
         return false;
      }
      
      alternativagfx function create(context:Context3D, stage3DIndex:int) : void
      {
      }
      
      alternativagfx function upload(stage3DIndex:int) : void
      {
      }
   }
}

