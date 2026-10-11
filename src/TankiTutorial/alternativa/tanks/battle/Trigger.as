package alternativa.tanks.battle
{
   import alternativa.physics.Body;
   
   public interface Trigger
   {
      
      function checkTrigger(body:Body) : void;
   }
}

