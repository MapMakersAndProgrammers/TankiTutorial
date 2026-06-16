package alternativa.tanks.sfx
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.TanksPhysicsScene;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.vehicles.tank.Tank;
   import tutorial.EffectsManager;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class TankExplosionFactory
   {
      
      private static var gutipur:TextureAnimation;
      
      private static var pawimog:TextureAnimation;
      
      private static var bucof:TextureAnimation;
      
      private static const tilubizy:Number = 800;
      
      private static const mudova:Number = 400;
      
      private static const safybe:Number = 1000;
      
      private static const funa:Number = 600;
      
      private static const dyjedic:Number = 800;
      
      private static const juwizi:Number = 200;
      
      private static const nidowyje:Number = -2000;
      
      private static const gubeneb:int = 200;
      
      private static const wonuhig:RayHit = new RayHit();
      
      private static const position:Vector3 = new Vector3();
      
      private static const fyqynyfy:Vector3 = new Vector3();
      
      private static const zerus:Vector3 = new Vector3();
      
      private static const gijalatyt:Matrix3 = new Matrix3();
      
      private static const wova:Number = 1;
      
      private static const hobuna:EffectsManager = GameData.hobuna;
      
      private static const gov:TanksPhysicsScene = GameData.gov;
      
      private static const murow:ObjectPool = GameData.murow;
      
      private static const bec:Vector3 = new Vector3(0,0,-1);
      
      private static const zekos:Vector3 = new Vector3();
      
      public function TankExplosionFactory()
      {
         super();
      }
      
      public static function createEffect(param1:Tank) : void
      {
         var _loc2_:Number = getEffectScale(param1);
         createExplosionShockWave(param1,_loc2_);
         createExplosionFire(_loc2_);
         createExplosionSmoke(_loc2_);
      }
      
      private static function getEffectScale(param1:Tank) : Number
      {
         var _loc2_:Mesh = param1.kuca.hullMesh;
         var _loc3_:Number = _loc2_.boundMaxX - _loc2_.boundMinX;
         var _loc4_:Number = _loc2_.boundMaxY - _loc2_.boundMinY;
         var _loc5_:Number = _loc2_.boundMaxZ - _loc2_.boundMinZ;
         var _loc6_:Number = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_);
         return _loc6_ / funa;
      }
      
      private static function createExplosionShockWave(param1:Tank, param2:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Vector3 = null;
         var _loc8_:Number = NaN;
         var _loc9_:AnimatedPlaneEffect = null;
         if(pawimog == null)
         {
            pawimog = Assets.getData("tank_explosion/shockwave",TextureAnimation);
         }
         var _loc3_:Number = 500;
         position.copy(param1.hogys.body.kejo.position);
         var _loc4_:CollisionDetector = gov.kymaqos;
         if(_loc4_.raycastStatic(position,bec,255,_loc3_,null,wonuhig))
         {
            wonuhig.position.z += 10;
            _loc5_ = safybe;
            _loc6_ = 200;
            if(wonuhig.jomuc > _loc6_)
            {
               _loc5_ *= (_loc3_ - wonuhig.jomuc) / (_loc3_ - _loc6_);
            }
            _loc7_ = wonuhig.lefugefo;
            _loc8_ = Math.acos(_loc7_.z);
            zekos.x = -_loc7_.y;
            zekos.y = _loc7_.x;
            zekos.z = 0;
            zekos.normalize();
            gijalatyt.fromAxisAngle(zekos,_loc8_);
            gijalatyt.getEulerAngles(fyqynyfy);
            _loc9_ = AnimatedPlaneEffect(murow.getObject(AnimatedPlaneEffect));
            _loc9_.init(param2 * _loc5_,wonuhig.position,fyqynyfy,pawimog.fps,pawimog,wova);
            hobuna.addEffect(_loc9_);
         }
      }
      
      private static function createExplosionFire(param1:Number) : void
      {
         if(bucof == null)
         {
            bucof = Assets.getData("tank_explosion/explosion",TextureAnimation);
         }
         position.z += 50;
         var _loc2_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(murow.getObject(StaticObject3DPositionProvider));
         _loc2_.init(position,gubeneb);
         var _loc3_:AnimatedSpriteEffect = AnimatedSpriteEffect(murow.getObject(AnimatedSpriteEffect));
         var _loc4_:Number = tilubizy * param1;
         _loc3_.init(_loc4_,_loc4_,bucof,Math.random() * 2 * Math.PI,bucof.fps,_loc2_);
         hobuna.addEffect(_loc3_);
      }
      
      private static function createExplosionSmoke(param1:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:MovingObject3DPositionProvider = null;
         var _loc5_:AnimatedSpriteEffect = null;
         var _loc6_:Number = NaN;
         if(gutipur == null)
         {
            gutipur = Assets.getData("tank_explosion/smoke",TextureAnimation);
         }
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = dyjedic + Math.random() * juwizi;
            zerus.x = _loc3_ * (1 - 2 * Math.random());
            zerus.y = _loc3_ * (1 - 2 * Math.random());
            zerus.z = _loc3_ * 0.5 * (1 + Math.random());
            _loc4_ = MovingObject3DPositionProvider(murow.getObject(MovingObject3DPositionProvider));
            _loc4_.init(position,zerus,nidowyje);
            _loc5_ = AnimatedSpriteEffect(murow.getObject(AnimatedSpriteEffect));
            _loc6_ = mudova * param1;
            _loc5_.init(_loc6_,_loc6_,gutipur,Math.random() * 2 * Math.PI,gutipur.fps,_loc4_);
            hobuna.addEffect(_loc5_);
            _loc2_++;
         }
      }
   }
}

