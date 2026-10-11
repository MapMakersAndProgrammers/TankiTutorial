package alternativa.tanks.battle.triggers
{
   import alternativa.physics.Body;
   import alternativa.tanks.battle.*;
   
   public class Triggers
   {
      
      private const triggers:Vector.<Trigger> = new Vector.<Trigger>();
      
      private const deferredActions:Vector.<DeferredAction> = new Vector.<DeferredAction>();
      
      private var checking:Boolean;
      
      public function Triggers()
      {
         super();
      }
      
      public function add(trigger:Trigger) : void
      {
         if(this.checking)
         {
            this.deferredActions.push(new DeferredTriggerAddition(this,trigger));
         }
         else if(this.triggers.indexOf(trigger) < 0)
         {
            this.triggers.push(trigger);
         }
      }
      
      public function remove(trigger:Trigger) : void
      {
         var len:int = 0;
         var index:int = 0;
         if(this.checking)
         {
            this.deferredActions.push(new DeferredTriggerDeletion(this,trigger));
         }
         else
         {
            len = int(this.triggers.length);
            if(len > 0)
            {
               index = this.triggers.indexOf(trigger);
               if(index >= 0)
               {
                  this.triggers[index] = this.triggers[--len];
                  this.triggers.length = len;
               }
            }
         }
      }
      
      public function check(body:Body) : void
      {
         var len:int = 0;
         var i:int = 0;
         var trigger:Trigger = null;
         if(body != null)
         {
            this.checking = true;
            len = int(this.triggers.length);
            i = 0;
            while(i < len)
            {
               trigger = this.triggers[i];
               trigger.checkTrigger(body);
               i++;
            }
            this.checking = false;
            this.executeDeferredActions();
         }
      }
      
      private function executeDeferredActions() : void
      {
         var action:DeferredAction = null;
         while(true)
         {
            action = this.deferredActions.pop();
            if(action == null)
            {
               break;
            }
            action.execute();
         }
      }
   }
}

