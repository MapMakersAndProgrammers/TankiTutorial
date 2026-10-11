package tutorial.commons
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class ProgressBar extends Sprite
   {
      
      private var maskSP:Sprite;
      
      private const WIDTH:int = 576;
      
      public function ProgressBar()
      {
         var bitmap:Bitmap = null;
         super();
         this.maskSP = new Sprite();
         this.maskSP.graphics.beginFill(0,1);
         this.maskSP.graphics.drawRect(0,0,this.WIDTH,26);
         this.maskSP.graphics.endFill();
         this.maskSP.width = this.WIDTH;
         this.maskSP.height = 24;
         addChild(this.maskSP);
         var form:Form = new Form(this.WIDTH + 6,Shared.stub,Shared.stub);
         form.x = -3;
         form.y = -3;
         addChild(form);
         var sprite:Sprite = new Sprite();
         addChild(sprite);
         var i:int = 0;
         while(i < 34)
         {
            bitmap = new Bitmap(Shared.stub);
            bitmap.x = i * 17;
            sprite.addChild(bitmap);
            i++;
         }
         sprite.mask = this.maskSP;
         this.setProgress(0);
      }
      
      public function setProgress(progress:Number) : void
      {
         this.maskSP.scaleX = progress;
      }
   }
}

