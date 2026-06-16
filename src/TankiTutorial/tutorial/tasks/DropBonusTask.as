package tutorial.tasks
{
   import alternativa.math.Vector3;
   import alternativa.tanks.bonuses.BattleBonus;
   import alternativa.tanks.bonuses.BattleBonusData;
   import alternativa.types.Long;
   import tutorial.BonusData;
   import tutorial.GameData;
   
   public class DropBonusTask extends Task
   {
      
      private static const nezeg:int = 1000;
      
      protected const position:Vector3 = new Vector3();
      
      public function DropBonusTask(param1:Vector3)
      {
         super();
         this.position.x = param1.x;
         this.position.y = param1.y;
         this.position.z = param1.z + nezeg;
      }
      
      override public function process() : Boolean
      {
         var _loc1_:BattleBonusData = this.getBattleBonusData();
         var _loc2_:BattleBonus = BattleBonus(GameData.murow.getObject(BattleBonus));
         _loc2_.init(this.getBonusObjectId(),Long.getNext(),_loc1_,GameData.mij);
         _loc2_.spawn(this.position,0,BonusData.kudutyje,this.onTankCollision);
         return true;
      }
      
      protected function getBattleBonusData() : BattleBonusData
      {
         throw new Error();
      }
      
      protected function getBonusObjectId() : Long
      {
         throw new Error();
      }
      
      protected function onTankCollision(param1:BattleBonus) : void
      {
         param1.pickup();
      }
   }
}

