package tutorial
{
   import embed.Embed;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import tutorial.commons.Lang;
   import tutorial.commons.LocalizedStrings;
   import tutorial.utils.Button;
   import tutorial.utils.Form;
   
   public class StartClip extends MovieClip
   {
      
      private var tuk:Button;
      
      private var jorodyk:Number;
      
      private var teziveqo:Number = 0.7;
      
      private var racefom:uint;
      
      public function StartClip()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.tuk = new Button(new Form(200,Embed.LEFT,Embed.FILL),new Form(200,Embed.LEFT_OVER,Embed.FILL_OVER),new Form(200,Embed.LEFT_PRESSED,Embed.FILL_PRESSED),Lang.getText(LocalizedStrings.START));
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.tuk.addEventListener(MouseEvent.CLICK,this.onClick);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.jorodyk = 1;
         this.onResize();
         addChild(this.tuk);
         stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         if(GameData.danewazam.contains(GameData.varezula))
         {
            GameData.danewazam.removeChild(GameData.varezula);
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:uint = uint(getTimer());
         var _loc3_:uint = (_loc2_ - this.racefom) * 0.001;
         this.jorodyk -= _loc3_ * 0.001;
         if(this.jorodyk <= this.teziveqo)
         {
            this.jorodyk = this.teziveqo;
            stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         this.onResize();
      }
      
      private function onRemoved(param1:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onResize(param1:Event = null) : void
      {
         var _loc2_:Point = new Point();
         _loc2_ = localToGlobal(_loc2_);
         this.drawBackground();
         this.tuk.x = int((stage.stageWidth - this.tuk.width) * 0.5) - _loc2_.x;
         this.tuk.y = int((stage.stageHeight - this.tuk.height) * 0.3) - _loc2_.y;
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Point = new Point();
         _loc1_ = localToGlobal(_loc1_);
      }
   }
}

