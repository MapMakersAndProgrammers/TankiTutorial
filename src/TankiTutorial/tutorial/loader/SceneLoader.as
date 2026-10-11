package tutorial.loader
{
   import alternativa.tanks.sound.SoundManager;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.utils.Dictionary;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class SceneLoader
   {
      
      private static const loaders:Dictionary = new Dictionary();
      
      private var scene:XML;
      
      private var callback:Function;
      
      private var baseURL:String;
      
      private var loaderClasses:Vector.<Class>;
      
      private var index:int;
      
      public function SceneLoader()
      {
         super();
      }
      
      public function load(sceneName:String, callback:Function) : void
      {
         var sceneXML:XML = null;
         this.callback = callback;
         var config:XML = Assets.config;
         this.loaderClasses = Vector.<Class>([PropLibsLoader,PropMapLoader,HullsLoader,TurretsLoader,EffectsLoader,SoundsLoader,BitmapsLoader,MeshesLoader,SWFLoader,SkyboxLoader]);
         this.baseURL = config.@baseURL.toString();
         for each(sceneXML in config.elements("scene"))
         {
            if(sceneXML.@name.toString() == sceneName)
            {
               this.scene = sceneXML;
               break;
            }
         }
         if(this.scene != null)
         {
            this.baseURL += this.scene.@baseURL.toString();
            this.index = -1;
            this.loadScene();
         }
      }
      
      private function loadScene() : void
      {
         var loaderClass:Class = null;
         var loader:TanksLoader = null;
         var listener:Function = null;
         ++this.index;
         if(this.index < this.loaderClasses.length)
         {
            loaderClass = this.loaderClasses[this.index];
            loader = loaders[loaderClass];
            if(loader == null)
            {
               loader = new loaderClass();
               loaders[loaderClass] = loader;
            }
            if(loader.check(this.scene))
            {
               if(loader is SoundsLoader)
               {
                  listener = this.onSoundLoaded;
               }
               else
               {
                  listener = this.loadScene;
               }
               loader.load(this.baseURL,this.scene,listener);
            }
            else
            {
               this.loadScene();
            }
         }
         else
         {
            this.callback(this);
         }
      }
      
      private function onSoundLoaded() : void
      {
         var tank:Tank = null;
         GameData.playerTank.addSoundToSoundManager();
         for each(tank in GameData.tanks)
         {
            tank.addSoundToSoundManager();
         }
         SoundManager.wiwoginut = 0.01;
         this.loadScene();
      }
   }
}

