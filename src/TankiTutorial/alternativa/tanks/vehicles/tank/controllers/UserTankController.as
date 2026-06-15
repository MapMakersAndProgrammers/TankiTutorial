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
      
      private var ridima:Dictionary;
      
      public function UserTankController(param1:IEventDispatcher, param2:Tank)
      {
         super(param2);
         this.initKeyHandlers();
         param1.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         param1.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouse);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.onMouse);
         param1.addEventListener(ControlModeChangeEvent.somyvigir,this.onMouseModeChanged);
         param1.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreen);
      }
      
      private function onFullScreen(param1:FullScreenEvent) : void
      {
         setAction(0);
      }
      
      private function onMouseModeChanged(param1:ControlModeChangeEvent) : void
      {
         var _loc2_:int = this.onKeyFire(false);
         if(_loc2_ != ses)
         {
            setAction(_loc2_);
         }
      }
      
      private function onMouse(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(GameData.kumiteva && Boolean(Tank(citacir).turretController.isNotLocked()))
         {
            _loc2_ = this.onKeyFire(param1.type == MouseEvent.MOUSE_DOWN);
            if(_loc2_ != ses)
            {
               setAction(_loc2_);
            }
         }
      }
      
      private function initKeyHandlers() : void
      {
         this.ridima = new Dictionary();
         this.setHandlers(ChassisControlKeyMap.zutetegyv,this.onKeyForward);
         this.setHandlers(ChassisControlKeyMap.huwumuly,this.onKeyBack);
         this.setHandlers(ChassisControlKeyMap.hatu,this.onKeyLeft);
         this.setHandlers(ChassisControlKeyMap.baric,this.onKeyRight);
         this.setHandlers(ChassisControlKeyMap.bacifaq,this.onKeyFire);
      }
      
      override public function update(param1:int, param2:int, param3:Number) : void
      {
         if(!dalipaz)
         {
            ses = 0;
         }
         var _loc4_:Tank = citacir;
         if(_loc4_.kakow == null || !Tank(citacir).turretController.isNotLocked())
         {
            ses &= ~(1 << syfysu);
         }
         super.update(param1,param2,param3);
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Function = this.ridima[param1.keyCode];
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_(param1.type == KeyboardEvent.KEY_DOWN);
            if(_loc3_ != ses)
            {
               setAction(_loc3_);
            }
         }
      }
      
      private function onKeyForward(param1:Boolean) : int
      {
         return MathUtils.changeBitValue(ses,cyjeruqa,param1);
      }
      
      private function onKeyBack(param1:Boolean) : int
      {
         return MathUtils.changeBitValue(ses,pycyje,param1);
      }
      
      private function onKeyLeft(param1:Boolean) : int
      {
         return MathUtils.changeBitValue(ses,dudazodol,param1);
      }
      
      private function onKeyRight(param1:Boolean) : int
      {
         return MathUtils.changeBitValue(ses,qij,param1);
      }
      
      private function onKeyFire(param1:Boolean) : int
      {
         return MathUtils.changeBitValue(ses,syfysu,param1);
      }
      
      private function setHandlers(param1:Vector.<uint>, param2:Function) : void
      {
         var _loc3_:uint = 0;
         for each(_loc3_ in param1)
         {
            this.ridima[_loc3_] = param2;
         }
      }
   }
}

