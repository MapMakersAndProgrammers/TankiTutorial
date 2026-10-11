package tutorial.loader.proplib
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   
   public class PropSprite
   {
      
      public var name:String;
      
      private var url:String;
      
      private var baseURL:String;
      
      private var _sprite:Sprite3D;
      
      public function PropSprite(xml:XML, baseURL:String)
      {
         super();
         this.baseURL = baseURL;
         this.url = baseURL + XMLUtils.getAttributeAsString(xml,"file");
         var material:TextureMaterial = new TextureMaterial(null,false,true,MipMapping.PER_PIXEL,5);
         material.diffuseMapURL = this.url;
         this._sprite = new Sprite3D(1,1,material);
         this._sprite.autoSize = true;
         this._sprite.originX = XMLUtils.getAttributeAsNumber(xml,"origin-x",0.5);
         this._sprite.originY = XMLUtils.getAttributeAsNumber(xml,"origin-y",0.5);
         var scale:Number = XMLUtils.getAttributeAsNumber(xml,"scale",1);
         this._sprite.scaleX = scale;
         this._sprite.scaleY = scale;
         this._sprite.scaleZ = scale;
         this._sprite.softAttenuation = 150;
         this._sprite.name = "bush";
      }
      
      public function get sprite() : Sprite3D
      {
         return this._sprite;
      }
   }
}

