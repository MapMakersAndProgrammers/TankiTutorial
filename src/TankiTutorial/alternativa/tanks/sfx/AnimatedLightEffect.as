package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.lights.OmniLight;
   import gafaduzuw.finajylom;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   
   public final class AnimatedLightEffect extends Wopowur implements bowu
   {
      
      public static const nimowu:Number = 99999;
      
      public var qarehop:OmniLight;
      
      private var toz:hebis;
      
      private var zeg:virah;
      
      private var wyzunime:int;
      
      private var sef:int;
      
      private var bol:Boolean;
      
      private var kat:Boolean;
      
      private var gog:Number;
      
      private var jawyn:Number;
      
      private var position:finajylom = new finajylom();
      
      public function AnimatedLightEffect(param1:fare)
      {
         super(param1);
         this.qarehop = new OmniLight(0,0,0);
      }
      
      public function init(param1:hebis, param2:virah, param3:Number = 99999, param4:Boolean = false) : void
      {
         this.initFromTime(param1,param2.doz(),param2,param3,param4);
      }
      
      public function initFromTime(param1:hebis, param2:int, param3:virah, param4:Number = 99999, param5:Boolean = false) : void
      {
         this.toz = param1;
         this.sef = param2;
         this.wyzunime = 0;
         this.zeg = param3;
         this.bol = param5;
         this.kat = true;
         this.gog = param4;
         this.jawyn = param4 / 4 * 3;
         param1.initPosition(this.qarehop);
      }
      
      public function initFromAnimation(param1:hebis, param2:dosu, param3:virah, param4:Number = 99999, param5:Boolean = false) : void
      {
         this.initFromTime(param1,param2.qyvoladeg.length / param2.macoqaka * 1000,param3,param4,param5);
      }
      
      public function addedToScene(param1:Object3DContainer) : void
      {
         param1.addChild(this.qarehop);
      }
      
      public function play(param1:int, param2:nufaneqog) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.kat)
         {
            this.zeg.pepare(this.qarehop,this.wyzunime,this.sef);
            this.toz.updateObjectPosition(this.qarehop,param2,param1);
            this.wyzunime += param1;
            if(this.wyzunime > this.sef)
            {
               if(this.bol)
               {
                  this.wyzunime %= this.sef;
               }
               else
               {
                  this.kat = false;
               }
            }
            this.position.kan = this.qarehop.x;
            this.position.zofydizug = this.qarehop.y;
            this.position.qyririg = this.qarehop.z;
            _loc3_ = Number(this.position.jepik(param2.position));
            if(_loc3_ > this.jawyn)
            {
               _loc4_ = 1 - (_loc3_ - this.jawyn) / (this.gog - this.jawyn);
               this.qarehop.intensity *= _loc4_;
               this.qarehop.visible = _loc3_ < this.gog;
            }
            return this.kat;
         }
         return false;
      }
      
      public function destroy() : void
      {
         this.qarehop.removeFromParent();
         this.zeg = null;
         this.toz = null;
      }
      
      public function kill() : void
      {
         this.kat = false;
      }
   }
}

