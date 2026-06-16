package alternativa.tanks.sfx.flamethrower
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import daz.fyweci;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   import gafaduzuw.finajylom;
   import gafaduzuw.fode;
   import gafaduzuw.kyhewil;
   import hygal.nufaneqog;
   import kefy.Wopowur;
   import kefy.fare;
   import kihi.qedozeze;
   import alternativa.tanks.sfx.bowu;
   import alternativa.tanks.sfx.dosu;
   import alternativa.tanks.sfx.pybalutu;
   import pekiv.sumik;
   import tutorial.commons.Assets;
   import zicy.nocyquk;
   
   public class StreamWeaponGraphicEffect extends Wopowur implements bowu
   {
      
      private static const migeru:int = 20;
      
      private static const dygusuf:Number = 3;
      
      private static const gijalatyt:fode = new fode();
      
      private static const bul:kyhewil = new kyhewil();
      
      private static const fybumu:finajylom = new finajylom();
      
      private static const ruda:finajylom = new finajylom();
      
      private static const rygapyv:finajylom = new finajylom();
      
      private static const dizecoca:finajylom = new finajylom();
      
      private static const rinego:finajylom = new finajylom();
      
      private static const tefydiw:qedozeze = new qedozeze();
      
      private var judawohof:Number;
      
      private var marehod:Number;
      
      private var niq:Number;
      
      private var toqumyc:finajylom = new finajylom();
      
      private var firaqe:Object3D;
      
      private var dymojes:govo;
      
      private var kymaqos:nocyquk;
      
      private var kygipiz:Vector.<lyhyzi> = new Vector.<lyhyzi>(migeru);
      
      private var jadeqy:Number;
      
      private var qyz:Number;
      
      private var lecopojen:int;
      
      private var bumypaz:int;
      
      private var gutebovu:int;
      
      private var danewazam:Object3DContainer;
      
      private var huzoqeq:Boolean;
      
      private var fyqih:StreamWeaponMuzzlePlane;
      
      private var taramuty:fyweci;
      
      private var molehyzuv:Number;
      
      private var binijosom:Number;
      
      private var nel:Number;
      
      private var tizymaku:Number;
      
      public function StreamWeaponGraphicEffect(param1:fare)
      {
         super(param1);
         this.fyqih = new StreamWeaponMuzzlePlane();
      }
      
      public function init(param1:fyweci, param2:Number, param3:Number, param4:Number, param5:finajylom, param6:Object3D, param7:govo, param8:nocyquk, param9:Number, param10:Number, param11:Number, param12:Number, param13:Number, param14:Number) : void
      {
         this.taramuty = param1;
         this.judawohof = param2;
         this.marehod = Math.tan(0.5 * param3);
         this.niq = param4;
         this.toqumyc.disy(param5);
         this.firaqe = param6;
         this.dymojes = param7;
         this.kymaqos = param8;
         this.molehyzuv = param11;
         this.binijosom = param12;
         this.nel = param13;
         this.tizymaku = param14;
         param7.tazequd = Assets.getData("flame_muzzle",dosu);
         this.fyqih.hijowase(param9,param10);
         this.jadeqy = 2 * (param12 - param11) / param2;
         this.qyz = 1000 * param2 / (migeru * param4);
         this.gutebovu = 0;
         this.lecopojen = this.bumypaz = getTimer();
         this.initMuzzlePlane(param7);
         this.huzoqeq = false;
      }
      
      private function initMuzzlePlane(param1:govo) : void
      {
         var _loc2_:siwewuvu = null;
         var _loc3_:ColorTransform = null;
         this.fyqih.init(param1.tazequd);
         if(param1.jowufeq != null)
         {
            _loc2_ = param1.jowufeq[0];
            _loc3_ = this.fyqih.colorTransform == null ? new ColorTransform() : this.fyqih.colorTransform;
            _loc3_.alphaMultiplier = _loc2_.fidemujil;
            _loc3_.alphaOffset = _loc2_.jadig;
            _loc3_.redMultiplier = _loc2_.kukuv;
            _loc3_.redOffset = _loc2_.goror;
            _loc3_.greenMultiplier = _loc2_.bofo;
            _loc3_.greenOffset = _loc2_.ruh;
            _loc3_.blueMultiplier = _loc2_.zybyjaweb;
            _loc3_.blueOffset = _loc2_.totejigi;
            this.fyqih.colorTransform = _loc3_;
         }
         else
         {
            this.fyqih.colorTransform = null;
         }
      }
      
      public function destroy() : void
      {
         while(this.gutebovu > 0)
         {
            this.removeParticle(0);
         }
         this.fyqih.removeFromParent();
         this.fyqih.clear();
         this.danewazam = null;
         this.taramuty = null;
         this.firaqe = null;
         this.dymojes = null;
         this.kymaqos = null;
         recycle();
      }
      
      public function play(param1:int, param2:nufaneqog) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc5_:lyhyzi = null;
         var _loc6_:finajylom = null;
         var _loc7_:Number = NaN;
         this.calculateParameters();
         _loc3_ = param1 / 1000;
         if(this.kymaqos.jityw(fybumu,ruda,sumik.neli,this.toqumyc.zofydizug + this.fyqih.nyhuguty,null,tefydiw))
         {
            this.fyqih.visible = false;
         }
         else
         {
            this.fyqih.visible = true;
            this.fyqih.update(_loc3_,this.dymojes.tazequd.macoqaka);
            pybalutu.teg(this.fyqih,rinego,ruda,param2.position);
         }
         if(!this.huzoqeq && this.gutebovu < migeru && this.lecopojen >= this.bumypaz)
         {
            this.bumypaz += this.qyz;
            this.addParticle();
         }
         var _loc4_:int = 0;
         while(_loc4_ < this.gutebovu)
         {
            _loc5_ = this.kygipiz[_loc4_];
            dizecoca.kan = _loc5_.x;
            dizecoca.zofydizug = _loc5_.y;
            dizecoca.qyririg = _loc5_.z;
            if(_loc5_.hyn > this.judawohof || Boolean(this.kymaqos.jityw(dizecoca,_loc5_.zerus,sumik.deli,_loc3_,null,tefydiw)))
            {
               this.removeParticle(_loc4_--);
            }
            else
            {
               _loc6_ = _loc5_.zerus;
               _loc5_.x += _loc6_.kan * _loc3_;
               _loc5_.y += _loc6_.zofydizug * _loc3_;
               _loc5_.z += _loc6_.qyririg * _loc3_;
               _loc5_.hyn += this.niq * _loc3_;
               _loc5_.rotation += dygusuf * _loc3_ * _loc5_.huved;
               _loc5_.les(_loc5_.tyfu);
               _loc5_.tyfu += this.dymojes.qywyr.macoqaka * _loc3_;
               _loc7_ = this.molehyzuv + this.jadeqy * _loc5_.hyn;
               if(_loc7_ > this.binijosom)
               {
                  _loc7_ = this.binijosom;
               }
               _loc5_.width = _loc7_;
               _loc5_.height = _loc7_;
               _loc5_.tehyqifu(this.judawohof,this.dymojes.qob);
            }
            _loc4_++;
         }
         this.lecopojen += param1;
         return !this.huzoqeq || this.gutebovu > 0;
      }
      
      public function kill() : void
      {
         if(!this.huzoqeq)
         {
            this.huzoqeq = true;
            this.fyqih.removeFromParent();
         }
      }
      
      public function addedToScene(param1:Object3DContainer) : void
      {
         this.danewazam = param1;
         param1.addChild(this.fyqih);
      }
      
      private function calculateParameters() : void
      {
         var _loc1_:Number = NaN;
         bul.lowefuwi(this.firaqe.x,this.firaqe.y,this.firaqe.z,this.firaqe.rotationX,this.firaqe.rotationY,this.firaqe.rotationZ);
         rygapyv.kan = bul.gusat;
         rygapyv.zofydizug = bul.sig;
         rygapyv.qyririg = bul.vug;
         ruda.kan = bul.cydop;
         ruda.zofydizug = bul.qanezycap;
         ruda.qyririg = bul.luwym;
         bul.japoniw(this.toqumyc,rinego);
         _loc1_ = Number(this.toqumyc.zofydizug);
         fybumu.kan = rinego.kan - _loc1_ * ruda.kan;
         fybumu.zofydizug = rinego.zofydizug - _loc1_ * ruda.zofydizug;
         fybumu.qyririg = rinego.qyririg - _loc1_ * ruda.qyririg;
      }
      
      private function addParticle() : void
      {
         var _loc1_:Number = this.nel + Math.random() * this.tizymaku;
         if(!this.fyqih.visible && tefydiw.jomuc < this.toqumyc.zofydizug + _loc1_)
         {
            return;
         }
         var _loc2_:lyhyzi = lyhyzi.bytupugif();
         _loc2_.vigipu(this.dymojes.qywyr);
         _loc2_.rotation = Math.random() * Math.PI * 2;
         _loc2_.tyfu = Math.random() * _loc2_.nawirales();
         this.getParticleFlightDirection(ruda);
         _loc2_.zerus.kan = this.niq * ruda.kan;
         _loc2_.zerus.zofydizug = this.niq * ruda.zofydizug;
         _loc2_.zerus.qyririg = this.niq * ruda.qyririg;
         _loc2_.zerus.kyluwuzi(this.taramuty.kejo.zerus);
         _loc2_.hyn = _loc1_;
         _loc2_.x = rinego.kan + _loc1_ * ruda.kan;
         _loc2_.y = rinego.zofydizug + _loc1_ * ruda.zofydizug;
         _loc2_.z = rinego.qyririg + _loc1_ * ruda.qyririg;
         _loc2_.huved = Math.random() < 0.5 ? 1 : -1;
         this.kygipiz[this.gutebovu++] = _loc2_;
         this.danewazam.addChild(_loc2_);
      }
      
      private function removeParticle(param1:int) : void
      {
         var _loc2_:lyhyzi = this.kygipiz[param1];
         this.kygipiz[param1] = this.kygipiz[--this.gutebovu];
         this.kygipiz[this.gutebovu] = null;
         _loc2_.dispose();
      }
      
      private function getParticleFlightDirection(param1:finajylom) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = 2 * Math.PI * Math.random();
         gijalatyt.dekod(param1,_loc2_);
         rygapyv.jec(gijalatyt);
         _loc3_ = this.judawohof * this.marehod * Math.random();
         param1.kan = param1.kan * this.judawohof + rygapyv.kan * _loc3_;
         param1.zofydizug = param1.zofydizug * this.judawohof + rygapyv.zofydizug * _loc3_;
         param1.qyririg = param1.qyririg * this.judawohof + rygapyv.qyririg * _loc3_;
         param1.behy();
      }
      
      public function get particles() : Vector.<lyhyzi>
      {
         return this.kygipiz;
      }
      
      public function get numParticles() : int
      {
         return this.gutebovu;
      }
      
      public function get range() : Number
      {
         return this.judawohof;
      }
   }
}

