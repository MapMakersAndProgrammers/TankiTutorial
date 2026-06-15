package tutorial.loader.proplib
{
   import tutorial.loader.BaseLoader;
   
   public class PropLibrary extends BaseLoader
   {
      
      public var gepocivaj:String;
      
      private var pomagu:XML;
      
      private var qynihevu:Object;
      
      private var luwuqap:String;
      
      public var gohigewam:int;
      
      public function PropLibrary(param1:XML, param2:String)
      {
         var _loc3_:XML = null;
         var _loc4_:PropGroup = null;
         this.qynihevu = new Object();
         super();
         this.pomagu = param1;
         this.luwuqap = param2;
         this.gepocivaj = XMLUtils.getAttributeAsString(param1,"name");
         onFinishLoad();
         for each(_loc3_ in param1.elements("prop-group"))
         {
            _loc4_ = new PropGroup(_loc3_,param2);
            this.qynihevu[_loc4_.gepocivaj] = _loc4_;
         }
      }
      
      public function loadObject(param1:String, param2:String, param3:String, param4:Function) : void
      {
         var _loc5_:PropGroup = this.qynihevu[param1];
         _loc5_.loadProp(param2,param3,param4);
      }
   }
}

