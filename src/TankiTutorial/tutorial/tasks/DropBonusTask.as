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
      
      private static const DROP_HEIGHT:int = 1000;
      
      protected const position:Vector3 = new Vector3();
      
      public function DropBonusTask(position:Vector3)
      {
         super();
         this.position.x = position.x;
         this.position.y = position.y;
         this.position.z = position.z + DROP_HEIGHT;
      }
      
      override public function process() : Boolean
      {
         var bonusData:BattleBonusData = this.getBattleBonusData();
         var bonus:BattleBonus = BattleBonus(GameData.objectPool.getObject(BattleBonus));
         bonus.init(this.getBonusObjectId(),Long.getNext(),bonusData,GameData.battleService);
         bonus.spawn(this.position,0,BonusData.FALL_SPEED,this.onTankCollision);
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
      
      protected function onTankCollision(bonus:BattleBonus) : void
      {
         bonus.pickup();
      }
   }
}

