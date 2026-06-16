package zimeko
{
   import daz.fyweci;
   import daz.gyhu;
   import daz.hah;
   import gafaduzuw.finajylom;
   import gafaduzuw.fode;
   import kihi.dudyqo;
   import kihi.qedozeze;
   import lagysyz.cil;
   import lagysyz.labeja;
   import lagysyz.rejolymu;
   import zicy.dovabaf;
   import zicy.faheter;
   import zicy.nekusupyg;
   import zicy.nocyquk;
   import zicy.tolavoka;
   import zicy.wagoc;
   
   public class mebiw implements nocyquk
   {
      
      private static const luculeqa:Number = 0.01;
      
      private const pusuc:Object = {};
      
      private const tet:qedozeze = new qedozeze();
      
      private const bilaw:pakokur = new pakokur();
      
      private const wawuse:finajylom = new finajylom();
      
      private const zidihyw:finajylom = new finajylom();
      
      private const mydip:qedozeze = new qedozeze();
      
      private const lukej:dudyqo = new dudyqo();
      
      private const pupicic:Vector.<gyhu> = new Vector.<gyhu>();
      
      private var nyseh:tolavoka = new tolavoka();
      
      private var hevarer:Number = 0.0001;
      
      private var cubajedid:Vector.<sagokibo> = new Vector.<sagokibo>();
      
      private var sity:Vector.<fyweci> = new Vector.<fyweci>();
      
      private var kobet:fyweci;
      
      public function mebiw()
      {
         super();
         var _loc1_:Number = 0.000001;
         this.bykad(dovabaf.jupod,dovabaf.jupod,new cil(_loc1_));
         this.bykad(dovabaf.jupod,dovabaf.hosomubeb,new labeja(_loc1_));
         this.bykad(dovabaf.jupod,dovabaf.miluvo,new rejolymu(_loc1_));
         this.jog();
      }
      
      private function bykad(param1:int, param2:int, param3:faheter) : void
      {
         this.pusuc[param1 | param2] = param3;
      }
      
      private function jog() : void
      {
         this.kobet = new fyweci(1,new fode());
         this.kobet.midorofic = false;
      }
      
      public function nonolit(param1:Vector.<dovabaf>, param2:dudyqo = null) : void
      {
         var _loc3_:dovabaf = null;
         for each(_loc3_ in param1)
         {
            _loc3_.body = this.kobet;
         }
         this.nyseh.hoc(param1,param2);
      }
      
      public function fusofe(param1:sagokibo) : void
      {
         this.cubajedid.push(param1);
      }
      
      public function rehef(param1:sagokibo) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = this.cubajedid.indexOf(param1);
         if(_loc2_ > -1)
         {
            _loc3_ = this.cubajedid.length - 1;
            this.cubajedid[_loc2_] = this.cubajedid[_loc3_];
            this.cubajedid.length = _loc3_;
         }
      }
      
      public function cul(param1:fyweci) : void
      {
         if(this.sity.indexOf(param1) < 0)
         {
            this.sity.push(param1);
         }
      }
      
      public function niryruv(param1:fyweci) : void
      {
         var _loc2_:int = this.sity.indexOf(param1);
         if(_loc2_ > -1)
         {
            this.sity.splice(_loc2_,1);
         }
      }
      
      public function fezasejo(param1:Vector.<hah>) : void
      {
         var _loc4_:sagokibo = null;
         var _loc5_:int = 0;
         var _loc2_:int = int(this.cubajedid.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.cubajedid[_loc3_];
            _loc4_.vahuzys = false;
            _loc4_.put = false;
            _loc5_ = int(param1.length);
            this.hibiqak(_loc4_,param1);
            if(_loc5_ != param1.length)
            {
               _loc4_.vahuzys = true;
            }
            _loc5_ = int(param1.length);
            this.dev(_loc4_,_loc3_ + 1,param1);
            if(_loc5_ != param1.length)
            {
               _loc4_.put = true;
            }
            this.ropy(_loc4_,param1);
            _loc3_++;
         }
      }
      
      private function hibiqak(param1:sagokibo, param2:Vector.<hah>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:hah = null;
         if(!param1.body.vowymov)
         {
            _loc3_ = int(param1.kodasy.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               this.qeciw(this.nyseh.wymyhujoq,param1.kodasy[_loc4_],this.pupicic);
               _loc4_++;
            }
            if(this.pupicic.length > 0)
            {
               _loc5_ = hah.create();
               _loc5_.rukowicyp = param1.body;
               _loc5_.zata = this.kobet;
               _loc5_.zuqy(this.pupicic);
               this.pupicic.length = 0;
               param2[param2.length] = _loc5_;
            }
         }
      }
      
      private function dev(param1:sagokibo, param2:int, param3:Vector.<hah>) : void
      {
         var _loc6_:sagokibo = null;
         var _loc7_:fyweci = null;
         var _loc8_:fyweci = null;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:hah = null;
         var _loc13_:int = 0;
         var _loc14_:gyhu = null;
         var _loc4_:int = int(this.cubajedid.length);
         var _loc5_:int = param2;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = this.cubajedid[_loc5_];
            _loc7_ = param1.body;
            _loc8_ = _loc6_.body;
            if(!(Boolean(_loc7_.vowymov) && Boolean(_loc8_.vowymov)) && Boolean(_loc7_.raruluk.hoguqatec(_loc8_.raruluk,luculeqa)))
            {
               this.pabegyqo(param1.kyripama,_loc6_.kyripama,this.pupicic);
               _loc9_ = int(this.pupicic.length);
               if(_loc9_ > 0)
               {
                  _loc10_ = _loc7_.fosa == null || Boolean(_loc7_.fosa.considerBodies(_loc7_,_loc8_));
                  _loc11_ = _loc8_.fosa == null || Boolean(_loc8_.fosa.considerBodies(_loc8_,_loc7_));
                  if(_loc10_ && _loc11_)
                  {
                     _loc12_ = hah.create();
                     _loc12_.rukowicyp = _loc7_;
                     _loc12_.zata = _loc8_;
                     _loc12_.zuqy(this.pupicic);
                     param3[param3.length] = _loc12_;
                  }
                  else
                  {
                     _loc13_ = 0;
                     while(_loc13_ < _loc9_)
                     {
                        _loc14_ = this.pupicic[_loc13_];
                        _loc14_.dispose();
                        _loc13_++;
                     }
                  }
                  this.pupicic.length = 0;
               }
            }
            _loc5_++;
         }
      }
      
      private function ropy(param1:sagokibo, param2:Vector.<hah>) : void
      {
         var _loc5_:fyweci = null;
         var _loc3_:int = int(this.sity.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.sity[_loc4_];
            this.kuvemok(param1.body,_loc5_,param2);
            _loc4_++;
         }
      }
      
      private function kuvemok(param1:fyweci, param2:fyweci, param3:Vector.<hah>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Vector.<dovabaf> = null;
         var _loc6_:int = 0;
         var _loc7_:Vector.<dovabaf> = null;
         var _loc8_:int = 0;
         var _loc9_:dovabaf = null;
         var _loc10_:int = 0;
         var _loc11_:hah = null;
         if(param1.raruluk.hoguqatec(param2.raruluk,luculeqa))
         {
            _loc4_ = int(param1.kizuvam);
            _loc5_ = param1.hebevy;
            _loc6_ = int(param2.kizuvam);
            _loc7_ = param2.hebevy;
            _loc8_ = 0;
            while(_loc8_ < _loc4_)
            {
               _loc9_ = _loc5_[_loc8_];
               _loc10_ = 0;
               while(_loc10_ < _loc6_)
               {
                  this.pabegyqo(_loc9_,_loc7_[_loc10_],this.pupicic);
                  _loc10_++;
               }
               _loc8_++;
            }
            if(this.pupicic.length > 0)
            {
               _loc11_ = hah.create();
               _loc11_.rukowicyp = param1;
               _loc11_.zata = param2;
               _loc11_.zuqy(this.pupicic);
               param3[param3.length] = _loc11_;
               this.pupicic.length = 0;
            }
         }
      }
      
      public function pabegyqo(param1:dovabaf, param2:dovabaf, param3:Vector.<gyhu>) : void
      {
         if((param1.nute & param2.nute) == 0)
         {
            return;
         }
         if(param1.body == param2.body)
         {
            return;
         }
         if(!param1.raruluk.hoguqatec(param2.raruluk,luculeqa))
         {
            return;
         }
         var _loc4_:faheter = this.pusuc[param1.huvozage | param2.huvozage];
         _loc4_.pabegyqo(param1,param2,param3);
      }
      
      public function bakoc(param1:dovabaf, param2:dovabaf) : Boolean
      {
         if((param1.nute & param2.nute) == 0)
         {
            return false;
         }
         if(param1.body == param2.body)
         {
            return false;
         }
         if(!param1.raruluk.hoguqatec(param2.raruluk,luculeqa))
         {
            return false;
         }
         var _loc3_:faheter = this.pusuc[param1.huvozage | param2.huvozage];
         return _loc3_.tebos(param1,param2);
      }
      
      public function nep(param1:finajylom, param2:finajylom, param3:int, param4:Number, param5:wagoc, param6:qedozeze) : Boolean
      {
         var _loc7_:Boolean = this.jityw(param1,param2,param3,param4,param5,param6);
         var _loc8_:Boolean = this.gajejupeg(param1,param2,param3,param4,param5,this.mydip);
         if(!(_loc8_ || _loc7_))
         {
            return false;
         }
         if(_loc8_ && _loc7_)
         {
            if(param6.jomuc > this.mydip.jomuc)
            {
               param6.disy(this.mydip);
            }
            this.mydip.clear();
            return true;
         }
         if(_loc7_)
         {
            this.mydip.clear();
            return true;
         }
         param6.disy(this.mydip);
         this.mydip.clear();
         return true;
      }
      
      public function jityw(param1:finajylom, param2:finajylom, param3:int, param4:Number, param5:wagoc, param6:qedozeze) : Boolean
      {
         if(!this.luweb(param1,param2,this.nyseh.wymyhujoq.taqa,this.bilaw))
         {
            return false;
         }
         if(this.bilaw.rekycave < 0 || this.bilaw.rylegyqa > param4)
         {
            return false;
         }
         if(this.bilaw.rylegyqa <= 0)
         {
            this.bilaw.rylegyqa = 0;
            this.zidihyw.kan = param1.kan;
            this.zidihyw.zofydizug = param1.zofydizug;
            this.zidihyw.qyririg = param1.qyririg;
         }
         else
         {
            this.zidihyw.kan = param1.kan + this.bilaw.rylegyqa * param2.kan;
            this.zidihyw.zofydizug = param1.zofydizug + this.bilaw.rylegyqa * param2.zofydizug;
            this.zidihyw.qyririg = param1.qyririg + this.bilaw.rylegyqa * param2.qyririg;
         }
         if(this.bilaw.rekycave > param4)
         {
            this.bilaw.rekycave = param4;
         }
         var _loc7_:Boolean = this.zarec(this.nyseh.wymyhujoq,param1,this.zidihyw,param2,param3,this.bilaw.rylegyqa,this.bilaw.rekycave,param5,param6);
         return _loc7_ ? param6.jomuc <= param4 : false;
      }
      
      public function woqyte(param1:finajylom, param2:finajylom, param3:int, param4:Number, param5:wagoc = null) : Boolean
      {
         var _loc6_:Boolean = this.jityw(param1,param2,param3,param4,param5,this.tet);
         this.tet.clear();
         return _loc6_;
      }
      
      private function qeciw(param1:nekusupyg, param2:dovabaf, param3:Vector.<gyhu>) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Vector.<dovabaf> = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1.vavyvyni != null)
         {
            _loc6_ = this.nyseh.gogoq;
            _loc7_ = param1.vavyvyni;
            _loc8_ = int(_loc7_.length);
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               this.pabegyqo(param2,_loc6_[_loc7_[_loc9_]],param3);
               _loc9_++;
            }
         }
         if(param1.zekos == -1)
         {
            return;
         }
         switch(param1.zekos)
         {
            case 0:
               _loc4_ = Number(param2.raruluk.cubegyw);
               _loc5_ = Number(param2.raruluk.jys);
               break;
            case 1:
               _loc4_ = Number(param2.raruluk.nicomosa);
               _loc5_ = Number(param2.raruluk.juri);
               break;
            case 2:
               _loc4_ = Number(param2.raruluk.gesuwi);
               _loc5_ = Number(param2.raruluk.zepoci);
         }
         if(_loc4_ < param1.retycel)
         {
            this.qeciw(param1.hab,param2,param3);
         }
         if(_loc5_ > param1.retycel)
         {
            this.qeciw(param1.gumipiw,param2,param3);
         }
         if(param1.tuz != null && _loc4_ < param1.retycel && _loc5_ > param1.retycel)
         {
            this.qeciw(param1.tuz.wymyhujoq,param2,param3);
         }
      }
      
      private function bylowuzys(param1:dovabaf, param2:nekusupyg) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Vector.<dovabaf> = null;
         var _loc6_:Vector.<int> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param2.vavyvyni != null)
         {
            _loc5_ = this.nyseh.gogoq;
            _loc6_ = param2.vavyvyni;
            _loc7_ = int(_loc6_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               if(this.bakoc(param1,_loc5_[_loc6_[_loc8_]]))
               {
                  return true;
               }
               _loc8_++;
            }
         }
         if(param2.zekos == -1)
         {
            return false;
         }
         switch(param2.zekos)
         {
            case 0:
               _loc3_ = Number(param1.raruluk.cubegyw);
               _loc4_ = Number(param1.raruluk.jys);
               break;
            case 1:
               _loc3_ = Number(param1.raruluk.nicomosa);
               _loc4_ = Number(param1.raruluk.juri);
               break;
            case 2:
               _loc3_ = Number(param1.raruluk.gesuwi);
               _loc4_ = Number(param1.raruluk.zepoci);
         }
         if(param2.tuz != null && _loc3_ < param2.retycel && _loc4_ > param2.retycel)
         {
            if(this.bylowuzys(param1,param2.tuz.wymyhujoq))
            {
               return true;
            }
         }
         if(_loc3_ < param2.retycel)
         {
            if(this.bylowuzys(param1,param2.hab))
            {
               return true;
            }
         }
         if(_loc4_ > param2.retycel)
         {
            if(this.bylowuzys(param1,param2.gumipiw))
            {
               return true;
            }
         }
         return false;
      }
      
      private function gajejupeg(param1:finajylom, param2:finajylom, param3:int, param4:Number, param5:wagoc, param6:qedozeze) : Boolean
      {
         var _loc13_:sagokibo = null;
         var _loc14_:fyweci = null;
         var _loc15_:dudyqo = null;
         var _loc16_:int = 0;
         var _loc17_:dovabaf = null;
         var _loc18_:Number = NaN;
         var _loc7_:Number = param1.kan + param2.kan * param4;
         var _loc8_:Number = param1.zofydizug + param2.zofydizug * param4;
         var _loc9_:Number = param1.qyririg + param2.qyririg * param4;
         if(_loc7_ < param1.kan)
         {
            this.lukej.cubegyw = _loc7_;
            this.lukej.jys = param1.kan;
         }
         else
         {
            this.lukej.cubegyw = param1.kan;
            this.lukej.jys = _loc7_;
         }
         if(_loc8_ < param1.zofydizug)
         {
            this.lukej.nicomosa = _loc8_;
            this.lukej.juri = param1.zofydizug;
         }
         else
         {
            this.lukej.nicomosa = param1.zofydizug;
            this.lukej.juri = _loc8_;
         }
         if(_loc9_ < param1.qyririg)
         {
            this.lukej.gesuwi = _loc9_;
            this.lukej.zepoci = param1.qyririg;
         }
         else
         {
            this.lukej.gesuwi = param1.qyririg;
            this.lukej.zepoci = _loc9_;
         }
         var _loc10_:Number = param4 + 1;
         var _loc11_:int = int(this.cubajedid.length);
         var _loc12_:int = 0;
         while(_loc12_ < _loc11_)
         {
            _loc13_ = this.cubajedid[_loc12_];
            _loc14_ = _loc13_.body;
            _loc15_ = _loc14_.raruluk;
            if(!(this.lukej.jys < _loc15_.cubegyw || this.lukej.cubegyw > _loc15_.jys || this.lukej.juri < _loc15_.nicomosa || this.lukej.nicomosa > _loc15_.juri || this.lukej.zepoci < _loc15_.gesuwi || this.lukej.gesuwi > _loc15_.zepoci))
            {
               _loc16_ = 0;
               while(_loc16_ < _loc14_.kizuvam)
               {
                  _loc17_ = _loc14_.hebevy[_loc16_];
                  if((_loc17_.nute & param3) != 0)
                  {
                     _loc15_ = _loc17_.raruluk;
                     if(!(this.lukej.jys < _loc15_.cubegyw || this.lukej.cubegyw > _loc15_.jys || this.lukej.juri < _loc15_.nicomosa || this.lukej.nicomosa > _loc15_.juri || this.lukej.zepoci < _loc15_.gesuwi || this.lukej.gesuwi > _loc15_.zepoci))
                     {
                        if(!(param5 != null && !param5.considerBody(_loc14_)))
                        {
                           _loc18_ = Number(_loc17_.nep(param1,param2,this.hevarer,this.wawuse));
                           if(_loc18_ >= 0 && _loc18_ < _loc10_)
                           {
                              _loc10_ = _loc18_;
                              param6.vetudozi = _loc17_;
                              param6.lefugefo.kan = this.wawuse.kan;
                              param6.lefugefo.zofydizug = this.wawuse.zofydizug;
                              param6.lefugefo.qyririg = this.wawuse.qyririg;
                           }
                        }
                     }
                  }
                  _loc16_++;
               }
            }
            _loc12_++;
         }
         if(_loc10_ > param4)
         {
            return false;
         }
         param6.position.kan = param1.kan + param2.kan * _loc10_;
         param6.position.zofydizug = param1.zofydizug + param2.zofydizug * _loc10_;
         param6.position.qyririg = param1.qyririg + param2.qyririg * _loc10_;
         param6.jomuc = _loc10_;
         return true;
      }
      
      private function luweb(param1:finajylom, param2:finajylom, param3:dudyqo, param4:pakokur) : Boolean
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         param4.rylegyqa = -1;
         param4.rekycave = 1e+308;
         var _loc7_:int = 0;
         for(; _loc7_ < 3; _loc7_++)
         {
            switch(_loc7_)
            {
               case 0:
                  if(!(param2.kan < this.hevarer && param2.kan > -this.hevarer))
                  {
                     _loc5_ = (param3.cubegyw - param1.kan) / param2.kan;
                     _loc6_ = (param3.jys - param1.kan) / param2.kan;
                     break;
                  }
                  if(param1.kan < param3.cubegyw || param1.kan > param3.jys)
                  {
                     return false;
                  }
                  continue;
               case 1:
                  if(!(param2.zofydizug < this.hevarer && param2.zofydizug > -this.hevarer))
                  {
                     _loc5_ = (param3.nicomosa - param1.zofydizug) / param2.zofydizug;
                     _loc6_ = (param3.juri - param1.zofydizug) / param2.zofydizug;
                     break;
                  }
                  if(param1.zofydizug < param3.nicomosa || param1.zofydizug > param3.juri)
                  {
                     return false;
                  }
                  continue;
               case 2:
                  if(!(param2.qyririg < this.hevarer && param2.qyririg > -this.hevarer))
                  {
                     _loc5_ = (param3.gesuwi - param1.qyririg) / param2.qyririg;
                     _loc6_ = (param3.zepoci - param1.qyririg) / param2.qyririg;
                     break;
                  }
                  if(param1.qyririg < param3.gesuwi || param1.qyririg > param3.zepoci)
                  {
                     return false;
                  }
                  continue;
            }
            if(_loc5_ < _loc6_)
            {
               if(_loc5_ > param4.rylegyqa)
               {
                  param4.rylegyqa = _loc5_;
               }
               if(_loc6_ < param4.rekycave)
               {
                  param4.rekycave = _loc6_;
               }
            }
            else
            {
               if(_loc6_ > param4.rylegyqa)
               {
                  param4.rylegyqa = _loc6_;
               }
               if(_loc5_ < param4.rekycave)
               {
                  param4.rekycave = _loc5_;
               }
            }
            if(param4.rekycave < param4.rylegyqa)
            {
               return false;
            }
         }
         return true;
      }
      
      private function zarec(param1:nekusupyg, param2:finajylom, param3:finajylom, param4:finajylom, param5:int, param6:Number, param7:Number, param8:wagoc, param9:qedozeze) : Boolean
      {
         var _loc10_:Number = NaN;
         var _loc11_:nekusupyg = null;
         var _loc12_:Boolean = false;
         var _loc13_:nekusupyg = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:dovabaf = null;
         if(param1.vavyvyni != null && this.fyfemov(param2,param4,param5,this.nyseh.gogoq,param1.vavyvyni,param8,param9))
         {
            return true;
         }
         if(param1.zekos == -1)
         {
            return false;
         }
         switch(param1.zekos)
         {
            case 0:
               if(param4.kan > -this.hevarer && param4.kan < this.hevarer)
               {
                  _loc10_ = param7 + 1;
               }
               else
               {
                  _loc10_ = (param1.retycel - param2.kan) / param4.kan;
               }
               _loc11_ = param3.kan < param1.retycel ? param1.hab : param1.gumipiw;
               break;
            case 1:
               if(param4.zofydizug > -this.hevarer && param4.zofydizug < this.hevarer)
               {
                  _loc10_ = param7 + 1;
               }
               else
               {
                  _loc10_ = (param1.retycel - param2.zofydizug) / param4.zofydizug;
               }
               _loc11_ = param3.zofydizug < param1.retycel ? param1.hab : param1.gumipiw;
               break;
            case 2:
               if(param4.qyririg > -this.hevarer && param4.qyririg < this.hevarer)
               {
                  _loc10_ = param7 + 1;
               }
               else
               {
                  _loc10_ = (param1.retycel - param2.qyririg) / param4.qyririg;
               }
               _loc11_ = param3.qyririg < param1.retycel ? param1.hab : param1.gumipiw;
         }
         if(_loc10_ < param6 || _loc10_ > param7)
         {
            return this.zarec(_loc11_,param2,param3,param4,param5,param6,param7,param8,param9);
         }
         _loc12_ = this.zarec(_loc11_,param2,param3,param4,param5,param6,_loc10_,param8,param9);
         if(_loc12_)
         {
            return true;
         }
         this.zidihyw.kan = param2.kan + _loc10_ * param4.kan;
         this.zidihyw.zofydizug = param2.zofydizug + _loc10_ * param4.zofydizug;
         this.zidihyw.qyririg = param2.qyririg + _loc10_ * param4.qyririg;
         if(param1.tuz != null)
         {
            _loc13_ = param1.tuz.wymyhujoq;
            while(_loc13_ != null && _loc13_.zekos != -1)
            {
               switch(_loc13_.zekos)
               {
                  case 0:
                     _loc13_ = this.zidihyw.kan < _loc13_.retycel ? _loc13_.hab : _loc13_.gumipiw;
                     break;
                  case 1:
                     _loc13_ = this.zidihyw.zofydizug < _loc13_.retycel ? _loc13_.hab : _loc13_.gumipiw;
                     break;
                  case 2:
                     _loc13_ = this.zidihyw.qyririg < _loc13_.retycel ? _loc13_.hab : _loc13_.gumipiw;
               }
            }
            if(_loc13_ != null && _loc13_.vavyvyni != null)
            {
               _loc14_ = int(_loc13_.vavyvyni.length);
               _loc15_ = 0;
               while(_loc15_ < _loc14_)
               {
                  _loc16_ = this.nyseh.gogoq[_loc13_.vavyvyni[_loc15_]];
                  if((_loc16_.nute & param5) != 0)
                  {
                     if(!(param8 != null && !param8.considerBody(_loc16_.body)))
                     {
                        param9.jomuc = _loc16_.nep(param2,param4,this.hevarer,param9.lefugefo);
                        if(param9.jomuc >= 0)
                        {
                           param9.position.disy(this.zidihyw);
                           param9.vetudozi = _loc16_;
                           return true;
                        }
                     }
                  }
                  _loc15_++;
               }
            }
         }
         return this.zarec(_loc11_ == param1.hab ? param1.gumipiw : param1.hab,param2,this.zidihyw,param4,param5,_loc10_,param7,param8,param9);
      }
      
      private function fyfemov(param1:finajylom, param2:finajylom, param3:int, param4:Vector.<dovabaf>, param5:Vector.<int>, param6:wagoc, param7:qedozeze) : Boolean
      {
         var _loc11_:dovabaf = null;
         var _loc12_:Number = NaN;
         var _loc8_:int = int(param5.length);
         var _loc9_:Number = 1e+308;
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_)
         {
            _loc11_ = param4[param5[_loc10_]];
            if((_loc11_.nute & param3) != 0)
            {
               if(!(param6 != null && !param6.considerBody(_loc11_.body)))
               {
                  _loc12_ = Number(_loc11_.nep(param1,param2,this.hevarer,this.wawuse));
                  if(_loc12_ > 0 && _loc12_ < _loc9_)
                  {
                     _loc9_ = _loc12_;
                     param7.vetudozi = _loc11_;
                     param7.lefugefo.kan = this.wawuse.kan;
                     param7.lefugefo.zofydizug = this.wawuse.zofydizug;
                     param7.lefugefo.qyririg = this.wawuse.qyririg;
                  }
               }
            }
            _loc10_++;
         }
         if(_loc9_ == 1e+308)
         {
            return false;
         }
         param7.position.kan = param1.kan + param2.kan * _loc9_;
         param7.position.zofydizug = param1.zofydizug + param2.zofydizug * _loc9_;
         param7.position.qyririg = param1.qyririg + param2.qyririg * _loc9_;
         param7.jomuc = _loc9_;
         return true;
      }
      
      public function qawadasy(param1:dovabaf) : Boolean
      {
         return this.bylowuzys(param1,this.nyseh.wymyhujoq);
      }
   }
}

