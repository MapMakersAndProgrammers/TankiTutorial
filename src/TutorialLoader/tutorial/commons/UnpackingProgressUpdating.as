package tutorial.commons
{
   public class UnpackingProgressUpdating
   {
      
      private static var updaterListener:Function;
      
      public function UnpackingProgressUpdating()
      {
         super();
      }
      
      public static function setListener(param1:Function) : *
      {
         UnpackingProgressUpdating.updaterListener = param1;
      }
      
      public static function update() : *
      {
         UnpackingProgressUpdating.updaterListener();
      }
   }
}

