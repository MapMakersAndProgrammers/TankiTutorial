package sypogo
{
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import fyf.vuteci;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class vewityv extends Wopowur
   {
      
      public var zyl:BitmapData;
      
      public var myma:TextureMaterial;
      
      public var gohigewam:int;
      
      public function vewityv(param1:fare)
      {
         super(param1);
      }
      
      public static function leqame(param1:TextureMaterial, param2:BitmapData, param3:int) : vewityv
      {
         var _loc4_:vewityv = vewityv(vuteci.murow.loq(vewityv));
         _loc4_.cabor(param1,param2,param3);
         return _loc4_;
      }
      
      public function cabor(param1:TextureMaterial, param2:BitmapData, param3:int) : void
      {
         this.myma = param1;
         this.zyl = param2;
         this.gohigewam = param3;
      }
      
      public function dumyripov() : void
      {
         this.myma.texture = this.zyl;
      }
      
      override public function sapavaj() : void
      {
         this.zyl = null;
         this.myma = null;
         super.sapavaj();
      }
   }
}

