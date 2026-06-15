package alternativa.tanks.utils
{
   public class BitMask
   {
      
      private var cogutirym:int;
      
      public function BitMask()
      {
         super();
      }
      
      public function setBits(param1:int) : void
      {
         this.cogutirym |= param1;
      }
      
      public function clearBits(param1:int) : void
      {
         this.cogutirym &= ~param1;
      }
      
      public function setBit(param1:int) : void
      {
         this.setBits(1 << param1);
      }
      
      public function clearBit(param1:int) : void
      {
         this.clearBits(1 << param1);
      }
      
      public function getBitValue(param1:int) : int
      {
         return 1 & this.cogutirym >> param1;
      }
      
      public function clear() : void
      {
         this.cogutirym = 0;
      }
      
      public function isEmpty() : Boolean
      {
         return this.cogutirym == 0;
      }
      
      public function change(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            this.setBits(param1);
         }
         else
         {
            this.clearBits(param1);
         }
      }
   }
}

