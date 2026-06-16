package movieclips
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol82")]
   public class FinishClip_finishMCClass extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
      
      public var dataClass:Class = FinishClip_finishMCClass_dataClass;
      
      public function FinishClip_finishMCClass()
      {
         super();
         initialWidth = 11500 / 20;
         initialHeight = 8920 / 20;
      }
      
      override public function get movieClipData() : ByteArray
      {
         if(bytes == null)
         {
            bytes = ByteArray(new this.dataClass());
         }
         return bytes;
      }
   }
}

