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
      
      private static var eulerAngles:Vector3 = new Vector3();
      
      private static var nywo:Vector3 = new Vector3();
      
      private static var qomusawe:Vector3 = new Vector3();
      
      private static var zob:Matrix3 = new Matrix3();
      
      private static var bohibotiq:Matrix3 = new Matrix3();
      
      public function SFXUtils()
      {
         super();
      }
      
      public static function parseAnimationStrip(texture:BitmapData, frameWidth:int, resolution:Number) : Vector.<Material>
      {
         var bitmapData:BitmapData = null;
         var materials:Vector.<Material> = new Vector.<Material>();
         var numFrames:int = texture.width / frameWidth;
         var rect:Rectangle = new Rectangle(0,0,frameWidth,texture.height);
         var point:Point = new Point();
         var i:int = 0;
         while(i < numFrames)
         {
            bitmapData = new BitmapData(frameWidth,texture.height,true,0);
            bitmapData.copyPixels(texture,rect,point);
            materials[i] = new TextureMaterial(bitmapData,false,true,MipMapping.PER_PIXEL,resolution);
            rect.x += frameWidth;
            i++;
         }
         return materials;
      }
      
      public static function alignObjectPlaneToView(object:Object3D, position:Vector3, direction:Vector3, cameraPosition:Vector3) : void
      {
         var angle:Number = NaN;
         var dot:Number = NaN;
         if(direction.y < -0.99999 || direction.y > 0.99999)
         {
            zeq.x = 0;
            zeq.y = 0;
            zeq.z = 1;
            angle = direction.y < 0 ? Math.PI : 0;
         }
         else
         {
            zeq.x = direction.z;
            zeq.y = 0;
            zeq.z = -direction.x;
            zeq.normalize();
            angle = Math.acos(direction.y);
         }
         zob.fromAxisAngle(zeq,angle);
         nywo.x = cameraPosition.x - position.x;
         nywo.y = cameraPosition.y - position.y;
         nywo.z = cameraPosition.z - position.z;
         dot = nywo.x * direction.x + nywo.y * direction.y + nywo.z * direction.z;
         nywo.x -= dot * direction.x;
         nywo.y -= dot * direction.y;
         nywo.z -= dot * direction.z;
         nywo.normalize();
         zob.transformVector(Vector3.zAxis,qomusawe);
         dot = qomusawe.x * nywo.x + qomusawe.y * nywo.y + qomusawe.z * nywo.z;
         gik.x = qomusawe.y * nywo.z - qomusawe.z * nywo.y;
         gik.y = qomusawe.z * nywo.x - qomusawe.x * nywo.z;
         gik.z = qomusawe.x * nywo.y - qomusawe.y * nywo.x;
         gik.normalize();
         angle = Math.acos(dot);
         bohibotiq.fromAxisAngle(gik,angle);
         zob.append(bohibotiq);
         zob.getEulerAngles(eulerAngles);
         object.rotationX = eulerAngles.x;
         object.rotationY = eulerAngles.y;
         object.rotationZ = eulerAngles.z;
         object.x = position.x;
         object.y = position.y;
         object.z = position.z;
      }
      
      public static function copyColorTransform(src:ColorTransform, result:ColorTransform) : void
      {
         result.redMultiplier = src.redMultiplier;
         result.greenMultiplier = src.greenMultiplier;
         result.blueMultiplier = src.blueMultiplier;
         result.alphaMultiplier = src.alphaMultiplier;
         result.redOffset = src.redOffset;
         result.greenOffset = src.greenOffset;
         result.blueOffset = src.blueOffset;
         result.alphaOffset = src.alphaOffset;
      }
   }
}

