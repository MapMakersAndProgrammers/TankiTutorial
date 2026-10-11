package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix4;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: this is needed to access some object3d properties
   use namespace alternativa3d;

   public class SmokyMuzzleFlashEffect extends PooledObject implements GraphicEffect
   {
      
      public static const PLANE_WIDTH:Number = 60;
      
      private static const PLANE_LENGTH:Number = 210;
      
      private static const direction:Vector3 = new Vector3();
      
      private static const muzzlePosition:Vector3 = new Vector3();
      
      private static const matrix:Matrix4 = new Matrix4();
      
      private static const cameraPosition:Vector3 = new Vector3();
      
      private var plane:SimplePlane;
      
      private var timeLeft:int;
      
      private var turret:Object3D;
      
      private var localMuzzlePosition:Vector3 = new Vector3();
      
      public function SmokyMuzzleFlashEffect(pool:Pool)
      {
         super(pool);
         this.plane = new SimplePlane(PLANE_WIDTH,PLANE_LENGTH,0.5,0);
         this.plane.setUVs(0,0,0,1,1,1,1,0);
         this.plane.useShadowMap = false;
         this.plane.useLight = false;
         this.plane.shadowMapAlphaThreshold = 2;
         this.plane.depthMapAlphaThreshold = 2;
      }
      
      public function init(localMuzzlePosition:Vector3, turret:Object3D, material:TextureMaterial, timeLeft:int) : void
      {
         this.localMuzzlePosition.copy(localMuzzlePosition);
         this.turret = turret;
         this.timeLeft = timeLeft;
         this.plane.setMaterialToAllFaces(material);
         var texture:BitmapData = material.texture;
         material.resolution = this.plane.calculateResolution(texture.width,texture.height);
      }
      
      public function play(deltaTime:int, camera:GameCamera) : Boolean
      {
         if(this.timeLeft < 0)
         {
            return false;
         }
         this.timeLeft -= deltaTime;
         matrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         matrix.transformVector(this.localMuzzlePosition,muzzlePosition);
         matrix.getAxis(1,direction);
         cameraPosition.x = camera.x;
         cameraPosition.y = camera.y;
         cameraPosition.z = camera.z;
         SFXUtils.alignObjectPlaneToView(this.plane,muzzlePosition,direction,cameraPosition);
         return true;
      }
      
      public function destroy() : void
      {
         this.plane.removeFromParent();
         this.turret = null;
         recycle();
      }
      
      public function kill() : void
      {
         this.timeLeft = -1;
      }
      
      public function addedToScene(container:Object3DContainer) : void
      {
         container.addChild(this.plane);
      }
   }
}

