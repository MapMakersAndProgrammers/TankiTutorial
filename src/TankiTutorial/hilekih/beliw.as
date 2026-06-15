package hilekih
{
   import alternativa.engine3d.lights.OmniLight;
   import hygal.nufaneqog;
   import kefy.fare;
   import lycikehe.hebis;
   import lycikehe.virah;
   
   public final class beliw extends Sibyl
   {
      
      public function beliw(param1:fare)
      {
         super(param1,new OmniLight(0,0,0));
      }
      
      public function cabor(param1:hebis, param2:virah, param3:virah, param4:Number = 1) : void
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
      
      override public function qeguqugir(param1:int, param2:nufaneqog) : Boolean
      {
         var _loc3_:Boolean = super.qeguqugir(param1,param2);
         var _loc4_:OmniLight = OmniLight(qarehop);
         _loc4_.attenuationBegin *= rudi;
         _loc4_.attenuationEnd *= rudi;
         return _loc3_;
      }
   }
}

