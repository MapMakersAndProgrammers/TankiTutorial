package alternativa.tanks.sfx.flamethrower
{
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.sfx.Object3DPositionProvider;
   import alternativa.tanks.sfx.LightAnimation;
   
   public final class OmniStreamLightEffect extends StreamLightEffect
   {
      
      public function OmniStreamLightEffect(pool:Pool)
      {
         super(pool,new OmniLight(0,0,0));
      }
      
      public function init(positionProvider:Object3DPositionProvider, startAnimation:LightAnimation, loopAnimation:LightAnimation, scale:Number = 1) : void
      {
         this.positionProvider = positionProvider;
         this.startTime = startAnimation.getLiveTime();
         this.loopTime = loopAnimation.getLiveTime();
         this.startAnimation = startAnimation;
         this.loopAnimation = loopAnimation;
         this.tize = loopTime / 4;
         this.scale = scale;
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

