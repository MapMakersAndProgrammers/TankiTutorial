package alternativa.tanks.battle
{
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   
   public interface BattleService
   {
      
      function getBattleRunner() : BattleRunner;
      
      function getBattleScene3D() : BattleScene3D;
      
      function getObjectPool() : ObjectPool;
      
      function addSound3DEffect(param1:ISound3DEffect) : void;
   }
}

