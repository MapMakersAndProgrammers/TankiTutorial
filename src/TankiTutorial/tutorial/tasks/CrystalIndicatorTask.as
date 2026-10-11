package tutorial.tasks
{
   import tutorial.GameData;
   
   public class CrystalIndicatorTask extends Task
   {
      
      public static const SHOW:String = "show";
      
      public static const HIDE:String = "hide";
      
      public static const INC:String = "inc";
      
      public static const NONE:String = "none";
      
      private var action:String = "none";
      
      public function CrystalIndicatorTask(action:String)
      {
         super();
         this.action = action;
      }
      
      override public function process() : Boolean
      {
         switch(this.action)
         {
            case SHOW:
               GameData.crystalIndicatorManager.showIndicator();
               this.action = NONE;
               break;
            case HIDE:
               GameData.crystalIndicatorManager.hideIndicator();
               this.action = NONE;
               break;
            case INC:
               this.action = NONE;
               break;
            case NONE:
         }
         return true;
      }
   }
}

