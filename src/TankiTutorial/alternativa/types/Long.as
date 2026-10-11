package alternativa.types
{
   import flash.utils.Dictionary;
   
   public class Long
   {
      
      private static var next:int = 0;
      
      private static const longs:Dictionary = new Dictionary();
      
      private var _low:int;
      
      public function Long(low:int)
      {
         super();
         this._low = low;
      }
      
      public static function getNext() : Long
      {
         var res:Long = null;
         if(Boolean(longs[next]))
         {
            res = longs[next];
         }
         else
         {
            res = new Long(next);
            longs[next] = res;
         }
         ++next;
         return res;
      }
      
      public static function getLong(value:int) : Long
      {
         if(Boolean(longs[value]))
         {
            return longs[value];
         }
         var res:Long = new Long(value);
         longs[value] = res;
         return res;
      }
      
      public function get low() : int
      {
         return this._low;
      }
      
      public function get high() : int
      {
         return 0;
      }
   }
}

