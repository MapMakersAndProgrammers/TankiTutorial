package alternativa.physics
{
   public class BodyContact
   {
      
      private static var pool:BodyContact;
      
      public var body1:Body;
      
      public var body2:Body;
      
      public var shapeContacts:Vector.<ShapeContact> = new Vector.<ShapeContact>();
      
      private var next:BodyContact;
      
      public function BodyContact()
      {
         super();
      }
      
      public static function create() : BodyContact
      {
         if(pool == null)
         {
            return new BodyContact();
         }
         var contact:BodyContact = pool;
         pool = pool.next;
         contact.next = null;
         return contact;
      }
      
      public function dispose() : void
      {
         var shapeContact:ShapeContact = null;
         this.body1 = null;
         this.body2 = null;
         var len:uint = this.shapeContacts.length;
         var i:int = 0;
         while(i < len)
         {
            shapeContact = this.shapeContacts[i];
            shapeContact.dispose();
            i++;
         }
         this.shapeContacts.length = 0;
         this.next = pool;
         pool = this;
      }
      
      public function copy(contact:BodyContact) : void
      {
         this.body1 = contact.body1;
         this.body2 = contact.body2;
         var contacts:Vector.<ShapeContact> = contact.shapeContacts;
         var len:uint = contacts.length;
         var i:int = 0;
         while(i < len)
         {
            this.shapeContacts[this.shapeContacts.length] = contacts[i];
            i++;
         }
      }
      
      public function setShapeContacts(contacts:Vector.<ShapeContact>) : void
      {
         var len:int = int(contacts.length);
         var i:int = 0;
         while(i < len)
         {
            this.shapeContacts[i] = contacts[i];
            i++;
         }
      }
   }
}

