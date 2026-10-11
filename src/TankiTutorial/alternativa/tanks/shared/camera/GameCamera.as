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
         var sinZsinY:Number = NaN;
         var cosX:Number = Math.cos(rotationX);
         var sinX:Number = Math.sin(rotationX);
         var cosY:Number = Math.cos(rotationY);
         var sinY:Number = Math.sin(rotationY);
         var cosZ:Number = Math.cos(rotationZ);
         var sinZ:Number = Math.sin(rotationZ);
         var cosZsinY:Number = cosZ * sinY;
         sinZsinY = sinZ * sinY;
         this.xAxis.x = cosZ * cosY;
         this.yAxis.x = cosZsinY * sinX - sinZ * cosX;
         this.zAxis.x = cosZsinY * cosX + sinZ * sinX;
         this.xAxis.y = sinZ * cosY;
         this.yAxis.y = sinZsinY * sinX + cosZ * cosX;
         this.zAxis.y = sinZsinY * cosX - cosZ * sinX;
         this.xAxis.z = -sinY;
         this.yAxis.z = cosY * sinX;
         this.zAxis.z = cosY * cosX;
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

