package dyfataki
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.objects.Mesh;
   import gafaduzuw.finajylom;
   import jydanitu.mase;
   import wijymifun.Lak;
   
   public class cogaj extends Mesh implements Lak
   {
      
      private var fyhum:mase;
      
      private var supy:Number = 1;
      
      private var fidemujil:Number = 1;
      
      public function cogaj(param1:mase, param2:Mesh)
      {
         super();
         this.fyhum = param1;
         clonePropertiesFrom(param2);
         var _loc3_:Face = param2.faces[0];
         setMaterialToAllFaces(_loc3_.material);
         sorting = Sorting.DYNAMIC_BSP;
      }
      
      public function cabor() : void
      {
         rotationX = 0;
         rotationY = 0;
         rotationZ = 0;
         scaleX = 1;
         scaleY = 1;
         scaleZ = 1;
         this.supy = 1;
         this.fidemujil = 1;
         this.ruwy();
      }
      
      public function nypujusy() : mase
      {
         return this.fyhum;
      }
      
      public function gihane() : Number
      {
         return this.supy;
      }
      
      public function newofelan(param1:Number) : void
      {
         this.supy = param1;
         this.ruwy();
      }
      
      public function zimas(param1:finajylom) : void
      {
         param1.kan = x;
         param1.zofydizug = y;
         param1.qyririg = z;
      }
      
      public function tahuh(param1:Number) : void
      {
         this.fidemujil = param1;
         this.ruwy();
      }
      
      private function ruwy() : void
      {
         alpha = this.fidemujil * this.supy;
      }
      
      public function sapavaj() : void
      {
         this.supy = 1;
         this.fidemujil = 1;
         wapakojy.zij(this);
      }
   }
}

