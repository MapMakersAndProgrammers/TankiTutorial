package alternativa.tanks.sfx
{
   public class LightingEfectRecord
   {
      
      public var attenuationBegin:Number;
      
      public var attenuationEnd:Number;
      
      public var color:uint;
      
      public var intensity:Number;
      
      public var time:int;
      
      public function LightingEfectRecord(attenuationBegin:Number = 0, attenuationEnd:Number = 0, color:uint = 0, intensity:Number = 0, time:int = 0)
      {
         super();
         this.attenuationBegin = attenuationBegin;
         this.attenuationEnd = attenuationEnd;
         this.color = color;
         this.intensity = intensity;
         this.time = time;
      }
   }
}

