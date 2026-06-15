package br.com.stimuli.loading.utils
{
   public class SmartURL
   {
      
      public var rawString:String;
      
      public var protocol:String;
      
      public var port:int;
      
      public var host:String;
      
      public var path:String;
      
      public var queryString:String;
      
      public var queryObject:Object;
      
      public var queryLength:int = 0;
      
      public var fileName:String;
      
      public function SmartURL(rawString:String)
      {
         var value:String = null;
         var varName:String = null;
         var pair:String = null;
         super();
         this.rawString = rawString;
         var URL_RE:RegExp = /((?P<protocol>[a-zA-Z]+: \/\/)   (?P<host>[^:\/]*) (:(?P<port>\d+))?)?  (?P<path>[^?]*)? ((?P<query>.*))? /x;
         var match:* = URL_RE.exec(rawString);
         if(Boolean(match))
         {
            this.protocol = Boolean(match.protocol) ? match.protocol : "http://";
            this.protocol = this.protocol.substr(0,this.protocol.indexOf("://"));
            this.host = match.host || null;
            this.port = Boolean(match.port) ? int(match.port) : 80;
            this.path = match.path;
            this.fileName = this.path.substring(this.path.lastIndexOf("/"),this.path.lastIndexOf("."));
            this.queryString = match.query;
            if(Boolean(this.queryString))
            {
               this.queryObject = {};
               this.queryString = this.queryString.substr(1);
               for each(pair in this.queryString.split("&"))
               {
                  varName = pair.split("=")[0];
                  value = pair.split("=")[1];
                  this.queryObject[varName] = value;
                  ++this.queryLength;
               }
            }
         }
         else
         {
            trace("no match");
         }
      }
      
      public function toString(... rest) : String
      {
         if(rest.length > 0 && rest[0] == true)
         {
            return "[URL] rawString :" + this.rawString + ", protocol: " + this.protocol + ", port: " + this.port + ", host: " + this.host + ", path: " + this.path + ". queryLength: " + this.queryLength;
         }
         return this.rawString;
      }
   }
}

