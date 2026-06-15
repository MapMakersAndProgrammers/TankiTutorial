package tutorial
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class CrystalIndicator extends Sprite
   {
      
      private var kadat:Class;
      
      private var myw:MovieClip;
      
      public var soluwirac:int = 0;
      
      public function CrystalIndicator()
      {
         var toRadians:int;
         var doqe:Function = null;
         this.kadat = CrystalIndicator_crystalClass;
         super();
         doqe = function():void
         {
            myw.stop();
         };
         this.myw = new this.kadat() as MovieClip;
         addChild(this.myw);
         this.setValue(0);
         toRadians = 0;
         while(toRadians < 60)
         {
            this.myw.addFrameScript(8 + 10 * toRadians,doqe);
            toRadians++;
         }
      }
      
      public function setValue(param1:int) : void
      {
         this.soluwirac = param1;
         this.myw.gotoAndPlay(param1 == 0 ? 0 : param1 * 10);
      }
      
      public function inc() : void
      {
         ++this.soluwirac;
         this.myw.gotoAndPlay(this.soluwirac == 0 ? 0 : this.soluwirac * 10);
      }
   }
}

