package tutorial.tasks
{
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import flash.utils.setTimeout;
   import tutorial.GameData;
   import tutorial.commons.Shared;
   
   public class PlayerRespawnTask extends Task
   {
      
      private static var begyzev:int = 0;
      
      private static var fer:int = 0;
      
      private const jifom:Tank = GameData.jifom;
      
      private var stage:Stage = GameData.stage;
      
      private var init:Boolean;
      
      public function PlayerRespawnTask()
      {
         super();
      }
      
      override public function process() : Boolean
      {
         if(!this.init)
         {
            this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
            this.init = true;
         }
         if(Boolean(this.jifom.kat) && this.jifom.hogys.body.kejo.position.z < -2000)
         {
            this.jifom.kill();
            this.jifom.hogys.kyripama.nute &= ~CollisionGroup.nuqa;
            ++fer;
            Shared.tracker.trackEvent(Shared.TUTORIAL_STAT,"jump_" + fer,Shared.currentStep);
            setTimeout(this.respawn,1500);
         }
         return false;
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.DELETE && Boolean(this.jifom.kat))
         {
            this.jifom.kill();
            ++begyzev;
            Shared.tracker.trackEvent(Shared.TUTORIAL_STAT,"suicide_" + begyzev,Shared.currentStep);
            setTimeout(this.respawn,1500);
         }
      }
      
      private function respawn() : void
      {
         this.jifom.respawn();
         this.jifom.hogys.kyripama.nute |= CollisionGroup.nuqa;
      }
   }
}

