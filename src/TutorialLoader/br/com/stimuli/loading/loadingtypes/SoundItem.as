package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.*;
   import flash.events.*;
   import flash.media.Sound;
   import flash.net.*;
   import flash.utils.*;
   
   public class SoundItem extends LoadingItem
   {
      
      public var loader:Sound;
      
      public function SoundItem(url:URLRequest, type:String, uid:String)
      {
         specificAvailableProps = [BulkLoader.CONTEXT];
         super(url,type,uid);
      }
      
      override public function _parseOptions(props:Object) : Array
      {
         _context = props[BulkLoader.CONTEXT] || null;
         return super._parseOptions(props);
      }
      
      override public function load() : void
      {
         super.load();
         this.loader = new Sound();
         this.loader.addEventListener(ProgressEvent.PROGRESS,onProgressHandler,false,0,true);
         this.loader.addEventListener(Event.COMPLETE,this.onCompleteHandler,false,0,true);
         this.loader.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false,0,true);
         this.loader.addEventListener(Event.OPEN,this.onStartedHandler,false,0,true);
         this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,super.onSecurityErrorHandler,false,0,true);
         try
         {
            this.loader.load(url,_context);
         }
         catch(e:SecurityError)
         {
            onSecurityErrorHandler(_createErrorEvent(e));
         }
      }
      
      override public function onStartedHandler(evt:Event) : void
      {
         _content = this.loader;
         super.onStartedHandler(evt);
      }
      
      override public function onErrorHandler(evt:ErrorEvent) : void
      {
         super.onErrorHandler(evt);
      }
      
      override public function onCompleteHandler(evt:Event) : void
      {
         _content = this.loader;
         super.onCompleteHandler(evt);
      }
      
      override public function stop() : void
      {
         try
         {
            if(Boolean(this.loader))
            {
               this.loader.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function cleanListeners() : void
      {
         if(Boolean(this.loader))
         {
            this.loader.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler,false);
            this.loader.removeEventListener(Event.COMPLETE,this.onCompleteHandler,false);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false);
            this.loader.removeEventListener(BulkLoader.OPEN,this.onStartedHandler,false);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,super.onSecurityErrorHandler,false);
         }
      }
      
      override public function isStreamable() : Boolean
      {
         return true;
      }
      
      override public function isSound() : Boolean
      {
         return true;
      }
      
      override public function destroy() : void
      {
         this.cleanListeners();
         this.stop();
         _content = null;
         this.loader = null;
      }
   }
}

