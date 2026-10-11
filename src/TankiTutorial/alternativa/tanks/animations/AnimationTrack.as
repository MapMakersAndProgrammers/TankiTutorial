package alternativa.tanks.animations
{
   public class AnimationTrack
   {
      
      private var times:Vector.<Number>;
      
      private var values:Vector.<Number>;
      
      private var numFrames:int;
      
      private var minTime:Number;
      
      private var maxTime:Number;
      
      public function AnimationTrack(times:Vector.<Number>, values:Vector.<Number>)
      {
         super();
         this.times = times;
         this.values = values;
         this.numFrames = times.length;
         this.minTime = times[0];
         this.maxTime = times[this.numFrames - 1];
      }
      
      public function getFrameTime(frameIndex:int) : Number
      {
         return this.times[frameIndex];
      }
      
      public function getNumFrames() : int
      {
         return this.numFrames;
      }
      
      public function getMinTime() : Number
      {
         return this.minTime;
      }
      
      public function getMaxTime() : Number
      {
         return this.maxTime;
      }
      
      public function getFrameValue(frameIndex:int) : Number
      {
         return this.values[frameIndex];
      }
   }
}

