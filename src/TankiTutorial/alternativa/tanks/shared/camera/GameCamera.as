package alternativa.tanks.shared.camera
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   
   public class GameCamera extends Camera3D
   {
      
      private static const run:Matrix3 = new Matrix3();
      
      public var position:Vector3 = new Vector3();
      
      public var memyjenut:Vector3 = new Vector3();
      
      public var bidan:Vector3 = new Vector3();
      
      public var tafel:Vector3 = new Vector3();
      
      private var nejy:CameraController = DummyCameraController.degakeh;
      
      public function GameCamera()
      {
         super();
      }
      
      public function set controller(param1:CameraController) : void
      {
         if(param1 == null)
         {
            throw new Error();
         }
         this.nejy = param1;
      }
      
      public function get controller() : CameraController
      {
         return this.nejy;
      }
      
      public function calculateAdditionalData() : void
      {
         var _loc8_:Number = NaN;
         var _loc1_:Number = Math.cos(rotationX);
         var _loc2_:Number = Math.sin(rotationX);
         var _loc3_:Number = Math.cos(rotationY);
         var _loc4_:Number = Math.sin(rotationY);
         var _loc5_:Number = Math.cos(rotationZ);
         var _loc6_:Number = Math.sin(rotationZ);
         var _loc7_:Number = _loc5_ * _loc4_;
         _loc8_ = _loc6_ * _loc4_;
         this.memyjenut.x = _loc5_ * _loc3_;
         this.bidan.x = _loc7_ * _loc2_ - _loc6_ * _loc1_;
         this.tafel.x = _loc7_ * _loc1_ + _loc6_ * _loc2_;
         this.memyjenut.y = _loc6_ * _loc3_;
         this.bidan.y = _loc8_ * _loc2_ + _loc5_ * _loc1_;
         this.tafel.y = _loc8_ * _loc1_ - _loc5_ * _loc2_;
         this.memyjenut.z = -_loc4_;
         this.bidan.z = _loc3_ * _loc2_;
         this.tafel.z = _loc3_ * _loc1_;
         this.position.x = x;
         this.position.y = y;
         this.position.z = z;
      }
      
      public function getGlobalVector(param1:Vector3, param2:Vector3) : void
      {
         run.setRotationMatrix(rotationX,rotationY,rotationZ);
         run.transformVector(param1,param2);
      }
      
      public function getLocalVector(param1:Vector3, param2:Vector3) : void
      {
         run.setRotationMatrix(rotationX,rotationY,rotationZ);
         run.transformVectorInverse(param1,param2);
      }
   }
}

