package alternativa.physics
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   
   public class PhysicsUtils
   {
      
      public function PhysicsUtils()
      {
         super();
      }
      
      public static function setBoxInvInertia(mass:Number, halfSize:Vector3, result:Matrix3) : void
      {
         if(mass <= 0)
         {
            throw new ArgumentError();
         }
         result.copy(Matrix3.zero);
         if(mass == Infinity)
         {
            return;
         }
         var xx:Number = halfSize.x * halfSize.x;
         var yy:Number = halfSize.y * halfSize.y;
         var zz:Number = halfSize.z * halfSize.z;
         result.ma = 3 / (mass * (yy + zz));
         result.mf = 3 / (mass * (zz + xx));
         result.mk = 3 / (mass * (xx + yy));
      }
      
      public static function getCylinderInvInertia(mass:Number, radius:Number, height:Number, result:Matrix3) : void
      {
         if(mass <= 0)
         {
            throw new ArgumentError();
         }
         result.copy(Matrix3.zero);
         if(mass == Infinity)
         {
            return;
         }
         result.ma = result.mf = 1 / (mass * (height * height / 12 + radius * radius / 4));
         result.mk = 2 / (mass * radius * radius);
      }
   }
}

