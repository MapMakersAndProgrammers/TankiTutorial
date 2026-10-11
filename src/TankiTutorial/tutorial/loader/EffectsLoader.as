package tutorial.loader
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.utils.GraphicsUtils;
   import flash.display.BitmapData;
   import tutorial.commons.Assets;
   
   public class EffectsLoader extends TanksLoader
   {
      
      private var effects:Vector.<XML>;
      
      private var baseURL:String;
      
      private var index:int;
      
      public function EffectsLoader()
      {
         super();
      }
      
      override public function check(sceneXML:XML) : Boolean
      {
         return sceneXML.effects.length() > 0;
      }
      
      override public function load(sceneURL:String, sceneXML:XML, completeListener:Function) : void
      {
         var effectXML:XML = null;
         this.xml = sceneXML.effects[0];
         this.callback = completeListener;
         this.effects = new Vector.<XML>();
         this.index = 0;
         this.baseURL = sceneURL + xml.@baseURL;
         var i:int = 0;
         for each(effectXML in xml.elements("effect"))
         {
            this.effects[i] = effectXML;
            i++;
         }
         this.loadEffect();
      }
      
      private function loadEffect() : void
      {
         if(this.index < this.effects.length)
         {
            if(Assets.hasData(this.effects[this.index].@id.toString(),TextureAnimation))
            {
               ++this.index;
               this.loadEffect();
            }
            else
            {
               currentURL = this.baseURL + this.effects[this.index].@url.toString();
               imageLoader.load(this.baseURL + this.effects[this.index].@url.toString(),this.saveBitmap);
            }
         }
         else if(callback != null)
         {
            callback();
         }
      }
      
      private function saveBitmap(bitmapData:BitmapData) : void
      {
         var effect:XML = null;
         var material:TextureMaterial = null;
         var frameWidth:Number = NaN;
         var frameHeight:Number = NaN;
         if(bitmapData != null)
         {
            effect = this.effects[this.index];
            material = new TextureMaterial(bitmapData,false,true,MipMapping.NONE,2.5);
            frameWidth = effect.@frameWidth > 0 ? Number(effect.@frameWidth) : bitmapData.height;
            frameHeight = effect.@frameHeight > 0 ? Number(effect.@frameHeight) : bitmapData.height;
            Assets.saveData(effect.@id.toString(),new TextureAnimation(material,GraphicsUtils.getUVFramesFromTexture(bitmapData,frameWidth,frameHeight,effect.@numFrames),effect.@fps > 0 ? Number(effect.@fps) : 30),TextureAnimation);
         }
         ++this.index;
         this.loadEffect();
      }
   }
}

