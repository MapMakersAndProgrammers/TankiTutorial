package alternativa.tanks.sfx.flamethrower
{
   import alternativa.engine3d.lights.OmniLight;
   import hygal.nufaneqog;
   import kefy.fare;
   import alternativa.tanks.sfx.hebis;
   import alternativa.tanks.sfx.virah;
   
   public final class OmniStreamLightEffect extends Sibyl
   {
      
      public function OmniStreamLightEffect(param1:fare)
      {
         super(param1,new OmniLight(0,0,0));
      }
      
      public function init(param1:hebis, param2:virah, param3:virah, param4:Number = 1) : void
      {
         this.toz = param1;
         this.racefom = param2.doz();
         this.bibe = param3.doz();
         this.zituciky = param2;
         this.ged = param3;
         this.tize = bibe / 4;
         this.rudi = param4;
         dozalij = true;
         wyzunime = 0;
         kat = true;
         rawo = false;
         jam = 0;
      }
      
      override public function play(param1:int, param2:nufaneqog) : Boolean
      {
         var _loc3_:Boolean = super.play(param1,param2);
         var _loc4_:OmniLight = OmniLight(qarehop);
         _loc4_.attenuationBegin *= rudi;
         _loc4_.attenuationEnd *= rudi;
         return _loc3_;
      }
   }
}

