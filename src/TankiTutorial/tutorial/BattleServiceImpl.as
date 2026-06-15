package tutorial
{
   import alternativa.tanks.battle.BattleRunner;
   import alternativa.tanks.battle.BattleScene3D;
   import alternativa.tanks.battle.BattleService;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   
   public class BattleServiceImpl implements BattleService
   {
      
      public function BattleServiceImpl()
      {
         super();
      }
      
      public function getBattleRunner() : BattleRunner
      {
         return GameData.zepymy;
      }
      
      public function getBattleScene3D() : BattleScene3D
      {
         return GameData.hyfecypi;
      }
      
      public function getObjectPool() : ObjectPool
      {
         return GameData.murow;
      }
      
      public function addSound3DEffect(param1:ISound3DEffect) : void
      {
         GameData.bijatil.addEffect(param1);
      }
   }
}

