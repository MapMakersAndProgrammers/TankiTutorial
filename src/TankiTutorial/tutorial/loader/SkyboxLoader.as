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
      
      override public function check(sceneXML:XML) : Boolean
      {
         return sceneXML.skybox.length() > 0;
      }
      
      override public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
         var bitmapXML:XML = null;
         this.xml = sceneXML.skybox[0];
         this.callback = completeListener;
         var urls:Vector.<String> = new Vector.<String>();
         var baseURL:String = sceneURL + xml.@baseURL;
         var i:int = 0;
         for each(bitmapXML in xml.elements("bitmap"))
         {
            urls[i] = baseURL + bitmapXML.@url.toString();
            i++;
         }
         GameData.root.addChildAt(this.createSkyBox(urls),0);
         if(completeListener != null)
         {
            completeListener();
         }
      }
      
      private function createSkyBox(urls:Vector.<String>) : SkyBox
      {
         var bitmapData:BitmapData = new BitmapData(1,1,false,10475506);
         var left:TextureMaterial = new TextureMaterial(bitmapData);
         var right:TextureMaterial = new TextureMaterial(bitmapData);
         var back:TextureMaterial = new TextureMaterial(bitmapData);
         var front:TextureMaterial = new TextureMaterial(bitmapData);
         var bottom:TextureMaterial = new TextureMaterial(bitmapData);
         var top:TextureMaterial = new TextureMaterial(bitmapData);
         left.diffuseMapURL = urls[0];
         right.diffuseMapURL = urls[1];
         back.diffuseMapURL = urls[2];
         front.diffuseMapURL = urls[3];
         bottom.diffuseMapURL = urls[4];
         top.diffuseMapURL = urls[5];
         GameData.texturesLoader.addToQueue(left,10);
         GameData.texturesLoader.addToQueue(right,10);
         GameData.texturesLoader.addToQueue(back,10);
         GameData.texturesLoader.addToQueue(front,10);
         GameData.texturesLoader.addToQueue(bottom,10);
         GameData.texturesLoader.addToQueue(top,10);
         var size:int = 200000;
         return new SkyBox(size,back,left,right,front,top,bottom);
      }
   }
}

