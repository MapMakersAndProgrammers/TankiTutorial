package alternativa.tanks.sfx
{
   public class Blinker
   {
      
      private var initialInterval:int;
      
      private var minInterval:int;
      
      private var intervalDecrement:int;
      
      private var maxValue:Number;
      
      private var minValue:Number;
      
      private var gahehake:Number;
      
      private var value:Number;
      
      private var speed:Number;
      
      private var sesibo:Number;
      
      private var nextSwitchTime:int;
      
      private var currentInterval:int;
      
      public function Blinker(initialInterval:int, minInterval:int, intervalDecrement:int, minValue:Number, maxValue:Number, param6:Number)
      {
         super();
         this.initialInterval = initialInterval;
         this.minInterval = minInterval;
         this.intervalDecrement = intervalDecrement;
         this.minValue = minValue;
         this.maxValue = maxValue;
         this.gahehake = param6;
         this.sesibo = maxValue - minValue;
      }
      
      public function setInitialInterval(interval:int) : void
      {
         this.initialInterval = interval;
      }
      
      public function init(time:int) : void
      {
         this.value = this.maxValue;
         this.currentInterval = this.initialInterval;
         this.speed = this.getSpeed(-1);
         this.nextSwitchTime = time + this.currentInterval;
      }
      
      public function setMaxValue(param1:Number) : void
      {
         if(param1 >= this.minValue)
         {
            this.maxValue = param1;
            this.sesibo = this.maxValue - this.minValue;
         }
      }
      
      public function setMinValue(param1:Number) : void
      {
         if(param1 <= this.maxValue)
         {
            this.minValue = param1;
            this.sesibo = this.maxValue - this.minValue;
         }
      }
      
      public function getMinValue() : Number
      {
         return this.minValue;
      }
      
      public function updateValue(time:int, deltaTime:int) : Number
      {
         this.value += this.speed * deltaTime;
         if(this.value > this.maxValue)
         {
            this.value = this.maxValue;
         }
         if(this.value < this.minValue)
         {
            this.value = this.minValue;
         }
         if(time >= this.nextSwitchTime)
         {
            if(this.currentInterval > this.minInterval)
            {
               this.currentInterval -= this.intervalDecrement;
               if(this.currentInterval < this.minInterval)
               {
                  this.currentInterval = this.minInterval;
               }
            }
            this.nextSwitchTime = time + this.currentInterval;
            if(this.speed < 0)
            {
               this.speed = this.getSpeed(1);
            }
            else
            {
               this.speed = this.getSpeed(-1);
            }
         }
         return this.value;
      }
      
      private function getSpeed(direction:Number) : Number
      {
         return direction * this.gahehake * this.sesibo / this.currentInterval;
      }
   }
}

