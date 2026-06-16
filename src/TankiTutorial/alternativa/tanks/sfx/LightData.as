package alternativa.tanks.sfx
{
   public class LightData
   {
      
      public static var defajykeb:LightAnimation;
      
      public static var bevevy:LightAnimation;
      
      public static var soqi:LightAnimation;
      
      public static var zup:LightAnimation;
      
      public static var fid:LightAnimation;
      
      public static var kozuk:LightAnimation;
      
      public static var suho:LightAnimation;
      
      public static var qekar:LightAnimation;
      
      public static var wykalu:LightAnimation;
      
      public function LightData()
      {
         super();
      }
      
      public static function init() : void
      {
         var _loc1_:Vector.<LightingEfectRecord> = null;
         _loc1_ = new Vector.<LightingEfectRecord>();
         _loc1_[0] = new LightingEfectRecord(100,500,16571766,0.9,0);
         _loc1_[1] = new LightingEfectRecord(1,2,16571766,0,250);
         defajykeb = new LightAnimation(_loc1_);
         _loc1_ = new Vector.<LightingEfectRecord>();
         _loc1_[0] = new LightingEfectRecord(100,900,16741656,1,0);
         _loc1_[1] = new LightingEfectRecord(100,900,16741656,0,900);
         bevevy = new LightAnimation(_loc1_);
         _loc1_ = new Vector.<LightingEfectRecord>();
         _loc1_[0] = new LightingEfectRecord(300,500,65535,0.3,0);
         _loc1_[1] = new LightingEfectRecord(1,2,65535,0,300);
         soqi = new LightAnimation(_loc1_);
         _loc1_ = new Vector.<LightingEfectRecord>();
         _loc1_[0] = new LightingEfectRecord(100,300,65535,0.5,0);
         zup = new LightAnimation(_loc1_);
         _loc1_ = new Vector.<LightingEfectRecord>();
         _loc1_[0] = new LightingEfectRecord(200,400,65535,0.3,0);
         _loc1_[1] = new LightingEfectRecord(1,2,65535,0,300);
         fid = new LightAnimation(_loc1_);
         _loc1_ = new Vector.<LightingEfectRecord>();
         _loc1_[0] = new LightingEfectRecord(1,2,0,0,0);
         kozuk = new LightAnimation(_loc1_);
         _loc1_ = new Vector.<LightingEfectRecord>();
         _loc1_[0] = new LightingEfectRecord(1,2,0,0,0);
         suho = new LightAnimation(_loc1_);
         _loc1_ = new Vector.<LightingEfectRecord>();
         _loc1_[0] = new LightingEfectRecord(1,2,16746496,0,0);
         _loc1_[1] = new LightingEfectRecord(100,1000,16746496,1,200);
         qekar = new LightAnimation(_loc1_);
         _loc1_ = new Vector.<LightingEfectRecord>();
         _loc1_[0] = new LightingEfectRecord(50,1000,16746496,1,0);
         _loc1_[1] = new LightingEfectRecord(150,800,16746496,1,100);
         _loc1_[2] = new LightingEfectRecord(100,1500,16746496,1,200);
         _loc1_[3] = new LightingEfectRecord(150,800,16746496,1,300);
         _loc1_[4] = new LightingEfectRecord(50,1000,16746496,1,400);
         wykalu = new LightAnimation(_loc1_);
      }
   }
}

