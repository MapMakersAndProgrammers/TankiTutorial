package alternativa.tanks.shared.usertitle
{
   import alternativa.tanks.sfx.Blinker;
   import alternativa.tanks.sfx.InventoryItemType;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class EffectIndicator
   {
      
      private static var leb:Dictionary;
      
      private static var qyhyli:Rectangle;
      
      private static const vybizy:int = 1;
      
      private static const koqacap:int = 2;
      
      private static const dec:int = 4;
      
      private static const mobihyle:int = 8;
      
      private static const myz:Number = 0.2;
      
      private static var gijalatyt:Matrix = new Matrix();
      
      private var japesuh:int;
      
      private var fidycah:BitmapData;
      
      private var cug:int;
      
      private var fur:ColorTransform = new ColorTransform();
      
      private var nedup:int;
      
      private var duleruve:Blinker;
      
      private var wedebuga:Number = 1;
      
      private var cizyhemy:Boolean;
      
      private var x:int;
      
      private var y:int;
      
      private var zab:UserTitle;
      
      private var kejo:int;
      
      private var jemusyvin:Boolean;
      
      public function EffectIndicator(param1:int, param2:int, param3:UserTitle, param4:int, param5:int)
      {
         super();
         if(leb == null)
         {
            initIcons();
         }
         this.japesuh = param1;
         this.fidycah = leb[param1];
         this.cug = param2;
         this.zab = param3;
         this.duleruve = new Blinker(param4,20,param5,myz,1,10);
         this.kejo = vybizy;
      }
      
      private static function initIcons() : void
      {
         leb = new Dictionary();
         qyhyli = BitmapData(leb[InventoryItemType.gezah]).rect;
      }
      
      public function get effectId() : int
      {
         return this.japesuh;
      }
      
      public function isVisible() : Boolean
      {
         return (this.kejo & dec) != 0;
      }
      
      public function isHidden() : Boolean
      {
         return this.kejo == vybizy;
      }
      
      public function show(param1:int) : void
      {
         this.kejo &= ~mobihyle;
         if(this.kejo != dec || this.wedebuga != 1)
         {
            this.cizyhemy = true;
         }
         this.nedup = getTimer() + param1 - this.cug;
         this.jemusyvin = false;
         this.wedebuga = 1;
         if(this.kejo == vybizy)
         {
            this.kejo = koqacap;
         }
      }
      
      public function hide() : void
      {
         if(this.kejo == koqacap)
         {
            this.zab.doHideIndicator(this);
            this.kejo = vybizy;
            return;
         }
         if((this.kejo & (vybizy | mobihyle)) != 0)
         {
            return;
         }
         this.kejo |= mobihyle;
         this.duleruve.setMinValue(0);
         if(!this.jemusyvin)
         {
            this.nedup = 0;
            this.duleruve.init(getTimer());
            this.jemusyvin = true;
         }
      }
      
      public function clear(param1:BitmapData) : void
      {
         if(this.kejo == vybizy || this.kejo == koqacap)
         {
            return;
         }
         qyhyli.x = this.x;
         qyhyli.y = this.y;
         param1.fillRect(qyhyli,0);
      }
      
      public function setPosition(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
         this.cizyhemy = true;
      }
      
      public function forceRedraw() : void
      {
         this.cizyhemy = true;
      }
      
      public function update(param1:int, param2:int, param3:BitmapData) : void
      {
         if(this.kejo == vybizy)
         {
            return;
         }
         if(this.cizyhemy)
         {
            this.draw(param3);
            this.cizyhemy = false;
         }
         if(param1 > this.nedup)
         {
            this.updateBlinking(param1,param2,param3);
         }
         if(this.kejo == koqacap)
         {
            this.kejo = dec;
         }
      }
      
      private function updateBlinking(param1:int, param2:int, param3:BitmapData) : void
      {
         var _loc4_:Number = NaN;
         if(this.jemusyvin)
         {
            _loc4_ = Number(this.duleruve.updateValue(param1,param2));
            if(_loc4_ != this.wedebuga)
            {
               this.wedebuga = _loc4_;
               this.draw(param3);
            }
            if((this.kejo & mobihyle) != 0 && this.wedebuga == 0)
            {
               this.zab.doHideIndicator(this);
               this.kejo = vybizy;
            }
         }
         else
         {
            this.duleruve.setMinValue(myz);
            this.duleruve.init(param1);
            this.jemusyvin = true;
         }
      }
      
      private function draw(param1:BitmapData) : void
      {
         this.clear(param1);
         gijalatyt.tx = this.x;
         gijalatyt.ty = this.y;
         this.fur.alphaMultiplier = this.wedebuga;
         param1.draw(this.fidycah,gijalatyt,this.fur,null,null,true);
      }
   }
}

