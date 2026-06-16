package tutorial.loader
{
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import tutorial.GameData;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   
   public class TextureQueueEntry extends PooledObject
   {
      
      public var zyl:BitmapData;
      
      public var material:TextureMaterial;
      
      public var gohigewam:int;
      
      public function TextureQueueEntry(param1:Pool)
      {
         super(param1);
      }
      
      public static function create(param1:TextureMaterial, param2:BitmapData, param3:int) : TextureQueueEntry
      {
         var _loc4_:TextureQueueEntry = TextureQueueEntry(GameData.murow.getObject(TextureQueueEntry));
         _loc4_.init(param1,param2,param3);
         return _loc4_;
      }
      
      public function init(param1:TextureMaterial, param2:BitmapData, param3:int) : void
      {
         this.material = param1;
         this.zyl = param2;
         this.gohigewam = param3;
      }
      
      public function upload() : void
      {
         this.material.texture = this.zyl;
      }
      
      override public function recycle() : void
      {
         this.zyl = null;
         this.material = null;
         super.recycle();
      }
   }
}

