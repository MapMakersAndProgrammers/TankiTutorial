package alternativa.tanks.vehicles.tank
{
   public class SimpleValueSmoother implements ValueSmoother
   {
      
      private var currentValue:Number;
      
      private var targetValue:Number;
      
      private var increaseSpeed:Number;
      
      private var decreaseSpeed:Number;
      
      public function SimpleValueSmoother(increaseSpeed:Number, decreaseSpeed:Number, targetValue:Number, currentValue:Number)
      {
         super();
         this.increaseSpeed = increaseSpeed;
         this.decreaseSpeed = decreaseSpeed;
         this.targetValue = targetValue;
         this.currentValue = currentValue;
      }
      
      public function reset(value:Number) : void
      {
         this.currentValue = value;
         this.targetValue = value;
      }
      
      public function update(dt:Number) : Number
      {
         if(this.currentValue < this.targetValue)
         {
            this.currentValue += this.increaseSpeed * dt;
            if(this.currentValue > this.targetValue)
            {
               this.currentValue = this.targetValue;
            }
         }
         else if(this.currentValue > this.targetValue)
         {
            this.currentValue -= this.decreaseSpeed * dt;
            if(this.currentValue < this.targetValue)
            {
               this.currentValue = this.targetValue;
            }
         }
         return this.currentValue;
      }
      
      public function setTargetValue(value:Number) : void
      {
         this.targetValue = value;
      }
      
      public function getTargetValue() : Number
      {
         return this.targetValue;
      }
   }
}

