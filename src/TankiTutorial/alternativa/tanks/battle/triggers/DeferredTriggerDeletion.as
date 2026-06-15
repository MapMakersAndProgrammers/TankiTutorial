package alternativa.tanks.battle.triggers
{
   import alternativa.tanks.battle.DeferredAction;
   import alternativa.tanks.battle.Trigger;
   
   public class DeferredTriggerDeletion implements DeferredAction
   {
      
      private var nykoto:Triggers;
      
      private var wyqitywi:Trigger;
      
      public function DeferredTriggerDeletion(param1:Triggers, param2:Trigger)
      {
         super();
         this.nykoto = param1;
         this.wyqitywi = param2;
      }
      
      public function execute() : void
      {
         this.nykoto.remove(this.wyqitywi);
      }
   }
}

