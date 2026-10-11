package alternativa.tanks.vehicles.tank.controllers
{
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.utils.MathUtils;
   import flash.events.FullScreenEvent;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import tutorial.GameData;
   
   public class UserTankController extends CommonTankController
   {
      
      private var handlers:Dictionary;
      
      public function UserTankController(param1:IEventDispatcher, param2:Tank)
      {
         super(param2);
         this.initKeyHandlers();
         param1.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         param1.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouse);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.onMouse);
         param1.addEventListener(ControlModeChangeEvent.CONTROL_MODE_CHANGED,this.onMouseModeChanged);
         param1.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
      }
      
      private function onFullScreen(fullScreenEvent:FullScreenEvent) : void
      {
         setAction(0);
      }
      
      private function onMouseModeChanged(controlModeChangeEvent:ControlModeChangeEvent) : void
      {
         var state:int = this.onKeyFire(false);
         if(state != controlState)
         {
            setAction(state);
         }
      }
      
      private function onMouse(mouseEvent:MouseEvent) : void
      {
         var state:int = 0;
         if(GameData.kumiteva && Boolean(Tank(tank).turretController.isNotLocked()))
         {
            state = this.onKeyFire(mouseEvent.type == MouseEvent.MOUSE_DOWN);
            if(state != controlState)
            {
               setAction(state);
            }
         }
      }
      
      private function initKeyHandlers() : void
      {
         this.handlers = new Dictionary();
         this.setHandlers(ChassisControlKeyMap.forwardKeys,this.onKeyForward);
         this.setHandlers(ChassisControlKeyMap.backKeys,this.onKeyBack);
         this.setHandlers(ChassisControlKeyMap.leftKeys,this.onKeyLeft);
         this.setHandlers(ChassisControlKeyMap.rightKeys,this.onKeyRight);
         this.setHandlers(ChassisControlKeyMap.fireKeys,this.onKeyFire);
      }
      
      override public function update(time:int, deltaTime:int, param3:Number) : void
      {
         if(!_enabled)
         {
            controlState = 0;
         }
         var _loc4_:Tank = tank;
         if(_loc4_.userTitle == null || !Tank(tank).turretController.isNotLocked())
         {
            controlState &= ~(1 << FIRE);
         }
         super.update(time,deltaTime,param3);
      }
      
      private function onKey(keyboardEvent:KeyboardEvent) : void
      {
         var state:int = 0;
         var handler:Function = this.handlers[keyboardEvent.keyCode];
         if(handler != null)
         {
            state = handler(keyboardEvent.type == KeyboardEvent.KEY_DOWN);
            if(state != controlState)
            {
               setAction(state);
            }
         }
      }
      
      private function onKeyForward(pressed:Boolean) : int
      {
         return MathUtils.changeBitValue(controlState,FORWARD,pressed);
      }
      
      private function onKeyBack(pressed:Boolean) : int
      {
         return MathUtils.changeBitValue(controlState,BACKWARD,pressed);
      }
      
      private function onKeyLeft(pressed:Boolean) : int
      {
         return MathUtils.changeBitValue(controlState,LEFT,pressed);
      }
      
      private function onKeyRight(pressed:Boolean) : int
      {
         return MathUtils.changeBitValue(controlState,RIGHT,pressed);
      }
      
      private function onKeyFire(pressed:Boolean) : int
      {
         return MathUtils.changeBitValue(controlState,FIRE,pressed);
      }
      
      private function setHandlers(keyCodes:Vector.<uint>, handler:Function) : void
      {
         var keyCode:uint = 0;
         for each(keyCode in keyCodes)
         {
            this.handlers[keyCode] = handler;
         }
      }
   }
}

