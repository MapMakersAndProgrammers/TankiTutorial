package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.physics.Body;
   import alternativa.tanks.sfx.flamethrower.FlamethrowerEffects;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.utils.getTimer;
   import tutorial.GameData;
   
   public class StreamWeapon extends Weapon
   {
      
      private static const wuvyt:int = 1000;
      
      private static const qipuji:Number = 0.3;
      
      private static const befin:Vector.<Body> = new Vector.<Body>();
      
      private static const vyla:Vector.<Number> = new Vector.<Number>();
      
      private var katyzypu:Number;
      
      private var rofukeho:Number;
      
      private var bevy:Number;
      
      private var lab:int;
      
      private var namekazaf:ConicAreaTargetingSystem;
      
      private var hobuna:FlamethrowerEffects;
      
      private var kifakazup:int;
      
      private var javoq:Boolean;
      
      private var nomotan:int;
      
      private var nykasev:int;
      
      private var beryfitu:Number;
      
      private var liwikyter:Boolean = false;
      
      public function StreamWeapon(param1:Number, param2:Number, param3:Number, param4:Number, param5:int, param6:ConicAreaTargetingSystem, param7:FlamethrowerEffects)
      {
         super("Flamethrower");
         this.beryfitu = param1;
         this.katyzypu = param2;
         this.rofukeho = param3;
         this.bevy = param4;
         this.lab = param5;
         this.namekazaf = param6;
         this.hobuna = param7;
      }
      
      public function reset() : void
      {
         this.javoq = false;
         zadawe = false;
         this.nomotan = 0;
         this.kifakazup = 0;
         this.nykasev = 0;
      }
      
      override public function get status() : Number
      {
         var _loc1_:Number = NaN;
         if(zadawe && !this.liwikyter)
         {
            _loc1_ = this.getCurrentEnergyInShootingMode(getTimer());
         }
         else
         {
            _loc1_ = this.getCurrentEnergyInIdleMode(getTimer());
         }
         return _loc1_ / this.katyzypu;
      }
      
      override public function update(param1:int, param2:int) : void
      {
         if(this.javoq)
         {
            this.runLogicForShootingMode(param1);
         }
         else
         {
            this.runLogicForIdleMode(param1);
         }
      }
      
      override public function stop() : void
      {
         super.stop();
         this.hobuna.stopEffects();
      }
      
      private function runLogicForShootingMode(param1:int) : void
      {
         if(zadawe)
         {
            this.tryToTick(param1);
            this.stopIfNecessary(param1);
         }
         else
         {
            this.liwikyter = false;
            this.stopShoot(param1);
         }
      }
      
      override public function start() : void
      {
         if(zadawe)
         {
            return;
         }
         zadawe = true;
         this.liwikyter = false;
      }
      
      private function tryToTick(param1:int) : void
      {
         if(this.nykasev > 0)
         {
            if(this.kifakazup <= param1)
            {
               this.tick(param1);
               this.nykasev -= 1;
            }
         }
      }
      
      private function stopIfNecessary(param1:int) : void
      {
         if(this.nykasev == 0)
         {
            if(this.getCurrentEnergyInShootingMode(param1) <= 0)
            {
               this.liwikyter = true;
               this.stopShoot(param1);
            }
         }
      }
      
      private function runLogicForIdleMode(param1:int) : void
      {
         if(zadawe && !this.liwikyter)
         {
            this.startShoot(param1);
         }
      }
      
      private function startShoot(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Tank = null;
         if(!this.javoq)
         {
            this.javoq = true;
            _loc2_ = this.getCurrentEnergyInIdleMode(param1);
            this.nomotan = this.getBaseTimeForShootingMode(param1,_loc2_);
            this.calculateTicksNumber(_loc2_);
            this.kifakazup = param1 + this.lab;
            _loc3_ = getTank();
            this.hobuna.startEffects(_loc3_.hogys.body,_loc3_.firaqe.jun[0],_loc3_.kuca.turretMesh);
         }
      }
      
      private function calculateTicksNumber(param1:Number) : void
      {
         this.nykasev = wuvyt * param1 / (this.rofukeho * this.lab);
      }
      
      private function stopShoot(param1:int) : void
      {
         if(this.javoq)
         {
            this.javoq = false;
            this.nomotan = param1 - this.getCurrentEnergyInShootingMode(param1) / this.bevy * wuvyt;
            this.nykasev = 0;
            this.hobuna.stopEffects();
         }
      }
      
      override public function getTarget() : Tank
      {
         var _loc4_:Tank = null;
         var _loc5_:int = 0;
         var _loc6_:Body = null;
         var _loc7_:Tank = null;
         var _loc1_:TurretData = getData();
         var _loc2_:Tank = getTank();
         _loc1_.update(_loc2_,0);
         this.namekazaf.getTargets(_loc2_.hogys.body,_loc1_.siwowop,qipuji,_loc1_.fybumu,_loc1_.ruda,_loc1_.zequsir,befin,vyla);
         var _loc3_:int = int(befin.length);
         if(_loc3_ == 1)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_)
            {
               _loc6_ = befin[_loc5_];
               _loc7_ = _loc6_.katuf as Tank;
               if(_loc7_ == GameData.jifom)
               {
                  _loc4_ = _loc7_;
               }
               _loc5_++;
            }
         }
         befin.length = 0;
         vyla.length = 0;
         return _loc4_;
      }
      
      private function tick(param1:int) : void
      {
         var _loc6_:Body = null;
         var _loc7_:Tank = null;
         this.kifakazup = param1 + this.lab;
         var _loc2_:TurretData = getData();
         var _loc3_:Tank = getTank();
         _loc2_.update(_loc3_,0);
         befin.length = 0;
         vyla.length = 0;
         this.namekazaf.getTargets(_loc3_.hogys.body,_loc2_.siwowop,qipuji,_loc2_.fybumu,_loc2_.ruda,_loc2_.zequsir,befin,vyla);
         var _loc4_:int = int(befin.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = befin[_loc5_];
            _loc7_ = _loc6_.katuf as Tank;
            if(_loc7_ != null)
            {
               _loc7_.substructHealth(this.beryfitu * kuqy);
            }
            _loc5_++;
         }
         befin.length = 0;
         vyla.length = 0;
      }
      
      private function getCurrentEnergyInIdleMode(param1:int) : Number
      {
         var _loc2_:Number = this.katyzypu;
         var _loc3_:Number = this.bevy * (param1 - this.nomotan) / wuvyt;
         return _loc3_ > _loc2_ ? _loc2_ : _loc3_;
      }
      
      private function getCurrentEnergyInShootingMode(param1:int) : Number
      {
         var _loc2_:Number = this.katyzypu - this.rofukeho * (param1 - this.nomotan) / wuvyt;
         return _loc2_ < 0 ? 0 : _loc2_;
      }
      
      private function getBaseTimeForIdleMode(param1:int, param2:Number) : int
      {
         return param1 - param2 / this.bevy * wuvyt;
      }
      
      private function getBaseTimeForShootingMode(param1:int, param2:Number) : int
      {
         return param1 - (this.katyzypu - param2) / this.rofukeho * wuvyt;
      }
   }
}

