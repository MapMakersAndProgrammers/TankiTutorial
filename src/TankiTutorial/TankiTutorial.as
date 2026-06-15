package
{
   import alternativa.tanks.sfx.LightData;
   import embed.Embed;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import tutorial.Game;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   import tutorial.commons.InitialDataLoader;
   import tutorial.commons.Lang;
   import tutorial.commons.Shared;
   
   [SWF(backgroundColor="#1B1B19",frameRate="60",width="900",height="700")]
   public class TankiTutorial extends Sprite
   {
      
      private static const ceqykepa:Class = TankiTutorial_ttfFont;
      
      private var vutofom:Game;
      
      public function TankiTutorial()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         Lang.init();
         LightData.init();
         GameData.createGameData(stage,this);
         Shared.currentStep = "StartLoadResources";
         if(!Assets.initialDataIsSaved)
         {
            InitialDataLoader.load(this.init);
         }
         else
         {
            Embed.init(this.start);
         }
      }
      
      private function init() : void
      {
         Embed.init(this.start);
      }
      
      private function start() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in InitialDataLoader.textures)
         {
            GameData.colorize(_loc1_);
            delete InitialDataLoader.textures[_loc1_];
         }
         InitialDataLoader.onAfterComplete();
         this.vutofom = new Game();
         this.vutofom.start();
      }
   }
}

