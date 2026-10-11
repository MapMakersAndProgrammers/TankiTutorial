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
      
      private static const MARGIN:int = 20;
      
      private var movie:MovieClip;
      
      private var nextMovie:MovieClip;
      
      public var currentMovie:MovieClip;
      
      private var align:String;
      
      private var container:DisplayObjectContainer;
      
      private var stage:Stage;
      
      private var time:uint;
      
      private var speed:Number = 1;
      
      private var hiding:Boolean;
      
      public function ScreenMovieClipManager(stage:Stage, container:DisplayObjectContainer)
      {
         super();
         this.container = container;
         this.stage = stage;
         stage.addEventListener(Event.RESIZE,this.updateAlign);
      }
      
      public function showMovie(clip:MovieClip, align:String, immediate:Boolean = false) : void
      {
         this.currentMovie = clip;
         if(immediate)
         {
            if(this.movie != null)
            {
               this.hide();
            }
            this.movie = clip;
            this.nextMovie = null;
            this.updateAlign();
            this.container.addChild(this.movie);
         }
         else
         {
            this.nextMovie = clip;
            clip.stop();
            this.align = align;
            if(this.movie != null)
            {
               this.stage.addEventListener(Event.ENTER_FRAME,this.hideImage);
               this.time = getTimer();
            }
            else
            {
               this.initMovie();
            }
         }
      }
      
      public function hideMovie(immediate:Boolean = false) : void
      {
         this.currentMovie = null;
         if(this.movie != null && !this.hiding)
         {
            if(immediate)
            {
               this.hide();
            }
            else
            {
               this.hiding = true;
               this.stage.addEventListener(Event.ENTER_FRAME,this.hideImage);
               this.time = getTimer();
            }
         }
      }
      
      private function initMovie() : void
      {
         this.movie = this.nextMovie;
         this.nextMovie = null;
         this.movie.alpha = 0;
         this.updateAlign();
         this.container.addChild(this.movie);
         this.stage.addEventListener(Event.ENTER_FRAME,this.showImage);
         this.time = getTimer();
      }
      
      private function showImage(e:Event) : void
      {
         var deltaTime:Number = (getTimer() - this.time) * 0.001;
         this.time = getTimer();
         this.movie.alpha += deltaTime * this.speed;
         if(this.movie.alpha >= 1)
         {
            this.movie.alpha = 1;
            this.movie.gotoAndPlay(0);
            this.stage.removeEventListener(Event.ENTER_FRAME,this.showImage);
         }
      }
      
      private function hideImage(e:Event) : void
      {
         var deltaTime:Number = (getTimer() - this.time) * 0.001;
         this.time = getTimer();
         this.movie.alpha -= deltaTime * this.speed;
         if(this.movie.alpha <= 0)
         {
            this.hide();
         }
      }
      
      private function hide() : void
      {
         this.movie.alpha = 0;
         this.container.removeChild(this.movie);
         this.movie = null;
         this.stage.removeEventListener(Event.ENTER_FRAME,this.hideImage);
         this.hiding = false;
         if(this.nextMovie != null)
         {
            this.initMovie();
         }
      }
      
      private function updateAlign(e:Event = null) : void
      {
         if(this.movie == null)
         {
            return;
         }
         switch(this.align)
         {
            case StageAlign.BOTTOM:
               this.movie.x = (this.stage.stageWidth - this.movie.width) * 0.5;
               this.movie.y = this.stage.stageHeight - this.movie.height - MARGIN;
               break;
            case StageAlign.BOTTOM_LEFT:
               this.movie.x = MARGIN;
               this.movie.y = this.stage.stageHeight - this.movie.height - MARGIN;
               break;
            case StageAlign.BOTTOM_RIGHT:
               this.movie.x = this.stage.stageWidth - this.movie.width - MARGIN;
               this.movie.y = this.stage.stageHeight - this.movie.height - MARGIN;
               break;
            case StageAlign.LEFT:
               this.movie.x = MARGIN;
               this.movie.y = (this.stage.stageHeight - this.movie.height) * 0.5;
               break;
            case StageAlign.RIGHT:
               this.movie.x = this.stage.stageWidth - this.movie.width - MARGIN;
               this.movie.y = (this.stage.stageHeight - this.movie.height) * 0.5;
               break;
            case StageAlign.TOP:
               this.movie.x = (this.stage.stageWidth - this.movie.width) * 0.5;
               this.movie.y = MARGIN;
               break;
            case StageAlign.TOP_LEFT:
               this.movie.x = MARGIN;
               this.movie.y = MARGIN;
               break;
            case StageAlign.TOP_RIGHT:
               this.movie.x = this.stage.stageWidth - this.movie.width - MARGIN;
               this.movie.y = MARGIN;
         }
      }
   }
}

