package alternativa.gfx.core
{
   import flash.display3D.Context3D;
   import flash.display3D.IndexBuffer3D;
   
   public class IndexBufferResource extends Resource
   {
      
      §§namespace("http://alternativaplatform.com/en/alternativagfx") var putiwyfa:Vector.<IndexBuffer3D> = new Vector.<IndexBuffer3D>(4);
      
      private var voq:Vector.<uint>;
      
      private var litewo:int;
      
      public function IndexBufferResource(indices:Vector.<uint>)
      {
         super();
         this.voq = indices;
         this.litewo = this.voq.length;
      }
      
      public function get indices() : Vector.<uint>
      {
         return this.voq;
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
         this.voq = null;
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
         return this.voq != null;
      }
      
      override §§namespace("http://alternativaplatform.com/en/alternativagfx") function create(context:Context3D, stage3DIndex:int) : void
      {
         super.create(context,stage3DIndex);
         this.putiwyfa[stage3DIndex] = context.createIndexBuffer(this.litewo);
      }
      
      override §§namespace("http://alternativaplatform.com/en/alternativagfx") function upload(stage3DIndex:int) : void
      {
         super.upload(stage3DIndex);
         IndexBuffer3D(this.putiwyfa[stage3DIndex]).uploadFromVector(this.voq,0,this.litewo);
      }
   }
}

