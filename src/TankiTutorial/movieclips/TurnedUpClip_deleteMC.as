package movieclips
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol82")]
   public class TurnedUpClip_deleteMC extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
      
      public var dataClass:Class = TurnedUpClip_deleteMC_dataClass;
      
      public function TurnedUpClip_deleteMC()
      {
         super();
         initialWidth = 1240 / 20;
         initialHeight = 1240 / 20;
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

