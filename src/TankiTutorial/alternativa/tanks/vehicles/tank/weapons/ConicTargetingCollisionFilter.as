package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.physics.Body;
   import alternativa.physics.collision.IRayCollisionFilter;
   import flash.utils.Dictionary;
   
   public class ConicTargetingCollisionFilter implements IRayCollisionFilter
   {
      
      public var wyd:Body;
      
      private var diza:Dictionary = new Dictionary();
      
      private var vibulir:Dictionary = new Dictionary();
      
      public function ConicTargetingCollisionFilter()
      {
         super();
      }
      
      public function considerBody(param1:Body) : Boolean
      {
         return this.wyd != param1 && this.diza[param1] == null && this.vibulir[param1] == null;
      }
      
      public function addTarget(param1:Body) : void
      {
         this.diza[param1] = true;
      }
      
      public function addInvalidTarget(param1:Body) : void
      {
         this.vibulir[param1] = true;
      }
      
      public function clearTargets() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.diza)
         {
            delete this.diza[_loc1_];
         }
      }
      
      public function clearInvalidTargets() : void
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this.vibulir)
         {
            delete this.vibulir[_loc1_];
         }
      }
   }
}

