package tutorial.utils
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   
   public class Button extends Sprite
   {
      
      private var lefugefo:DisplayObject;
      
      private var sac:DisplayObject;
      
      private var fiki:DisplayObject;
      
      private var zewucadiz:DisplayObject;
      
      private var komopin:TextField;
      
      private var kejocebil:Number;
      
      public function Button(param1:Form, param2:Form, param3:Form, param4:String)
      {
         super();
         buttonMode = true;
         useHandCursor = true;
         mouseChildren = false;
         tabEnabled = false;
         this.lefugefo = addChild(param1);
         this.sac = addChild(param2);
         this.fiki = addChild(param3);
         param2.visible = false;
         param3.visible = false;
         if(param4 != null)
         {
            this.komopin = Text.getTextField(param4,22,param1.width,"center");
            this.komopin.filters = [new DropShadowFilter(1,45,0,1,1,1,1.5)];
            addChild(this.komopin);
            this.komopin.y = (param1.height - this.komopin.textHeight) * 0.5 - 4;
            this.kejocebil = this.komopin.y;
         }
         addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         this.zewucadiz.visible = true;
         this.fiki.visible = false;
         if(this.komopin != null)
         {
            this.komopin.y = this.kejocebil;
         }
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         this.zewucadiz.visible = false;
         this.fiki.visible = true;
         if(this.komopin != null)
         {
            this.komopin.y = this.kejocebil + 1;
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this.lefugefo.visible = false;
         this.sac.visible = true;
         this.zewucadiz = this.sac;
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.lefugefo.visible = true;
         this.sac.visible = false;
         this.fiki.visible = false;
         if(this.komopin != null)
         {
            this.komopin.y = this.kejocebil;
         }
         this.zewucadiz = this.lefugefo;
      }
   }
}

