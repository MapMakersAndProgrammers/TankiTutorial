package tutorial.loader
{
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import tutorial.GameData;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   
   public class TextureQueueEntry extends PooledObject
   {
      
      public var texture:BitmapData;
      
      public var material:TextureMaterial;
      
      public var priority:int;
      
      public function TextureQueueEntry(pool:Pool)
      {
         super(pool);
      }
      
      public static function create(material:TextureMaterial, texture:BitmapData, priority:int) : TextureQueueEntry
      {
         var entry:TextureQueueEntry = TextureQueueEntry(GameData.objectPool.getObject(TextureQueueEntry));
         entry.init(material,texture,priority);
         return entry;
      }
      
      public function init(material:TextureMaterial, texture:BitmapData, priority:int) : void
      {
         this.material = material;
         this.texture = texture;
         this.priority = priority;
      }
      
      public function upload() : void
      {
         this.material.texture = this.texture;
      }
      
      override public function recycle() : void
      {
         this.texture = null;
         this.material = null;
         super.recycle();
      }
   }
}

