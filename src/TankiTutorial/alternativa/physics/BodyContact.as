package alternativa.physics
{
   public class BodyContact
   {
      
      private static var bagid:BodyContact;
      
      public var rukowicyp:Body;
      
      public var zata:Body;
      
      public var pupicic:Vector.<ShapeContact> = new Vector.<ShapeContact>();
      
      private var qesyqeno:BodyContact;
      
      public function BodyContact()
      {
         super();
      }
      
      public static function create() : BodyContact
      {
         if(bagid == null)
         {
            return new BodyContact();
         }
         var _loc1_:BodyContact = bagid;
         bagid = bagid.qesyqeno;
         _loc1_.qesyqeno = null;
         return _loc1_;
      }
      
      public function dispose() : void
      {
         var _loc3_:ShapeContact = null;
         this.rukowicyp = null;
         this.zata = null;
         var _loc1_:uint = this.pupicic.length;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.pupicic[_loc2_];
            _loc3_.dispose();
            _loc2_++;
         }
         this.pupicic.length = 0;
         this.qesyqeno = bagid;
         bagid = this;
      }
      
      public function copy(param1:BodyContact) : void
      {
         this.rukowicyp = param1.rukowicyp;
         this.zata = param1.zata;
         var _loc2_:Vector.<ShapeContact> = param1.pupicic;
         var _loc3_:uint = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.pupicic[this.pupicic.length] = _loc2_[_loc4_];
            _loc4_++;
         }
      }
      
      public function setShapeContacts(param1:Vector.<ShapeContact>) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.pupicic[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
      }
   }
}

