package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import flash.display3D.VertexBuffer3D;
   
   public class VertexBufferResource extends Resource
   {
      
      §§namespace("http://alternativaplatform.com/en/alternativagfx") var putiwyfa:Vector.<VertexBuffer3D> = new Vector.<VertexBuffer3D>(4);
      
      private var tob:Vector.<Number>;
      
      private var fyz:int;
      
      private var synafek:int;
      
      public function VertexBufferResource(vertices:Vector.<Number>, data32PerVertex:int)
      {
         super();
         this.tob = vertices;
         this.fyz = data32PerVertex;
         this.synafek = this.tob.length / this.fyz;
      }
      
      public function get vertices() : Vector.<Number>
      {
         return this.tob;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.putiwyfa[i] != null)
            {
               this.putiwyfa[i].dispose();
               this.putiwyfa[i] = null;
            }
         }
         this.tob = null;
      }
      
      override public function reset() : void
      {
         super.reset();
         for(var i:int = 0; i < 4; i++)
         {
            if(this.putiwyfa[i] != null)
            {
               this.putiwyfa[i].dispose();
               this.putiwyfa[i] = null;
            }
         }
      }
      
      override public function get available() : Boolean
      {
         return this.tob != null;
      }
      
      override §§namespace("http://alternativaplatform.com/en/alternativagfx") function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         this.putiwyfa[stage3DIndex] = context.createVertexBuffer(this.synafek,this.fyz);
      }
      
      override §§namespace("http://alternativaplatform.com/en/alternativagfx") function upload(stage3DIndex:int) : void
      {
         super.upload(stage3DIndex);
         VertexBuffer3D(this.putiwyfa[stage3DIndex]).uploadFromVector(this.tob,0,this.synafek);
      }
   }
}

