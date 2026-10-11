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
      
      public static function setObjectTransform(object:Object3D, position:Vector3, rotation:Vector3) : void
      {
         object.x = position.x;
         object.y = position.y;
         object.z = position.z;
         object.rotationX = rotation.x;
         object.rotationY = rotation.y;
         object.rotationZ = rotation.z;
      }
      
      public static function getSquareUVFramesFromTexture(bitmapData:BitmapData, numFrames:int = 0) : Vector.<UVFrame>
      {
         var frameSize:int = bitmapData.height;
         return getUVFramesFromTexture(bitmapData,frameSize,frameSize,numFrames);
      }
      
      public static function getUVFramesFromTexture(bitmapData:BitmapData, frameWidth:int, frameHeight:int, numFrames:int = 0) : Vector.<UVFrame>
      {
         var top:int = 0;
         var bottom:int = 0;
         var j:int = 0;
         var left:int = 0;
         var right:int = 0;
         var textureWidth:int = bitmapData.width;
         var _loc6_:int = Math.min(frameWidth,textureWidth);
         var numColumns:int = textureWidth / _loc6_;
         var textureHeight:int = bitmapData.height;
         var _loc9_:int = Math.min(frameHeight,textureHeight);
         var numRows:int = textureHeight / _loc9_;
         var totalFrames:int = numColumns * numRows;
         if(numFrames > 0 && totalFrames > numFrames)
         {
            totalFrames = numFrames;
         }
         var frames:Vector.<UVFrame> = new Vector.<UVFrame>(totalFrames);
         var index:int = 0;
         var i:int = 0;
         while(i < numRows)
         {
            top = i * _loc9_;
            bottom = top + _loc9_;
            j = 0;
            while(j < numColumns)
            {
               left = j * _loc6_;
               right = left + _loc6_;
               frames[index++] = new UVFrame(left / textureWidth,top / textureHeight,right / textureWidth,bottom / textureHeight);
               if(index == totalFrames)
               {
                  return frames;
               }
               j++;
            }
            i++;
         }
         return frames;
      }
   }
}

