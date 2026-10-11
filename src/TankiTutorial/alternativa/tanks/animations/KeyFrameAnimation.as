package alternativa.tanks.animations
{
   public class KeyFrameAnimation
   {
      
      private var tap:AnimationTrack;
      
      private var lamutameq:int;
      
      private var time:Number;
      
      private var lyjewaky:AnimatedValue;
      
      public function KeyFrameAnimation(param1:AnimationTrack, param2:AnimatedValue)
      {
         super();
         this.tap = param1;
         this.lyjewaky = param2;
      }
      
      public function start() : void
      {
         this.time = this.tap.getMinTime();
         this.lamutameq = 0;
      }
      
      public function isComplete() : Boolean
      {
         return this.lamutameq == this.tap.getNumFrames() - 1;
      }
      
      public function update(param1:Number) : void
      {
         if(!this.isComplete())
         {
            this.time += param1;
            while(this.time > this.tap.getFrameTime(this.lamutameq + 1))
            {
               ++this.lamutameq;
               if(this.isComplete())
               {
                  this.time = this.tap.getMaxTime();
                  break;
               }
            }
            this.lyjewaky.setAnimatedValue(this.getValue());
         }
      }
      
      private function getValue() : Number
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.isComplete())
         {
            return this.tap.getFrameTime(this.lamutameq);
         }
         _loc1_ = this.tap.getFrameTime(this.lamutameq);
         _loc2_ = this.tap.getFrameTime(this.lamutameq + 1);
         _loc3_ = this.tap.getFrameValue(this.lamutameq);
         _loc4_ = this.tap.getFrameValue(this.lamutameq + 1);
         return _loc3_ + (_loc4_ - _loc3_) * (this.time - _loc1_) / (_loc2_ - _loc1_);
      }
   }
}

