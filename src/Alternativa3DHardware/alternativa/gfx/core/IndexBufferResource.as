package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import flash.display3D.IndexBuffer3D;
   import alternativa.gfx.alternativagfx;
   
   use namespace alternativagfx;

   public class IndexBufferResource extends Resource
   {
      
      alternativagfx var buffers:Vector.<IndexBuffer3D> = new Vector.<IndexBuffer3D>(4);
      
      private var _indices:Vector.<uint>;
      
      private var numIndices:int;
      
      public function IndexBufferResource(indices:Vector.<uint>)
      {
         super();
         this._indices = indices;
         this.numIndices = this._indices.length;
      }
      
      public function get indices() : Vector.<uint>
      {
         return this._indices;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.buffers[i] != null)
            {
               this.buffers[i].dispose();
               this.buffers[i] = null;
            }
         }
         this._indices = null;
      }
      
      override public function reset() : void
      {
         super.reset();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.buffers[i] != null)
            {
               this.buffers[i].dispose();
               this.buffers[i] = null;
            }
         }
      }
      
      override public function get available() : Boolean
      {
         return this._indices != null;
      }
      
      override alternativagfx function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         this.buffers[stage3DIndex] = context.createIndexBuffer(this.numIndices);
      }
      
      override alternativagfx function upload(stage3DIndex:int) : void
      {
         super.upload(stage3DIndex);
         IndexBuffer3D(this.buffers[stage3DIndex]).uploadFromVector(this._indices,0,this.numIndices);
      }
   }
}

