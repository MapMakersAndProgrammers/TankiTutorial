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
      
      private static const bul:Matrix4 = new Matrix4();
      
      private static const fybumu:Vector3 = new Vector3();
      
      private static const direction:Vector3 = new Vector3();
      
      private static const rygapyv:Vector3 = new Vector3();
      
      private static const rinego:Vector3 = new Vector3();
      
      private static const tefydiw:RayHit = new RayHit();
      
      private static const rucuha:Number = 20;
      
      private static const kab:Number = 0.2;
      
      private var gog:Number;
      
      private var collisionDetector:CollisionDetector;
      
      private var toqumyc:Vector3 = new Vector3();
      
      private var firaqe:Object3D;
      
      private var cyrare:Number;
      
      private var dypudecoz:Number = 0;
      
      public function CollisionObject3DPositionProvider(param1:Pool)
      {
         super(param1);
      }
      
      private function calculateParameters() : void
      {
         bul.setMatrix(this.firaqe.x,this.firaqe.y,this.firaqe.z,this.firaqe.rotationX,this.firaqe.rotationY,this.firaqe.rotationZ);
         rygapyv.x = bul.gusat;
         rygapyv.y = bul.sig;
         rygapyv.z = bul.vug;
         direction.x = bul.cydop;
         direction.y = bul.qanezycap;
         direction.z = bul.luwym;
         bul.transformVector(this.toqumyc,rinego);
         var _loc1_:Number = Number(this.toqumyc.y);
         fybumu.x = rinego.x - _loc1_ * direction.x;
         fybumu.y = rinego.y - _loc1_ * direction.y;
         fybumu.z = rinego.z - _loc1_ * direction.z;
      }
      
      public function init(param1:Object3D, param2:Vector3, param3:CollisionDetector, param4:Number, param5:Number = 0.5) : void
      {
         this.firaqe = param1;
         this.toqumyc = param2;
         this.collisionDetector = param3;
         this.gog = param4;
         this.cyrare = param5;
         this.dypudecoz = 0;
      }
      
      public function initPosition(param1:Object3D) : void
      {
         this.calculateParameters();
         var _loc2_:Number = this.gog * this.cyrare;
         if(this.collisionDetector.raycastStatic(fybumu,direction,CollisionGroup.neli,this.gog,null,tefydiw))
         {
            _loc2_ = Vector3.distanceBetween(fybumu,tefydiw.position) * this.cyrare;
         }
         var _loc3_:Number = _loc2_ - this.dypudecoz;
         if(Math.abs(_loc3_) <= rucuha)
         {
            this.dypudecoz = _loc2_;
         }
         else
         {
            this.dypudecoz += _loc3_ * kab;
         }
         param1.x = fybumu.x + direction.x * this.dypudecoz;
         param1.y = fybumu.y + direction.y * this.dypudecoz;
         param1.z = fybumu.z + direction.z * this.dypudecoz;
      }
      
      public function updateObjectPosition(param1:Object3D, param2:GameCamera, param3:int) : void
      {
         this.initPosition(param1);
      }
      
      public function destroy() : void
      {
         this.firaqe = null;
         this.collisionDetector = null;
         recycle();
      }
   }
}

