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
      
      private static const vyvew:ConsoleVarFloat = new ConsoleVarFloat("cam_spd",1300,0,10000);
      
      private static const rafypiv:ConsoleVarFloat = new ConsoleVarFloat("cam_acc",4,0,1000000);
      
      private static const cumu:ConsoleVarFloat = new ConsoleVarFloat("cam_smooth",0.1,0.001,1);
      
      private static const jofohinar:ConsoleVarFloat = new ConsoleVarFloat("m_pitch",-0.006,-100,100);
      
      private static const gyvareve:ConsoleVarFloat = new ConsoleVarFloat("m_yaw",-0.006,-100,100);
      
      private static const cyjeruqa:int = 0;
      
      private static const vuhike:int = 1;
      
      private static const wogop:int = 2;
      
      private static const dad:int = 3;
      
      private static const desu:int = 4;
      
      private static const sulu:int = 5;
      
      private static const coc:int = 6;
      
      private static const giquju:int = 7;
      
      private var wupeko:Dictionary = new Dictionary();
      
      private var selijy:IEventDispatcher;
      
      private var butefu:GameCamera;
      
      public var zopuduwar:Boolean;
      
      private var ses:BitMask = new BitMask();
      
      private var byc:Number;
      
      private var jevezete:Number;
      
      private var sunopival:Number;
      
      private var qotok:Number;
      
      private var sema:Vector3 = new Vector3();
      
      private var ruda:Vector3 = new Vector3();
      
      private var position:Vector3 = new Vector3();
      
      private var poluwoh:Vector3 = new Vector3();
      
      public var vucofena:Boolean = true;
      
      public function SpectatorCameraController(param1:IEventDispatcher, param2:GameCamera)
      {
         super();
         this.selijy = param1;
         this.setCamera(param2);
         this.initKeyMap();
      }
      
      private function initKeyMap() : void
      {
         this.wupeko[Keyboard.W] = cyjeruqa;
         this.wupeko[Keyboard.S] = vuhike;
         this.wupeko[Keyboard.A] = wogop;
         this.wupeko[Keyboard.D] = dad;
         this.wupeko[Keyboard.Q] = sulu;
         this.wupeko[Keyboard.E] = desu;
         this.wupeko[Keyboard.SHIFT] = coc;
         this.wupeko[Keyboard.SPACE] = giquju;
      }
      
      public function setCamera(param1:GameCamera) : void
      {
         this.butefu = param1;
         this.position.x = param1.x;
         this.position.y = param1.y;
         this.position.z = param1.z;
         this.poluwoh.x = param1.rotationX;
         this.poluwoh.y = param1.rotationY;
         this.poluwoh.z = param1.rotationZ;
      }
      
      public function update(param1:int, param2:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.butefu != null)
         {
            _loc3_ = param2 / 1000;
            if(this.ses.getBitValue(giquju) > 0)
            {
               this.sema.x = this.getDirection(dad,wogop);
               this.sema.y = 0;
               this.sema.z = this.getDirection(cyjeruqa,vuhike);
               this.butefu.getGlobalVector(this.sema,this.ruda);
               this.ruda.z = 0;
               if(this.ruda.lengthSqr() > 0)
               {
                  this.ruda.normalize();
               }
               this.ruda.z = -this.getDirection(sulu,desu);
            }
            else
            {
               this.sema.x = this.getDirection(dad,wogop);
               this.sema.y = this.getDirection(sulu,desu);
               this.sema.z = this.getDirection(cyjeruqa,vuhike);
               this.butefu.getGlobalVector(this.sema,this.ruda);
            }
            if(this.ruda.lengthSqr() > 0)
            {
               this.ruda.normalize();
            }
            if(this.ses.getBitValue(coc) > 0)
            {
               this.ruda.scale(vyvew.duz * rafypiv.duz * _loc3_);
            }
            else
            {
               this.ruda.scale(vyvew.duz * _loc3_);
            }
            this.position.x += this.ruda.x;
            this.position.y += this.ruda.y;
            this.position.z += this.ruda.z;
            if(this.zopuduwar)
            {
               _loc4_ = this.vucofena ? 1 : 0;
               this.poluwoh.x = this.sunopival + _loc4_ * (GameData.stage.mouseY - this.jevezete) * jofohinar.duz;
               this.poluwoh.z = this.qotok + _loc4_ * (GameData.stage.mouseX - this.byc) * gyvareve.duz;
               if(this.poluwoh.x > 0)
               {
                  this.poluwoh.x = 0;
               }
               else if(this.poluwoh.x < -Math.PI)
               {
                  this.poluwoh.x = -Math.PI;
               }
            }
            this.butefu.x += (this.position.x - this.butefu.x) * cumu.duz;
            this.butefu.y += (this.position.y - this.butefu.y) * cumu.duz;
            this.butefu.z += (this.position.z - this.butefu.z) * cumu.duz;
            this.butefu.rotationX += (this.poluwoh.x - this.butefu.rotationX) * cumu.duz;
            this.butefu.rotationY += (this.poluwoh.y - this.butefu.rotationY) * cumu.duz;
            this.butefu.rotationZ += (this.poluwoh.z - this.butefu.rotationZ) * cumu.duz;
         }
      }
      
      private function getDirection(param1:int, param2:int) : int
      {
         return this.ses.getBitValue(param1) - this.ses.getBitValue(param2);
      }
      
      public function activate() : void
      {
         this.selijy.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.selijy.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.selijy.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      public function deactivate() : void
      {
         this.releaseMouse();
         this.selijy.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.selijy.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.selijy.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.zopuduwar = true;
         this.byc = param1.stageX;
         this.jevezete = param1.stageY;
         this.sunopival = this.butefu.rotationX;
         this.qotok = this.butefu.rotationZ;
         this.selijy.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(this.wupeko[param1.keyCode] != null)
         {
            this.ses.clearBit(this.wupeko[param1.keyCode]);
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(this.wupeko[param1.keyCode] != null)
         {
            this.ses.setBit(this.wupeko[param1.keyCode]);
         }
      }
      
      private function releaseMouse() : void
      {
         if(this.zopuduwar)
         {
            this.selijy.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            this.zopuduwar = false;
         }
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.releaseMouse();
      }
   }
}

