package classes
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import tutorial.commons.Lang;
   import tutorial.commons.LocalizedStrings;
   
   public class Text extends Sprite
   {
      
      private const maxLines:int = 3;
      
      private const textSize:int = 16;
      
      private const lineHeight:int = 20;
      
      private const delay:int = 2300;
      
      private const alphaStep:Number = 0.05;
      
      private const coordStep:int = 1;
      
      private var fields:Vector.<TextField> = new Vector.<TextField>();
      
      private var container:Sprite;
      
      private var intervalId:int;
      
      private var index:int;
      
      private var yCoord:int;
      
      private var state:int;
      
      public function Text()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      private function init(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = Lang.getText(LocalizedStrings.WELCOME_1).split("\n");
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            this.fields.push(this.createText(_loc3_[_loc2_]));
            _loc2_++;
         }
         _loc3_ = Lang.getText(LocalizedStrings.WELCOME_2).split("\n");
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            this.fields.push(this.createText(_loc3_[_loc2_]));
            _loc2_++;
         }
         _loc3_ = Lang.getText(LocalizedStrings.WELCOME_3).split("\n");
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            this.fields.push(this.createText(_loc3_[_loc2_]));
            _loc2_++;
         }
         this.fields.push(this.createText(" "));
         this.fields.push(this.createText(" "));
         this.container = new Sprite();
         this.container.x = 0;
         this.container.y = 0;
         addChild(this.container);
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         addEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.yCoord = -this.lineHeight;
         this.index = -1;
         this.state = 1;
      }
      
      private function destroy(param1:Event) : void
      {
         removeChild(this.container);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         clearInterval(this.intervalId);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:DisplayObject = null;
         if(this.state != 0)
         {
            if(this.state == 1)
            {
               if(this.container.numChildren == this.maxLines)
               {
                  _loc2_ = this.container.getChildAt(0);
                  _loc2_.alpha -= this.alphaStep;
                  if(_loc2_.alpha <= 0)
                  {
                     _loc2_.alpha = 0;
                  }
                  this.container.y -= this.coordStep;
                  if(this.container.y <= -this.yCoord)
                  {
                     this.container.y = -this.yCoord;
                  }
                  if(_loc2_.alpha == 0 && this.container.y == -this.yCoord)
                  {
                     this.container.removeChildAt(0);
                     this.addText();
                     this.state = 2;
                  }
               }
               else
               {
                  this.container.y -= this.coordStep;
                  if(this.container.y <= -this.yCoord)
                  {
                     this.container.y = -this.yCoord;
                     this.addText();
                     this.state = 2;
                  }
               }
            }
            else if(this.state == 2)
            {
               _loc2_ = this.container.getChildAt(this.container.numChildren - 1);
               _loc2_.alpha += this.alphaStep;
               if(_loc2_.alpha >= 1)
               {
                  _loc2_.alpha = 1;
                  this.intervalId = setTimeout(this.onInterval,this.delay);
                  this.state = 0;
               }
            }
         }
      }
      
      private function addText() : void
      {
         this.yCoord += this.lineHeight;
         if(++this.index >= this.fields.length)
         {
            this.index = 0;
         }
         var _loc1_:TextField = this.fields[this.index];
         _loc1_.alpha = 0;
         _loc1_.y = this.yCoord + 30;
         if(!Lang.embedFonts)
         {
            _loc1_.y += 3;
         }
         this.container.addChild(_loc1_);
      }
      
      private function onInterval() : void
      {
         this.state = 1;
      }
      
      private function createText(param1:String) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.selectable = false;
         _loc2_.multiline = true;
         _loc2_.mouseEnabled = false;
         _loc2_.autoSize = "center";
         _loc2_.antiAliasType = "advanced";
         _loc2_.sharpness = 0;
         _loc2_.thickness = 0;
         _loc2_.defaultTextFormat = new TextFormat("Myriad",18,16777215,null,null,null,null,null,"center");
         _loc2_.embedFonts = Lang.embedFonts;
         _loc2_.x = 240;
         _loc2_.y = 19;
         _loc2_.text = param1;
         _loc2_.x = -_loc2_.width / 2;
         _loc2_.filters = [new DropShadowFilter(1,45,0,1,2,2,2),new GlowFilter(0,1,5,5,0.5,1)];
         return _loc2_;
      }
   }
}

