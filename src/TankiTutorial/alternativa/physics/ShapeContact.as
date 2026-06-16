package alternativa.physics
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionShape;
   
   public class ShapeContact
   {
      
      private static var hem:int;
      
      private static const hybuhy:Vector.<ShapeContact> = new Vector.<ShapeContact>();
      
      public var position:Vector3 = new Vector3();
      
      public var pefavo:Number;
      
      public var lefugefo:Vector3 = new Vector3();
      
      public var cabuhyjyp:Vector3 = new Vector3();
      
      public var tufumiti:Vector3 = new Vector3();
      
      public var pisiryq:Number;
      
      public var dozusa:Number;
      
      public var juqakilu:Number;
      
      public var cywy:Number;
      
      public var kybifos:Number;
      
      public var vud:Number;
      
      public var jis:Number;
      
      public var lyfolihu:Number;
      
      public var bafa:Number;
      
      public var kymi:Number;
      
      public var satubowin:Number;
      
      public var divute:Vector3 = new Vector3();
      
      public var bamod:Vector3 = new Vector3();
      
      public var lasowicup:Number;
      
      public var desesu:Number;
      
      public var mejaj:Number;
      
      public var caduk:Boolean;
      
      public var biwywo:Number;
      
      public var cyloviqu:Number;
      
      public var ciqymaciv:CollisionShape;
      
      public var dizad:CollisionShape;
      
      public function ShapeContact()
      {
         super();
      }
      
      public static function create() : ShapeContact
      {
         if(hem == 0)
         {
            return new ShapeContact();
         }
         --hem;
         var _loc1_:ShapeContact = hybuhy[hem];
         hybuhy[hem] = null;
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this.ciqymaciv = null;
         this.dizad = null;
         hybuhy[hem] = this;
         ++hem;
      }
      
      public function calculatePersistentFrameData() : void
      {
         var _loc5_:Vector3 = null;
         var _loc1_:Body = this.ciqymaciv.body;
         var _loc2_:Body = this.dizad.body;
         this.biwywo = this.ciqymaciv.material.biwywo;
         var _loc3_:Number = this.dizad.material.biwywo;
         if(_loc3_ < this.biwywo)
         {
            this.biwywo = _loc3_;
         }
         this.cyloviqu = this.ciqymaciv.material.cyloviqu;
         var _loc4_:Number = this.dizad.material.cyloviqu;
         if(_loc4_ < this.cyloviqu)
         {
            this.cyloviqu = _loc4_;
         }
         _loc5_ = this.ciqymaciv.body.kejo.position;
         this.divute.x = this.position.x - _loc5_.x;
         this.divute.y = this.position.y - _loc5_.y;
         this.divute.z = this.position.z - _loc5_.z;
         _loc5_ = this.dizad.body.kejo.position;
         this.bamod.x = this.position.x - _loc5_.x;
         this.bamod.y = this.position.y - _loc5_.y;
         this.bamod.z = this.position.z - _loc5_.z;
         if(Math.abs(this.lefugefo.x) < Math.abs(this.lefugefo.y))
         {
            this.cabuhyjyp.cross2(this.lefugefo,Vector3.giv).normalize();
         }
         else
         {
            this.cabuhyjyp.cross2(this.lefugefo,Vector3.pypymu).normalize();
         }
         this.tufumiti.cross2(this.lefugefo,this.cabuhyjyp);
         this.lasowicup = 0;
         this.desesu = 0;
         this.mejaj = 0;
         this.juqakilu = 0;
         this.cywy = 0;
         this.kybifos = 0;
         if(_loc1_.midorofic)
         {
            this.vud = this.calculateAngularInertiaTerm(this.lefugefo,this.divute,_loc1_.cobugihyh);
            this.lyfolihu = this.calculateAngularInertiaTerm(this.cabuhyjyp,this.divute,_loc1_.cobugihyh);
            this.bafa = this.calculateAngularInertiaTerm(this.tufumiti,this.divute,_loc1_.cobugihyh);
            this.juqakilu += _loc1_.jutelycu + this.vud;
            this.cywy += _loc1_.jutelycu + this.lyfolihu;
            this.kybifos += _loc1_.jutelycu + this.bafa;
         }
         if(_loc2_.midorofic)
         {
            this.jis = this.calculateAngularInertiaTerm(this.lefugefo,this.bamod,_loc2_.cobugihyh);
            this.kymi = this.calculateAngularInertiaTerm(this.cabuhyjyp,this.bamod,_loc2_.cobugihyh);
            this.satubowin = this.calculateAngularInertiaTerm(this.tufumiti,this.bamod,_loc2_.cobugihyh);
            this.juqakilu += _loc2_.jutelycu + this.jis;
            this.cywy += _loc2_.jutelycu + this.kymi;
            this.kybifos += _loc2_.jutelycu + this.satubowin;
         }
         this.pisiryq = this.getSeparationVelocity();
         if(this.pisiryq < 0)
         {
            this.pisiryq = -this.biwywo * this.pisiryq;
         }
      }
      
      private function calculateAngularInertiaTerm(param1:Vector3, param2:Vector3, param3:Matrix3) : Number
      {
         var _loc4_:Number = param2.y * param1.z - param2.z * param1.y;
         var _loc5_:Number = param2.z * param1.x - param2.x * param1.z;
         var _loc6_:Number = param2.x * param1.y - param2.y * param1.x;
         var _loc7_:Number = param3.gusat * _loc4_ + param3.cydop * _loc5_ + param3.sivy * _loc6_;
         var _loc8_:Number = param3.sig * _loc4_ + param3.qanezycap * _loc5_ + param3.wyvukog * _loc6_;
         var _loc9_:Number = param3.vug * _loc4_ + param3.luwym * _loc5_ + param3.tari * _loc6_;
         _loc4_ = _loc8_ * param2.z - _loc9_ * param2.y;
         _loc5_ = _loc9_ * param2.x - _loc7_ * param2.z;
         _loc6_ = _loc7_ * param2.y - _loc8_ * param2.x;
         return _loc4_ * param1.x + _loc5_ * param1.y + _loc6_ * param1.z;
      }
      
      public function getSeparationVelocity() : Number
      {
         var _loc1_:Vector3 = this.ciqymaciv.body.kejo.fev;
         var _loc2_:Number = _loc1_.y * this.divute.z - _loc1_.z * this.divute.y;
         var _loc3_:Number = _loc1_.z * this.divute.x - _loc1_.x * this.divute.z;
         var _loc4_:Number = _loc1_.x * this.divute.y - _loc1_.y * this.divute.x;
         var _loc5_:Vector3 = this.ciqymaciv.body.kejo.zerus;
         var _loc6_:Number = _loc5_.x + _loc2_;
         var _loc7_:Number = _loc5_.y + _loc3_;
         var _loc8_:Number = _loc5_.z + _loc4_;
         _loc1_ = this.dizad.body.kejo.fev;
         _loc2_ = _loc1_.y * this.bamod.z - _loc1_.z * this.bamod.y;
         _loc3_ = _loc1_.z * this.bamod.x - _loc1_.x * this.bamod.z;
         _loc4_ = _loc1_.x * this.bamod.y - _loc1_.y * this.bamod.x;
         _loc5_ = this.dizad.body.kejo.zerus;
         _loc6_ -= _loc5_.x + _loc2_;
         _loc7_ -= _loc5_.y + _loc3_;
         _loc8_ -= _loc5_.z + _loc4_;
         return _loc6_ * this.lefugefo.x + _loc7_ * this.lefugefo.y + _loc8_ * this.lefugefo.z;
      }
      
      public function calcualteDynamicFrameData(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc7_:Number = NaN;
         var _loc5_:Body = this.ciqymaciv.body;
         var _loc6_:Body = this.dizad.body;
         this.juqakilu = 0;
         this.cywy = 0;
         this.kybifos = 0;
         if(_loc5_.midorofic)
         {
            this.juqakilu += _loc5_.jutelycu + this.vud;
            this.cywy += _loc5_.jutelycu + this.lyfolihu;
            this.kybifos += _loc5_.jutelycu + this.bafa;
         }
         if(_loc6_.midorofic)
         {
            this.juqakilu += _loc6_.jutelycu + this.jis;
            this.cywy += _loc6_.jutelycu + this.kymi;
            this.kybifos += _loc6_.jutelycu + this.satubowin;
         }
         if(this.pefavo > param1)
         {
            _loc7_ = this.pefavo - param1;
            if(_loc7_ > param3)
            {
               _loc7_ = param3;
            }
            this.dozusa = param2 * _loc7_ / param4;
         }
         else
         {
            this.dozusa = 0;
         }
      }
   }
}

