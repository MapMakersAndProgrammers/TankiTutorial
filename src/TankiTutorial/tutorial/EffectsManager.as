package tutorial
{
   import alternativa.tanks.sfx.GraphicEffect;
   import alternativa.tanks.shared.camera.GameCamera;
   
   public class EffectsManager
   {
      
      private var effects:Vector.<GraphicEffect> = new Vector.<GraphicEffect>();
      
      private var newEffects:Vector.<GraphicEffect> = new Vector.<GraphicEffect>();
      
      public function EffectsManager()
      {
         super();
      }
      
      public function update(time:uint, camera:GameCamera) : void
      {
         var i:int = 0;
         var effect:GraphicEffect = null;
         var len:int = int(this.newEffects.length);
         i = 0;
         while(i < len)
         {
            effect = this.newEffects.pop();
            this.effects.push(effect);
            effect.addedToScene(GameData.kdContainer);
            i++;
         }
         len = int(this.effects.length);
         i = 0;
         while(i < len)
         {
            effect = this.effects[i];
            if(!effect.play(time,camera))
            {
               effect.destroy();
               len--;
               this.effects[i] = this.effects[len];
               this.effects.length = len;
            }
            i++;
         }
      }
      
      public function addEffect(effect:GraphicEffect) : void
      {
         this.newEffects.push(effect);
      }
   }
}

