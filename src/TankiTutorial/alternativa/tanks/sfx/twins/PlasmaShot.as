package alternativa.tanks.sfx.twins
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.physics.Body;
   import alternativa.physics.TanksPhysicsScene;
   import tutorial.EffectsManager;
   import tutorial.GameData;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.utils.MathUtils;
   import alternativa.tanks.battle.Renderer;
   import alternativa.tanks.battle.PhysicsController;
   import alternativa.tanks.battle.PhysicsInterpolator;
   import alternativa.tanks.sfx.AnimatedSprite3D;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.sfx.ExternalObject3DPositionProvider;
   import alternativa.tanks.sfx.AnimatedLightEffect;
   import alternativa.tanks.sfx.LightData;
   import alternativa.tanks.sfx.LightAnimation;
   import alternativa.tanks.sfx.AnimatedSpriteEffect;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.RenderGroup;
   import tutorial.commons.Assets;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.IRayCollisionFilter;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: this is needed to access some object3d properties
   use namespace alternativa3d;

   public class PlasmaShot extends PooledObject implements PhysicsController, PhysicsInterpolator, IRayCollisionFilter, Renderer
   {
      
      private static var mofibimap:TextureAnimation;
      
      private static var fid:TextureAnimation;
      
      public static const tezesulal:Number = 250;
      
      public static const boker:Number = 300;
      
      private static const zily:int = 1000;
      
      private static const jydihab:Number = 30;
      
      private static const fenuf:int = 8;
      
      private static const vogilyta:Number = 2 * Math.PI / fenuf;
      
      private static const gizynuzelu:Matrix3 = new Matrix3();
      
      private static const hifoca:Vector3 = new Vector3();
      
      private static const wonuhig:RayHit = new RayHit();
      
      private static const vytaf:Vector3 = new Vector3();
      
      public static const qyk:Number = 6000;
      
      public static const qulif:Number = 9000;
      
      public static const japycepef:Number = 50;
      
      private static const gov:TanksPhysicsScene = GameData.gov;
      
      private static const guzinizub:KDContainer = GameData.guzinizub;
      
      private static const murow:ObjectPool = GameData.murow;
      
      private static const hobuna:EffectsManager = GameData.hobuna;
      
      private static const jypadif:RenderGroup = GameData.jypadif;
      
      private static const neputi:Vector3 = new Vector3();
      
      private const kamog:Vector3 = new Vector3();
      
      private var taramuty:Body;
      
      private var kovi:Vector3 = new Vector3();
      
      private var vedebuweb:Number;
      
      private var jac:Boolean;
      
      private var guripovec:Vector3 = new Vector3();
      
      private var penybuke:Vector3 = new Vector3();
      
      private var fybumu:Vector3 = new Vector3();
      
      private var zeneti:Vector3 = new Vector3();
      
      private var cekyno:Vector.<Vector3>;
      
      private var ruv:Number = 0;
      
      private var wahy:AnimatedSprite3D;
      
      private var nomupiz:int;
      
      private var lamutameq:Number;
      
      private var beryfitu:Number;
      
      public var bogepulah:LightAnimation = LightData.zup;
      
      public var cilug:LightAnimation = LightData.fid;
      
      private var veliqe:AnimatedLightEffect;
      
      private var kig:ExternalObject3DPositionProvider;
      
      public function PlasmaShot(param1:Pool)
      {
         super(param1);
         this.cekyno = new Vector.<Vector3>(fenuf);
         var _loc2_:int = 0;
         while(_loc2_ < fenuf)
         {
            this.cekyno[_loc2_] = new Vector3();
            _loc2_++;
         }
         this.wahy = new AnimatedSprite3D(tezesulal,tezesulal);
      }
      
      private static function getMostOrthogonalAxis(param1:Vector3, param2:Vector3) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = 10000000000;
         var _loc5_:Number = param1.x < 0 ? -param1.x : Number(param1.x);
         if(_loc5_ < _loc4_)
         {
            _loc4_ = _loc5_;
            _loc3_ = 0;
         }
         _loc5_ = param1.y < 0 ? -param1.y : Number(param1.y);
         if(_loc5_ < _loc4_)
         {
            _loc4_ = _loc5_;
            _loc3_ = 1;
         }
         _loc5_ = param1.z < 0 ? -param1.z : Number(param1.z);
         if(_loc5_ < _loc4_)
         {
            _loc3_ = 2;
         }
         switch(_loc3_)
         {
            case 0:
               param2.x = 0;
               param2.y = param1.z;
               param2.z = -param1.y;
               break;
            case 1:
               param2.x = -param1.z;
               param2.y = 0;
               param2.z = param1.x;
               break;
            case 2:
               param2.x = param1.y;
               param2.y = -param1.x;
               param2.z = 0;
         }
      }
      
      public function init(param1:Number, param2:Number) : void
      {
         if(mofibimap == null)
         {
            mofibimap = Assets.getData("plasma",TextureAnimation);
         }
         this.vedebuweb = param1;
         this.beryfitu = param2;
         this.wahy.setAnimationData(mofibimap);
         this.nomupiz = this.wahy.getNumFrames();
         this.lamutameq = this.nomupiz * Math.random();
         this.wahy.rotation = MathUtils.qubabyby * Math.random();
         this.ruv = 0;
         this.jac = true;
      }
      
      public function addToGame(param1:Vector3, param2:Vector3, param3:Vector3, param4:Body) : void
      {
         this.fybumu.copy(param1);
         this.guripovec.copy(param2);
         this.penybuke.copy(param2);
         this.zeneti.copy(param2);
         this.wahy.x = param2.x;
         this.wahy.y = param2.y;
         this.wahy.z = param2.z;
         this.kovi.copy(param3);
         this.taramuty = param4;
         this.veliqe = AnimatedLightEffect(murow.getObject(AnimatedLightEffect));
         this.kig = ExternalObject3DPositionProvider(murow.getObject(ExternalObject3DPositionProvider));
         this.kig.setPosition(param2);
         this.veliqe.init(this.kig,this.bogepulah,AnimatedLightEffect.nimowu,true);
         hobuna.addEffect(this.veliqe);
         gov.addPhysicsController(this);
         gov.addPhysicsInterpolator(this);
         jypadif.addRenderer(this);
      }
      
      public function runBeforePhysicsUpdate(param1:Number) : void
      {
         var _loc5_:Vector3 = null;
         var _loc2_:CollisionDetector = gov.secakesem;
         if(this.jac)
         {
            if(this.processFirstTick(_loc2_))
            {
               return;
            }
            this.jac = false;
         }
         if(this.ruv > qyk)
         {
            this.destroy();
            return;
         }
         var _loc3_:Number = qulif * param1;
         this.ruv += _loc3_;
         if(_loc2_.raycast(this.guripovec,this.kovi,CollisionGroup.pisyse,_loc3_,this,wonuhig))
         {
            this.applyImpact(wonuhig.vetudozi.body,wonuhig.position,this.kovi,this.ruv);
            this.destroy();
            return;
         }
         this.kamog.copy(this.kovi).scale(_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < fenuf)
         {
            _loc5_ = this.cekyno[_loc4_];
            if(_loc2_.raycast(_loc5_,this.kovi,CollisionGroup.pisyse,_loc3_,this,wonuhig))
            {
               if(wonuhig.vetudozi.body != null)
               {
                  this.applyImpact(wonuhig.vetudozi.body,wonuhig.position,this.kovi,this.ruv);
                  this.destroy();
                  return;
               }
            }
            _loc5_.add(this.kamog);
            _loc4_++;
         }
         this.penybuke.copy(this.guripovec);
         this.guripovec.add(this.kamog);
      }
      
      public function render(param1:int, param2:int) : void
      {
         if(!this.jac && this.wahy._parent == null)
         {
            guzinizub.addChild(this.wahy);
         }
         var _loc3_:Number = param2 / zily;
         this.wahy.setFrameIndex(this.lamutameq);
         this.lamutameq += jydihab * _loc3_;
         if(this.lamutameq >= this.nomupiz)
         {
            this.lamutameq = 0;
         }
         var _loc4_:Number = tezesulal;
         this.wahy.width = _loc4_;
         this.wahy.height = _loc4_;
         this.wahy.x = this.zeneti.x;
         this.wahy.y = this.zeneti.y;
         this.wahy.z = this.zeneti.z;
         this.wahy.rotation -= 3 * _loc3_;
         this.kig.setPosition(this.zeneti);
      }
      
      public function destroy() : void
      {
         this.wahy.removeFromParent();
         this.taramuty = null;
         this.wahy.material = null;
         this.wahy.colorTransform = null;
         gov.removePhysicsController(this);
         gov.removePhysicsInterpolator(this);
         jypadif.removeRenderer(this);
         this.veliqe.kill();
         this.veliqe = null;
         this.kig = null;
         recycle();
      }
      
      public function considerBody(param1:Body) : Boolean
      {
         return this.taramuty != param1;
      }
      
      private function initRadialPoints(param1:Vector3, param2:Vector3, param3:Number) : void
      {
         getMostOrthogonalAxis(param2,vytaf);
         vytaf.normalize().scale(param3);
         gizynuzelu.fromAxisAngle(param2,vogilyta);
         Vector3(this.cekyno[0]).copy(param1).add(vytaf);
         var _loc4_:int = 1;
         while(_loc4_ < fenuf)
         {
            vytaf.transform3(gizynuzelu);
            Vector3(this.cekyno[_loc4_]).copy(param1).add(vytaf);
            _loc4_++;
         }
      }
      
      private function createExplosionEffect(param1:Vector3, param2:Number) : void
      {
         if(fid == null)
         {
            fid = Assets.getData("plasma_exp",TextureAnimation);
         }
         var _loc3_:int = 50 + boker * 0.5;
         var _loc4_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(murow.getObject(StaticObject3DPositionProvider));
         _loc4_.init(param1,_loc3_);
         var _loc5_:Number = boker * (1 + param2) / 2;
         var _loc6_:AnimatedSpriteEffect = AnimatedSpriteEffect(murow.getObject(AnimatedSpriteEffect));
         var _loc7_:int = 20;
         _loc6_.init(_loc5_,_loc5_,fid,MathUtils.qubabyby * Math.random(),_loc7_,_loc4_,0.5,0.5,null);
         hobuna.addEffect(_loc6_);
         this.createExplsionLightEffect(param1);
      }
      
      private function createExplsionLightEffect(param1:Vector3) : void
      {
         var _loc2_:int = 50 + boker * 0.5;
         var _loc3_:AnimatedLightEffect = AnimatedLightEffect(murow.getObject(AnimatedLightEffect));
         var _loc4_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(murow.getObject(StaticObject3DPositionProvider));
         _loc4_.init(param1,_loc2_);
         _loc3_.init(_loc4_,this.cilug);
         hobuna.addEffect(_loc3_);
      }
      
      private function applyImpact(param1:Body, param2:Vector3, param3:Vector3, param4:Number) : void
      {
         var _loc5_:Tank = null;
         this.createExplosionEffect(param2,1);
         if(param1 != null)
         {
            _loc5_ = param1.katuf as Tank;
            if(_loc5_ != null)
            {
               param1.addWorldForceScaled(param2,param3,this.vedebuweb);
               _loc5_.substructHealth(this.beryfitu);
            }
         }
      }
      
      private function processFirstTick(param1:CollisionDetector) : Boolean
      {
         var _loc6_:Vector3 = null;
         var _loc7_:Body = null;
         hifoca.copy(this.guripovec);
         var _loc2_:Number = japycepef;
         hifoca.z += _loc2_;
         if(param1.raycast(hifoca,Vector3.lasis,CollisionGroup.neli,_loc2_,null,wonuhig))
         {
            this.applyImpact(null,wonuhig.position,null,0);
            this.destroy();
            return true;
         }
         var _loc3_:Vector3 = neputi;
         _loc3_.diff(this.guripovec,this.fybumu);
         var _loc4_:Number = Number(_loc3_.length());
         _loc3_.normalize();
         if(param1.raycast(this.fybumu,_loc3_,CollisionGroup.deli,_loc4_,this,wonuhig))
         {
            this.fybumu.addScaled(wonuhig.jomuc,_loc3_);
            this.applyImpact(wonuhig.vetudozi.body,this.fybumu,_loc3_,0);
            this.destroy();
            return true;
         }
         this.initRadialPoints(this.fybumu,_loc3_,_loc2_);
         var _loc5_:int = 0;
         while(_loc5_ < fenuf)
         {
            _loc6_ = this.cekyno[_loc5_];
            if(param1.raycast(_loc6_,this.kovi,CollisionGroup.deli,_loc4_,this,wonuhig))
            {
               _loc7_ = wonuhig.vetudozi.body;
               if(_loc7_ != null)
               {
                  this.fybumu.addScaled(wonuhig.jomuc,_loc3_);
                  this.applyImpact(_loc7_,this.fybumu,_loc3_,0);
                  this.destroy();
                  return true;
               }
            }
            _loc5_++;
         }
         this.initRadialPoints(this.guripovec,this.kovi,_loc2_);
         return false;
      }
      
      public function interpolatePhysicsState(param1:Number) : void
      {
         this.zeneti.interpolate(param1,this.penybuke,this.guripovec);
      }
   }
}

