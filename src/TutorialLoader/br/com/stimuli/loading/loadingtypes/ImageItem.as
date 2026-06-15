package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class ImageItem extends LoadingItem
   {
      
      public var loader:Loader;
      
      public function ImageItem(url:URLRequest, type:String, uid:String)
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
         this.loader = new Loader();
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgressHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCompleteHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(Event.INIT,this.onInitHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false,100,true);
         this.loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityErrorHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(Event.OPEN,onStartedHandler,false,0,true);
         this.loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false,0,true);
         try
         {
            this.loader.load(url,_context);
         }
         catch(e:SecurityError)
         {
            onSecurityErrorHandler(_createErrorEvent(e));
         }
      }
      
      public function _onHttpStatusHandler(evt:HTTPStatusEvent) : void
      {
         _httpStatus = evt.status;
         dispatchEvent(evt);
      }
      
      override public function onErrorHandler(evt:ErrorEvent) : void
      {
         super.onErrorHandler(evt);
      }
      
      public function onInitHandler(evt:Event) : void
      {
         dispatchEvent(evt);
      }
      
      override public function onCompleteHandler(evt:Event) : void
      {
         try
         {
            _content = this.loader.content;
            super.onCompleteHandler(evt);
         }
         catch(e:SecurityError)
         {
            _content = loader;
            super.onCompleteHandler(evt);
         }
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
      
      public function getDefinitionByName(className:String) : Object
      {
         if(this.loader.contentLoaderInfo.applicationDomain.hasDefinition(className))
         {
            return this.loader.contentLoaderInfo.applicationDomain.getDefinition(className);
         }
         return null;
      }
      
      override public function cleanListeners() : void
      {
         var removalTarget:Object = null;
         if(Boolean(this.loader))
         {
            removalTarget = this.loader.contentLoaderInfo;
            removalTarget.removeEventListener(ProgressEvent.PROGRESS,onProgressHandler,false);
            removalTarget.removeEventListener(Event.COMPLETE,this.onCompleteHandler,false);
            removalTarget.removeEventListener(Event.INIT,this.onInitHandler,false);
            removalTarget.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorHandler,false);
            removalTarget.removeEventListener(BulkLoader.OPEN,onStartedHandler,false);
            removalTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS,super.onHttpStatusHandler,false);
         }
      }
      
      override public function isImage() : Boolean
      {
         return type == BulkLoader.TYPE_IMAGE;
      }
      
      override public function isSWF() : Boolean
      {
         return type == BulkLoader.TYPE_MOVIECLIP;
      }
      
      override public function isStreamable() : Boolean
      {
         return this.isSWF();
      }
      
      override public function destroy() : void
      {
         this.stop();
         this.cleanListeners();
         _content = null;
         if(Boolean(this.loader) && Boolean(this.loader.hasOwnProperty("unloadAndStop")) && this.loader["unloadAndStop"] is Function)
         {
            this.loader["unloadAndStop"](true);
         }
         else if(Boolean(this.loader) && Boolean(this.loader.hasOwnProperty("unload")) && this.loader["unload"] is Function)
         {
            this.loader["unload"]();
         }
         this.loader = null;
      }
   }
}

