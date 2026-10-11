package
{
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.CameraController;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.BitMask;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import tutorial.GameData;
   
   public class SpectatorCameraController implements CameraController
   {
      
      private static const camSpeed:ConsoleVarFloat = new ConsoleVarFloat("cam_spd",1300,0,10000);
      
      private static const camAcc:ConsoleVarFloat = new ConsoleVarFloat("cam_acc",4,0,1000000);
      
      private static const camSmooth:ConsoleVarFloat = new ConsoleVarFloat("cam_smooth",0.1,0.001,1);
      
      private static const mousePitch:ConsoleVarFloat = new ConsoleVarFloat("m_pitch",-0.006,-100,100);
      
      private static const mouseYaw:ConsoleVarFloat = new ConsoleVarFloat("m_yaw",-0.006,-100,100);
      
      private static const FORWARD:int = 0;
      
      private static const BACK:int = 1;
      
      private static const LEFT:int = 2;
      
      private static const RIGHT:int = 3;
      
      private static const desu:int = 4;
      
      private static const sulu:int = 5;
      
      private static const ACCELERATE:int = 6;
      
      private static const giquju:int = 7;
      
      private var keyMap:Dictionary = new Dictionary();
      
      private var eventDispatcher:IEventDispatcher;
      
      private var camera:GameCamera;
      
      public var mousePressed:Boolean;
      
      private var ses:BitMask = new BitMask();
      
      private var byc:Number;
      
      private var jevezete:Number;
      
      private var sunopival:Number;
      
      private var qotok:Number;
      
      private var sema:Vector3 = new Vector3();
      
      private var direction:Vector3 = new Vector3();
      
      private var position:Vector3 = new Vector3();
      
      private var rotation:Vector3 = new Vector3();
      
      public var mouseEnabled:Boolean = true;
      
      public function SpectatorCameraController(eventDispatcher:IEventDispatcher, camera:GameCamera)
      {
         super();
         this.eventDispatcher = eventDispatcher;
         this.setCamera(camera);
         this.initKeyMap();
      }
      
      private function initKeyMap() : void
      {
         this.keyMap[Keyboard.W] = FORWARD;
         this.keyMap[Keyboard.S] = BACK;
         this.keyMap[Keyboard.A] = LEFT;
         this.keyMap[Keyboard.D] = RIGHT;
         this.keyMap[Keyboard.Q] = sulu;
         this.keyMap[Keyboard.E] = desu;
         this.keyMap[Keyboard.SHIFT] = ACCELERATE;
         this.keyMap[Keyboard.SPACE] = giquju;
      }
      
      public function setCamera(camera:GameCamera) : void
      {
         this.camera = camera;
         this.position.x = camera.x;
         this.position.y = camera.y;
         this.position.z = camera.z;
         this.rotation.x = camera.rotationX;
         this.rotation.y = camera.rotationY;
         this.rotation.z = camera.rotationZ;
      }
      
      public function update(time:int, deltaTime:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.camera != null)
         {
            _loc3_ = deltaTime / 1000;
            if(this.ses.getBitValue(giquju) > 0)
            {
               this.sema.x = this.getDirection(RIGHT,LEFT);
               this.sema.y = 0;
               this.sema.z = this.getDirection(FORWARD,BACK);
               this.camera.getGlobalVector(this.sema,this.direction);
               this.direction.z = 0;
               if(this.direction.lengthSqr() > 0)
               {
                  this.direction.normalize();
               }
               this.direction.z = -this.getDirection(sulu,desu);
            }
            else
            {
               this.sema.x = this.getDirection(RIGHT,LEFT);
               this.sema.y = this.getDirection(sulu,desu);
               this.sema.z = this.getDirection(FORWARD,BACK);
               this.camera.getGlobalVector(this.sema,this.direction);
            }
            if(this.direction.lengthSqr() > 0)
            {
               this.direction.normalize();
            }
            if(this.ses.getBitValue(ACCELERATE) > 0)
            {
               this.direction.scale(camSpeed.value * camAcc.value * _loc3_);
            }
            else
            {
               this.direction.scale(camSpeed.value * _loc3_);
            }
            this.position.x += this.direction.x;
            this.position.y += this.direction.y;
            this.position.z += this.direction.z;
            if(this.mousePressed)
            {
               _loc4_ = this.mouseEnabled ? 1 : 0;
               this.rotation.x = this.sunopival + _loc4_ * (GameData.stage.mouseY - this.jevezete) * mousePitch.value;
               this.rotation.z = this.qotok + _loc4_ * (GameData.stage.mouseX - this.byc) * mouseYaw.value;
               if(this.rotation.x > 0)
               {
                  this.rotation.x = 0;
               }
               else if(this.rotation.x < -Math.PI)
               {
                  this.rotation.x = -Math.PI;
               }
            }
            this.camera.x += (this.position.x - this.camera.x) * camSmooth.value;
            this.camera.y += (this.position.y - this.camera.y) * camSmooth.value;
            this.camera.z += (this.position.z - this.camera.z) * camSmooth.value;
            this.camera.rotationX += (this.rotation.x - this.camera.rotationX) * camSmooth.value;
            this.camera.rotationY += (this.rotation.y - this.camera.rotationY) * camSmooth.value;
            this.camera.rotationZ += (this.rotation.z - this.camera.rotationZ) * camSmooth.value;
         }
      }
      
      private function getDirection(param1:int, param2:int) : int
      {
         return this.ses.getBitValue(param1) - this.ses.getBitValue(param2);
      }
      
      public function activate() : void
      {
         this.eventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.eventDispatcher.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.eventDispatcher.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      public function deactivate() : void
      {
         this.releaseMouse();
         this.eventDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.eventDispatcher.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.eventDispatcher.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onMouseDown(mouseEvent:MouseEvent) : void
      {
         this.mousePressed = true;
         this.byc = mouseEvent.stageX;
         this.jevezete = mouseEvent.stageY;
         this.sunopival = this.camera.rotationX;
         this.qotok = this.camera.rotationZ;
         this.eventDispatcher.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      private function onKeyUp(keyboardEvent:KeyboardEvent) : void
      {
         if(this.keyMap[keyboardEvent.keyCode] != null)
         {
            this.ses.clearBit(this.keyMap[keyboardEvent.keyCode]);
         }
      }
      
      private function onKeyDown(keyboardEvent:KeyboardEvent) : void
      {
         if(this.keyMap[keyboardEvent.keyCode] != null)
         {
            this.ses.setBit(this.keyMap[keyboardEvent.keyCode]);
         }
      }
      
      private function releaseMouse() : void
      {
         if(this.mousePressed)
         {
            this.eventDispatcher.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            this.mousePressed = false;
         }
      }
      
      private function onMouseUp(mouseEvent:MouseEvent) : void
      {
         this.releaseMouse();
      }
   }
}

