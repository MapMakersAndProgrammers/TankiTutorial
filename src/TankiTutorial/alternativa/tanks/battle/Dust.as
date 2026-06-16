package alternativa.tanks.battle
{
   import alternativa.tanks.vehicles.tank.physics.SuspensionRay;
   import alternativa.tanks.vehicles.tank.physics.Track;
   import flash.display.BlendMode;
   import flash.utils.Dictionary;
   import tutorial.GameData;
   import alternativa.math.Vector3;
   import alternativa.math.Matrix3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.sfx.*;
   import alternativa.tanks.vehicles.tank.Tank;
   
   public class Dust
   {
      
      private static const fapuna:Number = 0.2;
      
      private static const pame:Number = 1;
      
      private static const lesu:Vector3 = new Vector3(100,0,0);
      
      private static const mazilynu:Vector3 = new Vector3();
      
      private static const dizecoca:Vector3 = new Vector3();
      
      private var jujygiw:Number = 0;
      
      private var zeg:TextureAnimation;
      
      private var bim:Dictionary = new Dictionary();
      
      private var butefu:GameCamera;
      
      private var kyfyjyril:Number;
      
      private var ziqel:Number;
      
      public var enabled:Boolean = true;
      
      private var tywad:Number;
      
      private var zymugypu:Number;
      
      public function Dust(param1:GameCamera)
      {
         super();
         this.butefu = param1;
      }
      
      private static function addJitter(param1:Vector3, param2:Number) : void
      {
         param1.x += (Math.random() - 0.5) * 2 * param2;
         param1.y += (Math.random() - 0.5) * 2 * param2;
         param1.z += (Math.random() - 0.5) * 2 * param2;
      }
      
      public function init(param1:TextureAnimation, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this.zeg = param1;
         this.ziqel = param2;
         this.kyfyjyril = param3;
         this.jujygiw = param4;
         this.tywad = param5;
         this.zymugypu = param6;
      }
      
      public function addTank(param1:Tank) : void
      {
         this.bim[param1] = param1.fysa / 600;
      }
      
      public function removeTank(param1:Tank) : void
      {
         delete this.bim[param1];
      }
      
      public function update() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Tank = null;
         if(this.enabled && Boolean(this.butefu.softTransparency) && this.butefu.softTransparencyStrength > 0.01)
         {
            for(_loc1_ in this.bim)
            {
               _loc2_ = _loc1_ as Tank;
               if(_loc2_ != null && _loc2_.getLeftTrack() != null && _loc2_.getRightTrack() != null)
               {
                  this.addTankDust(_loc2_,100,this.zymugypu);
               }
            }
         }
      }
      
      public function addTankDust(param1:Tank, param2:Number = 100, param3:Number = 0.2) : void
      {
         var _loc4_:Number = NaN;
         var _loc7_:Matrix3 = null;
         _loc4_ = Number(this.bim[param1]);
         var _loc5_:Track = param1.getLeftTrack();
         var _loc6_:Track = param1.getRightTrack();
         if(_loc5_.zigebota * _loc6_.zigebota < 0)
         {
            param2 = 5;
         }
         _loc7_ = param1.body.jefe;
         lesu.x *= -1;
         _loc7_.transformVector(lesu,mazilynu);
         this.addTrackDust(_loc5_,_loc4_,mazilynu,param2,param3);
         lesu.x *= -1;
         _loc7_.transformVector(lesu,mazilynu);
         this.addTrackDust(_loc6_,_loc4_,mazilynu,param2,param3);
      }
      
      private function addTrackDust(param1:Track, param2:Number, param3:Vector3, param4:Number, param5:Number) : void
      {
         var _loc7_:SuspensionRay = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc6_:int = 0;
         while(_loc6_ < param1.wavi)
         {
            _loc7_ = param1.mofovoti[_loc6_];
            _loc8_ = Math.abs(_loc7_.wiciqy);
            if(_loc8_ > param4 && Math.random() < param5)
            {
               _loc9_ = _loc8_ > 500 ? 1 : 0.3 + _loc8_ / 712;
               dizecoca.copy(_loc7_.getGlobalOrigin());
               addJitter(dizecoca,50);
               param3.z = 100;
               addJitter(param3,20);
               this.createDustParticle(param2,dizecoca,param3,_loc9_);
            }
            _loc6_++;
         }
      }
      
      private function createDustParticle(param1:Number, param2:Vector3, param3:Vector3, param4:Number) : void
      {
         var _loc6_:ScalingObject3DPositionProvider = null;
         var _loc7_:LimitedDistanceAnimatedSpriteEffect = null;
         var _loc8_:Number = NaN;
         var _loc5_:Number = this.tywad * param4 * this.butefu.softTransparencyStrength;
         if(this.enabled && Boolean(this.butefu.softTransparency) && _loc5_ > 0)
         {
            _loc6_ = ScalingObject3DPositionProvider(GameData.murow.getObject(ScalingObject3DPositionProvider));
            _loc6_.init(param2,param3,0.01);
            _loc7_ = LimitedDistanceAnimatedSpriteEffect(GameData.murow.getObject(LimitedDistanceAnimatedSpriteEffect));
            _loc8_ = this.jujygiw * param1 * (1 + pame * Math.random());
            _loc7_.init(_loc8_,_loc8_,this.zeg,Math.random() * 2 * Math.PI,_loc6_,0.5,0.5,null,130,BlendMode.NORMAL,this.kyfyjyril,this.ziqel,_loc5_);
            GameData.hobuna.addEffect(_loc7_);
         }
      }
   }
}

