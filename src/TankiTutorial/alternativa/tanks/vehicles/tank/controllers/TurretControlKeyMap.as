package alternativa.tanks.vehicles.tank.controllers
{
   import flash.ui.Keyboard;
   
   public class TurretControlKeyMap
   {
      
      private static var taqino:TurretControlKeyMap;
      
      private static var kulohi:int;
      
      public var hatu:Vector.<uint>;
      
      public var baric:Vector.<uint>;
      
      public var konejohe:Vector.<uint>;
      
      public function TurretControlKeyMap(param1:Vector.<uint>, param2:Vector.<uint>, param3:Vector.<uint>)
      {
         super();
         this.hatu = param1;
         this.baric = param2;
         this.konejohe = param3;
      }
      
      public static function initDefaultKeyMap(param1:String) : void
      {
         if(taqino == null)
         {
            kulohi = param1 == "de" ? int(Keyboard.Y) : int(Keyboard.Z);
            taqino = new TurretControlKeyMap(Vector.<uint>([kulohi,Keyboard.COMMA]),Vector.<uint>([Keyboard.X,Keyboard.PERIOD]),Vector.<uint>([Keyboard.C,Keyboard.SLASH]));
         }
      }
      
      public static function getDefaultKeyLeft() : int
      {
         return kulohi;
      }
      
      public static function getDefaultKeyMap() : TurretControlKeyMap
      {
         return taqino;
      }
   }
}

