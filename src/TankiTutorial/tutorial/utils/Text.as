package tutorial.utils
{
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import tutorial.commons.Lang;
   
   public class Text
   {
      
      private static const dropShadowFilter:DropShadowFilter = new DropShadowFilter(2,0,0,1,10,10);
      
      public function Text()
      {
         super();
      }
      
      public static function getTextField(text:String, size:Number, width:Number = -1, align:String = "left") : TextField
      {
         var textField:TextField = new TextField();
         textField.selectable = false;
         textField.mouseEnabled = false;
         textField.antiAliasType = "advanced";
         textField.sharpness = 0;
         textField.thickness = 0;
         var textFormat:TextFormat = new TextFormat("Quad",size,16777215,null,null,null,null,null,align);
         textField.defaultTextFormat = textFormat;
         textField.embedFonts = Lang.embedFonts;
         textField.text = text;
         if(width >= 0)
         {
            textField.width = width;
         }
         textField.filters = [dropShadowFilter];
         return textField;
      }
   }
}

