package alternativa.tanks.bonuses
{
   import alternativa.tanks.animations.AnimatedValue;
   import flash.geom.ColorTransform;
   
   public class AnimatedColorTransform implements AnimatedValue
   {
      
      public const colorTransform:ColorTransform = new ColorTransform();
      
      public function AnimatedColorTransform()
      {
         super();
      }
      
      public function setAnimatedValue(value:Number) : void
      {
         this.colorTransform.redOffset = value;
         this.colorTransform.greenOffset = value;
         this.colorTransform.blueOffset = value;
      }
   }
}

