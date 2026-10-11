package tutorial.commons
{
   public class UnpackingProgressUpdating
   {
      
      private static var updaterListener:Function;
      
      public function UnpackingProgressUpdating()
      {
         super();
      }
      
      public static function setListener(listener:Function) : *
      {
         UnpackingProgressUpdating.updaterListener = listener;
      }
      
      public static function update() : *
      {
         UnpackingProgressUpdating.updaterListener();
      }
   }
}

