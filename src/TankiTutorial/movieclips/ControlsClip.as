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
         var keyboardBitmapData:BitmapData = null;
         var mouseBitmapData:BitmapData = null;
         this.arrowsGlowMC = ControlsClip_arrowsGlowMC;
         this.spaceGlowMC = ControlsClip_spaceGlowMC;
         super();
         if(Lang.language == Lang.DE)
         {
            keyboardBitmapData = Assets.getData("help_de_png",BitmapData);
         }
         else
         {
            keyboardBitmapData = Assets.getData("help_png",BitmapData);
         }
         mouseBitmapData = Assets.getData("help_mouse",BitmapData);
         this.arrowsGlow = new this.arrowsGlowMC();
         this.spaceGlow = new this.spaceGlowMC();
         this.arrowsGlow.alpha = 0.43;
         this.spaceGlow.alpha = 0.43;
         var sprite:Sprite = new Sprite();
         var turretLabel:TextField = Text.getTextField(Lang.getText(LocalizedStrings.TURRET),12,100,"center");
         var fireLabel:TextField = Text.getTextField(Lang.getText(LocalizedStrings.FIRE),12,100,"center");
         var movingLabel:TextField = Text.getTextField(Lang.getText(LocalizedStrings.MOVING),12,100,"center");
         turretLabel.x = 4;
         turretLabel.y = 65;
         fireLabel.x = 115;
         fireLabel.y = 65;
         movingLabel.x = 223;
         movingLabel.y = 65;
         sprite.addChild(turretLabel);
         sprite.addChild(fireLabel);
         sprite.addChild(movingLabel);
         this.text = Text.getTextField(Lang.getText(LocalizedStrings.CONTROL_SEPARATOR),12);
         var bitmapData:BitmapData = new BitmapData(keyboardBitmapData.width,keyboardBitmapData.height,true,0);
         bitmapData.draw(keyboardBitmapData);
         bitmapData.draw(sprite);
         this.keyboardBitmap = new Bitmap(bitmapData);
         addChild(this.keyboardBitmap);
         bitmapData = new BitmapData(mouseBitmapData.width,mouseBitmapData.height,true,0);
         bitmapData.draw(mouseBitmapData);
         bitmapData.draw(sprite);
         if(GameData.mouseEnabled)
         {
            this.mouseBitmap = new Bitmap(bitmapData);
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

