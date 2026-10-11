package alternativa.tanks.vehicles.tank.controllers
{
   import flash.ui.Keyboard;
   
   public class TurretControlKeyMap
   {
      
      private static var defaultKeyMap:TurretControlKeyMap;
      
      private static var defaultKeyLeft:int;
      
      public var leftKeys:Vector.<uint>;
      
      public var rightKeys:Vector.<uint>;
      
      public var centerKeys:Vector.<uint>;
      
      public function TurretControlKeyMap(leftKeys:Vector.<uint>, rightKeys:Vector.<uint>, centerKeys:Vector.<uint>)
      {
         super();
         this.leftKeys = leftKeys;
         this.rightKeys = rightKeys;
         this.centerKeys = centerKeys;
      }
      
      public static function initDefaultKeyMap(locale:String) : void
      {
         if(defaultKeyMap == null)
         {
            defaultKeyLeft = locale == "de" ? int(Keyboard.Y) : int(Keyboard.Z);
            defaultKeyMap = new TurretControlKeyMap(Vector.<uint>([defaultKeyLeft,Keyboard.COMMA]),Vector.<uint>([Keyboard.X,Keyboard.PERIOD]),Vector.<uint>([Keyboard.C,Keyboard.SLASH]));
         }
      }
      
      public static function getDefaultKeyLeft() : int
      {
         return defaultKeyLeft;
      }
      
      public static function getDefaultKeyMap() : TurretControlKeyMap
      {
         return defaultKeyMap;
      }
   }
}

