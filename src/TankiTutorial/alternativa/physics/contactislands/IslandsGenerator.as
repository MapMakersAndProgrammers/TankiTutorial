package alternativa.physics.contactislands
{
   import alternativa.physics.BodyContact;
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.QuickUnionFind;
   import alternativa.utils.clearDictionary;
   import flash.utils.Dictionary;
   
   public class IslandsGenerator
   {
      
      public const islands:Vector.<ContactIsland> = new Vector.<ContactIsland>();
      
      private const islandsByRoot:Dictionary = new Dictionary();
      
      private const unionFind:QuickUnionFind = new QuickUnionFind();
      
      private var physicsScene:PhysicsScene;
      
      public function IslandsGenerator(physicsScene:PhysicsScene)
      {
         super();
         this.physicsScene = physicsScene;
      }
      
      public function generate(contacts:Vector.<BodyContact>, numBodies:int) : void
      {
         this.createUnions(contacts,numBodies);
         this.createIslands(contacts);
      }
      
      private function createUnions(contacts:Vector.<BodyContact>, numBodies:int) : void
      {
         var contact:BodyContact = null;
         this.unionFind.init(numBodies);
         var len:int = int(contacts.length);
         var i:int = 0;
         while(i < len)
         {
            contact = contacts[i];
            if(contact.body1.movable && contact.body2.movable)
            {
               this.unionFind.union(contact.body1.id,contact.body2.id);
            }
            i++;
         }
      }
      
      private function createIslands(contacts:Vector.<BodyContact>) : void
      {
         var contact:BodyContact = null;
         var root:int = 0;
         var island:ContactIsland = null;
         var len:int = int(contacts.length);
         var i:int = 0;
         while(i < len)
         {
            contact = contacts[i];
            if(contact.body1.movable)
            {
               root = int(this.unionFind.root(contact.body1.id));
            }
            else
            {
               root = int(this.unionFind.root(contact.body2.id));
            }
            island = this.islandsByRoot[root];
            if(island == null)
            {
               island = ContactIsland.create();
               this.islands[this.islands.length] = island;
               this.islandsByRoot[root] = island;
            }
            island.bodyContacts[island.bodyContacts.length] = contact;
            i++;
         }
         var numIslands:int = int(this.islands.length);
         var j:int = 0;
         while(j < numIslands)
         {
            island = this.islands[j];
            island.init(this.physicsScene);
            j++;
         }
         clearDictionary(this.islandsByRoot);
      }
      
      public function clear() : void
      {
         var island:ContactIsland = null;
         var len:int = int(this.islands.length);
         var i:int = 0;
         while(i < len)
         {
            island = this.islands[i];
            island.dispose();
            i++;
         }
         this.islands.length = 0;
      }
   }
}

