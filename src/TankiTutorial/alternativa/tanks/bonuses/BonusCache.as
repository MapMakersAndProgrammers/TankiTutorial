package alternativa.tanks.bonuses
{
   import alternativa.types.Long;
   import flash.utils.Dictionary;
   
   public class BonusCache
   {
      
      private static const qiwozoc:ObjectCache = new ObjectCache();
      
      private static const wykyb:ObjectCache = new ObjectCache();
      
      private static var kudu:Dictionary = new Dictionary();
      
      public function BonusCache()
      {
         super();
      }
      
      public static function isParachuteCacheEmpty() : Boolean
      {
         return qiwozoc.isEmpty();
      }
      
      public static function getParachute() : Parachute
      {
         return Parachute(qiwozoc.ObjectCache());
      }
      
      public static function putParachute(param1:Parachute) : void
      {
         qiwozoc.put(param1);
      }
      
      public static function isCordsCacheEmpty() : Boolean
      {
         return wykyb.isEmpty();
      }
      
      public static function getCords() : Cords
      {
         return Cords(wykyb.ObjectCache());
      }
      
      public static function putCords(param1:Cords) : void
      {
         wykyb.put(param1);
      }
      
      public static function isBonusMeshCacheEmpty(param1:Long) : Boolean
      {
         return getBonusMeshCache(param1).isEmpty();
      }
      
      public static function getBonusMesh(param1:Long) : BonusMesh
      {
         return BonusMesh(getBonusMeshCache(param1).ObjectCache());
      }
      
      public static function putBonusMesh(param1:BonusMesh) : void
      {
         getBonusMeshCache(param1.getObjectId()).put(param1);
      }
      
      public static function clear() : void
      {
         qiwozoc.clear();
         wykyb.clear();
         kudu = new Dictionary();
      }
      
      private static function getBonusMeshCache(param1:Long) : ObjectCache
      {
         var _loc2_:ObjectCache = kudu[param1];
         if(_loc2_ == null)
         {
            _loc2_ = new ObjectCache();
            kudu[param1] = _loc2_;
         }
         return _loc2_;
      }
   }
}

