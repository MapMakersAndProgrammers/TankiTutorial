package org.osflash.signals
{
   public class Slot implements ISlot
   {
      
      public var dimev:ISignal;
      
      public var dalipaz:Boolean = true;
      
      public var wefi:Function;
      
      public var deziqir:Boolean = false;
      
      public var rysaj:int = 0;
      
      public var ropohym:Array;
      
      public function Slot(param1:Function, param2:ISignal, param3:Boolean = false, param4:int = 0)
      {
         super();
         this.wefi = param1;
         this.deziqir = param3;
         this.dimev = param2;
         this.rysaj = param4;
         this.verifyListener(param1);
      }
      
      public function execute0() : void
      {
         if(!this.dalipaz)
         {
            return;
         }
         if(this.deziqir)
         {
            this.remove();
         }
         if(Boolean(this.ropohym) && Boolean(this.ropohym.length))
         {
            this.wefi.apply(null,this.ropohym);
            return;
         }
         this.wefi();
      }
      
      public function execute1(param1:Object) : void
      {
         if(!this.dalipaz)
         {
            return;
         }
         if(this.deziqir)
         {
            this.remove();
         }
         if(Boolean(this.ropohym) && Boolean(this.ropohym.length))
         {
            this.wefi.apply(null,[param1].concat(this.ropohym));
            return;
         }
         this.wefi(param1);
      }
      
      public function execute(param1:Array) : void
      {
         if(!this.dalipaz)
         {
            return;
         }
         if(this.deziqir)
         {
            this.remove();
         }
         if(Boolean(this.ropohym) && Boolean(this.ropohym.length))
         {
            param1 = param1.concat(this.ropohym);
         }
         var _loc2_:int = int(param1.length);
         if(_loc2_ == 0)
         {
            this.wefi();
         }
         else if(_loc2_ == 1)
         {
            this.wefi(param1[0]);
         }
         else if(_loc2_ == 2)
         {
            this.wefi(param1[0],param1[1]);
         }
         else if(_loc2_ == 3)
         {
            this.wefi(param1[0],param1[1],param1[2]);
         }
         else
         {
            this.wefi.apply(null,param1);
         }
      }
      
      public function getListener() : Function
      {
         return this.wefi;
      }
      
      public function setListener(param1:Function) : void
      {
         if(null == param1)
         {
            throw new ArgumentError("Given listener is null.\nDid you want to set enabled to false instead?");
         }
         this.verifyListener(param1);
         this.wefi = param1;
      }
      
      public function getOnce() : Boolean
      {
         return this.deziqir;
      }
      
      public function getPriority() : int
      {
         return this.rysaj;
      }
      
      public function toString() : String
      {
         return "[Slot listener: " + this.wefi + ", once: " + this.deziqir + ", priority: " + this.rysaj + ", enabled: " + this.dalipaz + "]";
      }
      
      public function getEnabled() : Boolean
      {
         return this.dalipaz;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this.dalipaz = param1;
      }
      
      public function getParams() : Array
      {
         return this.ropohym;
      }
      
      public function setParams(param1:Array) : void
      {
         this.ropohym = param1;
      }
      
      public function remove() : void
      {
         this.dimev.remove(this.wefi);
      }
      
      public function verifyListener(param1:Function) : void
      {
         if(null == param1)
         {
            throw new ArgumentError("Given listener is null.");
         }
         if(null == this.dimev)
         {
            throw new Error("Internal signal reference has not been set yet.");
         }
      }
   }
}

