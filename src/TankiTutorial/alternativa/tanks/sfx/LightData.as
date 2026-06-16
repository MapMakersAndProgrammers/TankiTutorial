package alternativa.tanks.sfx
{
   public class LightData
   {
      
      public static var defajykeb:virah;
      
      public static var bevevy:virah;
      
      public static var soqi:virah;
      
      public static var zup:virah;
      
      public static var fid:virah;
      
      public static var kozuk:virah;
      
      public static var suho:virah;
      
      public static var qekar:virah;
      
      public static var wykalu:virah;
      
      public function LightData()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:Vector.<pybi> = null;
         _loc1_ = new Vector.<pybi>();
         _loc1_[0] = new pybi(100,500,16571766,0.9,0);
         _loc1_[1] = new pybi(1,2,16571766,0,250);
         defajykeb = new virah(_loc1_);
         _loc1_ = new Vector.<pybi>();
         _loc1_[0] = new pybi(100,900,16741656,1,0);
         _loc1_[1] = new pybi(100,900,16741656,0,900);
         bevevy = new virah(_loc1_);
         _loc1_ = new Vector.<pybi>();
         _loc1_[0] = new pybi(300,500,65535,0.3,0);
         _loc1_[1] = new pybi(1,2,65535,0,300);
         soqi = new virah(_loc1_);
         _loc1_ = new Vector.<pybi>();
         _loc1_[0] = new pybi(100,300,65535,0.5,0);
         zup = new virah(_loc1_);
         _loc1_ = new Vector.<pybi>();
         _loc1_[0] = new pybi(200,400,65535,0.3,0);
         _loc1_[1] = new pybi(1,2,65535,0,300);
         fid = new virah(_loc1_);
         _loc1_ = new Vector.<pybi>();
         _loc1_[0] = new pybi(1,2,0,0,0);
         kozuk = new virah(_loc1_);
         _loc1_ = new Vector.<pybi>();
         _loc1_[0] = new pybi(1,2,0,0,0);
         suho = new virah(_loc1_);
         _loc1_ = new Vector.<pybi>();
         _loc1_[0] = new pybi(1,2,16746496,0,0);
         _loc1_[1] = new pybi(100,1000,16746496,1,200);
         qekar = new virah(_loc1_);
         _loc1_ = new Vector.<pybi>();
         _loc1_[0] = new pybi(50,1000,16746496,1,0);
         _loc1_[1] = new pybi(150,800,16746496,1,100);
         _loc1_[2] = new pybi(100,1500,16746496,1,200);
         _loc1_[3] = new pybi(150,800,16746496,1,300);
         _loc1_[4] = new pybi(50,1000,16746496,1,400);
         wykalu = new virah(_loc1_);
      }
   }
}

