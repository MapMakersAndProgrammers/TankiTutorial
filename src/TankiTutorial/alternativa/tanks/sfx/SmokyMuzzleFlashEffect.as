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
      
      public static const qezizyj:Number = 60;
      
      private static const kykihyf:Number = 210;
      
      private static const nywysi:Vector3 = new Vector3();
      
      private static const rinego:Vector3 = new Vector3();
      
      private static const bul:Matrix4 = new Matrix4();
      
      private static const wuzyrodu:Vector3 = new Vector3();
      
      private var cysam:SimplePlane;
      
      private var myhal:int;
      
      private var firaqe:Object3D;
      
      private var toqumyc:Vector3 = new Vector3();
      
      public function SmokyMuzzleFlashEffect(param1:Pool)
      {
         super(param1);
         this.cysam = new SimplePlane(qezizyj,kykihyf,0.5,0);
         this.cysam.setUVs(0,0,0,1,1,1,1,0);
         this.cysam.useShadowMap = false;
         this.cysam.useLight = false;
         this.cysam.shadowMapAlphaThreshold = 2;
         this.cysam.depthMapAlphaThreshold = 2;
      }
      
      public function init(param1:Vector3, param2:Object3D, param3:TextureMaterial, param4:int) : void
      {
         this.toqumyc.copy(param1);
         this.firaqe = param2;
         this.myhal = param4;
         this.cysam.setMaterialToAllFaces(param3);
         var _loc5_:BitmapData = param3.texture;
         param3.resolution = this.cysam.calculateResolution(_loc5_.width,_loc5_.height);
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
         if(this.myhal < 0)
         {
            return false;
         }
         this.myhal -= param1;
         bul.setMatrix(this.firaqe.x,this.firaqe.y,this.firaqe.z,this.firaqe.rotationX,this.firaqe.rotationY,this.firaqe.rotationZ);
         bul.transformVector(this.toqumyc,rinego);
         bul.getAxis(1,nywysi);
         wuzyrodu.x = param2.x;
         wuzyrodu.y = param2.y;
         wuzyrodu.z = param2.z;
         SFXUtils.alignObjectPlaneToView(this.cysam,rinego,nywysi,wuzyrodu);
         return true;
      }
      
      public function destroy() : void
      {
         this.cysam.removeFromParent();
         this.firaqe = null;
         recycle();
      }
      
      public function kill() : void
      {
         this.myhal = -1;
      }
      
      public function addedToScene(param1:Object3DContainer) : void
      {
         param1.addChild(this.cysam);
      }
   }
}

