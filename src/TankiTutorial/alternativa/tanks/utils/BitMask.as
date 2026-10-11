package alternativa.tanks.utils
{
   public class BitMask
   {
      
      private var mask:int;
      
      public function BitMask()
      {
         super();
      }
      
      public function setBits(bits:int) : void
      {
         this.mask |= bits;
      }
      
      public function clearBits(bits:int) : void
      {
         this.mask &= ~bits;
      }
      
      public function setBit(bitIndex:int) : void
      {
         this.setBits(1 << bitIndex);
      }
      
      public function clearBit(bitIndex:int) : void
      {
         this.clearBits(1 << bitIndex);
      }
      
      public function getBitValue(bitIndex:int) : int
      {
         return 1 & this.mask >> bitIndex;
      }
      
      public function clear() : void
      {
         this.mask = 0;
      }
      
      public function isEmpty() : Boolean
      {
         return this.mask == 0;
      }
      
      public function change(bits:int, value:Boolean) : void
      {
         if(value)
         {
            this.setBits(bits);
         }
         else
         {
            this.clearBits(bits);
         }
      }
   }
}

