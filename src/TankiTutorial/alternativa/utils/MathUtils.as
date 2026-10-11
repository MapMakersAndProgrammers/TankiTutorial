package alternativa.utils
{
   public class MathUtils
   {
      
      public static const PI2:Number = 2 * Math.PI;
      
      public function MathUtils()
      {
         super();
      }
      
      public static function clamp(value:Number, min:Number, max:Number) : Number
      {
         if(value < min)
         {
            return min;
         }
         if(value > max)
         {
            return max;
         }
         return value;
      }
      
      public static function clampAngle(angle:Number) : Number
      {
         angle %= PI2;
         if(angle < -Math.PI)
         {
            return PI2 + angle;
         }
         if(angle > Math.PI)
         {
            return angle - PI2;
         }
         return angle;
      }
      
      public static function clampAngleFast(angle:Number) : Number
      {
         if(angle < -Math.PI)
         {
            return PI2 + angle;
         }
         if(angle > Math.PI)
         {
            return angle - PI2;
         }
         return angle;
      }
      
      public static function toDegrees(radians:Number) : Number
      {
         return radians * 180 / Math.PI;
      }
      
      public static function toRadians(degrees:Number) : Number
      {
         return degrees * Math.PI / 180;
      }
      
      public static function getBitValue(value:int, bit:int) : int
      {
         return value >> bit & 1;
      }
      
      public static function changeBitValue(value:int, bit:int, enabled:Boolean) : int
      {
         if(enabled)
         {
            return value | 1 << bit;
         }
         return value & ~(1 << bit);
      }
      
      public static function moveValueTowards(value:Number, target:Number, delta:Number) : Number
      {
         if(value < target)
         {
            value += delta;
            return value > target ? target : value;
         }
         if(value > target)
         {
            value -= delta;
            return value < target ? target : value;
         }
         return value;
      }
      
      public static function snap(value:Number, target:Number, epsilon:Number) : Number
      {
         if(value > target - epsilon && value < target + epsilon)
         {
            return target;
         }
         return value;
      }
      
      public static function sign(value:Number) : Number
      {
         if(value < 0)
         {
            return -1;
         }
         if(value > 0)
         {
            return 1;
         }
         return 0;
      }
      
      public static function numberSign(value:Number, threshold:Number) : Number
      {
         if(value < 0)
         {
            return value < -threshold ? -1 : 0;
         }
         if(value > 0)
         {
            return value > threshold ? 1 : 0;
         }
         return 0;
      }
      
      public static function numbersEqual(a:Number, b:Number, epsilon:Number) : Boolean
      {
         var diff:Number = a - b;
         if(diff < 0)
         {
            return diff > -epsilon;
         }
         return diff < epsilon;
      }
   }
}

