package movieclips
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol82")]
   public class ControlsClip_spaceGlowMC extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
      
      public var dataClass:Class = ControlsClip_spaceGlowMC_dataClass;
      
      public function ControlsClip_spaceGlowMC()
      {
         super();
         initialWidth = 6520 / 20;
         initialHeight = 1860 / 20;
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

