package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.battle.hidablegraphicobjects.HidableGraphicObject;
   
   public class Parachute extends Object3DContainer implements HidableGraphicObject
   {
      
      public static const RADIUS:Number = 266;
      
      public static const NUM_CORDS:int = 12;
      
      private var supy:Number = 1;
      
      private var alphaMultiplier:Number = 1;
      
      public function Parachute(parachuteMesh:Mesh, parachuteInnerMesh:Mesh)
      {
         super();
         this.addMesh(Mesh(parachuteMesh.clone()));
         this.addMesh(Mesh(parachuteInnerMesh.clone()));
      }
      
      private function addMesh(mesh:Mesh) : void
      {
         mesh.shadowMapAlphaThreshold = 2;
         addChild(mesh);
      }
      
      public function recycle() : void
      {
         this.supy = 1;
         this.alphaMultiplier = 1;
         scaleX = 1;
         scaleY = 1;
         scaleZ = 1;
         BonusCache.putParachute(this);
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
      
      private function updateAlpha() : void
      {
         alpha = this.alphaMultiplier * this.supy;
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
   }
}

