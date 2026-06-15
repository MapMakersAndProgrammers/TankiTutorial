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
      
      private static const cud:String = "mouseLock";
      
      private static const kygiwu:String = "fullScreenInteractiveAccepted";
      
      private static const hofyq:String = "rightMouseDown";
      
      private static const tebydutug:String = "rightMouseUp";
      
      private static const liqiliw:String = "movementX";
      
      private static const womefivy:String = "fullScreen";
      
      private static const votam:Number = 0.001;
      
      private var selijy:InteractiveObject;
      
      private var gofucuheg:int;
      
      private var ridima:Dictionary;
      
      private var wupeko:TurretControlKeyMap;
      
      private var jipuzy:Number = 0;
      
      private var qicucufov:Number = 0;
      
      private var raliw:Boolean = false;
      
      private var cyzogi:Boolean = false;
      
      private var zadawe:Boolean = true;
      
      private var behu:Boolean = false;
      
      private var kowywyq:Boolean = false;
      
      private var wezet:Boolean = false;
      
      public function LocalTurretController(param1:Number, param2:Number, param3:InteractiveObject)
      {
         super(param1,param2,false);
         this.selijy = param3;
         this.setDefaultKeyMap();
         param3.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         param3.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
         if(GameData.vucofena)
         {
            param3.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            param3.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            param3.addEventListener(kygiwu,this.onFullScreen);
            param3.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
            param3.addEventListener(Event.ACTIVATE,this.onActivate);
            param3.addEventListener(Event.DEACTIVATE,this.onDeactivate);
            param3.addEventListener(Event.MOUSE_LEAVE,this.onMouseLeave);
            param3.addEventListener(hofyq,this.onRightMouseDown);
            param3.addEventListener(tebydutug,this.onRightMouseUp);
            this.enableMouseMode();
         }
      }
      
      private function onRightMouseDown(param1:Event) : void
      {
         GameData.qazul = true;
         this.gofucuheg = 0;
         applyControlState(this.gofucuheg);
      }
      
      private function onRightMouseUp(param1:Event) : void
      {
         GameData.qazul = false;
      }
      
      private function onMouseLeave(param1:Event) : void
      {
         if(this.isFullScreen())
         {
            this.zadawe = false;
         }
      }
      
      private function onDeactivate(param1:Event) : void
      {
         this.zadawe = false;
      }
      
      private function onActivate(param1:Event) : void
      {
         if(!this.zadawe)
         {
            this.behu = true;
            if(GameData.kumiteva)
            {
               this.enableMouseMode();
            }
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         if(this.kowywyq)
         {
            this.kowywyq = false;
            return;
         }
         if(GameData.kumiteva && isNotLocked())
         {
            this.qicucufov -= param1[liqiliw] * votam;
            this.qicucufov = MathUtils.clampAngle(this.qicucufov);
            this.raliw = true;
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(!GameData.kumiteva && this.zadawe)
         {
            if(!this.isFullScreen())
            {
               GameData.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
            else
            {
               this.enableMouseMode();
            }
            param1.stopImmediatePropagation();
         }
      }
      
      public function setDefaultKeyMap() : void
      {
         this.setKeyMap(TurretControlKeyMap.getDefaultKeyMap());
      }
      
      public function setKeyMap(param1:TurretControlKeyMap) : void
      {
         this.wupeko = param1;
         this.gofucuheg = 0;
         applyControlState(0);
         this.ridima = new Dictionary();
         this.setHandlers(param1.hatu,this.onKeyLeft);
         this.setHandlers(param1.baric,this.onKeyRight);
         this.setHandlers(param1.konejohe,this.onKeyCenter);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.selijy.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.selijy.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
         this.selijy.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.selijy.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this.selijy.removeEventListener(kygiwu,this.onFullScreen);
         this.selijy.removeEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
      }
      
      private function onFullScreen(param1:FullScreenEvent) : void
      {
         if(param1.fullScreen && (param1.type == kygiwu || Capabilities.isDebugger && param1.type == womefivy))
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
         this.wezet = true;
      }
      
      private function doEnableBouseMode() : *
      {
         if(GameData.vucofena && !finished && this.isFullScreen())
         {
            GameData.stage[cud] = true;
            GameData.kumiteva = true;
            this.raliw = false;
            this.qicucufov = getDirection() + jygef;
            this.kowywyq = true;
            this.gofucuheg = 0;
            applyControlState(this.gofucuheg);
            GameData.stage.dispatchEvent(new ControlModeChangeEvent());
            this.wezet = false;
         }
      }
      
      private function disableMouseMode() : void
      {
         if(GameData.vucofena && this.isFullScreen())
         {
            GameData.stage[cud] = false;
         }
         GameData.kumiteva = false;
         this.gofucuheg = 0;
         applyControlState(this.gofucuheg);
         GameData.stage.dispatchEvent(new ControlModeChangeEvent());
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Function = this.ridima[param1.keyCode];
         if(_loc2_ != null)
         {
            if(GameData.kumiteva)
            {
               this.disableMouseMode();
            }
            _loc3_ = _loc2_(param1.type == KeyboardEvent.KEY_DOWN);
            if(_loc3_ != this.gofucuheg)
            {
               this.gofucuheg = MathUtils.changeBitValue(_loc3_,heravytu,false);
               applyControlState(_loc3_);
            }
         }
      }
      
      private function onKeyLeft(param1:Boolean) : int
      {
         return MathUtils.changeBitValue(this.gofucuheg,wogop,param1);
      }
      
      private function onKeyRight(param1:Boolean) : int
      {
         return MathUtils.changeBitValue(this.gofucuheg,dad,param1);
      }
      
      private function onKeyCenter(param1:Boolean) : int
      {
         return MathUtils.changeBitValue(this.gofucuheg,heravytu,param1);
      }
      
      private function setHandlers(param1:Vector.<uint>, param2:Function) : void
      {
         var _loc3_:uint = 0;
         for each(_loc3_ in param1)
         {
            this.ridima[_loc3_] = param2;
         }
      }
      
      override public function rotate(param1:Number) : void
      {
         if(this.behu)
         {
            this.zadawe = true;
            this.behu = false;
         }
         if(this.wezet)
         {
            this.doEnableBouseMode();
         }
         if(GameData.kumiteva && !GameData.qazul)
         {
            this.jipuzy = this.qicucufov - jygef;
            this.updateMouse(param1);
         }
         super.rotate(param1);
      }
      
      private function updateMouse(param1:Number) : void
      {
         var _loc2_:Number = this.angleDiff(this.jipuzy,getDirection());
         var _loc3_:Number = getMaxTurnSpeed() * param1;
         if(Math.abs(_loc2_) < _loc3_ && !this.raliw)
         {
            this.jipuzy = getDirection();
            this.gofucuheg = 0;
         }
         else if(_loc2_ < 0)
         {
            this.gofucuheg = MathUtils.changeBitValue(this.gofucuheg,dad,true);
            this.gofucuheg = MathUtils.changeBitValue(this.gofucuheg,wogop,false);
         }
         else
         {
            this.gofucuheg = MathUtils.changeBitValue(this.gofucuheg,wogop,true);
            this.gofucuheg = MathUtils.changeBitValue(this.gofucuheg,dad,false);
         }
         this.raliw = false;
         applyControlState(this.gofucuheg);
      }
      
      private function angleDiff(param1:Number, param2:Number) : Number
      {
         return Math.atan2(Math.sin(param1 - param2),Math.cos(param1 - param2));
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
         return this.qicucufov - jygef;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.cyzogi = true;
      }
      
      override public function setTankDirection(param1:Number) : void
      {
         super.setTankDirection(param1);
         if(this.cyzogi)
         {
            this.qicucufov = jygef;
            this.cyzogi = false;
         }
      }
      
      override public function finish() : void
      {
         super.finish();
         this.disableMouseMode();
         this.selijy.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.selijy.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
         if(GameData.vucofena)
         {
            this.selijy.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            this.selijy.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.selijy.removeEventListener(kygiwu,this.onFullScreen);
            this.selijy.removeEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
            this.selijy.removeEventListener(Event.ACTIVATE,this.onActivate);
            this.selijy.removeEventListener(Event.DEACTIVATE,this.onDeactivate);
            this.selijy.removeEventListener(Event.MOUSE_LEAVE,this.onMouseLeave);
         }
      }
   }
}

