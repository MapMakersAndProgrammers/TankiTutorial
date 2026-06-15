package tutorial.loader
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.SkyBox;
   import flash.display.BitmapData;
   import tutorial.GameData;
   
   public class SkyboxLoader extends TanksLoader
   {
      
      public function SkyboxLoader()
      {
         super();
      }
      
      override public function check(param1:XML) : Boolean
      {
         return param1.skybox.length() > 0;
      }
      
      override public function load(param1:String, param2:XML, param3:Function) : void
      {
         var _loc7_:XML = null;
         this.pomagu = param2.skybox[0];
         this.hon = param3;
         var _loc4_:Vector.<String> = new Vector.<String>();
         var _loc5_:String = param1 + pomagu.@baseURL;
         var _loc6_:int = 0;
         for each(_loc7_ in pomagu.elements("bitmap"))
         {
            _loc4_[_loc6_] = _loc5_ + _loc7_.@url.toString();
            _loc6_++;
         }
         GameData.root.addChildAt(this.createSkyBox(_loc4_),0);
         if(param3 != null)
         {
            param3();
         }
      }
      
      private function createSkyBox(param1:Vector.<String>) : SkyBox
      {
         var _loc2_:BitmapData = new BitmapData(1,1,false,10475506);
         var _loc3_:TextureMaterial = new TextureMaterial(_loc2_);
         var _loc4_:TextureMaterial = new TextureMaterial(_loc2_);
         var _loc5_:TextureMaterial = new TextureMaterial(_loc2_);
         var _loc6_:TextureMaterial = new TextureMaterial(_loc2_);
         var _loc7_:TextureMaterial = new TextureMaterial(_loc2_);
         var _loc8_:TextureMaterial = new TextureMaterial(_loc2_);
         _loc3_.diffuseMapURL = param1[0];
         _loc4_.diffuseMapURL = param1[1];
         _loc5_.diffuseMapURL = param1[2];
         _loc6_.diffuseMapURL = param1[3];
         _loc7_.diffuseMapURL = param1[4];
         _loc8_.diffuseMapURL = param1[5];
         GameData.ciqoby.addToQueue(_loc3_,10);
         GameData.ciqoby.addToQueue(_loc4_,10);
         GameData.ciqoby.addToQueue(_loc5_,10);
         GameData.ciqoby.addToQueue(_loc6_,10);
         GameData.ciqoby.addToQueue(_loc7_,10);
         GameData.ciqoby.addToQueue(_loc8_,10);
         var _loc9_:int = 200000;
         return new SkyBox(_loc9_,_loc5_,_loc3_,_loc4_,_loc6_,_loc8_,_loc7_);
      }
   }
}

