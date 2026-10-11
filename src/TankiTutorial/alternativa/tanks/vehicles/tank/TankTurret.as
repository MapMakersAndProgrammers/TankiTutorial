package alternativa.tanks.vehicles.tank
{
   import alternativa.math.Vector3;
   
   public class TankTurret extends TankPart
   {
      
      public var muzzles:Vector.<Vector3> = new Vector.<Vector3>();
      
      public var flagMountPoint:Vector3 = new Vector3();
      
      public var turnAcceleration:Number;
      
      public var maxTurnSpeed:Number;
      
      public var damage:Number;
      
      public function TankTurret()
      {
         super();
      }
   }
}

