package alternativa.tanks.animations
{
   public class AnimationTrack
   {
      
      private var mal:Vector.<Number>;
      
      private var maduze:Vector.<Number>;
      
      private var nomupiz:int;
      
      private var giwiqy:Number;
      
      private var davaqymev:Number;
      
      public function AnimationTrack(param1:Vector.<Number>, param2:Vector.<Number>)
      {
         super();
         this.mal = param1;
         this.maduze = param2;
         this.nomupiz = param1.length;
         this.giwiqy = param1[0];
         this.davaqymev = param1[this.nomupiz - 1];
      }
      
      public function getFrameTime(param1:int) : Number
      {
         return this.mal[param1];
      }
      
      public function getNumFrames() : int
      {
         return this.nomupiz;
      }
      
      public function getMinTime() : Number
      {
         return this.giwiqy;
      }
      
      public function getMaxTime() : Number
      {
         return this.davaqymev;
      }
      
      public function getFrameValue(param1:int) : Number
      {
         return this.maduze[param1];
      }
   }
}

