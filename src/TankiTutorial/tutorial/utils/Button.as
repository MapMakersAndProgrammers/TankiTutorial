package tutorial.utils
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   
   public class Button extends Sprite
   {
      
      private var normal:DisplayObject;
      
      private var over:DisplayObject;
      
      private var down:DisplayObject;
      
      private var current:DisplayObject;
      
      private var textField:TextField;
      
      private var textY:Number;
      
      public function Button(normal:Form, over:Form, down:Form, label:String)
      {
         super();
         buttonMode = true;
         useHandCursor = true;
         mouseChildren = false;
         tabEnabled = false;
         this.normal = addChild(normal);
         this.over = addChild(over);
         this.down = addChild(down);
         over.visible = false;
         down.visible = false;
         if(label != null)
         {
            this.textField = Text.getTextField(label,22,normal.width,"center");
            this.textField.filters = [new DropShadowFilter(1,45,0,1,1,1,1.5)];
            addChild(this.textField);
            this.textField.y = (normal.height - this.textField.textHeight) * 0.5 - 4;
            this.textY = this.textField.y;
         }
         addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
      
      private function onUp(mouseEvent:MouseEvent) : void
      {
         this.current.visible = true;
         this.down.visible = false;
         if(this.textField != null)
         {
            this.textField.y = this.textY;
         }
      }
      
      private function onDown(mouseEvent:MouseEvent) : void
      {
         this.current.visible = false;
         this.down.visible = true;
         if(this.textField != null)
         {
            this.textField.y = this.textY + 1;
         }
      }
      
      private function onOver(mouseEvent:MouseEvent) : void
      {
         this.normal.visible = false;
         this.over.visible = true;
         this.current = this.over;
      }
      
      private function onOut(mouseEvent:MouseEvent) : void
      {
         this.normal.visible = true;
         this.over.visible = false;
         this.down.visible = false;
         if(this.textField != null)
         {
            this.textField.y = this.textY;
         }
         this.current = this.normal;
      }
   }
}

