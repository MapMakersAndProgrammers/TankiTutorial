package alternativa.types
{
   import flash.utils.Dictionary;
   
   public class Long
   {
      
      private static var wyhynif:int = 0;
      
      private static const ryparyg:Dictionary = new Dictionary();
      
      private var gojiwi:int;
      
      public function Long(param1:int)
      {
         super();
         this.gojiwi = param1;
      }
      
      public static function getNext() : Long
      {
         var _loc1_:Long = null;
         if(Boolean(ryparyg[wyhynif]))
         {
            _loc1_ = ryparyg[wyhynif];
         }
         else
         {
            _loc1_ = new Long(wyhynif);
            ryparyg[wyhynif] = _loc1_;
         }
         ++wyhynif;
         return _loc1_;
      }
      
      public static function getLong(param1:int) : Long
      {
         if(Boolean(ryparyg[param1]))
         {
            return ryparyg[param1];
         }
         var _loc2_:Long = new Long(param1);
         ryparyg[param1] = _loc2_;
         return _loc2_;
      }
      
      public function get low() : int
      {
         return this.gojiwi;
      }
      
      public function get high() : int
      {
         return 0;
      }
   }
}

