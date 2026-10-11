package alternativa.tanks.sfx
{
   public class LightData
   {
      
      public static var smokyShotLight:LightAnimation;
      
      public static var smokyExplosionLight:LightAnimation;
      
      public static var plasmaMuzzleLight:LightAnimation;
      
      public static var plasmaShotLight:LightAnimation;
      
      public static var plasmaExplosionLight:LightAnimation;
      
      public static var flameMuzzleStartLight:LightAnimation;
      
      public static var flameMuzzleLoopLight:LightAnimation;
      
      public static var flameStreamStartLight:LightAnimation;
      
      public static var flameStreamLoopLight:LightAnimation;
      
      public function LightData()
      {
         super();
      }
      
      public static function init() : void
      {
         var records:Vector.<LightingEfectRecord> = null;
         records = new Vector.<LightingEfectRecord>();
         records[0] = new LightingEfectRecord(100,500,16571766,0.9,0);
         records[1] = new LightingEfectRecord(1,2,16571766,0,250);
         smokyShotLight = new LightAnimation(records);
         records = new Vector.<LightingEfectRecord>();
         records[0] = new LightingEfectRecord(100,900,16741656,1,0);
         records[1] = new LightingEfectRecord(100,900,16741656,0,900);
         smokyExplosionLight = new LightAnimation(records);
         records = new Vector.<LightingEfectRecord>();
         records[0] = new LightingEfectRecord(300,500,65535,0.3,0);
         records[1] = new LightingEfectRecord(1,2,65535,0,300);
         plasmaMuzzleLight = new LightAnimation(records);
         records = new Vector.<LightingEfectRecord>();
         records[0] = new LightingEfectRecord(100,300,65535,0.5,0);
         plasmaShotLight = new LightAnimation(records);
         records = new Vector.<LightingEfectRecord>();
         records[0] = new LightingEfectRecord(200,400,65535,0.3,0);
         records[1] = new LightingEfectRecord(1,2,65535,0,300);
         plasmaExplosionLight = new LightAnimation(records);
         records = new Vector.<LightingEfectRecord>();
         records[0] = new LightingEfectRecord(1,2,0,0,0);
         flameMuzzleStartLight = new LightAnimation(records);
         records = new Vector.<LightingEfectRecord>();
         records[0] = new LightingEfectRecord(1,2,0,0,0);
         flameMuzzleLoopLight = new LightAnimation(records);
         records = new Vector.<LightingEfectRecord>();
         records[0] = new LightingEfectRecord(1,2,16746496,0,0);
         records[1] = new LightingEfectRecord(100,1000,16746496,1,200);
         flameStreamStartLight = new LightAnimation(records);
         records = new Vector.<LightingEfectRecord>();
         records[0] = new LightingEfectRecord(50,1000,16746496,1,0);
         records[1] = new LightingEfectRecord(150,800,16746496,1,100);
         records[2] = new LightingEfectRecord(100,1500,16746496,1,200);
         records[3] = new LightingEfectRecord(150,800,16746496,1,300);
         records[4] = new LightingEfectRecord(50,1000,16746496,1,400);
         flameStreamLoopLight = new LightAnimation(records);
      }
   }
}

