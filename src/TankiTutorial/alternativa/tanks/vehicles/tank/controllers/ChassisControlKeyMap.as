package alternativa.tanks.vehicles.tank.controllers
{
   import flash.ui.Keyboard;
   
   public class ChassisControlKeyMap
   {
      
      public static var zutetegyv:Vector.<uint> = Vector.<uint>([Keyboard.UP,Keyboard.W]);
      
      public static var huwumuly:Vector.<uint> = Vector.<uint>([Keyboard.DOWN,Keyboard.S]);
      
      public static var hatu:Vector.<uint> = Vector.<uint>([Keyboard.LEFT,Keyboard.A]);
      
      public static var baric:Vector.<uint> = Vector.<uint>([Keyboard.RIGHT,Keyboard.D]);
      
      public static var bacifaq:Vector.<uint> = Vector.<uint>([Keyboard.SPACE]);
      
      public function ChassisControlKeyMap()
      {
         super();
      }
   }
}

