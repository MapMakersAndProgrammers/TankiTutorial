package alternativa.tanks.sfx
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Sprite3D;
   
   public class AnimatedSprite3D extends Sprite3D
   {
      
      private var frames:Vector.<UVFrame>;
      
      private var numFrames:int;
      
      public function AnimatedSprite3D(param1:Number, param2:Number, param3:Material = null)
      {
         super(param1,param2,param3);
         useShadowMap = false;
         useLight = false;
      }
      
      public function setAnimationData(animation:TextureAnimation) : void
      {
         material = animation.material;
         this.frames = animation.frames;
         this.numFrames = this.frames.length;
      }
      
      public function getNumFrames() : int
      {
         return this.numFrames;
      }
      
      public function clear() : void
      {
         this.frames = null;
         material = null;
         this.numFrames = 0;
      }
      
      public function setFrameIndex(param1:int) : void
      {
         this.setFrame(this.frames[param1 % this.numFrames]);
      }
      
      private function setFrame(frame:UVFrame) : void
      {
         topLeftU = frame.topLeftU;
         topLeftV = frame.topLeftV;
         bottomRightU = frame.bottomRightU;
         bottomRightV = frame.bottomRightV;
      }
   }
}

