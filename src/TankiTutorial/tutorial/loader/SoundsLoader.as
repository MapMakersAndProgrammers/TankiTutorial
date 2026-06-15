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
      
      private static var qahytenip:Boolean;
      
      private static const ryv:Vector.<String> = new Vector.<String>();
      
      private static const jugar:Vector.<Sound> = new Vector.<Sound>();
      
      public function SoundsLoader()
      {
         super();
      }
      
      override public function check(param1:XML) : Boolean
      {
         return param1.sounds.length() > 0;
      }
      
      override public function load(param1:String, param2:XML, param3:Function) : void
      {
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:Sound = null;
         this.pomagu = param2.sounds[0];
         this.hon = param3;
         var _loc4_:String = param1 + pomagu.@baseURL;
         for each(_loc5_ in pomagu.elements("sound"))
         {
            _loc6_ = _loc5_.@id.toString();
            _loc7_ = new Sound();
            ryv.push(_loc4_ + _loc5_.@url.toString());
            jugar.push(_loc7_);
            Assets.saveData(_loc6_,_loc7_,Sound);
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,"SoundsLoader.load():",_loc4_);
         }
         if(!qahytenip)
         {
            qahytenip = true;
            this.loadSound();
         }
         if(param3 != null)
         {
            Shared.tracker.trackEvent(Shared.TUTORIAL_LOAD,"SoundsLoader.loaded","");
            param3();
         }
      }
      
      private function loadSound(param1:Event = null) : void
      {
         var _loc2_:Sound = null;
         var _loc3_:Sound = null;
         if(param1 != null)
         {
            _loc2_ = Sound(param1.target);
            _loc2_.removeEventListener(Event.COMPLETE,this.loadSound);
         }
         if(ryv.length > 0)
         {
            _loc3_ = jugar.shift();
            _loc3_.addEventListener(Event.COMPLETE,this.loadSound);
            _loc3_.addEventListener(IOErrorEvent.IO_ERROR,onError);
            _loc3_.addEventListener(ErrorEvent.ERROR,onError);
            _loc3_.load(new URLRequest(ryv.shift()));
         }
         else
         {
            qahytenip = false;
         }
      }
      
      override protected function nextItem() : void
      {
         this.loadSound();
      }
   }
}

