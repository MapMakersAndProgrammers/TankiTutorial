package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;
   
   public class Vertex
   {
      
      alternativa3d static var collector:Vertex;
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var z:Number = 0;
      
      public var u:Number = 0;
      
      public var v:Number = 0;
      
      public var normalX:Number;
      
      public var normalY:Number;
      
      public var normalZ:Number;
      
      alternativa3d var cameraX:Number;
      
      alternativa3d var cameraY:Number;
      
      alternativa3d var cameraZ:Number;
      
      alternativa3d var offset:Number = 1;
      
      alternativa3d var transformId:int = 0;
      
      alternativa3d var drawId:int = 0;
      
      alternativa3d var index:int;
      
      alternativa3d var next:Vertex;
      
      alternativa3d var value:Vertex;
      
      public var id:Object;
      
      public function Vertex()
      {
         super();
      }
      
      alternativa3d static function createList(num:int) : Vertex
      {
         var last:Vertex = null;
         var res:Vertex = collector;
         if(res != null)
         {
            for(last = res; num > 1; )
            {
               last.transformId = 0;
               last.drawId = 0;
               if(last.next == null)
               {
                  while(num > 1)
                  {
                     last.next = new Vertex();
                     last = last.next;
                     num--;
                  }
                  break;
               }
               last = last.next;
               num--;
            }
            collector = last.next;
            last.transformId = 0;
            last.drawId = 0;
            last.next = null;
         }
         else
         {
            res = new Vertex();
            for(last = res; num > 1; )
            {
               last.next = new Vertex();
               last = last.next;
               num--;
            }
         }
         return res;
      }
      
      alternativa3d function create() : Vertex
      {
         var res:Vertex = null;
         if(collector != null)
         {
            res = collector;
            collector = res.next;
            res.next = null;
            res.transformId = 0;
            res.drawId = 0;
            return res;
         }
         return new Vertex();
      }
      
      public function toString() : String
      {
         return "[Vertex " + this.id + " " + this.x.toFixed(2) + ", " + this.y.toFixed(2) + ", " + this.z.toFixed(2) + ", " + this.u.toFixed(3) + ", " + this.v.toFixed(3) + "]";
      }
   }
}

