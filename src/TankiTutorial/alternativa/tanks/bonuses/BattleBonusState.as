package alternativa.tanks.bonuses
{
   public class BattleBonusState
   {
      
      public var fitepil:Number = 0;
      
      public var peze:Number = 0;
      
      public var zywojehu:Number = 0;
      
      public function BattleBonusState()
      {
         super();
      }
      
      public function interpolate(param1:BattleBonusState, param2:BattleBonusState, param3:Number) : void
      {
         this.fitepil = param1.fitepil + param3 * (param2.fitepil - param1.fitepil);
         this.peze = param1.peze + param3 * (param2.peze - param1.peze);
         this.zywojehu = param1.zywojehu + param3 * (param2.zywojehu - param1.zywojehu);
      }
      
      public function copy(param1:BattleBonusState) : void
      {
         this.fitepil = param1.fitepil;
         this.peze = param1.peze;
         this.zywojehu = param1.zywojehu;
      }
   }
}

