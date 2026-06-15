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
      
      private static var buhisuko:BattleBonusData;
      
      private static const jegys:Long = Long.getNext();
      
      public function DropMedicineTask(param1:Vector3)
      {
         super(param1);
      }
      
      override protected function getBattleBonusData() : BattleBonusData
      {
         if(buhisuko == null)
         {
            buhisuko = this.createBattleBonusData();
         }
         return buhisuko;
      }
      
      private function createBattleBonusData() : BattleBonusData
      {
         var _loc1_:BattleBonusData = new BattleBonusData();
         _loc1_.tipi = Assets.getData("med",Mesh);
         _loc1_.vukuzub = Assets.getData("parachute",Mesh);
         _loc1_.berav = Assets.getData("parachute_inner",Mesh);
         _loc1_.zerow = new TextureMaterial(Assets.getData("cords",BitmapData));
         _loc1_.wym = int.MAX_VALUE;
         _loc1_.ruzy = Assets.getData("bonus",Sound);
         return _loc1_;
      }
      
      override protected function getBonusObjectId() : Long
      {
         return jegys;
      }
      
      override protected function onTankCollision(param1:BattleBonus) : void
      {
         super.onTankCollision(param1);
         GameData.jifom.heal();
      }
   }
}

