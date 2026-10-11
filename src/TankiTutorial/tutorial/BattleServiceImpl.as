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
         return GameData.battleRunner;
      }
      
      public function getBattleScene3D() : BattleScene3D
      {
         return GameData.battleScene;
      }
      
      public function getObjectPool() : ObjectPool
      {
         return GameData.objectPool;
      }
      
      public function addSound3DEffect(effect:ISound3DEffect) : void
      {
         GameData.soundManager.addEffect(effect);
      }
   }
}

