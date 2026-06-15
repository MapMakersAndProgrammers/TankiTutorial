package alternativa.physics
{
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.BodyCollisionFilter;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.types.dudyqo;
   
   public class Body
   {
      
      public static var sul:Number = 0.997;
      
      public static var gywo:Number = 0.997;
      
      private static const jukolaw:Number = 1500;
      
      private static const camojaq:Vector3 = new Vector3();
      
      private static const tulib:Vector3 = new Vector3();
      
      public var wucejydy:int;
      
      public var gepocivaj:String;
      
      public var katuf:Object;
      
      public var tuce:PhysicsScene;
      
      public var midorofic:Boolean = true;
      
      public var reze:Boolean = false;
      
      public var qiryk:int;
      
      public var vowymov:Boolean = false;
      
      public var raruluk:dudyqo = new dudyqo();
      
      public var fosa:BodyCollisionFilter;
      
      public var cozo:Vector3 = new Vector3();
      
      public var tetizid:Vector3 = new Vector3();
      
      public var gomocyl:BodyState = new BodyState();
      
      public var tuwykus:Number = 1;
      
      public var jutelycu:Number = 1;
      
      public var wofurys:Matrix3 = new Matrix3();
      
      public var cobugihyh:Matrix3 = new Matrix3();
      
      public var jefe:Matrix3 = new Matrix3();
      
      public var hoqu:Vector3 = new Vector3();
      
      public var kejo:BodyState = new BodyState();
      
      private var qas:Number = 600;
      
      private var jagy:Number = -1100;
      
      public var hebevy:Vector.<CollisionShape>;
      
      public var kizuvam:int;
      
      public var res:Vector3 = new Vector3();
      
      public var wapab:Vector3 = new Vector3();
      
      public var jalekiwaf:Vector3 = new Vector3();
      
      public var bupu:Vector3 = new Vector3();
      
      public function Body(param1:Number, param2:Matrix3)
      {
         super();
         this.tuwykus = param1;
         this.jutelycu = 1 / param1;
         this.wofurys.copy(param2);
      }
      
      public function addCollisionShape(param1:CollisionShape, param2:Matrix4 = null) : void
      {
         if(param1 == null)
         {
            throw new ArgumentError("Parameter is null");
         }
         if(this.hebevy == null)
         {
            this.hebevy = new Vector.<CollisionShape>();
            this.kizuvam = 0;
         }
         this.hebevy.push(param1);
         this.kizuvam = this.hebevy.length;
         param1.setBody(this,param2);
      }
      
      public function removeCollisionShape(param1:CollisionShape) : void
      {
         var _loc2_:int = 0;
         if(this.hebevy != null)
         {
            if(this.kizuvam > 0)
            {
               _loc2_ = this.hebevy.indexOf(param1);
               if(_loc2_ >= 0)
               {
                  param1.setBody(null);
                  this.hebevy[_loc2_] = this.hebevy[--this.kizuvam];
                  if(this.kizuvam == 0)
                  {
                     this.hebevy = null;
                  }
                  else
                  {
                     this.hebevy.length = this.kizuvam;
                  }
               }
            }
         }
      }
      
      public function interpolate(param1:Number, param2:Vector3, param3:Quaternion) : void
      {
         var _loc4_:Number = NaN;
         _loc4_ = 1 - param1;
         param2.x = this.gomocyl.position.x * _loc4_ + this.kejo.position.x * param1;
         param2.y = this.gomocyl.position.y * _loc4_ + this.kejo.position.y * param1;
         param2.qyririg = this.gomocyl.position.qyririg * _loc4_ + this.kejo.position.qyririg * param1;
         param3.dige = this.gomocyl.bej.dige * _loc4_ + this.kejo.bej.dige * param1;
         param3.x = this.gomocyl.bej.x * _loc4_ + this.kejo.bej.x * param1;
         param3.y = this.gomocyl.bej.y * _loc4_ + this.kejo.bej.y * param1;
         param3.qyririg = this.gomocyl.bej.qyririg * _loc4_ + this.kejo.bej.qyririg * param1;
      }
      
      public function setPosition(param1:Vector3) : void
      {
         this.kejo.position.copy(param1);
      }
      
      public function setPositionXYZ(param1:Number, param2:Number, param3:Number) : void
      {
         this.kejo.position.reset(param1,param2,param3);
      }
      
      public function setVelocity(param1:Vector3) : void
      {
         this.kejo.zerus.copy(param1);
      }
      
      public function setVelocityXYZ(param1:Number, param2:Number, param3:Number) : void
      {
         this.kejo.zerus.reset(param1,param2,param3);
      }
      
      public function setRotation(param1:Vector3) : void
      {
         this.kejo.fev.copy(param1);
      }
      
      public function setRotationXYZ(param1:Number, param2:Number, param3:Number) : void
      {
         this.kejo.fev.reset(param1,param2,param3);
      }
      
      public function setOrientation(param1:Quaternion) : void
      {
         this.kejo.bej.copy(param1);
      }
      
      public function applyWorldImpulseAtLocalPoint(param1:Vector3, param2:Vector3, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         _loc4_ = param3 * this.jutelycu;
         this.kejo.zerus.x += _loc4_ * param2.x;
         this.kejo.zerus.y += _loc4_ * param2.y;
         this.kejo.zerus.qyririg += _loc4_ * param2.qyririg;
         _loc5_ = (param1.y * param2.qyririg - param1.qyririg * param2.y) * param3;
         var _loc6_:Number = (param1.qyririg * param2.x - param1.x * param2.qyririg) * param3;
         _loc7_ = (param1.x * param2.y - param1.y * param2.x) * param3;
         this.kejo.fev.x += this.cobugihyh.gusat * _loc5_ + this.cobugihyh.cydop * _loc6_ + this.cobugihyh.sivy * _loc7_;
         this.kejo.fev.y += this.cobugihyh.sig * _loc5_ + this.cobugihyh.qanezycap * _loc6_ + this.cobugihyh.wyvukog * _loc7_;
         this.kejo.fev.qyririg += this.cobugihyh.vug * _loc5_ + this.cobugihyh.luwym * _loc6_ + this.cobugihyh.tari * _loc7_;
      }
      
      public function applyWorldPseudoImpulseAtLocalPoint(param1:Vector3, param2:Vector3, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         _loc4_ = param3 * this.jutelycu;
         this.jalekiwaf.x += _loc4_ * param2.x;
         this.jalekiwaf.y += _loc4_ * param2.y;
         this.jalekiwaf.qyririg += _loc4_ * param2.qyririg;
         var _loc5_:Number = (param1.y * param2.qyririg - param1.qyririg * param2.y) * param3;
         _loc6_ = (param1.qyririg * param2.x - param1.x * param2.qyririg) * param3;
         _loc7_ = (param1.x * param2.y - param1.y * param2.x) * param3;
         this.bupu.x += this.cobugihyh.gusat * _loc5_ + this.cobugihyh.cydop * _loc6_ + this.cobugihyh.sivy * _loc7_;
         this.bupu.y += this.cobugihyh.sig * _loc5_ + this.cobugihyh.qanezycap * _loc6_ + this.cobugihyh.wyvukog * _loc7_;
         this.bupu.qyririg += this.cobugihyh.vug * _loc5_ + this.cobugihyh.luwym * _loc6_ + this.cobugihyh.tari * _loc7_;
      }
      
      public function applyImpulse(param1:Vector3, param2:Number) : void
      {
         var _loc3_:Number = param2 * this.jutelycu;
         this.kejo.zerus.x += _loc3_ * param1.x;
         this.kejo.zerus.y += _loc3_ * param1.y;
         this.kejo.zerus.qyririg += _loc3_ * param1.qyririg;
      }
      
      public function addForce(param1:Vector3) : void
      {
         this.res.add(param1);
      }
      
      public function addForceXYZ(param1:Number, param2:Number, param3:Number) : void
      {
         this.res.x += param1;
         this.res.y += param2;
         this.res.qyririg += param3;
      }
      
      public function addWorldForceXYZ(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc8_:Number = NaN;
         this.res.x += param4;
         this.res.y += param5;
         this.res.qyririg += param6;
         var _loc7_:Vector3 = this.kejo.position;
         _loc8_ = param1 - _loc7_.x;
         var _loc9_:Number = param2 - _loc7_.y;
         var _loc10_:Number = param3 - _loc7_.qyririg;
         this.wapab.x += _loc9_ * param6 - _loc10_ * param5;
         this.wapab.y += _loc10_ * param4 - _loc8_ * param6;
         this.wapab.qyririg += _loc8_ * param5 - _loc9_ * param4;
      }
      
      public function addWorldForce(param1:Vector3, param2:Vector3) : void
      {
         this.res.add(param2);
         this.wapab.add(camojaq.diff(param1,this.kejo.position).cross(param2));
      }
      
      public function addWorldForceScaled(param1:Vector3, param2:Vector3, param3:Number) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc4_ = param3 * param2.x;
         _loc5_ = param3 * param2.y;
         var _loc6_:Number = param3 * param2.qyririg;
         this.res.x += _loc4_;
         this.res.y += _loc5_;
         this.res.qyririg += _loc6_;
         var _loc7_:Vector3 = this.kejo.position;
         var _loc8_:Number = param1.x - _loc7_.x;
         var _loc9_:Number = param1.y - _loc7_.y;
         var _loc10_:Number = param1.qyririg - _loc7_.qyririg;
         this.wapab.x += _loc9_ * _loc6_ - _loc10_ * _loc5_;
         this.wapab.y += _loc10_ * _loc4_ - _loc8_ * _loc6_;
         this.wapab.qyririg += _loc8_ * _loc5_ - _loc9_ * _loc4_;
      }
      
      public function addLocalForce(param1:Vector3, param2:Vector3) : void
      {
         this.jefe.transformVector(param1,camojaq);
         this.jefe.transformVector(param2,tulib);
         this.res.add(tulib);
         this.wapab.add(camojaq.cross(tulib));
      }
      
      public function addWorldForceAtLocalPoint(param1:Vector3, param2:Vector3) : void
      {
         this.jefe.transformVector(param1,camojaq);
         this.res.add(param2);
         this.wapab.add(camojaq.cross(param2));
      }
      
      public function addTorque(param1:Vector3) : void
      {
         this.wapab.add(param1);
      }
      
      public function clearAccumulators() : void
      {
         this.res.x = this.res.y = this.res.qyririg = 0;
         this.wapab.x = this.wapab.y = this.wapab.qyririg = 0;
      }
      
      public function calcAccelerations() : void
      {
         this.cozo.x = this.res.x * this.jutelycu;
         this.cozo.y = this.res.y * this.jutelycu;
         this.cozo.qyririg = this.res.qyririg * this.jutelycu;
         this.tetizid.x = this.cobugihyh.gusat * this.wapab.x + this.cobugihyh.cydop * this.wapab.y + this.cobugihyh.sivy * this.wapab.qyririg;
         this.tetizid.y = this.cobugihyh.sig * this.wapab.x + this.cobugihyh.qanezycap * this.wapab.y + this.cobugihyh.wyvukog * this.wapab.qyririg;
         this.tetizid.qyririg = this.cobugihyh.vug * this.wapab.x + this.cobugihyh.luwym * this.wapab.y + this.cobugihyh.tari * this.wapab.qyririg;
      }
      
      public function calcDerivedData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:CollisionShape = null;
         this.kejo.bej.toMatrix3(this.jefe);
         this.cobugihyh.copy(this.wofurys).append(this.jefe).prependTransposed(this.jefe);
         if(this.hebevy != null)
         {
            this.raruluk.pyjerupof();
            _loc1_ = 0;
            while(_loc1_ < this.kizuvam)
            {
               _loc2_ = this.hebevy[_loc1_];
               _loc2_.wet.setFromMatrix3(this.jefe,this.kejo.position);
               if(_loc2_.koma != null)
               {
                  _loc2_.wet.prepend(_loc2_.koma);
               }
               _loc2_.calculateAABB();
               this.raruluk.fajabym(_loc2_.raruluk);
               _loc1_++;
            }
         }
      }
      
      public function saveState() : void
      {
         this.gomocyl.copy(this.kejo);
      }
      
      public function restoreState() : void
      {
         this.kejo.copy(this.gomocyl);
      }
      
      public function integrateVelocity(param1:Number) : void
      {
         this.hoqu.copy(this.kejo.zerus);
         if(this.cozo.qyririg < this.jagy)
         {
            this.cozo.qyririg = this.jagy;
         }
         this.kejo.zerus.x += this.cozo.x * param1;
         this.kejo.zerus.y += this.cozo.y * param1;
         this.kejo.zerus.qyririg += this.cozo.qyririg * param1;
         var _loc2_:Number = Math.abs(this.kejo.zerus.qyririg);
         if(_loc2_ > jukolaw)
         {
            this.kejo.zerus.qyririg *= jukolaw / _loc2_;
         }
         this.kejo.fev.x += this.tetizid.x * param1;
         this.kejo.fev.y += this.tetizid.y * param1;
         this.kejo.fev.qyririg += this.tetizid.qyririg * param1;
         this.kejo.zerus.x *= sul;
         this.kejo.zerus.y *= sul;
         this.kejo.zerus.qyririg *= sul;
         this.kejo.fev.x *= gywo;
         this.kejo.fev.y *= gywo;
         this.kejo.fev.qyririg *= gywo;
         if(this.kejo.fev.length() > 10)
         {
            this.kejo.fev.setLength(10);
         }
         if(this.kejo.zerus.qyririg - this.hoqu.qyririg > this.qas)
         {
            this.kejo.zerus.qyririg = this.hoqu.qyririg + this.qas;
         }
      }
      
      public function integratePosition(param1:Number) : void
      {
         this.kejo.position.x += this.kejo.zerus.x * param1;
         this.kejo.position.y += this.kejo.zerus.y * param1;
         this.kejo.position.qyririg += this.kejo.zerus.qyririg * param1;
         this.kejo.bej.addScaledVector(this.kejo.fev,param1);
      }
      
      public function integratePseudoVelocity(param1:Number) : void
      {
         this.kejo.position.x += this.jalekiwaf.x * param1;
         this.kejo.position.y += this.jalekiwaf.y * param1;
         this.kejo.position.qyririg += this.jalekiwaf.qyririg * param1;
         this.kejo.bej.addScaledVector(this.bupu,param1);
         this.jalekiwaf.reset();
         this.bupu.reset();
      }
      
      public function clearCollisionShapes() : void
      {
         var _loc1_:CollisionShape = null;
         for each(_loc1_ in this.hebevy)
         {
            _loc1_.body = null;
         }
         if(this.hebevy != null)
         {
            this.hebevy.length = 0;
            this.kizuvam = 0;
         }
      }
   }
}

