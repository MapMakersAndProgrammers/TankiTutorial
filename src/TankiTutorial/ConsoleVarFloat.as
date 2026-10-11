package
{
   public class ConsoleVarFloat
   {
      
      private var name:String;
      
      public var value:Number;
      
      private var minValue:Number;
      
      private var maxValue:Number;
      
      public function ConsoleVarFloat(name:String, value:Number, minValue:Number, maxValue:Number)
      {
         super();
         this.name = name;
         this.value = value;
         this.minValue = minValue;
         this.maxValue = maxValue;
      }
   }
}

