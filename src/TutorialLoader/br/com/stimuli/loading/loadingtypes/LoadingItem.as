package br.com.stimuli.loading.loadingtypes
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import br.com.stimuli.loading.utils.SmartURL;
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class LoadingItem extends EventDispatcher
   {
      
      public static const STATUS_STOPPED:String = "stopped";
      
      public static const STATUS_STARTED:String = "started";
      
      public static const STATUS_FINISHED:String = "finished";
      
      public static const STATUS_ERROR:String = "error";
      
      public var _type:String;
      
      public var url:URLRequest;
      
      public var _id:String;
      
      public var _uid:String;
      
      public var _additionIndex:int;
      
      public var _priority:int = 0;
      
      public var _isLoaded:Boolean;
      
      public var _isLoading:Boolean;
      
      public var status:String;
      
      public var maxTries:int = 3;
      
      public var numTries:int = 0;
      
      public var weight:int = 1;
      
      public var preventCache:Boolean;
      
      public var _bytesTotal:int = -1;
      
      public var _bytesLoaded:int = 0;
      
      public var _bytesRemaining:int = 2147483647;
      
      public var _percentLoaded:Number;
      
      public var _weightPercentLoaded:Number;
      
      public var _addedTime:int;
      
      public var _startTime:int;
      
      public var _responseTime:Number;
      
      public var _latency:Number;
      
      public var _totalTime:int;
      
      public var _timeToDownload:Number;
      
      public var _speed:Number;
      
      public var _content:*;
      
      public var _httpStatus:int = -1;
      
      public var _context:* = null;
      
      public var _parsedURL:SmartURL;
      
      public var specificAvailableProps:Array;
      
      public var propertyParsingErrors:Array;
      
      public var errorEvent:ErrorEvent;
      
      public function LoadingItem(url:URLRequest, type:String, _uid:String)
      {
         super();
         this._type = type;
         this.url = url;
         this._parsedURL = new SmartURL(url.url);
         if(!this.specificAvailableProps)
         {
            this.specificAvailableProps = [];
         }
         this._uid = _uid;
      }
      
      public function _parseOptions(props:Object) : Array
      {
         var propName:String = null;
         this.preventCache = props[BulkLoader.PREVENT_CACHING];
         this._id = props[BulkLoader.ID];
         this._priority = int(props[BulkLoader.PRIORITY]) || 0;
         this.maxTries = int(props[BulkLoader.MAX_TRIES]) || 3;
         this.weight = int(props[BulkLoader.WEIGHT]) || 1;
         var allowedProps:Array = BulkLoader.GENERAL_AVAILABLE_PROPS.concat(this.specificAvailableProps);
         this.propertyParsingErrors = [];
         for(propName in props)
         {
            if(allowedProps.indexOf(propName) == -1)
            {
               this.propertyParsingErrors.push(this + ": got a wrong property name: " + propName + ", with value:" + props[propName]);
            }
         }
         return this.propertyParsingErrors;
      }
      
      public function get content() : *
      {
         return this._content;
      }
      
      public function load() : void
      {
         var cacheString:String = null;
         if(this.preventCache)
         {
            cacheString = "BulkLoaderNoCache=" + this._uid + "_" + int(Math.random() * 100 * getTimer());
            if(this.url.url.indexOf("?") == -1)
            {
               this.url.url += "?" + cacheString;
            }
            else
            {
               this.url.url += "&" + cacheString;
            }
         }
         this._isLoading = true;
         this._startTime = getTimer();
      }
      
      public function onHttpStatusHandler(evt:HTTPStatusEvent) : void
      {
         this._httpStatus = evt.status;
         dispatchEvent(evt);
      }
      
      public function onProgressHandler(evt:ProgressEvent) : void
      {
         this._bytesLoaded = evt.bytesLoaded;
         this._bytesTotal = evt.bytesTotal;
         this._bytesRemaining = this._bytesTotal - this.bytesLoaded;
         if(this._bytesRemaining < 0)
         {
            this._bytesRemaining = int.MAX_VALUE;
         }
         if(this._bytesTotal < 4 && this._bytesLoaded > 0)
         {
            this._bytesTotal = int.MAX_VALUE;
         }
         this._percentLoaded = this._bytesLoaded / this._bytesTotal;
         this._weightPercentLoaded = this._percentLoaded * this.weight;
         var e:BulkProgressEvent = new BulkProgressEvent(BulkLoader.PROGRESS,true,false);
         e._percentLoaded = this._percentLoaded;
         e.bytesTotal = this._bytesTotal;
         e.bytesLoaded = this._bytesLoaded;
         evt.stopImmediatePropagation();
         dispatchEvent(e);
      }
      
      public function onCompleteHandler(evt:Event) : void
      {
         this._totalTime = getTimer();
         this._timeToDownload = (this._totalTime - this._responseTime) / 1000;
         if(this._timeToDownload == 0)
         {
            this._timeToDownload = 0.1;
         }
         this._bytesTotal = this._bytesLoaded;
         this._bytesRemaining = 0;
         this._speed = BulkLoader.truncateNumber(this.bytesTotal / 1024 / this._timeToDownload);
         this.status = STATUS_FINISHED;
         this._isLoaded = true;
         dispatchEvent(evt);
         evt.stopPropagation();
      }
      
      public function onErrorHandler(evt:ErrorEvent) : void
      {
         ++this.numTries;
         evt.stopPropagation();
         if(this.numTries < this.maxTries)
         {
            this.status = null;
            this.load();
         }
         else
         {
            this.status = STATUS_ERROR;
            this.errorEvent = evt;
            this._dispatchErrorEvent(this.errorEvent);
         }
      }
      
      public function _dispatchErrorEvent(evt:ErrorEvent) : void
      {
         this.status = STATUS_ERROR;
         dispatchEvent(new ErrorEvent(BulkLoader.ERROR,true,false,evt.text));
      }
      
      public function _createErrorEvent(e:Error) : ErrorEvent
      {
         return new ErrorEvent(BulkLoader.ERROR,false,false,e.message);
      }
      
      public function onSecurityErrorHandler(e:ErrorEvent) : void
      {
         this.status = STATUS_ERROR;
         this.errorEvent = e as ErrorEvent;
         e.stopPropagation();
         this._dispatchErrorEvent(this.errorEvent);
      }
      
      public function onStartedHandler(evt:Event) : void
      {
         this._responseTime = getTimer();
         this._latency = BulkLoader.truncateNumber((this._responseTime - this._startTime) / 1000);
         this.status = STATUS_STARTED;
         dispatchEvent(evt);
      }
      
      override public function toString() : String
      {
         return "LoadingItem url: " + this.url.url + ", type:" + this._type + ", status: " + this.status;
      }
      
      public function stop() : void
      {
         if(this._isLoaded)
         {
            return;
         }
         this.status = STATUS_STOPPED;
         this._isLoading = false;
      }
      
      public function cleanListeners() : void
      {
      }
      
      public function isVideo() : Boolean
      {
         return false;
      }
      
      public function isSound() : Boolean
      {
         return false;
      }
      
      public function isText() : Boolean
      {
         return false;
      }
      
      public function isXML() : Boolean
      {
         return false;
      }
      
      public function isImage() : Boolean
      {
         return false;
      }
      
      public function isSWF() : Boolean
      {
         return false;
      }
      
      public function isLoader() : Boolean
      {
         return false;
      }
      
      public function isStreamable() : Boolean
      {
         return false;
      }
      
      public function destroy() : void
      {
         this._content = null;
      }
      
      public function get bytesTotal() : int
      {
         return this._bytesTotal;
      }
      
      public function get bytesLoaded() : int
      {
         return this._bytesLoaded;
      }
      
      public function get bytesRemaining() : int
      {
         return this._bytesRemaining;
      }
      
      public function get percentLoaded() : Number
      {
         return this._percentLoaded;
      }
      
      public function get weightPercentLoaded() : Number
      {
         return this._weightPercentLoaded;
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get isLoaded() : Boolean
      {
         return this._isLoaded;
      }
      
      public function get addedTime() : int
      {
         return this._addedTime;
      }
      
      public function get startTime() : int
      {
         return this._startTime;
      }
      
      public function get responseTime() : Number
      {
         return this._responseTime;
      }
      
      public function get latency() : Number
      {
         return this._latency;
      }
      
      public function get totalTime() : int
      {
         return this._totalTime;
      }
      
      public function get timeToDownload() : int
      {
         return this._timeToDownload;
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function get httpStatus() : int
      {
         return this._httpStatus;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get hostName() : String
      {
         return this._parsedURL.host;
      }
      
      public function get humanFiriendlySize() : String
      {
         var kb:Number = this._bytesTotal / 1024;
         if(kb < 1024)
         {
            return Math.ceil(kb) + " kb";
         }
         return (kb / 1024).toPrecision(3) + " mb";
      }
      
      public function getStats() : String
      {
         return "Item url: " + this.url.url + "(s), total time: " + (this._totalTime / 1000).toPrecision(3) + "(s), download time: " + this._timeToDownload.toPrecision(3) + "(s), latency:" + this._latency + "(s), speed: " + this._speed + " kb/s, size: " + this.humanFiriendlySize;
      }
   }
}

