package alternativa.tanks.sfx.flamethrower
{
   import alternativa.math.Vector3;
   import alternativa.tanks.sfx.AnimatedSprite3D;
   import flash.geom.ColorTransform;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: this is for an object3d function
   use namespace alternativa3d;

   public class StreamWeaponParticle extends AnimatedSprite3D
   {
      
      private static var poolSize:int = 20;
      
      private static var pool:Vector.<StreamWeaponParticle> = new Vector.<StreamWeaponParticle>(poolSize);
      
      private static var poolIndex:int = -1;
      
      public var velocity:Vector3 = new Vector3();
      
      public var flightDistance:Number = 0;
      
      public var frameIndex:Number;
      
      public var rotationDirection:int;
      
      public function StreamWeaponParticle()
      {
         super(100,100);
         softAttenuation = 100;
         colorTransform = new ColorTransform();
      }
      
      public static function getParticle() : StreamWeaponParticle
      {
         if(poolIndex == -1)
         {
            return new StreamWeaponParticle();
         }
         var particle:StreamWeaponParticle = pool[poolIndex];
         pool[poolIndex--] = null;
         return particle;
      }
      
      private static function interpolateColorTransform(entry1:ColorTransformEntry, entry2:ColorTransformEntry, t:Number, result:ColorTransform) : void
      {
         result.alphaMultiplier = entry1.alphaMultiplier + t * (entry2.alphaMultiplier - entry1.alphaMultiplier);
         result.alphaOffset = entry1.alphaOffset + t * (entry2.alphaOffset - entry1.alphaOffset);
         result.redMultiplier = entry1.redMultiplier + t * (entry2.redMultiplier - entry1.redMultiplier);
         result.redOffset = entry1.redOffset + t * (entry2.redOffset - entry1.redOffset);
         result.greenMultiplier = entry1.greenMultiplier + t * (entry2.greenMultiplier - entry1.greenMultiplier);
         result.greenOffset = entry1.greenOffset + t * (entry2.greenOffset - entry1.greenOffset);
         result.blueMultiplier = entry1.blueMultiplier + t * (entry2.blueMultiplier - entry1.blueMultiplier);
         result.blueOffset = entry1.blueOffset + t * (entry2.blueOffset - entry1.blueOffset);
      }
      
      private static function copyStructToColorTransform(entry:ColorTransformEntry, result:ColorTransform) : void
      {
         result.alphaMultiplier = entry.alphaMultiplier;
         result.alphaOffset = entry.alphaOffset;
         result.redMultiplier = entry.redMultiplier;
         result.redOffset = entry.redOffset;
         result.greenMultiplier = entry.greenMultiplier;
         result.greenOffset = entry.greenOffset;
         result.blueMultiplier = entry.blueMultiplier;
         result.blueOffset = entry.blueOffset;
      }
      
      public function dispose() : void
      {
         removeFromParent();
         clear();
         pool[++poolIndex] = this;
      }
      
      public function updateColorTransofrm(range:Number, colorTransforms:Vector.<ColorTransformEntry>) : void
      {
         var t:Number = NaN;
         var entry1:ColorTransformEntry = null;
         var entry2:ColorTransformEntry = null;
         var i:int = 0;
         if(colorTransforms != null)
         {
            t = this.flightDistance / range;
            if(t <= 0)
            {
               entry1 = colorTransforms[0];
               copyStructToColorTransform(entry1,colorTransform);
            }
            else if(t >= 1)
            {
               entry1 = colorTransforms[colorTransforms.length - 1];
               copyStructToColorTransform(entry1,colorTransform);
            }
            else
            {
               i = 1;
               entry1 = colorTransforms[0];
               entry2 = colorTransforms[1];
               while(entry2.time < t)
               {
                  i++;
                  entry1 = entry2;
                  entry2 = colorTransforms[i];
               }
               t = (t - entry1.time) / (entry2.time - entry1.time);
               interpolateColorTransform(entry1,entry2,t,colorTransform);
            }
            alpha = colorTransform.alphaMultiplier;
         }
      }
   }
}

