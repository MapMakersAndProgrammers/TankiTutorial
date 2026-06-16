package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SFXUtils
   {
      
      private static var zeq:Vector3 = new Vector3();
      
      private static var gik:Vector3 = new Vector3();
      
      private static var fyqynyfy:Vector3 = new Vector3();
      
      private static var nywo:Vector3 = new Vector3();
      
      private static var qomusawe:Vector3 = new Vector3();
      
      private static var zob:Matrix3 = new Matrix3();
      
      private static var bohibotiq:Matrix3 = new Matrix3();
      
      public function SFXUtils()
      {
         super();
      }
      
      public static function parseAnimationStrip(param1:BitmapData, param2:int, param3:Number) : Vector.<Material>
      {
         var _loc9_:BitmapData = null;
         var _loc4_:Vector.<Material> = new Vector.<Material>();
         var _loc5_:int = param1.width / param2;
         var _loc6_:Rectangle = new Rectangle(0,0,param2,param1.height);
         var _loc7_:Point = new Point();
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_)
         {
            _loc9_ = new BitmapData(param2,param1.height,true,0);
            _loc9_.copyPixels(param1,_loc6_,_loc7_);
            _loc4_[_loc8_] = new TextureMaterial(_loc9_,false,true,MipMapping.PER_PIXEL,param3);
            _loc6_.x += param2;
            _loc8_++;
         }
         return _loc4_;
      }
      
      public static function alignObjectPlaneToView(param1:Object3D, param2:Vector3, param3:Vector3, param4:Vector3) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(param3.y < -0.99999 || param3.y > 0.99999)
         {
            zeq.x = 0;
            zeq.y = 0;
            zeq.z = 1;
            _loc5_ = param3.y < 0 ? Math.PI : 0;
         }
         else
         {
            zeq.x = param3.z;
            zeq.y = 0;
            zeq.z = -param3.x;
            zeq.normalize();
            _loc5_ = Math.acos(param3.y);
         }
         zob.fromAxisAngle(zeq,_loc5_);
         nywo.x = param4.x - param2.x;
         nywo.y = param4.y - param2.y;
         nywo.z = param4.z - param2.z;
         _loc6_ = nywo.x * param3.x + nywo.y * param3.y + nywo.z * param3.z;
         nywo.x -= _loc6_ * param3.x;
         nywo.y -= _loc6_ * param3.y;
         nywo.z -= _loc6_ * param3.z;
         nywo.normalize();
         zob.transformVector(Vector3.nesicuryn,qomusawe);
         _loc6_ = qomusawe.x * nywo.x + qomusawe.y * nywo.y + qomusawe.z * nywo.z;
         gik.x = qomusawe.y * nywo.z - qomusawe.z * nywo.y;
         gik.y = qomusawe.z * nywo.x - qomusawe.x * nywo.z;
         gik.z = qomusawe.x * nywo.y - qomusawe.y * nywo.x;
         gik.normalize();
         _loc5_ = Math.acos(_loc6_);
         bohibotiq.fromAxisAngle(gik,_loc5_);
         zob.append(bohibotiq);
         zob.getEulerAngles(fyqynyfy);
         param1.rotationX = fyqynyfy.x;
         param1.rotationY = fyqynyfy.y;
         param1.rotationZ = fyqynyfy.z;
         param1.x = param2.x;
         param1.y = param2.y;
         param1.z = param2.z;
      }
      
      public static function copyColorTransform(param1:ColorTransform, param2:ColorTransform) : void
      {
         param2.redMultiplier = param1.redMultiplier;
         param2.greenMultiplier = param1.greenMultiplier;
         param2.blueMultiplier = param1.blueMultiplier;
         param2.alphaMultiplier = param1.alphaMultiplier;
         param2.redOffset = param1.redOffset;
         param2.greenOffset = param1.greenOffset;
         param2.blueOffset = param1.blueOffset;
         param2.alphaOffset = param1.alphaOffset;
      }
   }
}

