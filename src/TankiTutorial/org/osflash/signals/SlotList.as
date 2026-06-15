package org.osflash.signals
{
   public final class SlotList
   {
      
      public static const luqe:SlotList = new SlotList(null,null);
      
      public var riw:ISlot;
      
      public var rysered:SlotList;
      
      public var nuta:Boolean = false;
      
      public function SlotList(param1:ISlot, param2:SlotList = null)
      {
         super();
         if(!param1 && !param2)
         {
            if(Boolean(luqe))
            {
               throw new ArgumentError("Parameters head and tail are null. Use the NIL element instead.");
            }
            this.nuta = false;
         }
         else
         {
            if(!param1)
            {
               throw new ArgumentError("Parameter head cannot be null.");
            }
            this.riw = param1;
            this.rysered = param2 || luqe;
            this.nuta = true;
         }
      }
      
      public function getLength() : uint
      {
         if(!this.nuta)
         {
            return 0;
         }
         if(this.rysered == luqe)
         {
            return 1;
         }
         var _loc1_:uint = 0;
         var _loc2_:SlotList = this;
         while(_loc2_.nuta)
         {
            _loc1_++;
            _loc2_ = _loc2_.rysered;
         }
         return _loc1_;
      }
      
      public function prepend(param1:ISlot) : SlotList
      {
         return new SlotList(param1,this);
      }
      
      public function append(param1:ISlot) : SlotList
      {
         if(!param1)
         {
            return this;
         }
         if(!this.nuta)
         {
            return new SlotList(param1);
         }
         if(this.rysered == luqe)
         {
            return new SlotList(param1).prepend(this.riw);
         }
         var _loc2_:SlotList = new SlotList(this.riw);
         var _loc3_:SlotList = _loc2_;
         var _loc4_:SlotList = this.rysered;
         while(_loc4_.nuta)
         {
            _loc3_ = _loc3_.rysered = new SlotList(_loc4_.riw);
            _loc4_ = _loc4_.rysered;
         }
         _loc3_.rysered = new SlotList(param1);
         return _loc2_;
      }
      
      public function filterNot(param1:Function) : SlotList
      {
         if(!this.nuta || param1 == null)
         {
            return this;
         }
         if(param1 == this.riw.getListener())
         {
            return this.rysered;
         }
         var _loc2_:SlotList = new SlotList(this.riw);
         var _loc3_:SlotList = _loc2_;
         var _loc4_:SlotList = this.rysered;
         while(_loc4_.nuta)
         {
            if(_loc4_.riw.getListener() == param1)
            {
               _loc3_.rysered = _loc4_.rysered;
               return _loc2_;
            }
            _loc3_ = _loc3_.rysered = new SlotList(_loc4_.riw);
            _loc4_ = _loc4_.rysered;
         }
         return this;
      }
      
      public function contains(param1:Function) : Boolean
      {
         if(!this.nuta)
         {
            return false;
         }
         var _loc2_:SlotList = this;
         while(_loc2_.nuta)
         {
            if(_loc2_.riw.getListener() == param1)
            {
               return true;
            }
            _loc2_ = _loc2_.rysered;
         }
         return false;
      }
      
      public function find(param1:Function) : ISlot
      {
         if(!this.nuta)
         {
            return null;
         }
         var _loc2_:SlotList = this;
         while(_loc2_.nuta)
         {
            if(_loc2_.riw.getListener() == param1)
            {
               return _loc2_.riw;
            }
            _loc2_ = _loc2_.rysered;
         }
         return null;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         var _loc2_:SlotList = this;
         while(_loc2_.nuta)
         {
            _loc1_ += _loc2_.riw + " -> ";
            _loc2_ = _loc2_.rysered;
         }
         _loc1_ += "NIL";
         return "[List " + _loc1_ + "]";
      }
   }
}

