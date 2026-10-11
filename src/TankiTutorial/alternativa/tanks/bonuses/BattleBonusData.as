package alternativa.tanks.bonuses
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import flash.media.Sound;
   
   public class BattleBonusData
   {
      
      public var bonusMesh:Mesh;
      
      public var parachuteMesh:Mesh;
      
      public var parachuteInnerMesh:Mesh;
      
      public var cordsMaterial:TextureMaterial;
      
      public var pickupSound:Sound;
      
      public var lifeTime:int;
      
      public function BattleBonusData()
      {
         super();
      }
   }
}

