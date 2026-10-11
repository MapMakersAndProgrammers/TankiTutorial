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
      
      public function TrackerService(debug:Boolean = false)
      {
         super();
         this.gaAvailable = ExternalInterface.available && Boolean(ExternalInterface.call("checkGALoaded"));
         this.ymAvailable = ExternalInterface.available && Boolean(ExternalInterface.call("checkYMLoaded"));
         this.debug = debug;
         if(this.isAnyTrackingServiceAvailable())
         {
            this.commands = new Vector.<TrackerCommand>();
            this.timer = new Timer(100);
            this.timer.addEventListener(TimerEvent.TIMER,this.timer_timerHandler);
            actions = new Dictionary();
         }
      }
      
      public function trackPageView(page:String) : void
      {
         var time:int = 0;
         if(this.gaAvailable)
         {
            time = getTimer() / 100;
            actions[page] = time;
            this.commands.push(new TrackerCommand("GATrackPageView","/" + page));
            this.timer.start();
         }
         if(this.debug)
         {
            Shared.clientLog.addLine("trackPageView(" + page + ")");
         }
      }
      
      public function trackEvent(category:String, action:String, label:String) : void
      {
         var time:int = 0;
         if(this.debug)
         {
            Shared.clientLog.addLine("trackEvent(" + category + ", " + action + ", " + label + ")");
         }
         if(this.isAnyTrackingServiceAvailable())
         {
            time = getTimer() / 100;
            actions[action] = time;
            if(this.gaAvailable)
            {
               this.commands.push(new TrackerCommand("GATrackEvent",category,action,label));
            }
            if(this.ymAvailable)
            {
               this.commands.push(new TrackerCommand("YMReachGoal",action));
            }
            this.timer.start();
         }
      }
      
      public function trackEventValue(category:String, action:String, label:String, value:Number) : void
      {
         var time:int = 0;
         if(this.gaAvailable)
         {
            time = getTimer() / 100;
            actions[action] = time;
            this.commands.push(new TrackerCommand("GATrackEvent",category,action,value.toFixed(2)));
            this.timer.start();
         }
      }
      
      public function trackEventAfter(category:String, action:String, previousAction:String) : void
      {
         var time:int = 0;
         if(this.gaAvailable)
         {
            time = getTimer() / 100;
            if(actions[previousAction] != null)
            {
               this.trackEventValue(category,action,null,int((time - actions[previousAction]) / 10));
            }
            else
            {
               this.trackEvent(category,action,previousAction + " action not logged");
            }
         }
      }
      
      private function timer_timerHandler(timerEvent:TimerEvent) : void
      {
         var command:TrackerCommand = null;
         var result:Boolean = false;
         if(this.commands.length > 0)
         {
            if(this.isAnyTrackingServiceAvailable())
            {
               command = this.commands.shift();
               switch(command.arguments.length)
               {
                  case 4:
                     result = ExternalInterface.call(command.command,command.arguments[0],command.arguments[1],command.arguments[2],command.arguments[3]);
                     break;
                  case 3:
                     result = ExternalInterface.call(command.command,command.arguments[0],command.arguments[1],command.arguments[2]);
                     break;
                  default:
                     result = ExternalInterface.call(command.command,command.arguments[0]);
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
   
   public function TrackerCommand(command:String, ... rest)
   {
      super();
      this._command = command;
      this._arguments = rest;
   }
   
   public function get command() : String
   {
      return this._command;
   }
   
   public function set command(value:String) : void
   {
      this._command = value;
   }
   
   public function get arguments() : Array
   {
      return this._arguments;
   }
   
   public function set arguments(value:Array) : void
   {
      this._arguments = value;
   }
}
