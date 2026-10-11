package tutorial.tasks
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.bonuses.BattleBonus;
   import alternativa.tanks.bonuses.BattleBonusData;
   import alternativa.types.Long;
   import flash.display.BitmapData;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class DropCrystalTask extends DropBonusTask
   {
      
      private static var battleBonusData:BattleBonusData;
      
      private static const bonusObjectId:Long = Long.getNext();
      
      public function DropCrystalTask(position:Vector3)
      {
         super(position);
      }
      
      override protected function getBattleBonusData() : BattleBonusData
      {
         if(battleBonusData == null)
         {
            battleBonusData = this.createBattleBonusData();
         }
         return battleBonusData;
      }
      
      private function createBattleBonusData() : BattleBonusData
      {
         var bonusData:BattleBonusData = new BattleBonusData();
         bonusData.tipi = Assets.getData("crystal",Mesh);
         bonusData.vukuzub = Assets.getData("parachute",Mesh);
         bonusData.berav = Assets.getData("parachute_inner",Mesh);
         bonusData.zerow = new TextureMaterial(Assets.getData("cords",BitmapData));
         bonusData.wym = 100000;
         return bonusData;
      }
      
      override protected function getBonusObjectId() : Long
      {
         return bonusObjectId;
      }
      
      override protected function onTankCollision(bonus:BattleBonus) : void
      {
         super.onTankCollision(bonus);
         GameData.crystalIndicatorManager.indicator.inc();
      }
   }
}

