package alternativa.tanks.utils
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   
   public class Utils3D
   {
      
      private static const fyqynyfy:Vector3 = new Vector3();
      
      public static const neputi:Vector3 = new Vector3();
      
      public function Utils3D()
      {
         super();
      }
      
      public static function setObjectTransform(param1:Object3D, param2:Matrix4) : void
      {
         param2.getEulerAngles(fyqynyfy);
         param1.x = param2.md;
         param1.y = param2.mh;
         param1.z = param2.ml;
         param1.rotationX = fyqynyfy.x;
         param1.rotationY = fyqynyfy.y;
         param1.rotationZ = fyqynyfy.z;
      }
   }
}

