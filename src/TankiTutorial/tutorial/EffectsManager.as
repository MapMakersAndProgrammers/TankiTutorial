package tutorial
{
   import alternativa.tanks.sfx.GraphicEffect;
   import alternativa.tanks.shared.camera.GameCamera;
   
   public class EffectsManager
   {
      
      private var taro:Vector.<GraphicEffect> = new Vector.<GraphicEffect>();
      
      private var ryquf:Vector.<GraphicEffect> = new Vector.<GraphicEffect>();
      
      public function EffectsManager()
      {
         super();
      }
      
      public function update(param1:uint, param2:GameCamera) : void
      {
         var _loc4_:int = 0;
         var _loc5_:GraphicEffect = null;
         var _loc3_:int = int(this.ryquf.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.ryquf.pop();
            this.taro.push(_loc5_);
            _loc5_.addedToScene(GameData.guzinizub);
            _loc4_++;
         }
         _loc3_ = int(this.taro.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.taro[_loc4_];
            if(!_loc5_.play(param1,param2))
            {
               _loc5_.destroy();
               _loc3_--;
               this.taro[_loc4_] = this.taro[_loc3_];
               this.taro.length = _loc3_;
            }
            _loc4_++;
         }
      }
      
      public function addEffect(param1:GraphicEffect) : void
      {
         this.ryquf.push(param1);
      }
   }
}

