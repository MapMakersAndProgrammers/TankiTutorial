package alternativa.tanks.sound
{
   import alternativa.tanks.sfx.ISound3DEffect;
   
   internal class SoundEffectData
   {
      
      private static var numObjects:int;
      
      private static var pool:Vector.<SoundEffectData> = new Vector.<SoundEffectData>();
      
      public var distanceSqr:Number;
      
      public var effect:ISound3DEffect;
      
      public function SoundEffectData(distanceSqr:Number, effect:ISound3DEffect)
      {
         super();
         this.distanceSqr = distanceSqr;
         this.effect = effect;
      }
      
      public static function create(param1:Number, param2:ISound3DEffect) : SoundEffectData
      {
         var soundEffectData:SoundEffectData = null;
         if(numObjects > 0)
         {
            soundEffectData = pool[--numObjects];
            pool[numObjects] = null;
            soundEffectData.distanceSqr = param1;
            soundEffectData.effect = param2;
            return soundEffectData;
         }
         return new SoundEffectData(param1,param2);
      }
      
      public static function destroy(soundEffectData:SoundEffectData) : void
      {
         soundEffectData.effect = null;
         pool[numObjects++] = soundEffectData;
      }
   }
}

