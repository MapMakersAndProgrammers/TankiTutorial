package alternativa.tanks.vehicles.tank
{
   public class SimpleValueSmoother implements ValueSmoother
   {
      
      private var soluwirac:Number;
      
      private var cejufi:Number;
      
      private var lisecaze:Number;
      
      private var bybidohun:Number;
      
      public function SimpleValueSmoother(param1:Number, param2:Number, param3:Number, param4:Number)
      {
         super();
         this.lisecaze = param1;
         this.bybidohun = param2;
         this.cejufi = param3;
         this.soluwirac = param4;
      }
      
      public function reset(param1:Number) : void
      {
         this.soluwirac = param1;
         this.cejufi = param1;
      }
      
      public function update(param1:Number) : Number
      {
         if(this.soluwirac < this.cejufi)
         {
            this.soluwirac += this.lisecaze * param1;
            if(this.soluwirac > this.cejufi)
            {
               this.soluwirac = this.cejufi;
            }
         }
         else if(this.soluwirac > this.cejufi)
         {
            this.soluwirac -= this.bybidohun * param1;
            if(this.soluwirac < this.cejufi)
            {
               this.soluwirac = this.cejufi;
            }
         }
         return this.soluwirac;
      }
      
      public function setTargetValue(param1:Number) : void
      {
         this.cejufi = param1;
      }
      
      public function getTargetValue() : Number
      {
         return this.cejufi;
      }
   }
}

