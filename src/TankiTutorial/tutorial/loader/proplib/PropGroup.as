package tutorial.loader.proplib
{
   public class PropGroup
   {
      
      public var gepocivaj:String;
      
      private var neludetur:Object;
      
      private var luwuqap:String;
      
      public function PropGroup(param1:XML, param2:String)
      {
         var _loc3_:XML = null;
         var _loc4_:PropMesh = null;
         var _loc5_:PropSprite = null;
         this.neludetur = new Object();
         super();
         this.gepocivaj = XMLUtils.getAttributeAsString(param1,"name");
         this.luwuqap = param2;
         for each(_loc3_ in param1.prop)
         {
            if(_loc3_.elements("mesh").length() > 0)
            {
               _loc4_ = new PropMesh(_loc3_.mesh[0],param2);
               _loc4_.gepocivaj = XMLUtils.getAttributeAsString(_loc3_,"name");
               this.neludetur[_loc4_.gepocivaj] = _loc4_;
            }
            else if(_loc3_.elements("sprite").length() > 0)
            {
               _loc5_ = new PropSprite(_loc3_.sprite[0],param2);
               _loc5_.gepocivaj = XMLUtils.getAttributeAsString(_loc3_,"name");
               this.neludetur[_loc5_.gepocivaj] = _loc5_;
            }
         }
      }
      
      public function loadProp(param1:String, param2:String, param3:Function) : void
      {
         var _loc4_:Object = this.neludetur[param1];
         if(_loc4_ is PropMesh)
         {
            PropMesh(_loc4_).load(param2,param3);
         }
         else if(_loc4_ is PropSprite)
         {
            param3(PropSprite(_loc4_).sprite);
         }
         else
         {
            param3();
         }
      }
   }
}

