package tutorial.commons
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class Form extends Sprite
   {
      
      public function Form(totalWidth:int, edge:BitmapData, middle:BitmapData)
      {
         var bitmap:Bitmap = null;
         super();
         bitmap = new Bitmap(edge);
         addChild(bitmap);
         bitmap = new Bitmap(middle);
         bitmap.width = totalWidth - edge.width * 2;
         bitmap.x = edge.width;
         addChild(bitmap);
         bitmap = new Bitmap(edge);
         bitmap.scaleX = -1;
         bitmap.x = totalWidth;
         addChild(bitmap);
      }
   }
}

