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
      
      private static var resym:int = 20;
      
      private static var pool:Vector.<StreamWeaponParticle> = new Vector.<StreamWeaponParticle>(resym);
      
      private static var byqe:int = -1;
      
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
         if(byqe == -1)
         {
            return new StreamWeaponParticle();
         }
         var particle:StreamWeaponParticle = pool[byqe];
         pool[byqe--] = null;
         return particle;
      }
      
      private static function interpolateColorTransform(entry1:ColorTransformEntry, entry2:ColorTransformEntry, param3:Number, result:ColorTransform) : void
      {
         result.alphaMultiplier = entry1.alphaMultiplier + param3 * (entry2.alphaMultiplier - entry1.alphaMultiplier);
         result.alphaOffset = entry1.alphaOffset + param3 * (entry2.alphaOffset - entry1.alphaOffset);
         result.redMultiplier = entry1.redMultiplier + param3 * (entry2.redMultiplier - entry1.redMultiplier);
         result.redOffset = entry1.redOffset + param3 * (entry2.redOffset - entry1.redOffset);
         result.greenMultiplier = entry1.greenMultiplier + param3 * (entry2.greenMultiplier - entry1.greenMultiplier);
         result.greenOffset = entry1.greenOffset + param3 * (entry2.greenOffset - entry1.greenOffset);
         result.blueMultiplier = entry1.blueMultiplier + param3 * (entry2.blueMultiplier - entry1.blueMultiplier);
         result.blueOffset = entry1.blueOffset + param3 * (entry2.blueOffset - entry1.blueOffset);
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
         pool[++byqe] = this;
      }
      
      public function updateColorTransofrm(range:Number, colorTransforms:Vector.<ColorTransformEntry>) : void
      {
         var _loc3_:Number = NaN;
         var entry1:ColorTransformEntry = null;
         var entry2:ColorTransformEntry = null;
         var _loc6_:int = 0;
         if(colorTransforms != null)
         {
            _loc3_ = this.flightDistance / range;
            if(_loc3_ <= 0)
            {
               entry1 = colorTransforms[0];
               copyStructToColorTransform(entry1,colorTransform);
            }
            else if(_loc3_ >= 1)
            {
               entry1 = colorTransforms[colorTransforms.length - 1];
               copyStructToColorTransform(entry1,colorTransform);
            }
            else
            {
               _loc6_ = 1;
               entry1 = colorTransforms[0];
               entry2 = colorTransforms[1];
               while(entry2.jomuc < _loc3_)
               {
                  _loc6_++;
                  entry1 = entry2;
                  entry2 = colorTransforms[_loc6_];
               }
               _loc3_ = (_loc3_ - entry1.jomuc) / (entry2.jomuc - entry1.jomuc);
               interpolateColorTransform(entry1,entry2,_loc3_,colorTransform);
            }
            alpha = colorTransform.alphaMultiplier;
         }
      }
   }
}

