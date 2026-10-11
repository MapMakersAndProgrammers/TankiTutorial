package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.Tank;
   
   public class TurretData
   {
      
      private static const matrix:Matrix4 = new Matrix4();
      
      private static const localBarrelOrigin:Vector3 = new Vector3();
      
      public const localMuzzlePosition:Vector3 = new Vector3();
      
      public const muzzlePosition:Vector3 = new Vector3();
      
      public const barrelOrigin:Vector3 = new Vector3();
      
      public const xAxis:Vector3 = new Vector3();
      
      public const direction:Vector3 = new Vector3();
      
      public var barrelLength:Number;
      
      public var turretMesh:Mesh;
      
      public function TurretData()
      {
         super();
      }
      
      public function update(tank:Tank, muzzleIndex:int) : void
      {
         var muzzle:Vector3 = tank.turret.muzzles[muzzleIndex];
         this.localMuzzlePosition.x = muzzle.x;
         this.localMuzzlePosition.y = muzzle.y;
         this.localMuzzlePosition.z = muzzle.z;
         this.turretMesh = tank.skin.turretMesh;
         this.barrelLength = muzzle.y;
         matrix.setMatrix(this.turretMesh.x,this.turretMesh.y,this.turretMesh.z,this.turretMesh.rotationX,this.turretMesh.rotationY,this.turretMesh.rotationZ);
         matrix.transformVector(this.localMuzzlePosition,this.muzzlePosition);
         localBarrelOrigin.x = this.localMuzzlePosition.x;
         localBarrelOrigin.z = this.localMuzzlePosition.z;
         matrix.transformVector(localBarrelOrigin,this.barrelOrigin);
         this.xAxis.x = matrix.ma;
         this.xAxis.y = matrix.me;
         this.xAxis.z = matrix.mi;
         this.direction.x = matrix.mb;
         this.direction.y = matrix.mf;
         this.direction.z = matrix.mj;
      }
   }
}

