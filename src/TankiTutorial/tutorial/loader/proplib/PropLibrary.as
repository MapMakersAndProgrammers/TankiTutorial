package tutorial.loader.proplib
{
   import tutorial.loader.BaseLoader;
   
   public class PropLibrary extends BaseLoader
   {
      
      public var name:String;
      
      private var xml:XML;
      
      private var groups:Object;
      
      private var baseURL:String;
      
      public var priority:int;
      
      public function PropLibrary(xml:XML, baseURL:String)
      {
         var groupXML:XML = null;
         var group:PropGroup = null;
         this.groups = new Object();
         super();
         this.xml = xml;
         this.baseURL = baseURL;
         this.name = XMLUtils.getAttributeAsString(xml,"name");
         onFinishLoad();
         for each(groupXML in xml.elements("prop-group"))
         {
            group = new PropGroup(groupXML,baseURL);
            this.groups[group.name] = group;
         }
      }
      
      public function loadObject(groupName:String, propName:String, textureName:String, callback:Function) : void
      {
         var group:PropGroup = this.groups[groupName];
         group.loadProp(propName,textureName,callback);
      }
   }
}

