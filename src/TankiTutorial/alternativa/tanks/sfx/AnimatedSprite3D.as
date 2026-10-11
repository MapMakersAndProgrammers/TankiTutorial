package alternativa.tanks.sfx
{
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Sprite3D;
   
   public class AnimatedSprite3D extends Sprite3D
   {
      
      private var frames:Vector.<UVFrame>;
      
      private var numFrames:int;
      
      public function AnimatedSprite3D(width:Number, height:Number, material:Material = null)
      {
         super(width,height,material);
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
      
      public function setFrameIndex(frameIndex:int) : void
      {
         this.setFrame(this.frames[frameIndex % this.numFrames]);
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

