package tutorial.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Form extends Sprite
   {
      
      public function Form(param1:int, param2:BitmapData, param3:BitmapData)
      {
         var _loc4_:Bitmap = null;
         super();
         _loc4_ = new Bitmap(param2);
         addChild(_loc4_);
         _loc4_ = new Bitmap(param3);
         _loc4_.width = param1 - param2.width * 2;
         _loc4_.x = param2.width;
         addChild(_loc4_);
         _loc4_ = new Bitmap(param2);
         _loc4_.scaleX = -1;
         _loc4_.x = param1;
         addChild(_loc4_);
      }
   }
}

