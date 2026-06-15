package alternativa.tanks.battle.triggers
{
   import alternativa.physics.Body;
   import alternativa.tanks.battle.*;
   
   public class Triggers
   {
      
      private const wamura:Vector.<Trigger> = new Vector.<Trigger>();
      
      private const muvymow:Vector.<DeferredAction> = new Vector.<DeferredAction>();
      
      private var cinyfutu:Boolean;
      
      public function Triggers()
      {
         super();
      }
      
      public function add(param1:Trigger) : void
      {
         if(this.cinyfutu)
         {
            this.muvymow.push(new DeferredTriggerAddition(this,param1));
         }
         else if(this.wamura.indexOf(param1) < 0)
         {
            this.wamura.push(param1);
         }
      }
      
      public function remove(param1:Trigger) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.cinyfutu)
         {
            this.muvymow.push(new DeferredTriggerDeletion(this,param1));
         }
         else
         {
            _loc2_ = int(this.wamura.length);
            if(_loc2_ > 0)
            {
               _loc3_ = this.wamura.indexOf(param1);
               if(_loc3_ >= 0)
               {
                  this.wamura[_loc3_] = this.wamura[--_loc2_];
                  this.wamura.length = _loc2_;
               }
            }
         }
      }
      
      public function check(param1:Body) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Trigger = null;
         if(param1 != null)
         {
            this.cinyfutu = true;
            _loc2_ = int(this.wamura.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.wamura[_loc3_];
               _loc4_.checkTrigger(param1);
               _loc3_++;
            }
            this.cinyfutu = false;
            this.executeDeferredActions();
         }
      }
      
      private function executeDeferredActions() : void
      {
         var _loc1_:DeferredAction = null;
         while(true)
         {
            _loc1_ = this.muvymow.pop();
            if(_loc1_ == null)
            {
               break;
            }
            _loc1_.execute();
         }
      }
   }
}

