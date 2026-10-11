package tutorial.tasks
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.bonuses.BattleBonus;
   import alternativa.tanks.bonuses.BattleBonusData;
   import alternativa.types.Long;
   import flash.display.BitmapData;
   import flash.media.Sound;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class DropMedicineTask extends DropBonusTask
   {
      
      private static var battleBonusData:BattleBonusData;
      
      private static const bonusObjectId:Long = Long.getNext();
      
      public function DropMedicineTask(position:Vector3)
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
         bonusData.bonusMesh = Assets.getData("med",Mesh);
         bonusData.parachuteMesh = Assets.getData("parachute",Mesh);
         bonusData.parachuteInnerMesh = Assets.getData("parachute_inner",Mesh);
         bonusData.cordsMaterial = new TextureMaterial(Assets.getData("cords",BitmapData));
         bonusData.lifeTime = int.MAX_VALUE;
         bonusData.pickupSound = Assets.getData("bonus",Sound);
         return bonusData;
      }
      
      override protected function getBonusObjectId() : Long
      {
         return bonusObjectId;
      }
      
      override protected function onTankCollision(bonus:BattleBonus) : void
      {
         super.onTankCollision(bonus);
         GameData.playerTank.heal();
      }
   }
}

