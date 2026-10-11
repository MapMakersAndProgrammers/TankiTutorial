package alternativa.tanks.sfx.flamethrower
{
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.sfx.Object3DPositionProvider;
   import alternativa.tanks.sfx.LightAnimation;
   
   public final class OmniStreamLightEffect extends StreamLightEffect
   {
      
      public function OmniStreamLightEffect(param1:Pool)
      {
         super(param1,new OmniLight(0,0,0));
      }
      
      public function init(param1:Object3DPositionProvider, param2:LightAnimation, param3:LightAnimation, param4:Number = 1) : void
      {
         this.positionProvider = param1;
         this.racefom = param2.getLiveTime();
         this.loopTime = param3.getLiveTime();
         this.startAnimation = param2;
         this.loopAnimation = param3;
         this.tize = loopTime / 4;
         this.scale = param4;
         starting = true;
         time = 0;
         alive = true;
         stopping = false;
         stopTime = 0;
      }
      
      override public function play(deltaTime:int, camera:GameCamera) : Boolean
      {
         var result:Boolean = super.play(deltaTime,camera);
         var omniLight:OmniLight = OmniLight(light);
         omniLight.attenuationBegin *= scale;
         omniLight.attenuationEnd *= scale;
         return result;
      }
   }
}

