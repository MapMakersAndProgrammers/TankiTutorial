package alternativa.physics
{
   public class QuickUnionFind
   {
      
      private var parents:Vector.<int>;
      
      private var sizes:Vector.<int>;
      
      public function QuickUnionFind()
      {
         super();
         this.parents = new Vector.<int>(1);
         this.sizes = new Vector.<int>(1);
      }
      
      public function init(count:int) : void
      {
         this.parents.length = count;
         this.sizes.length = count;
         var i:int = 0;
         while(i < count)
         {
            this.parents[i] = i;
            this.sizes[i] = 1;
            i++;
         }
      }
      
      public function union(a:int, b:int) : void
      {
         var rootA:int = 0;
         var rootB:int = 0;
         var sizeA:int = 0;
         var sizeB:int = 0;
         if(!this.connected(a,b))
         {
            rootA = this.root(a);
            rootB = this.root(b);
            sizeA = this.sizes[rootA];
            sizeB = this.sizes[rootB];
            if(sizeA > sizeB)
            {
               this.parents[rootB] = rootA;
               this.sizes[rootA] += sizeB;
            }
            else
            {
               this.parents[rootA] = rootB;
               this.sizes[rootB] += sizeA;
            }
         }
      }
      
      public function connected(a:int, b:int) : Boolean
      {
         return this.root(a) == this.root(b);
      }
      
      public function root(index:int) : int
      {
         var id:int = index;
         while(this.parents[id] != id)
         {
            id = this.parents[id];
         }
         return id;
      }
   }
}

