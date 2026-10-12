package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import flash.display3D.VertexBuffer3D;
   import alternativa.gfx.alternativagfx;
   
   use namespace alternativagfx;
   
   public class VertexBufferResource extends Resource
   {
      
      alternativagfx var buffers:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(4);
      
      private var _vertices:Vector.<Number>;
      
      private var data32PerVertex:int;
      
      private var numVertices:int;
      
      public function VertexBufferResource(vertices:Vector.<Number>, data32PerVertex:int)
      {
         super();
         this._vertices = vertices;
         this.data32PerVertex = data32PerVertex;
         this.numVertices = this._vertices.length / this.data32PerVertex;
      }
      
      public function get vertices() : Vector.<Number>
      {
         return this._vertices;
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
         this._vertices = null;
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
         return this._vertices != null;
      }
      
      override alternativagfx function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         this.buffers[stage3DIndex] = context.createVertexBuffer(this.numVertices,this.data32PerVertex);
      }
      
      override alternativagfx function upload(stage3DIndex:int) : void
      {
         super.upload(stage3DIndex);
         VertexBuffer3D(this.buffers[stage3DIndex]).uploadFromVector(this._vertices,0,this.numVertices);
      }
   }
}

