package tutorial.tasks
{
   public class TaskGroup extends Task
   {
      
      private var head:Task;
      
      private var tail:Task;
      
      public function TaskGroup()
      {
         super();
         this.head = new Task();
         this.tail = new Task();
         this.head.next = this.tail;
         this.tail.prev = this.head;
      }
      
      public function addTask(task:Task) : void
      {
         task.next = this.tail;
         task.prev = this.tail.prev;
         this.tail.prev.next = task;
         this.tail.prev = task;
      }
      
      final override public function process() : Boolean
      {
         var done:Boolean = false;
         var allDone:Boolean = true;
         var task:Task = this.head.next;
         while(task != this.tail)
         {
            done = task.process();
            allDone &&= done;
            task = task.next;
            if(done)
            {
               this.removeTask(task.prev);
            }
         }
         return allDone;
      }
      
      private function removeTask(task:Task) : void
      {
         task.prev.next = task.next;
         task.next.prev = task.prev;
         task.next = null;
         task.prev = null;
      }
   }
}

