package alternativa.tanks.shared.usertitle
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class ProgressBarSkin
   {
      
      private static var winowuge:Class = ProgressBarSkin_hpLeftDmCls;
      
      private static var dibidebas:BitmapData = Bitmap(new winowuge()).bitmapData;
      
      private static var fohohirah:Class = ProgressBarSkin_hpRightDmCls;
      
      private static var lyrimaqu:BitmapData = Bitmap(new fohohirah()).bitmapData;
      
      private static var ziqa:Class = ProgressBarSkin_hpLeftBgDmCls;
      
      private static var kivyv:BitmapData = Bitmap(new ziqa()).bitmapData;
      
      private static var vejof:Class = ProgressBarSkin_hpRightBgDmCls;
      
      private static var qebo:BitmapData = Bitmap(new vejof()).bitmapData;
      
      private static var hoze:Class = ProgressBarSkin_weaponLeftCls;
      
      private static var mopode:BitmapData = Bitmap(new hoze()).bitmapData;
      
      private static var pyfyzahit:Class = ProgressBarSkin_weaponRightCls;
      
      private static var repygyr:BitmapData = Bitmap(new pyfyzahit()).bitmapData;
      
      private static var tylydi:Class = ProgressBarSkin_weaponLeftBgCls;
      
      private static var qapupo:BitmapData = Bitmap(new tylydi()).bitmapData;
      
      private static var hudipuce:Class = ProgressBarSkin_weaponRightBgCls;
      
      private static var nujotafi:BitmapData = Bitmap(new hudipuce()).bitmapData;
      
      private static var bepezysyt:Class = ProgressBarSkin_barShadowCls;
      
      private static var zawor:BitmapData = Bitmap(new bepezysyt()).bitmapData;
      
      private static var hupygofi:Class = ProgressBarSkin_barShadowLeftCls;
      
      private static var qequgow:BitmapData = Bitmap(new hupygofi()).bitmapData;
      
      private static var zecodiqy:Class = ProgressBarSkin_barShadowRightCls;
      
      private static var gaminyqeb:BitmapData = Bitmap(new zecodiqy()).bitmapData;
      
      private static const rali:uint = 4964125;
      
      private static const nini:uint = 2448911;
      
      private static const nebekaja:uint = 14207247;
      
      private static const gafujyp:uint = 7758340;
      
      public static const gify:ProgressBarSkin = new ProgressBarSkin(rali,nini,dibidebas,kivyv,lyrimaqu,qebo,zawor,qequgow,gaminyqeb);
      
      public static const mub:ProgressBarSkin = new ProgressBarSkin(nebekaja,gafujyp,mopode,qapupo,repygyr,nujotafi,zawor,qequgow,gaminyqeb);
      
      public var color:uint;
      
      public var furoveb:uint;
      
      public var bypot:BitmapData;
      
      public var row:BitmapData;
      
      public var cyv:BitmapData;
      
      public var sikaq:BitmapData;
      
      public var roga:BitmapData;
      
      public var bavofyhe:BitmapData;
      
      public var nuvyma:BitmapData;
      
      public function ProgressBarSkin(param1:uint, param2:uint, param3:BitmapData, param4:BitmapData, param5:BitmapData, param6:BitmapData, param7:BitmapData, param8:BitmapData, param9:BitmapData)
      {
         super();
         this.color = param1;
         this.furoveb = param2;
         this.bypot = param3;
         this.row = param4;
         this.cyv = param5;
         this.sikaq = param6;
         this.nuvyma = param7;
         this.roga = param8;
         this.bavofyhe = param9;
      }
   }
}

