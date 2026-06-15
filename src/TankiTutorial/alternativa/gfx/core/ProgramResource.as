package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import flash.display3D.Program3D;
   import flash.utils.ByteArray;
   
   public class ProgramResource extends Resource
   {
      
      §§namespace("http://alternativaplatform.com/en/alternativagfx") var tecemyl:Vector.<Program3D> = new Vector.<Program3D>(4);
      
      private var lugak:ByteArray;
      
      private var cajaq:ByteArray;
      
      public function ProgramResource(vertexProgram:ByteArray, fragmentProgram:ByteArray)
      {
         super();
         this.lugak = vertexProgram;
         this.cajaq = fragmentProgram;
      }
      
      public function get vertexProgram() : ByteArray
      {
         return this.lugak;
      }
      
      public function get fragmentProgram() : ByteArray
      {
         return this.cajaq;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.tecemyl[i] != null)
            {
               this.tecemyl[i].dispose();
               this.tecemyl[i] = null;
            }
         }
         this.lugak = null;
         this.cajaq = null;
      }
      
      override public function reset() : void
      {
         super.reset();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.tecemyl[i] != null)
            {
               this.tecemyl[i].dispose();
               this.tecemyl[i] = null;
            }
         }
      }
      
      override public function get available() : Boolean
      {
         return this.lugak != null && this.cajaq != null;
      }
      
      override §§namespace("http://alternativaplatform.com/en/alternativagfx") function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         this.tecemyl[stage3DIndex] = context.createProgram();
      }
      
      override §§namespace("http://alternativaplatform.com/en/alternativagfx") function upload(stage3DIndex:int) : void
      {
         super.upload(stage3DIndex);
         Program3D(this.tecemyl[stage3DIndex]).upload(this.vertexProgram,this.fragmentProgram);
      }
   }
}

