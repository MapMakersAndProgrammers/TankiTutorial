package zicy
{
   import alternativa.physics.collision.types.AABB;
   
   public class diqohohi
   {
      
      private static const tyvak:AABB = new AABB();
      
      private static const tibuh:Vector.<Number> = new Vector.<Number>();
      
      private static const vydumu:Vector.<Number> = new Vector.<Number>();
      
      private static const zyq:Vector.<Number> = new Vector.<Number>();
      
      private static const gaboder:Vector.<Number> = new Vector.<Number>(6);
      
      private static const pekeryf:Vector.<Number> = new Vector.<Number>(6);
      
      public var hevarer:Number = 0.1;
      
      public var cihi:int = 1;
      
      public var tugoz:tolavoka;
      
      public var vivunoc:nekusupyg;
      
      public var wymyhujoq:nekusupyg;
      
      private var ladoba:int;
      
      private var zadarypus:Number;
      
      private var qijysa:Number;
      
      public function diqohohi(param1:tolavoka, param2:nekusupyg)
      {
         super();
         this.tugoz = param1;
         this.vivunoc = param2;
      }
      
      public function hoc() : void
      {
         this.wymyhujoq = new nekusupyg();
         this.wymyhujoq.taqa = this.vivunoc.taqa.clone();
         this.wymyhujoq.vavyvyni = new Vector.<int>();
         var _loc1_:int = int(this.vivunoc.henanaja.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            this.wymyhujoq.vavyvyni[_loc2_] = this.vivunoc.henanaja[_loc2_];
            _loc2_++;
         }
         this.wyjiqel(this.wymyhujoq);
         tibuh.length = vydumu.length = zyq.length = 0;
      }
      
      private function wyjiqel(param1:nekusupyg) : void
      {
         var _loc2_:Vector.<int> = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:AABB = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc16_:AABB = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         if(param1.vavyvyni.length <= this.cihi)
         {
            return;
         }
         _loc2_ = param1.vavyvyni;
         _loc5_ = param1.taqa;
         tyvak.cubegyw = _loc5_.cubegyw + this.hevarer;
         tyvak.nicomosa = _loc5_.nicomosa + this.hevarer;
         tyvak.gesuwi = _loc5_.gesuwi + this.hevarer;
         tyvak.jys = _loc5_.jys - this.hevarer;
         tyvak.juri = _loc5_.juri - this.hevarer;
         tyvak.zepoci = _loc5_.zepoci - this.hevarer;
         var _loc6_:Number = this.hevarer * 2;
         var _loc7_:Vector.<AABB> = this.tugoz.nyrimobo;
         var _loc11_:int = int(_loc2_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc11_)
         {
            _loc16_ = _loc7_[_loc2_[_loc3_]];
            if(this.vivunoc.zekos != 0)
            {
               if(_loc16_.cubegyw > tyvak.cubegyw)
               {
                  tibuh[_loc8_++] = _loc16_.cubegyw;
               }
               if(_loc16_.jys < tyvak.jys)
               {
                  tibuh[_loc8_++] = _loc16_.jys;
               }
            }
            if(this.vivunoc.zekos != 1)
            {
               if(_loc16_.nicomosa > tyvak.nicomosa)
               {
                  vydumu[_loc9_++] = _loc16_.nicomosa;
               }
               if(_loc16_.juri < tyvak.juri)
               {
                  vydumu[_loc9_++] = _loc16_.juri;
               }
            }
            if(this.vivunoc.zekos != 2)
            {
               if(_loc16_.gesuwi > tyvak.gesuwi)
               {
                  zyq[_loc10_++] = _loc16_.gesuwi;
               }
               if(_loc16_.zepoci < tyvak.zepoci)
               {
                  zyq[_loc10_++] = _loc16_.zepoci;
               }
            }
            _loc3_++;
         }
         this.ladoba = -1;
         this.zadarypus = 1e+308;
         gaboder[0] = _loc5_.cubegyw;
         gaboder[1] = _loc5_.nicomosa;
         gaboder[2] = _loc5_.gesuwi;
         gaboder[3] = _loc5_.jys;
         gaboder[4] = _loc5_.juri;
         gaboder[5] = _loc5_.zepoci;
         if(this.vivunoc.zekos != 0)
         {
            this.putynovu(param1,0,_loc8_,tibuh,gaboder);
         }
         if(this.vivunoc.zekos != 1)
         {
            this.putynovu(param1,1,_loc9_,vydumu,gaboder);
         }
         if(this.vivunoc.zekos != 2)
         {
            this.putynovu(param1,2,_loc10_,zyq,gaboder);
         }
         if(this.ladoba < 0)
         {
            return;
         }
         var _loc12_:Boolean = this.ladoba == 0;
         var _loc13_:Boolean = this.ladoba == 1;
         param1.zekos = this.ladoba;
         param1.retycel = this.qijysa;
         param1.hab = new nekusupyg();
         param1.hab.vewu = param1;
         param1.hab.taqa = _loc5_.clone();
         param1.gumipiw = new nekusupyg();
         param1.gumipiw.vewu = param1;
         param1.gumipiw.taqa = _loc5_.clone();
         if(_loc12_)
         {
            param1.hab.taqa.jys = param1.gumipiw.taqa.cubegyw = this.qijysa;
         }
         else if(_loc13_)
         {
            param1.hab.taqa.juri = param1.gumipiw.taqa.nicomosa = this.qijysa;
         }
         else
         {
            param1.hab.taqa.zepoci = param1.gumipiw.taqa.gesuwi = this.qijysa;
         }
         var _loc14_:Number = this.qijysa - this.hevarer;
         var _loc15_:Number = this.qijysa + this.hevarer;
         _loc3_ = 0;
         while(_loc3_ < _loc11_)
         {
            _loc16_ = _loc7_[_loc2_[_loc3_]];
            _loc17_ = _loc12_ ? _loc16_.cubegyw : (_loc13_ ? _loc16_.nicomosa : _loc16_.gesuwi);
            _loc18_ = _loc12_ ? _loc16_.jys : (_loc13_ ? _loc16_.juri : _loc16_.zepoci);
            if(_loc18_ <= _loc15_)
            {
               if(_loc17_ < _loc14_)
               {
                  if(param1.hab.vavyvyni == null)
                  {
                     param1.hab.vavyvyni = new Vector.<int>();
                  }
                  param1.hab.vavyvyni.push(_loc2_[_loc3_]);
                  _loc2_[_loc3_] = -1;
               }
            }
            else if(_loc17_ >= _loc14_)
            {
               if(_loc18_ > _loc15_)
               {
                  if(param1.gumipiw.vavyvyni == null)
                  {
                     param1.gumipiw.vavyvyni = new Vector.<int>();
                  }
                  param1.gumipiw.vavyvyni.push(_loc2_[_loc3_]);
                  _loc2_[_loc3_] = -1;
               }
            }
            _loc3_++;
         }
         _loc3_ = 0;
         _loc4_ = 0;
         while(_loc3_ < _loc11_)
         {
            if(_loc2_[_loc3_] >= 0)
            {
               _loc2_[_loc4_++] = _loc2_[_loc3_];
            }
            _loc3_++;
         }
         if(_loc4_ > 0)
         {
            _loc2_.length = _loc4_;
         }
         else
         {
            param1.vavyvyni = null;
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
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Boolean = false;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc22_:AABB = null;
         var _loc6_:int = (param2 + 1) % 3;
         var _loc7_:int = (param2 + 2) % 3;
         var _loc8_:Number = (param5[_loc6_ + 3] - param5[_loc6_]) * (param5[_loc7_ + 3] - param5[_loc7_]);
         var _loc9_:Vector.<AABB> = this.tugoz.nyrimobo;
         var _loc10_:int = 0;
         while(_loc10_ < param3)
         {
            _loc11_ = param4[_loc10_];
            if(!isNaN(_loc11_))
            {
               _loc12_ = _loc11_ - this.hevarer;
               _loc13_ = _loc11_ + this.hevarer;
               _loc14_ = _loc8_ * (_loc11_ - param5[param2]);
               _loc15_ = _loc8_ * (param5[int(param2 + 3)] - _loc11_);
               _loc16_ = 0;
               _loc17_ = 0;
               _loc18_ = false;
               _loc19_ = int(param1.vavyvyni.length);
               _loc20_ = 0;
               while(_loc20_ < _loc19_)
               {
                  _loc22_ = _loc9_[param1.vavyvyni[_loc20_]];
                  pekeryf[0] = _loc22_.cubegyw;
                  pekeryf[1] = _loc22_.nicomosa;
                  pekeryf[2] = _loc22_.gesuwi;
                  pekeryf[3] = _loc22_.jys;
                  pekeryf[4] = _loc22_.juri;
                  pekeryf[5] = _loc22_.zepoci;
                  if(pekeryf[param2 + 3] <= _loc13_)
                  {
                     if(pekeryf[param2] < _loc12_)
                     {
                        _loc16_++;
                     }
                  }
                  else
                  {
                     if(pekeryf[param2] < _loc12_)
                     {
                        _loc18_ = true;
                        break;
                     }
                     _loc17_++;
                  }
                  _loc20_++;
               }
               _loc21_ = _loc14_ * _loc16_ + _loc15_ * _loc17_;
               if(!_loc18_ && _loc21_ < this.zadarypus && _loc16_ > 0 && _loc17_ > 0)
               {
                  this.ladoba = param2;
                  this.zadarypus = _loc21_;
                  this.qijysa = _loc11_;
               }
               _loc20_ = _loc10_ + 1;
               while(_loc20_ < param3)
               {
                  if(param4[_loc20_] >= _loc11_ - this.hevarer && param4[_loc20_] <= _loc11_ + this.hevarer)
                  {
                     param4[_loc20_] = NaN;
                  }
                  _loc20_++;
               }
            }
            _loc10_++;
         }
      }
   }
}

