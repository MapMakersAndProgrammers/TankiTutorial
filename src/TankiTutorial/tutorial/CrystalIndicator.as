package tutorial
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class CrystalIndicator extends Sprite
   {
      
      private var crystalClass:Class;
      
      private var clip:MovieClip;
      
      public var value:int = 0;
      
      public function CrystalIndicator()
      {
         var toRadians:int;
         var stopClip:Function = null;
         this.crystalClass = CrystalIndicator_crystalClass;
         super();
         stopClip = function():void
         {
            clip.stop();
         };
         this.clip = new this.crystalClass() as MovieClip;
         addChild(this.clip);
         this.setValue(0);
         toRadians = 0;
         while(toRadians < 60)
         {
            this.clip.addFrameScript(8 + 10 * toRadians,stopClip);
            toRadians++;
         }
      }
      
      public function setValue(value:int) : void
      {
         this.value = value;
         this.clip.gotoAndPlay(value == 0 ? 0 : value * 10);
      }
      
      public function inc() : void
      {
         ++this.value;
         this.clip.gotoAndPlay(this.value == 0 ? 0 : this.value * 10);
      }
   }
}

