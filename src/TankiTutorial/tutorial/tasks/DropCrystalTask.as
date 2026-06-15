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
      
      private static var buhisuko:BattleBonusData;
      
      private static const bope:Long = Long.getNext();
      
      public function DropCrystalTask(param1:Vector3)
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
         _loc1_.tipi = Assets.getData("crystal",Mesh);
         _loc1_.vukuzub = Assets.getData("parachute",Mesh);
         _loc1_.berav = Assets.getData("parachute_inner",Mesh);
         _loc1_.zerow = new TextureMaterial(Assets.getData("cords",BitmapData));
         _loc1_.wym = 100000;
         return _loc1_;
      }
      
      override protected function getBonusObjectId() : Long
      {
         return bope;
      }
      
      override protected function onTankCollision(param1:BattleBonus) : void
      {
         super.onTankCollision(param1);
         GameData.maji.duqup.inc();
      }
   }
}

