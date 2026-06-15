package br.com.stimuli.loading
{
   import br.com.stimuli.loading.loadingtypes.*;
   import flash.display.*;
   import flash.events.*;
   import flash.media.Sound;
   import flash.net.*;
   import flash.utils.*;
   
   public class BulkLoader extends EventDispatcher
   {
      
      public static var _customTypesExtensions:Object;
      
      public static const VERSION:String = "$Id$";
      
      public static const TYPE_BINARY:String = "binary";
      
      public static const TYPE_IMAGE:String = "image";
      
      public static const TYPE_MOVIECLIP:String = "movieclip";
      
      public static const TYPE_SOUND:String = "sound";
      
      public static const TYPE_TEXT:String = "text";
      
      public static const TYPE_XML:String = "xml";
      
      public static const TYPE_VIDEO:String = "video";
      
      public static const AVAILABLE_TYPES:Array = [TYPE_VIDEO,TYPE_XML,TYPE_TEXT,TYPE_SOUND,TYPE_MOVIECLIP,TYPE_IMAGE,TYPE_BINARY];
      
      public static var AVAILABLE_EXTENSIONS:Array = ["swf","jpg","jpeg","gif","png","flv","mp3","xml","txt","js"];
      
      public static var IMAGE_EXTENSIONS:Array = ["jpg","jpeg","gif","png"];
      
      public static var MOVIECLIP_EXTENSIONS:Array = ["swf"];
      
      public static var TEXT_EXTENSIONS:Array = ["txt","js","php","asp","py"];
      
      public static var VIDEO_EXTENSIONS:Array = ["flv","f4v","f4p","mp4"];
      
      public static var SOUND_EXTENSIONS:Array = ["mp3","f4a","f4b"];
      
      public static var XML_EXTENSIONS:Array = ["xml"];
      
      public static const PROGRESS:String = "progress";
      
      public static const COMPLETE:String = "complete";
      
      public static const HTTP_STATUS:String = "httpStatus";
      
      public static const ERROR:String = "error";
      
      public static const SECURITY_ERROR:String = "securityError";
      
      public static const OPEN:String = "open";
      
      public static const CAN_BEGIN_PLAYING:String = "canBeginPlaying";
      
      public static const CHECK_POLICY_FILE:String = "checkPolicyFile";
      
      public static const PREVENT_CACHING:String = "preventCache";
      
      public static const HEADERS:String = "headers";
      
      public static const CONTEXT:String = "context";
      
      public static const ID:String = "id";
      
      public static const PRIORITY:String = "priority";
      
      public static const MAX_TRIES:String = "maxTries";
      
      public static const WEIGHT:String = "weight";
      
      public static const PAUSED_AT_START:String = "pausedAtStart";
      
      public static const GENERAL_AVAILABLE_PROPS:Array = [WEIGHT,MAX_TRIES,HEADERS,ID,PRIORITY,PREVENT_CACHING,"type"];
      
      public static var _instancesCreated:int = 0;
      
      public static var _allLoaders:Object = {};
      
      public static const DEFAULT_NUM_CONNECTIONS:int = 12;
      
      public static const LOG_VERBOSE:int = 0;
      
      public static const LOG_INFO:int = 2;
      
      public static const LOG_WARNINGS:int = 3;
      
      public static const LOG_ERRORS:int = 4;
      
      public static const LOG_SILENT:int = 10;
      
      public static const DEFAULT_LOG_LEVEL:int = LOG_ERRORS;
      
      public static var _typeClasses:Object = {
         "image":ImageItem,
         "movieclip":ImageItem,
         "xml":XMLItem,
         "video":VideoItem,
         "sound":SoundItem,
         "text":URLItem,
         "binary":BinaryItem
      };
      
      public var _name:String;
      
      public var _id:int;
      
      public var _items:Array = [];
      
      public var _contents:Dictionary = new Dictionary(true);
      
      public var _additionIndex:int = 0;
      
      public var _numConnections:int = 12;
      
      public var maxConnectionsPerHost:int = 2;
      
      public var _connections:Object;
      
      public var _loadedRatio:Number = 0;
      
      public var _itemsTotal:int = 0;
      
      public var _itemsLoaded:int = 0;
      
      public var _totalWeight:int = 0;
      
      public var _bytesTotal:int = 0;
      
      public var _bytesTotalCurrent:int = 0;
      
      public var _bytesLoaded:int = 0;
      
      public var _percentLoaded:Number = 0;
      
      public var _weightPercent:Number;
      
      public var avgLatency:Number;
      
      public var speedAvg:Number;
      
      public var _speedTotal:Number;
      
      public var _startTime:int;
      
      public var _endTIme:int;
      
      public var _lastSpeedCheck:int;
      
      public var _lastBytesCheck:int;
      
      public var _speed:Number;
      
      public var totalTime:Number;
      
      public var logLevel:int = 4;
      
      public var _allowsAutoIDFromFileName:Boolean = false;
      
      public var _isRunning:Boolean;
      
      public var _isFinished:Boolean;
      
      public var _isPaused:Boolean = true;
      
      public var _logFunction:Function = trace;
      
      public var _stringSubstitutions:Object;
      
      public function BulkLoader(name:String = null, numConnections:int = 12, logLevel:int = 4)
      {
         super();
         if(!name)
         {
            name = getUniqueName();
         }
         if(Boolean(_allLoaders[name]))
         {
            __debug_print_loaders();
            throw new Error("BulkLoader with name\'" + name + "\' has already been created.");
         }
         if(!name)
         {
            throw new Error("Cannot create a BulkLoader instance without a name");
         }
         _allLoaders[name] = this;
         if(numConnections > 0)
         {
            this._numConnections = numConnections;
         }
         this.logLevel = logLevel;
         this._name = name;
         ++_instancesCreated;
         this._id = _instancesCreated;
         this._additionIndex = 0;
         addEventListener(BulkLoader.ERROR,this._swallowError,false,1,true);
      }
      
      public static function createUniqueNamedLoader(numConnections:int = 12, logLevel:int = 4) : BulkLoader
      {
         return new BulkLoader(BulkLoader.getUniqueName(),numConnections,logLevel);
      }
      
      public static function getUniqueName() : String
      {
         return "BulkLoader-" + _instancesCreated;
      }
      
      public static function getLoader(name:String) : BulkLoader
      {
         return BulkLoader._allLoaders[name] as BulkLoader;
      }
      
      public static function _hasItemInBulkLoader(key:*, atLoader:BulkLoader) : Boolean
      {
         var item:LoadingItem = atLoader.get(key);
         if(Boolean(item) && item._isLoaded)
         {
            return true;
         }
         return false;
      }
      
      public static function whichLoaderHasItem(key:*) : BulkLoader
      {
         var l:BulkLoader = null;
         for each(l in _allLoaders)
         {
            if(BulkLoader._hasItemInBulkLoader(key,l))
            {
               return l;
            }
         }
         return null;
      }
      
      public static function registerNewType(extension:String, atType:String, withClass:Class = null) : Boolean
      {
         var extensions:Array = null;
         if(extension.charAt(0) == ".")
         {
            extension = extension.substring(1);
         }
         if(!_customTypesExtensions)
         {
            _customTypesExtensions = {};
         }
         atType = atType.toLowerCase();
         if(AVAILABLE_TYPES.indexOf(atType) == -1)
         {
            if(!Boolean(withClass))
            {
               throw new Error("[BulkLoader]: When adding a new type and extension, you must determine which class to use");
            }
            _typeClasses[atType] = withClass;
            if(!_customTypesExtensions[atType])
            {
               _customTypesExtensions[atType] = [];
               AVAILABLE_TYPES.push(atType);
            }
            _customTypesExtensions[atType].push(extension);
            return true;
         }
         if(Boolean(_customTypesExtensions[atType]))
         {
            _customTypesExtensions[atType].push(extension);
         }
         var options:Object = {};
         options[TYPE_IMAGE] = IMAGE_EXTENSIONS;
         options[TYPE_MOVIECLIP] = MOVIECLIP_EXTENSIONS;
         options[TYPE_VIDEO] = VIDEO_EXTENSIONS;
         options[TYPE_SOUND] = SOUND_EXTENSIONS;
         options[TYPE_TEXT] = TEXT_EXTENSIONS;
         options[TYPE_XML] = XML_EXTENSIONS;
         extensions = options[atType];
         if(Boolean(extensions) && extensions.indexOf(extension) == -1)
         {
            extensions.push(extension);
            return true;
         }
         return false;
      }
      
      public static function removeAllLoaders() : void
      {
         var atLoader:BulkLoader = null;
         for each(atLoader in _allLoaders)
         {
            atLoader.removeAll();
            atLoader.clear();
            atLoader = null;
         }
         _allLoaders = {};
      }
      
      public static function pauseAllLoaders() : void
      {
         var atLoader:BulkLoader = null;
         for each(atLoader in _allLoaders)
         {
            atLoader.pauseAll();
         }
      }
      
      public static function truncateNumber(raw:Number, decimals:int = 2) : Number
      {
         var power:int = Math.pow(10,decimals);
         return Math.round(raw * power) / power;
      }
      
      public static function guessType(urlAsString:String) : String
      {
         var type:String = null;
         var checkType:String = null;
         var checkExt:String = null;
         var searchString:String = urlAsString.indexOf("?") > -1 ? urlAsString.substring(0,urlAsString.indexOf("?")) : urlAsString;
         var finalPart:String = searchString.substring(searchString.lastIndexOf("/"));
         var extension:String = finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
         if(!Boolean(extension))
         {
            extension = BulkLoader.TYPE_TEXT;
         }
         if(extension == BulkLoader.TYPE_IMAGE || BulkLoader.IMAGE_EXTENSIONS.indexOf(extension) > -1)
         {
            type = BulkLoader.TYPE_IMAGE;
         }
         else if(extension == BulkLoader.TYPE_SOUND || BulkLoader.SOUND_EXTENSIONS.indexOf(extension) > -1)
         {
            type = BulkLoader.TYPE_SOUND;
         }
         else if(extension == BulkLoader.TYPE_VIDEO || BulkLoader.VIDEO_EXTENSIONS.indexOf(extension) > -1)
         {
            type = BulkLoader.TYPE_VIDEO;
         }
         else if(extension == BulkLoader.TYPE_XML || BulkLoader.XML_EXTENSIONS.indexOf(extension) > -1)
         {
            type = BulkLoader.TYPE_XML;
         }
         else if(extension == BulkLoader.TYPE_MOVIECLIP || BulkLoader.MOVIECLIP_EXTENSIONS.indexOf(extension) > -1)
         {
            type = BulkLoader.TYPE_MOVIECLIP;
         }
         else
         {
            for(checkType in _customTypesExtensions)
            {
               for each(checkExt in _customTypesExtensions[checkType])
               {
                  if(checkExt == extension)
                  {
                     type = checkType;
                     break;
                  }
                  if(Boolean(type))
                  {
                     break;
                  }
               }
            }
            if(!type)
            {
               type = BulkLoader.TYPE_TEXT;
            }
         }
         return type;
      }
      
      public static function substituteURLString(raw:String, substitutions:Object) : String
      {
         var lastMatch:Object = null;
         var match:Object = null;
         var subs:String = null;
         if(!substitutions)
         {
            return raw;
         }
         var subRegex:RegExp = /(?P<var_name>\{\s*[^\}]*\})/g;
         var result:Object = subRegex.exec(raw);
         var var_name:String = Boolean(result) ? result.var_name : null;
         var matches:Array = [];
         var numRuns:int = 0;
         while(Boolean(result) && Boolean(result.var_name))
         {
            if(Boolean(result.var_name))
            {
               var_name = result.var_name;
               var_name = var_name.replace("{","");
               var_name = var_name.replace("}","");
               var_name = var_name.replace(/\s*/g,"");
            }
            matches.push({
               "start":result.index,
               "end":result.index + result.var_name.length,
               "changeTo":substitutions[var_name]
            });
            numRuns++;
            if(numRuns > 400)
            {
               break;
            }
            result = subRegex.exec(raw);
            var_name = Boolean(result) ? result.var_name : null;
         }
         if(matches.length == 0)
         {
            return raw;
         }
         var buffer:Array = [];
         var previous:String = raw.substr(0,matches[0].start);
         for each(match in matches)
         {
            if(Boolean(lastMatch))
            {
               previous = raw.substring(lastMatch.end,match.start);
            }
            buffer.push(previous);
            buffer.push(match.changeTo);
            lastMatch = match;
         }
         buffer.push(raw.substring(match.end));
         return buffer.join("");
      }
      
      public static function getFileName(text:String, allowExtension:Boolean = false) : String
      {
         if(text.lastIndexOf("/") == text.length - 1)
         {
            return getFileName(text.substring(0,text.length - 1));
         }
         var startAt:int = text.lastIndexOf("/") + 1;
         var croppedString:String = text.substring(startAt);
         var lastIndex:int = allowExtension ? croppedString.length : croppedString.indexOf(".");
         if(lastIndex == -1)
         {
            if(croppedString.indexOf("?") > -1)
            {
               lastIndex = croppedString.indexOf("?");
            }
            else
            {
               lastIndex = croppedString.length;
            }
         }
         return croppedString.substring(0,lastIndex);
      }
      
      public static function __debug_print_loaders() : void
      {
         var instNames:String = null;
         var theNames:Array = [];
         for each(instNames in BulkLoader._allLoaders)
         {
            theNames.push(instNames);
         }
         theNames.sort();
         trace("All loaders");
         theNames.forEach(function(item:*, ... rest):void
         {
            trace("\t",item);
         });
         trace("===========");
      }
      
      public static function __debug_print_num_loaders() : void
      {
         var instNames:String = null;
         var num:int = 0;
         for each(instNames in BulkLoader._allLoaders)
         {
            num++;
         }
         trace("BulkLoader has ",num,"instances");
      }
      
      public static function __debug_printStackTrace() : void
      {
         try
         {
            throw new Error("stack trace");
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
      }
      
      public function hasItem(key:*, searchAll:Boolean = true) : Boolean
      {
         var loaders:* = undefined;
         var l:BulkLoader = null;
         if(searchAll)
         {
            loaders = _allLoaders;
         }
         else
         {
            loaders = [this];
         }
         for each(l in loaders)
         {
            if(_hasItemInBulkLoader(key,l))
            {
               return true;
            }
         }
         return false;
      }
      
      public function add(url:*, props:Object = null) : LoadingItem
      {
         var type:String = null;
         var error:String = null;
         if(!this._name)
         {
            throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
         }
         if(!url || !String(url))
         {
            throw new Error("[BulkLoader] Cannot add an item with a null url");
         }
         props ||= {};
         if(url is String)
         {
            url = new URLRequest(BulkLoader.substituteURLString(url,this._stringSubstitutions));
            if(Boolean(props[HEADERS]))
            {
               url.requestHeaders = props[HEADERS];
            }
         }
         else if(!url is URLRequest)
         {
            throw new Error("[BulkLoader] cannot add object with bad type for url:\'" + url.url);
         }
         var item:LoadingItem = this.get(props[ID]);
         if(Boolean(item))
         {
            this.log("Add received an already added id: " + props[ID] + ", not adding a new item");
            return item;
         }
         if(Boolean(props["type"]))
         {
            type = props["type"].toLowerCase();
            if(AVAILABLE_TYPES.indexOf(type) == -1)
            {
               this.log("add received an unknown type:",type,"and will cast it to text",LOG_WARNINGS);
            }
         }
         if(!type)
         {
            type = guessType(url.url);
         }
         ++this._additionIndex;
         item = new _typeClasses[type](url,type,_instancesCreated + "_" + String(this._additionIndex));
         if(!props["id"] && this._allowsAutoIDFromFileName)
         {
            props["id"] = getFileName(url.url);
            this.log("Adding automatic id from file name for item:",item,"( id= " + props["id"] + " )");
         }
         var errors:Array = item._parseOptions(props);
         for each(error in errors)
         {
            this.log(error,LOG_WARNINGS);
         }
         this.log("Added",item,LOG_VERBOSE);
         item._addedTime = getTimer();
         item._additionIndex = this._additionIndex;
         item.addEventListener(Event.COMPLETE,this._onItemComplete,false,int.MIN_VALUE,true);
         item.addEventListener(Event.COMPLETE,this._incrementItemsLoaded,false,int.MAX_VALUE,true);
         item.addEventListener(ERROR,this._onItemError,false,0,true);
         item.addEventListener(Event.OPEN,this._onItemStarted,false,0,true);
         item.addEventListener(ProgressEvent.PROGRESS,this._onProgress,false,0,true);
         this._items.push(item);
         this._itemsTotal += 1;
         this._totalWeight += item.weight;
         this.sortItemsByPriority();
         this._isFinished = false;
         if(!this._isPaused)
         {
            this._loadNext();
         }
         return item;
      }
      
      public function start(withConnections:int = -1) : void
      {
         if(withConnections > 0)
         {
            this._numConnections = withConnections;
         }
         if(Boolean(this._connections))
         {
            this._loadNext();
            return;
         }
         this._startTime = getTimer();
         this._connections = {};
         this._loadNext();
         this._isRunning = true;
         this._lastBytesCheck = 0;
         this._lastSpeedCheck = getTimer();
         this._isPaused = false;
      }
      
      public function reload(key:*) : Boolean
      {
         var item:LoadingItem = this.get(key);
         if(!item)
         {
            return false;
         }
         this._removeFromItems(item);
         this._removeFromConnections(item);
         item.stop();
         item.cleanListeners();
         item.status = null;
         this._isFinished = false;
         item._addedTime = getTimer();
         item._additionIndex = this._additionIndex++;
         item.addEventListener(Event.COMPLETE,this._onItemComplete,false,int.MIN_VALUE,true);
         item.addEventListener(Event.COMPLETE,this._incrementItemsLoaded,false,int.MAX_VALUE,true);
         item.addEventListener(ERROR,this._onItemError,false,0,true);
         item.addEventListener(Event.OPEN,this._onItemStarted,false,0,true);
         item.addEventListener(ProgressEvent.PROGRESS,this._onProgress,false,0,true);
         this._items.push(item);
         this._itemsTotal += 1;
         this._totalWeight += item.weight;
         this.sortItemsByPriority();
         this._isFinished = false;
         this.loadNow(item);
         return true;
      }
      
      public function loadNow(key:*) : Boolean
      {
         var itemToRemove:LoadingItem = null;
         var item:LoadingItem = this.get(key);
         if(!item)
         {
            return false;
         }
         if(!this._connections)
         {
            this._connections = {};
         }
         if(item.status == LoadingItem.STATUS_FINISHED || item.status == LoadingItem.STATUS_STARTED)
         {
            return true;
         }
         if(this._getNumConnections() >= this.numConnections || this._getNumConnectionsForItem(item) >= this.maxConnectionsPerHost)
         {
            itemToRemove = this._getLeastUrgentOpenedItem();
            this.pause(itemToRemove);
            this._removeFromConnections(itemToRemove);
            itemToRemove.status = null;
         }
         item._priority = this.highestPriority;
         this._loadNext(item);
         return true;
      }
      
      public function _getLeastUrgentOpenedItem() : LoadingItem
      {
         var itemsToLoad:Array = this._getAllConnections();
         itemsToLoad.sortOn(["priority","bytesRemaining","_additionIndex"],[Array.NUMERIC,Array.DESCENDING,Array.NUMERIC,Array.NUMERIC]);
         return LoadingItem(itemsToLoad[0]);
      }
      
      public function _getNextItemToLoad() : LoadingItem
      {
         var checkItem:LoadingItem = null;
         this._getAllConnections().forEach(function(i:LoadingItem, ... rest):void
         {
            if(i.status == LoadingItem.STATUS_ERROR && i.numTries >= i.maxTries)
            {
               _removeFromConnections(i);
            }
         });
         for each(checkItem in this._items)
         {
            if(!checkItem._isLoading && checkItem.status != LoadingItem.STATUS_STOPPED && this._canOpenConnectioForItem(checkItem))
            {
               return checkItem;
            }
         }
         return null;
      }
      
      public function _loadNext(toLoad:LoadingItem = null) : Boolean
      {
         var connectionsForItem:Array = null;
         if(this._isFinished)
         {
            return false;
         }
         if(!this._connections)
         {
            this._connections = {};
         }
         var next:Boolean = false;
         toLoad ||= this._getNextItemToLoad();
         if(Boolean(toLoad))
         {
            next = true;
            this._isRunning = true;
            if(this._canOpenConnectioForItem(toLoad))
            {
               connectionsForItem = this._getConnectionsForHostName(toLoad.hostName);
               connectionsForItem.push(toLoad);
               toLoad.load();
               this.log("Will load item:",toLoad,LOG_INFO);
            }
            if(Boolean(this._getNextItemToLoad()))
            {
               this._loadNext();
            }
         }
         return next;
      }
      
      public function _onItemComplete(evt:Event) : void
      {
         var item:LoadingItem = evt.target as LoadingItem;
         this._removeFromConnections(item);
         this.log("Loaded ",item,LOG_INFO);
         this.log("Items to load",this.getNotLoadedItems(),LOG_VERBOSE);
         item.cleanListeners();
         this._contents[item.url.url] = item.content;
         var next:Boolean = this._loadNext();
         var allDone:Boolean = this._isAllDoneP();
         if(allDone)
         {
            this._onAllLoaded();
         }
         evt.stopPropagation();
      }
      
      public function _incrementItemsLoaded(evt:Event) : void
      {
         ++this._itemsLoaded;
      }
      
      public function _updateStats() : void
      {
         var item:LoadingItem = null;
         this.avgLatency = 0;
         this.speedAvg = 0;
         var totalLatency:Number = 0;
         var totalBytes:int = 0;
         this._speedTotal = 0;
         var num:Number = 0;
         for each(item in this._items)
         {
            if(item._isLoaded && item.status != LoadingItem.STATUS_ERROR)
            {
               totalLatency += item.latency;
               totalBytes += item.bytesTotal;
               num++;
            }
         }
         this._speedTotal = totalBytes / 1024 / this.totalTime;
         this.avgLatency = totalLatency / num;
         this.speedAvg = this._speedTotal / num;
      }
      
      public function _removeFromItems(item:LoadingItem) : Boolean
      {
         var removeIndex:int = this._items.indexOf(item);
         if(removeIndex > -1)
         {
            this._items.splice(removeIndex,1);
            if(item._isLoaded)
            {
               --this._itemsLoaded;
            }
            --this._itemsTotal;
            this._totalWeight -= item.weight;
            this.log("Removing " + item,LOG_VERBOSE);
            item.removeEventListener(Event.COMPLETE,this._onItemComplete,false);
            item.removeEventListener(Event.COMPLETE,this._incrementItemsLoaded,false);
            item.removeEventListener(ERROR,this._onItemError,false);
            item.removeEventListener(Event.OPEN,this._onItemStarted,false);
            item.removeEventListener(ProgressEvent.PROGRESS,this._onProgress,false);
            return true;
         }
         return false;
      }
      
      public function _removeFromConnections(item:*) : Boolean
      {
         if(!this._connections || this._getNumConnectionsForItem(item) == 0)
         {
            return false;
         }
         var connectionsForHost:Array = this._getConnectionsForHostName(item.hostName);
         var removeIndex:int = connectionsForHost.indexOf(item);
         if(removeIndex > -1)
         {
            connectionsForHost.splice(removeIndex,1);
            return true;
         }
         return false;
      }
      
      public function _getNumConnectionsForHostname(hostname:String) : int
      {
         var conns:Array = this._getConnectionsForHostName(hostname);
         if(!conns)
         {
            return 0;
         }
         return conns.length;
      }
      
      public function _getNumConnectionsForItem(item:LoadingItem) : int
      {
         var conns:Array = this._getConnectionsForHostName(item.hostName);
         if(!conns)
         {
            return 0;
         }
         return conns.length;
      }
      
      public function _getAllConnections() : Array
      {
         var hostname:String = null;
         var conns:Array = [];
         for(hostname in this._connections)
         {
            conns = conns.concat(this._connections[hostname]);
         }
         return conns;
      }
      
      public function _getNumConnections() : int
      {
         var hostname:String = null;
         var connections:int = 0;
         for(hostname in this._connections)
         {
            connections += this._connections[hostname].length;
         }
         return connections;
      }
      
      public function _getConnectionsForHostName(hostname:String) : Array
      {
         if(this._connections[hostname] == null)
         {
            this._connections[hostname] = [];
         }
         return this._connections[hostname];
      }
      
      public function _canOpenConnectioForItem(item:LoadingItem) : Boolean
      {
         if(this._getNumConnections() >= this.numConnections)
         {
            return false;
         }
         if(this._getNumConnectionsForItem(item) >= this.maxConnectionsPerHost)
         {
            return false;
         }
         return true;
      }
      
      public function _onItemError(evt:ErrorEvent) : void
      {
         var item:LoadingItem = evt.target as LoadingItem;
         this._removeFromConnections(item);
         this.log("After " + item.numTries + " I am giving up on " + item.url.url,LOG_ERRORS);
         this.log("Error loading",item,evt.text,LOG_ERRORS);
         this._loadNext();
         dispatchEvent(evt);
      }
      
      public function _onItemStarted(evt:Event) : void
      {
         var item:LoadingItem = evt.target as LoadingItem;
         this.log("Started loading",item,LOG_INFO);
         dispatchEvent(evt);
      }
      
      public function _onProgress(evt:Event = null) : void
      {
         var e:BulkProgressEvent = this.getProgressForItems(this._items);
         this._bytesLoaded = e.bytesLoaded;
         this._bytesTotal = e.bytesTotal;
         this._weightPercent = e.weightPercent;
         this._percentLoaded = e.percentLoaded;
         this._bytesTotalCurrent = e.bytesTotalCurrent;
         this._loadedRatio = e.ratioLoaded;
         dispatchEvent(e);
      }
      
      public function getProgressForItems(keys:Array) : BulkProgressEvent
      {
         var item:LoadingItem = null;
         var key:* = undefined;
         this._bytesLoaded = this._bytesTotal = this._bytesTotalCurrent = 0;
         var localWeightPercent:Number = 0;
         var localWeightTotal:int = 0;
         var itemsStarted:int = 0;
         var localWeightLoaded:Number = 0;
         var localItemsTotal:int = 0;
         var localItemsLoaded:int = 0;
         var localBytesLoaded:int = 0;
         var localBytesTotal:int = 0;
         var localBytesTotalCurrent:int = 0;
         var theseItems:Array = [];
         for each(key in keys)
         {
            item = this.get(key);
            if(item)
            {
               localItemsTotal++;
               localWeightTotal += item.weight;
               if(item.status == LoadingItem.STATUS_STARTED || item.status == LoadingItem.STATUS_FINISHED || item.status == LoadingItem.STATUS_STOPPED)
               {
                  localBytesLoaded += item._bytesLoaded;
                  localBytesTotalCurrent += item._bytesTotal;
                  if(item._bytesTotal > 0)
                  {
                     localWeightLoaded += item._bytesLoaded / item._bytesTotal * item.weight;
                  }
                  if(item.status == LoadingItem.STATUS_FINISHED)
                  {
                     localItemsLoaded++;
                  }
                  itemsStarted++;
               }
            }
         }
         if(itemsStarted != localItemsTotal)
         {
            localBytesTotal = Number.POSITIVE_INFINITY;
         }
         else
         {
            localBytesTotal = localBytesTotalCurrent;
         }
         localWeightPercent = localWeightLoaded / localWeightTotal;
         if(localWeightTotal == 0)
         {
            localWeightPercent = 0;
         }
         var e:BulkProgressEvent = new BulkProgressEvent(PROGRESS);
         e.setInfo(localBytesLoaded,localBytesTotal,localBytesTotal,localItemsLoaded,localItemsTotal,localWeightPercent);
         return e;
      }
      
      public function get numConnections() : int
      {
         return this._numConnections;
      }
      
      public function get contents() : Object
      {
         return this._contents;
      }
      
      public function get items() : Array
      {
         return this._items.slice();
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get loadedRatio() : Number
      {
         return this._loadedRatio;
      }
      
      public function get itemsTotal() : int
      {
         return this.items.length;
      }
      
      public function get itemsLoaded() : int
      {
         return this._itemsLoaded;
      }
      
      public function set itemsLoaded(value:int) : void
      {
         this._itemsLoaded = value;
      }
      
      public function get totalWeight() : int
      {
         return this._totalWeight;
      }
      
      public function get bytesTotal() : int
      {
         return this._bytesTotal;
      }
      
      public function get bytesLoaded() : int
      {
         return this._bytesLoaded;
      }
      
      public function get bytesTotalCurrent() : int
      {
         return this._bytesTotalCurrent;
      }
      
      public function get percentLoaded() : Number
      {
         return this._percentLoaded;
      }
      
      public function get weightPercent() : Number
      {
         return this._weightPercent;
      }
      
      public function get isRunning() : Boolean
      {
         return this._isRunning;
      }
      
      public function get isFinished() : Boolean
      {
         return this._isFinished;
      }
      
      public function get highestPriority() : int
      {
         var item:LoadingItem = null;
         var highest:int = int.MIN_VALUE;
         for each(item in this._items)
         {
            if(item.priority > highest)
            {
               highest = item.priority;
            }
         }
         return highest;
      }
      
      public function get logFunction() : Function
      {
         return this._logFunction;
      }
      
      public function get allowsAutoIDFromFileName() : Boolean
      {
         return this._allowsAutoIDFromFileName;
      }
      
      public function set allowsAutoIDFromFileName(value:Boolean) : void
      {
         this._allowsAutoIDFromFileName = value;
      }
      
      public function getNotLoadedItems() : Array
      {
         return this._items.filter(function(i:LoadingItem, ... rest):Boolean
         {
            return i.status != LoadingItem.STATUS_FINISHED;
         });
      }
      
      public function get speed() : Number
      {
         var timeElapsed:int = getTimer() - this._lastSpeedCheck;
         var bytesDelta:int = (this.bytesLoaded - this._lastBytesCheck) / 1024;
         var speed:int = bytesDelta / (timeElapsed / 1000);
         this._lastSpeedCheck = timeElapsed;
         this._lastBytesCheck = this.bytesLoaded;
         return speed;
      }
      
      public function set logFunction(func:Function) : void
      {
         this._logFunction = func;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get stringSubstitutions() : Object
      {
         return this._stringSubstitutions;
      }
      
      public function set stringSubstitutions(value:Object) : void
      {
         this._stringSubstitutions = value;
      }
      
      public function changeItemPriority(key:String, newPriority:int) : Boolean
      {
         var item:LoadingItem = this.get(key);
         if(!item)
         {
            return false;
         }
         item._priority = newPriority;
         this.sortItemsByPriority();
         return true;
      }
      
      public function sortItemsByPriority() : void
      {
         this._items.sortOn(["priority","_additionIndex"],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
      }
      
      public function _getContentAsType(key:*, type:Class, clearMemory:Boolean = false) : *
      {
         var item:LoadingItem;
         var res:* = undefined;
         if(!this._name)
         {
            throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
         }
         item = this.get(key);
         if(!item)
         {
            return null;
         }
         try
         {
            if(item._isLoaded || item.isStreamable() && item.status == LoadingItem.STATUS_STARTED)
            {
               res = item.content as type;
               if(res == null)
               {
                  throw new Error("bad cast");
               }
               if(clearMemory)
               {
                  this.remove(key);
                  if(!this._isPaused)
                  {
                     this._loadNext();
                  }
               }
               return res;
            }
         }
         catch(e:Error)
         {
            log("Failed to get content with url: \'" + key + "\'as type:",type,LOG_ERRORS);
         }
         return null;
      }
      
      public function getContent(key:String, clearMemory:Boolean = false) : *
      {
         return this._getContentAsType(key,Object,clearMemory);
      }
      
      public function getXML(key:*, clearMemory:Boolean = false) : XML
      {
         return XML(this._getContentAsType(key,XML,clearMemory));
      }
      
      public function getText(key:*, clearMemory:Boolean = false) : String
      {
         return String(this._getContentAsType(key,String,clearMemory));
      }
      
      public function getSound(key:*, clearMemory:Boolean = false) : Sound
      {
         return Sound(this._getContentAsType(key,Sound,clearMemory));
      }
      
      public function getBitmap(key:String, clearMemory:Boolean = false) : Bitmap
      {
         return Bitmap(this._getContentAsType(key,Bitmap,clearMemory));
      }
      
      public function getDisplayObjectLoader(key:String, clearMemory:Boolean = false) : Loader
      {
         var item:ImageItem;
         var res:Loader = null;
         if(!this._name)
         {
            throw new Error("[BulkLoader] Cannot use an instance that has been cleared from memory (.clear())");
         }
         item = this.get(key) as ImageItem;
         if(!item)
         {
            return null;
         }
         try
         {
            res = item.loader as Loader;
            if(!res)
            {
               throw new Error("bad cast");
            }
            if(clearMemory)
            {
               this.remove(key);
               if(!this._isPaused)
               {
                  this._loadNext();
               }
            }
            return res;
         }
         catch(e:Error)
         {
            log("Failed to get content with url: \'" + key + "\'as type: Loader",LOG_ERRORS);
         }
         return null;
      }
      
      public function getMovieClip(key:String, clearMemory:Boolean = false) : MovieClip
      {
         return MovieClip(this._getContentAsType(key,MovieClip,clearMemory));
      }
      
      public function getSprite(key:String, clearMemory:Boolean = false) : Sprite
      {
         return Sprite(this._getContentAsType(key,Sprite,clearMemory));
      }
      
      public function getAVM1Movie(key:String, clearMemory:Boolean = false) : AVM1Movie
      {
         return AVM1Movie(this._getContentAsType(key,AVM1Movie,clearMemory));
      }
      
      public function getNetStream(key:String, clearMemory:Boolean = false) : NetStream
      {
         return NetStream(this._getContentAsType(key,NetStream,clearMemory));
      }
      
      public function getNetStreamMetaData(key:String, clearMemory:Boolean = false) : Object
      {
         var netStream:NetStream = this.getNetStream(key,clearMemory);
         return Boolean(netStream) ? (this.get(key) as Object).metaData : null;
      }
      
      public function getBitmapData(key:*, clearMemory:Boolean = false) : BitmapData
      {
         try
         {
            return this.getBitmap(key,clearMemory).bitmapData;
         }
         catch(e:Error)
         {
            log("Failed to get bitmapData with url:",key,LOG_ERRORS);
         }
         return null;
      }
      
      public function getBinary(key:*, clearMemory:Boolean = false) : ByteArray
      {
         return ByteArray(this._getContentAsType(key,ByteArray,clearMemory));
      }
      
      public function getSerializedData(key:*, clearMemory:Boolean = false, encodingFunction:Function = null) : *
      {
         var raw:* = undefined;
         var parsed:* = undefined;
         try
         {
            raw = this._getContentAsType(key,Object,clearMemory);
            parsed = encodingFunction.apply(null,[raw]);
            return parsed;
         }
         catch(e:Error)
         {
            log("Failed to parse key:",key,"with encodingFunction:" + encodingFunction,LOG_ERRORS);
         }
         return null;
      }
      
      public function getHttpStatus(key:*) : int
      {
         var item:LoadingItem = this.get(key);
         if(Boolean(item))
         {
            return item.httpStatus;
         }
         return -1;
      }
      
      public function _isAllDoneP() : Boolean
      {
         return this._items.every(function(item:LoadingItem, ... rest):Boolean
         {
            return item._isLoaded;
         });
      }
      
      public function _onAllLoaded() : void
      {
         if(this._isFinished)
         {
            return;
         }
         var eComplete:BulkProgressEvent = new BulkProgressEvent(COMPLETE);
         eComplete.setInfo(this.bytesLoaded,this.bytesTotal,this.bytesTotalCurrent,this._itemsLoaded,this.itemsTotal,this.weightPercent);
         var eProgress:BulkProgressEvent = new BulkProgressEvent(PROGRESS);
         eProgress.setInfo(this.bytesLoaded,this.bytesTotal,this.bytesTotalCurrent,this._itemsLoaded,this.itemsTotal,this.weightPercent);
         this._isRunning = false;
         this._endTIme = getTimer();
         this.totalTime = BulkLoader.truncateNumber((this._endTIme - this._startTime) / 1000);
         this._updateStats();
         this._connections = {};
         this.getStats();
         this._isFinished = true;
         this.log("Finished all",LOG_INFO);
         dispatchEvent(eProgress);
         dispatchEvent(eComplete);
      }
      
      public function getStats() : String
      {
         var itemsInfo:Array;
         var statsString:String;
         var stats:Array = [];
         stats.push("\n************************************");
         stats.push("All items loaded(" + this.itemsTotal + ")");
         stats.push("Total time(s):       " + this.totalTime);
         stats.push("Average latency(s):  " + truncateNumber(this.avgLatency));
         stats.push("Average speed(kb/s): " + truncateNumber(this.speedAvg));
         stats.push("Median speed(kb/s):  " + truncateNumber(this._speedTotal));
         stats.push("KiloBytes total:     " + truncateNumber(this.bytesTotal / 1024));
         itemsInfo = this._items.map(function(item:LoadingItem, ... rest):String
         {
            return "\t" + item.getStats();
         });
         stats.push(itemsInfo.join("\n"));
         stats.push("************************************");
         statsString = stats.join("\n");
         this.log(statsString,LOG_VERBOSE);
         return statsString;
      }
      
      public function log(... msg) : void
      {
         var messageLevel:int = isNaN(msg[msg.length - 1]) ? 3 : int(msg.pop());
         if(messageLevel >= this.logLevel)
         {
            this._logFunction("[BulkLoader] " + msg.join(" "));
         }
      }
      
      public function get(key:*) : LoadingItem
      {
         var item:LoadingItem = null;
         if(!key)
         {
            return null;
         }
         if(key is LoadingItem)
         {
            return key;
         }
         for each(item in this._items)
         {
            if(item._id == key || item._parsedURL.rawString == key || item.url == key || key is URLRequest && item.url.url == key.url)
            {
               return item;
            }
         }
         return null;
      }
      
      public function remove(key:*, internalCall:Boolean = false) : Boolean
      {
         var item:LoadingItem = null;
         var allDone:Boolean = false;
         try
         {
            item = this.get(key);
            if(!item)
            {
               return false;
            }
            this._removeFromItems(item);
            this._removeFromConnections(item);
            item.destroy();
            delete this._contents[item.url.url];
            if(internalCall)
            {
               return true;
            }
            item = null;
            this._onProgress();
            allDone = this._isAllDoneP();
            if(allDone)
            {
               this._onAllLoaded();
            }
            return true;
         }
         catch(e:Error)
         {
            log("Error while removing item from key:" + key,e.getStackTrace(),LOG_ERRORS);
         }
         return false;
      }
      
      public function removeAll() : void
      {
         var item:LoadingItem = null;
         for each(item in this._items.slice())
         {
            this.remove(item,true);
         }
         this._items = [];
         this._connections = {};
         this._contents = new Dictionary(true);
         this._percentLoaded = this._weightPercent = this._loadedRatio = 0;
      }
      
      public function clear() : void
      {
         this.removeAll();
         delete _allLoaders[this.name];
         this._name = null;
      }
      
      public function removePausedItems() : Boolean
      {
         var stoppedLoads:Array = this._items.filter(function(item:LoadingItem, ... rest):Boolean
         {
            return item.status == LoadingItem.STATUS_STOPPED;
         });
         stoppedLoads.forEach(function(item:LoadingItem, ... rest):void
         {
            remove(item);
         });
         this._loadNext();
         return stoppedLoads.length > 0;
      }
      
      public function removeFailedItems() : int
      {
         var numCleared:int = 0;
         var badItems:Array = this._items.filter(function(item:LoadingItem, ... rest):Boolean
         {
            return item.status == LoadingItem.STATUS_ERROR;
         });
         numCleared = int(badItems.length);
         badItems.forEach(function(item:LoadingItem, ... rest):void
         {
            remove(item);
         });
         this._loadNext();
         return numCleared;
      }
      
      public function getFailedItems() : Array
      {
         return this._items.filter(function(item:LoadingItem, ... rest):Boolean
         {
            return item.status == LoadingItem.STATUS_ERROR;
         });
      }
      
      public function pause(key:*, loadsNext:Boolean = false) : Boolean
      {
         var item:LoadingItem = this.get(key);
         if(!item)
         {
            return false;
         }
         if(item.status != LoadingItem.STATUS_FINISHED)
         {
            item.stop();
         }
         this.log("STOPPED ITEM:",item,LOG_INFO);
         var result:Boolean = this._removeFromConnections(item);
         if(loadsNext)
         {
            this._loadNext();
         }
         return result;
      }
      
      public function pauseAll() : void
      {
         var item:LoadingItem = null;
         for each(item in this._items)
         {
            this.pause(item);
         }
         this._isRunning = false;
         this._isPaused = true;
         this.log("Stopping all items",LOG_INFO);
      }
      
      public function resume(key:*) : Boolean
      {
         var item:LoadingItem = key is LoadingItem ? key : this.get(key);
         this._isPaused = false;
         if(Boolean(item) && item.status == LoadingItem.STATUS_STOPPED)
         {
            item.status = null;
            this._loadNext();
            return true;
         }
         return false;
      }
      
      public function resumeAll() : Boolean
      {
         var affected:Boolean;
         this.log("Resuming all items",LOG_VERBOSE);
         affected = false;
         this._items.forEach(function(item:LoadingItem, ... rest):void
         {
            if(item.status == LoadingItem.STATUS_STOPPED)
            {
               resume(item);
               affected = true;
            }
         });
         this._loadNext();
         return affected;
      }
      
      override public function toString() : String
      {
         return "[BulkLoader] name:" + this.name + ", itemsTotal: " + this.itemsTotal + ", itemsLoaded: " + this._itemsLoaded;
      }
      
      public function _swallowError(e:Event) : void
      {
      }
   }
}

