package tutorial.utils
{
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import tutorial.commons.Lang;
   
   public class Text
   {
      
      private static const qycerij:DropShadowFilter = new DropShadowFilter(2,0,0,1,10,10);
      
      public function Text()
      {
         super();
      }
      
      public static function getTextField(param1:String, param2:Number, param3:Number = -1, param4:String = "left") : TextField
      {
         var _loc5_:TextField = new TextField();
         _loc5_.selectable = false;
         _loc5_.mouseEnabled = false;
         _loc5_.antiAliasType = "advanced";
         _loc5_.sharpness = 0;
         _loc5_.thickness = 0;
         var _loc6_:TextFormat = new TextFormat("Quad",param2,16777215,null,null,null,null,null,param4);
         _loc5_.defaultTextFormat = _loc6_;
         _loc5_.embedFonts = Lang.embedFonts;
         _loc5_.text = param1;
         if(param3 >= 0)
         {
            _loc5_.width = param3;
         }
         _loc5_.filters = [qycerij];
         return _loc5_;
      }
   }
}

