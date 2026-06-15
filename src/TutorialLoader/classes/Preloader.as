package classes
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import tutorial.commons.Lang;
   import tutorial.commons.LocalizedStrings;
   import tutorial.commons.Shared;
   
   public class Preloader extends Sprite
   {
      
      private static const EPanel:Class = Preloader_EPanel;
      
      private static const EProgress:Class = Preloader_EProgress;
      
      private static const EBlick:Class = Preloader_EBlick;
      
      private static const ELock:Class = Preloader_ELock;
      
      private static const ENormal:Class = Preloader_ENormal;
      
      private static const EOver:Class = Preloader_EOver;
      
      private static const MAX_WIDTH:Number = 438;
      
      public const HW:Number = 240;
      
      public const HH:Number = 40;
      
      public const textH:Number = 74;
      
      private var disapierListener:Function;
      
      private var policy:Boolean;
      
      private var _progress:Number;
      
      private var startButtonClicked:Boolean = false;
      
      private var progressBar:Bitmap;
      
      private var progressBlick:Shape;
      
      private var lock:Bitmap;
      
      private var normal:Bitmap;
      
      private var over:Bitmap;
      
      private var button:Sprite;
      
      private var locked:TextField;
      
      private var label:TextField;
      
      private var logo:Bitmap;
      
      private var background:Sprite;
      
      private var bg:Bitmap;
      
      private var bgFill:Bitmap;
      
      private var blick:BitmapData = new EBlick().bitmapData;
      
      private var blickMatrix:Matrix = new Matrix();
      
      private var urls:Vector.<String> = new Vector.<String>();
      
      private var loader:Loader;
      
      private var urlsCounter:int = 0;
      
      private var logoDiffuse:BitmapData;
      
      private var logoAlpha:BitmapData;
      
      private var loaded:Boolean = false;
      
      private var colorTransform:ColorTransform = new ColorTransform(0,0,0);
      
      private var bx:Number = 132;
      
      private var by:Number = 61;
      
      private var ly:Number = -311;
      
      public function Preloader(param1:Function, param2:Boolean)
      {
         super();
         this.disapierListener = param1;
         this.policy = param2;
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      private function init(param1:Event) : void
      {
         var _loc2_:Bitmap = new EPanel();
         this.progressBar = new EProgress();
         this.progressBar.x = 21;
         this.progressBar.y = 21;
         this.progressBar.width = 0;
         this.progressBar.blendMode = "overlay";
         this.progressBlick = new Shape();
         this.progressBlick.x = this.progressBar.x;
         this.progressBlick.y = this.progressBar.y;
         this.progressBlick.blendMode = "add";
         this.progressBlick.alpha = 0.5;
         this.locked = this.createStartText(2302755);
         this.locked.filters = [new DropShadowFilter(1,45,5526612,1,2,2,1.5)];
         this.lock = new ELock();
         this.lock.x = this.bx;
         this.lock.y = this.by;
         this.normal = new ENormal();
         this.normal.visible = false;
         this.normal.x = this.bx;
         this.normal.y = this.by;
         this.over = new EOver();
         this.over.visible = false;
         this.over.x = this.bx;
         this.over.y = this.by;
         this.label = this.createStartText(1121280);
         this.label.visible = false;
         this.label.filters = [new DropShadowFilter(1,45,10223390,1,2,2,1.5)];
         this.button = new Sprite();
         this.button.visible = false;
         this.button.buttonMode = true;
         this.button.useHandCursor = true;
         this.button.tabEnabled = false;
         this.button.graphics.beginFill(16711680,0);
         this.button.graphics.drawRect(this.normal.x,this.normal.y,this.normal.width,this.normal.height);
         this.button.addEventListener(MouseEvent.MOUSE_OVER,this.onButtonOver);
         this.button.addEventListener(MouseEvent.MOUSE_OUT,this.onButtonOut);
         this.button.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonDown);
         this.button.addEventListener(MouseEvent.CLICK,this.onButtonClick);
         var _loc3_:Text = new Text();
         _loc3_.x = this.HW;
         _loc3_.y = -this.textH;
         this.background = new Sprite();
         addChild(this.background);
         addChild(_loc2_);
         addChild(this.progressBar);
         addChild(this.progressBlick);
         addChild(this.lock);
         addChild(this.locked);
         addChild(this.normal);
         addChild(this.over);
         addChild(this.button);
         addChild(this.label);
         addChild(_loc3_);
         this.progress = 0;
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         addEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.urls.push("resources/loader/landing/logo.jpg");
         this.urls.push("resources/loader/landing/alpha.jpg");
         this.urls.push("resources/loader/landing/background.jpg");
         this.urlsCounter = -1;
         this.loadNextBMP();
      }
      
      private function loadNextBMP(param1:Event = null) : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:String = null;
         var _loc4_:LoaderContext = null;
         if(this.urlsCounter >= 0 && !(param1 is ErrorEvent))
         {
            _loc2_ = this.loader.content as Bitmap;
            _loc3_ = this.urls[this.urlsCounter];
            if(_loc3_.indexOf("logo") >= 0)
            {
               this.logoDiffuse = _loc2_.bitmapData;
            }
            else if(_loc3_.indexOf("alpha") >= 0)
            {
               this.logoAlpha = _loc2_.bitmapData;
            }
            else if(_loc3_.indexOf("background") >= 0)
            {
               this.bg = _loc2_;
            }
            if(this.logo == null && this.logoDiffuse != null && this.logoAlpha != null)
            {
               this.logo = new Bitmap();
               this.logo.bitmapData = new BitmapData(this.logoDiffuse.width,this.logoDiffuse.height,true,0);
               this.logo.bitmapData.copyPixels(this.logoDiffuse,this.logoDiffuse.rect,new Point());
               this.logo.bitmapData.copyChannel(this.logoAlpha,this.logoAlpha.rect,new Point(),1,8);
               this.logo.x = 240 - Math.round(this.logo.width * 0.5);
               this.logo.y = this.ly;
               this.logo.alpha = 0;
               addChild(this.logo);
            }
         }
         if(++this.urlsCounter < this.urls.length)
         {
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadNextBMP);
            this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loadNextBMP);
            this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loadNextBMP);
            _loc4_ = new LoaderContext(this.policy);
            if("imageDecodingPolicy" in _loc4_)
            {
               _loc4_.imageDecodingPolicy = "onLoad";
            }
            this.loader.load(new URLRequest(this.urls[this.urlsCounter]),_loc4_);
         }
         else if(this.bg != null)
         {
            this.bgFill = new Bitmap();
            this.bgFill.bitmapData = new BitmapData(this.bg.bitmapData.width,1,false,0);
            this.bgFill.bitmapData.copyPixels(this.bg.bitmapData,new Rectangle(0,0,this.bg.bitmapData.width,1),new Point());
            this.background.addChild(this.bg);
            this.background.addChild(this.bgFill);
            this.background.transform.colorTransform = this.colorTransform;
            this.loaded = true;
            this.resize();
         }
      }
      
      private function createStartText(param1:int) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.selectable = false;
         _loc2_.multiline = false;
         _loc2_.mouseEnabled = false;
         _loc2_.autoSize = "center";
         _loc2_.antiAliasType = "advanced";
         _loc2_.sharpness = 0;
         _loc2_.thickness = 0;
         _loc2_.defaultTextFormat = new TextFormat("Quadrat",28,param1,Lang.embedFonts ? null : true,null,null,null,null,"center");
         _loc2_.embedFonts = Lang.embedFonts;
         _loc2_.x = 240;
         _loc2_.y = this.by + 3;
         _loc2_.text = Lang.getText(LocalizedStrings.START);
         return _loc2_;
      }
      
      private function onButtonOver(param1:MouseEvent) : void
      {
         this.normal.alpha = 0;
         this.over.visible = true;
      }
      
      private function onButtonOut(param1:MouseEvent) : void
      {
         this.label.y = this.by + 3;
         this.over.y = this.by;
         this.normal.alpha = 1;
         this.over.visible = false;
      }
      
      private function onButtonDown(param1:MouseEvent) : void
      {
         Shared.tracker.trackEvent(Shared.TUTORIAL,Shared.TUTORIAL + ":click_start","");
         this.label.y = this.by + 3 + 1;
         this.over.y = this.by + 1;
      }
      
      private function onButtonClick(param1:MouseEvent) : void
      {
         this.label.y = this.by + 3;
         this.over.y = this.by;
         this.startButtonClicked = true;
         this.button.buttonMode = false;
         this.button.useHandCursor = false;
         this.button.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         stage.dispatchEvent(new Event(Event.RESIZE));
      }
      
      private function destroy(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.destroy);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(this.startButtonClicked)
         {
            alpha -= 0.05;
            if(alpha <= 0)
            {
               removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
               this.disapierListener();
            }
         }
         if(this._progress == 1)
         {
            this.progressBlick.alpha -= 0.025;
            if(this.progressBlick.alpha < 0)
            {
               this.progressBlick.alpha = 0;
            }
         }
         if(this._progress <= 1)
         {
            this.progressBar.width = Math.round(MAX_WIDTH * this._progress);
         }
         this.progressBlick.graphics.clear();
         this.progressBlick.graphics.beginBitmapFill(this.blick,this.blickMatrix,true,false);
         this.progressBlick.graphics.drawRect(0,0,this.progressBar.width,this.progressBar.height);
         this.blickMatrix.tx += 3;
         if(this.blickMatrix.tx >= this.blick.width)
         {
            this.blickMatrix.tx %= this.blick.width;
         }
         if(this.logo != null)
         {
            if(this.logo.alpha < 1)
            {
               this.logo.alpha += 0.025;
               if(this.logo.alpha > 1)
               {
                  this.logo.alpha = 1;
               }
            }
         }
         if(this.loaded)
         {
            if(this.colorTransform.redMultiplier < 1)
            {
               this.colorTransform.redMultiplier += 0.025;
               this.colorTransform.greenMultiplier += 0.025;
               this.colorTransform.blueMultiplier += 0.025;
               if(this.colorTransform.redMultiplier > 1)
               {
                  this.colorTransform.redMultiplier = 1;
                  this.colorTransform.greenMultiplier = 1;
                  this.colorTransform.blueMultiplier = 1;
               }
               this.background.transform.colorTransform = this.colorTransform;
            }
         }
      }
      
      public function unlockStartButton() : void
      {
         this.lock.visible = false;
         this.locked.visible = false;
         this.normal.visible = true;
         this.label.visible = true;
         this.button.visible = true;
      }
      
      public function set progress(param1:Number) : void
      {
         this._progress = param1;
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function resize() : void
      {
         this.background.graphics.clear();
         if(!this.loaded)
         {
            this.background.graphics.beginFill(0);
            this.background.graphics.drawRect(-x,-y,stage.stageWidth,stage.stageHeight);
         }
         else
         {
            this.bg.x = this.HW - Math.round(this.bg.width * 0.5);
            this.bg.y = this.HH - Math.round(this.bg.height * 0.5);
            this.bgFill.x = this.bg.x;
            this.bgFill.y = -y;
            if(this.bg.y - this.bgFill.y > 0)
            {
               this.bgFill.height = this.bg.y - this.bgFill.y;
            }
            else
            {
               this.bgFill.height = 0;
            }
            this.background.graphics.beginFill(0);
            this.background.graphics.drawRect(-x,-y,stage.stageWidth,stage.stageHeight);
            this.background.graphics.drawRect(this.bgFill.x,this.bgFill.y,this.bg.width,this.bgFill.height + this.bg.height);
         }
      }
   }
}

