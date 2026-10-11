package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   
   public class HitInfo
   {
      
      public var time:Number;
      
      public var body:Body;
      
      public var position:Vector3 = new Vector3();
      
      public var direction:Vector3 = new Vector3();
      
      public function HitInfo()
      {
         super();
      }
   }
}

