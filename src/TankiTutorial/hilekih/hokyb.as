package hilekih
{
   import lycikehe.Medima;
   import lycikehe.dosu;
   import lycikehe.haq;
   
   internal class hokyb extends Medima
   {
      
      private var gepoky:Vector.<haq>;
      
      private var nomupiz:int;
      
      private var tyfu:Number;
      
      public function hokyb()
      {
         super(1,1,0.5,0);
         shadowMapAlphaThreshold = 2;
         depthMapAlphaThreshold = 2;
         useShadowMap = false;
         useLight = false;
      }
      
      public function cabor(param1:dosu) : void
      {
         setMaterialToAllFaces(param1.myma);
         this.gepoky = param1.qyvoladeg;
         this.nomupiz = this.gepoky.length;
         this.tyfu = 0;
         this.toli(this.gepoky[0]);
      }
      
      public function napyr() : void
      {
         setMaterialToAllFaces(null);
         this.gepoky = null;
         this.nomupiz = 0;
      }
      
      public function kidi(param1:Number, param2:Number) : void
      {
         this.tyfu += param1 * param2;
         if(this.tyfu >= this.nomupiz)
         {
            this.tyfu = 0;
         }
         this.toli(this.gepoky[int(this.tyfu)]);
      }
      
      private function toli(param1:haq) : void
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

