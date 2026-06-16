package alternativa.physics.contactislands
{
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.Body;
   import alternativa.physics.ShapeContact;
   import alternativa.physics.BodyContact;
   import alternativa.math.Vector3;
   
   public class ContactIsland
   {
      
      private static var hem:int;
      
      private static const hybuhy:Vector.<ContactIsland> = new Vector.<ContactIsland>();
      
      private static const jyz:Vector3 = new Vector3();
      
      private static const noravog:int = 0;
      
      private static const jeq:int = 1;
      
      public const hikocos:Vector.<BodyContact> = new Vector.<BodyContact>();
      
      private var gov:PhysicsScene;
      
      private const recegalu:Vector.<ShapeContact> = new Vector.<ShapeContact>();
      
      private const kuto:Vector.<ShapeContact> = new Vector.<ShapeContact>();
      
      private var waj:Vector.<Body> = new Vector.<Body>();
      
      private var hefadab:Vector.<Body> = new Vector.<Body>();
      
      private const reqepoquq:Vector.<BodyContact> = new Vector.<BodyContact>();
      
      private const pyc:ContactLevels = new ContactLevels();
      
      public function ContactIsland()
      {
         super();
      }
      
      public static function create() : ContactIsland
      {
         if(hem == 0)
         {
            return new ContactIsland();
         }
         --hem;
         var _loc1_:ContactIsland = hybuhy[hem];
         hybuhy[hem] = null;
         return _loc1_;
      }
      
      public function dispose() : void
      {
         this.gov = null;
         this.hikocos.length = 0;
         this.recegalu.length = 0;
         this.kuto.length = 0;
         this.waj.length = 0;
         this.hefadab.length = 0;
         this.reqepoquq.length = 0;
         this.pyc.clear();
         hybuhy[hem++] = this;
      }
      
      public function init(param1:PhysicsScene) : void
      {
         var _loc5_:BodyContact = null;
         var _loc6_:Vector.<ShapeContact> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         this.gov = param1;
         var _loc2_:int = int(this.hikocos.length);
         var _loc3_:Vector.<ShapeContact> = this.recegalu;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this.hikocos[_loc4_];
            _loc6_ = _loc5_.pupicic;
            _loc7_ = int(_loc6_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc3_[_loc3_.length] = _loc6_[_loc8_];
               _loc8_++;
            }
            _loc4_++;
         }
      }
      
      public function collisionPhase(param1:int) : void
      {
         this.resolveCollisions(param1);
      }
      
      public function contactPhase(param1:int) : void
      {
         this.resolveContacts(param1);
      }
      
      private function resolveCollisions(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = int(this.recegalu.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            this.shuffleContacts(this.recegalu);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               this.resolveContact(this.recegalu[_loc4_],noravog);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      private function resolveContacts(param1:int) : void
      {
         var _loc2_:Vector.<Body> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ShapeContact = null;
         this.processContacts(param1);
         this.pyc.init(this.hikocos);
         this.pyc.getStaticLevel(this.reqepoquq,this.hefadab);
         if(this.reqepoquq.length > 0)
         {
            this.getShapeContacts(this.reqepoquq,this.kuto);
            this.resolveContactsForLevel(param1,this.kuto);
            this.calculatePseudoVelocities(param1,this.kuto);
            while(this.pyc.hasContacts())
            {
               _loc2_ = this.waj;
               this.waj = this.hefadab;
               this.hefadab = _loc2_;
               this.reqepoquq.length = 0;
               this.hefadab.length = 0;
               this.pyc.getNextLevel(this.waj,this.reqepoquq,this.hefadab);
               this.setBodiesMobility(this.waj,false);
               this.kuto.length = 0;
               this.getShapeContacts(this.reqepoquq,this.kuto);
               _loc3_ = int(this.kuto.length);
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = this.kuto[_loc4_];
                  _loc5_.calcualteDynamicFrameData(this.gov.gyge,this.gov.dikaruly,this.gov.finybyle,this.gov.favobyfum);
                  _loc4_++;
               }
               this.resolveContactsForLevel(param1,this.kuto);
               this.calculatePseudoVelocities(param1,this.kuto);
               this.setBodiesMobility(this.waj,true);
            }
         }
         else
         {
            this.getShapeContacts(this.hikocos,this.kuto);
            this.resolveContactsForLevel(param1,this.kuto);
            this.calculatePseudoVelocities(param1,this.kuto);
         }
      }
      
      private function processContacts(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = int(this.recegalu.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            this.shuffleContacts(this.recegalu);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               this.resolveContact(this.recegalu[_loc4_],jeq);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      private function getShapeContacts(param1:Vector.<BodyContact>, param2:Vector.<ShapeContact>) : void
      {
         var _loc5_:BodyContact = null;
         var _loc6_:Vector.<ShapeContact> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc5_.pupicic;
            _loc7_ = int(_loc6_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               param2[param2.length] = _loc6_[_loc8_];
               _loc8_++;
            }
            _loc4_++;
         }
      }
      
      private function shuffleContacts(param1:Vector.<ShapeContact>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:ShapeContact = null;
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 1;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc3_ * Math.random();
            _loc5_ = param1[_loc4_];
            param1[_loc4_] = param1[_loc3_];
            param1[_loc3_] = _loc5_;
            _loc3_++;
         }
      }
      
      private function resolveContactsForLevel(param1:int, param2:Vector.<ShapeContact>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            this.shuffleContacts(param2);
            _loc4_ = int(param2.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.resolveContact(param2[_loc5_],jeq);
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      private function calculatePseudoVelocities(param1:int, param2:Vector.<ShapeContact>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            this.shuffleContacts(param2);
            _loc4_ = int(param2.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.resolveContactPseudoVelocity(param2[_loc5_]);
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      private function setBodiesMobility(param1:Vector.<Body>, param2:Boolean) : void
      {
         var _loc5_:Body = null;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc5_.midorofic = param2;
            _loc4_++;
         }
      }
      
      private function resolveContact(param1:ShapeContact, param2:int) : void
      {
         var _loc8_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc3_:Vector3 = param1.lefugefo;
         var _loc4_:Body = param1.ciqymaciv.body;
         var _loc5_:Body = param1.dizad.body;
         var _loc6_:Vector3 = jyz;
         this.calculateRelativeVelocity(param1,_loc6_);
         var _loc7_:Number = _loc6_.x * _loc3_.x + _loc6_.y * _loc3_.y + _loc6_.z * _loc3_.z;
         if(param2 == jeq)
         {
            _loc8_ = 0;
            if(_loc7_ < 0)
            {
               param1.caduk = false;
            }
            else if(param1.caduk)
            {
               return;
            }
         }
         else
         {
            param1.caduk = true;
            _loc8_ = Number(param1.pisiryq);
         }
         var _loc9_:Number = Number(_loc6_.dot(param1.cabuhyjyp));
         var _loc10_:Number = Number(_loc6_.dot(param1.tufumiti));
         var _loc11_:Number = param1.desesu - _loc9_ / param1.cywy;
         var _loc12_:Number = param1.mejaj - _loc10_ / param1.kybifos;
         var _loc13_:Number = _loc11_ * _loc11_ + _loc12_ * _loc12_;
         var _loc14_:Number = param1.cyloviqu * param1.lasowicup;
         if(_loc13_ > _loc14_ * _loc14_)
         {
            _loc20_ = Math.sqrt(_loc13_);
            _loc11_ *= _loc14_ / _loc20_;
            _loc12_ *= _loc14_ / _loc20_;
         }
         var _loc15_:Number = _loc11_ - param1.desesu;
         var _loc16_:Number = _loc12_ - param1.mejaj;
         param1.desesu = _loc11_;
         param1.mejaj = _loc12_;
         if(_loc4_.midorofic)
         {
            _loc4_.applyWorldImpulseAtLocalPoint(param1.divute,param1.cabuhyjyp,_loc15_);
            _loc4_.applyWorldImpulseAtLocalPoint(param1.divute,param1.tufumiti,_loc16_);
         }
         if(_loc5_.midorofic)
         {
            _loc5_.applyWorldImpulseAtLocalPoint(param1.bamod,param1.cabuhyjyp,-_loc15_);
            _loc5_.applyWorldImpulseAtLocalPoint(param1.bamod,param1.tufumiti,-_loc16_);
         }
         this.calculateRelativeVelocity(param1,_loc6_);
         _loc7_ = _loc6_.x * _loc3_.x + _loc6_.y * _loc3_.y + _loc6_.z * _loc3_.z;
         var _loc17_:Number = _loc8_ - _loc7_;
         var _loc18_:Number = param1.lasowicup + _loc17_ / param1.juqakilu;
         if(_loc18_ < 0)
         {
            _loc18_ = 0;
         }
         var _loc19_:Number = _loc18_ - param1.lasowicup;
         param1.lasowicup = _loc18_;
         if(_loc4_.midorofic)
         {
            _loc4_.applyWorldImpulseAtLocalPoint(param1.divute,param1.lefugefo,_loc19_);
         }
         if(_loc5_.midorofic)
         {
            _loc5_.applyWorldImpulseAtLocalPoint(param1.bamod,param1.lefugefo,-_loc19_);
         }
      }
      
      private function calculateRelativeVelocity(param1:ShapeContact, param2:Vector3) : void
      {
         var _loc4_:Vector3 = null;
         var _loc3_:Vector3 = param1.ciqymaciv.body.kejo.fev;
         _loc4_ = param1.divute;
         var _loc5_:Number = _loc3_.y * _loc4_.z - _loc3_.z * _loc4_.y;
         var _loc6_:Number = _loc3_.z * _loc4_.x - _loc3_.x * _loc4_.z;
         var _loc7_:Number = _loc3_.x * _loc4_.y - _loc3_.y * _loc4_.x;
         _loc4_ = param1.ciqymaciv.body.kejo.zerus;
         param2.x = _loc4_.x + _loc5_;
         param2.y = _loc4_.y + _loc6_;
         param2.z = _loc4_.z + _loc7_;
         _loc3_ = param1.dizad.body.kejo.fev;
         _loc4_ = param1.bamod;
         _loc5_ = _loc3_.y * _loc4_.z - _loc3_.z * _loc4_.y;
         _loc6_ = _loc3_.z * _loc4_.x - _loc3_.x * _loc4_.z;
         _loc7_ = _loc3_.x * _loc4_.y - _loc3_.y * _loc4_.x;
         _loc4_ = param1.dizad.body.kejo.zerus;
         param2.x -= _loc4_.x + _loc5_;
         param2.y -= _loc4_.y + _loc6_;
         param2.z -= _loc4_.z + _loc7_;
      }
      
      private function resolveContactPseudoVelocity(param1:ShapeContact) : void
      {
         var _loc2_:Vector3 = jyz;
         this.calcPseudoSeparationVelocity(param1,_loc2_);
         var _loc3_:Number = _loc2_.x * param1.lefugefo.x + _loc2_.y * param1.lefugefo.y + _loc2_.z * param1.lefugefo.z;
         var _loc4_:Number = param1.dozusa - _loc3_;
         var _loc5_:Number = _loc4_ / param1.juqakilu;
         if(param1.ciqymaciv.body.midorofic)
         {
            param1.ciqymaciv.body.applyWorldPseudoImpulseAtLocalPoint(param1.divute,param1.lefugefo,_loc5_);
         }
         if(param1.dizad.body.midorofic)
         {
            param1.dizad.body.applyWorldPseudoImpulseAtLocalPoint(param1.bamod,param1.lefugefo,-_loc5_);
         }
      }
      
      private function calcPseudoSeparationVelocity(param1:ShapeContact, param2:Vector3) : void
      {
         var _loc4_:Vector3 = null;
         var _loc7_:Number = NaN;
         var _loc3_:Vector3 = param1.ciqymaciv.body.bupu;
         _loc4_ = param1.divute;
         var _loc5_:Number = _loc3_.y * _loc4_.z - _loc3_.z * _loc4_.y;
         var _loc6_:Number = _loc3_.z * _loc4_.x - _loc3_.x * _loc4_.z;
         _loc7_ = _loc3_.x * _loc4_.y - _loc3_.y * _loc4_.x;
         _loc4_ = param1.ciqymaciv.body.jalekiwaf;
         param2.x = _loc4_.x + _loc5_;
         param2.y = _loc4_.y + _loc6_;
         param2.z = _loc4_.z + _loc7_;
         _loc3_ = param1.dizad.body.bupu;
         _loc4_ = param1.bamod;
         _loc5_ = _loc3_.y * _loc4_.z - _loc3_.z * _loc4_.y;
         _loc6_ = _loc3_.z * _loc4_.x - _loc3_.x * _loc4_.z;
         _loc7_ = _loc3_.x * _loc4_.y - _loc3_.y * _loc4_.x;
         _loc4_ = param1.dizad.body.jalekiwaf;
         param2.x -= _loc4_.x + _loc5_;
         param2.y -= _loc4_.y + _loc6_;
         param2.z -= _loc4_.z + _loc7_;
      }
   }
}

