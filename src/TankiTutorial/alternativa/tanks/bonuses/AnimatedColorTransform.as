package alternativa.tanks.bonuses
{
   import alternativa.tanks.animations.AnimatedValue;
   import flash.geom.ColorTransform;
   
   public class AnimatedColorTransform implements AnimatedValue
   {
      
      public const fur:ColorTransform = new ColorTransform();
      
      public function AnimatedColorTransform()
      {
         super();
      }
      
      public function setAnimatedValue(param1:Number) : void
      {
         this.fur.redOffset = param1;
         this.fur.greenOffset = param1;
         this.fur.blueOffset = param1;
      }
   }
}

