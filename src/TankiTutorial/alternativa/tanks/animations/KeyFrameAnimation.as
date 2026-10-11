package alternativa.tanks.animations
{
   public class KeyFrameAnimation
   {
      
      private var track:AnimationTrack;
      
      private var frameIndex:int;
      
      private var time:Number;
      
      private var animatedValue:AnimatedValue;
      
      public function KeyFrameAnimation(track:AnimationTrack, animatedValue:AnimatedValue)
      {
         super();
         this.track = track;
         this.animatedValue = animatedValue;
      }
      
      public function start() : void
      {
         this.time = this.track.getMinTime();
         this.frameIndex = 0;
      }
      
      public function isComplete() : Boolean
      {
         return this.frameIndex == this.track.getNumFrames() - 1;
      }
      
      public function update(delta:Number) : void
      {
         if(!this.isComplete())
         {
            this.time += delta;
            while(this.time > this.track.getFrameTime(this.frameIndex + 1))
            {
               ++this.frameIndex;
               if(this.isComplete())
               {
                  this.time = this.track.getMaxTime();
                  break;
               }
            }
            this.animatedValue.setAnimatedValue(this.getValue());
         }
      }
      
      private function getValue() : Number
      {
         var startTime:Number = NaN;
         var endTime:Number = NaN;
         var startValue:Number = NaN;
         var endValue:Number = NaN;
         if(this.isComplete())
         {
            return this.track.getFrameTime(this.frameIndex);
         }
         startTime = this.track.getFrameTime(this.frameIndex);
         endTime = this.track.getFrameTime(this.frameIndex + 1);
         startValue = this.track.getFrameValue(this.frameIndex);
         endValue = this.track.getFrameValue(this.frameIndex + 1);
         return startValue + (endValue - startValue) * (this.time - startTime) / (endTime - startTime);
      }
   }
}

