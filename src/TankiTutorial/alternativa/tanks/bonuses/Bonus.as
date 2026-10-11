package alternativa.tanks.bonuses
{
   import alternativa.math.Vector3;
   import alternativa.types.Long;
   
   public interface Bonus
   {
      
      function get bonusId() : Long;
      
      function spawn(position:Vector3, param2:int, fallSpeed:Number, callback:Function) : void;
      
      function pickup() : void;
      
      function remove() : void;
   }
}

