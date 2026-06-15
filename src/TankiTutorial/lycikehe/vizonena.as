package lycikehe
{
   import alternativa.engine3d.core.Object3DContainer;
   import flash.geom.ColorTransform;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class vizonena extends Wopowur implements bowu
   {
      
      private var wahy:cyp;
      
      private var lamutameq:Number;
      
      private var luzulo:Number;
      
      private var maq:Boolean;
      
      private var toz:hebis;
      
      public function vizonena(param1:fare)
      {
         super(param1);
         this.wahy = new cyp(1,1);
         this.wahy.softAttenuation = 150;
      }
      
      public function cabor(param1:Number, param2:Number, param3:dosu, param4:Number, param5:Number, param6:hebis, param7:Number = 0.5, param8:Number = 0.5, param9:ColorTransform = null) : void
      {
         this.mohijy(param1,param2,param4,param7,param8,param9,param3);
         param6.nyw(this.wahy);
         this.luzulo = 0.001 * param5;
         this.toz = param6;
         this.lamutameq = 0;
         this.maq = false;
      }
      
      public function wivir(param1:Number, param2:Number, param3:dosu, param4:Number, param5:Number, param6:hebis, param7:Number = 0.5, param8:Number = 0.5, param9:ColorTransform = null) : void
      {
         this.cabor(param1,param2,param3,param4,param5,param6,param7,param8,param9);
         this.maq = true;
      }
      
      public function jipokikez(param1:Object3DContainer) : void
      {
         param1.addChild(this.wahy);
      }
      
      public function qeguqugir(param1:int, param2:nufaneqog) : Boolean
      {
         if(this.maq || this.lamutameq < this.wahy.nawirales())
         {
            this.wahy.les(this.lamutameq);
            this.lamutameq += param1 * this.luzulo;
            this.toz.lynetame(this.wahy,param2,param1);
            return true;
         }
         return false;
      }
      
      public function byr() : void
      {
         this.wahy.removeFromParent();
         this.wahy.napyr();
         this.toz.byr();
         this.toz = null;
         sapavaj();
      }
      
      public function wolyfami() : void
      {
         this.maq = false;
         this.lamutameq = this.wahy.nawirales();
      }
      
      private function mohijy(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:ColorTransform, param7:dosu) : void
      {
         this.wahy.width = param1;
         this.wahy.height = param2;
         this.wahy.rotation = param3;
         this.wahy.originX = param4;
         this.wahy.originY = param5;
         this.wahy.colorTransform = param6;
         this.wahy.vigipu(param7);
      }
   }
}

