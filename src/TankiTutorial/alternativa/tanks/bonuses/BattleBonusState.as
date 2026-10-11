package alternativa.tanks.bonuses
{
   public class BattleBonusState
   {
      
      public var z:Number = 0;
      
      public var rotationX:Number = 0;
      
      public var rotationZ:Number = 0;
      
      public function BattleBonusState()
      {
         super();
      }
      
      public function interpolate(a:BattleBonusState, b:BattleBonusState, t:Number) : void
      {
         this.z = a.z + t * (b.z - a.z);
         this.rotationX = a.rotationX + t * (b.rotationX - a.rotationX);
         this.rotationZ = a.rotationZ + t * (b.rotationZ - a.rotationZ);
      }
      
      public function copy(state:BattleBonusState) : void
      {
         this.z = state.z;
         this.rotationX = state.rotationX;
         this.rotationZ = state.rotationZ;
      }
   }
}

