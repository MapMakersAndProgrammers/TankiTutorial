package movieclips
{
   import tutorial.GameData;
   import tutorial.utils.Text;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import tutorial.commons.Assets;
   import tutorial.commons.Lang;
   import tutorial.commons.LocalizedStrings;
   
   public class ControlsClip extends MovieClip
   {
      
      private var arrowsGlowMC:Class;
      
      private var spaceGlowMC:Class;
      
      private var keyboardBitmap:Bitmap;
      
      private var mouseBitmap:Bitmap;
      
      private var arrowsGlow:MovieClip;
      
      private var spaceGlow:MovieClip;
      
      private var text:TextField;
      
      public function ControlsClip()
      {
         var _loc1_:BitmapData = null;
         var _loc2_:BitmapData = null;
         this.arrowsGlowMC = ControlsClip_arrowsGlowMC;
         this.spaceGlowMC = ControlsClip_spaceGlowMC;
         super();
         if(Lang.language == Lang.DE)
         {
            _loc1_ = Assets.getData("help_de_png",BitmapData);
         }
         else
         {
            _loc1_ = Assets.getData("help_png",BitmapData);
         }
         _loc2_ = Assets.getData("help_mouse",BitmapData);
         this.arrowsGlow = new this.arrowsGlowMC();
         this.spaceGlow = new this.spaceGlowMC();
         this.arrowsGlow.alpha = 0.43;
         this.spaceGlow.alpha = 0.43;
         var _loc3_:Sprite = new Sprite();
         var _loc4_:TextField = Text.getTextField(Lang.getText(LocalizedStrings.TURRET),12,100,"center");
         var _loc5_:TextField = Text.getTextField(Lang.getText(LocalizedStrings.FIRE),12,100,"center");
         var _loc6_:TextField = Text.getTextField(Lang.getText(LocalizedStrings.MOVING),12,100,"center");
         _loc4_.x = 4;
         _loc4_.y = 65;
         _loc5_.x = 115;
         _loc5_.y = 65;
         _loc6_.x = 223;
         _loc6_.y = 65;
         _loc3_.addChild(_loc4_);
         _loc3_.addChild(_loc5_);
         _loc3_.addChild(_loc6_);
         this.text = Text.getTextField(Lang.getText(LocalizedStrings.CONTROL_SEPARATOR),12);
         var _loc7_:BitmapData = new BitmapData(_loc1_.width,_loc1_.height,true,0);
         _loc7_.draw(_loc1_);
         _loc7_.draw(_loc3_);
         this.keyboardBitmap = new Bitmap(_loc7_);
         addChild(this.keyboardBitmap);
         _loc7_ = new BitmapData(_loc2_.width,_loc2_.height,true,0);
         _loc7_.draw(_loc2_);
         _loc7_.draw(_loc3_);
         if(GameData.vucofena)
         {
            this.mouseBitmap = new Bitmap(_loc7_);
            addChild(this.text);
            this.text.y = this.mouseBitmap.height + 10;
            this.text.x = this.mouseBitmap.width - this.text.textWidth >> 1;
            addChild(this.mouseBitmap);
            this.keyboardBitmap.y = this.text.y + this.text.textHeight + 10;
         }
      }
      
      public function showArrowGlow() : void
      {
         if(this.arrowsGlow.parent != null)
         {
            removeChild(this.arrowsGlow);
         }
         addChild(this.arrowsGlow);
         this.arrowsGlow.gotoAndPlay(0);
      }
      
      public function hideArrowGlow() : void
      {
         if(this.arrowsGlow.parent != null)
         {
            removeChild(this.arrowsGlow);
         }
      }
      
      public function showSpaceGlow() : void
      {
         if(this.spaceGlow.parent != null)
         {
            removeChild(this.spaceGlow);
         }
         addChild(this.spaceGlow);
         this.spaceGlow.gotoAndPlay(0);
      }
      
      public function hideSpaceGlow() : void
      {
         if(this.spaceGlow.parent != null)
         {
            removeChild(this.spaceGlow);
         }
      }
   }
}

