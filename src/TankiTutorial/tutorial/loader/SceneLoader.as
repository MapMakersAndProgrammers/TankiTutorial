package tutorial.loader
{
   import alternativa.tanks.sound.SoundManager;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.utils.Dictionary;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class SceneLoader
   {
      
      private static const ripig:Dictionary = new Dictionary();
      
      private var tuce:XML;
      
      private var hon:Function;
      
      private var luwuqap:String;
      
      private var pamopejus:Vector.<Class>;
      
      private var zuzecoc:int;
      
      public function SceneLoader()
      {
         super();
      }
      
      public function load(param1:String, param2:Function) : void
      {
         var _loc4_:XML = null;
         this.hon = param2;
         var _loc3_:XML = Assets.config;
         this.pamopejus = Vector.<Class>([PropLibsLoader,PropMapLoader,HullsLoader,TurretsLoader,EffectsLoader,SoundsLoader,BitmapsLoader,MeshesLoader,SWFLoader,SkyboxLoader]);
         this.luwuqap = _loc3_.@baseURL.toString();
         for each(_loc4_ in _loc3_.elements("scene"))
         {
            if(_loc4_.@name.toString() == param1)
            {
               this.tuce = _loc4_;
               break;
            }
         }
         if(this.tuce != null)
         {
            this.luwuqap += this.tuce.@baseURL.toString();
            this.zuzecoc = -1;
            this.loadScene();
         }
      }
      
      private function loadScene() : void
      {
         var _loc1_:Class = null;
         var _loc2_:TanksLoader = null;
         var _loc3_:Function = null;
         ++this.zuzecoc;
         if(this.zuzecoc < this.pamopejus.length)
         {
            _loc1_ = this.pamopejus[this.zuzecoc];
            _loc2_ = ripig[_loc1_];
            if(_loc2_ == null)
            {
               _loc2_ = new _loc1_();
               ripig[_loc1_] = _loc2_;
            }
            if(_loc2_.check(this.tuce))
            {
               if(_loc2_ is SoundsLoader)
               {
                  _loc3_ = this.onSoundLoaded;
               }
               else
               {
                  _loc3_ = this.loadScene;
               }
               _loc2_.load(this.luwuqap,this.tuce,_loc3_);
            }
            else
            {
               this.loadScene();
            }
         }
         else
         {
            this.hon(this);
         }
      }
      
      private function onSoundLoaded() : void
      {
         var _loc1_:Tank = null;
         GameData.jifom.addSoundToSoundManager();
         for each(_loc1_ in GameData.gaz)
         {
            _loc1_.addSoundToSoundManager();
         }
         SoundManager.wiwoginut = 0.01;
         this.loadScene();
      }
   }
}

