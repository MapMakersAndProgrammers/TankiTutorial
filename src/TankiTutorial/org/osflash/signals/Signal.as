package org.osflash.signals
{
   import flash.errors.IllegalOperationError;
   import flash.utils.getQualifiedClassName;
   
   public class Signal implements ISignal
   {
      
      private var vuruwovib:Array;
      
      private var tylakizu:SlotList = SlotList.luqe;
      
      public function Signal(... rest)
      {
         super();
         this.setValueClasses(rest.length == 1 && rest[0] is Array ? rest[0] : rest);
      }
      
      public function getValueClasses() : Array
      {
         return this.vuruwovib;
      }
      
      public function setValueClasses(param1:Array) : void
      {
         this.vuruwovib = Boolean(param1) ? param1.slice() : [];
         var _loc2_:int = int(this.vuruwovib.length);
         while(Boolean(_loc2_--))
         {
            if(!(this.vuruwovib[_loc2_] is Class))
            {
               throw new ArgumentError("Invalid valueClasses argument: " + "item at index " + _loc2_ + " should be a Class but was:<" + this.vuruwovib[_loc2_] + ">." + getQualifiedClassName(this.vuruwovib[_loc2_]));
            }
         }
      }
      
      public function getNumListeners() : uint
      {
         return this.tylakizu.getLength();
      }
      
      public function addOnce(param1:Function) : ISlot
      {
         return this.registerListener(param1,true);
      }
      
      public function add(param1:Function) : ISlot
      {
         return this.registerListener(param1);
      }
      
      public function remove(param1:Function) : ISlot
      {
         var _loc2_:ISlot = this.tylakizu.find(param1);
         if(!_loc2_)
         {
            return null;
         }
         this.tylakizu = this.tylakizu.filterNot(param1);
         return _loc2_;
      }
      
      public function removeAll() : void
      {
         this.tylakizu = SlotList.luqe;
      }
      
      public function dispatch(... rest) : void
      {
         var _loc2_:int = int(this.vuruwovib.length);
         var _loc3_:int = int(rest.length);
         if(_loc3_ < _loc2_)
         {
            throw new ArgumentError("Incorrect number of arguments. " + "Expected at least " + _loc2_ + " but received " + _loc3_ + ".");
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            if(!(rest[_loc4_] is this.vuruwovib[_loc4_] || rest[_loc4_] === null))
            {
               throw new ArgumentError("Value object <" + rest[_loc4_] + "> is not an instance of <" + this.vuruwovib[_loc4_] + ">.");
            }
            _loc4_++;
         }
         var _loc5_:SlotList = this.tylakizu;
         if(_loc5_.nuta)
         {
            while(_loc5_.nuta)
            {
               _loc5_.riw.execute(rest);
               _loc5_ = _loc5_.rysered;
            }
         }
      }
      
      public function registerListener(param1:Function, param2:Boolean = false) : ISlot
      {
         var _loc3_:ISlot = null;
         if(this.registrationPossible(param1,param2))
         {
            _loc3_ = new Slot(param1,this,param2);
            this.tylakizu = this.tylakizu.prepend(_loc3_);
            return _loc3_;
         }
         return this.tylakizu.find(param1);
      }
      
      public function registrationPossible(param1:Function, param2:Boolean) : Boolean
      {
         if(!this.tylakizu.nuta)
         {
            return true;
         }
         var _loc3_:ISlot = this.tylakizu.find(param1);
         if(!_loc3_)
         {
            return true;
         }
         if(_loc3_.getOnce() != param2)
         {
            throw new IllegalOperationError("You cannot addOnce() then add() the same listener without removing the relationship first.");
         }
         return false;
      }
   }
}

