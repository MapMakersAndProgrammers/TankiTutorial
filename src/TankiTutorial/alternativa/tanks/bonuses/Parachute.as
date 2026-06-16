package alternativa.tanks.bonuses
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.battle.hidablegraphicobjects.HidableGraphicObject;
   
   public class Parachute extends Object3DContainer implements HidableGraphicObject
   {
      
      public static const jonoga:Number = 266;
      
      public static const lapocar:int = 12;
      
      private var supy:Number = 1;
      
      private var fidemujil:Number = 1;
      
      public function Parachute(param1:Mesh, param2:Mesh)
      {
         super();
         this.addMesh(Mesh(param1.clone()));
         this.addMesh(Mesh(param2.clone()));
      }
      
      private function addMesh(param1:Mesh) : void
      {
         param1.shadowMapAlphaThreshold = 2;
         addChild(param1);
      }
      
      public function recycle() : void
      {
         this.supy = 1;
         this.fidemujil = 1;
         scaleX = 1;
         scaleY = 1;
         scaleZ = 1;
         BonusCache.putParachute(this);
      }
      
      public function getAlpha() : Number
      {
         return this.supy;
      }
      
      public function setAlpha(param1:Number) : void
      {
         this.supy = param1;
         this.updateAlpha();
      }
      
      private function updateAlpha() : void
      {
         alpha = this.fidemujil * this.supy;
      }
      
      public function readPosition(param1:Vector3) : void
      {
         param1.x = x;
         param1.y = y;
         param1.z = z;
      }
      
      public function setAlphaMultiplier(param1:Number) : void
      {
         this.fidemujil = param1;
         this.updateAlpha();
      }
   }
}

