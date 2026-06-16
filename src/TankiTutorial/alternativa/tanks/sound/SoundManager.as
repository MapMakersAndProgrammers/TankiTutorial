package alternativa.tanks.sound
{
   import alternativa.math.Vector3;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.shared.camera.GameCamera;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   import tutorial.commons.Shared;
   
   public class SoundManager implements ISoundManager
   {
      
      private static const jewawulef:int = 10;
      
      private static const kenuqoz:int = 20;
      
      private static const duv:Vector3 = new Vector3();
      
      public static var tacacihob:Number = 0;
      
      public static var wiwoginut:Number = 0;
      
      public static var nad:Number = 0;
      
      private var jahobyva:Number = 0.07;
      
      private var fesiwu:Number;
      
      private var hobuna:Vector.<SoundEffectData> = new Vector.<SoundEffectData>();
      
      private var riwo:int;
      
      private var jugar:Dictionary = new Dictionary();
      
      private var numSounds:int;
      
      private var cimaw:Vector.<int> = new Vector.<int>();
      
      private var tehewym:Boolean = false;
      
      public function SoundManager()
      {
         super();
      }
      
      public static function createSoundManager(param1:Sound) : ISoundManager
      {
         var _loc2_:SoundChannel = param1.play(0,1,new SoundTransform(0));
         if(_loc2_ != null)
         {
            _loc2_.stop();
            return new SoundManager();
         }
         return new DummySoundManager();
      }
      
      public function set maxDistance(param1:Number) : void
      {
         this.fesiwu = param1 * param1;
      }
      
      public function setMute(param1:Boolean) : void
      {
         this.tehewym = param1;
      }
      
      public function playSound(param1:Sound, param2:int = 0, param3:int = 0, param4:SoundTransform = null) : SoundChannel
      {
         if(this.cannotPlaySound(param1))
         {
            return null;
         }
         var _loc5_:SoundChannel = param1.play(param2,param3,param4);
         if(_loc5_ != null)
         {
            this.addSoundChannel(_loc5_);
         }
         return _loc5_;
      }
      
      private function cannotPlaySound(param1:Sound) : Boolean
      {
         return this.tehewym || this.numSounds == jewawulef || param1 == null;
      }
      
      public function stopSound(param1:SoundChannel) : void
      {
         if(param1 != null || this.jugar[param1] != null)
         {
            this.removeSoundChannel(param1);
         }
      }
      
      public function stopAllSounds() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.jugar)
         {
            this.removeSoundChannel(_loc1_ as SoundChannel);
         }
      }
      
      public function addEffect(param1:ISound3DEffect) : Boolean
      {
         if(this.canAddEffect(param1))
         {
            param1.enabled = true;
            this.hobuna.push(SoundEffectData.create(0,param1));
            ++this.riwo;
            return true;
         }
         return false;
      }
      
      private function canAddEffect(param1:ISound3DEffect) : Boolean
      {
         return !this.tehewym && param1 != null && this.getEffectIndex(param1) < 0;
      }
      
      public function removeEffect(param1:ISound3DEffect) : void
      {
         var _loc3_:SoundEffectData = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.riwo)
         {
            _loc3_ = this.hobuna[_loc2_];
            if(_loc3_.nyniqadi == param1)
            {
               param1.destroy();
               SoundEffectData.destroy(_loc3_);
               this.hobuna.splice(_loc2_,1);
               --this.riwo;
               return;
            }
            _loc2_++;
         }
      }
      
      public function removeAllEffects() : void
      {
         var _loc1_:SoundEffectData = null;
         while(this.hobuna.length > 0)
         {
            _loc1_ = this.hobuna.pop();
            _loc1_.nyniqadi.destroy();
            SoundEffectData.destroy(_loc1_);
         }
         this.riwo = 0;
      }
      
      public function updateSoundEffects(param1:int, param2:GameCamera) : void
      {
         var _loc3_:int = 0;
         if(this.riwo > 0)
         {
            this.sortEffects(param2.position);
            _loc3_ = this.processEffectsInActiveRange(param1,param2);
            this.deactivateRemainingEffects(_loc3_);
         }
         this.switchBaseVolume();
      }
      
      private function switchBaseVolume() : void
      {
         if(wiwoginut > 0)
         {
            wiwoginut += 0.03;
            if(wiwoginut > 1)
            {
               wiwoginut = 1;
            }
         }
         if(nad < Shared.volume)
         {
            nad += 0.1;
            if(nad > Shared.volume)
            {
               nad = Shared.volume;
            }
         }
         else
         {
            nad -= 0.1;
            if(nad < Shared.volume)
            {
               nad = Shared.volume;
            }
         }
         tacacihob = wiwoginut * nad;
      }
      
      private function processEffectsInActiveRange(param1:int, param2:GameCamera) : int
      {
         var _loc3_:SoundEffectData = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < this.riwo)
         {
            _loc3_ = this.hobuna[_loc5_];
            _loc6_ = int(_loc3_.nyniqadi.numSounds);
            if(_loc6_ == 0)
            {
               _loc3_.nyniqadi.destroy();
               SoundEffectData.destroy(_loc3_);
               this.hobuna.splice(_loc5_,1);
               --this.riwo;
               _loc5_--;
            }
            else
            {
               if(_loc3_.pyvyg > this.fesiwu || _loc4_ + _loc6_ > kenuqoz)
               {
                  break;
               }
               _loc3_.nyniqadi.enabled = true;
               _loc3_.nyniqadi.play(param1,param2);
               _loc4_ += _loc6_;
            }
            _loc5_++;
         }
         return _loc5_;
      }
      
      private function deactivateRemainingEffects(param1:int) : void
      {
         var _loc3_:SoundEffectData = null;
         var _loc2_:int = param1;
         while(_loc2_ < this.riwo)
         {
            _loc3_ = this.hobuna[_loc2_];
            _loc3_.nyniqadi.enabled = false;
            if(_loc3_.nyniqadi.numSounds == 0)
            {
               _loc3_.nyniqadi.destroy();
               SoundEffectData.destroy(_loc3_);
               this.hobuna.splice(_loc2_,1);
               --this.riwo;
               _loc2_--;
            }
            _loc2_++;
         }
      }
      
      private function addSoundChannel(param1:SoundChannel) : void
      {
         param1.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         this.jugar[param1] = true;
         ++this.numSounds;
      }
      
      private function removeSoundChannel(param1:SoundChannel) : void
      {
         param1.stop();
         param1.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         delete this.jugar[param1];
         --this.numSounds;
      }
      
      private function onSoundComplete(param1:Event) : void
      {
         this.stopSound(param1.target as SoundChannel);
      }
      
      private function getEffectIndex(param1:ISound3DEffect) : int
      {
         var _loc3_:SoundEffectData = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.riwo)
         {
            _loc3_ = this.hobuna[_loc2_];
            if(_loc3_.nyniqadi == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function sortEffects(param1:Vector3) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:SoundEffectData = null;
         var _loc9_:SoundEffectData = null;
         var _loc10_:SoundEffectData = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:SoundEffectData = null;
         var _loc4_:int = 0;
         var _loc5_:int = this.riwo - 1;
         _loc2_ = 0;
         while(_loc2_ < this.riwo)
         {
            _loc8_ = this.hobuna[_loc2_];
            _loc8_.nyniqadi.readPosition(duv);
            _loc11_ = param1.x - duv.x;
            _loc12_ = param1.y - duv.y;
            _loc13_ = param1.z - duv.z;
            _loc8_.pyvyg = _loc11_ * _loc11_ + _loc12_ * _loc12_ + _loc13_ * _loc13_;
            _loc2_++;
         }
         if(this.riwo == 1)
         {
            return;
         }
         this.cimaw[0] = _loc4_;
         this.cimaw[1] = _loc5_;
         _loc6_ = 2;
         while(_loc6_ > 0)
         {
            _loc3_ = _loc5_ = this.cimaw[--_loc6_];
            _loc2_ = _loc4_ = this.cimaw[--_loc6_];
            _loc14_ = this.hobuna[_loc5_ + _loc4_ >> 1];
            _loc7_ = Number(_loc14_.pyvyg);
            do
            {
               _loc9_ = this.hobuna[_loc2_];
               while(_loc9_.pyvyg < _loc7_)
               {
                  _loc2_++;
                  _loc9_ = this.hobuna[_loc2_];
               }
               _loc10_ = this.hobuna[_loc3_];
               while(_loc10_.pyvyg > _loc7_)
               {
                  _loc3_--;
                  _loc10_ = this.hobuna[_loc3_];
               }
               if(_loc2_ <= _loc3_)
               {
                  this.hobuna[_loc2_++] = _loc10_;
                  this.hobuna[_loc3_--] = _loc9_;
               }
            }
            while(_loc2_ <= _loc3_);
            if(_loc4_ < _loc3_)
            {
               this.cimaw[_loc6_++] = _loc4_;
               this.cimaw[_loc6_++] = _loc3_;
            }
            if(_loc2_ < _loc5_)
            {
               this.cimaw[_loc6_++] = _loc2_;
               this.cimaw[_loc6_++] = _loc5_;
            }
         }
      }
   }
}

