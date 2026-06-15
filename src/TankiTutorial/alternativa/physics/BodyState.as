package alternativa.physics
{
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   
   public class BodyState
   {
      
      public var zerus:Vector3 = new Vector3();
      
      public var bej:Quaternion = new Quaternion();
      
      public var fev:Vector3 = new Vector3();
      
      public var position:Vector3 = new Vector3();
      
      public function BodyState()
      {
         super();
      }
      
      public function copy(param1:BodyState) : void
      {
         this.position.copy(param1.position);
         this.bej.copy(param1.bej);
         this.zerus.copy(param1.zerus);
         this.fev.copy(param1.fev);
      }
      
      public function isValid() : Boolean
      {
         return this.zerus.isFiniteVector() && this.fev.isFiniteVector() && this.position.isFiniteVector() && this.bej.isFiniteQuaternion();
      }
   }
}

