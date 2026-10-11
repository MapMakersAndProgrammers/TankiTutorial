package alternativa.tanks.vehicles.tank.controllers
{
   import flash.ui.Keyboard;
   
   public class ChassisControlKeyMap
   {
      
      public static var forwardKeys:Vector.<uint> = Vector.<uint>([Keyboard.UP,Keyboard.W]);
      
      public static var backKeys:Vector.<uint> = Vector.<uint>([Keyboard.DOWN,Keyboard.S]);
      
      public static var leftKeys:Vector.<uint> = Vector.<uint>([Keyboard.LEFT,Keyboard.A]);
      
      public static var rightKeys:Vector.<uint> = Vector.<uint>([Keyboard.RIGHT,Keyboard.D]);
      
      public static var fireKeys:Vector.<uint> = Vector.<uint>([Keyboard.SPACE]);
      
      public function ChassisControlKeyMap()
      {
         super();
      }
   }
}

