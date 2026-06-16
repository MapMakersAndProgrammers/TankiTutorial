package alternativa.physics.contactislands
{
   import daz.fyweci;
   import daz.hah;
   
   public class ContactLevels
   {
      
      private const duby:Vector.<hah> = new Vector.<hah>();
      
      public function ContactLevels()
      {
         super();
      }
      
      public function init(param1:Vector.<hah>) : void
      {
         var _loc2_:int = int(param1.length);
         this.duby.length = _loc2_;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.duby[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
      }
      
      public function clear() : void
      {
         this.duby.length = 0;
      }
      
      public function getStaticLevel(param1:Vector.<hah>, param2:Vector.<fyweci>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:hah = null;
         _loc3_ = 0;
         while(_loc3_ < this.duby.length)
         {
            _loc4_ = this.duby[_loc3_];
            if(this.isStaticContact(_loc4_))
            {
               param1[param1.length] = _loc4_;
               param2[param2.length] = this.getNonStaticBody(_loc4_);
               this.removeContact(_loc3_);
               _loc3_--;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.duby.length)
         {
            _loc4_ = this.duby[_loc3_];
            if(param2.indexOf(_loc4_.rukowicyp) >= 0 && param2.indexOf(_loc4_.zata) >= 0)
            {
               param1[param1.length] = _loc4_;
               this.removeContact(_loc3_);
               _loc3_--;
            }
            _loc3_++;
         }
      }
      
      private function isStaticContact(param1:hah) : Boolean
      {
         return !(Boolean(param1.rukowicyp.midorofic) && Boolean(param1.zata.midorofic));
      }
      
      private function getNonStaticBody(param1:hah) : fyweci
      {
         if(param1.rukowicyp.midorofic)
         {
            return param1.rukowicyp;
         }
         return param1.zata;
      }
      
      private function removeContact(param1:int) : void
      {
         var _loc2_:int = this.duby.length - 1;
         this.duby[param1] = this.duby[_loc2_];
         this.duby.length = _loc2_;
      }
      
      public function getNextLevel(param1:Vector.<fyweci>, param2:Vector.<hah>, param3:Vector.<fyweci>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:hah = null;
         _loc4_ = 0;
         while(_loc4_ < this.duby.length)
         {
            _loc5_ = this.duby[_loc4_];
            if(this.isInContactWith(param1,_loc5_))
            {
               param2[param2.length] = _loc5_;
               param3[param3.length] = this.getNextLevelBody(_loc5_,param1);
               this.removeContact(_loc4_);
               _loc4_--;
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this.duby.length)
         {
            _loc5_ = this.duby[_loc4_];
            if(param3.indexOf(_loc5_.rukowicyp) >= 0 && param3.indexOf(_loc5_.zata) >= 0)
            {
               param2[param2.length] = _loc5_;
               this.removeContact(_loc4_);
               _loc4_--;
            }
            _loc4_++;
         }
      }
      
      private function isInContactWith(param1:Vector.<fyweci>, param2:hah) : Boolean
      {
         return param1.indexOf(param2.rukowicyp) >= 0 || param1.indexOf(param2.zata) >= 0;
      }
      
      private function getNextLevelBody(param1:hah, param2:Vector.<fyweci>) : fyweci
      {
         if(param2.indexOf(param1.rukowicyp) < 0)
         {
            return param1.rukowicyp;
         }
         return param1.zata;
      }
      
      public function hasContacts() : Boolean
      {
         return this.duby.length > 0;
      }
   }
}

