package classes
{
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import tutorial.commons.Lang;
   import tutorial.commons.LocalizedStrings;
   
   public class SkipButton extends Button
   {
      
      private static const EArrow:Class = SkipButton_EArrow;
      
      public function SkipButton(param1:Function)
      {
         super(param1);
      }
      
      override protected function init(param1:Event) : void
      {
         var _loc2_:Bitmap = new EArrow();
         _loc2_.x = -_loc2_.width;
         _loc2_.y = 20;
         label.addChild(_loc2_);
         var _loc3_:TextField = new TextField();
         _loc3_.selectable = false;
         _loc3_.multiline = true;
         _loc3_.mouseEnabled = false;
         _loc3_.autoSize = "right";
         _loc3_.antiAliasType = "advanced";
         _loc3_.sharpness = 0;
         _loc3_.thickness = 0;
         _loc3_.defaultTextFormat = new TextFormat("Quadrat",Lang.embedFonts ? 12 : 26,16777215,Lang.embedFonts ? null : true,null,null,null,null,"right",null,null,null,-4);
         _loc3_.embedFonts = Lang.embedFonts;
         _loc3_.x = _loc2_.x - 7;
         _loc3_.y = Lang.embedFonts ? 15.3 : 14;
         _loc3_.text = Lang.getText(LocalizedStrings.SKIP);
         label.addChild(_loc3_);
         super.init(param1);
      }
   }
}

