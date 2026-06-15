package zicy
{
   import kihi.dudyqo;
   
   public class tolavoka
   {
      
      private static const tyvak:dudyqo = new dudyqo();
      
      private static const tibuh:Vector.<Number> = new Vector.<Number>();
      
      private static const vydumu:Vector.<Number> = new Vector.<Number>();
      
      private static const zyq:Vector.<Number> = new Vector.<Number>();
      
      private static const gaboder:Vector.<Number> = new Vector.<Number>(6);
      
      private static const pekeryf:Vector.<Number> = new Vector.<Number>(6);
      
      public var hevarer:Number = 0.1;
      
      public var cihi:int = 1;
      
      public var wymyhujoq:nekusupyg;
      
      public var gogoq:Vector.<dovabaf>;
      
      public var pojisahyz:int;
      
      public var nyrimobo:Vector.<dudyqo> = new Vector.<dudyqo>();
      
      private var ladoba:int;
      
      private var qijysa:Number;
      
      private var zadarypus:Number;
      
      public function tolavoka()
      {
         super();
      }
      
      public function hoc(param1:Vector.<dovabaf>, param2:dudyqo = null) : void
      {
         var _loc5_:dovabaf = null;
         var _loc6_:dudyqo = null;
         this.gogoq = param1.concat();
         this.pojisahyz = this.gogoq.length;
         this.wymyhujoq = new nekusupyg();
         this.wymyhujoq.vavyvyni = new Vector.<int>();
         var _loc3_:dudyqo = this.wymyhujoq.taqa = param2 != null ? param2 : new dudyqo();
         var _loc4_:int = 0;
         while(_loc4_ < this.pojisahyz)
         {
            _loc5_ = this.gogoq[_loc4_];
            _loc6_ = this.nyrimobo[_loc4_] = _loc5_.zety();
            _loc3_.fajabym(_loc6_);
            this.wymyhujoq.vavyvyni[_loc4_] = _loc4_;
            _loc4_++;
         }
         this.nyrimobo.length = this.pojisahyz;
         this.wyjiqel(this.wymyhujoq);
         tibuh.length = vydumu.length = zyq.length = 0;
      }
      
      private function wyjiqel(param1:nekusupyg) : void
      {
         var _loc4_:dudyqo = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc15_:dudyqo = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc2_:Vector.<int> = param1.vavyvyni;
         var _loc3_:int = int(_loc2_.length);
         if(_loc3_ <= this.cihi)
         {
            return;
         }
         _loc4_ = param1.taqa;
         tyvak.cubegyw = _loc4_.cubegyw + this.hevarer;
         tyvak.nicomosa = _loc4_.nicomosa + this.hevarer;
         tyvak.gesuwi = _loc4_.gesuwi + this.hevarer;
         tyvak.jys = _loc4_.jys - this.hevarer;
         tyvak.juri = _loc4_.juri - this.hevarer;
         tyvak.zepoci = _loc4_.zepoci - this.hevarer;
         var _loc5_:Number = this.hevarer * 2;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < _loc3_)
         {
            _loc15_ = this.nyrimobo[_loc2_[_loc6_]];
            if(_loc15_.jys - _loc15_.cubegyw <= _loc5_)
            {
               if(_loc15_.cubegyw <= tyvak.cubegyw)
               {
                  tibuh[_loc8_++] = _loc4_.cubegyw;
               }
               else if(_loc15_.jys >= tyvak.jys)
               {
                  tibuh[_loc8_++] = _loc4_.jys;
               }
               else
               {
                  tibuh[_loc8_++] = (_loc15_.cubegyw + _loc15_.jys) * 0.5;
               }
            }
            else
            {
               if(_loc15_.cubegyw > tyvak.cubegyw)
               {
                  tibuh[_loc8_++] = _loc15_.cubegyw;
               }
               if(_loc15_.jys < tyvak.jys)
               {
                  tibuh[_loc8_++] = _loc15_.jys;
               }
            }
            if(_loc15_.juri - _loc15_.nicomosa <= _loc5_)
            {
               if(_loc15_.nicomosa <= tyvak.nicomosa)
               {
                  vydumu[_loc9_++] = _loc4_.nicomosa;
               }
               else if(_loc15_.juri >= tyvak.juri)
               {
                  vydumu[_loc9_++] = _loc4_.juri;
               }
               else
               {
                  vydumu[_loc9_++] = (_loc15_.nicomosa + _loc15_.juri) * 0.5;
               }
            }
            else
            {
               if(_loc15_.nicomosa > tyvak.nicomosa)
               {
                  vydumu[_loc9_++] = _loc15_.nicomosa;
               }
               if(_loc15_.juri < tyvak.juri)
               {
                  vydumu[_loc9_++] = _loc15_.juri;
               }
            }
            if(_loc15_.zepoci - _loc15_.gesuwi <= _loc5_)
            {
               if(_loc15_.gesuwi <= tyvak.gesuwi)
               {
                  zyq[_loc10_++] = _loc4_.gesuwi;
               }
               else if(_loc15_.zepoci >= tyvak.zepoci)
               {
                  zyq[_loc10_++] = _loc4_.zepoci;
               }
               else
               {
                  zyq[_loc10_++] = (_loc15_.gesuwi + _loc15_.zepoci) * 0.5;
               }
            }
            else
            {
               if(_loc15_.gesuwi > tyvak.gesuwi)
               {
                  zyq[_loc10_++] = _loc15_.gesuwi;
               }
               if(_loc15_.zepoci < tyvak.zepoci)
               {
                  zyq[_loc10_++] = _loc15_.zepoci;
               }
            }
            _loc6_++;
         }
         this.ladoba = -1;
         this.zadarypus = 1e+308;
         gaboder[0] = _loc4_.cubegyw;
         gaboder[1] = _loc4_.nicomosa;
         gaboder[2] = _loc4_.gesuwi;
         gaboder[3] = _loc4_.jys;
         gaboder[4] = _loc4_.juri;
         gaboder[5] = _loc4_.zepoci;
         this.putynovu(param1,0,_loc8_,tibuh,gaboder);
         this.putynovu(param1,1,_loc9_,vydumu,gaboder);
         this.putynovu(param1,2,_loc10_,zyq,gaboder);
         if(this.ladoba < 0)
         {
            return;
         }
         var _loc11_:Boolean = this.ladoba == 0;
         var _loc12_:Boolean = this.ladoba == 1;
         param1.zekos = this.ladoba;
         param1.retycel = this.qijysa;
         param1.hab = new nekusupyg();
         param1.hab.vewu = param1;
         param1.hab.taqa = _loc4_.bet();
         param1.gumipiw = new nekusupyg();
         param1.gumipiw.vewu = param1;
         param1.gumipiw.taqa = _loc4_.bet();
         if(_loc11_)
         {
            param1.hab.taqa.jys = param1.gumipiw.taqa.cubegyw = this.qijysa;
         }
         else if(_loc12_)
         {
            param1.hab.taqa.juri = param1.gumipiw.taqa.nicomosa = this.qijysa;
         }
         else
         {
            param1.hab.taqa.zepoci = param1.gumipiw.taqa.gesuwi = this.qijysa;
         }
         var _loc13_:Number = this.qijysa - this.hevarer;
         var _loc14_:Number = this.qijysa + this.hevarer;
         _loc6_ = 0;
         while(_loc6_ < _loc3_)
         {
            _loc15_ = this.nyrimobo[_loc2_[_loc6_]];
            _loc16_ = _loc11_ ? _loc15_.cubegyw : (_loc12_ ? _loc15_.nicomosa : _loc15_.gesuwi);
            _loc17_ = _loc11_ ? _loc15_.jys : (_loc12_ ? _loc15_.juri : _loc15_.zepoci);
            if(_loc17_ <= _loc14_)
            {
               if(_loc16_ < _loc13_)
               {
                  if(param1.hab.vavyvyni == null)
                  {
                     param1.hab.vavyvyni = new Vector.<int>();
                  }
                  param1.hab.vavyvyni.push(_loc2_[_loc6_]);
                  _loc2_[_loc6_] = -1;
               }
               else
               {
                  if(param1.henanaja == null)
                  {
                     param1.henanaja = new Vector.<int>();
                  }
                  param1.henanaja.push(_loc2_[_loc6_]);
                  _loc2_[_loc6_] = -1;
               }
            }
            else if(_loc16_ >= _loc13_)
            {
               if(param1.gumipiw.vavyvyni == null)
               {
                  param1.gumipiw.vavyvyni = new Vector.<int>();
               }
               param1.gumipiw.vavyvyni.push(_loc2_[_loc6_]);
               _loc2_[_loc6_] = -1;
            }
            _loc6_++;
         }
         _loc6_ = 0;
         _loc7_ = 0;
         while(_loc6_ < _loc3_)
         {
            if(_loc2_[_loc6_] >= 0)
            {
               _loc2_[_loc7_++] = _loc2_[_loc6_];
            }
            _loc6_++;
         }
         if(_loc7_ > 0)
         {
            _loc2_.length = _loc7_;
         }
         else
         {
            param1.vavyvyni = null;
         }
         if(param1.henanaja != null)
         {
            param1.tuz = new diqohohi(this,param1);
            param1.tuz.hoc();
         }
         if(param1.hab.vavyvyni != null)
         {
            this.wyjiqel(param1.hab);
         }
         if(param1.gumipiw.vavyvyni != null)
         {
            this.wyjiqel(param1.gumipiw);
         }
      }
      
      private function putynovu(param1:nekusupyg, param2:int, param3:int, param4:Vector.<Number>, param5:Vector.<Number>) : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Boolean = false;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:Number = NaN;
         var _loc21_:dudyqo = null;
         var _loc6_:int = (param2 + 1) % 3;
         var _loc7_:int = (param2 + 2) % 3;
         var _loc8_:Number = (param5[_loc6_ + 3] - param5[_loc6_]) * (param5[_loc7_ + 3] - param5[_loc7_]);
         var _loc9_:int = 0;
         while(_loc9_ < param3)
         {
            _loc10_ = param4[_loc9_];
            if(!isNaN(_loc10_))
            {
               _loc11_ = _loc10_ - this.hevarer;
               _loc12_ = _loc10_ + this.hevarer;
               _loc13_ = _loc8_ * (_loc10_ - param5[param2]);
               _loc14_ = _loc8_ * (param5[int(param2 + 3)] - _loc10_);
               _loc15_ = 0;
               _loc16_ = 0;
               _loc17_ = false;
               _loc18_ = int(param1.vavyvyni.length);
               _loc19_ = 0;
               while(_loc19_ < _loc18_)
               {
                  _loc21_ = this.nyrimobo[param1.vavyvyni[_loc19_]];
                  pekeryf[0] = _loc21_.cubegyw;
                  pekeryf[1] = _loc21_.nicomosa;
                  pekeryf[2] = _loc21_.gesuwi;
                  pekeryf[3] = _loc21_.jys;
                  pekeryf[4] = _loc21_.juri;
                  pekeryf[5] = _loc21_.zepoci;
                  if(pekeryf[param2 + 3] <= _loc12_)
                  {
                     if(pekeryf[param2] < _loc11_)
                     {
                        _loc15_++;
                     }
                  }
                  else
                  {
                     if(pekeryf[param2] < _loc11_)
                     {
                        _loc17_ = true;
                        break;
                     }
                     _loc16_++;
                  }
                  _loc19_++;
               }
               _loc20_ = _loc13_ * _loc15_ + _loc14_ * _loc16_;
               if(!_loc17_ && _loc20_ < this.zadarypus && _loc15_ > 0 && _loc16_ > 0)
               {
                  this.ladoba = param2;
                  this.zadarypus = _loc20_;
                  this.qijysa = _loc10_;
               }
               _loc19_ = _loc9_ + 1;
               while(_loc19_ < param3)
               {
                  if(param4[_loc19_] >= _loc10_ - this.hevarer && param4[_loc19_] <= _loc10_ + this.hevarer)
                  {
                     param4[_loc19_] = NaN;
                  }
                  _loc19_++;
               }
            }
            _loc9_++;
         }
      }
      
      public function jiw() : void
      {
         this.hylejotim("",this.wymyhujoq);
      }
      
      private function hylejotim(param1:String, param2:nekusupyg) : void
      {
         if(param2 == null)
         {
            return;
         }
         this.hylejotim(param1 + "-",param2.hab);
         this.hylejotim(param1 + "+",param2.gumipiw);
      }
   }
}

