package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.types.Long;
   import alternativa.tanks.battle.hidablegraphicobjects.HidableGraphicObject;
   
   public class BonusMesh extends Mesh implements HidableGraphicObject
   {
      
      private var objectId:Long;
      
      private var supy:Number = 1;
      
      private var alphaMultiplier:Number = 1;
      
      public function BonusMesh(objectId:Long, mesh:Mesh)
      {
         super();
         this.objectId = objectId;
         clonePropertiesFrom(mesh);
         var face:Face = mesh.faces[0];
         setMaterialToAllFaces(face.material);
         sorting = Sorting.DYNAMIC_BSP;
      }
      
      public function init() : void
      {
         rotationX = 0;
         rotationY = 0;
         rotationZ = 0;
         scaleX = 1;
         scaleY = 1;
         scaleZ = 1;
         this.supy = 1;
         this.alphaMultiplier = 1;
         this.updateAlpha();
      }
      
      public function getObjectId() : Long
      {
         return this.objectId;
      }
      
      public function getAlpha() : Number
      {
         return this.supy;
      }
      
      public function setAlpha(value:Number) : void
      {
         this.supy = value;
         this.updateAlpha();
      }
      
      public function readPosition(result:Vector3) : void
      {
         result.x = x;
         result.y = y;
         result.z = z;
      }
      
      public function setAlphaMultiplier(value:Number) : void
      {
         this.alphaMultiplier = value;
         this.updateAlpha();
      }
      
      private function updateAlpha() : void
      {
         alpha = this.alphaMultiplier * this.supy;
      }
      
      public function recycle() : void
      {
         this.supy = 1;
         this.alphaMultiplier = 1;
         BonusCache.putBonusMesh(this);
      }
   }
}

