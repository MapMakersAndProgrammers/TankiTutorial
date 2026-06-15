package dyfataki
{
   import alternativa.engine3d.core.Object3D;
   import gafaduzuw.finajylom;
   import gafaduzuw.fode;
   import jydanitu.mase;
   import kefy.Wopowur;
   import kefy.fare;
   import kihi.qedozeze;
   import lifyqeq.lojufaqik;
   import lifyqeq.tugawe;
   import lowavide.litavepot;
   import lowavide.qujimowo;
   import lowavide.vozaj;
   import lowavide.zocikydo;
   import lycikehe.hubumeno;
   import lycikehe.raz;
   import lycikehe.zel;
   import pekiv.sumik;
   import zicy.nocyquk;
   
   public class ryzaj extends Wopowur implements qujimowo, zocikydo, litavepot, Rozokebis
   {
      
      private static const manytaq:Number = 10000000000;
      
      private static const peveco:finajylom = new finajylom();
      
      private static const docyqy:finajylom = new finajylom();
      
      private static const nuk:finajylom = new finajylom();
      
      private static const jarunazyk:finajylom = new finajylom();
      
      private static const natyjy:finajylom = new finajylom();
      
      private static const cokis:finajylom = new finajylom();
      
      private static const vyhomopog:finajylom = new finajylom();
      
      private static const tet:qedozeze = new qedozeze();
      
      private static const run:fode = new fode();
      
      private static const qopo:fode = new fode();
      
      private static const zekos:finajylom = new finajylom();
      
      private static const fyqynyfy:finajylom = new finajylom();
      
      private static const divogyvo:finajylom = new finajylom();
      
      private var giqo:cogaj;
      
      private var kyvedu:lufoloje;
      
      private var til:fodolihy;
      
      private var mij:vozaj;
      
      private var pobano:Number = 0;
      
      private var luk:mase;
      
      private var katuf:luculo;
      
      private var nimulul:mase;
      
      private var ledijym:Boolean;
      
      private var wyqitywi:cuvamywe;
      
      private var lywajoqa:Vector.<judidoju> = new Vector.<judidoju>();
      
      private var syligatyl:judidoju;
      
      private var kewi:tijimu;
      
      private var lyge:jif;
      
      public const nuziged:tugawe = new lojufaqik();
      
      public const lybaluh:tugawe = new lojufaqik();
      
      public const gave:tugawe = new lojufaqik();
      
      private const hery:tugawe = new lojufaqik();
      
      public function ryzaj(param1:fare)
      {
         super(param1);
         this.wyqitywi = new cuvamywe(this);
         this.kewi = new tijimu(this);
         this.lyge = new jif(this);
      }
      
      private static function fazidu(param1:finajylom) : Boolean
      {
         return param1.qyririg > rurosecel.bepy;
      }
      
      public function cabor(param1:mase, param2:mase, param3:luculo, param4:vozaj) : void
      {
         this.luk = param1;
         this.nimulul = param2;
         this.katuf = param3;
         this.mij = param4;
         this.lywajoqa.length = 0;
      }
      
      public function pykevazut(param1:finajylom, param2:int, param3:Number, param4:Function) : void
      {
         var _loc5_:int = 0;
         this.pobano = param3;
         this.hery.kyluwuzi(param4);
         this.gyvok();
         this.ledijym = false;
         this.lywajoqa.length = 0;
         this.goq(param1,docyqy,peveco);
         if(this.fehan(param1))
         {
            this.vaqun(docyqy,peveco);
         }
         else
         {
            this.mogufakew(param1,docyqy,peveco,param2);
            this.wyqitywi.nyzydec(this.mij.hifajy());
            _loc5_ = (docyqy.jepik(param1) - rurosecel.numij) / param3 * 1000;
         }
         this.wobev(_loc5_ + this.katuf.wym - param2);
         if(this.qovado())
         {
            this.sisenujet();
         }
      }
      
      private function vaqun(param1:finajylom, param2:finajylom) : void
      {
         var _loc3_:Number = NaN;
         divogyvo.variq(0,0,rurosecel.numij);
         if(fazidu(param2))
         {
            fyqynyfy.variq(0,0,this.dil());
         }
         else
         {
            zekos.juc(finajylom.nesicuryn,param2);
            zekos.behy();
            _loc3_ = Math.acos(param2.qyririg);
            run.dekod(zekos,_loc3_);
            qopo.vajetyw(0,0,this.dil());
            qopo.codaz(run);
            qopo.vah(fyqynyfy);
            divogyvo.jec(run);
         }
         this.giqo.rotationX = fyqynyfy.kan;
         this.giqo.rotationY = fyqynyfy.zofydizug;
         this.giqo.rotationZ = fyqynyfy.qyririg;
         this.giqo.x = param1.kan + divogyvo.kan;
         this.giqo.y = param1.zofydizug + divogyvo.zofydizug;
         this.giqo.z = param1.qyririg + divogyvo.qyririg;
         this.gunof();
         this.mij.rybigu().miboho(this.giqo);
         this.dudu();
      }
      
      private function dudu() : void
      {
         var _loc1_:qape = qape(this.mij.gezuzec().loq(qape));
         _loc1_.juh(this,this.mij);
      }
      
      private function gunof() : void
      {
         this.wyqitywi.kidi(this.giqo.x,this.giqo.y,this.giqo.z,this.giqo.rotationX,this.giqo.rotationY,this.giqo.rotationZ);
      }
      
      private function dil() : Number
      {
         return Math.PI * 10 * this.nimulul.rodaf / 180;
      }
      
      private function mogufakew(param1:finajylom, param2:finajylom, param3:finajylom, param4:int) : void
      {
         var _loc5_:Number = NaN;
         if(fazidu(param3))
         {
            _loc5_ = this.sywo(param1,param2);
            nuk.disy(param2);
         }
         else
         {
            jarunazyk.juc(param3,finajylom.nesicuryn);
            jarunazyk.behy();
            natyjy.juc(param3,jarunazyk);
            cokis.juc(finajylom.nesicuryn,jarunazyk);
            vyhomopog.disy(param1);
            vyhomopog.lopyvan(-rurosecel.numij,cokis);
            nuk.disy(param2);
            nuk.lopyvan(-rurosecel.numij / param3.qyririg,natyjy);
            if(this.mij.hifajy().pazoc().jityw(vyhomopog,finajylom.lasis,sumik.neli,manytaq,null,tet))
            {
               if(param2.qyririg < tet.zybin.qyririg && tet.zybin.qyririg < nuk.qyririg)
               {
                  nuk.lopyvan(rurosecel.numij / param3.qyririg * (nuk.qyririg - tet.zybin.qyririg) / (nuk.qyririg - param2.qyririg),natyjy);
               }
            }
            _loc5_ = this.sywo(param1,nuk);
            this.lyge.cabor(nuk,param3);
            this.lywajoqa.push(this.lyge);
         }
         var _loc6_:Number = nuk.qyririg + rurosecel.numij + rurosecel.wucaruw;
         var _loc7_:Number = this.dil();
         if(_loc5_ * 1000 <= param4)
         {
            this.giqo.x = param1.kan;
            this.giqo.y = param1.zofydizug;
            this.giqo.z = param2.qyririg + rurosecel.numij;
            this.giqo.rotationZ = _loc7_ + _loc5_ * rurosecel.myr;
            this.gunof();
            this.mij.rybigu().miboho(this.giqo);
         }
         else
         {
            this.dynoj();
            this.jinyso();
            this.gyzepiz(this.mij);
            this.kewi.cabor(param1,this.pobano,_loc6_,-_loc5_,param4 / 1000,_loc7_);
            this.lywajoqa.push(this.kewi);
         }
      }
      
      private function fehan(param1:finajylom) : Boolean
      {
         var _loc2_:nocyquk = this.mij.hifajy().pazoc();
         return _loc2_.woqyte(param1,finajylom.nesicuryn,sumik.neli,manytaq);
      }
      
      private function goq(param1:finajylom, param2:finajylom, param3:finajylom) : void
      {
         var _loc4_:nocyquk = this.mij.hifajy().pazoc();
         if(_loc4_.jityw(param1,finajylom.lasis,sumik.neli,manytaq,null,tet))
         {
            param3.disy(tet.lefugefo);
            param2.disy(tet.zybin);
         }
         else
         {
            param3.disy(finajylom.nesicuryn);
            param2.disy(param1);
            param2.qyririg -= 1000;
         }
      }
      
      public function get regupagaq() : mase
      {
         return this.nimulul;
      }
      
      public function mefomoj() : void
      {
         this.nuziged.wanemyw();
         this.suqyzufa();
         this.rytuz();
         this.qozu();
         this.byr();
      }
      
      private function suqyzufa() : void
      {
         var _loc1_:raz = null;
         var _loc2_:finajylom = null;
         if(this.katuf.ruzy != null)
         {
            _loc1_ = raz.leqame(this.katuf.ruzy,hubumeno.suwyc,hubumeno.bapewa,hubumeno.fyvilyv,0.5);
            _loc2_ = new finajylom(this.giqo.x,this.giqo.y,this.giqo.z);
            this.mij.gimog(zel.leqame(this.mij.gezuzec(),_loc2_,_loc1_));
         }
      }
      
      private function qozu() : void
      {
         var _loc1_:mopiny = mopiny(this.mij.gezuzec().loq(mopiny));
         _loc1_.juh(this.giqo,this.mij.rybigu());
         this.giqo = null;
      }
      
      public function kyragira() : void
      {
         this.lybaluh.wanemyw();
         this.giqo = null;
         this.byr();
      }
      
      private function byr() : void
      {
         this.gave.wanemyw();
         this.nuziged.ficituk();
         this.lybaluh.ficituk();
         this.gave.ficituk();
         this.sunetaci();
         this.pygeky();
         this.reharagev();
         this.wyqitywi.detudomej();
         this.hery.ficituk();
         this.mij = null;
         this.katuf = null;
         sapavaj();
      }
      
      private function sunetaci() : void
      {
         if(this.giqo != null)
         {
            this.mij.rybigu().behukywu(this.giqo);
            this.giqo.sapavaj();
            this.giqo = null;
         }
      }
      
      private function pygeky() : void
      {
         if(this.kyvedu != null)
         {
            this.mij.rybigu().behukywu(this.kyvedu);
            this.kyvedu.sapavaj();
            this.kyvedu = null;
            this.mij.rybigu().behukywu(this.til);
            this.til.sapavaj();
            this.til = null;
         }
      }
      
      private function sywo(param1:finajylom, param2:finajylom) : Number
      {
         return (param1.qyririg - param2.qyririg - rurosecel.numij) / this.pobano;
      }
      
      private function wobev(param1:int) : void
      {
         var _loc2_:nezyrowi = nezyrowi(this.mij.gezuzec().loq(nezyrowi));
         _loc2_.cabor(this.mij.rybigu(),this,param1);
      }
      
      private function gyzepiz(param1:vozaj) : void
      {
         var _loc2_:zygaqaf = zygaqaf(param1.gezuzec().loq(zygaqaf));
         _loc2_.juh(this,param1.rybigu());
      }
      
      private function sisenujet() : void
      {
         if(!this.ledijym)
         {
            this.ledijym = true;
            this.mij.hifajy().dufuredi(this);
            this.mij.hifajy().gyvefohip(this);
            this.mij.rybigu().dopus(this,0);
         }
      }
      
      private function dynoj() : void
      {
         if(wapakojy.qifaw())
         {
            this.kyvedu = new lufoloje(this.katuf.vukuzub,this.katuf.berav);
         }
         else
         {
            this.kyvedu = wapakojy.libysoti();
         }
         if(wapakojy.lutyvemu())
         {
            this.til = new fodolihy(lufoloje.jonoga,rurosecel.numij,lufoloje.lapocar,this.katuf.zerow);
         }
         else
         {
            this.til = wapakojy.dugejobig();
         }
         this.til.cabor(this.giqo,this.kyvedu);
      }
      
      private function gyvok() : void
      {
         if(wapakojy.posuvy(this.luk))
         {
            this.giqo = new cogaj(this.luk,this.katuf.tipi);
         }
         else
         {
            this.giqo = wapakojy.qemydyc(this.luk);
         }
         this.giqo.cabor();
      }
      
      private function jinyso() : void
      {
         this.mij.rybigu().miboho(this.kyvedu);
         this.mij.rybigu().miboho(this.giqo);
         this.mij.rybigu().miboho(this.til);
      }
      
      public function hebygima(param1:Number) : void
      {
         this.syligatyl.hebygima(param1);
      }
      
      private function reharagev() : void
      {
         if(this.ledijym)
         {
            this.ledijym = false;
            this.mij.hifajy().wizosigy(this);
            this.mij.hifajy().buj(this);
            this.mij.rybigu().gebi(this,0);
         }
      }
      
      private function rytuz() : void
      {
         var _loc1_:purywi = null;
         if(this.kyvedu != null)
         {
            _loc1_ = purywi(this.mij.gezuzec().loq(purywi));
            _loc1_.juh(this.mij.rybigu(),this.kyvedu,this.til,this.pobano / 2);
            this.kyvedu = null;
            this.til = null;
         }
      }
      
      public function hynar(param1:Number) : void
      {
         this.syligatyl.hynar(param1);
      }
      
      public function gecumyb(param1:int, param2:int) : void
      {
         this.syligatyl.gecumyb();
      }
      
      public function newofelan(param1:Number) : void
      {
         this.giqo.newofelan(param1);
         if(this.kyvedu != null)
         {
            this.kyvedu.newofelan(param1);
            this.til.newofelan(param1);
         }
      }
      
      public function cazizole() : void
      {
         this.wyqitywi.detudomej();
         this.hery.wanemyw(this);
      }
      
      public function synevy() : void
      {
         this.rytuz();
         if(!this.qovado())
         {
            this.piluny();
         }
      }
      
      public function tewyveku() : void
      {
         this.piluny();
      }
      
      private function piluny() : void
      {
         this.reharagev();
      }
      
      public function qemydyc() : cogaj
      {
         return this.giqo;
      }
      
      private function qovado() : Boolean
      {
         this.syligatyl = this.lywajoqa.pop();
         if(this.syligatyl == null)
         {
            return false;
         }
         this.syligatyl.juh();
         return true;
      }
      
      public function libysoti() : Object3D
      {
         return this.kyvedu;
      }
      
      public function dugejobig() : fodolihy
      {
         return this.til;
      }
      
      public function lesebymeb() : cuvamywe
      {
         return this.wyqitywi;
      }
      
      public function vyr() : void
      {
         this.wyqitywi.nyzydec(this.mij.hifajy());
      }
   }
}

