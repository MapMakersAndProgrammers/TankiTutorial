package alternativa.tanks.sfx
{
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import tutorial.commons.Assets;
   
   public class TankSounds implements ISound3DEffect
   {
      
      private static const neza:Vector3 = new Vector3();
      
      private var reva:Tank;
      
      private var fezi:EngineSounds;
      
      private var bywyson:Sound3D;
      
      private var qylugugo:int = 1;
      
      private var dalipaz:Boolean = false;
      
      private var nizo:Boolean;
      
      private var lusik:Boolean = false;
      
      private var pywuvisa:Boolean = false;
      
      public function TankSounds()
      {
         super();
      }
      
      private function initEngineSound() : void
      {
         var _loc1_:Sound = null;
         var _loc2_:Sound = null;
         var _loc3_:Sound = null;
         if(!this.lusik)
         {
            _loc1_ = Assets.getData("engine_idle",Sound);
            _loc2_ = Assets.getData("engine_start",Sound);
            _loc3_ = Assets.getData("engine_moving",Sound);
            if(_loc1_ != null && _loc2_ != null && _loc3_ != null)
            {
               this.fezi = new EngineSounds(_loc1_,_loc2_,_loc3_);
               this.lusik = true;
            }
         }
      }
      
      private function initTurretSound() : void
      {
         var _loc1_:Sound = null;
         if(!this.pywuvisa)
         {
            _loc1_ = Assets.getData("engine_turret",Sound);
            if(_loc1_ != null)
            {
               this.bywyson = Sound3D.create(_loc1_,500,2000,5,0.5);
               this.pywuvisa = true;
            }
         }
      }
      
      public function setIdleMode() : void
      {
         this.initEngineSound();
         if(this.lusik)
         {
            this.qylugugo = EngineSounds.qanigak;
            if(this.dalipaz)
            {
               this.fezi.setIdleMode();
            }
         }
      }
      
      public function setSilentMode() : void
      {
         this.initEngineSound();
         if(this.lusik)
         {
            this.qylugugo = EngineSounds.pubevih;
            if(this.dalipaz)
            {
               this.fezi.setSilentMode();
            }
         }
      }
      
      public function setAccelerationMode() : void
      {
         this.initEngineSound();
         if(this.lusik)
         {
            this.qylugugo = EngineSounds.docic;
            if(this.dalipaz)
            {
               this.fezi.setAccelerationMode();
            }
         }
      }
      
      public function setTurningMode() : void
      {
         this.initEngineSound();
         if(this.lusik)
         {
            this.qylugugo = EngineSounds.daqizinan;
            if(this.dalipaz)
            {
               this.fezi.setTurningMode();
            }
         }
      }
      
      public function setTank(param1:Tank) : void
      {
         this.reva = param1;
      }
      
      public function playTurretSound(param1:Boolean) : void
      {
         var _loc2_:SoundChannel = null;
         this.initTurretSound();
         if(this.pywuvisa)
         {
            if(this.dalipaz)
            {
               if(param1 && this.nizo)
               {
                  if(!this.bywyson.isPlaying())
                  {
                     _loc2_ = this.bywyson.play(100,0);
                     if(_loc2_ != null)
                     {
                        _loc2_.addEventListener(Event.SOUND_COMPLETE,this.onTurretSoundComplete);
                     }
                  }
               }
               else if(this.bywyson.isPlaying())
               {
                  this.bywyson.stop();
               }
            }
         }
      }
      
      private function onTurretSoundComplete(param1:Event) : void
      {
         if(this.nizo)
         {
            this.bywyson.play(3000,9999);
         }
      }
      
      public function set turretSoundEnabled(param1:Boolean) : void
      {
         if(this.nizo != param1)
         {
            this.nizo = param1;
            if(!this.nizo)
            {
               if(this.pywuvisa)
               {
                  this.bywyson.stop();
               }
            }
         }
      }
      
      public function play(param1:int, param2:GameCamera) : void
      {
         if(this.reva != null && this.dalipaz)
         {
            neza.copy(this.reva.hogys.body.kejo.position);
            if(this.lusik)
            {
               this.fezi.update(param1,param2.position,neza,param2.memyjenut);
            }
            if(this.pywuvisa)
            {
               this.bywyson.checkVolume(param2.position,neza,param2.memyjenut);
            }
         }
      }
      
      public function destroy() : void
      {
         if(this.lusik)
         {
            this.fezi.stop();
         }
         if(this.pywuvisa)
         {
            this.bywyson.stop();
         }
      }
      
      public function kill() : void
      {
      }
      
      public function get numSounds() : int
      {
         return 2;
      }
      
      public function readPosition(param1:Vector3) : void
      {
         param1.copy(this.reva.hogys.body.kejo.position);
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(this.dalipaz != param1)
         {
            this.dalipaz = param1;
            this.updateSounds();
         }
      }
      
      private function updateSounds() : void
      {
         if(this.dalipaz)
         {
            if(this.lusik)
            {
               switch(this.qylugugo)
               {
                  case EngineSounds.qanigak:
                     this.fezi.setIdleMode();
                     break;
                  case EngineSounds.docic:
                     this.fezi.setAccelerationMode();
                     break;
                  case EngineSounds.daqizinan:
                     this.fezi.setTurningMode();
               }
            }
         }
         else
         {
            if(this.pywuvisa)
            {
               this.bywyson.stop();
            }
            if(this.lusik)
            {
               this.fezi.setSilentMode();
            }
         }
      }
   }
}

