package alternativa.physics.contactislands
{
   import alternativa.physics.Body;
   import alternativa.physics.BodyContact;
   
   public class ContactLevels
   {
      
      private const contacts:Vector.<BodyContact> = new Vector.<BodyContact>();
      
      public function ContactLevels()
      {
         super();
      }
      
      public function init(bodyContacts:Vector.<BodyContact>) : void
      {
         var len:int = int(bodyContacts.length);
         this.contacts.length = len;
         var i:int = 0;
         while(i < len)
         {
            this.contacts[i] = bodyContacts[i];
            i++;
         }
      }
      
      public function clear() : void
      {
         this.contacts.length = 0;
      }
      
      public function getStaticLevel(levelContacts:Vector.<BodyContact>, levelBodies:Vector.<Body>) : void
      {
         var i:int = 0;
         var contact:BodyContact = null;
         i = 0;
         while(i < this.contacts.length)
         {
            contact = this.contacts[i];
            if(this.isStaticContact(contact))
            {
               levelContacts[levelContacts.length] = contact;
               levelBodies[levelBodies.length] = this.getNonStaticBody(contact);
               this.removeContact(i);
               i--;
            }
            i++;
         }
         i = 0;
         while(i < this.contacts.length)
         {
            contact = this.contacts[i];
            if(levelBodies.indexOf(contact.body1) >= 0 && levelBodies.indexOf(contact.body2) >= 0)
            {
               levelContacts[levelContacts.length] = contact;
               this.removeContact(i);
               i--;
            }
            i++;
         }
      }
      
      private function isStaticContact(contact:BodyContact) : Boolean
      {
         return !(Boolean(contact.body1.movable) && Boolean(contact.body2.movable));
      }
      
      private function getNonStaticBody(contact:BodyContact) : Body
      {
         if(contact.body1.movable)
         {
            return contact.body1;
         }
         return contact.body2;
      }
      
      private function removeContact(index:int) : void
      {
         var lastIndex:int = this.contacts.length - 1;
         this.contacts[index] = this.contacts[lastIndex];
         this.contacts.length = lastIndex;
      }
      
      public function getNextLevel(bodies:Vector.<Body>, levelContacts:Vector.<BodyContact>, levelBodies:Vector.<Body>) : void
      {
         var i:int = 0;
         var contact:BodyContact = null;
         i = 0;
         while(i < this.contacts.length)
         {
            contact = this.contacts[i];
            if(this.isInContactWith(bodies,contact))
            {
               levelContacts[levelContacts.length] = contact;
               levelBodies[levelBodies.length] = this.getNextLevelBody(contact,bodies);
               this.removeContact(i);
               i--;
            }
            i++;
         }
         i = 0;
         while(i < this.contacts.length)
         {
            contact = this.contacts[i];
            if(levelBodies.indexOf(contact.body1) >= 0 && levelBodies.indexOf(contact.body2) >= 0)
            {
               levelContacts[levelContacts.length] = contact;
               this.removeContact(i);
               i--;
            }
            i++;
         }
      }
      
      private function isInContactWith(bodies:Vector.<Body>, contact:BodyContact) : Boolean
      {
         return bodies.indexOf(contact.body1) >= 0 || bodies.indexOf(contact.body2) >= 0;
      }
      
      private function getNextLevelBody(contact:BodyContact, bodies:Vector.<Body>) : Body
      {
         if(bodies.indexOf(contact.body1) < 0)
         {
            return contact.body1;
         }
         return contact.body2;
      }
      
      public function hasContacts() : Boolean
      {
         return this.contacts.length > 0;
      }
   }
}

