package alternativa.tanks.sfx.flamethrower
{
   public class ColorTransformEntry
   {
      
      public var jomuc:Number;
      
      public var redMultiplier:Number;
      
      public var greenMultiplier:Number;
      
      public var blueMultiplier:Number;
      
      public var alphaMultiplier:Number;
      
      public var redOffset:int;
      
      public var greenOffset:int;
      
      public var blueOffset:int;
      
      public var alphaOffset:int;
      
      public function ColorTransformEntry(redMultiplier:Number, greenMultiplier:Number, blueMultiplier:Number, alphaMultiplier:Number, redOffset:Number, greenOffset:Number, blueOffset:Number, alphaOffset:Number, param9:Number)
      {
         super();
         this.jomuc = param9;
         this.redMultiplier = redMultiplier;
         this.greenMultiplier = greenMultiplier;
         this.blueMultiplier = blueMultiplier;
         this.alphaMultiplier = alphaMultiplier;
         this.redOffset = redOffset;
         this.greenOffset = greenOffset;
         this.blueOffset = blueOffset;
         this.alphaOffset = alphaOffset;
      }
   }
}

