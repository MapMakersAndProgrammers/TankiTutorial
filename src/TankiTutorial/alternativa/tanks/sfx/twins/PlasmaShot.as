package alternativa.tanks.sfx.twins
{
   import alternativa.engine3d.containers.KDContainer;
   import daz.fyweci;
   import daz.hivymop;
   import fyf.dinomyvi;
   import fyf.vuteci;
   import gafaduzuw.finajylom;
   import gafaduzuw.fode;
   import kefy.Wopowur;
   import kefy.fare;
   import kefy.lalyna;
   import alternativa.physics.collision.types.qedozeze;
   import kulo.huv;
   import alternativa.tanks.battle.litavepot;
   import alternativa.tanks.battle.qujimowo;
   import alternativa.tanks.battle.zocikydo;
   import alternativa.tanks.sfx.cyp;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.sfx.dosu;
   import alternativa.tanks.sfx.mirir;
   import alternativa.tanks.sfx.AnimatedLightEffect;
   import alternativa.tanks.sfx.LightData;
   import alternativa.tanks.sfx.virah;
   import alternativa.tanks.sfx.AnimatedSpriteEffect;
   import alternativa.tanks.vehicles.tank.Tank;
   import pekiv.sumik;
   import qoweve.benesihys;
   import tutorial.commons.Assets;
   import zicy.nocyquk;
   import zicy.wagoc;
   
   public class PlasmaShot extends Wopowur implements qujimowo, zocikydo, wagoc, litavepot
   {
      
      private static var mofibimap:dosu;
      
      private static var fid:dosu;
      
      public static const tezesulal:Number = 250;
      
      public static const boker:Number = 300;
      
      private static const zily:int = 1000;
      
      private static const jydihab:Number = 30;
      
      private static const fenuf:int = 8;
      
      private static const vogilyta:Number = 2 * Math.PI / fenuf;
      
      private static const gizynuzelu:fode = new fode();
      
      private static const hifoca:finajylom = new finajylom();
      
      private static const wonuhig:qedozeze = new qedozeze();
      
      private static const vytaf:finajylom = new finajylom();
      
      public static const qyk:Number = 6000;
      
      public static const qulif:Number = 9000;
      
      public static const japycepef:Number = 50;
      
      private static const gov:hivymop = vuteci.gov;
      
      private static const guzinizub:KDContainer = vuteci.guzinizub;
      
      private static const murow:lalyna = vuteci.murow;
      
      private static const hobuna:dinomyvi = vuteci.hobuna;
      
      private static const jypadif:benesihys = vuteci.jypadif;
      
      private static const neputi:finajylom = new finajylom();
      
      private const kamog:finajylom = new finajylom();
      
      private var taramuty:fyweci;
      
      private var kovi:finajylom = new finajylom();
      
      private var vedebuweb:Number;
      
      private var jac:Boolean;
      
      private var guripovec:finajylom = new finajylom();
      
      private var penybuke:finajylom = new finajylom();
      
      private var fybumu:finajylom = new finajylom();
      
      private var zeneti:finajylom = new finajylom();
      
      private var cekyno:Vector.<finajylom>;
      
      private var ruv:Number = 0;
      
      private var wahy:cyp;
      
      private var nomupiz:int;
      
      private var lamutameq:Number;
      
      private var beryfitu:Number;
      
      public var bogepulah:virah = LightData.zup;
      
      public var cilug:virah = LightData.fid;
      
      private var veliqe:AnimatedLightEffect;
      
      private var kig:mirir;
      
      public function PlasmaShot(param1:fare)
      {
         super(param1);
         this.cekyno = new Vector.<finajylom>(fenuf);
         var _loc2_:int = 0;
         while(_loc2_ < fenuf)
         {
            this.cekyno[_loc2_] = new finajylom();
            _loc2_++;
         }
         this.wahy = new cyp(tezesulal,tezesulal);
      }
      
      private static function getMostOrthogonalAxis(param1:finajylom, param2:finajylom) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = 10000000000;
         var _loc5_:Number = param1.kan < 0 ? -param1.kan : Number(param1.kan);
         if(_loc5_ < _loc4_)
         {
            _loc4_ = _loc5_;
            _loc3_ = 0;
         }
         _loc5_ = param1.zofydizug < 0 ? -param1.zofydizug : Number(param1.zofydizug);
         if(_loc5_ < _loc4_)
         {
            _loc4_ = _loc5_;
            _loc3_ = 1;
         }
         _loc5_ = param1.qyririg < 0 ? -param1.qyririg : Number(param1.qyririg);
         if(_loc5_ < _loc4_)
         {
            _loc3_ = 2;
         }
         switch(_loc3_)
         {
            case 0:
               param2.kan = 0;
               param2.zofydizug = param1.qyririg;
               param2.qyririg = -param1.zofydizug;
               break;
            case 1:
               param2.kan = -param1.qyririg;
               param2.zofydizug = 0;
               param2.qyririg = param1.kan;
               break;
            case 2:
               param2.kan = param1.zofydizug;
               param2.zofydizug = -param1.kan;
               param2.qyririg = 0;
         }
      }
      
      public function init(param1:Number, param2:Number) : void
      {
         if(mofibimap == null)
         {
            mofibimap = Assets.getData("plasma",dosu);
         }
         this.vedebuweb = param1;
         this.beryfitu = param2;
         this.wahy.vigipu(mofibimap);
         this.nomupiz = this.wahy.nawirales();
         this.lamutameq = this.nomupiz * Math.random();
         this.wahy.rotation = huv.qubabyby * Math.random();
         this.ruv = 0;
         this.jac = true;
      }
      
      public function addToGame(param1:finajylom, param2:finajylom, param3:finajylom, param4:fyweci) : void
      {
         this.fybumu.disy(param1);
         this.guripovec.disy(param2);
         this.penybuke.disy(param2);
         this.zeneti.disy(param2);
         this.wahy.x = param2.kan;
         this.wahy.y = param2.zofydizug;
         this.wahy.z = param2.qyririg;
         this.kovi.disy(param3);
         this.taramuty = param4;
         this.veliqe = AnimatedLightEffect(murow.loq(AnimatedLightEffect));
         this.kig = mirir(murow.loq(mirir));
         this.kig.setPosition(param2);
         this.veliqe.init(this.kig,this.bogepulah,AnimatedLightEffect.nimowu,true);
         hobuna.jyqinosi(this.veliqe);
         gov.dufuredi(this);
         gov.gyvefohip(this);
         jypadif.dopus(this);
      }
      
      public function runBeforePhysicsUpdate(param1:Number) : void
      {
         var _loc5_:finajylom = null;
         var _loc2_:nocyquk = gov.secakesem;
         if(this.jac)
         {
            if(this.processFirstTick(_loc2_))
            {
               return;
            }
            this.jac = false;
         }
         if(this.ruv > qyk)
         {
            this.destroy();
            return;
         }
         var _loc3_:Number = qulif * param1;
         this.ruv += _loc3_;
         if(_loc2_.nep(this.guripovec,this.kovi,sumik.pisyse,_loc3_,this,wonuhig))
         {
            this.applyImpact(wonuhig.vetudozi.body,wonuhig.position,this.kovi,this.ruv);
            this.destroy();
            return;
         }
         this.kamog.disy(this.kovi).rudi(_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < fenuf)
         {
            _loc5_ = this.cekyno[_loc4_];
            if(_loc2_.nep(_loc5_,this.kovi,sumik.pisyse,_loc3_,this,wonuhig))
            {
               if(wonuhig.vetudozi.body != null)
               {
                  this.applyImpact(wonuhig.vetudozi.body,wonuhig.position,this.kovi,this.ruv);
                  this.destroy();
                  return;
               }
            }
            _loc5_.kyluwuzi(this.kamog);
            _loc4_++;
         }
         this.penybuke.disy(this.guripovec);
         this.guripovec.kyluwuzi(this.kamog);
      }
      
      public function render(param1:int, param2:int) : void
      {
         if(!this.jac && this.wahy._parent == null)
         {
            guzinizub.addChild(this.wahy);
         }
         var _loc3_:Number = param2 / zily;
         this.wahy.les(this.lamutameq);
         this.lamutameq += jydihab * _loc3_;
         if(this.lamutameq >= this.nomupiz)
         {
            this.lamutameq = 0;
         }
         var _loc4_:Number = tezesulal;
         this.wahy.width = _loc4_;
         this.wahy.height = _loc4_;
         this.wahy.x = this.zeneti.kan;
         this.wahy.y = this.zeneti.zofydizug;
         this.wahy.z = this.zeneti.qyririg;
         this.wahy.rotation -= 3 * _loc3_;
         this.kig.setPosition(this.zeneti);
      }
      
      public function destroy() : void
      {
         this.wahy.removeFromParent();
         this.taramuty = null;
         this.wahy.material = null;
         this.wahy.colorTransform = null;
         gov.wizosigy(this);
         gov.buj(this);
         jypadif.gebi(this);
         this.veliqe.kill();
         this.veliqe = null;
         this.kig = null;
         recycle();
      }
      
      public function considerBody(param1:fyweci) : Boolean
      {
         return this.taramuty != param1;
      }
      
      private function initRadialPoints(param1:finajylom, param2:finajylom, param3:Number) : void
      {
         getMostOrthogonalAxis(param2,vytaf);
         vytaf.behy().rudi(param3);
         gizynuzelu.dekod(param2,vogilyta);
         finajylom(this.cekyno[0]).disy(param1).kyluwuzi(vytaf);
         var _loc4_:int = 1;
         while(_loc4_ < fenuf)
         {
            vytaf.jec(gizynuzelu);
            finajylom(this.cekyno[_loc4_]).disy(param1).kyluwuzi(vytaf);
            _loc4_++;
         }
      }
      
      private function createExplosionEffect(param1:finajylom, param2:Number) : void
      {
         if(fid == null)
         {
            fid = Assets.getData("plasma_exp",dosu);
         }
         var _loc3_:int = 50 + boker * 0.5;
         var _loc4_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(murow.loq(StaticObject3DPositionProvider));
         _loc4_.init(param1,_loc3_);
         var _loc5_:Number = boker * (1 + param2) / 2;
         var _loc6_:AnimatedSpriteEffect = AnimatedSpriteEffect(murow.loq(AnimatedSpriteEffect));
         var _loc7_:int = 20;
         _loc6_.init(_loc5_,_loc5_,fid,huv.qubabyby * Math.random(),_loc7_,_loc4_,0.5,0.5,null);
         hobuna.jyqinosi(_loc6_);
         this.createExplsionLightEffect(param1);
      }
      
      private function createExplsionLightEffect(param1:finajylom) : void
      {
         var _loc2_:int = 50 + boker * 0.5;
         var _loc3_:AnimatedLightEffect = AnimatedLightEffect(murow.loq(AnimatedLightEffect));
         var _loc4_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(murow.loq(StaticObject3DPositionProvider));
         _loc4_.init(param1,_loc2_);
         _loc3_.init(_loc4_,this.cilug);
         hobuna.jyqinosi(_loc3_);
      }
      
      private function applyImpact(param1:fyweci, param2:finajylom, param3:finajylom, param4:Number) : void
      {
         var _loc5_:Tank = null;
         this.createExplosionEffect(param2,1);
         if(param1 != null)
         {
            _loc5_ = param1.katuf as Tank;
            if(_loc5_ != null)
            {
               param1.hogetuwi(param2,param3,this.vedebuweb);
               _loc5_.substructHealth(this.beryfitu);
            }
         }
      }
      
      private function processFirstTick(param1:nocyquk) : Boolean
      {
         var _loc6_:finajylom = null;
         var _loc7_:fyweci = null;
         hifoca.disy(this.guripovec);
         var _loc2_:Number = japycepef;
         hifoca.qyririg += _loc2_;
         if(param1.nep(hifoca,finajylom.lasis,sumik.neli,_loc2_,null,wonuhig))
         {
            this.applyImpact(null,wonuhig.position,null,0);
            this.destroy();
            return true;
         }
         var _loc3_:finajylom = neputi;
         _loc3_.vaw(this.guripovec,this.fybumu);
         var _loc4_:Number = Number(_loc3_.nyhuguty());
         _loc3_.behy();
         if(param1.nep(this.fybumu,_loc3_,sumik.deli,_loc4_,this,wonuhig))
         {
            this.fybumu.lopyvan(wonuhig.jomuc,_loc3_);
            this.applyImpact(wonuhig.vetudozi.body,this.fybumu,_loc3_,0);
            this.destroy();
            return true;
         }
         this.initRadialPoints(this.fybumu,_loc3_,_loc2_);
         var _loc5_:int = 0;
         while(_loc5_ < fenuf)
         {
            _loc6_ = this.cekyno[_loc5_];
            if(param1.nep(_loc6_,this.kovi,sumik.deli,_loc4_,this,wonuhig))
            {
               _loc7_ = wonuhig.vetudozi.body;
               if(_loc7_ != null)
               {
                  this.fybumu.lopyvan(wonuhig.jomuc,_loc3_);
                  this.applyImpact(_loc7_,this.fybumu,_loc3_,0);
                  this.destroy();
                  return true;
               }
            }
            _loc5_++;
         }
         this.initRadialPoints(this.guripovec,this.kovi,_loc2_);
         return false;
      }
      
      public function interpolatePhysicsState(param1:Number) : void
      {
         this.zeneti.lir(param1,this.penybuke,this.guripovec);
      }
   }
}

