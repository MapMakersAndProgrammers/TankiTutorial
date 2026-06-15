package tutorial.commons
{
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class TrackerService
   {
      
      private static var actions:Dictionary;
      
      private var commands:Vector.<TrackerCommand>;
      
      private var timer:Timer;
      
      private var gaAvailable:Boolean = false;
      
      private var ymAvailable:Boolean = false;
      
      private var debug:Boolean;
      
      public function TrackerService(param1:Boolean = false)
      {
         super();
         this.gaAvailable = ExternalInterface.available && Boolean(ExternalInterface.call("checkGALoaded"));
         this.ymAvailable = ExternalInterface.available && Boolean(ExternalInterface.call("checkYMLoaded"));
         this.debug = param1;
         if(this.isAnyTrackingServiceAvailable())
         {
            this.commands = new Vector.<TrackerCommand>();
            this.timer = new Timer(100);
            this.timer.addEventListener(TimerEvent.TIMER,this.timer_timerHandler);
            actions = new Dictionary();
         }
      }
      
      public function trackPageView(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.gaAvailable)
         {
            _loc2_ = getTimer() / 100;
            actions[param1] = _loc2_;
            this.commands.push(new TrackerCommand("GATrackPageView","/" + param1));
            this.timer.start();
         }
         if(this.debug)
         {
            Shared.clientLog.addLine("trackPageView(" + param1 + ")");
         }
      }
      
      public function trackEvent(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:int = 0;
         if(this.debug)
         {
            Shared.clientLog.addLine("trackEvent(" + param1 + ", " + param2 + ", " + param3 + ")");
         }
         if(this.isAnyTrackingServiceAvailable())
         {
            _loc4_ = getTimer() / 100;
            actions[param2] = _loc4_;
            if(this.gaAvailable)
            {
               this.commands.push(new TrackerCommand("GATrackEvent",param1,param2,param3));
            }
            if(this.ymAvailable)
            {
               this.commands.push(new TrackerCommand("YMReachGoal",param2));
            }
            this.timer.start();
         }
      }
      
      public function trackEventValue(param1:String, param2:String, param3:String, param4:Number) : void
      {
         var _loc5_:int = 0;
         if(this.gaAvailable)
         {
            _loc5_ = getTimer() / 100;
            actions[param2] = _loc5_;
            this.commands.push(new TrackerCommand("GATrackEvent",param1,param2,param4.toFixed(2)));
            this.timer.start();
         }
      }
      
      public function trackEventAfter(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:int = 0;
         if(this.gaAvailable)
         {
            _loc4_ = getTimer() / 100;
            if(actions[param3] != null)
            {
               this.trackEventValue(param1,param2,null,int((_loc4_ - actions[param3]) / 10));
            }
            else
            {
               this.trackEvent(param1,param2,param3 + " action not logged");
            }
         }
      }
      
      private function timer_timerHandler(param1:TimerEvent) : void
      {
         var _loc3_:TrackerCommand = null;
         var _loc4_:Boolean = false;
         if(this.commands.length > 0)
         {
            if(this.isAnyTrackingServiceAvailable())
            {
               _loc3_ = this.commands.shift();
               switch(_loc3_.arguments.length)
               {
                  case 4:
                     _loc4_ = ExternalInterface.call(_loc3_.command,_loc3_.arguments[0],_loc3_.arguments[1],_loc3_.arguments[2],_loc3_.arguments[3]);
                     break;
                  case 3:
                     _loc4_ = ExternalInterface.call(_loc3_.command,_loc3_.arguments[0],_loc3_.arguments[1],_loc3_.arguments[2]);
                     break;
                  default:
                     _loc4_ = ExternalInterface.call(_loc3_.command,_loc3_.arguments[0]);
               }
            }
         }
         else
         {
            this.timer.stop();
         }
      }
      
      private function isAnyTrackingServiceAvailable() : Boolean
      {
         return this.gaAvailable || this.ymAvailable;
      }
   }
}

class TrackerCommand
{
   
   private var _command:String;
   
   private var _arguments:Array;
   
   public function TrackerCommand(param1:String, ... rest)
   {
      super();
      this._command = param1;
      this._arguments = rest;
   }
   
   public function get command() : String
   {
      return this._command;
   }
   
   public function set command(param1:String) : void
   {
      this._command = param1;
   }
   
   public function get arguments() : Array
   {
      return this._arguments;
   }
   
   public function set arguments(param1:Array) : void
   {
      this._arguments = param1;
   }
}
