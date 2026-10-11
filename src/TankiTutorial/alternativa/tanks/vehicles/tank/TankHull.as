package alternativa.tanks.vehicles.tank
{
   import alternativa.math.Vector3;
   
   public class TankHull extends TankPart
   {
      
      public var mountPoint:Vector3 = new Vector3();
      
      public var mass:Number;
      
      public var damping:Number;
      
      public var speed:Number;
      
      public var acceleration:Number;
      
      public var reverseAcceleration:Number;
      
      public var sideAcceleration:Number;
      
      public var turnSpeed:Number;
      
      public var turnAcceleration:Number;
      
      public var reverseTurnAcceleration:Number;
      
      public var health:Number;
      
      public function TankHull()
      {
         super();
      }
   }
}

