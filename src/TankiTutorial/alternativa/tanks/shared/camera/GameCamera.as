package alternativa.tanks.shared.camera
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   
   public class GameCamera extends Camera3D
   {
      
      private static const run:Matrix3 = new Matrix3();
      
      public var position:Vector3 = new Vector3();
      
      public var xAxis:Vector3 = new Vector3();
      
      public var yAxis:Vector3 = new Vector3();
      
      public var zAxis:Vector3 = new Vector3();
      
      private var _controller:CameraController = DummyCameraController.instance;
      
      public function GameCamera()
      {
         super();
      }
      
      public function set controller(value:CameraController) : void
      {
         if(value == null)
         {
            throw new Error();
         }
         this._controller = value;
      }
      
      public function get controller() : CameraController
      {
         return this._controller;
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
         this.xAxis.x = _loc5_ * _loc3_;
         this.yAxis.x = _loc7_ * _loc2_ - _loc6_ * _loc1_;
         this.zAxis.x = _loc7_ * _loc1_ + _loc6_ * _loc2_;
         this.xAxis.y = _loc6_ * _loc3_;
         this.yAxis.y = _loc8_ * _loc2_ + _loc5_ * _loc1_;
         this.zAxis.y = _loc8_ * _loc1_ - _loc5_ * _loc2_;
         this.xAxis.z = -_loc4_;
         this.yAxis.z = _loc3_ * _loc2_;
         this.zAxis.z = _loc3_ * _loc1_;
         this.position.x = x;
         this.position.y = y;
         this.position.z = z;
      }
      
      public function getGlobalVector(localVector:Vector3, result:Vector3) : void
      {
         run.setRotationMatrix(rotationX,rotationY,rotationZ);
         run.transformVector(localVector,result);
      }
      
      public function getLocalVector(globalVector:Vector3, result:Vector3) : void
      {
         run.setRotationMatrix(rotationX,rotationY,rotationZ);
         run.transformVectorInverse(globalVector,result);
      }
   }
}

