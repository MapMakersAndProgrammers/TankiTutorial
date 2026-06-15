package classes
{
   import flash.display.Bitmap;
   import flash.events.Event;
   
   public class SoundButton extends Button
   {
      
      private static const ESpeaker:Class = SoundButton_ESpeaker;
      
      private static const ECross:Class = SoundButton_ECross;
      
      private var cross:Bitmap = new Bitmap();
      
      public function SoundButton(param1:Function)
      {
         super(param1,true);
         this.cross.visible = false;
      }
      
      public function get state() : Boolean
      {
         return !this.cross.visible;
      }
      
      public function set state(param1:Boolean) : void
      {
         this.cross.visible = !param1;
      }
      
      override protected function init(param1:Event) : void
      {
         var _loc2_:Bitmap = new ESpeaker();
         _loc2_.y = 20;
         label.addChild(_loc2_);
         this.cross.bitmapData = new ECross().bitmapData;
         this.cross.y = 20;
         label.addChild(this.cross);
         super.init(param1);
      }
   }
}

