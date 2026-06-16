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
         this.toz = param1;
         this.racefom = param2.getLiveTime();
         this.bibe = param3.getLiveTime();
         this.zituciky = param2;
         this.ged = param3;
         this.tize = bibe / 4;
         this.scale = param4;
         dozalij = true;
         wyzunime = 0;
         kat = true;
         rawo = false;
         jam = 0;
      }
      
      override public function play(param1:int, param2:GameCamera) : Boolean
      {
         var _loc3_:Boolean = super.play(param1,param2);
         var _loc4_:OmniLight = OmniLight(qarehop);
         _loc4_.attenuationBegin *= scale;
         _loc4_.attenuationEnd *= scale;
         return _loc3_;
      }
   }
}

