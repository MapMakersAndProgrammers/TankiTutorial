package tutorial.loader.proplib
{
   public class PropGroup
   {
      
      public var name:String;
      
      private var props:Object;
      
      private var baseURL:String;
      
      public function PropGroup(xml:XML, baseURL:String)
      {
         var propXML:XML = null;
         var propMesh:PropMesh = null;
         var propSprite:PropSprite = null;
         this.props = new Object();
         super();
         this.name = XMLUtils.getAttributeAsString(xml,"name");
         this.baseURL = baseURL;
         for each(propXML in xml.prop)
         {
            if(propXML.elements("mesh").length() > 0)
            {
               propMesh = new PropMesh(propXML.mesh[0],baseURL);
               propMesh.name = XMLUtils.getAttributeAsString(propXML,"name");
               this.props[propMesh.name] = propMesh;
            }
            else if(propXML.elements("sprite").length() > 0)
            {
               propSprite = new PropSprite(propXML.sprite[0],baseURL);
               propSprite.name = XMLUtils.getAttributeAsString(propXML,"name");
               this.props[propSprite.name] = propSprite;
            }
         }
      }
      
      public function loadProp(propName:String, textureName:String, callback:Function) : void
      {
         var prop:Object = this.props[propName];
         if(prop is PropMesh)
         {
            PropMesh(prop).load(textureName,callback);
         }
         else if(prop is PropSprite)
         {
            callback(PropSprite(prop).sprite);
         }
         else
         {
            callback();
         }
      }
   }
}

