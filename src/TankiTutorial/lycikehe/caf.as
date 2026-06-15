package lycikehe
{
   import alternativa.engine3d.core.Object3DContainer;
   import gafaduzuw.finajylom;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   
   public class caf extends Wopowur implements bowu
   {
      
      private static const hydobym:Number = 100;
      
      private var tytofu:Number;
      
      private var rudi:Number;
      
      private var zeqowas:Number;
      
      private var gefeci:fikap;
      
      private var wyzunime:int;
      
      private var davaqymev:int;
      
      public function caf(param1:fare)
      {
         super(param1);
         this.gefeci = new fikap(hydobym);
      }
      
      public function cabor(param1:Number, param2:finajylom, param3:finajylom, param4:Number, param5:dosu, param6:Number) : void
      {
         this.gefeci.cabor(param5,0.001 * param4);
         this.davaqymev = this.gefeci.masity();
         this.wyzunime = 0;
         this.tytofu = 0.001 * param6;
         this.zeqowas = param1 / hydobym;
         this.rudi = this.zeqowas;
         this.gefeci.x = param2.kan;
         this.gefeci.y = param2.zofydizug;
         this.gefeci.z = param2.qyririg;
         this.gefeci.rotationX = param3.kan;
         this.gefeci.rotationY = param3.zofydizug;
         this.gefeci.rotationZ = param3.qyririg;
      }
      
      public function jipokikez(param1:Object3DContainer) : void
      {
         param1.addChild(this.gefeci);
      }
      
      public function qeguqugir(param1:int, param2:nufaneqog) : Boolean
      {
         if(this.wyzunime >= this.davaqymev)
         {
            return false;
         }
         this.gefeci.luqacij(this.wyzunime);
         this.wyzunime += param1;
         this.gefeci.scaleX = this.rudi;
         this.gefeci.scaleY = this.rudi;
         this.rudi += this.zeqowas * this.tytofu * param1;
         return true;
      }
      
      public function byr() : void
      {
         this.gefeci.removeFromParent();
         this.gefeci.napyr();
         sapavaj();
      }
      
      public function wolyfami() : void
      {
         this.wyzunime = this.davaqymev;
      }
   }
}

