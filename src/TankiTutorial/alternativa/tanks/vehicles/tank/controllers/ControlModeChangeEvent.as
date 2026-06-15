package alternativa.tanks.vehicles.tank.controllers
{
   import flash.events.Event;
   
   public class ControlModeChangeEvent extends Event
   {
      
      public static const somyvigir:String = "controlModeChanged";
      
      public function ControlModeChangeEvent()
      {
         super(somyvigir);
      }
   }
}

