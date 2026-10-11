package alternativa.tanks.shared.usertitle
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class ProgressBarSkin
   {
      
      private static var hpLeftDmCls:Class = ProgressBarSkin_hpLeftDmCls;
      
      private static var hpLeftDm:BitmapData = Bitmap(new hpLeftDmCls()).bitmapData;
      
      private static var hpRightDmCls:Class = ProgressBarSkin_hpRightDmCls;
      
      private static var hpRightDm:BitmapData = Bitmap(new hpRightDmCls()).bitmapData;
      
      private static var hpLeftBgDmCls:Class = ProgressBarSkin_hpLeftBgDmCls;
      
      private static var hpLeftBgDm:BitmapData = Bitmap(new hpLeftBgDmCls()).bitmapData;
      
      private static var hpRightBgDmCls:Class = ProgressBarSkin_hpRightBgDmCls;
      
      private static var hpRightBgDm:BitmapData = Bitmap(new hpRightBgDmCls()).bitmapData;
      
      private static var weaponLeftCls:Class = ProgressBarSkin_weaponLeftCls;
      
      private static var weaponLeft:BitmapData = Bitmap(new weaponLeftCls()).bitmapData;
      
      private static var weaponRightCls:Class = ProgressBarSkin_weaponRightCls;
      
      private static var weaponRight:BitmapData = Bitmap(new weaponRightCls()).bitmapData;
      
      private static var weaponLeftBgCls:Class = ProgressBarSkin_weaponLeftBgCls;
      
      private static var weaponLeftBg:BitmapData = Bitmap(new weaponLeftBgCls()).bitmapData;
      
      private static var weaponRightBgCls:Class = ProgressBarSkin_weaponRightBgCls;
      
      private static var weaponRightBg:BitmapData = Bitmap(new weaponRightBgCls()).bitmapData;
      
      private static var barShadowCls:Class = ProgressBarSkin_barShadowCls;
      
      private static var barShadow:BitmapData = Bitmap(new barShadowCls()).bitmapData;
      
      private static var barShadowLeftCls:Class = ProgressBarSkin_barShadowLeftCls;
      
      private static var barShadowLeft:BitmapData = Bitmap(new barShadowLeftCls()).bitmapData;
      
      private static var barShadowRightCls:Class = ProgressBarSkin_barShadowRightCls;
      
      private static var barShadowRight:BitmapData = Bitmap(new barShadowRightCls()).bitmapData;
      
      private static const HP_DM_COLOR:uint = 4964125;
      
      private static const HP_DM_BG_COLOR:uint = 2448911;
      
      private static const WEAPON_COLOR:uint = 14207247;
      
      private static const WEAPON_BG_COLOR:uint = 7758340;
      
      public static const hpDm:ProgressBarSkin = new ProgressBarSkin(HP_DM_COLOR,HP_DM_BG_COLOR,hpLeftDm,hpLeftBgDm,hpRightDm,hpRightBgDm,barShadow,barShadowLeft,barShadowRight);
      
      public static const weapon:ProgressBarSkin = new ProgressBarSkin(WEAPON_COLOR,WEAPON_BG_COLOR,weaponLeft,weaponLeftBg,weaponRight,weaponRightBg,barShadow,barShadowLeft,barShadowRight);
      
      public var color:uint;
      
      public var bgColor:uint;
      
      public var left:BitmapData;
      
      public var leftBg:BitmapData;
      
      public var right:BitmapData;
      
      public var rightBg:BitmapData;
      
      public var shadowLeft:BitmapData;
      
      public var shadowRight:BitmapData;
      
      public var shadow:BitmapData;
      
      public function ProgressBarSkin(color:uint, bgColor:uint, left:BitmapData, leftBg:BitmapData, right:BitmapData, rightBg:BitmapData, shadow:BitmapData, shadowLeft:BitmapData, shadowRight:BitmapData)
      {
         super();
         this.color = color;
         this.bgColor = bgColor;
         this.left = left;
         this.leftBg = leftBg;
         this.right = right;
         this.rightBg = rightBg;
         this.shadow = shadow;
         this.shadowLeft = shadowLeft;
         this.shadowRight = shadowRight;
      }
   }
}

