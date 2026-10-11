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
      
      private static const camVSpeed:ConsoleVarFloat = new ConsoleVarFloat("cam_vspeed",0.7,0,10);
      
      private static const MOVEMENT_Y:String = "movementY";
      
      private static const navysofi:Number = 0.001;
      
      private static const giviwazyr:Number = 5 * Math.PI / 180;
      
      private static const upKeys:Vector.<uint> = Vector.<uint>([Keyboard.PAGE_UP,Keyboard.RIGHTBRACKET,Keyboard.Q]);
      
      private static const downKeys:Vector.<uint> = Vector.<uint>([Keyboard.PAGE_DOWN,Keyboard.LEFTBRACKET,Keyboard.E]);
      
      private static const COLLIDER_RADIUS:Number = 50;
      
      private static const bawen:Vector3 = new Vector3();
      
      private static const lilotes:Vector3 = new Vector3();
      
      private static const direction:Vector3 = new Vector3();
      
      private static const source:Vector3D = new Vector3D();
      
      private static const displacement:Vector3D = new Vector3D();
      
      private static const collisionPoint:Vector3D = new Vector3D();
      
      private static const collisionPlane:Vector3D = new Vector3D();
      
      private static const gizynuzelu:Matrix3 = new Matrix3();
      
      private static const axis:Vector3 = new Vector3();
      
      private static const rayDirection:Vector3 = new Vector3();
      
      public static var visonyh:Number = 10;
      
      public static var dygowodyc:Number = Math.PI / 180;
      
      public static var viwatih:Number = 10;
      
      private static const gidif:Number = 10 * Math.PI / 180;
      
      private static const nimogot:Number = 1;
      
      private static const rucuha:Number = 300;
      
      private static const gejahi:Vector3 = new Vector3();
      
      private static const lucykocah:Vector3 = new Vector3();
      
      private static const rayOrigin:Vector3 = new Vector3();
      
      private static const rejefylyh:Vector3 = new Vector3();
      
      private static const wele:Vector3 = new Vector3();
      
      private var alternateSettings:Boolean;
      
      public var nis:Boolean;
      
      public var angle:Number = 0;
      
      public var heightOffset:Number = 0;
      
      private var stage:Stage;
      
      private var qahe:Number = 0;
      
      private var locked:Boolean;
      
      private var upPressed:Boolean;
      
      private var downPressed:Boolean;
      
      private var active:Boolean;
      
      private var target:CameraTarget;
      
      private var position:Vector3 = new Vector3();
      
      private var rotation:Vector3 = new Vector3();
      
      private var targetPosition:Vector3 = new Vector3();
      
      private var targetDirection:Vector3 = new Vector3();
      
      private var linearSpeed:Number = 0;
      
      private var pitchSpeed:Number = 0;
      
      private var yawSpeed:Number = 0;
      
      private var kocu:int;
      
      private var cameraPositionData:CameraPositionData = new CameraPositionData();
      
      private var dycanaki:Number;
      
      private var cameraT:Number = 0;
      
      private var cameraPosition:Point = new Point();
      
      private var p0:Point;
      
      private var p1:Point;
      
      private var p2:Point;
      
      private var p3:Point;
      
      private var collider:EllipsoidCollider;
      
      private var collisionObject:Object3D;
      
      private var tasufuwa:int;
      
      private var vycy:Number;
      
      private var tazor:Number = 0;
      
      private var matrix:Matrix3 = new Matrix3();
      
      private var dodycoli:Number;
      
      public function FollowCameraController(stage:Stage, camera:GameCamera)
      {
         super(camera);
         if(stage == null)
         {
            throw new ArgumentError("Parameter stage cannot be null");
         }
         this.stage = stage;
         this.p0 = new Point(145,545);
         this.p1 = new Point(930,1395);
         this.p2 = new Point(2245,1565);
         this.p3 = new Point(3105,760);
         this.collider = new EllipsoidCollider(COLLIDER_RADIUS,COLLIDER_RADIUS,COLLIDER_RADIUS);
         this.initCameraComponents();
         this.setCameraT(0.2);
      }
      
      private static function vector3To3D(vector3:Vector3, vector3D:Vector3D) : void
      {
         vector3D.x = vector3.x;
         vector3D.y = vector3.y;
         vector3D.z = vector3.z;
      }
      
      private static function getLinearSpeed(distance:Number) : Number
      {
         return 5 * distance;
      }
      
      private static function getAngularSpeed(angle:Number, speed:Number) : Number
      {
         var _loc3_:Number = 3;
         if(angle < -dygowodyc)
         {
            return _loc3_ * (angle + dygowodyc);
         }
         if(angle > dygowodyc)
         {
            return _loc3_ * (angle - dygowodyc);
         }
         return speed;
      }
      
      private static function bezier(t:Number, p0:Number, p1:Number, p2:Number, p3:Number) : Number
      {
         var _loc6_:Number = 3 * (p1 - p0);
         var _loc7_:Number = 3 * p0 - 6 * p1 + 3 * p2;
         var _loc8_:Number = -p0 + 3 * p1 - 3 * p2 + p3;
         return p0 + t * _loc6_ + t * t * _loc7_ + t * t * t * _loc8_;
      }
      
      public function setCollisionParameters(collisionObject:Object3D) : void
      {
         this.collisionObject = collisionObject;
      }
      
      public function setDefaultSettings() : void
      {
         this.alternateSettings = false;
      }
      
      public function setAlternateSettings() : void
      {
         this.alternateSettings = true;
      }
      
      public function setTarget(target:CameraTarget) : void
      {
         this.target = target;
      }
      
      public function setTargetParams(targetPosition:Vector3, targetDirection:Vector3) : void
      {
         this.targetPosition.copy(targetPosition);
         this.targetDirection.copy(targetDirection);
         this.kocu = 0;
         this.getCameraPositionData(targetPosition,targetDirection,this.cameraPositionData);
         this.position.copy(this.cameraPositionData.position);
         this.rotation.x = this.getPitchAngle(this.cameraPositionData) - 0.5 * Math.PI;
         this.rotation.y = 0;
         this.rotation.z = Math.atan2(-targetDirection.x,targetDirection.y);
         this.setPosition(this.position);
         setOrientation(this.rotation);
      }
      
      public function initCameraComponents() : void
      {
         this.position.x = camera.x;
         this.position.y = camera.y;
         this.position.z = camera.z;
         this.rotation.x = camera.rotationX;
         this.rotation.y = camera.rotationY;
         this.rotation.z = camera.rotationZ;
      }
      
      public function activate() : void
      {
         if(!this.active)
         {
            this.active = true;
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
            this.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
            this.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.vycy = 0;
         }
      }
      
      public function deactivate() : void
      {
         if(this.active)
         {
            this.active = false;
            this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
            this.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
            this.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.upPressed = false;
            this.downPressed = false;
         }
      }
      
      private function onMouseMove(mouseEvent:MouseEvent) : void
      {
         var movementY:Number = NaN;
         if(mouseEvent.hasOwnProperty(MOVEMENT_Y))
         {
            movementY = Number(mouseEvent[MOVEMENT_Y]);
            this.vycy += movementY * navysofi;
            this.vycy = MathUtils.clamp(this.vycy,-1,1);
         }
      }
      
      private function onMouseWheel(mouseEvent:MouseEvent) : void
      {
         var _loc2_:Boolean = false;
         if(!this.locked)
         {
            _loc2_ = false;
            if(mouseEvent.delta > 0)
            {
               if(this.tasufuwa < 0)
               {
                  this.tasufuwa = 0;
               }
               _loc2_ = true;
            }
            if(mouseEvent.delta < 0)
            {
               if(this.tasufuwa > 0)
               {
                  this.tasufuwa = 0;
               }
               _loc2_ = true;
            }
            if(_loc2_)
            {
               this.tasufuwa = mouseEvent.delta * 2;
            }
         }
      }
      
      public function update(time:int, deltaTime:int) : void
      {
         if(this.target == null)
         {
            return;
         }
         var dt:Number = deltaTime * 0.001;
         if(dt > 0.1)
         {
            dt = 0.1;
         }
         this.updateCameraHeight(dt);
         if(!this.locked)
         {
            this.recalculateTargetData();
         }
         direction.x = this.targetDirection.x;
         direction.y = this.targetDirection.y;
         direction.z = this.targetDirection.z;
         this.matrix.fromAxisAngle(Vector3.zAxis,this.angle);
         direction.transform3(this.matrix);
         this.getCameraPositionData(this.targetPosition,direction,this.cameraPositionData);
         if(isNaN(this.cameraPositionData.position.x))
         {
            return;
         }
         wele.diff(this.cameraPositionData.position,this.position);
         var distance:Number = wele.length();
         if(distance > visonyh)
         {
            this.linearSpeed = getLinearSpeed(distance - visonyh);
         }
         var step:Number = this.linearSpeed * dt;
         if(step > distance)
         {
            step = distance;
         }
         wele.normalize().scale(step);
         var pitch:Number = this.getPitchAngle(this.cameraPositionData);
         var yaw:Number = Math.atan2(-direction.x,direction.y);
         var _loc8_:Number = MathUtils.clampAngle(this.rotation.x + 0.5 * Math.PI);
         var _loc9_:Number = MathUtils.clampAngle(this.rotation.z);
         var _loc10_:Number = MathUtils.clampAngleFast(pitch - _loc8_);
         this.pitchSpeed = getAngularSpeed(_loc10_,this.pitchSpeed);
         var _loc11_:Number = this.pitchSpeed * dt;
         if(_loc10_ > 0 && _loc11_ > _loc10_ || _loc10_ < 0 && _loc11_ < _loc10_)
         {
            _loc11_ = _loc10_;
         }
         var _loc12_:Number = MathUtils.clampAngleFast(yaw - _loc9_);
         this.yawSpeed = getAngularSpeed(_loc12_,this.yawSpeed);
         var _loc13_:Number = this.yawSpeed * dt;
         if(_loc12_ > 0 && _loc13_ > _loc12_ || _loc12_ < 0 && _loc13_ < _loc12_)
         {
            _loc13_ = _loc12_;
         }
         this.linearSpeed = MathUtils.snap(this.linearSpeed,0,viwatih);
         this.pitchSpeed = MathUtils.snap(this.pitchSpeed,0,viwatih);
         this.yawSpeed = MathUtils.snap(this.yawSpeed,0,viwatih);
         this.position.add(wele);
         this.rotation.x += _loc11_;
         this.rotation.z += _loc13_;
         gejahi.copy(this.position);
         lucykocah.copy(this.rotation);
         this.setPosition(gejahi);
         setOrientation(lucykocah);
      }
      
      override protected function setPosition(param1:Vector3) : void
      {
         super.setPosition(param1);
         camera.z += this.heightOffset;
      }
      
      public function setLocked(locked:Boolean) : void
      {
         this.locked = locked;
         this.tasufuwa = 0;
      }
      
      public function getCameraT() : Number
      {
         return this.cameraT;
      }
      
      public function setCameraT(t:Number) : void
      {
         var _loc2_:Number = MathUtils.clamp(this.cameraT + this.vycy * 0.1,0,1);
         this.cameraT = MathUtils.clamp(t,0,1);
         this.cameraPosition.x = bezier(_loc2_,this.p0.x,this.p1.x,this.p2.x,this.p3.x);
         this.cameraPosition.y = bezier(_loc2_,this.p0.y,this.p1.y,this.p2.y,this.p3.y);
         this.dycanaki = Math.atan2(this.cameraPosition.x,this.cameraPosition.y);
         this.qahe = this.cameraPosition.length;
         this.kocu = 0;
      }
      
      public function getCameraState(param1:Vector3, param2:Vector3, param3:Vector3, param4:Vector3) : void
      {
         this.getCameraPositionData(param1,param2,this.cameraPositionData);
         param4.x = this.getPitchAngle(this.cameraPositionData) - 0.5 * Math.PI;
         param4.z = Math.atan2(-param2.x,param2.y);
         param3.copy(this.cameraPositionData.position);
      }
      
      public function recalculateTargetData() : void
      {
         this.target.getCameraParams(this.targetPosition,this.targetDirection);
      }
      
      private function getCameraPositionData(param1:Vector3, param2:Vector3, result:CameraPositionData) : void
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
         result.widaqurag = 0;
         result.time = 1;
         rayOrigin.copy(param1);
         axis.x = rejefylyh.y;
         axis.y = -rejefylyh.x;
         rejefylyh.reverse();
         gizynuzelu.fromAxisAngle(axis,-_loc4_);
         gizynuzelu.transformVector(rejefylyh,rayDirection);
         this.getCollisionPoint(rayOrigin,rayDirection,this.qahe,bawen);
         var distance:Number = lilotes.copy(rayOrigin).subtract(bawen).length();
         result.time = distance / this.qahe;
         if(distance < rucuha)
         {
            rayOrigin.copy(bawen);
            _loc7_ = rucuha - distance;
            this.getCollisionPoint(rayOrigin,Vector3.zAxis,_loc7_,bawen);
         }
         result.position.copy(bawen);
      }
      
      private function getCollisionPoint(origin:Vector3, direction:Vector3, distance:Number, result:Vector3) : void
      {
         var _loc5_:Number = NaN;
         vector3To3D(origin,source);
         displacement.x = distance * direction.x;
         displacement.y = distance * direction.y;
         displacement.z = distance * direction.z;
         if(this.collider.getCollision(source,displacement,collisionPoint,collisionPlane,this.collisionObject))
         {
            _loc5_ = COLLIDER_RADIUS + 0.1;
            result.x = collisionPoint.x + _loc5_ * collisionPlane.x;
            result.y = collisionPoint.y + _loc5_ * collisionPlane.y;
            result.z = collisionPoint.z + _loc5_ * collisionPlane.z;
         }
         else
         {
            result.copy(origin).addScaled(distance,direction);
         }
      }
      
      private function onKey(keyboardEvent:KeyboardEvent) : void
      {
         if(downKeys.indexOf(keyboardEvent.keyCode) >= 0)
         {
            this.downPressed = keyboardEvent.type == KeyboardEvent.KEY_DOWN;
         }
         else if(upKeys.indexOf(keyboardEvent.keyCode) >= 0)
         {
            this.upPressed = keyboardEvent.type == KeyboardEvent.KEY_DOWN;
         }
      }
      
      private function updateCameraHeight(dt:Number) : void
      {
         var dir:int = 0;
         if(this.tasufuwa < 0)
         {
            this.upPressed = true;
            this.downPressed = false;
            ++this.tasufuwa;
            if(this.tasufuwa == 0)
            {
               this.upPressed = false;
            }
         }
         else if(this.tasufuwa > 0)
         {
            this.upPressed = false;
            this.downPressed = true;
            --this.tasufuwa;
            if(this.tasufuwa == 0)
            {
               this.downPressed = false;
            }
         }
         if(!this.nis && this.upPressed != this.downPressed)
         {
            dir = this.upPressed ? 1 : -1;
            this.tazor = this.getCameraT() + dir * camVSpeed.value * dt;
            this.setCameraT(this.tazor);
         }
         else
         {
            this.setCameraT(this.cameraT);
         }
      }
      
      private function getPitchAngle(param1:CameraPositionData) : Number
      {
         var _loc2_:Number = this.dycanaki - gidif;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         var _loc3_:Number = param1.time;
         if(_loc3_ >= 1 || _loc2_ < giviwazyr || !this.alternateSettings)
         {
            return param1.widaqurag - _loc2_;
         }
         var _loc4_:Number = this.cameraPosition.x;
         return param1.widaqurag - Math.atan2(_loc3_ * _loc4_,nimogot * _loc4_ * (1 / Math.tan(_loc2_) - (1 - _loc3_) / Math.tan(this.dycanaki)));
      }
   }
}

