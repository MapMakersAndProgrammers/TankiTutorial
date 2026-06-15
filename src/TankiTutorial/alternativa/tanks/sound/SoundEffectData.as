package alternativa.tanks.sound
{
   import alternativa.tanks.sfx.ISound3DEffect;
   
   internal class SoundEffectData
   {
      
      private static var dosomez:int;
      
      private static var hybuhy:Vector.<SoundEffectData> = new Vector.<SoundEffectData>();
      
      public var pyvyg:Number;
      
      public var nyniqadi:ISound3DEffect;
      
      public function SoundEffectData(param1:Number, param2:ISound3DEffect)
      {
         super();
         this.pyvyg = param1;
         this.nyniqadi = param2;
      }
      
      public static function create(param1:Number, param2:ISound3DEffect) : SoundEffectData
      {
         var _loc3_:SoundEffectData = null;
         if(dosomez > 0)
         {
            _loc3_ = hybuhy[--dosomez];
            hybuhy[dosomez] = null;
            _loc3_.pyvyg = param1;
            _loc3_.nyniqadi = param2;
            return _loc3_;
         }
         return new SoundEffectData(param1,param2);
      }
      
      public static function destroy(param1:SoundEffectData) : void
      {
         param1.nyniqadi = null;
         hybuhy[dosomez++] = param1;
      }
   }
}

