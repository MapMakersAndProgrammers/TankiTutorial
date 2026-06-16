package alternativa.tanks.vehicles.tank
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.objects.Mesh;
   import befifijoj.jarod;
   import danufabo.let;
   import daz.fyweci;
   import daz.hivymop;
   import daz.vywamy;
   import duqy.lozuqywi;
   import duqy.sizud;
   import flash.display.BitmapData;
   import flash.media.Sound;
   import flash.utils.setTimeout;
   import fyf.nygujygaw;
   import fyf.qon;
   import fyf.vuteci;
   import gafaduzuw.finajylom;
   import gafaduzuw.fode;
   import gafaduzuw.kyhewil;
   import gafaduzuw.zybek;
   import hygal.nufaneqog;
   import jem.viqyr;
   import kefy.lalyna;
   import kodoq.hapafal;
   import alternativa.tanks.battle.litavepot;
   import alternativa.tanks.battle.qujimowo;
   import alternativa.tanks.battle.zocikydo;
   import alternativa.tanks.sfx.hefova;
   import alternativa.tanks.sfx.hubumeno;
   import alternativa.tanks.sfx.kulog;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import pekiv.sumik;
   import qoweve.benesihys;
   import tup.detamonuk;
   import tutorial.commons.Assets;
   import zicy.Peruvec;
   import zimeko.sagokibo;
   import zur.qaselo;
   
   public class Tank implements Lifa, zocikydo, qujimowo, litavepot, Peruvec
   {
      
      private static const radanigys:Number = 0.4;
      
      private static const lilotes:finajylom = new finajylom();
      
      private static const wokymityf:fode = new fode();
      
      private static const qef:kyhewil = new kyhewil();
      
      private static const rizy:kyhewil = new kyhewil();
      
      private static const qalolyris:finajylom = new finajylom();
      
      private static const dedit:finajylom = new finajylom();
      
      private static const hyqirufy:finajylom = new finajylom();
      
      private static const jygef:finajylom = new finajylom();
      
      private static const baven:finajylom = new finajylom();
      
      private static const gof:finajylom = new finajylom();
      
      private const zeneti:finajylom = new finajylom();
      
      private const lobozofeh:zybek = new zybek();
      
      private var jifav:pulunad = new paco(100,1000,0,0);
      
      private var vibewyge:pulunad = new paco(0.3,10,0,0);
      
      private const bijatil:viqyr = vuteci.bijatil;
      
      private const guzinizub:KDContainer = vuteci.guzinizub;
      
      private const butefu:nufaneqog = vuteci.butefu;
      
      private const gov:hivymop = vuteci.gov;
      
      private const murow:lalyna = vuteci.murow;
      
      private const jypadif:benesihys = vuteci.jypadif;
      
      private var civacofo:Vector.<finajylom>;
      
      private var nyryp:Number = 0;
      
      public var nariw:fohynopil;
      
      public var firaqe:pezynopo;
      
      public var hogys:sagokibo;
      
      private var tuwykus:Number;
      
      private var fusisywa:int;
      
      private var bedepidy:Number = 0;
      
      public var kuca:detamonuk;
      
      private var quj:Number;
      
      private var wibo:Number;
      
      public var kat:Boolean;
      
      private var tasapupat:qaselo;
      
      public var kakow:jarod;
      
      public var lysecof:kulog;
      
      private var wom:Boolean;
      
      private var zafutonaz:String;
      
      private const zywanywy:finajylom = new finajylom();
      
      private const josi:zybek = new zybek();
      
      private const faqes:finajylom = new finajylom();
      
      private const wykuc:zybek = new zybek();
      
      private var mum:let;
      
      private var momomafoj:Number = 0;
      
      public var fysa:Number;
      
      private var gobo:lozuqywi = new lozuqywi();
      
      private var hag:makyfa;
      
      private var viqi:bydewyhij;
      
      private var diniqu:Boolean = false;
      
      public function Tank()
      {
         super();
         this.kuca = new detamonuk();
      }
      
      public function get body() : fyweci
      {
         if(this.hogys == null)
         {
            throw new Error();
         }
         return this.hogys.body;
      }
      
      public function setWeaponDamageMultiplier(param1:Number) : void
      {
         if(this.tasapupat != null)
         {
            this.tasapupat.kuqy = param1;
         }
      }
      
      private function setMaxHealth(param1:Number) : void
      {
         this.wibo = param1;
         this.quj = this.wibo;
      }
      
      public function substructHealth(param1:Number) : void
      {
         if(this == vuteci.jifom && this.quj <= this.wibo * 0.5)
         {
            this.quj -= this.quj / this.wibo * param1;
         }
         else
         {
            this.quj -= param1;
         }
         if(this.quj < 0)
         {
            this.quj = 0;
         }
         if(this.kakow != null)
         {
            this.kakow.feb(this.quj,this.wibo);
         }
      }
      
      public function get currentHealth() : Number
      {
         return this.quj;
      }
      
      public function init(param1:String, param2:String, param3:String, param4:Number = 0) : void
      {
         if(param4 > 0)
         {
            this.momomafoj = param4;
         }
         this.zafutonaz = param3;
         this.setHull(param1);
         this.setTurret(param2);
         this.setColormap(param3);
      }
      
      public function setHull(param1:String) : void
      {
         var _loc3_:Mesh = null;
         var _loc4_:finajylom = null;
         var _loc2_:fohynopil = qon.leqib[param1];
         if(_loc2_ == null)
         {
            throw new ArgumentError("Hull is null");
         }
         if(this.nariw != _loc2_)
         {
            this.gobo.miqelina = _loc2_.sasi;
            this.setMaxHealth(this.momomafoj > 0 ? this.momomafoj : Number(_loc2_.quj));
            this.nariw = _loc2_;
            this.kuca.setHull(_loc2_);
            this.tuwykus = _loc2_.tuwykus;
            this.setMaxSpeed(_loc2_.wiciqy,true);
            this.setMaxTurnSpeed(_loc2_.pyfika,true);
            _loc3_ = _loc2_.kuca;
            _loc3_.calculateBounds();
            _loc4_ = new finajylom(2 * _loc3_.boundMaxX,2 * _loc3_.boundMaxY,_loc3_.boundMaxZ);
            this.createBody(this.tuwykus,_loc4_);
            this.createChassis(_loc4_,_loc2_);
            this.setOptimalZCorrection(_loc4_);
            this.setBodyCollisionGroup(sumik.pisyse | sumik.bywowe | sumik.deli | sumik.nuqa);
            this.setTracksCollisionGroup(sumik.bywowe);
         }
      }
      
      private function createBody(param1:Number, param2:finajylom) : void
      {
         var _loc4_:fyweci = null;
         if(this.hogys == null)
         {
            _loc4_ = new fyweci(param1,fode.nyra);
            _loc4_.katuf = this;
            this.hogys = new sagokibo(_loc4_);
         }
         var _loc3_:finajylom = param2.bet();
         _loc3_.rudi(0.5);
         vywamy.fyb(param1,_loc3_,this.hogys.body.wofurys);
         this.hogys.body.tuwykus = param1;
         this.hogys.body.jutelycu = 1 / param1;
         this.createCollisionPrimitives(_loc3_);
         this.createVisibilityPoints(_loc3_);
      }
      
      private function createCollisionPrimitives(param1:finajylom) : void
      {
         this.hogys.vaf();
         var _loc2_:Number = 2 * param1.qyririg - (this.gobo.vocuqih - leja.kyr);
         sof.vof(param1,_loc2_,this.hogys);
         sof.lyl(param1,_loc2_,this.hogys);
         this.setBoundSphereRadius(param1,_loc2_);
      }
      
      private function setBoundSphereRadius(param1:finajylom, param2:Number) : void
      {
         var _loc3_:finajylom = new finajylom(param1.kan,param1.zofydizug,param2 / 2);
         var _loc4_:kyhewil = this.hogys.kyripama.koma;
         this.fysa = _loc3_.nyhuguty() + Math.abs(_loc4_.sunafepo);
      }
      
      private function createVisibilityPoints(param1:finajylom) : void
      {
         var _loc2_:Number = Number(param1.kan);
         var _loc3_:Number = Number(param1.zofydizug);
         this.civacofo = Vector.<finajylom>([new finajylom(-_loc2_,_loc3_,0),new finajylom(_loc2_,_loc3_,0),new finajylom(-_loc2_,0,0),new finajylom(_loc2_,0,0),new finajylom(-_loc2_,-_loc3_,0),new finajylom(_loc2_,-_loc3_,0)]);
      }
      
      private function createChassis(param1:finajylom, param2:fohynopil) : void
      {
         this.hag = new makyfa(this.hogys.body,this.gobo,this.jifav,param1);
         this.hag.wiwewiq(param2.cozo);
         this.hag.cofo(param2.qezuw);
         this.hag.valita(param2.wito);
         this.hag.zyko(param2.qupi);
         this.hag.ziryd(param2.beg);
         this.viqi = new bydewyhij(this.hag,this.kuca,this.jifav);
      }
      
      public function setTurret(param1:String) : void
      {
         var _loc2_:pezynopo = nygujygaw.leqib[param1];
         if(_loc2_ == null)
         {
            throw new ArgumentError("Turret is null");
         }
         if(this.firaqe != _loc2_)
         {
            if(this.tasapupat != null)
            {
               this.tasapupat.stop();
            }
            this.tasapupat = nygujygaw.getWeapon(param1);
            if(this.mum != null)
            {
               this.mum.setMaxTurnSpeed(_loc2_.gejebuke,false);
               this.mum.zyko(_loc2_.qupi);
            }
            this.tasapupat.pad(this);
            this.firaqe = _loc2_;
            this.kuca.setTurret(_loc2_);
         }
      }
      
      public function getCameraParams(param1:finajylom, param2:finajylom) : void
      {
         this.lobozofeh.jolujeni(wokymityf);
         lilotes.disy(this.zeneti);
         lilotes.kan += this.nyryp * wokymityf.sivy;
         lilotes.zofydizug += this.nyryp * wokymityf.wyvukog;
         lilotes.qyririg += this.nyryp * wokymityf.tari;
         qef.natam(wokymityf,lilotes);
         var _loc3_:finajylom = this.kuca.cypagy().sih;
         rizy.lowefuwi(_loc3_.kan,_loc3_.zofydizug,_loc3_.qyririg,0,0,vuteci.kumiteva ? Number(this.mum.voza()) : Number(this.mum.wako()));
         rizy.codaz(qef);
         param1.variq(rizy.kyvuru,rizy.zumidynip,rizy.sunafepo);
         param2.variq(rizy.cydop,rizy.qanezycap,rizy.luwym);
      }
      
      public function setMaxSpeed(param1:Number, param2:Boolean) : void
      {
         if(param2)
         {
            this.jifav.variq(param1);
         }
         else
         {
            this.jifav.calokyteb(param1);
         }
      }
      
      public function setMaxTurnSpeed(param1:Number, param2:Boolean) : void
      {
         if(param2)
         {
            this.vibewyge.variq(param1);
         }
         else
         {
            this.vibewyge.calokyteb(param1);
         }
      }
      
      public function setCheckpoint() : void
      {
         this.zywanywy.disy(this.faqes);
         this.josi.disy(this.wykuc);
         this.faqes.disy(this.hogys.body.kejo.position);
         this.wykuc.disy(this.hogys.body.kejo.bej);
      }
      
      public function setColormap(param1:String) : void
      {
         var _loc2_:BitmapData = Assets.getData(param1,BitmapData);
         this.kuca.setColormap(_loc2_);
      }
      
      public function kill() : void
      {
         if(this.mum != null)
         {
            this.mum.neqykud(1);
         }
         this.kat = false;
         this.bijatil.tucuqokeq(this.lysecof);
         hefova.hyw(this);
         this.setColormap("dead");
         if(this.kakow != null)
         {
            this.kakow.von();
         }
         this.hogys.body.kejo.zerus.qyririg += 500;
         this.hogys.body.kejo.fev.variq(2,2,2);
         var _loc1_:Sound3D = Sound3D.create(Assets.getData("tank_explosion",Sound),hubumeno.suwyc,hubumeno.bapewa,hubumeno.fyvilyv,radanigys);
         this.bijatil.jyqinosi(Sound3DEffect.create(this.murow,this.hogys.body.kejo.position,_loc1_,0,0));
      }
      
      public function respawn() : void
      {
         this.kuca.citygebal.visible = false;
         this.kuca.pyjikilyr.visible = false;
         this.kuca.nuvyma.alpha = 0;
         this.bijatil.jyqinosi(this.lysecof);
         this.setColormap(this.zafutonaz);
         this.quj = this.wibo;
         this.hogys.body.nihyhyr(0,0,0);
         this.hogys.body.setPosition(this.zywanywy);
         this.hogys.body.setOrientation(this.josi);
         if(this.mum != null)
         {
            this.mum.variq();
            this.mum.gys(1);
         }
         vuteci.namab.nidodyp(new hapafal(0.2,2));
         setTimeout(this.showAfterRespawn,1000);
      }
      
      private function showAfterRespawn() : void
      {
         this.kuca.citygebal.visible = true;
         this.kuca.pyjikilyr.visible = true;
         this.kuca.nuvyma.alpha = 1;
         if(this.kakow != null)
         {
            this.kakow.kyrir();
         }
         this.kat = true;
      }
      
      public function addToGame() : void
      {
         this.gov.fusofe(this.hogys);
         this.gov.dufuredi(this);
         this.gov.gyvefohip(this);
         this.kat = true;
         this.jypadif.dopus(this);
         this.kuca.bil(this.guzinizub,this.butefu);
         vuteci.gido.addTank(this);
         this.wom = true;
         this.lysecof = new kulog();
         this.lysecof.pad(this);
         this.lysecof.lepuqa = true;
         this.addSoundToSoundManager();
      }
      
      public function addSoundToSoundManager() : void
      {
         if(!this.diniqu)
         {
            this.diniqu = this.bijatil.jyqinosi(this.lysecof);
         }
      }
      
      public function removeFromGame() : void
      {
         this.bijatil.tucuqokeq(this.lysecof);
         this.gov.rehef(this.hogys);
         this.gov.buj(this);
         this.gov.wizosigy(this);
         this.jypadif.gebi(this);
         this.kuca.qeze();
         vuteci.gido.removeTank(this);
         this.wom = false;
      }
      
      public function heal() : void
      {
         this.quj = this.wibo;
      }
      
      public function setMovementParams(param1:int, param2:int, param3:Boolean) : void
      {
         this.hag.rucumopak = param1;
         this.hag.wuzyvodew = param2;
         this.hag.cewubegy = param3;
         this.updateEngineSound();
      }
      
      private function updateEngineSound() : void
      {
         if(this.hag.dajy)
         {
            this.lysecof.norak();
         }
         else if(this.hag.rucumopak != 0)
         {
            this.lysecof.baz();
         }
         else if(this.hag.wuzyvodew != 0)
         {
            this.lysecof.kuw();
         }
         else
         {
            this.lysecof.norak();
         }
      }
      
      public function interpolatePhysicsState(param1:Number) : void
      {
         this.hogys.body.lir(param1,this.zeneti,this.lobozofeh);
         this.lobozofeh.behy();
         if(this.mum != null)
         {
            this.bedepidy = -this.mum.gifagoku(param1);
         }
      }
      
      public function render(param1:int, param2:int) : void
      {
         this.lobozofeh.jolujeni(wokymityf);
         lilotes.disy(this.zeneti);
         lilotes.kan += this.nyryp * wokymityf.sivy;
         lilotes.zofydizug += this.nyryp * wokymityf.wyvukog;
         lilotes.qyririg += this.nyryp * wokymityf.tari;
         this.kuca.luhizoh(lilotes,this.lobozofeh,this.bedepidy);
         var _loc3_:Number = param2 * 0.001;
         this.viqi.hylij(_loc3_);
         lilotes.kan = this.kuca.citygebal.x;
         lilotes.zofydizug = this.kuca.citygebal.y;
         lilotes.qyririg = this.kuca.citygebal.z;
         if(this.tasapupat != null)
         {
            this.tasapupat.update(param1,param2);
         }
         if(this.kakow != null)
         {
            this.kakow.dugujiri(100 * this.tasapupat.tucyjyfid);
            this.kakow.feb(this.quj,this.wibo);
            this.kakow.update(lilotes);
         }
         if(this.mum != null)
         {
            this.mum.mazyja(this.calculateTankDirection());
         }
      }
      
      private function calculateTankDirection() : Number
      {
         this.lobozofeh.jolujeni(wokymityf);
         wokymityf.japoniw(finajylom.nesicuryn,dedit);
         dedit.behy();
         qalolyris.qyririg = this.nyryp;
         lilotes.variq();
         lilotes.jec(wokymityf);
         lilotes.kyluwuzi(this.zeneti);
         qef.natam(wokymityf,lilotes);
         hyqirufy.variq(qef.kyvuru,qef.zumidynip,qef.sunafepo);
         jygef.variq(qef.cydop,qef.qanezycap,qef.luwym);
         jygef.behy();
         baven.disy(finajylom.giv);
         gof.disy(finajylom.pypymu);
         baven.himyfuvyd(dedit);
         gof.himyfuvyd(dedit);
         baven.behy();
         gof.behy();
         var _loc1_:Number = Number(gof.zyfav(jygef));
         var _loc2_:Number = Number(baven.zyfav(jygef));
         return Math.acos(_loc1_) * (_loc2_ > 0 ? -1 : 1);
      }
      
      public function runBeforePhysicsUpdate(param1:Number) : void
      {
         this.fusisywa = 0;
         var _loc2_:Number = Number(this.jifav.update(param1));
         var _loc3_:Number = Number(this.vibewyge.update(param1));
         this.hag.mudicyle(_loc2_,_loc3_,param1);
         this.rotateTurret(param1);
      }
      
      private function rotateTurret(param1:Number) : void
      {
         if(this.mum != null)
         {
            this.mum.juhyzika(param1);
            this.lysecof.wafejazi(this.mum.ralamiqu());
         }
      }
      
      private function setOptimalZCorrection(param1:finajylom) : void
      {
         this.nyryp = 0;
      }
      
      public function getWeapon() : qaselo
      {
         return this.tasapupat;
      }
      
      public function get inGame() : Boolean
      {
         return this.wom;
      }
      
      public function considerBodies(param1:fyweci, param2:fyweci) : Boolean
      {
         if(param1.fosa != null && param2.fosa == null)
         {
            ++Tank(param1.katuf).fusisywa;
         }
         else if(param1.fosa == null && param2.fosa != null)
         {
            ++Tank(param2.katuf).fusisywa;
         }
         return false;
      }
      
      public function setTracksCollisionGroup(param1:int) : void
      {
         this.hag.setTracksCollisionGroup(param1);
      }
      
      public function setBodyCollisionGroup(param1:int) : void
      {
         this.hogys.kyripama.nute = param1;
      }
      
      public function get turretController() : let
      {
         return this.mum;
      }
      
      public function set turretController(param1:let) : void
      {
         this.mum = param1;
         if(this.firaqe != null)
         {
            this.mum.setMaxTurnSpeed(this.firaqe.gejebuke,false);
            this.mum.zyko(this.firaqe.qupi);
         }
      }
      
      public function lockMovement() : void
      {
         this.hag.dajy = true;
         this.updateEngineSound();
      }
      
      public function unlockMovement() : void
      {
         this.hag.dajy = false;
         this.updateEngineSound();
      }
      
      public function getLeftTrack() : sizud
      {
         return this.hag.vapal;
      }
      
      public function getRightTrack() : sizud
      {
         return this.hag.mof;
      }
      
      public function setPosition(param1:finajylom) : void
      {
         this.hogys.body.setPosition(param1);
         this.hogys.body.rudahy();
         this.zeneti.disy(param1);
      }
      
      public function setOrientation(param1:zybek) : void
      {
         this.hogys.body.setOrientation(param1);
         this.hogys.body.rudahy();
         this.lobozofeh.disy(param1);
      }
   }
}

