package alternativa.tanks.vehicles.tank.controllers
{
   import flash.events.Event;
   
   public class ControlModeChangeEvent extends Event
   {
      
      public static const CONTROL_MODE_CHANGED:String = "controlModeChanged";
      
      public function ControlModeChangeEvent()
      {
         super(CONTROL_MODE_CHANGED);
      }
   }
}

