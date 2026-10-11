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
      
      private static const localDustVelocity:Vector3 = new Vector3(100,0,0);
      
      private static const dustVelocity:Vector3 = new Vector3();
      
      private static const particlePosition:Vector3 = new Vector3();
      
      private var particleSize:Number = 0;
      
      private var animation:TextureAnimation;
      
      private var tankScales:Dictionary = new Dictionary();
      
      private var camera:GameCamera;
      
      private var nearDistance:Number;
      
      private var farDistance:Number;
      
      public var enabled:Boolean = true;
      
      private var intensity:Number;
      
      private var dustProbability:Number;
      
      public function Dust(camera:GameCamera)
      {
         super();
         this.camera = camera;
      }
      
      private static function addJitter(vector:Vector3, amount:Number) : void
      {
         vector.x += (Math.random() - 0.5) * 2 * amount;
         vector.y += (Math.random() - 0.5) * 2 * amount;
         vector.z += (Math.random() - 0.5) * 2 * amount;
      }
      
      public function init(param1:TextureAnimation, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this.animation = param1;
         this.farDistance = param2;
         this.nearDistance = param3;
         this.particleSize = param4;
         this.intensity = param5;
         this.dustProbability = param6;
      }
      
      public function addTank(tank:Tank) : void
      {
         this.tankScales[tank] = tank.boundSphereRadius / 600;
      }
      
      public function removeTank(tank:Tank) : void
      {
         delete this.tankScales[tank];
      }
      
      public function update() : void
      {
         var key:* = undefined;
         var tank:Tank = null;
         if(this.enabled && Boolean(this.camera.softTransparency) && this.camera.softTransparencyStrength > 0.01)
         {
            for(key in this.tankScales)
            {
               tank = key as Tank;
               if(tank != null && tank.getLeftTrack() != null && tank.getRightTrack() != null)
               {
                  this.addTankDust(tank,100,this.dustProbability);
               }
            }
         }
      }
      
      public function addTankDust(tank:Tank, minSpeed:Number = 100, probability:Number = 0.2) : void
      {
         var scale:Number = NaN;
         var matrix:Matrix3 = null;
         scale = Number(this.tankScales[tank]);
         var leftTrack:Track = tank.getLeftTrack();
         var rightTrack:Track = tank.getRightTrack();
         if(leftTrack.animationSpeed * rightTrack.animationSpeed < 0)
         {
            minSpeed = 5;
         }
         matrix = tank.body.orientationMatrix;
         localDustVelocity.x *= -1;
         matrix.transformVector(localDustVelocity,dustVelocity);
         this.addTrackDust(leftTrack,scale,dustVelocity,minSpeed,probability);
         localDustVelocity.x *= -1;
         matrix.transformVector(localDustVelocity,dustVelocity);
         this.addTrackDust(rightTrack,scale,dustVelocity,minSpeed,probability);
      }
      
      private function addTrackDust(track:Track, scale:Number, velocity:Vector3, minSpeed:Number, probability:Number) : void
      {
         var suspensionRay:SuspensionRay = null;
         var speed:Number = NaN;
         var strength:Number = NaN;
         var i:int = 0;
         while(i < track.numRays)
         {
            suspensionRay = track.rays[i];
            speed = Math.abs(suspensionRay.speed);
            if(speed > minSpeed && Math.random() < probability)
            {
               strength = speed > 500 ? 1 : 0.3 + speed / 712;
               particlePosition.copy(suspensionRay.getGlobalOrigin());
               addJitter(particlePosition,50);
               velocity.z = 100;
               addJitter(velocity,20);
               this.createDustParticle(scale,particlePosition,velocity,strength);
            }
            i++;
         }
      }
      
      private function createDustParticle(scale:Number, position:Vector3, velocity:Vector3, strength:Number) : void
      {
         var positionProvider:ScalingObject3DPositionProvider = null;
         var spriteEffect:LimitedDistanceAnimatedSpriteEffect = null;
         var size:Number = NaN;
         var alpha:Number = this.intensity * strength * this.camera.softTransparencyStrength;
         if(this.enabled && Boolean(this.camera.softTransparency) && alpha > 0)
         {
            positionProvider = ScalingObject3DPositionProvider(GameData.objectPool.getObject(ScalingObject3DPositionProvider));
            positionProvider.init(position,velocity,0.01);
            spriteEffect = LimitedDistanceAnimatedSpriteEffect(GameData.objectPool.getObject(LimitedDistanceAnimatedSpriteEffect));
            size = this.particleSize * scale * (1 + pame * Math.random());
            spriteEffect.init(size,size,this.animation,Math.random() * 2 * Math.PI,positionProvider,0.5,0.5,null,130,BlendMode.NORMAL,this.nearDistance,this.farDistance,alpha);
            GameData.effects.addEffect(spriteEffect);
         }
      }
   }
}

