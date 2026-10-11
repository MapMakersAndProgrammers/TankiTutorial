package tutorial.tasks
{
   public class Task
   {
      
      internal var prev:Task;
      
      internal var next:Task;
      
      public function Task()
      {
         super();
      }
      
      public function process() : Boolean
      {
         return true;
      }
   }
}

