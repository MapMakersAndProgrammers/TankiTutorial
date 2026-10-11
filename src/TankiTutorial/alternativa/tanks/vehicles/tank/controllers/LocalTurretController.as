package alternativa.tanks.vehicles.tank.controllers
{
   import alternativa.utils.MathUtils;
   import flash.display.InteractiveObject;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.system.Capabilities;
   import flash.utils.Dictionary;
   import tutorial.GameData;
   
   public class LocalTurretController extends TurretController
   {
      
      private static const MOUSE_LOCK:String = "mouseLock";
      
      private static const FULL_SCREEN_INTERACTIVE_ACCEPTED:String = "fullScreenInteractiveAccepted";
      
      private static const RIGHT_MOUSE_DOWN:String = "rightMouseDown";
      
      private static const RIGHT_MOUSE_UP:String = "rightMouseUp";
      
      private static const MOVEMENT_X:String = "movementX";
      
      private static const FULL_SCREEN:String = "fullScreen";
      
      private static const MOUSE_SENSITIVITY:Number = 0.001;
      
      private var eventSource:InteractiveObject;
      
      private var controlState:int;
      
      private var handlers:Dictionary;
      
      private var keyMap:TurretControlKeyMap;
      
      private var targetDirection:Number = 0;
      
      private var mouseDirection:Number = 0;
      
      private var mouseMoved:Boolean = false;
      
      private var cyzogi:Boolean = false;
      
      private var active:Boolean = true;
      
      private var behu:Boolean = false;
      
      private var skipMouseMove:Boolean = false;
      
      private var mouseModeRequested:Boolean = false;
      
      public function LocalTurretController(param1:Number, param2:Number, eventSource:InteractiveObject)
      {
         super(param1,param2,false);
         this.eventSource = eventSource;
         this.setDefaultKeyMap();
         eventSource.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         eventSource.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
         if(GameData.mouseEnabled)
         {
            eventSource.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            eventSource.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            eventSource.addEventListener(FULL_SCREEN_INTERACTIVE_ACCEPTED,this.onFullScreen);
            eventSource.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
            eventSource.addEventListener(Event.ACTIVATE,this.onActivate);
            eventSource.addEventListener(Event.DEACTIVATE,this.onDeactivate);
            eventSource.addEventListener(Event.MOUSE_LEAVE,this.onMouseLeave);
            eventSource.addEventListener(RIGHT_MOUSE_DOWN,this.onRightMouseDown);
            eventSource.addEventListener(RIGHT_MOUSE_UP,this.onRightMouseUp);
            this.enableMouseMode();
         }
      }
      
      private function onRightMouseDown(e:Event) : void
      {
         GameData.qazul = true;
         this.controlState = 0;
         applyControlState(this.controlState);
      }
      
      private function onRightMouseUp(e:Event) : void
      {
         GameData.qazul = false;
      }
      
      private function onMouseLeave(e:Event) : void
      {
         if(this.isFullScreen())
         {
            this.active = false;
         }
      }
      
      private function onDeactivate(e:Event) : void
      {
         this.active = false;
      }
      
      private function onActivate(e:Event) : void
      {
         if(!this.active)
         {
            this.behu = true;
            if(GameData.kumiteva)
            {
               this.enableMouseMode();
            }
         }
      }
      
      private function onMouseMove(mouseEvent:MouseEvent) : void
      {
         if(this.skipMouseMove)
         {
            this.skipMouseMove = false;
            return;
         }
         if(GameData.kumiteva && isNotLocked())
         {
            this.mouseDirection -= mouseEvent[MOVEMENT_X] * MOUSE_SENSITIVITY;
            this.mouseDirection = MathUtils.clampAngle(this.mouseDirection);
            this.mouseMoved = true;
         }
      }
      
      private function onMouseDown(mouseEvent:MouseEvent) : void
      {
         if(!GameData.kumiteva && this.active)
         {
            if(!this.isFullScreen())
            {
               GameData.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
            else
            {
               this.enableMouseMode();
            }
            mouseEvent.stopImmediatePropagation();
         }
      }
      
      public function setDefaultKeyMap() : void
      {
         this.setKeyMap(TurretControlKeyMap.getDefaultKeyMap());
      }
      
      public function setKeyMap(param1:TurretControlKeyMap) : void
      {
         this.keyMap = param1;
         this.controlState = 0;
         applyControlState(0);
         this.handlers = new Dictionary();
         this.setHandlers(param1.leftKeys,this.onKeyLeft);
         this.setHandlers(param1.rightKeys,this.onKeyRight);
         this.setHandlers(param1.centerKeys,this.onKeyCenter);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.eventSource.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.eventSource.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
         this.eventSource.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.eventSource.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this.eventSource.removeEventListener(FULL_SCREEN_INTERACTIVE_ACCEPTED,this.onFullScreen);
         this.eventSource.removeEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
      }
      
      private function onFullScreen(fullScreenEvent:FullScreenEvent) : void
      {
         if(fullScreenEvent.fullScreen && (fullScreenEvent.type == FULL_SCREEN_INTERACTIVE_ACCEPTED || Capabilities.isDebugger && fullScreenEvent.type == FULL_SCREEN))
         {
            this.enableMouseMode();
         }
         else
         {
            this.disableMouseMode();
         }
      }
      
      private function enableMouseMode() : void
      {
         this.mouseModeRequested = true;
      }
      
      private function doEnableBouseMode() : *
      {
         if(GameData.mouseEnabled && !finished && this.isFullScreen())
         {
            GameData.stage[MOUSE_LOCK] = true;
            GameData.kumiteva = true;
            this.mouseMoved = false;
            this.mouseDirection = getDirection() + tankDirection;
            this.skipMouseMove = true;
            this.controlState = 0;
            applyControlState(this.controlState);
            GameData.stage.dispatchEvent(new ControlModeChangeEvent());
            this.mouseModeRequested = false;
         }
      }
      
      private function disableMouseMode() : void
      {
         if(GameData.mouseEnabled && this.isFullScreen())
         {
            GameData.stage[MOUSE_LOCK] = false;
         }
         GameData.kumiteva = false;
         this.controlState = 0;
         applyControlState(this.controlState);
         GameData.stage.dispatchEvent(new ControlModeChangeEvent());
      }
      
      private function onKey(keyboardEvent:KeyboardEvent) : void
      {
         var state:int = 0;
         var handler:Function = this.handlers[keyboardEvent.keyCode];
         if(handler != null)
         {
            if(GameData.kumiteva)
            {
               this.disableMouseMode();
            }
            state = handler(keyboardEvent.type == KeyboardEvent.KEY_DOWN);
            if(state != this.controlState)
            {
               this.controlState = MathUtils.changeBitValue(state,CENTER,false);
               applyControlState(state);
            }
         }
      }
      
      private function onKeyLeft(pressed:Boolean) : int
      {
         return MathUtils.changeBitValue(this.controlState,LEFT,pressed);
      }
      
      private function onKeyRight(pressed:Boolean) : int
      {
         return MathUtils.changeBitValue(this.controlState,RIGHT,pressed);
      }
      
      private function onKeyCenter(pressed:Boolean) : int
      {
         return MathUtils.changeBitValue(this.controlState,CENTER,pressed);
      }
      
      private function setHandlers(keyCodes:Vector.<uint>, handler:Function) : void
      {
         var keyCode:uint = 0;
         for each(keyCode in keyCodes)
         {
            this.handlers[keyCode] = handler;
         }
      }
      
      override public function rotate(dt:Number) : void
      {
         if(this.behu)
         {
            this.active = true;
            this.behu = false;
         }
         if(this.mouseModeRequested)
         {
            this.doEnableBouseMode();
         }
         if(GameData.kumiteva && !GameData.qazul)
         {
            this.targetDirection = this.mouseDirection - tankDirection;
            this.updateMouse(dt);
         }
         super.rotate(dt);
      }
      
      private function updateMouse(dt:Number) : void
      {
         var angle:Number = this.angleDiff(this.targetDirection,getDirection());
         var maxAngle:Number = getMaxTurnSpeed() * dt;
         if(Math.abs(angle) < maxAngle && !this.mouseMoved)
         {
            this.targetDirection = getDirection();
            this.controlState = 0;
         }
         else if(angle < 0)
         {
            this.controlState = MathUtils.changeBitValue(this.controlState,RIGHT,true);
            this.controlState = MathUtils.changeBitValue(this.controlState,LEFT,false);
         }
         else
         {
            this.controlState = MathUtils.changeBitValue(this.controlState,LEFT,true);
            this.controlState = MathUtils.changeBitValue(this.controlState,RIGHT,false);
         }
         this.mouseMoved = false;
         applyControlState(this.controlState);
      }
      
      private function angleDiff(a:Number, b:Number) : Number
      {
         return Math.atan2(Math.sin(a - b),Math.cos(a - b));
      }
      
      private function isFullScreen() : Boolean
      {
         return GameData.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE;
      }
      
      private function enableFullScreen() : void
      {
         GameData.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
      }
      
      override public function getCameraDirection() : Number
      {
         return this.mouseDirection - tankDirection;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.cyzogi = true;
      }
      
      override public function setTankDirection(value:Number) : void
      {
         super.setTankDirection(value);
         if(this.cyzogi)
         {
            this.mouseDirection = tankDirection;
            this.cyzogi = false;
         }
      }
      
      override public function finish() : void
      {
         super.finish();
         this.disableMouseMode();
         this.eventSource.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.eventSource.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
         if(GameData.mouseEnabled)
         {
            this.eventSource.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.eventSource.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.eventSource.removeEventListener(FULL_SCREEN_INTERACTIVE_ACCEPTED,this.onFullScreen);
            this.eventSource.removeEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
            this.eventSource.removeEventListener(Event.ACTIVATE,this.onActivate);
            this.eventSource.removeEventListener(Event.DEACTIVATE,this.onDeactivate);
            this.eventSource.removeEventListener(Event.MOUSE_LEAVE,this.onMouseLeave);
         }
      }
   }
}

