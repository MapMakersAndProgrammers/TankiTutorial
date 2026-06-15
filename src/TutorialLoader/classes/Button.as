package classes
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class Button extends Sprite
   {
      
      private static const ELeft:Class = Button_ELeft;
      
      private static const ELeftOver:Class = Button_ELeftOver;
      
      private static const ERight:Class = Button_ERight;
      
      private static const ERightOver:Class = Button_ERightOver;
      
      private static const ECenter:Class = Button_ECenter;
      
      private static const ECenterOver:Class = Button_ECenterOver;
      
      private var listener:Function;
      
      private var flip:Boolean;
      
      protected var label:Sprite;
      
      private var button:Sprite;
      
      private var left:Bitmap;
      
      private var leftOver:Bitmap;
      
      private var right:Bitmap;
      
      private var rightOver:Bitmap;
      
      private var center:Bitmap;
      
      private var centerOver:Bitmap;
      
      public function Button(param1:Function, param2:Boolean = false)
      {
         super();
         this.listener = param1;
         this.flip = param2;
         this.right = new ERight();
         this.rightOver = new ERightOver();
         this.rightOver.visible = false;
         this.center = new ECenter();
         this.centerOver = new ECenterOver();
         this.centerOver.visible = false;
         this.left = new ELeft();
         this.leftOver = new ELeftOver();
         this.leftOver.visible = false;
         this.button = new Sprite();
         this.button.buttonMode = true;
         this.button.useHandCursor = true;
         this.button.tabEnabled = false;
         this.label = new Sprite();
         this.label.mouseEnabled = false;
         this.label.mouseChildren = false;
         this.label.filters = [new DropShadowFilter(1,45,0,1,1,1,1.5)];
         addChild(this.left);
         addChild(this.right);
         addChild(this.center);
         addChild(this.leftOver);
         addChild(this.rightOver);
         addChild(this.centerOver);
         addChild(this.button);
         addChild(this.label);
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      protected function init(param1:Event) : void
      {
         if(!this.flip)
         {
            this.right.x = -this.right.width;
            this.label.x = this.right.x;
            this.center.x = this.right.x - Math.round(this.label.width) + 3;
            this.center.width = -this.center.x - this.right.width;
            this.left.x = this.center.x - this.left.width;
            this.button.graphics.beginFill(16711680,0);
            this.button.graphics.drawRect(this.left.x + 8,8,-this.left.x - 8 - 8,this.left.height - 8 - 8);
         }
         else
         {
            this.right.scaleX = -1;
            this.left.scaleX = -1;
            this.right.x = this.right.width;
            this.label.x = this.right.width;
            this.center.x = this.right.width;
            this.center.width = this.label.width;
            this.left.x = this.center.x + this.center.width + this.left.width;
            this.button.graphics.beginFill(16711680,0);
            this.button.graphics.drawRect(8,8,this.left.x - 8 - 8,this.left.height - 8 - 8);
         }
         this.rightOver.scaleX = this.right.scaleX;
         this.leftOver.scaleX = this.left.scaleX;
         this.rightOver.x = this.right.x;
         this.centerOver.x = this.center.x;
         this.centerOver.width = this.center.width;
         this.leftOver.x = this.left.x;
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         this.button.addEventListener(MouseEvent.MOUSE_OVER,this.onButtonOver);
         this.button.addEventListener(MouseEvent.MOUSE_OUT,this.onButtonOut);
         this.button.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
         this.button.addEventListener(MouseEvent.CLICK,this.onButtonClick);
      }
      
      private function onButtonOver(param1:MouseEvent) : void
      {
         this.left.visible = false;
         this.right.visible = false;
         this.center.visible = false;
         this.leftOver.visible = true;
         this.rightOver.visible = true;
         this.centerOver.visible = true;
      }
      
      private function onButtonOut(param1:MouseEvent) : void
      {
         this.label.y = 0;
         this.leftOver.y = 0;
         this.rightOver.y = 0;
         this.centerOver.y = 0;
         this.left.visible = true;
         this.right.visible = true;
         this.center.visible = true;
         this.leftOver.visible = false;
         this.rightOver.visible = false;
         this.centerOver.visible = false;
      }
      
      private function onButtonDown(param1:MouseEvent) : void
      {
         this.label.y = 1;
         this.leftOver.y = 1;
         this.rightOver.y = 1;
         this.centerOver.y = 1;
         param1.stopImmediatePropagation();
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         this.label.y = 0;
         this.leftOver.y = 0;
         this.rightOver.y = 0;
         this.centerOver.y = 0;
         this.listener();
         param1.stopImmediatePropagation();
      }
   }
}

