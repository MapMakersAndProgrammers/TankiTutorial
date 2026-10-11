package alternativa.tanks.shared.usertitle
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ProgressBar
   {
      
      private static var matrix:Matrix = new Matrix();
      
      public var maxValue:int;
      
      private var width:int;
      
      private var shadowLeftWidth:int;
      
      private var shadowHeight:int;
      
      private var offsetX:int;
      
      private var offsetY:int;
      
      private var skin:ProgressBarSkin;
      
      private var leftBgWidth:int;
      
      private var leftBgHeight:int;
      
      private var _progress:int;
      
      private var shape:Shape = new Shape();
      
      private var x:int;
      
      private var y:int;
      
      private var rect:Rectangle;
      
      public function ProgressBar(x:int, y:int, maxValue:int, width:int, skin:ProgressBarSkin)
      {
         super();
         this.x = x;
         this.y = y;
         this.maxValue = maxValue;
         this.width = width;
         this.setSkin(skin);
         this.rect = new Rectangle(x,y,2 * this.shadowLeftWidth + width,this.shadowHeight);
      }
      
      public function setSkin(skin:ProgressBarSkin) : void
      {
         this.skin = skin;
         this.leftBgWidth = skin.leftBg.width;
         this.leftBgHeight = skin.leftBg.height;
         this.shadowLeftWidth = skin.shadowLeft.width;
         this.shadowHeight = skin.shadow.height;
         this.offsetX = this.shadowLeftWidth - this.leftBgWidth;
         this.offsetY = this.shadowHeight - this.leftBgHeight >> 1;
      }
      
      public function get progress() : int
      {
         return this._progress;
      }
      
      public function set progress(value:int) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         else if(value > this.maxValue)
         {
            value = this.maxValue;
         }
         this._progress = value;
      }
      
      public function draw(texture:BitmapData) : void
      {
         var filledWidth:int = 0;
         var graphics:Graphics = this.shape.graphics;
         graphics.clear();
         graphics.beginBitmapFill(this.skin.shadowLeft);
         graphics.drawRect(0,0,this.shadowLeftWidth,this.shadowHeight);
         graphics.beginBitmapFill(this.skin.shadow);
         graphics.drawRect(this.shadowLeftWidth,0,this.width - 2 * this.leftBgWidth,this.shadowHeight);
         graphics.beginBitmapFill(this.skin.shadowRight);
         graphics.drawRect(this.shadowLeftWidth + this.width - 2 * this.leftBgWidth,0,this.shadowLeftWidth,this.shadowHeight);
         graphics.endFill();
         var progressWidth:int = this.width * this._progress / this.maxValue;
         var rightBgX:int = this.width - this.leftBgWidth;
         if(progressWidth >= this.leftBgWidth)
         {
            if(progressWidth == this.width)
            {
               this.drawFullBar(graphics,this.skin.color,this.skin.left,this.skin.right);
               filledWidth = progressWidth;
            }
            else
            {
               matrix.tx = this.offsetX;
               matrix.ty = this.offsetY;
               graphics.beginBitmapFill(this.skin.left,matrix,false);
               graphics.drawRect(this.offsetX,this.offsetY,this.leftBgWidth,this.leftBgHeight);
               if(progressWidth > this.leftBgWidth)
               {
                  if(progressWidth > rightBgX)
                  {
                     progressWidth = rightBgX;
                  }
                  filledWidth = progressWidth;
                  graphics.beginFill(this.skin.color);
                  graphics.drawRect(this.offsetX + this.leftBgWidth,this.offsetY,progressWidth - this.leftBgWidth,this.leftBgHeight);
               }
               else
               {
                  filledWidth = this.leftBgWidth;
               }
            }
         }
         if(filledWidth == 0)
         {
            this.drawFullBar(graphics,this.skin.bgColor,this.skin.leftBg,this.skin.rightBg);
         }
         else if(filledWidth < this.width)
         {
            graphics.beginFill(this.skin.bgColor);
            graphics.drawRect(this.offsetX + filledWidth,this.offsetY,rightBgX - filledWidth,this.leftBgHeight);
            matrix.tx = this.offsetX + rightBgX;
            matrix.ty = this.offsetY;
            graphics.beginBitmapFill(this.skin.rightBg,matrix,false);
            graphics.drawRect(this.offsetX + rightBgX,this.offsetY,this.leftBgWidth,this.leftBgHeight);
         }
         graphics.endFill();
         texture.fillRect(this.rect,0);
         matrix.tx = this.x;
         matrix.ty = this.y;
         texture.draw(this.shape,matrix);
      }
      
      private function drawFullBar(graphics:Graphics, color:uint, left:BitmapData, right:BitmapData) : void
      {
         var rightBgX:int = this.width - this.leftBgWidth;
         matrix.tx = this.offsetX;
         matrix.ty = this.offsetY;
         graphics.beginBitmapFill(left,matrix,false);
         graphics.drawRect(this.offsetX,this.offsetY,this.leftBgWidth,this.leftBgHeight);
         graphics.beginFill(color);
         graphics.drawRect(this.offsetX + this.leftBgWidth,this.offsetY,rightBgX - this.leftBgWidth,this.leftBgHeight);
         matrix.tx = this.offsetX + rightBgX;
         graphics.beginBitmapFill(right,matrix,false);
         graphics.drawRect(this.offsetX + rightBgX,this.offsetY,this.leftBgWidth,this.leftBgHeight);
      }
   }
}

