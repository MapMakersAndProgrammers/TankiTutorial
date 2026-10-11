package alternativa.tanks.sfx.flamethrower
{
   import alternativa.tanks.sfx.SimplePlane;
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.sfx.UVFrame;
   
   internal class StreamWeaponMuzzlePlane extends SimplePlane
   {
      
      private var frames:Vector.<UVFrame>;
      
      private var numFrames:int;
      
      private var frameIndex:Number;
      
      public function StreamWeaponMuzzlePlane()
      {
         super(1,1,0.5,0);
         shadowMapAlphaThreshold = 2;
         depthMapAlphaThreshold = 2;
         useShadowMap = false;
         useLight = false;
      }
      
      public function init(animation:TextureAnimation) : void
      {
         setMaterialToAllFaces(animation.material);
         this.frames = animation.frames;
         this.numFrames = this.frames.length;
         this.frameIndex = 0;
         this.setFrame(this.frames[0]);
      }
      
      public function clear() : void
      {
         setMaterialToAllFaces(null);
         this.frames = null;
         this.numFrames = 0;
      }
      
      public function update(dt:Number, fps:Number) : void
      {
         this.frameIndex += dt * fps;
         if(this.frameIndex >= this.numFrames)
         {
            this.frameIndex = 0;
         }
         this.setFrame(this.frames[int(this.frameIndex)]);
      }
      
      private function setFrame(frame:UVFrame) : void
      {
         gar.u = frame.topLeftU;
         gar.v = frame.topLeftV;
         nityt.u = frame.topLeftU;
         nityt.v = frame.bottomRightV;
         fysu.u = frame.bottomRightU;
         fysu.v = frame.bottomRightV;
         rok.u = frame.bottomRightU;
         rok.v = frame.topLeftV;
      }
   }
}

