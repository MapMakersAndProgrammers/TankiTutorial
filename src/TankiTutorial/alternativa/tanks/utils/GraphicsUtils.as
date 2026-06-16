package alternativa.tanks.utils
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.sfx.UVFrame;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class GraphicsUtils
   {
      
      private static const mutedog:Point = new Point();
      
      public function GraphicsUtils()
      {
         super();
      }
      
      public static function setObjectTransform(param1:Object3D, param2:Vector3, param3:Vector3) : void
      {
         param1.x = param2.x;
         param1.y = param2.y;
         param1.z = param2.z;
         param1.rotationX = param3.x;
         param1.rotationY = param3.y;
         param1.rotationZ = param3.z;
      }
      
      public static function getSquareUVFramesFromTexture(param1:BitmapData, param2:int = 0) : Vector.<UVFrame>
      {
         var _loc3_:int = param1.height;
         return getUVFramesFromTexture(param1,_loc3_,_loc3_,param2);
      }
      
      public static function getUVFramesFromTexture(param1:BitmapData, param2:int, param3:int, param4:int = 0) : Vector.<UVFrame>
      {
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc5_:int = param1.width;
         var _loc6_:int = Math.min(param2,_loc5_);
         var _loc7_:int = _loc5_ / _loc6_;
         var _loc8_:int = param1.height;
         var _loc9_:int = Math.min(param3,_loc8_);
         var _loc10_:int = _loc8_ / _loc9_;
         var _loc11_:int = _loc7_ * _loc10_;
         if(param4 > 0 && _loc11_ > param4)
         {
            _loc11_ = param4;
         }
         var _loc12_:Vector.<UVFrame> = new Vector.<UVFrame>(_loc11_);
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         while(_loc14_ < _loc10_)
         {
            _loc15_ = _loc14_ * _loc9_;
            _loc16_ = _loc15_ + _loc9_;
            _loc17_ = 0;
            while(_loc17_ < _loc7_)
            {
               _loc18_ = _loc17_ * _loc6_;
               _loc19_ = _loc18_ + _loc6_;
               _loc12_[_loc13_++] = new UVFrame(_loc18_ / _loc5_,_loc15_ / _loc8_,_loc19_ / _loc5_,_loc16_ / _loc8_);
               if(_loc13_ == _loc11_)
               {
                  return _loc12_;
               }
               _loc17_++;
            }
            _loc14_++;
         }
         return _loc12_;
      }
   }
}

