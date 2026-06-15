package alternativa.tanks.sfx
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Sprite3D;
   
   public class AnimatedSprite3D extends Sprite3D
   {
      
      private var gepoky:Vector.<UVFrame>;
      
      private var nomupiz:int;
      
      public function AnimatedSprite3D(param1:Number, param2:Number, param3:Material = null)
      {
         super(param1,param2,param3);
         useShadowMap = false;
         useLight = false;
      }
      
      public function setAnimationData(param1:TextureAnimation) : void
      {
         material = param1.material;
         this.gepoky = param1.qyvoladeg;
         this.nomupiz = this.gepoky.length;
      }
      
      public function getNumFrames() : int
      {
         return this.nomupiz;
      }
      
      public function clear() : void
      {
         this.gepoky = null;
         material = null;
         this.nomupiz = 0;
      }
      
      public function setFrameIndex(param1:int) : void
      {
         this.setFrame(this.gepoky[param1 % this.nomupiz]);
      }
      
      private function setFrame(param1:UVFrame) : void
      {
         topLeftU = param1.picylyno;
         topLeftV = param1.lesenac;
         bottomRightU = param1.pusunawy;
         bottomRightV = param1.salemat;
      }
   }
}

