package
{
   import alternativa.engine3d.core.EllipsoidCollider;
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.CameraController;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.utils.MathUtils;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.ui.Keyboard;
   
   public class FollowCameraController extends CameraControllerBase implements CameraController
   {
      
      private static const supis:ConsoleVarFloat = new ConsoleVarFloat("cam_vspeed",0.7,0,10);
      
      private static const wigacyha:String = "movementY";
      
      private static const navysofi:Number = 0.001;
      
      private static const giviwazyr:Number = 5 * Math.PI / 180;
      
      private static const tubojur:Vector.<uint> = Vector.<uint>([Keyboard.PAGE_UP,Keyboard.RIGHTBRACKET,Keyboard.Q]);
      
      private static const rasat:Vector.<uint> = Vector.<uint>([Keyboard.PAGE_DOWN,Keyboard.LEFTBRACKET,Keyboard.E]);
      
      private static const jokorufu:Number = 50;
      
      private static const bawen:Vector3 = new Vector3();
      
      private static const lilotes:Vector3 = new Vector3();
      
      private static const bec:Vector3 = new Vector3();
      
      private static const nifo:Vector3D = new Vector3D();
      
      private static const loqi:Vector3D = new Vector3D();
      
      private static const vipo:Vector3D = new Vector3D();
      
      private static const gariv:Vector3D = new Vector3D();
      
      private static const gizynuzelu:Matrix3 = new Matrix3();
      
      private static const zekos:Vector3 = new Vector3();
      
      private static const janimamu:Vector3 = new Vector3();
      
      public static var visonyh:Number = 10;
      
      public static var dygowodyc:Number = Math.PI / 180;
      
      public static var viwatih:Number = 10;
      
      private static const gidif:Number = 10 * Math.PI / 180;
      
      private static const nimogot:Number = 1;
      
      private static const rucuha:Number = 300;
      
      private static const gejahi:Vector3 = new Vector3();
      
      private static const lucykocah:Vector3 = new Vector3();
      
      private static const hifoca:Vector3 = new Vector3();
      
      private static const rejefylyh:Vector3 = new Vector3();
      
      private static const wele:Vector3 = new Vector3();
      
      private var gesil:Boolean;
      
      public var nis:Boolean;
      
      public var qusejov:Number = 0;
      
      public var bifejizi:Number = 0;
      
      private var stage:Stage;
      
      private var qahe:Number = 0;
      
      private var zocike:Boolean;
      
      private var woze:Boolean;
      
      private var voneluba:Boolean;
      
      private var zadawe:Boolean;
      
      private var kes:CameraTarget;
      
      private var position:Vector3 = new Vector3();
      
      private var poluwoh:Vector3 = new Vector3();
      
      private var qepajuz:Vector3 = new Vector3();
      
      private var qevyc:Vector3 = new Vector3();
      
      private var nyqi:Number = 0;
      
      private var rapyqe:Number = 0;
      
      private var pyhykusik:Number = 0;
      
      private var kocu:int;
      
      private var pevan:CameraPositionData = new CameraPositionData();
      
      private var dycanaki:Number;
      
      private var gaqojo:Number = 0;
      
      private var wuzyrodu:Point = new Point();
      
      private var tabu:Point;
      
      private var fybug:Point;
      
      private var vibocyqi:Point;
      
      private var ref:Point;
      
      private var kubeku:EllipsoidCollider;
      
      private var sak:Object3D;
      
      private var tasufuwa:int;
      
      private var vycy:Number;
      
      private var tazor:Number = 0;
      
      private var run:Matrix3 = new Matrix3();
      
      private var dodycoli:Number;
      
      public function FollowCameraController(param1:Stage, param2:GameCamera)
      {
         super(param2);
         if(param1 == null)
         {
            throw new ArgumentError("Parameter stage cannot be null");
         }
         this.stage = param1;
         this.tabu = new Point(145,545);
         this.fybug = new Point(930,1395);
         this.vibocyqi = new Point(2245,1565);
         this.ref = new Point(3105,760);
         this.kubeku = new EllipsoidCollider(jokorufu,jokorufu,jokorufu);
         this.initCameraComponents();
         this.setCameraT(0.2);
      }
      
      private static function vector3To3D(param1:Vector3, param2:Vector3D) : void
      {
         param2.x = param1.x;
         param2.y = param1.y;
         param2.z = param1.z;
      }
      
      private static function getLinearSpeed(param1:Number) : Number
      {
         return 5 * param1;
      }
      
      private static function getAngularSpeed(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = 3;
         if(param1 < -dygowodyc)
         {
            return _loc3_ * (param1 + dygowodyc);
         }
         if(param1 > dygowodyc)
         {
            return _loc3_ * (param1 - dygowodyc);
         }
         return param2;
      }
      
      private static function bezier(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         var _loc6_:Number = 3 * (param3 - param2);
         var _loc7_:Number = 3 * param2 - 6 * param3 + 3 * param4;
         var _loc8_:Number = -param2 + 3 * param3 - 3 * param4 + param5;
         return param2 + param1 * _loc6_ + param1 * param1 * _loc7_ + param1 * param1 * param1 * _loc8_;
      }
      
      public function setCollisionParameters(param1:Object3D) : void
      {
         this.sak = param1;
      }
      
      public function setDefaultSettings() : void
      {
         this.gesil = false;
      }
      
      public function setAlternateSettings() : void
      {
         this.gesil = true;
      }
      
      public function setTarget(param1:CameraTarget) : void
      {
         this.kes = param1;
      }
      
      public function setTargetParams(param1:Vector3, param2:Vector3) : void
      {
         this.qepajuz.copy(param1);
         this.qevyc.copy(param2);
         this.kocu = 0;
         this.getCameraPositionData(param1,param2,this.pevan);
         this.position.copy(this.pevan.position);
         this.poluwoh.x = this.getPitchAngle(this.pevan) - 0.5 * Math.PI;
         this.poluwoh.y = 0;
         this.poluwoh.z = Math.atan2(-param2.x,param2.y);
         this.setPosition(this.position);
         setOrientation(this.poluwoh);
      }
      
      public function initCameraComponents() : void
      {
         this.position.x = butefu.x;
         this.position.y = butefu.y;
         this.position.z = butefu.z;
         this.poluwoh.x = butefu.rotationX;
         this.poluwoh.y = butefu.rotationY;
         this.poluwoh.z = butefu.rotationZ;
      }
      
      public function activate() : void
      {
         if(!this.zadawe)
         {
            this.zadawe = true;
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
            this.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
            this.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.vycy = 0;
         }
      }
      
      public function deactivate() : void
      {
         if(this.zadawe)
         {
            this.zadawe = false;
            this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
            this.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
            this.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.woze = false;
            this.voneluba = false;
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         if(param1.hasOwnProperty(wigacyha))
         {
            _loc2_ = Number(param1[wigacyha]);
            this.vycy += _loc2_ * navysofi;
            this.vycy = MathUtils.clamp(this.vycy,-1,1);
         }
      }
      
      private function onMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         if(!this.zocike)
         {
            _loc2_ = false;
            if(param1.delta > 0)
            {
               if(this.tasufuwa < 0)
               {
                  this.tasufuwa = 0;
               }
               _loc2_ = true;
            }
            if(param1.delta < 0)
            {
               if(this.tasufuwa > 0)
               {
                  this.tasufuwa = 0;
               }
               _loc2_ = true;
            }
            if(_loc2_)
            {
               this.tasufuwa = param1.delta * 2;
            }
         }
      }
      
      public function update(param1:int, param2:int) : void
      {
         if(this.kes == null)
         {
            return;
         }
         var _loc3_:Number = param2 * 0.001;
         if(_loc3_ > 0.1)
         {
            _loc3_ = 0.1;
         }
         this.updateCameraHeight(_loc3_);
         if(!this.zocike)
         {
            this.recalculateTargetData();
         }
         bec.x = this.qevyc.x;
         bec.y = this.qevyc.y;
         bec.z = this.qevyc.z;
         this.run.fromAxisAngle(Vector3.nesicuryn,this.qusejov);
         bec.transform3(this.run);
         this.getCameraPositionData(this.qepajuz,bec,this.pevan);
         if(isNaN(this.pevan.position.x))
         {
            return;
         }
         wele.diff(this.pevan.position,this.position);
         var _loc4_:Number = wele.length();
         if(_loc4_ > visonyh)
         {
            this.nyqi = getLinearSpeed(_loc4_ - visonyh);
         }
         var _loc5_:Number = this.nyqi * _loc3_;
         if(_loc5_ > _loc4_)
         {
            _loc5_ = _loc4_;
         }
         wele.normalize().scale(_loc5_);
         var _loc6_:Number = this.getPitchAngle(this.pevan);
         var _loc7_:Number = Math.atan2(-bec.x,bec.y);
         var _loc8_:Number = MathUtils.clampAngle(this.poluwoh.x + 0.5 * Math.PI);
         var _loc9_:Number = MathUtils.clampAngle(this.poluwoh.z);
         var _loc10_:Number = MathUtils.clampAngleFast(_loc6_ - _loc8_);
         this.rapyqe = getAngularSpeed(_loc10_,this.rapyqe);
         var _loc11_:Number = this.rapyqe * _loc3_;
         if(_loc10_ > 0 && _loc11_ > _loc10_ || _loc10_ < 0 && _loc11_ < _loc10_)
         {
            _loc11_ = _loc10_;
         }
         var _loc12_:Number = MathUtils.clampAngleFast(_loc7_ - _loc9_);
         this.pyhykusik = getAngularSpeed(_loc12_,this.pyhykusik);
         var _loc13_:Number = this.pyhykusik * _loc3_;
         if(_loc12_ > 0 && _loc13_ > _loc12_ || _loc12_ < 0 && _loc13_ < _loc12_)
         {
            _loc13_ = _loc12_;
         }
         this.nyqi = MathUtils.snap(this.nyqi,0,viwatih);
         this.rapyqe = MathUtils.snap(this.rapyqe,0,viwatih);
         this.pyhykusik = MathUtils.snap(this.pyhykusik,0,viwatih);
         this.position.add(wele);
         this.poluwoh.x += _loc11_;
         this.poluwoh.z += _loc13_;
         gejahi.copy(this.position);
         lucykocah.copy(this.poluwoh);
         this.setPosition(gejahi);
         setOrientation(lucykocah);
      }
      
      override protected function setPosition(param1:Vector3) : void
      {
         super.setPosition(param1);
         butefu.z += this.bifejizi;
      }
      
      public function setLocked(param1:Boolean) : void
      {
         this.zocike = param1;
         this.tasufuwa = 0;
      }
      
      public function getCameraT() : Number
      {
         return this.gaqojo;
      }
      
      public function setCameraT(param1:Number) : void
      {
         var _loc2_:Number = MathUtils.clamp(this.gaqojo + this.vycy * 0.1,0,1);
         this.gaqojo = MathUtils.clamp(param1,0,1);
         this.wuzyrodu.x = bezier(_loc2_,this.tabu.x,this.fybug.x,this.vibocyqi.x,this.ref.x);
         this.wuzyrodu.y = bezier(_loc2_,this.tabu.y,this.fybug.y,this.vibocyqi.y,this.ref.y);
         this.dycanaki = Math.atan2(this.wuzyrodu.x,this.wuzyrodu.y);
         this.qahe = this.wuzyrodu.length;
         this.kocu = 0;
      }
      
      public function getCameraState(param1:Vector3, param2:Vector3, param3:Vector3, param4:Vector3) : void
      {
         this.getCameraPositionData(param1,param2,this.pevan);
         param4.x = this.getPitchAngle(this.pevan) - 0.5 * Math.PI;
         param4.z = Math.atan2(-param2.x,param2.y);
         param3.copy(this.pevan.position);
      }
      
      public function recalculateTargetData() : void
      {
         this.kes.getCameraParams(this.qepajuz,this.qevyc);
      }
      
      private function getCameraPositionData(param1:Vector3, param2:Vector3, param3:CameraPositionData) : void
      {
         var _loc7_:Number = NaN;
         var _loc4_:Number = this.dycanaki;
         var _loc5_:Number = Math.sqrt(param2.x * param2.x + param2.y * param2.y);
         if(_loc5_ < 0.00001)
         {
            rejefylyh.x = 1;
            rejefylyh.y = 0;
         }
         else
         {
            rejefylyh.x = param2.x / _loc5_;
            rejefylyh.y = param2.y / _loc5_;
         }
         param3.widaqurag = 0;
         param3.jomuc = 1;
         hifoca.copy(param1);
         zekos.x = rejefylyh.y;
         zekos.y = -rejefylyh.x;
         rejefylyh.reverse();
         gizynuzelu.fromAxisAngle(zekos,-_loc4_);
         gizynuzelu.transformVector(rejefylyh,janimamu);
         this.getCollisionPoint(hifoca,janimamu,this.qahe,bawen);
         var _loc6_:Number = lilotes.copy(hifoca).subtract(bawen).length();
         param3.jomuc = _loc6_ / this.qahe;
         if(_loc6_ < rucuha)
         {
            hifoca.copy(bawen);
            _loc7_ = rucuha - _loc6_;
            this.getCollisionPoint(hifoca,Vector3.nesicuryn,_loc7_,bawen);
         }
         param3.position.copy(bawen);
      }
      
      private function getCollisionPoint(param1:Vector3, param2:Vector3, param3:Number, param4:Vector3) : void
      {
         var _loc5_:Number = NaN;
         vector3To3D(param1,nifo);
         loqi.x = param3 * param2.x;
         loqi.y = param3 * param2.y;
         loqi.z = param3 * param2.z;
         if(this.kubeku.getCollision(nifo,loqi,vipo,gariv,this.sak))
         {
            _loc5_ = jokorufu + 0.1;
            param4.x = vipo.x + _loc5_ * gariv.x;
            param4.y = vipo.y + _loc5_ * gariv.y;
            param4.z = vipo.z + _loc5_ * gariv.z;
         }
         else
         {
            param4.copy(param1).addScaled(param3,param2);
         }
      }
      
      private function onKey(param1:KeyboardEvent) : void
      {
         if(rasat.indexOf(param1.keyCode) >= 0)
         {
            this.voneluba = param1.type == KeyboardEvent.KEY_DOWN;
         }
         else if(tubojur.indexOf(param1.keyCode) >= 0)
         {
            this.woze = param1.type == KeyboardEvent.KEY_DOWN;
         }
      }
      
      private function updateCameraHeight(param1:Number) : void
      {
         var _loc2_:int = 0;
         if(this.tasufuwa < 0)
         {
            this.woze = true;
            this.voneluba = false;
            ++this.tasufuwa;
            if(this.tasufuwa == 0)
            {
               this.woze = false;
            }
         }
         else if(this.tasufuwa > 0)
         {
            this.woze = false;
            this.voneluba = true;
            --this.tasufuwa;
            if(this.tasufuwa == 0)
            {
               this.voneluba = false;
            }
         }
         if(!this.nis && this.woze != this.voneluba)
         {
            _loc2_ = this.woze ? 1 : -1;
            this.tazor = this.getCameraT() + _loc2_ * supis.duz * param1;
            this.setCameraT(this.tazor);
         }
         else
         {
            this.setCameraT(this.gaqojo);
         }
      }
      
      private function getPitchAngle(param1:CameraPositionData) : Number
      {
         var _loc2_:Number = this.dycanaki - gidif;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         var _loc3_:Number = param1.jomuc;
         if(_loc3_ >= 1 || _loc2_ < giviwazyr || !this.gesil)
         {
            return param1.widaqurag - _loc2_;
         }
         var _loc4_:Number = this.wuzyrodu.x;
         return param1.widaqurag - Math.atan2(_loc3_ * _loc4_,nimogot * _loc4_ * (1 / Math.tan(_loc2_) - (1 - _loc3_) / Math.tan(this.dycanaki)));
      }
   }
}

