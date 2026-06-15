package tutorial.loader.proplib
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   
   public class PropSprite
   {
      
      public var gepocivaj:String;
      
      private var zuqu:String;
      
      private var luwuqap:String;
      
      private var niqybyga:Sprite3D;
      
      public function PropSprite(param1:XML, param2:String)
      {
         super();
         this.luwuqap = param2;
         this.zuqu = param2 + XMLUtils.getAttributeAsString(param1,"file");
         var _loc3_:TextureMaterial = new TextureMaterial(null,false,true,MipMapping.PER_PIXEL,5);
         _loc3_.diffuseMapURL = this.zuqu;
         this.niqybyga = new Sprite3D(1,1,_loc3_);
         this.niqybyga.autoSize = true;
         this.niqybyga.originX = XMLUtils.getAttributeAsNumber(param1,"origin-x",0.5);
         this.niqybyga.originY = XMLUtils.getAttributeAsNumber(param1,"origin-y",0.5);
         var _loc4_:Number = XMLUtils.getAttributeAsNumber(param1,"scale",1);
         this.niqybyga.scaleX = _loc4_;
         this.niqybyga.scaleY = _loc4_;
         this.niqybyga.scaleZ = _loc4_;
         this.niqybyga.softAttenuation = 150;
         this.niqybyga.name = "bush";
      }
      
      public function get sprite() : Sprite3D
      {
         return this.niqybyga;
      }
   }
}

