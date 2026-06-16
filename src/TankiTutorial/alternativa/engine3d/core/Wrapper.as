package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;
   
   public class Wrapper
   {
      
      alternativa3d static var collector:Wrapper;
      
      alternativa3d var next:Wrapper;
      
      alternativa3d var vertex:Vertex;
      
      public function Wrapper()
      {
         super();
      }
      
      alternativa3d static function create() : Wrapper
      {
         var res:Wrapper = null;
         if(collector != null)
         {
            res = collector;
            collector = collector.next;
            res.next = null;
            return res;
         }
         return new Wrapper();
      }
      
      alternativa3d function create() : Wrapper
      {
         var res:Wrapper = null;
         if(collector != null)
         {
            res = collector;
            collector = collector.next;
            res.next = null;
            return res;
         }
         return new Wrapper();
      }
   }
}

