package wovyrogor
{
   import daz.Feb;
   import daz.fyweci;
   import daz.gyhu;
   import daz.hah;
   import gafaduzuw.finajylom;
   
   public class boferupe
   {
      
      private static var hem:int;
      
      private static const hybuhy:Vector.<boferupe> = new Vector.<boferupe>();
      
      private static const jyz:finajylom = new finajylom();
      
      private static const noravog:int = 0;
      
      private static const jeq:int = 1;
      
      public const hikocos:Vector.<hah> = new Vector.<hah>();
      
      private var gov:Feb;
      
      private const recegalu:Vector.<gyhu> = new Vector.<gyhu>();
      
      private const kuto:Vector.<gyhu> = new Vector.<gyhu>();
      
      private var waj:Vector.<fyweci> = new Vector.<fyweci>();
      
      private var hefadab:Vector.<fyweci> = new Vector.<fyweci>();
      
      private const reqepoquq:Vector.<hah> = new Vector.<hah>();
      
      private const pyc:kepeb = new kepeb();
      
      public function boferupe()
      {
         super();
      }
      
      public static function leqame() : boferupe
      {
         if(hem == 0)
         {
            return new boferupe();
         }
         --hem;
         var _loc1_:boferupe = hybuhy[hem];
         hybuhy[hem] = null;
         return _loc1_;
      }
      
      public function haces() : void
      {
         this.gov = null;
         this.hikocos.length = 0;
         this.recegalu.length = 0;
         this.kuto.length = 0;
         this.waj.length = 0;
         this.hefadab.length = 0;
         this.reqepoquq.length = 0;
         this.pyc.napyr();
         hybuhy[hem++] = this;
      }
      
      public function cabor(param1:Feb) : void
      {
         var _loc5_:hah = null;
         var _loc6_:Vector.<gyhu> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         this.gov = param1;
         var _loc2_:int = int(this.hikocos.length);
         var _loc3_:Vector.<gyhu> = this.recegalu;
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
      
      public function tehyruma(param1:int) : void
      {
         this.hew(param1);
      }
      
      public function boro(param1:int) : void
      {
         this.wyvyjavin(param1);
      }
      
      private function hew(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = int(this.recegalu.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            this.razug(this.recegalu);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               this.muny(this.recegalu[_loc4_],noravog);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      private function wyvyjavin(param1:int) : void
      {
         var _loc2_:Vector.<fyweci> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:gyhu = null;
         this.wofuqyti(param1);
         this.pyc.cabor(this.hikocos);
         this.pyc.hus(this.reqepoquq,this.hefadab);
         if(this.reqepoquq.length > 0)
         {
            this.quguqig(this.reqepoquq,this.kuto);
            this.cohuz(param1,this.kuto);
            this.puwapysun(param1,this.kuto);
            while(this.pyc.bige())
            {
               _loc2_ = this.waj;
               this.waj = this.hefadab;
               this.hefadab = _loc2_;
               this.reqepoquq.length = 0;
               this.hefadab.length = 0;
               this.pyc.disubegi(this.waj,this.reqepoquq,this.hefadab);
               this.puw(this.waj,false);
               this.kuto.length = 0;
               this.quguqig(this.reqepoquq,this.kuto);
               _loc3_ = int(this.kuto.length);
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = this.kuto[_loc4_];
                  _loc5_.lyfugyt(this.gov.gyge,this.gov.dikaruly,this.gov.finybyle,this.gov.favobyfum);
                  _loc4_++;
               }
               this.cohuz(param1,this.kuto);
               this.puwapysun(param1,this.kuto);
               this.puw(this.waj,true);
            }
         }
         else
         {
            this.quguqig(this.hikocos,this.kuto);
            this.cohuz(param1,this.kuto);
            this.puwapysun(param1,this.kuto);
         }
      }
      
      private function wofuqyti(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = int(this.recegalu.length);
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            this.razug(this.recegalu);
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               this.muny(this.recegalu[_loc4_],jeq);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      private function quguqig(param1:Vector.<hah>, param2:Vector.<gyhu>) : void
      {
         var _loc5_:hah = null;
         var _loc6_:Vector.<gyhu> = null;
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
      
      private function razug(param1:Vector.<gyhu>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:gyhu = null;
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
      
      private function cohuz(param1:int, param2:Vector.<gyhu>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            this.razug(param2);
            _loc4_ = int(param2.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.muny(param2[_loc5_],jeq);
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      private function puwapysun(param1:int, param2:Vector.<gyhu>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            this.razug(param2);
            _loc4_ = int(param2.length);
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               this.kimaduki(param2[_loc5_]);
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      private function puw(param1:Vector.<fyweci>, param2:Boolean) : void
      {
         var _loc5_:fyweci = null;
         var _loc3_:int = int(param1.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc5_.midorofic = param2;
            _loc4_++;
         }
      }
      
      private function muny(param1:gyhu, param2:int) : void
      {
         var _loc8_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc3_:finajylom = param1.lefugefo;
         var _loc4_:fyweci = param1.ciqymaciv.pakewewo;
         var _loc5_:fyweci = param1.dizad.pakewewo;
         var _loc6_:finajylom = jyz;
         this.seposok(param1,_loc6_);
         var _loc7_:Number = _loc6_.kan * _loc3_.kan + _loc6_.zofydizug * _loc3_.zofydizug + _loc6_.qyririg * _loc3_.qyririg;
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
         var _loc9_:Number = Number(_loc6_.zyfav(param1.cabuhyjyp));
         var _loc10_:Number = Number(_loc6_.zyfav(param1.tufumiti));
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
            _loc4_.vymoget(param1.divute,param1.cabuhyjyp,_loc15_);
            _loc4_.vymoget(param1.divute,param1.tufumiti,_loc16_);
         }
         if(_loc5_.midorofic)
         {
            _loc5_.vymoget(param1.bamod,param1.cabuhyjyp,-_loc15_);
            _loc5_.vymoget(param1.bamod,param1.tufumiti,-_loc16_);
         }
         this.seposok(param1,_loc6_);
         _loc7_ = _loc6_.kan * _loc3_.kan + _loc6_.zofydizug * _loc3_.zofydizug + _loc6_.qyririg * _loc3_.qyririg;
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
            _loc4_.vymoget(param1.divute,param1.lefugefo,_loc19_);
         }
         if(_loc5_.midorofic)
         {
            _loc5_.vymoget(param1.bamod,param1.lefugefo,-_loc19_);
         }
      }
      
      private function seposok(param1:gyhu, param2:finajylom) : void
      {
         var _loc4_:finajylom = null;
         var _loc3_:finajylom = param1.ciqymaciv.pakewewo.kejo.fev;
         _loc4_ = param1.divute;
         var _loc5_:Number = _loc3_.zofydizug * _loc4_.qyririg - _loc3_.qyririg * _loc4_.zofydizug;
         var _loc6_:Number = _loc3_.qyririg * _loc4_.kan - _loc3_.kan * _loc4_.qyririg;
         var _loc7_:Number = _loc3_.kan * _loc4_.zofydizug - _loc3_.zofydizug * _loc4_.kan;
         _loc4_ = param1.ciqymaciv.pakewewo.kejo.zerus;
         param2.kan = _loc4_.kan + _loc5_;
         param2.zofydizug = _loc4_.zofydizug + _loc6_;
         param2.qyririg = _loc4_.qyririg + _loc7_;
         _loc3_ = param1.dizad.pakewewo.kejo.fev;
         _loc4_ = param1.bamod;
         _loc5_ = _loc3_.zofydizug * _loc4_.qyririg - _loc3_.qyririg * _loc4_.zofydizug;
         _loc6_ = _loc3_.qyririg * _loc4_.kan - _loc3_.kan * _loc4_.qyririg;
         _loc7_ = _loc3_.kan * _loc4_.zofydizug - _loc3_.zofydizug * _loc4_.kan;
         _loc4_ = param1.dizad.pakewewo.kejo.zerus;
         param2.kan -= _loc4_.kan + _loc5_;
         param2.zofydizug -= _loc4_.zofydizug + _loc6_;
         param2.qyririg -= _loc4_.qyririg + _loc7_;
      }
      
      private function kimaduki(param1:gyhu) : void
      {
         var _loc2_:finajylom = jyz;
         this.vifo(param1,_loc2_);
         var _loc3_:Number = _loc2_.kan * param1.lefugefo.kan + _loc2_.zofydizug * param1.lefugefo.zofydizug + _loc2_.qyririg * param1.lefugefo.qyririg;
         var _loc4_:Number = param1.dozusa - _loc3_;
         var _loc5_:Number = _loc4_ / param1.juqakilu;
         if(param1.ciqymaciv.pakewewo.midorofic)
         {
            param1.ciqymaciv.pakewewo.menema(param1.divute,param1.lefugefo,_loc5_);
         }
         if(param1.dizad.pakewewo.midorofic)
         {
            param1.dizad.pakewewo.menema(param1.bamod,param1.lefugefo,-_loc5_);
         }
      }
      
      private function vifo(param1:gyhu, param2:finajylom) : void
      {
         var _loc4_:finajylom = null;
         var _loc7_:Number = NaN;
         var _loc3_:finajylom = param1.ciqymaciv.pakewewo.bupu;
         _loc4_ = param1.divute;
         var _loc5_:Number = _loc3_.zofydizug * _loc4_.qyririg - _loc3_.qyririg * _loc4_.zofydizug;
         var _loc6_:Number = _loc3_.qyririg * _loc4_.kan - _loc3_.kan * _loc4_.qyririg;
         _loc7_ = _loc3_.kan * _loc4_.zofydizug - _loc3_.zofydizug * _loc4_.kan;
         _loc4_ = param1.ciqymaciv.pakewewo.jalekiwaf;
         param2.kan = _loc4_.kan + _loc5_;
         param2.zofydizug = _loc4_.zofydizug + _loc6_;
         param2.qyririg = _loc4_.qyririg + _loc7_;
         _loc3_ = param1.dizad.pakewewo.bupu;
         _loc4_ = param1.bamod;
         _loc5_ = _loc3_.zofydizug * _loc4_.qyririg - _loc3_.qyririg * _loc4_.zofydizug;
         _loc6_ = _loc3_.qyririg * _loc4_.kan - _loc3_.kan * _loc4_.qyririg;
         _loc7_ = _loc3_.kan * _loc4_.zofydizug - _loc3_.zofydizug * _loc4_.kan;
         _loc4_ = param1.dizad.pakewewo.jalekiwaf;
         param2.kan -= _loc4_.kan + _loc5_;
         param2.zofydizug -= _loc4_.zofydizug + _loc6_;
         param2.qyririg -= _loc4_.qyririg + _loc7_;
      }
   }
}

