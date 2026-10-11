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
      
      private static var numSuicides:int = 0;
      
      private static var numJumps:int = 0;
      
      private const playerTank:Tank = GameData.playerTank;
      
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
         if(Boolean(this.playerTank.kat) && this.playerTank.hogys.body.state.position.z < -2000)
         {
            this.playerTank.kill();
            this.playerTank.hogys.kyripama.collisionGroup &= ~CollisionGroup.BONUS;
            ++numJumps;
            Shared.tracker.trackEvent(Shared.TUTORIAL_STAT,"jump_" + numJumps,Shared.currentStep);
            setTimeout(this.respawn,1500);
         }
         return false;
      }
      
      private function onKeyDown(keyboardEvent:KeyboardEvent) : void
      {
         if(keyboardEvent.keyCode == Keyboard.DELETE && Boolean(this.playerTank.kat))
         {
            this.playerTank.kill();
            ++numSuicides;
            Shared.tracker.trackEvent(Shared.TUTORIAL_STAT,"suicide_" + numSuicides,Shared.currentStep);
            setTimeout(this.respawn,1500);
         }
      }
      
      private function respawn() : void
      {
         this.playerTank.respawn();
         this.playerTank.hogys.kyripama.collisionGroup |= CollisionGroup.BONUS;
      }
   }
}

