package daz
{
   public class taval
   {
      
      private var gemaw:Vector.<int>;
      
      private var jiso:Vector.<int>;
      
      public function taval()
      {
         super();
         this.gemaw = new Vector.<int>(1);
         this.jiso = new Vector.<int>(1);
      }
      
      public function cabor(param1:int) : void
      {
         this.gemaw.length = param1;
         this.jiso.length = param1;
         var _loc2_:int = 0;
         while(_loc2_ < param1)
         {
            this.gemaw[_loc2_] = _loc2_;
            this.jiso[_loc2_] = 1;
            _loc2_++;
         }
      }
      
      public function mukikuvo(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!this.sejifiv(param1,param2))
         {
            _loc3_ = this.rareku(param1);
            _loc4_ = this.rareku(param2);
            _loc5_ = this.jiso[_loc3_];
            _loc6_ = this.jiso[_loc4_];
            if(_loc5_ > _loc6_)
            {
               this.gemaw[_loc4_] = _loc3_;
               this.jiso[_loc3_] += _loc6_;
            }
            else
            {
               this.gemaw[_loc3_] = _loc4_;
               this.jiso[_loc4_] += _loc5_;
            }
         }
      }
      
      public function sejifiv(param1:int, param2:int) : Boolean
      {
         return this.rareku(param1) == this.rareku(param2);
      }
      
      public function rareku(param1:int) : int
      {
         var _loc2_:int = param1;
         while(this.gemaw[_loc2_] != _loc2_)
         {
            _loc2_ = this.gemaw[_loc2_];
         }
         return _loc2_;
      }
   }
}

