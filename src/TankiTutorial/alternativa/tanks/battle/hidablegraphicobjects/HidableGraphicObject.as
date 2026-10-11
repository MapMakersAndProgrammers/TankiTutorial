package alternativa.tanks.battle.hidablegraphicobjects
{
   import alternativa.math.Vector3;
   
   public interface HidableGraphicObject
   {
      
      function readPosition(result:Vector3) : void;
      
      function setAlphaMultiplier(value:Number) : void;
   }
}

