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
      
      private static var icons:Dictionary;
      
      private static var iconRect:Rectangle;
      
      private static const STATE_HIDDEN:int = 1;
      
      private static const STATE_SHOWING:int = 2;
      
      private static const STATE_VISIBLE:int = 4;
      
      private static const STATE_HIDING:int = 8;
      
      private static const MIN_ALPHA:Number = 0.2;
      
      private static var matrix:Matrix = new Matrix();
      
      private var _effectId:int;
      
      private var icon:BitmapData;
      
      private var blinkingTime:int;
      
      private var colorTransform:ColorTransform = new ColorTransform();
      
      private var blinkingStartTime:int;
      
      private var blinker:Blinker;
      
      private var alpha:Number = 1;
      
      private var needRedraw:Boolean;
      
      private var x:int;
      
      private var y:int;
      
      private var userTitle:UserTitle;
      
      private var state:int;
      
      private var blinking:Boolean;
      
      public function EffectIndicator(effectId:int, blinkingTime:int, userTitle:UserTitle, initialInterval:int, intervalDecrement:int)
      {
         super();
         if(icons == null)
         {
            initIcons();
         }
         this._effectId = effectId;
         this.icon = icons[effectId];
         this.blinkingTime = blinkingTime;
         this.userTitle = userTitle;
         this.blinker = new Blinker(initialInterval,20,intervalDecrement,MIN_ALPHA,1,10);
         this.state = STATE_HIDDEN;
      }
      
      private static function initIcons() : void
      {
         icons = new Dictionary();
         iconRect = BitmapData(icons[InventoryItemType.gezah]).rect;
      }
      
      public function get effectId() : int
      {
         return this._effectId;
      }
      
      public function isVisible() : Boolean
      {
         return (this.state & STATE_VISIBLE) != 0;
      }
      
      public function isHidden() : Boolean
      {
         return this.state == STATE_HIDDEN;
      }
      
      public function show(duration:int) : void
      {
         this.state &= ~STATE_HIDING;
         if(this.state != STATE_VISIBLE || this.alpha != 1)
         {
            this.needRedraw = true;
         }
         this.blinkingStartTime = getTimer() + duration - this.blinkingTime;
         this.blinking = false;
         this.alpha = 1;
         if(this.state == STATE_HIDDEN)
         {
            this.state = STATE_SHOWING;
         }
      }
      
      public function hide() : void
      {
         if(this.state == STATE_SHOWING)
         {
            this.userTitle.doHideIndicator(this);
            this.state = STATE_HIDDEN;
            return;
         }
         if((this.state & (STATE_HIDDEN | STATE_HIDING)) != 0)
         {
            return;
         }
         this.state |= STATE_HIDING;
         this.blinker.setMinValue(0);
         if(!this.blinking)
         {
            this.blinkingStartTime = 0;
            this.blinker.init(getTimer());
            this.blinking = true;
         }
      }
      
      public function clear(texture:BitmapData) : void
      {
         if(this.state == STATE_HIDDEN || this.state == STATE_SHOWING)
         {
            return;
         }
         iconRect.x = this.x;
         iconRect.y = this.y;
         texture.fillRect(iconRect,0);
      }
      
      public function setPosition(x:int, y:int) : void
      {
         this.x = x;
         this.y = y;
         this.needRedraw = true;
      }
      
      public function forceRedraw() : void
      {
         this.needRedraw = true;
      }
      
      public function update(time:int, deltaTime:int, texture:BitmapData) : void
      {
         if(this.state == STATE_HIDDEN)
         {
            return;
         }
         if(this.needRedraw)
         {
            this.draw(texture);
            this.needRedraw = false;
         }
         if(time > this.blinkingStartTime)
         {
            this.updateBlinking(time,deltaTime,texture);
         }
         if(this.state == STATE_SHOWING)
         {
            this.state = STATE_VISIBLE;
         }
      }
      
      private function updateBlinking(time:int, deltaTime:int, texture:BitmapData) : void
      {
         var value:Number = NaN;
         if(this.blinking)
         {
            value = Number(this.blinker.updateValue(time,deltaTime));
            if(value != this.alpha)
            {
               this.alpha = value;
               this.draw(texture);
            }
            if((this.state & STATE_HIDING) != 0 && this.alpha == 0)
            {
               this.userTitle.doHideIndicator(this);
               this.state = STATE_HIDDEN;
            }
         }
         else
         {
            this.blinker.setMinValue(MIN_ALPHA);
            this.blinker.init(time);
            this.blinking = true;
         }
      }
      
      private function draw(texture:BitmapData) : void
      {
         this.clear(texture);
         matrix.tx = this.x;
         matrix.ty = this.y;
         this.colorTransform.alphaMultiplier = this.alpha;
         texture.draw(this.icon,matrix,this.colorTransform,null,null,true);
      }
   }
}

