package tutorial.loader
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import tutorial.commons.Assets;
   import tutorial.commons.Shared;
   
   public class SoundsLoader extends TanksLoader
   {
      
      private static var loading:Boolean;
      
      private static const urls:Vector.<String> = new Vector.<String>();
      
      private static const sounds:Vector.<Sound> = new Vector.<Sound>();
      
      public function SoundsLoader()
      {
         super();
      }
      
      override public function check(sceneXML:XML) : Boolean
      {
         return sceneXML.sounds.length() > 0;
      }
      
      override public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
         var soundXML:XML = null;
         var id:String = null;
         var sound:Sound = null;
         this.xml = sceneXML.sounds[0];
         this.callback = completeListener;
         var baseURL:String = sceneURL + xml.@baseURL;
         for each(soundXML in xml.elements("sound"))
         {
            id = soundXML.@id.toString();
            sound = new Sound();
            urls.push(baseURL + soundXML.@url.toString());
            sounds.push(sound);
            Assets.saveData(id,sound,Sound);
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,"SoundsLoader.load():",baseURL);
         }
         if(!loading)
         {
            loading = true;
            this.loadSound();
         }
         if(completeListener != null)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,"SoundsLoader.loaded","");
            completeListener();
         }
      }
      
      private function loadSound(e:Event = null) : void
      {
         var loadedSound:Sound = null;
         var sound:Sound = null;
         if(e != null)
         {
            loadedSound = Sound(e.target);
            loadedSound.removeEventListener(Event.COMPLETE,this.loadSound);
         }
         if(urls.length > 0)
         {
            sound = sounds.shift();
            sound.addEventListener(Event.COMPLETE,this.loadSound);
            sound.addEventListener(IOErrorEvent.IO_ERROR,onError);
            sound.addEventListener(ErrorEvent.ERROR,onError);
            sound.load(new URLRequest(urls.shift()));
         }
         else
         {
            loading = false;
         }
      }
      
      override protected function nextItem() : void
      {
         this.loadSound();
      }
   }
}

