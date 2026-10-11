package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import flash.display3D.Program3D;
   import flash.utils.ByteArray;
   import alternativa.gfx.alternativagfx;
   
   use namespace alternativagfx;

   public class ProgramResource extends Resource
   {
      
      alternativagfx var programs:Vector.<Program3D> = new Vector.<Program3D>(4);
      
      private var _vertexProgram:ByteArray;
      
      private var _fragmentProgram:ByteArray;
      
      public function ProgramResource(vertexProgram:ByteArray, fragmentProgram:ByteArray)
      {
         super();
         this._vertexProgram = vertexProgram;
         this._fragmentProgram = fragmentProgram;
      }
      
      public function get vertexProgram() : ByteArray
      {
         return this._vertexProgram;
      }
      
      public function get fragmentProgram() : ByteArray
      {
         return this._fragmentProgram;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.programs[i] != null)
            {
               this.programs[i].dispose();
               this.programs[i] = null;
            }
         }
         this._vertexProgram = null;
         this._fragmentProgram = null;
      }
      
      override public function reset() : void
      {
         super.reset();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.programs[i] != null)
            {
               this.programs[i].dispose();
               this.programs[i] = null;
            }
         }
      }
      
      override public function get available() : Boolean
      {
         return this._vertexProgram != null && this._fragmentProgram != null;
      }
      
      override alternativagfx function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         this.programs[stage3DIndex] = context.createProgram();
      }
      
      override alternativagfx function upload(stage3DIndex:int) : void
      {
         super.upload(stage3DIndex);
         Program3D(this.programs[stage3DIndex]).upload(this.vertexProgram,this.fragmentProgram);
      }
   }
}

