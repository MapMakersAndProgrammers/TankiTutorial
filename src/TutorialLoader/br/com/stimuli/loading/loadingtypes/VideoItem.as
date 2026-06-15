package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class VideoItem extends LoadingItem
   {
      
      private var nc:NetConnection;
      
      public var stream:NetStream;
      
      public var dummyEventTrigger:Sprite;
      
      public var _checkPolicyFile:Boolean;
      
      public var pausedAtStart:Boolean = false;
      
      public var _metaData:Object;
      
      public var _canBeginStreaming:Boolean = false;
      
      public function VideoItem(url:URLRequest, type:String, uid:String)
      {
         specificAvailableProps = [BulkLoader.CHECK_POLICY_FILE,BulkLoader.PAUSED_AT_START];
         super(url,type,uid);
         _bytesTotal = _bytesLoaded = 0;
      }
      
      override public function _parseOptions(props:Object) : Array
      {
         this.pausedAtStart = Boolean(props[BulkLoader.PAUSED_AT_START]);
         this._checkPolicyFile = Boolean(props[BulkLoader.CHECK_POLICY_FILE]);
         return super._parseOptions(props);
      }
      
      override public function load() : void
      {
         var customClient:Object;
         super.load();
         this.nc = new NetConnection();
         this.nc.connect(null);
         this.stream = new NetStream(this.nc);
         this.stream.addEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false,0,true);
         this.stream.addEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false,0,true);
         this.dummyEventTrigger = new Sprite();
         this.dummyEventTrigger.addEventListener(Event.ENTER_FRAME,this.createNetStreamEvent,false,0,true);
         customClient = new Object();
         customClient.onCuePoint = function(... args):void
         {
         };
         customClient.onMetaData = this.onVideoMetadata;
         customClient.onPlayStatus = function(... args):void
         {
         };
         this.stream.client = customClient;
         try
         {
            this.stream.play(url.url,this._checkPolicyFile);
         }
         catch(e:SecurityError)
         {
            onSecurityErrorHandler(_createErrorEvent(e));
         }
      }
      
      public function createNetStreamEvent(evt:Event) : void
      {
         var completeEvent:Event = null;
         var startEvent:Event = null;
         var event:ProgressEvent = null;
         var timeElapsed:int = 0;
         var currentSpeed:Number = NaN;
         var estimatedTimeRemaining:Number = NaN;
         var videoTimeToDownload:Number = NaN;
         if(_bytesTotal == _bytesLoaded && _bytesTotal > 8)
         {
            if(Boolean(this.dummyEventTrigger))
            {
               this.dummyEventTrigger.removeEventListener(Event.ENTER_FRAME,this.createNetStreamEvent,false);
            }
            this.fireCanBeginStreamingEvent();
            completeEvent = new Event(Event.COMPLETE);
            this.onCompleteHandler(completeEvent);
         }
         else if(Boolean(_bytesTotal == 0) && Boolean(this.stream) && this.stream.bytesTotal > 4)
         {
            startEvent = new Event(Event.OPEN);
            this.onStartedHandler(startEvent);
            _bytesLoaded = this.stream.bytesLoaded;
            _bytesTotal = this.stream.bytesTotal;
         }
         else if(Boolean(this.stream))
         {
            event = new ProgressEvent(ProgressEvent.PROGRESS,false,false,this.stream.bytesLoaded,this.stream.bytesTotal);
            if(Boolean(this.isVideo()) && Boolean(this.metaData) && !this._canBeginStreaming)
            {
               timeElapsed = getTimer() - responseTime;
               if(timeElapsed > 100)
               {
                  currentSpeed = bytesLoaded / (timeElapsed / 1000);
                  _bytesRemaining = _bytesTotal - bytesLoaded;
                  estimatedTimeRemaining = _bytesRemaining / (currentSpeed * 0.8);
                  videoTimeToDownload = this.metaData.duration - this.stream.bufferLength;
                  if(videoTimeToDownload > estimatedTimeRemaining)
                  {
                     this.fireCanBeginStreamingEvent();
                  }
               }
            }
            super.onProgressHandler(event);
         }
      }
      
      override public function onCompleteHandler(evt:Event) : void
      {
         _content = this.stream;
         super.onCompleteHandler(evt);
      }
      
      override public function onStartedHandler(evt:Event) : void
      {
         _content = this.stream;
         if(this.pausedAtStart && Boolean(this.stream))
         {
            this.stream.pause();
            this.stream.seek(0);
         }
         super.onStartedHandler(evt);
      }
      
      override public function stop() : void
      {
         try
         {
            if(Boolean(this.stream))
            {
               this.stream.close();
            }
         }
         catch(e:Error)
         {
         }
         super.stop();
      }
      
      override public function cleanListeners() : void
      {
         if(Boolean(this.stream))
         {
            this.stream.removeEventListener(IOErrorEvent.IO_ERROR,onErrorHandler,false);
            this.stream.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false);
         }
         if(Boolean(this.dummyEventTrigger))
         {
            this.dummyEventTrigger.removeEventListener(Event.ENTER_FRAME,this.createNetStreamEvent,false);
            this.dummyEventTrigger = null;
         }
      }
      
      override public function isVideo() : Boolean
      {
         return true;
      }
      
      override public function isStreamable() : Boolean
      {
         return true;
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.stream))
         {
         }
         this.stop();
         this.cleanListeners();
         this.stream = null;
         super.destroy();
      }
      
      internal function onNetStatus(evt:NetStatusEvent) : void
      {
         var e:Event = null;
         if(!this.stream)
         {
            return;
         }
         this.stream.removeEventListener(NetStatusEvent.NET_STATUS,this.onNetStatus,false);
         if(evt.info.code == "NetStream.Play.Start")
         {
            _content = this.stream;
            e = new Event(Event.OPEN);
            this.onStartedHandler(e);
         }
         else if(evt.info.code == "NetStream.Play.StreamNotFound")
         {
            onErrorHandler(_createErrorEvent(new Error("[VideoItem] NetStream not found at " + this.url.url)));
         }
      }
      
      internal function onVideoMetadata(evt:*) : void
      {
         this._metaData = evt;
      }
      
      public function get metaData() : Object
      {
         return this._metaData;
      }
      
      public function get checkPolicyFile() : Object
      {
         return this._checkPolicyFile;
      }
      
      private function fireCanBeginStreamingEvent() : void
      {
         if(this._canBeginStreaming)
         {
            return;
         }
         this._canBeginStreaming = true;
         var evt:Event = new Event(BulkLoader.CAN_BEGIN_PLAYING);
         dispatchEvent(evt);
      }
      
      public function get canBeginStreaming() : Boolean
      {
         return this._canBeginStreaming;
      }
   }
}

