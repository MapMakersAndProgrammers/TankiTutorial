package tutorial
{
   import tutorial.commons.Assets;
   import tutorial.loader.SceneLoader;
   
   public class DependenciesLoader
   {
      
      private static const loaded:Object = {};
      
      private var dependencies:Array;
      
      private var index:int;
      
      private var callback:Function;
      
      private var currentDependency:String;
      
      public function DependenciesLoader()
      {
         super();
      }
      
      public function load(dependencies:Array, callback:Function) : void
      {
         var name:String = null;
         var sceneXML:XML = null;
         var sceneName:String = null;
         this.dependencies = dependencies;
         this.callback = callback;
         var config:XML = Assets.config;
         this.index = 0;
         var notLoaded:Object = {};
         for each(name in dependencies)
         {
            if(!loaded[name])
            {
               notLoaded[name] = true;
            }
         }
         for each(sceneXML in config.scene)
         {
            sceneName = sceneXML.@name.toString();
            if(Boolean(notLoaded[sceneName]))
            {
               delete notLoaded[sceneName];
            }
         }
         this.loadDependency();
      }
      
      private function loadDependency(loader:SceneLoader = null) : void
      {
         var sceneLoader:SceneLoader = null;
         if(loader != null)
         {
            ++this.index;
            loaded[this.currentDependency] = true;
         }
         if(this.index < this.dependencies.length)
         {
            this.currentDependency = this.dependencies[this.index];
            if(Boolean(loaded[this.currentDependency]))
            {
               ++this.index;
               this.loadDependency();
            }
            else
            {
               sceneLoader = new SceneLoader();
               sceneLoader.load(this.currentDependency,this.loadDependency);
            }
         }
         else
         {
            this.callback();
         }
      }
   }
}

