package tutorial
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.display.StageAlign;
   import flash.events.Event;
   import flash.utils.getTimer;
   
   public class ScreenMovieClipManager
   {
      
      private static const kiqidevov:int = 20;
      
      private var cyferov:MovieClip;
      
      private var wyfyk:MovieClip;
      
      public var pere:MovieClip;
      
      private var cinilu:String;
      
      private var danewazam:DisplayObjectContainer;
      
      private var stage:Stage;
      
      private var lecopojen:uint;
      
      private var wiciqy:Number = 1;
      
      private var vocid:Boolean;
      
      public function ScreenMovieClipManager(param1:Stage, param2:DisplayObjectContainer)
      {
         super();
         this.danewazam = param2;
         this.stage = param1;
         param1.addEventListener(Event.RESIZE,this.updateAlign);
      }
      
      public function showMovie(param1:MovieClip, param2:String, param3:Boolean = false) : void
      {
         this.pere = param1;
         if(param3)
         {
            if(this.cyferov != null)
            {
               this.hide();
            }
            this.cyferov = param1;
            this.wyfyk = null;
            this.updateAlign();
            this.danewazam.addChild(this.cyferov);
         }
         else
         {
            this.wyfyk = param1;
            param1.stop();
            this.cinilu = param2;
            if(this.cyferov != null)
            {
               this.stage.addEventListener(Event.ENTER_FRAME,this.hideImage);
               this.lecopojen = getTimer();
            }
            else
            {
               this.initMovie();
            }
         }
      }
      
      public function hideMovie(param1:Boolean = false) : void
      {
         this.pere = null;
         if(this.cyferov != null && !this.vocid)
         {
            if(param1)
            {
               this.hide();
            }
            else
            {
               this.vocid = true;
               this.stage.addEventListener(Event.ENTER_FRAME,this.hideImage);
               this.lecopojen = getTimer();
            }
         }
      }
      
      private function initMovie() : void
      {
         this.cyferov = this.wyfyk;
         this.wyfyk = null;
         this.cyferov.alpha = 0;
         this.updateAlign();
         this.danewazam.addChild(this.cyferov);
         this.stage.addEventListener(Event.ENTER_FRAME,this.showImage);
         this.lecopojen = getTimer();
      }
      
      private function showImage(param1:Event) : void
      {
         var _loc2_:Number = (getTimer() - this.lecopojen) * 0.001;
         this.lecopojen = getTimer();
         this.cyferov.alpha += _loc2_ * this.wiciqy;
         if(this.cyferov.alpha >= 1)
         {
            this.cyferov.alpha = 1;
            this.cyferov.gotoAndPlay(0);
            this.stage.removeEventListener(Event.ENTER_FRAME,this.showImage);
         }
      }
      
      private function hideImage(param1:Event) : void
      {
         var _loc2_:Number = (getTimer() - this.lecopojen) * 0.001;
         this.lecopojen = getTimer();
         this.cyferov.alpha -= _loc2_ * this.wiciqy;
         if(this.cyferov.alpha <= 0)
         {
            this.hide();
         }
      }
      
      private function hide() : void
      {
         this.cyferov.alpha = 0;
         this.danewazam.removeChild(this.cyferov);
         this.cyferov = null;
         this.stage.removeEventListener(Event.ENTER_FRAME,this.hideImage);
         this.vocid = false;
         if(this.wyfyk != null)
         {
            this.initMovie();
         }
      }
      
      private function updateAlign(param1:Event = null) : void
      {
         if(this.cyferov == null)
         {
            return;
         }
         switch(this.cinilu)
         {
            case StageAlign.BOTTOM:
               this.cyferov.x = (this.stage.stageWidth - this.cyferov.width) * 0.5;
               this.cyferov.y = this.stage.stageHeight - this.cyferov.height - kiqidevov;
               break;
            case StageAlign.BOTTOM_LEFT:
               this.cyferov.x = kiqidevov;
               this.cyferov.y = this.stage.stageHeight - this.cyferov.height - kiqidevov;
               break;
            case StageAlign.BOTTOM_RIGHT:
               this.cyferov.x = this.stage.stageWidth - this.cyferov.width - kiqidevov;
               this.cyferov.y = this.stage.stageHeight - this.cyferov.height - kiqidevov;
               break;
            case StageAlign.LEFT:
               this.cyferov.x = kiqidevov;
               this.cyferov.y = (this.stage.stageHeight - this.cyferov.height) * 0.5;
               break;
            case StageAlign.RIGHT:
               this.cyferov.x = this.stage.stageWidth - this.cyferov.width - kiqidevov;
               this.cyferov.y = (this.stage.stageHeight - this.cyferov.height) * 0.5;
               break;
            case StageAlign.TOP:
               this.cyferov.x = (this.stage.stageWidth - this.cyferov.width) * 0.5;
               this.cyferov.y = kiqidevov;
               break;
            case StageAlign.TOP_LEFT:
               this.cyferov.x = kiqidevov;
               this.cyferov.y = kiqidevov;
               break;
            case StageAlign.TOP_RIGHT:
               this.cyferov.x = this.stage.stageWidth - this.cyferov.width - kiqidevov;
               this.cyferov.y = kiqidevov;
         }
      }
   }
}

