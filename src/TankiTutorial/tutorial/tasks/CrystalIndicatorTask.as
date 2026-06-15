package tutorial.tasks
{
   import tutorial.GameData;
   
   public class CrystalIndicatorTask extends Task
   {
      
      public static const qufifyqi:String = "show";
      
      public static const zijuzohyl:String = "hide";
      
      public static const dabilenoc:String = "inc";
      
      public static const sel:String = "none";
      
      private var hemire:String = "none";
      
      public function CrystalIndicatorTask(param1:String)
      {
         super();
         this.hemire = param1;
      }
      
      override public function process() : Boolean
      {
         switch(this.hemire)
         {
            case qufifyqi:
               GameData.maji.showIndicator();
               this.hemire = sel;
               break;
            case zijuzohyl:
               GameData.maji.hideIndicator();
               this.hemire = sel;
               break;
            case dabilenoc:
               this.hemire = sel;
               break;
            case sel:
         }
         return true;
      }
   }
}

