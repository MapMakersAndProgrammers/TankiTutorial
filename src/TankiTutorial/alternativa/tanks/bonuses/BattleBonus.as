package alternativa.tanks.bonuses
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
   import alternativa.tanks.battle.litavepot;
   import alternativa.tanks.battle.qujimowo;
   import alternativa.tanks.battle.vozaj;
   import alternativa.tanks.battle.zocikydo;
   import alternativa.tanks.sfx.hubumeno;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import pekiv.sumik;
   import zicy.nocyquk;
   
   public class BattleBonus extends Wopowur implements qujimowo, zocikydo, litavepot, Rozokebis
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
      
      private var giqo:BonusMesh;
      
      private var kyvedu:lufoloje;
      
      private var til:Cords;
      
      private var mij:vozaj;
      
      private var pobano:Number = 0;
      
      private var luk:mase;
      
      private var katuf:luculo;
      
      private var nimulul:mase;
      
      private var ledijym:Boolean;
      
      private var wyqitywi:cuvamywe;
      
      private var lywajoqa:Vector.<judidoju> = new Vector.<judidoju>();
      
      private var syligatyl:judidoju;
      
      private var kewi:FallController;
      
      private var lyge:LandingController;
      
      public const nuziged:tugawe = new lojufaqik();
      
      public const lybaluh:tugawe = new lojufaqik();
      
      public const gave:tugawe = new lojufaqik();
      
      private const hery:tugawe = new lojufaqik();
      
      public function BattleBonus(param1:fare)
      {
         super(param1);
         this.wyqitywi = new cuvamywe(this);
         this.kewi = new FallController(this);
         this.lyge = new LandingController(this);
      }
      
      private static function isFlatSurface(param1:finajylom) : Boolean
      {
         return param1.qyririg > rurosecel.bepy;
      }
      
      public function init(param1:mase, param2:mase, param3:luculo, param4:vozaj) : void
      {
         this.luk = param1;
         this.nimulul = param2;
         this.katuf = param3;
         this.mij = param4;
         this.lywajoqa.length = 0;
      }
      
      public function spawn(param1:finajylom, param2:int, param3:Number, param4:Function) : void
      {
         var _loc5_:int = 0;
         this.pobano = param3;
         this.hery.kyluwuzi(param4);
         this.initBonusMesh();
         this.ledijym = false;
         this.lywajoqa.length = 0;
         this.getGroundPointAndNormal(param1,docyqy,peveco);
         if(this.isUnderCeil(param1))
         {
            this.initOnGround(docyqy,peveco);
         }
         else
         {
            this.initAirborne(param1,docyqy,peveco,param2);
            this.wyqitywi.nyzydec(this.mij.hifajy());
            _loc5_ = (docyqy.jepik(param1) - rurosecel.numij) / param3 * 1000;
         }
         this.initRemovalAnimation(_loc5_ + this.katuf.wym - param2);
         if(this.runNextController())
         {
            this.activateRendererAndPhysicsController();
         }
      }
      
      private function initOnGround(param1:finajylom, param2:finajylom) : void
      {
         var _loc3_:Number = NaN;
         divogyvo.variq(0,0,rurosecel.numij);
         if(isFlatSurface(param2))
         {
            fyqynyfy.variq(0,0,this.getStartingAngleZ());
         }
         else
         {
            zekos.juc(finajylom.nesicuryn,param2);
            zekos.behy();
            _loc3_ = Math.acos(param2.qyririg);
            run.dekod(zekos,_loc3_);
            qopo.vajetyw(0,0,this.getStartingAngleZ());
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
         this.updateTriggerFromMesh();
         this.mij.rybigu().miboho(this.giqo);
         this.startGroundSpawnAnimation();
      }
      
      private function startGroundSpawnAnimation() : void
      {
         var _loc1_:qape = qape(this.mij.gezuzec().loq(qape));
         _loc1_.start(this,this.mij);
      }
      
      private function updateTriggerFromMesh() : void
      {
         this.wyqitywi.update(this.giqo.x,this.giqo.y,this.giqo.z,this.giqo.rotationX,this.giqo.rotationY,this.giqo.rotationZ);
      }
      
      private function getStartingAngleZ() : Number
      {
         return Math.PI * 10 * this.nimulul.rodaf / 180;
      }
      
      private function initAirborne(param1:finajylom, param2:finajylom, param3:finajylom, param4:int) : void
      {
         var _loc5_:Number = NaN;
         if(isFlatSurface(param3))
         {
            _loc5_ = this.calculateFallTime(param1,param2);
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
               if(param2.qyririg < tet.position.qyririg && tet.position.qyririg < nuk.qyririg)
               {
                  nuk.lopyvan(rurosecel.numij / param3.qyririg * (nuk.qyririg - tet.position.qyririg) / (nuk.qyririg - param2.qyririg),natyjy);
               }
            }
            _loc5_ = this.calculateFallTime(param1,nuk);
            this.lyge.init(nuk,param3);
            this.lywajoqa.push(this.lyge);
         }
         var _loc6_:Number = nuk.qyririg + rurosecel.numij + rurosecel.wucaruw;
         var _loc7_:Number = this.getStartingAngleZ();
         if(_loc5_ * 1000 <= param4)
         {
            this.giqo.x = param1.kan;
            this.giqo.y = param1.zofydizug;
            this.giqo.z = param2.qyririg + rurosecel.numij;
            this.giqo.rotationZ = _loc7_ + _loc5_ * rurosecel.myr;
            this.updateTriggerFromMesh();
            this.mij.rybigu().miboho(this.giqo);
         }
         else
         {
            this.initParachute();
            this.addAllToScene();
            this.startSpawnAnimation(this.mij);
            this.kewi.init(param1,this.pobano,_loc6_,-_loc5_,param4 / 1000,_loc7_);
            this.lywajoqa.push(this.kewi);
         }
      }
      
      private function isUnderCeil(param1:finajylom) : Boolean
      {
         var _loc2_:nocyquk = this.mij.hifajy().pazoc();
         return _loc2_.woqyte(param1,finajylom.nesicuryn,sumik.neli,manytaq);
      }
      
      private function getGroundPointAndNormal(param1:finajylom, param2:finajylom, param3:finajylom) : void
      {
         var _loc4_:nocyquk = this.mij.hifajy().pazoc();
         if(_loc4_.jityw(param1,finajylom.lasis,sumik.neli,manytaq,null,tet))
         {
            param3.disy(tet.lefugefo);
            param2.disy(tet.position);
         }
         else
         {
            param3.disy(finajylom.nesicuryn);
            param2.disy(param1);
            param2.qyririg -= 1000;
         }
      }
      
      public function get bonusId() : mase
      {
         return this.nimulul;
      }
      
      public function pickup() : void
      {
         this.nuziged.wanemyw();
         this.playPickupSound();
         this.detachParachute();
         this.startPickupAnimation();
         this.destroy();
      }
      
      private function playPickupSound() : void
      {
         var _loc1_:Sound3D = null;
         var _loc2_:finajylom = null;
         if(this.katuf.ruzy != null)
         {
            _loc1_ = Sound3D.create(this.katuf.ruzy,hubumeno.suwyc,hubumeno.bapewa,hubumeno.fyvilyv,0.5);
            _loc2_ = new finajylom(this.giqo.x,this.giqo.y,this.giqo.z);
            this.mij.gimog(Sound3DEffect.create(this.mij.gezuzec(),_loc2_,_loc1_));
         }
      }
      
      private function startPickupAnimation() : void
      {
         var _loc1_:mopiny = mopiny(this.mij.gezuzec().loq(mopiny));
         _loc1_.start(this.giqo,this.mij.rybigu());
         this.giqo = null;
      }
      
      public function remove() : void
      {
         this.lybaluh.wanemyw();
         this.giqo = null;
         this.destroy();
      }
      
      private function destroy() : void
      {
         this.gave.wanemyw();
         this.nuziged.ficituk();
         this.lybaluh.ficituk();
         this.gave.ficituk();
         this.destroyBonusMesh();
         this.destroyParachute();
         this.deactivateRendererAndPhysicsController();
         this.wyqitywi.detudomej();
         this.hery.ficituk();
         this.mij = null;
         this.katuf = null;
         recycle();
      }
      
      private function destroyBonusMesh() : void
      {
         if(this.giqo != null)
         {
            this.mij.rybigu().behukywu(this.giqo);
            this.giqo.recycle();
            this.giqo = null;
         }
      }
      
      private function destroyParachute() : void
      {
         if(this.kyvedu != null)
         {
            this.mij.rybigu().behukywu(this.kyvedu);
            this.kyvedu.recycle();
            this.kyvedu = null;
            this.mij.rybigu().behukywu(this.til);
            this.til.recycle();
            this.til = null;
         }
      }
      
      private function calculateFallTime(param1:finajylom, param2:finajylom) : Number
      {
         return (param1.qyririg - param2.qyririg - rurosecel.numij) / this.pobano;
      }
      
      private function initRemovalAnimation(param1:int) : void
      {
         var _loc2_:RemovalAnimation = RemovalAnimation(this.mij.gezuzec().loq(RemovalAnimation));
         _loc2_.init(this.mij.rybigu(),this,param1);
      }
      
      private function startSpawnAnimation(param1:vozaj) : void
      {
         var _loc2_:zygaqaf = zygaqaf(param1.gezuzec().loq(zygaqaf));
         _loc2_.start(this,param1.rybigu());
      }
      
      private function activateRendererAndPhysicsController() : void
      {
         if(!this.ledijym)
         {
            this.ledijym = true;
            this.mij.hifajy().dufuredi(this);
            this.mij.hifajy().gyvefohip(this);
            this.mij.rybigu().dopus(this,0);
         }
      }
      
      private function initParachute() : void
      {
         if(wapakojy.qifaw())
         {
            this.kyvedu = new lufoloje(this.katuf.vukuzub,this.katuf.berav);
         }
         else
         {
            this.kyvedu = wapakojy.getParachute();
         }
         if(wapakojy.lutyvemu())
         {
            this.til = new Cords(lufoloje.jonoga,rurosecel.numij,lufoloje.lapocar,this.katuf.zerow);
         }
         else
         {
            this.til = wapakojy.getCords();
         }
         this.til.init(this.giqo,this.kyvedu);
      }
      
      private function initBonusMesh() : void
      {
         if(wapakojy.posuvy(this.luk))
         {
            this.giqo = new BonusMesh(this.luk,this.katuf.tipi);
         }
         else
         {
            this.giqo = wapakojy.getBonusMesh(this.luk);
         }
         this.giqo.init();
      }
      
      private function addAllToScene() : void
      {
         this.mij.rybigu().miboho(this.kyvedu);
         this.mij.rybigu().miboho(this.giqo);
         this.mij.rybigu().miboho(this.til);
      }
      
      public function runBeforePhysicsUpdate(param1:Number) : void
      {
         this.syligatyl.runBeforePhysicsUpdate(param1);
      }
      
      private function deactivateRendererAndPhysicsController() : void
      {
         if(this.ledijym)
         {
            this.ledijym = false;
            this.mij.hifajy().wizosigy(this);
            this.mij.hifajy().buj(this);
            this.mij.rybigu().gebi(this,0);
         }
      }
      
      private function detachParachute() : void
      {
         var _loc1_:purywi = null;
         if(this.kyvedu != null)
         {
            _loc1_ = purywi(this.mij.gezuzec().loq(purywi));
            _loc1_.start(this.mij.rybigu(),this.kyvedu,this.til,this.pobano / 2);
            this.kyvedu = null;
            this.til = null;
         }
      }
      
      public function interpolatePhysicsState(param1:Number) : void
      {
         this.syligatyl.interpolatePhysicsState(param1);
      }
      
      public function render(param1:int, param2:int) : void
      {
         this.syligatyl.render();
      }
      
      public function setAlpha(param1:Number) : void
      {
         this.giqo.setAlpha(param1);
         if(this.kyvedu != null)
         {
            this.kyvedu.setAlpha(param1);
            this.til.setAlpha(param1);
         }
      }
      
      public function onTriggerActivated() : void
      {
         this.wyqitywi.detudomej();
         this.hery.wanemyw(this);
      }
      
      public function onTouchGround() : void
      {
         this.detachParachute();
         if(!this.runNextController())
         {
            this.stopMovement();
         }
      }
      
      public function onLandingComplete() : void
      {
         this.stopMovement();
      }
      
      private function stopMovement() : void
      {
         this.deactivateRendererAndPhysicsController();
      }
      
      public function getBonusMesh() : BonusMesh
      {
         return this.giqo;
      }
      
      private function runNextController() : Boolean
      {
         this.syligatyl = this.lywajoqa.pop();
         if(this.syligatyl == null)
         {
            return false;
         }
         this.syligatyl.start();
         return true;
      }
      
      public function getParachute() : Object3D
      {
         return this.kyvedu;
      }
      
      public function getCords() : Cords
      {
         return this.til;
      }
      
      public function getTrigger() : cuvamywe
      {
         return this.wyqitywi;
      }
      
      public function enableTrigger() : void
      {
         this.wyqitywi.nyzydec(this.mij.hifajy());
      }
   }
}

