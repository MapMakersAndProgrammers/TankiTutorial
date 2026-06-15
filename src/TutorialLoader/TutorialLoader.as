package
{
   import br.com.stimuli.loading.BulkLoader;
   import classes.Preloader;
   import classes.SkipButton;
   import classes.SoundButton;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageQuality;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.system.Security;
   import flash.system.SecurityDomain;
   import tutorial.commons.InitialDataLoader;
   import tutorial.commons.Lang;
   import tutorial.commons.LoaderWindow;
   import tutorial.commons.Shared;
   import tutorial.commons.TrackerService;
   import tutorial.commons.UnpackingProgressUpdating;
   
   [SWF(backgroundColor="#000000",frameRate="60",width="1200",height="700")]
   public class TutorialLoader extends Sprite
   {
      
      private static const ttfFontQuadrat:Class = TutorialLoader_ttfFontQuadrat;
      
      private static const ttfFontMyriad:Class = TutorialLoader_ttfFontMyriad;
      
      private static const LOADING_PART:Number = 0.7;
      
      private static const UNPACKAGING_PHASES_COUNT:int = 50;
      
      private var tracker:TrackerService = new TrackerService(true);
      
      private var preloader:Preloader;
      
      private var skipButton:SkipButton;
      
      private var soundButton:SoundButton;
      
      private var loader:BulkLoader;
      
      private var policy:Boolean = false;
      
      private var loadingProgressInPercents:int = 0;
      
      public function TutorialLoader()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init);
      }
      
      private function init(param1:Event) : void
      {
         var gpuCaps:GPUCapabilities;
         var path:String = null;
         var url:String = null;
         var hash:String = null;
         var navigator:Array = null;
         var e:Event = param1;
         this.policy = loaderInfo.parameters["baseDomain"] != undefined;
         if(this.policy)
         {
            Security.loadPolicyFile("http://" + loaderInfo.parameters["baseDomain"] + "/crossdomain.xml");
            Security.allowDomain(loaderInfo.parameters["baseDomain"]);
         }
         if(ExternalInterface.available)
         {
            ExternalInterface.call("gameLaunched");
         }
         Lang.init();
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.quality = StageQuality.MEDIUM;
         this.preloader = new Preloader(this.show,this.policy);
         this.skipButton = new SkipButton(this.skip);
         this.soundButton = new SoundButton(this.mute);
         this.soundButton.state = Shared.volume > 0;
         addChild(this.preloader);
         addChild(this.skipButton);
         addChild(this.soundButton);
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize();
         if(ExternalInterface.available)
         {
            path = ExternalInterface.call("window.location.pathname.toString");
            path = path.substring(0,path.lastIndexOf("/") + 1);
            url = ExternalInterface.call("window.location.protocol.toString") + "//" + ExternalInterface.call("window.location.host.toString") + path + "lucky.html#tutorial=true";
            hash = ExternalInterface.call("window.location.hash.toString");
            if(hash != null && hash != "")
            {
               url += "&" + hash.substr(1);
            }
            Shared.regURL = url;
            navigator = ExternalInterface.call("getNavigator");
            Shared.navigator = navigator[0];
            Shared.navigatorVersion = navigator[1];
         }
         Shared.navigateMethod = function():void
         {
            if(!ExternalInterface.available || ExternalInterface.call("refresh") == null)
            {
               navigateToURL(new URLRequest(Shared.regURL),"_self");
            }
         };
         gpuCaps = new GPUCapabilities(stage);
         gpuCaps.addEventListener(Event.COMPLETE,this.loadTutorial);
         gpuCaps.detect();
         UnpackingProgressUpdating.setListener(this.updateLoadingProgress);
      }
      
      private function updateLoadingProgress() : void
      {
         this.preloader.progress += (1 - LOADING_PART) / UNPACKAGING_PHASES_COUNT;
         this.trackLoadingProgressInPercents(this.preloader.progress);
      }
      
      private function loadTutorial(param1:Event) : void
      {
         var url:String = null;
         var loaderContext:LoaderContext = null;
         var e:Event = param1;
         this.loader = new BulkLoader();
         Shared.currentStep = "StartLoadSWF";
         this.tracker.trackEvent(Shared.TUTORIAL_LOAD,"StartLoadSWF","");
         try
         {
            this.tracker.trackEvent(Shared.TUTORIAL_STAT,"screen_resolution",Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY);
            this.tracker.trackEvent(Shared.TUTORIAL_STAT,"mode",this.getMode());
            this.tracker.trackEvent(Shared.TUTORIAL_STAT,"fp_version",Capabilities.version);
            url = GPUCapabilities.gpuEnabled ? "hardware.swf" : "software.swf";
            loaderContext = this.policy ? new LoaderContext(true,ApplicationDomain.currentDomain,SecurityDomain.currentDomain) : new LoaderContext(false,ApplicationDomain.currentDomain);
            this.loader.add(new URLRequest(url),{
               "id":"tutorial",
               "context":loaderContext
            });
            Shared.gpu = GPUCapabilities.gpuEnabled;
            Shared.constrained = GPUCapabilities.constrained;
            Shared.tracker = this.tracker;
            Shared.preloader = new LoaderWindow(stage);
         }
         catch(error:Error)
         {
            tracker.trackEvent(Shared.TUTORIAL_ERROR,"codeError",error.errorID + " " + error.message);
         }
         InitialDataLoader.load(this.onComplete,this.onProgress,this.unlockStartButton,this.loader);
      }
      
      private function onProgress(param1:Number) : void
      {
         this.preloader.progress = LOADING_PART * param1;
         this.trackLoadingProgressInPercents(this.preloader.progress);
      }
      
      private function trackLoadingProgressInPercents(param1:Number) : void
      {
         var _loc2_:Number = param1 * 100;
         if(_loc2_ >= this.loadingProgressInPercents)
         {
            this.tracker.trackEvent(Shared.TUTORIAL_LOAD,Shared.TUTORIAL_LOAD + ":" + this.loadingProgressInPercents.toString(),"");
            this.loadingProgressInPercents += 10;
         }
      }
      
      private function unlockStartButton() : void
      {
         this.preloader.progress = 1;
         this.preloader.unlockStartButton();
      }
      
      private function getMode() : String
      {
         if(GPUCapabilities.gpuEnabled)
         {
            return "GPU" + (GPUCapabilities.constrained ? "_constrained" : "");
         }
         return "CPU";
      }
      
      private function onResize(param1:Event = null) : void
      {
         if(this.preloader != null && this.preloader.parent != null)
         {
            this.preloader.x = Math.round(stage.stageWidth * 0.5) - this.preloader.HW;
            this.preloader.y = Math.round(stage.stageHeight * 0.5) - this.preloader.HH + this.preloader.textH;
            if(this.preloader.y < 220 + this.preloader.textH)
            {
               this.preloader.y = 220 + this.preloader.textH;
               if(stage.stageHeight < 330 + this.preloader.textH)
               {
                  this.preloader.y -= 330 + this.preloader.textH - stage.stageHeight;
               }
            }
            this.preloader.resize();
         }
         if(this.skipButton != null && this.skipButton.parent != null)
         {
            this.skipButton.x = stage.stageWidth;
            this.skipButton.y = 0;
         }
      }
      
      private function skip(param1:Event = null) : void
      {
         this.tracker.trackEvent(Shared.TUTORIAL,Shared.TUTORIAL + ":click_skip",Shared.currentStep);
         if(Shared.navigateMethod != null)
         {
            Shared.navigateMethod();
         }
      }
      
      private function mute(param1:Event = null) : void
      {
         Shared.volume = Shared.volume > 0 ? 0 : 1;
         if(this.soundButton != null)
         {
            this.soundButton.state = Shared.volume > 0;
         }
      }
      
      private function onComplete() : void
      {
         Shared.renderEnabled = false;
         addChildAt(this.loader.getDisplayObjectLoader("tutorial"),0);
      }
      
      private function show() : void
      {
         Shared.renderEnabled = true;
         removeChild(this.preloader);
         this.preloader = null;
      }
   }
}

