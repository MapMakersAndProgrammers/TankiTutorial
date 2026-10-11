package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.physics.Body;
   import alternativa.physics.collision.IRayCollisionFilter;
   import flash.utils.Dictionary;
   
   public class ConicTargetingCollisionFilter implements IRayCollisionFilter
   {
      
      public var excludedBody:Body;
      
      private var targets:Dictionary = new Dictionary();
      
      private var invalidTargets:Dictionary = new Dictionary();
      
      public function ConicTargetingCollisionFilter()
      {
         super();
      }
      
      public function considerBody(body:Body) : Boolean
      {
         return this.excludedBody != body && this.targets[body] == null && this.invalidTargets[body] == null;
      }
      
      public function addTarget(body:Body) : void
      {
         this.targets[body] = true;
      }
      
      public function addInvalidTarget(body:Body) : void
      {
         this.invalidTargets[body] = true;
      }
      
      public function clearTargets() : void
      {
         var key:* = undefined;
         for(key in this.targets)
         {
            delete this.targets[key];
         }
      }
      
      public function clearInvalidTargets() : void
      {
         var key:* = undefined;
         for(key in this.invalidTargets)
         {
            delete this.invalidTargets[key];
         }
      }
   }
}

