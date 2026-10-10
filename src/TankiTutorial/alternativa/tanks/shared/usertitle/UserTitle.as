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
      
      private static const matrix:Matrix = new Matrix();
      
      private static const BLINKING_TIME:int = 3000;
      
      private static const nizohe:int = 13;
      
      private static const LABEL_HEIGHT:int = 13;
      
      private static const bebujizon:int = 3;
      
      private static const INDICATOR_SIZE:int = 16;
      
      private static const vicufis:int = -3;
      
      private static const vopafub:int = 2;
      
      private static const retunobi:int = -1;
      
      private static const rotizefaq:int = 4;
      
      private static const INDICATOR_SPACING:int = 4;
      
      private static const BAR_WIDTH:int = 100;
      
      private static const BAR_HEIGHT:int = 8;
      
      private static const MARGIN:int = 3;
      
      private static const gop:int = 2 * MARGIN;
      
      private static const effectIds:Vector.<int> = Vector.<int>([InventoryItemType.gezah,InventoryItemType.ramymep,InventoryItemType.ronura,InventoryItemType.majycy]);
      
      private static const glowFilter:GlowFilter = new GlowFilter(0,0.8,4,4,3);
      
      private static const ALPHA_SPEED:Number = 0.002;
      
      private var configuration:int;
      
      private var dirtyFlags:int;
      
      private var sprite:Sprite3D;
      
      private var rect:Rectangle;
      
      private var label:Label;
      
      private var healthBar:ProgressBar;
      
      private var weaponBar:ProgressBar;
      
      private var effectIndicators:Vector.<EffectIndicator>;
      
      private var numVisibleIndicators:int;
      
      private var indicatorsY:int;
      
      private var rank:int;
      
      private var labelText:String;
      
      private var health:int;
      
      private var maxHealth:int;
      
      private var weaponStatus:int;
      
      private var vos:Boolean;
      
      private var healthBarSkin:ProgressBarSkin = ProgressBarSkin.hpDm;
      
      private var hidden:Boolean = true;
      
      private var time:int;
      
      private var material:TextureMaterial;
      
      private var texture:BitmapData;
      
      private var heightOffset:Number;
      
      private var container:Object3DContainer;
      
      private var size:Size2D = new Size2D();
      
      public function UserTitle(heightOffset:Number, container:Object3DContainer)
      {
         super();
         this.heightOffset = heightOffset;
         this.container = container;
         this.material = new TextureMaterial();
         this.material.name = "title";
         this.sprite = new Sprite3D(100,100,this.material);
         if(heightOffset == 0)
         {
            this.sprite.name = "title";
         }
         this.sprite.clipping = Clipping.FACE_CLIPPING;
         this.sprite.perspectiveScale = false;
         this.sprite.alpha = 0;
         this.sprite.visible = false;
         this.hidden = true;
         this.sprite.useShadowMap = false;
         this.sprite.useLight = false;
      }
      
      public function getTexture() : BitmapData
      {
         return this.texture;
      }
      
      public function hide() : void
      {
         this.hidden = true;
      }
      
      public function hideImmediate() : void
      {
         this.hide();
         this.sprite.alpha = 0.0001;
      }
      
      public function show() : void
      {
         this.hidden = false;
      }
      
      public function setConfiguration(configuration:int) : void
      {
         if(this.configuration != configuration)
         {
            this.configuration = configuration;
            this.updateConfiguration();
         }
      }
      
      public function setRank(rank:int) : void
      {
         if(this.rank != rank)
         {
            this.rank = rank;
            if(this.hasAnyFlag(TitleConfigFlags.LABEL))
            {
               this.invalidateConfigFlags(TitleConfigFlags.LABEL | TitleConfigFlags.HEALTH | TitleConfigFlags.WEAPON | TitleConfigFlags.EFFECTS);
            }
         }
      }
      
      public function setLabelText(labelText:String) : void
      {
         if(this.labelText != labelText)
         {
            this.labelText = labelText;
            if(this.hasAnyFlag(TitleConfigFlags.LABEL))
            {
               this.updateConfiguration();
               this.invalidateConfigFlags(TitleConfigFlags.LABEL | TitleConfigFlags.HEALTH | TitleConfigFlags.WEAPON | TitleConfigFlags.EFFECTS);
            }
         }
      }
      
      public function setHealth(health:int, maxHealth:int) : void
      {
         if(this.healthBar == null)
         {
            return;
         }
         if(this.health != health)
         {
            this.health = health;
            this.invalidateConfigFlags(TitleConfigFlags.HEALTH);
         }
         if(this.maxHealth != maxHealth)
         {
            this.maxHealth = maxHealth;
            this.invalidateConfigFlags(TitleConfigFlags.HEALTH);
            this.healthBar.maxValue = maxHealth;
         }
      }
      
      public function setWeaponStatus(weaponStatus:int) : void
      {
         if(this.weaponStatus != weaponStatus)
         {
            this.weaponStatus = weaponStatus;
            this.invalidateConfigFlags(TitleConfigFlags.WEAPON);
         }
      }
      
      public function showIndicator(effectId:int, duration:int) : void
      {
         var indicator:EffectIndicator = null;
         if(this.hasAnyFlag(TitleConfigFlags.EFFECTS))
         {
            indicator = this.getEffectIndicatorById(effectId);
            if(indicator != null)
            {
               if(indicator.isHidden())
               {
                  this.changeVisibleIndicatorsNumber(1);
               }
               indicator.show(duration);
            }
         }
      }
      
      public function hideIndicator(effectId:int) : void
      {
         var indicator:EffectIndicator = null;
         if(this.hasAnyFlag(TitleConfigFlags.EFFECTS))
         {
            indicator = this.getEffectIndicatorById(effectId);
            if(indicator != null)
            {
               indicator.hide();
            }
         }
      }
      
      public function hideIndicators() : void
      {
         var effectId:int = 0;
         if(this.hasAnyFlag(TitleConfigFlags.EFFECTS) && this.effectIndicators != null)
         {
            for each(effectId in effectIds)
            {
               this.hideIndicator(effectId);
            }
         }
      }
      
      internal function doHideIndicator(indicator:EffectIndicator) : void
      {
         indicator.clear(this.texture);
         this.changeVisibleIndicatorsNumber(-1);
      }
      
      public function update(position:Vector3) : void
      {
         var indicator:EffectIndicator = null;
         this.setPosition(position);
         var currentTime:int = getTimer();
         var deltaTime:int = currentTime - this.time;
         this.time = currentTime;
         this.updateVisibility(deltaTime);
         if(this.dirtyFlags != 0)
         {
            if(this.isDirtyAndHasOption(TitleConfigFlags.LABEL))
            {
               this.updateLabel();
            }
            if(this.isDirtyAndHasOption(TitleConfigFlags.HEALTH))
            {
               this.healthBar.setSkin(this.healthBarSkin);
               this.healthBar.progress = this.health;
               this.healthBar.draw(this.texture);
            }
            if(this.isDirtyAndHasOption(TitleConfigFlags.WEAPON))
            {
               this.weaponBar.progress = this.weaponStatus;
               this.weaponBar.draw(this.texture);
            }
            if(this.isDirtyAndHasOption(TitleConfigFlags.EFFECTS))
            {
               for each(indicator in this.effectIndicators)
               {
                  indicator.forceRedraw();
               }
            }
            this.dirtyFlags = 0;
         }
         if(this.hasAnyFlag(TitleConfigFlags.EFFECTS))
         {
            this.updateEffectIndicators(currentTime,deltaTime);
         }
      }
      
      private function isDirtyAndHasOption(flags:int) : Boolean
      {
         return (flags & this.dirtyFlags & this.configuration) == flags;
      }
      
      private function updateEffectIndicators(time:int, deltaTime:int) : void
      {
         var indicator:EffectIndicator = null;
         var i:int = 0;
         var x:int = 0;
         var len:int = int(this.effectIndicators.length);
         if(this.vos)
         {
            this.vos = false;
            x = this.size.width + gop - this.numVisibleIndicators * INDICATOR_SIZE - (this.numVisibleIndicators - 1) * INDICATOR_SPACING >> 1;
            i = 0;
            while(i < len)
            {
               indicator = this.effectIndicators[i];
               if(indicator.isVisible())
               {
                  indicator.clear(this.texture);
               }
               if(!indicator.isHidden())
               {
                  indicator.setPosition(x,this.indicatorsY);
                  x += INDICATOR_SIZE + INDICATOR_SPACING;
               }
               i++;
            }
         }
         i = 0;
         while(i < len)
         {
            indicator = this.effectIndicators[i];
            indicator.update(time,deltaTime,this.texture);
            i++;
         }
      }
      
      private function changeVisibleIndicatorsNumber(delta:int) : void
      {
         this.numVisibleIndicators += delta;
         this.vos = true;
      }
      
      private function updateConfiguration() : void
      {
         if(this.configuration != 0)
         {
            this.setupTexture();
            this.setupComponents();
         }
      }
      
      private function setupTexture() : void
      {
         var numIndicators:int = 0;
         var width:int = 0;
         this.size.setToZero();
         if(this.hasAnyFlag(TitleConfigFlags.LABEL))
         {
            this.createLabelComponents();
            this.label.text = this.labelText || "";
            this.size.setWidth(nizohe + vicufis + this.label.textWidth);
            this.size.setHeight(LABEL_HEIGHT);
         }
         if(this.hasAnyFlag(TitleConfigFlags.HEALTH))
         {
            this.size.setWidthIfGreater(BAR_WIDTH);
            if(this.hasAnyFlag(TitleConfigFlags.LABEL))
            {
               this.size.addHeight(vopafub);
            }
            this.size.addHeight(BAR_HEIGHT);
         }
         if(this.hasAnyFlag(TitleConfigFlags.WEAPON))
         {
            this.size.setWidthIfGreater(BAR_WIDTH);
            this.size.addHeight(retunobi + BAR_HEIGHT);
         }
         if(this.hasAnyFlag(TitleConfigFlags.EFFECTS))
         {
            numIndicators = 4;
            width = numIndicators * INDICATOR_SIZE + (numIndicators - 1) * INDICATOR_SPACING;
            this.size.setWidthIfGreater(width);
            if(this.hasAnyFlag(TitleConfigFlags.LABEL | TitleConfigFlags.HEALTH))
            {
               this.size.addHeight(rotizefaq);
            }
            this.size.addHeight(INDICATOR_SIZE);
         }
         this.size.addWidth(2 * MARGIN);
         this.size.addHeight(2 * MARGIN);
         this.createTexture();
      }
      
      private function createTexture() : void
      {
         var width:int = this.size.width;
         var height:int = this.size.height;
         if(this.texture == null || this.texture.width != width || this.texture.height != height)
         {
            if(this.texture != null)
            {
               this.texture.dispose();
            }
            this.texture = new BitmapData(width,height,true,0);
            this.material.texture = this.texture;
            this.sprite.width = width;
            this.sprite.height = height;
            this.rect = this.texture.rect;
            this.invalidateConfigFlags(TitleConfigFlags.LABEL | TitleConfigFlags.HEALTH | TitleConfigFlags.WEAPON | TitleConfigFlags.EFFECTS);
         }
      }
      
      private function setupComponents() : void
      {
         var y:int = MARGIN;
         if(this.hasAnyFlag(TitleConfigFlags.LABEL))
         {
            y += LABEL_HEIGHT;
         }
         var x:int = this.size.width - BAR_WIDTH >> 1;
         if(this.hasAnyFlag(TitleConfigFlags.HEALTH))
         {
            if(this.hasAnyFlag(TitleConfigFlags.LABEL))
            {
               y += vopafub;
            }
            this.healthBar = new ProgressBar(x,y,0,BAR_WIDTH,this.healthBarSkin);
            y += BAR_HEIGHT;
         }
         if(this.hasAnyFlag(TitleConfigFlags.WEAPON))
         {
            y += retunobi;
            this.weaponBar = new ProgressBar(x,y,100,BAR_WIDTH,ProgressBarSkin.weapon);
            y += BAR_HEIGHT;
         }
         if(this.hasAnyFlag(TitleConfigFlags.EFFECTS))
         {
            y += rotizefaq;
            this.indicatorsY = y;
            this.createEffectsIndicators();
         }
      }
      
      public function addToContainer() : void
      {
         if(this.sprite.parent == null)
         {
            this.container.addChild(this.sprite);
            this.time = getTimer();
         }
      }
      
      public function removeFromContainer() : void
      {
         if(this.sprite.parent != null)
         {
            this.sprite.parent.removeChild(this.sprite);
         }
      }
      
      public function setPosition(position:Vector3) : void
      {
         this.sprite.x = position.x;
         this.sprite.y = position.y;
         this.sprite.z = position.z + this.heightOffset;
      }
      
      public function readPosition(position:Vector3D) : void
      {
         position.x = this.sprite.x;
         position.y = this.sprite.y;
         position.z = this.sprite.z;
      }
      
      private function invalidateConfigFlags(flags:int) : void
      {
         this.dirtyFlags |= flags & this.configuration;
      }
      
      private function hasAnyFlag(flags:int) : Boolean
      {
         return (flags & this.configuration) != 0;
      }
      
      private function createLabelComponents() : void
      {
         if(this.label == null)
         {
            this.label = new Label();
            this.label.autoSize = TextFieldAutoSize.LEFT;
            this.label.thickness = 50;
         }
      }
      
      private function updateLabel() : void
      {
         var bitmapData:BitmapData = this.texture.clone();
         bitmapData.fillRect(this.rect,0);
         var width:int = nizohe + vicufis + this.label.textWidth;
         var x:int = this.size.width - width >> 1;
         matrix.tx = x;
         matrix.ty = MARGIN + bebujizon;
         matrix.tx = x + nizohe + vicufis;
         matrix.ty = MARGIN;
         this.label.textColor = this.healthBarSkin.color;
         bitmapData.draw(this.label,matrix,null,null,null,true);
         this.texture.applyFilter(bitmapData,this.rect,new Point(),glowFilter);
         bitmapData.dispose();
      }
      
      private function createEffectsIndicators() : void
      {
         var effectId:int = 0;
         if(this.effectIndicators == null)
         {
            this.effectIndicators = new Vector.<EffectIndicator>();
            for each(effectId in effectIds)
            {
               if(effectId == InventoryItemType.gezah)
               {
                  this.effectIndicators.push(new EffectIndicator(effectId,100000,this,300,0));
               }
               else
               {
                  this.effectIndicators.push(new EffectIndicator(effectId,BLINKING_TIME,this,300,30));
               }
            }
         }
      }
      
      private function getEffectIndicatorById(effectId:int) : EffectIndicator
      {
         var len:int = 0;
         var i:int = 0;
         var indicator:EffectIndicator = null;
         if(this.effectIndicators != null)
         {
            len = int(this.effectIndicators.length);
            i = 0;
            while(i < len)
            {
               indicator = this.effectIndicators[i];
               if(indicator.effectId == effectId)
               {
                  return indicator;
               }
               i++;
            }
         }
         return null;
      }
      
      private function updateVisibility(deltaTime:int) : void
      {
         if(this.hidden)
         {
            if(this.sprite.alpha > 0)
            {
               this.sprite.alpha -= ALPHA_SPEED * deltaTime;
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
               this.sprite.alpha += ALPHA_SPEED * deltaTime;
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
