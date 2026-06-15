package alternativa.tanks.bonuses
{
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   
   public class LandingState
   {
      
      public const position:Vector3 = new Vector3();
      
      public const bej:Quaternion = new Quaternion();
      
      public function LandingState()
      {
         super();
      }
      
      public function interpolate(param1:LandingState, param2:LandingState, param3:Number) : void
      {
         this.position.interpolate(param3,param1.position,param2.position);
         this.bej.slerp(param1.bej,param2.bej,param3);
      }
      
      public function copy(param1:LandingState) : void
      {
         this.position.copy(param1.position);
         this.bej.copy(param1.bej);
      }
   }
}

