package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix4;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.physics.collision.CollisionDetector;
   
   public class CollisionObject3DPositionProvider extends PooledObject implements Object3DPositionProvider
   {
      
      private static const matrix:Matrix4 = new Matrix4();
      
      private static const barrelOrigin:Vector3 = new Vector3();
      
      private static const direction:Vector3 = new Vector3();
      
      private static const xAxis:Vector3 = new Vector3();
      
      private static const muzzlePosition:Vector3 = new Vector3();
      
      private static const rayHit:RayHit = new RayHit();
      
      private static const rucuha:Number = 20;
      
      private static const kab:Number = 0.2;
      
      private var maxDistance:Number;
      
      private var collisionDetector:CollisionDetector;
      
      private var localMuzzlePosition:Vector3 = new Vector3();
      
      private var turret:Object3D;
      
      private var cyrare:Number;
      
      private var distance:Number = 0;
      
      public function CollisionObject3DPositionProvider(param1:Pool)
      {
         super(param1);
      }
      
      private function calculateParameters() : void
      {
         matrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         xAxis.x = matrix.ma;
         xAxis.y = matrix.me;
         xAxis.z = matrix.mi;
         direction.x = matrix.mb;
         direction.y = matrix.mf;
         direction.z = matrix.mj;
         matrix.transformVector(this.localMuzzlePosition,muzzlePosition);
         var _loc1_:Number = Number(this.localMuzzlePosition.y);
         barrelOrigin.x = muzzlePosition.x - _loc1_ * direction.x;
         barrelOrigin.y = muzzlePosition.y - _loc1_ * direction.y;
         barrelOrigin.z = muzzlePosition.z - _loc1_ * direction.z;
      }
      
      public function init(param1:Object3D, param2:Vector3, param3:CollisionDetector, param4:Number, param5:Number = 0.5) : void
      {
         this.turret = param1;
         this.localMuzzlePosition = param2;
         this.collisionDetector = param3;
         this.maxDistance = param4;
         this.cyrare = param5;
         this.distance = 0;
      }
      
      public function initPosition(object:Object3D) : void
      {
         this.calculateParameters();
         var targetDistance:Number = this.maxDistance * this.cyrare;
         if(this.collisionDetector.raycastStatic(barrelOrigin,direction,CollisionGroup.STATIC,this.maxDistance,null,rayHit))
         {
            targetDistance = Vector3.distanceBetween(barrelOrigin,rayHit.position) * this.cyrare;
         }
         var delta:Number = targetDistance - this.distance;
         if(Math.abs(delta) <= rucuha)
         {
            this.distance = targetDistance;
         }
         else
         {
            this.distance += delta * kab;
         }
         object.x = barrelOrigin.x + direction.x * this.distance;
         object.y = barrelOrigin.y + direction.y * this.distance;
         object.z = barrelOrigin.z + direction.z * this.distance;
      }
      
      public function updateObjectPosition(object:Object3D, camera:GameCamera, deltaTime:int) : void
      {
         this.initPosition(object);
      }
      
      public function destroy() : void
      {
         this.turret = null;
         this.collisionDetector = null;
         recycle();
      }
   }
}

