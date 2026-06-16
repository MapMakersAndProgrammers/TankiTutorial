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
         var _loc4_:Bitmap = null;
         super();
         this.maskSP = new Sprite();
         this.maskSP.graphics.beginFill(0,1);
         this.maskSP.graphics.drawRect(0,0,this.WIDTH,26);
         this.maskSP.graphics.endFill();
         this.maskSP.width = this.WIDTH;
         this.maskSP.height = 24;
         addChild(this.maskSP);
         var _loc1_:Form = new Form(this.WIDTH + 6,Shared.stub,Shared.stub);
         _loc1_.x = -3;
         _loc1_.y = -3;
         addChild(_loc1_);
         var _loc2_:Sprite = new Sprite();
         addChild(_loc2_);
         var _loc3_:int = 0;
         while(_loc3_ < 34)
         {
            _loc4_ = new Bitmap(Shared.stub);
            _loc4_.x = _loc3_ * 17;
            _loc2_.addChild(_loc4_);
            _loc3_++;
         }
         _loc2_.mask = this.maskSP;
         this.setProgress(0);
      }
      
      public function setProgress(param1:Number) : void
      {
         this.maskSP.scaleX = param1;
      }
   }
}

