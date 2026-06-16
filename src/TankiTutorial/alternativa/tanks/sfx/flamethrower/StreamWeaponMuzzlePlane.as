package alternativa.tanks.sfx.flamethrower
{
   import alternativa.tanks.sfx.Medima;
   import alternativa.tanks.sfx.dosu;
   import alternativa.tanks.sfx.haq;
   
   internal class StreamWeaponMuzzlePlane extends Medima
   {
      
      private var gepoky:Vector.<haq>;
      
      private var nomupiz:int;
      
      private var tyfu:Number;
      
      public function StreamWeaponMuzzlePlane()
      {
         super(1,1,0.5,0);
         shadowMapAlphaThreshold = 2;
         depthMapAlphaThreshold = 2;
         useShadowMap = false;
         useLight = false;
      }
      
      public function init(param1:dosu) : void
      {
         setMaterialToAllFaces(param1.myma);
         this.gepoky = param1.qyvoladeg;
         this.nomupiz = this.gepoky.length;
         this.tyfu = 0;
         this.setFrame(this.gepoky[0]);
      }
      
      public function clear() : void
      {
         setMaterialToAllFaces(null);
         this.gepoky = null;
         this.nomupiz = 0;
      }
      
      public function update(param1:Number, param2:Number) : void
      {
         this.tyfu += param1 * param2;
         if(this.tyfu >= this.nomupiz)
         {
            this.tyfu = 0;
         }
         this.setFrame(this.gepoky[int(this.tyfu)]);
      }
      
      private function setFrame(param1:haq) : void
      {
         gar.u = param1.picylyno;
         gar.v = param1.lesenac;
         nityt.u = param1.picylyno;
         nityt.v = param1.salemat;
         fysu.u = param1.pusunawy;
         fysu.v = param1.salemat;
         rok.u = param1.pusunawy;
         rok.v = param1.lesenac;
      }
   }
}

