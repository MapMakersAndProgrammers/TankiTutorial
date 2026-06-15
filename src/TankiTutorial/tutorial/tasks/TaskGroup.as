package tutorial.tasks
{
   public class TaskGroup extends Task
   {
      
      private var riw:Task;
      
      private var rysered:Task;
      
      public function TaskGroup()
      {
         super();
         this.riw = new Task();
         this.rysered = new Task();
         this.riw.suzasevot = this.rysered;
         this.rysered.tomi = this.riw;
      }
      
      public function addTask(param1:Task) : void
      {
         param1.suzasevot = this.rysered;
         param1.tomi = this.rysered.tomi;
         this.rysered.tomi.suzasevot = param1;
         this.rysered.tomi = param1;
      }
      
      final override public function process() : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc1_:Boolean = true;
         var _loc2_:Task = this.riw.suzasevot;
         while(_loc2_ != this.rysered)
         {
            _loc3_ = _loc2_.process();
            _loc1_ &&= _loc3_;
            _loc2_ = _loc2_.suzasevot;
            if(_loc3_)
            {
               this.removeTask(_loc2_.tomi);
            }
         }
         return _loc1_;
      }
      
      private function removeTask(param1:Task) : void
      {
         param1.tomi.suzasevot = param1.suzasevot;
         param1.suzasevot.tomi = param1.tomi;
         param1.suzasevot = null;
         param1.tomi = null;
      }
   }
}

