package tutorial.loader
{
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import fyf.vuteci;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class TextureQueueEntry extends Wopowur
   {
      
      public var zyl:BitmapData;
      
      public var myma:TextureMaterial;
      
      public var gohigewam:int;
      
      public function TextureQueueEntry(param1:fare)
      {
         super(param1);
      }
      
      public static function create(param1:TextureMaterial, param2:BitmapData, param3:int) : TextureQueueEntry
      {
         var _loc4_:TextureQueueEntry = TextureQueueEntry(vuteci.murow.loq(TextureQueueEntry));
         _loc4_.init(param1,param2,param3);
         return _loc4_;
      }
      
      public function init(param1:TextureMaterial, param2:BitmapData, param3:int) : void
      {
         this.myma = param1;
         this.zyl = param2;
         this.gohigewam = param3;
      }
      
      public function dumyripov() : void
      {
         this.myma.texture = this.zyl;
      }
      
      override public function recycle() : void
      {
         this.zyl = null;
         this.myma = null;
         super.recycle();
      }
   }
}

