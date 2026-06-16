package alternativa.tanks.shared.usertitle
{
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.sfx.InventoryItemType;
   import flash.display.BitmapData;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.text.TextFieldAutoSize;
   import flash.utils.getTimer;
   
   public class UserTitle
   {
      
      private static const gijalatyt:Matrix = new Matrix();
      
      private static const dusojan:int = 3000;
      
      private static const nizohe:int = 13;
      
      private static const jajid:int = 13;
      
      private static const bebujizon:int = 3;
      
      private static const qucysu:int = 16;
      
      private static const vicufis:int = -3;
      
      private static const vopafub:int = 2;
      
      private static const retunobi:int = -1;
      
      private static const rotizefaq:int = 4;
      
      private static const fapyv:int = 4;
      
      private static const perus:int = 100;
      
      private static const bon:int = 8;
      
      private static const mycamake:int = 3;
      
      private static const gop:int = 2 * mycamake;
      
      private static const bosemy:Vector.<int> = Vector.<int>([InventoryItemType.gezah,InventoryItemType.ramymep,InventoryItemType.ronura,InventoryItemType.majycy]);
      
      private static const mocedu:GlowFilter = new GlowFilter(0,0.8,4,4,3);
      
      private static const hacevul:Number = 0.002;
      
      private var mojyfod:int;
      
      private var zofahy:int;
      
      private var sprite:Sprite3D;
      
      private var kiqep:Rectangle;
      
      private var girilu:Label;
      
      private var tudapypyk:ProgressBar;
      
      private var ruwyb:ProgressBar;
      
      private var redado:Vector.<EffectIndicator>;
      
      private var fil:int;
      
      private var gycebute:int;
      
      private var lavur:int;
      
      private var butyv:String;
      
      private var quj:int;
      
      private var wibo:int;
      
      private var fyfefi:int;
      
      private var vos:Boolean;
      
      private var tojuhata:ProgressBarSkin = ProgressBarSkin.gify;
      
      private var juvowywa:Boolean = true;
      
      private var lecopojen:int;
      
      private var material:TextureMaterial;
      
      private var zyl:BitmapData;
      
      private var bifejizi:Number;
      
      private var danewazam:Object3DContainer;
      
      private var jiso:Size2D = new Size2D();
      
      public function UserTitle(param1:Number, param2:Object3DContainer)
      {
         super();
         this.bifejizi = param1;
         this.danewazam = param2;
         this.material = new TextureMaterial();
         this.material.name = "title";
         this.sprite = new Sprite3D(100,100,this.material);
         if(param1 == 0)
         {
            this.sprite.name = "title";
         }
         this.sprite.clipping = Clipping.FACE_CLIPPING;
         this.sprite.perspectiveScale = false;
         this.sprite.alpha = 0;
         this.sprite.visible = false;
         this.juvowywa = true;
         this.sprite.useShadowMap = false;
         this.sprite.useLight = false;
      }
      
      public function getTexture() : BitmapData
      {
         return this.zyl;
      }
      
      public function hide() : void
      {
         this.juvowywa = true;
      }
      
      public function hideImmediate() : void
      {
         this.hide();
         this.sprite.alpha = 0.0001;
      }
      
      public function show() : void
      {
         this.juvowywa = false;
      }
      
      public function setConfiguration(param1:int) : void
      {
         if(this.mojyfod != param1)
         {
            this.mojyfod = param1;
            this.updateConfiguration();
         }
      }
      
      public function setRank(param1:int) : void
      {
         if(this.lavur != param1)
         {
            this.lavur = param1;
            if(this.hasAnyFlag(TitleConfigFlags.kiwy))
            {
               this.invalidateConfigFlags(TitleConfigFlags.kiwy | TitleConfigFlags.qoj | TitleConfigFlags.deli | TitleConfigFlags.gibevugus);
            }
         }
      }
      
      public function setLabelText(param1:String) : void
      {
         if(this.butyv != param1)
         {
            this.butyv = param1;
            if(this.hasAnyFlag(TitleConfigFlags.kiwy))
            {
               this.updateConfiguration();
               this.invalidateConfigFlags(TitleConfigFlags.kiwy | TitleConfigFlags.qoj | TitleConfigFlags.deli | TitleConfigFlags.gibevugus);
            }
         }
      }
      
      public function setHealth(param1:int, param2:int) : void
      {
         if(this.tudapypyk == null)
         {
            return;
         }
         if(this.quj != param1)
         {
            this.quj = param1;
            this.invalidateConfigFlags(TitleConfigFlags.qoj);
         }
         if(this.wibo != param2)
         {
            this.wibo = param2;
            this.invalidateConfigFlags(TitleConfigFlags.qoj);
            this.tudapypyk.zabiso = param2;
         }
      }
      
      public function setWeaponStatus(param1:int) : void
      {
         if(this.fyfefi != param1)
         {
            this.fyfefi = param1;
            this.invalidateConfigFlags(TitleConfigFlags.deli);
         }
      }
      
      public function showIndicator(param1:int, param2:int) : void
      {
         var _loc3_:EffectIndicator = null;
         if(this.hasAnyFlag(TitleConfigFlags.gibevugus))
         {
            _loc3_ = this.getEffectIndicatorById(param1);
            if(_loc3_ != null)
            {
               if(_loc3_.isHidden())
               {
                  this.changeVisibleIndicatorsNumber(1);
               }
               _loc3_.show(param2);
            }
         }
      }
      
      public function hideIndicator(param1:int) : void
      {
         var _loc2_:EffectIndicator = null;
         if(this.hasAnyFlag(TitleConfigFlags.gibevugus))
         {
            _loc2_ = this.getEffectIndicatorById(param1);
            if(_loc2_ != null)
            {
               _loc2_.hide();
            }
         }
      }
      
      public function hideIndicators() : void
      {
         var _loc1_:int = 0;
         if(this.hasAnyFlag(TitleConfigFlags.gibevugus) && this.redado != null)
         {
            for each(_loc1_ in bosemy)
            {
               this.hideIndicator(_loc1_);
            }
         }
      }
      
      internal function doHideIndicator(param1:EffectIndicator) : void
      {
         param1.clear(this.zyl);
         this.changeVisibleIndicatorsNumber(-1);
      }
      
      public function update(param1:Vector3) : void
      {
         var _loc4_:EffectIndicator = null;
         this.setPosition(param1);
         var _loc2_:int = getTimer();
         var _loc3_:int = _loc2_ - this.lecopojen;
         this.lecopojen = _loc2_;
         this.updateVisibility(_loc3_);
         if(this.zofahy != 0)
         {
            if(this.isDirtyAndHasOption(TitleConfigFlags.kiwy))
            {
               this.updateLabel();
            }
            if(this.isDirtyAndHasOption(TitleConfigFlags.qoj))
            {
               this.tudapypyk.setSkin(this.tojuhata);
               this.tudapypyk.progress = this.quj;
               this.tudapypyk.draw(this.zyl);
            }
            if(this.isDirtyAndHasOption(TitleConfigFlags.deli))
            {
               this.ruwyb.progress = this.fyfefi;
               this.ruwyb.draw(this.zyl);
            }
            if(this.isDirtyAndHasOption(TitleConfigFlags.gibevugus))
            {
               for each(_loc4_ in this.redado)
               {
                  _loc4_.forceRedraw();
               }
            }
            this.zofahy = 0;
         }
         if(this.hasAnyFlag(TitleConfigFlags.gibevugus))
         {
            this.updateEffectIndicators(_loc2_,_loc3_);
         }
      }
      
      private function isDirtyAndHasOption(param1:int) : Boolean
      {
         return (param1 & this.zofahy & this.mojyfod) == param1;
      }
      
      private function updateEffectIndicators(param1:int, param2:int) : void
      {
         var _loc3_:EffectIndicator = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc5_:int = int(this.redado.length);
         if(this.vos)
         {
            this.vos = false;
            _loc6_ = this.jiso.width + gop - this.fil * qucysu - (this.fil - 1) * fapyv >> 1;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc3_ = this.redado[_loc4_];
               if(_loc3_.isVisible())
               {
                  _loc3_.clear(this.zyl);
               }
               if(!_loc3_.isHidden())
               {
                  _loc3_.setPosition(_loc6_,this.gycebute);
                  _loc6_ += qucysu + fapyv;
               }
               _loc4_++;
            }
         }
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = this.redado[_loc4_];
            _loc3_.update(param1,param2,this.zyl);
            _loc4_++;
         }
      }
      
      private function changeVisibleIndicatorsNumber(param1:int) : void
      {
         this.fil += param1;
         this.vos = true;
      }
      
      private function updateConfiguration() : void
      {
         if(this.mojyfod != 0)
         {
            this.setupTexture();
            this.setupComponents();
         }
      }
      
      private function setupTexture() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.jiso.setToZero();
         if(this.hasAnyFlag(TitleConfigFlags.kiwy))
         {
            this.createLabelComponents();
            this.girilu.text = this.butyv || "";
            this.jiso.setWidth(nizohe + vicufis + this.girilu.textWidth);
            this.jiso.setHeight(jajid);
         }
         if(this.hasAnyFlag(TitleConfigFlags.qoj))
         {
            this.jiso.setWidthIfGreater(perus);
            if(this.hasAnyFlag(TitleConfigFlags.kiwy))
            {
               this.jiso.addHeight(vopafub);
            }
            this.jiso.addHeight(bon);
         }
         if(this.hasAnyFlag(TitleConfigFlags.deli))
         {
            this.jiso.setWidthIfGreater(perus);
            this.jiso.addHeight(retunobi + bon);
         }
         if(this.hasAnyFlag(TitleConfigFlags.gibevugus))
         {
            _loc1_ = 4;
            _loc2_ = _loc1_ * qucysu + (_loc1_ - 1) * fapyv;
            this.jiso.setWidthIfGreater(_loc2_);
            if(this.hasAnyFlag(TitleConfigFlags.kiwy | TitleConfigFlags.qoj))
            {
               this.jiso.addHeight(rotizefaq);
            }
            this.jiso.addHeight(qucysu);
         }
         this.jiso.addWidth(2 * mycamake);
         this.jiso.addHeight(2 * mycamake);
         this.createTexture();
      }
      
      private function createTexture() : void
      {
         var _loc1_:int = this.jiso.width;
         var _loc2_:int = this.jiso.height;
         if(this.zyl == null || this.zyl.width != _loc1_ || this.zyl.height != _loc2_)
         {
            if(this.zyl != null)
            {
               this.zyl.dispose();
            }
            this.zyl = new BitmapData(_loc1_,_loc2_,true,0);
            this.material.texture = this.zyl;
            this.sprite.width = _loc1_;
            this.sprite.height = _loc2_;
            this.kiqep = this.zyl.rect;
            this.invalidateConfigFlags(TitleConfigFlags.kiwy | TitleConfigFlags.qoj | TitleConfigFlags.deli | TitleConfigFlags.gibevugus);
         }
      }
      
      private function setupComponents() : void
      {
         var _loc1_:int = mycamake;
         if(this.hasAnyFlag(TitleConfigFlags.kiwy))
         {
            _loc1_ += jajid;
         }
         var _loc2_:int = this.jiso.width - perus >> 1;
         if(this.hasAnyFlag(TitleConfigFlags.qoj))
         {
            if(this.hasAnyFlag(TitleConfigFlags.kiwy))
            {
               _loc1_ += vopafub;
            }
            this.tudapypyk = new ProgressBar(_loc2_,_loc1_,0,perus,this.tojuhata);
            _loc1_ += bon;
         }
         if(this.hasAnyFlag(TitleConfigFlags.deli))
         {
            _loc1_ += retunobi;
            this.ruwyb = new ProgressBar(_loc2_,_loc1_,100,perus,ProgressBarSkin.mub);
            _loc1_ += bon;
         }
         if(this.hasAnyFlag(TitleConfigFlags.gibevugus))
         {
            _loc1_ += rotizefaq;
            this.gycebute = _loc1_;
            this.createEffectsIndicators();
         }
      }
      
      public function addToContainer() : void
      {
         if(this.sprite.parent == null)
         {
            this.danewazam.addChild(this.sprite);
            this.lecopojen = getTimer();
         }
      }
      
      public function removeFromContainer() : void
      {
         if(this.sprite.parent != null)
         {
            this.sprite.parent.removeChild(this.sprite);
         }
      }
      
      public function setPosition(param1:Vector3) : void
      {
         this.sprite.x = param1.x;
         this.sprite.y = param1.y;
         this.sprite.z = param1.z + this.bifejizi;
      }
      
      public function readPosition(param1:Vector3D) : void
      {
         param1.x = this.sprite.x;
         param1.y = this.sprite.y;
         param1.z = this.sprite.z;
      }
      
      private function invalidateConfigFlags(param1:int) : void
      {
         this.zofahy |= param1 & this.mojyfod;
      }
      
      private function hasAnyFlag(param1:int) : Boolean
      {
         return (param1 & this.mojyfod) != 0;
      }
      
      private function createLabelComponents() : void
      {
         if(this.girilu == null)
         {
            this.girilu = new Label();
            this.girilu.autoSize = TextFieldAutoSize.LEFT;
            this.girilu.thickness = 50;
         }
      }
      
      private function updateLabel() : void
      {
         var _loc1_:BitmapData = this.zyl.clone();
         _loc1_.fillRect(this.kiqep,0);
         var _loc2_:int = nizohe + vicufis + this.girilu.textWidth;
         var _loc3_:int = this.jiso.width - _loc2_ >> 1;
         gijalatyt.tx = _loc3_;
         gijalatyt.ty = mycamake + bebujizon;
         gijalatyt.tx = _loc3_ + nizohe + vicufis;
         gijalatyt.ty = mycamake;
         this.girilu.textColor = this.tojuhata.color;
         _loc1_.draw(this.girilu,gijalatyt,null,null,null,true);
         this.zyl.applyFilter(_loc1_,this.kiqep,new Point(),mocedu);
         _loc1_.dispose();
      }
      
      private function createEffectsIndicators() : void
      {
         var _loc1_:int = 0;
         if(this.redado == null)
         {
            this.redado = new Vector.<EffectIndicator>();
            for each(_loc1_ in bosemy)
            {
               if(_loc1_ == InventoryItemType.gezah)
               {
                  this.redado.push(new EffectIndicator(_loc1_,100000,this,300,0));
               }
               else
               {
                  this.redado.push(new EffectIndicator(_loc1_,dusojan,this,300,30));
               }
            }
         }
      }
      
      private function getEffectIndicatorById(param1:int) : EffectIndicator
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:EffectIndicator = null;
         if(this.redado != null)
         {
            _loc2_ = int(this.redado.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.redado[_loc3_];
               if(_loc4_.effectId == param1)
               {
                  return _loc4_;
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      private function updateVisibility(param1:int) : void
      {
         if(this.juvowywa)
         {
            if(this.sprite.alpha > 0)
            {
               this.sprite.alpha -= hacevul * param1;
               if(this.sprite.alpha <= 0)
               {
                  this.sprite.alpha = 0;
                  this.sprite.visible = false;
               }
            }
         }
         else
         {
            this.sprite.visible = true;
            if(this.sprite.alpha < 1)
            {
               this.sprite.alpha += hacevul * param1;
               if(this.sprite.alpha > 1)
               {
                  this.sprite.alpha = 1;
               }
            }
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.events.EventDispatcher;
import flash.text.TextField;

class Label extends TextField
{
   
   public function Label()
   {
      super();
   }
}
